#!/bin/bash

CBA_NAME="lock-device"
TEST_NAME="success"
TEST_NUMBER=$RANDOM
mkdir -p "$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/"

. ./$TEST_DIRECTORY/utils.sh

echo "Running test: $CBA_NAME:$TEST_NUMBER:$TEST_NAME"

for i in `seq 1 4`
do
    echo "Sending request $i"
    RESPONSE_HEADERS_FILE="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-headers-$i"
    RESPONSE_PAYLOAD_FILE="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-payload-$i"
    REQUEST_PAYLOAD_FILE="$TEST_DIRECTORY/$CBA_NAME/$TEST_NAME/request-payloads/request-payload-$i.json"

    process_cba $REQUEST_PAYLOAD_FILE $RESPONSE_PAYLOAD_FILE $RESPONSE_HEADERS_FILE &
    pids[${i}]=$!
    sleep 3
done

echo "Waiting for responses"
for pid in ${pids[*]}
do
    wait $pid
done

echo "Assert payload - request 1"
RESPONSE_PAYLOAD_FILE="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-payload-1"
EXPECTED_PAYLOAD_FILE="$TEST_DIRECTORY/$CBA_NAME/$TEST_NAME/expected-payloads/expected-payload-1.json"
assert_cds_response_equals $EXPECTED_PAYLOAD_FILE $RESPONSE_PAYLOAD_FILE

echo "Assert payload - request 2"
RESPONSE_PAYLOAD_FILE="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-payload-2"
EXPECTED_PAYLOAD_FILE="$TEST_DIRECTORY/$CBA_NAME/$TEST_NAME/expected-payloads/expected-payload-2.json"
assert_cds_response_equals $EXPECTED_PAYLOAD_FILE $RESPONSE_PAYLOAD_FILE

echo "Assert payload - request 3"
RESPONSE_PAYLOAD_FILE="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-payload-3"
EXPECTED_PAYLOAD_FILE="$TEST_DIRECTORY/$CBA_NAME/$TEST_NAME/expected-payloads/expected-payload-3.json"
assert_cds_response_equals $EXPECTED_PAYLOAD_FILE $RESPONSE_PAYLOAD_FILE

echo "Assert payload - request 4"
RESPONSE_PAYLOAD_FILE="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-payload-4"
EXPECTED_PAYLOAD_FILE="$TEST_DIRECTORY/$CBA_NAME/$TEST_NAME/expected-payloads/expected-payload-4.json"
assert_cds_response_equals $EXPECTED_PAYLOAD_FILE $RESPONSE_PAYLOAD_FILE
