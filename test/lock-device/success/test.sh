#!/bin/bash
#
# Copyright (C) 2020 Bell Canada.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

CBA_NAME="lock-device"
TEST_NAME="success"
TEST_NUMBER=$RANDOM
mkdir -p "$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/"

. ./$TEST_DIRECTORY/utils.sh

echo "Running test: $CBA_NAME:$TEST_NUMBER:$TEST_NAME"


# Request 1: Acquire lock and run for 30 sec
# Sleep 5 - ensure req 1 is processed before req 2
# Request 2: Wait for lock 10 sec then time out
# Sleep 60 - lock should have been released after this time
# Request 3: Acquire lock and run for 30 sec
# Sleep 5 - ensure req 3 is processed before req 4
# Request 4: Wait for lock 10 sec then time out
delays=(0 5 60 5 0)

for i in `seq 1 4`
do
    echo "Sending request $i"
    RESPONSE_HEADERS_FILE="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-headers-$i"
    RESPONSE_PAYLOAD_FILE="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-payload-$i"
    REQUEST_PAYLOAD_FILE="$TEST_DIRECTORY/$CBA_NAME/$TEST_NAME/request-payloads/request-payload-$i.json"

    process_cba $REQUEST_PAYLOAD_FILE $RESPONSE_PAYLOAD_FILE $RESPONSE_HEADERS_FILE &
    pids[${i}]=$!
    sleep ${delays[$i]}
done

echo "Waiting for responses - pids: ${pids[*]}"
for pid in ${pids[*]}
do
    echo "Waiting for pid $pid"
    wait $pid
done

for i in `seq 1 4`
do
    echo "Assert payload - request $i"
    RESPONSE_PAYLOAD_FILE="$RESPONSES_DIRECTORY/$CBA_NAME/$TEST_NAME/$TEST_NUMBER/response-payload-$i"
    EXPECTED_PAYLOAD_FILE="$TEST_DIRECTORY/$CBA_NAME/$TEST_NAME/expected-payloads/expected-payload-$i.json"
    assert_cds_response_equals $EXPECTED_PAYLOAD_FILE $RESPONSE_PAYLOAD_FILE
done
