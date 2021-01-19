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

CBA_NAME="netconf"
LANG="jython"
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
