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

CBA_NAME="resource-resolution"
TEST_NAME="$CBA_NAME-enrichment"
TEST_NUMBER=$RANDOM
RESPONSE_HEADERS_FILE="$RESPONSES_DIRECTORY/$TEST_NAME-$TEST_NUMBER-response-headers"

. ./$TEST_DIRECTORY/utils.sh

export MOCK_SRV="http://cds-regression-mockserver/mock-$CI_PIPELINE_ID"
CDS_DB_SVC=${CDS_DB_SVC:-"cds-db"}
export DB_URL="jdbc:mysql://${CDS_DB_SVC}:3306/sdnctl"
apply_env_to_definition $CBA_NAME

echo "Compressing CBA: $CBA_NAME"
compress_cba $CBA_NAME

echo "Enriching CBA: $CBA_NAME"
enrich_cba $CBA_NAME $RESPONSE_HEADERS_FILE

echo 'Assert status 200'
assert_status_code 200 $RESPONSE_HEADERS_FILE
