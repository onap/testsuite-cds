#!/bin/bash
CBA_NAME="cli"
TEST_NAME="command-fail"
TEST_NUMBER=$RANDOM

mkdir -p "$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/"
RESPONSE_HEADERS_FILE="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-headers"
RESPONSE_PAYLOAD_FILE="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-payload"

RESOURCES_DIR="$TEST_DIRECTORY/$CBA_NAME/$TEST_NAME/resources/$CDS_VERSION"
REQUEST_PAYLOAD_FILE="$RESOURCES_DIR/request-payload.json"
EXPECTED_PAYLOAD_FILE="$RESOURCES_DIR/expected-response.json"

. ./$TEST_DIRECTORY/utils.sh

echo "Running test: $CBA_NAME:$TEST_NUMBER:$TEST_NAME"

echo 'Calling CDS process'
process_cba $REQUEST_PAYLOAD_FILE $RESPONSE_PAYLOAD_FILE $RESPONSE_HEADERS_FILE

if [ "${CDS_VERSION} " == "elalto " ]; then
  echo 'Assert statuscode 500'
  assert_status_code 500 $RESPONSE_HEADERS_FILE
else
  echo 'Assert statuscode 200'
  assert_status_code 200 $RESPONSE_HEADERS_FILE
fi

echo 'Assert payload'
assert_cds_response_equals $EXPECTED_PAYLOAD_FILE $RESPONSE_PAYLOAD_FILE
