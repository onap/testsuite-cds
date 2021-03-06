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

import logging
from blueprints_grpc import executor_utils
from blueprints_grpc.blueprint_processing_server import AbstractScriptFunction
import json
from google.protobuf import json_format

class HelloWorld(AbstractScriptFunction):
    def __init__(self):
        self.logger = logging.getLogger(self.__class__.__name__)

    def process(self, execution_request):
        self.logger.info("Request Received in Script : {}".format(execution_request))

        inputs = json_format.MessageToJson(execution_request.payload)
        response_payload_json = json.loads(inputs)

        execution_response = executor_utils.success_response(execution_request, response_payload_json, 200)
        self.logger.info("Response returned : {}".format(execution_response))
        yield execution_response

    def recover(self, runtime_exception, execution_request):  # Ignore PyLintBear (W0613)
        return None

    def send_notification(self, execution_request):
        yield executor_utils.send_notification(execution_request, "I am notification")
