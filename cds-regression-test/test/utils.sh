#ssert_status_code()!/bin/bash
FAILED_TESTS_LOG="$FAILED_TESTS_DIRECTORY/$TEST_NAME-$RANDOM.log"

touch $FAILED_TESTS_LOG

# ------------------------------------------------------------------
#                             CDS API
# ------------------------------------------------------------------
CDS_AUTHORIZATION="Basic Y2NzZGthcHBzOmNjc2RrYXBwcw=="
AUTHORIZATION_HEADER="Authorization: $CDS_AUTHORIZATION"
CONTENT_TYPE_FORM_DATA="Content-Type: multipart/form-data"
CONTENT_TYPE_APPLICATION_JSON="Content-Type: application/json"
BOOTSTRAP_ENDPOINT="api/v1/blueprint-model/bootstrap"

# Input Arguments:
#  1. CBA name
compress_cba() {
  pushd $CBA_DIRECTORY/$1
  zip -r ../$1.zip .
  popd
}

 # Input Arguments:
 #  1. CBA name
compress_cba_versioned() {
  pushd "$CBA_DIRECTORY/$1/$CDS_VERSION"
  zip -r ../../$1.zip .
  popd
}

# Sends CBA to CDS for enrichment
#
# Input Arguments:
#   1. CBA name
#   2. filepath for response header output
enrich_cba() {
    curl -vs http://$CDS_URL_REGRESSION_TEST:$RUNTIME_PORT/$ENRICH_URI \
        -H "$CONTENT_TYPE_FORM_DATA" \
        -H "$AUTHORIZATION_HEADER" \
        -F file="@$CBA_DIRECTORY/$1.zip" \
        -o "$CBA_ENRICHED_FOLDER/$1.zip" \
        2> $2
}

# Uploads CBA to CDS
#
# Input Arguments:
#   1. CBA name
#   2. filepath for response payload output
#   3. filepath for response header output
upload_cba() {
  if [ "${CDS_VERSION} " == "elalto " ]; then
    UPLOAD_ENDPOINT=${UPLOAD_URI_ELALTO}
  else
    UPLOAD_ENDPOINT=${UPLOAD_URI_FRANKFURT}
  fi
    curl -vs http://$CDS_URL_REGRESSION_TEST:$RUNTIME_PORT/${UPLOAD_ENDPOINT} \
        -H "$CONTENT_TYPE_FORM_DATA" \
        -H "$AUTHORIZATION_HEADER" \
        -F file="@$CBA_ENRICHED_FOLDER/$1.zip" \
        > $2 \
        2> $3
}

# Uploads DD to CDS
#
# Input Arguments:
#   1. filepath for request payload json file
#   2. filepath for response payload output
#   3. filepath for response header output
upload_dd() {
    curl -vs http://$CDS_URL_REGRESSION_TEST:$RUNTIME_PORT/$LOAD_DATA_DICT \
        -H "$CONTENT_TYPE_APPLICATION_JSON" \
        -H "$AUTHORIZATION_HEADER" \
        --data "@$1" \
        >$2 \
        2> $3
}

# Sends process request to CDS
#
# Input Arguments:
#   1. filepath for request payload json file
#   2. filepath for response payload output
#   3. filepath for response header output
process_cba() {
    curl -vs http://$CDS_URL_REGRESSION_TEST:$RUNTIME_PORT/$PROCESS_URI \
        -H "$CONTENT_TYPE_APPLICATION_JSON" \
        -H "$AUTHORIZATION_HEADER" \
        --data "@$1" \
        >$2 \
        2> $3
}

# Bootstrap CDS request (Frankfurt and up)
# Input arguments:
#   1. filepath for response payload output
#   2. filepath for response header output
bootstrap_cds() {
  curl -vs http://$CDS_URL_REGRESSION_TEST:$RUNTIME_PORT/${BOOTSTRAP_ENDPOINT} \
    -H "$CONTENT_TYPE_APPLICATION_JSON" \
    -H "$AUTHORIZATION_HEADER" \
    --data-raw '{
 	"loadModelType" : true,
	"loadResourceDictionary" : true,
	"loadCBA" : false
}'>$1 2>$2

}

