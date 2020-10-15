#!/bin/bash
# Starting from Frankfurt CDS release, we need to bootstrap on the first execution.

# bootstrap files output filenames
RESPONSE_HEADERS_FILE="$RESPONSES_DIRECTORY/bootstrap-response-headers"
RESPONSE_PAYLOAD_FILE="$RESPONSES_DIRECTORY/bootstrap-response-payload"

if [ ${CDS_VERSION} == "elalto" ]; then
  echo "Skipping bootstrap for elalto release"
else
  echo "Bootstrapping CDS"
  . ./$TEST_DIRECTORY/utils.sh
  bootstrap_cds ${RESPONSE_PAYLOAD_FILE} ${RESPONSE_HEADERS_FILE}
  echo "DEBUG::: RESPONSE_HEADERS_FILE: ${RESPONSE_HEADERS_FILE}"
  cat ${RESPONSE_HEADERS_FILE}
  echo "DEBUG::: RESPONSE_PAYLOAD_FILE: ${RESPONSE_PAYLOAD_FILE}"
  cat ${RESPONSE_PAYLOAD_FILE}
  assert_status_code 200 ${RESPONSE_HEADERS_FILE}
fi
