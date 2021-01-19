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

CBA_NAME="cli"
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
