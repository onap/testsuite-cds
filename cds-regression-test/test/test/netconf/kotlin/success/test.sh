#!/bin/bash

CBA_NAME="netconf"
LANG="kotlin"
TEST_NAME="success"
TEST_NUMBER=$RANDOM

mkdir -p "$RESPONSES_DIRECTORY/$CBA_NAME/$LANG/$TEST_NAME/$TEST_NUMBER/"
RESPONSE_HEADERS_FILE="$RESPONSES_DIRECTORY/$CBA_NAME/$LANG/$TEST_NAME/$TEST_NUMBER/response-headers"
RESPONSE_PAYLOAD_FILE="$RESPONSES_DIRECTORY/$CBA_NAME/$LANG/$TEST_NAME/$TEST_NUMBER/response-payload"

REQUEST_PAYLOAD_FILE="$TEST_DIRECTORY/$CBA_NAME/$LANG/$TEST_NAME/request-payload.json"
EXPECTED_PAYLOAD_FILE="$TEST_DIRECTORY/$CBA_NAME/$LANG/$TEST_NAME/expected-response.json"

. ./$TEST_DIRECTORY/utils.sh

echo "Running test: $CBA_NAME:$TEST_NUMBER:$TEST_NAME"

echo 'Calling CDS process'
process_cba $REQUEST_PAYLOAD_FILE $RESPONSE_PAYLOAD_FILE $RESPONSE_HEADERS_FILE

echo 'Assert statuscode 200'
assert_status_code 200 $RESPONSE_HEADERS_FILE

echo 'Assert payload'
assert_cds_response_equals $EXPECTED_PAYLOAD_FILE $RESPONSE_PAYLOAD_FILE