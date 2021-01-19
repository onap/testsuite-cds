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

# Starting from Frankfurt CDS release, we need to bootstrap on the first execution.

# bootstrap files output filenames
RESPONSE_HEADERS_FILE="$RESPONSES_DIRECTORY/bootstrap-response-headers"
RESPONSE_PAYLOAD_FILE="$RESPONSES_DIRECTORY/bootstrap-response-payload"

echo "Bootstrapping CDS"
. ./$TEST_DIRECTORY/utils.sh
bootstrap_cds ${RESPONSE_PAYLOAD_FILE} ${RESPONSE_HEADERS_FILE}
echo "DEBUG::: RESPONSE_HEADERS_FILE: ${RESPONSE_HEADERS_FILE}"
cat ${RESPONSE_HEADERS_FILE}
echo "DEBUG::: RESPONSE_PAYLOAD_FILE: ${RESPONSE_PAYLOAD_FILE}"
cat ${RESPONSE_PAYLOAD_FILE}
assert_status_code 200 ${RESPONSE_HEADERS_FILE}
