#!/usr/bin/python

import sys
from cds_utils.payload_coder import send_response_data_payload

def echo(arg):
    print(arg)

if __name__ == "__main__":
    echo(sys.argv[1])
    resp_data = {"abc": ["xyz", "qqq"]}
    send_response_data_payload(resp_data)
    sys.exit(0)
