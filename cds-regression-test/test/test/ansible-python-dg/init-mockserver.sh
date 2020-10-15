#!/bin/bash

CBA_NAME="ansible-python-dg"
DIR_PAYLOADS="$TEST_DIRECTORY/$CBA_NAME/mock-payloads"


# JOB TEMPLATE
echo "Mocking Job Template route..."
JT_PAYLOAD="job-template.json"
curl -v -X PUT "http://$MOCKSERVER_URL:$MOCKSERVER_PORT/mockserver/expectation" -d "@$DIR_PAYLOADS/$JT_PAYLOAD"

# JOB TEMPLATE LAUNCH - GET
echo "Mocking Job Template Launch GET route..."
GET_JT_LAUNCH_PAYLOAD="get_job-template-launch.json"
curl -v -X PUT "http://$MOCKSERVER_URL:$MOCKSERVER_PORT/mockserver/expectation" -d "@$DIR_PAYLOADS/$GET_JT_LAUNCH_PAYLOAD"

# JOB TEMPLATE LAUNCH
echo "Mocking Inventory route..."
INVENTORY_PAYLOAD="inventory.json"
curl -v -X PUT "http://$MOCKSERVER_URL:$MOCKSERVER_PORT/mockserver/expectation" -d "@$DIR_PAYLOADS/$INVENTORY_PAYLOAD"

# JOB TEMPLATE LAUNCH - POST
echo "Mocking Job Template Launch POST route..."
POST_JT_LAUNCH_PAYLOAD="post_job-template-launch.json"
curl -v -X PUT "http://$MOCKSERVER_URL:$MOCKSERVER_PORT/mockserver/expectation" -d "@$DIR_PAYLOADS/$POST_JT_LAUNCH_PAYLOAD"

# JOB EXECUTION
echo "Mocking Job Execution route..."
JOB_EXECUTION_PAYLOAD="job-execution.json"
curl -v -X PUT "http://$MOCKSERVER_URL:$MOCKSERVER_PORT/mockserver/expectation" -d "@$DIR_PAYLOADS/$JOB_EXECUTION_PAYLOAD"

# JOB OUTPUT
echo "Mocking Job Output route..."
JOB_OUTPUT_PAYLOAD="job-output.json"
curl -v -X PUT "http://$MOCKSERVER_URL:$MOCKSERVER_PORT/mockserver/expectation" -d "@$DIR_PAYLOADS/$JOB_OUTPUT_PAYLOAD"
