#!/bin/bash
CBA_NAME="netconf"
TEST_NAME="$CBA_NAME-upload"
TEST_NUMBER=$RANDOM
RESPONSE_HEADERS_FILE="$RESPONSES_DIRECTORY/$TEST_NAME-$TEST_NUMBER-response-headers"
RESPONSE_PAYLOAD_FILE="$RESPONSES_DIRECTORY/$TEST_NAME-$TEST_NUMBER-response-payload"
REQUEST_PAYLOAD_FILE="$TEST_DIRECTORY/$CBA_NAME/dummy-request-payload.json"

. ./$TEST_DIRECTORY/utils.sh

echo "Uploading CBA: $CBA_NAME"
upload_cba $CBA_NAME $RESPONSE_PAYLOAD_FILE $RESPONSE_HEADERS_FILE

echo 'Assert status 200'
assert_status_code 200 $RESPONSE_HEADERS_FILE

# This step prevents a race-condition for parallel process requests 
# when cba has not yet been written to filesystem 
echo 'Send process request to force CDS to load CBA to filesystem'
process_cba $REQUEST_PAYLOAD_FILE '/dev/null' '/dev/null'
