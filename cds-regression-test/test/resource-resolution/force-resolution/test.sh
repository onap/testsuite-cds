#!/bin/bash

CBA_NAME="resource-resolution"
TEST_NAME="force-resolution"
TEST_NUMBER=$RANDOM

REQUEST_PAYLOAD_DIR="request-payloads"
EXPECTED_PAYLOAD_DIR="expected-payloads"

mkdir -p "$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/"
RESPONSE_HEADERS_FILE_1="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-headers-1"
RESPONSE_PAYLOAD_FILE_1="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-payload-1"
REQUEST_PAYLOAD_FILE_1="$TEST_DIRECTORY/$CBA_NAME/$TEST_NAME/$REQUEST_PAYLOAD_DIR/request-payload-1.json"
EXPECTED_PAYLOAD_FILE_1="$TEST_DIRECTORY/$CBA_NAME/$TEST_NAME/$EXPECTED_PAYLOAD_DIR/expected-response-1.json"

RESPONSE_HEADERS_FILE_2="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-headers-2"
RESPONSE_PAYLOAD_FILE_2="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-payload-2"
REQUEST_PAYLOAD_FILE_2="$TEST_DIRECTORY/$CBA_NAME/$TEST_NAME/$REQUEST_PAYLOAD_DIR/request-payload-2.json"
EXPECTED_PAYLOAD_FILE_2="$TEST_DIRECTORY/$CBA_NAME/$TEST_NAME/$EXPECTED_PAYLOAD_DIR/expected-response-2.json"

. ./$TEST_DIRECTORY/utils.sh

echo "Running test: $CBA_NAME:$TEST_NUMBER:$TEST_NAME"
echo "Running initial ressource-resolution to resolve template..."
process_cba $REQUEST_PAYLOAD_FILE_1 $RESPONSE_PAYLOAD_FILE_1 $RESPONSE_HEADERS_FILE_1

echo 'Assert statuscode'
assert_status_code 200 $RESPONSE_HEADERS_FILE_1

echo 'Assert payload'
assert_cds_response_equals $EXPECTED_PAYLOAD_FILE_1 $RESPONSE_PAYLOAD_FILE_1


# Verify force-resolution
## Same resolution-key, different input values from above test.
## Force-resolution is enabled in the CBA so we shouldn't get the same resolved template as above.
echo "Running the same ressource-resolution but with different inputs..."
process_cba $REQUEST_PAYLOAD_FILE_2 $RESPONSE_PAYLOAD_FILE_2 $RESPONSE_HEADERS_FILE_2

echo 'Assert statuscode'
assert_status_code 200 $RESPONSE_HEADERS_FILE_2

echo 'Assert payload'
assert_cds_response_equals $EXPECTED_PAYLOAD_FILE_2 $RESPONSE_PAYLOAD_FILE_2
