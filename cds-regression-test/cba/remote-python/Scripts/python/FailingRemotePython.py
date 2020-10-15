#!/usr/bin/python

import sys
from cds_utils.payload_coder import send_response_data_payload

if __name__ == "__main__":
    try:
        raise Exception("Intentionally raised exception!")
    except Exception as e:
        print("Intentionally raised exception!")
        resp_data = {
            "errorMessage": "Intentionally raised exception!"
        }
        send_response_data_payload(resp_data)
    sys.exit(1)
