/*
 *  Copyright © 2019 IBM, Bell Canada.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package cli

import org.onap.ccsdk.cds.controllerblueprints.core.logger
import org.onap.ccsdk.cds.blueprintsprocessor.core.api.data.ExecutionServiceInput
import org.onap.ccsdk.cds.blueprintsprocessor.functions.cli.executor.cliDeviceInfo
import org.onap.ccsdk.cds.blueprintsprocessor.functions.cli.executor.getSshClientService
import org.onap.ccsdk.cds.blueprintsprocessor.services.execution.AbstractScriptComponentFunction
import org.onap.ccsdk.cds.blueprintsprocessor.services.execution.ComponentScriptExecutor
import org.onap.ccsdk.cds.controllerblueprints.core.asJsonPrimitive
import org.onap.ccsdk.cds.controllerblueprints.core.utils.JacksonUtils


open class CliRegressionTest : AbstractScriptComponentFunction() {

    private val log = logger(CliRegressionTest::class)

    override suspend fun processNB(executionRequest: ExecutionServiceInput) {
        // Get Client Service
        val sshClientService = getSshClientService(cliDeviceInfo("device-properties"))
		sshClientService.startSession()
 		
        // Read Commands
        val timeout = bluePrintRuntimeService.getInputValue("connectionTimeOut").asText()
        val commands = bluePrintRuntimeService.getInputValue("commands")
            .let { JacksonUtils.getListFromJsonNode(it, String::class.java) }

        // Execute
        var responsesLog = "Error"
        try {
            responsesLog = sshClientService.executeCommands(commands, timeout.toLong())
            log.info(responsesLog)
        } catch (e: Exception) {
            e.message?.let { addError(it) }
        } finally {
            setAttribute(ComponentScriptExecutor.ATTRIBUTE_RESPONSE_DATA, responsesLog.asJsonPrimitive())
            sshClientService.closeSession()
        }
    }

    override suspend fun recoverNB(runtimeException: RuntimeException, executionRequest: ExecutionServiceInput) {
        log.info("Executing Recovery")
    }
}