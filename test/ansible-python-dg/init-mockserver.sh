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
. ./$TEST_DIRECTORY/utils.sh

CBA_NAME="ansible-python-dg"
DIR_PAYLOADS="$TEST_DIRECTORY/$CBA_NAME/mock-payloads"

OP=expectation
if [[ $1 == rm ]]; then
  OP=clear
fi

# JOB TEMPLATE
echo "Mocking Job Template route..."
export PATH_JT_PAYLOAD="/mock-$CI_PIPELINE_ID/ansible-python-dg/success/api/v2/job_templates/hello_world_job_template/"
JT_PAYLOAD="$DIR_PAYLOADS/job-template.json"
apply_env_to_json_template $JT_PAYLOAD
curl -vLk -X PUT "http://$CLUSTER_IP:$MOCKSERVER_NODEPORT/mockserver/$OP" -d "@$JT_PAYLOAD"

# JOB TEMPLATE LAUNCH - GET
echo "Mocking Job Template Launch GET route..."
export PATH_GET_JT_LAUNCH_PAYLOAD="/mock-$CI_PIPELINE_ID/ansible-python-dg/success/api/v2/job_templates/123/launch/"
GET_JT_LAUNCH_PAYLOAD="$DIR_PAYLOADS/get_job-template-launch.json"
apply_env_to_json_template $GET_JT_LAUNCH_PAYLOAD
curl -vLk -X PUT "http://$CLUSTER_IP:$MOCKSERVER_NODEPORT/mockserver/$OP" -d "@$GET_JT_LAUNCH_PAYLOAD"

# JOB TEMPLATE LAUNCH
echo "Mocking Inventory route..."
export PATH_INVENTORY="/mock-$CI_PIPELINE_ID/ansible-python-dg/success/api/v2/inventories/"
INVENTORY_PAYLOAD="$DIR_PAYLOADS/inventory.json"
apply_env_to_json_template $INVENTORY_PAYLOAD
curl -vLk -X PUT "http://$CLUSTER_IP:$MOCKSERVER_NODEPORT/mockserver/$OP" -d "@$INVENTORY_PAYLOAD"

# JOB TEMPLATE LAUNCH - POST
echo "Mocking Job Template Launch POST route..."
export PATH_POST_JT_LAUNCH_PAYLOAD="/mock-$CI_PIPELINE_ID/ansible-python-dg/success/api/v2/job_templates/123/launch/"
POST_JT_LAUNCH_PAYLOAD="$DIR_PAYLOADS/post_job-template-launch.json"
apply_env_to_json_template $POST_JT_LAUNCH_PAYLOAD
curl -vLk -X PUT "http://$CLUSTER_IP:$MOCKSERVER_NODEPORT/mockserver/$OP" -d "@$POST_JT_LAUNCH_PAYLOAD"

# JOB EXECUTION
echo "Mocking Job Execution route..."
export PATH_JOB_EXECUTION_PAYLOAD="/mock-$CI_PIPELINE_ID/ansible-python-dg/success/api/v2/jobs/456/"
JOB_EXECUTION_PAYLOAD="$DIR_PAYLOADS/job-execution.json"
apply_env_to_json_template $JOB_EXECUTION_PAYLOAD
curl -vLk -X PUT "http://$CLUSTER_IP:$MOCKSERVER_NODEPORT/mockserver/$OP" -d "@$JOB_EXECUTION_PAYLOAD"

# JOB OUTPUT
echo "Mocking Job Output route..."
export PATH_JOB_OUTPUT_PAYLOAD="/mock-$CI_PIPELINE_ID/ansible-python-dg/success/api/v2/jobs/456/stdout/"
JOB_OUTPUT_PAYLOAD="$DIR_PAYLOADS/job-output.json"
apply_env_to_json_template $JOB_OUTPUT_PAYLOAD
curl -vLk -X PUT "http://$CLUSTER_IP:$MOCKSERVER_NODEPORT/mockserver/$OP" -d "@$JOB_OUTPUT_PAYLOAD"
