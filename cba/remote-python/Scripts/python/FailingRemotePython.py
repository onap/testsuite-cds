#!/usr/bin/python
#
#  Copyright © 2020 Bell Canada.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

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
