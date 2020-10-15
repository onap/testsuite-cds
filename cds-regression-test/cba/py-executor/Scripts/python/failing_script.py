#!/usr/bin/python
#
#  Copyright © 2018-2019 AT&T Intellectual Property.
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

import logging
from blueprints_grpc import executor_utils
from blueprints_grpc.blueprint_processing_server import AbstractScriptFunction


class FailingScript(AbstractScriptFunction):
    def __init__(self):
        self.logger = logging.getLogger(self.__class__.__name__)

    def process(self, execution_request):
        self.logger.info("Request Received in Script : {}".format(execution_request))
        raise RuntimeError('Script raised an exception')

    def recover(self):
        return None

    def send_notification(self, execution_request):
        yield executor_utils.send_notification(execution_request, "I am notification")