# ------------------------------------------------------------------
#                       Blueprint modifications
# ------------------------------------------------------------------


# Sets a value in the definition json file
# Input arguments
#   1: CBA name
#   1: jq path for value to be set
#   2: value
definition_set_value() {
  local BLUEPRINT_DEFINITION_FILE=`grep "Entry" $CBA_DIRECTORY/$1/TOSCA-Metadata/TOSCA.meta|awk '{ print $2 }'`
  local TEMPFILE=`mktemp`
  jq "$2=$3" < $CBA_DIRECTORY/$1/$BLUEPRINT_DEFINITION_FILE > $TEMPFILE
  mv $TEMPFILE $CBA_DIRECTORY/$1/$BLUEPRINT_DEFINITION_FILE
}

# Makes environment variables available for json templating using jq path
# example template { "cds-version": .CDS_VERSION } - will populate value CDS_VERSION from env
# Input arguments
#  1: template file
apply_env_to_json_template() {
  local TEMPFILE=`mktemp`
  jq -n env|jq -f $1 > $TEMPFILE
  mv $TEMPFILE $1
}

# ------------------------------------------------------------------
#                          Assert Functions
# ------------------------------------------------------------------

match() {
  local input="$(cat)"
  local m="$(grep -o "$1" <<<"$input")"
  test "$m" || tee -a $FAILED_TESTS_LOG <<EOF
--------------------------------------------------------------------
TEST: $TEST_NAME
match

expected: $1
got:
$input

--------------------------------------------------------------------
EOF
}

# Asserts that 2 json files are equal
#
# Input arguments:
#   1: filepath for expected json
#   2: filepath for actual json
assert_json_equals() {
  local res=`diff <(jq -S < $1) <(jq -S < $2)`
  if [ "$res" ]
    then
      tee -a $FAILED_TESTS_LOG <<EOF
--------------------------------------------------------------------
TEST: $TEST_NAME
assert_json_equals

diff:
$res


--------------------------------------------------------------------
EOF
  fi
}

# Asserts specific json property in provided file
#
# Input arguments:
#  1: jq filter for property, eg. .status.eventType
#  2: expected property value
#  3: filepath for jsonfile to assert
assert_json_property_equals() {
  local prop=`jq "$1" <$3`
  [ $prop = "$2" ] || tee -a $FAILED_TESTS_LOG <<EOF
--------------------------------------------------------------------
TEST: $TEST_NAME
assert_json_property_equals

expected: $2
got: $prop

--------------------------------------------------------------------
EOF
}

# Asserts CDS response payload, ignores timestamps
#
# Input arguments:
#  1. filepath for exepected payload
#  2. filepath for received payload
assert_cds_response_equals() {
  EXPECTED=`mktemp`
  ACTUAL=`mktemp`
  #remove timestamps and correlationUUID
  jq 'del(.correlationUUID,.[].timestamp?)' < $1 > $EXPECTED
  jq 'del(.correlationUUID,.[].timestamp?)' < $2 > $ACTUAL
  assert_json_equals $EXPECTED $ACTUAL
}

# Asserts response status code
#
# Input arguments:
#  1. expected response code, eg. 200
#  2. filepath for response header file

assert_status_code() { match "^< HTTP/.* $1 " < $2; }

# Asserts respones status code (CDS version-dependent)
# For elalto, we look for the code as returned by the query,
# but not elalto (frankfurt and onward,) we look for json return object .status.code
# Input arguments:
#  1. expected response code, eg. 200
#  2. filepath for response header file
#  2. filepath for response payload file
assert_status_code_versioned() {
  if [ "${CDS_VERSION}" == "elalto" ]; then
    match "^< HTTP/.* $1 " < $2;
  else
    assert_json_property_equals '.status.code' $1 $3
  fi
}

exit_on_errors() {
  if [ -s $FAILED_TESTS_LOG ]
    then exit 1
  fi
}
