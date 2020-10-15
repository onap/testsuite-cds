#!/bin/bash
TEST_NUMBER=$RANDOM
RESPONSE_HEADERS_FILE="$RESPONSES_DIRECTORY/reset-mockserver-$TEST_NUMBER-response-headers"

. ./$TEST_DIRECTORY/utils.sh

echo "Reset mockserver - $TEST_NUMBER"
curl -v -X PUT "http://$MOCKSERVER_URL:$MOCKSERVER_PORT/mockserver/reset" > /dev/null 2> $RESPONSE_HEADERS_FILE
echo 'Assert status 200'
assert_status_code 200 $RESPONSE_HEADERS_FILE
