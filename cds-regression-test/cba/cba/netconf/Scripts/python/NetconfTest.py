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
import netconf_constant
from java.lang import Exception as JavaException
from netconfclient import NetconfClient
import json
from org.onap.ccsdk.cds.blueprintsprocessor.services.execution import AbstractScriptComponentFunction

class NetconfTest(AbstractScriptComponentFunction):

    def process(self):
        log = globals()[netconf_constant.SERVICE_LOG]
        payload="""
        <configuration xmlns:junos="http://xml.juniper.net/junos/17.4R1/junos">
        <system xmlns="http://yang.juniper.net/junos-qfx/conf/system">
            <host-name operation="delete" />
            <host-name operation="create">Regression-Mock</host-name>
        </system>
        </configuration>
        """
        responsePayload = '{"deploySuccess": false}'
        print(responsePayload)

        try:
            nc = NetconfClient(log, self, "netconf-connection")
            nc.connect()
            nc.lock()
            nc.edit_config(message_content=payload, config_target="candidate")
            operationResponse = nc.commit()
            nc.unlock()
            nc.disconnect()
            responsePayload = json.dumps({"deploySuccess": operationResponse.isSuccess()})
        except JavaException as err:
            self.addError(err.message)
        except Exception as err:
            self.addError("Python error: {}".format(err))

        # self.setAttribute("response-data", ObjectMapper().readTree(responsePayload))
        return None

    def recover(self):
        return None
