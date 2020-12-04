#!/bin/bash
if [ "${CDS_VERSION} " == "elalto " ]; then
  echo "Skipping, not available in elalto"
  return 0
fi

CBA_NAME="lock-device"
TEST_NAME="$CBA_NAME-enrichment"
TEST_NUMBER=$RANDOM
RESPONSE_HEADERS_FILE="$RESPONSES_DIRECTORY/$TEST_NAME-$TEST_NUMBER-response-headers"

. ./$TEST_DIRECTORY/utils.sh

echo "Compressing CBA: $CBA_NAME"
compress_cba $CBA_NAME

echo "Enriching CBA: $CBA_NAME"
enrich_cba $CBA_NAME $RESPONSE_HEADERS_FILE

echo 'Assert status 200'
assert_status_code 200 $RESPONSE_HEADERS_FILE
