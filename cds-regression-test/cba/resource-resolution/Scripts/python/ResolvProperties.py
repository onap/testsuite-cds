#  Copyright (c) 2019 IBM, Bell Canada.
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
from abstract_ra_processor import AbstractRAProcessor
from blueprint_constants import *

class ResolvProperties(AbstractRAProcessor):

    def process(self, resource_assignment):

        resource_assignment_names = ["v_python","j_python"]
        script_value = "undefined"

        try:
            if resource_assignment.name in resource_assignment_names :
                script_value = "ok"
            # set value for resource getting currently resolved
            self.set_resource_data_value(resource_assignment, script_value)
        except JavaException, err:
          log.error("Java Exception in the script {}", err)
          self.set_resource_data_value(resource_assignment, "ERROR")
        except Exception, err:
          log.error("Python Exception in the script {}", err)
          self.set_resource_data_value(resource_assignment, "ERROR")
        return None

    def recover(self, runtime_exception, resource_assignment):
        log.error("Exception in the script {}", runtime_exception)
        print self.addError(runtime_exception.cause.message)
        return None
