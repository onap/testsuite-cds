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

TEST_NAME="upload-data-dict"
TEST_NUMBER=$RANDOM
REQUEST_DD_PAYLOAD_DIR="$TEST_DIRECTORY/resource-resolution/data-dict"

. ./$TEST_DIRECTORY/utils.sh

# delete useless log file
rm $FAILED_TESTS_LOG

DD_PAYLOADS=$(ls $REQUEST_DD_PAYLOAD_DIR)
for DD_PAYLOAD in $DD_PAYLOADS
do
  echo "Uploading DD : $DD_PAYLOAD"
  PAYLOAD_NAME=$(echo "$DD_PAYLOAD" | cut -d '.' -f1)
  RESPONSE_HEADERS_FILE="$RESPONSES_DIRECTORY/$TEST_NAME-$PAYLOAD_NAME-$TEST_NUMBER-response-headers"
  RESPONSE_PAYLOAD_FILE="$RESPONSES_DIRECTORY/$TEST_NAME-$PAYLOAD_NAME-$TEST_NUMBER-response-payload"
  PAYLOAD_FILE="$REQUEST_DD_PAYLOAD_DIR/$DD_PAYLOAD"
  FAILED_TESTS_LOG="$FAILED_TESTS_DIRECTORY/$TEST_NAME-$PAYLOAD_NAME-$TEST_NUMBER.log"

  # create log life
  touch $FAILED_TESTS_LOG

  upload_dd $PAYLOAD_FILE $RESPONSE_PAYLOAD_FILE $RESPONSE_HEADERS_FILE

  echo 'Assert status 200'
  assert_status_code 200 $RESPONSE_HEADERS_FILE
done
