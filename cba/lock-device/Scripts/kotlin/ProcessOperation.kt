/*
 *  Copyright © 2019 Bell Canada.
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

package cba.cds.RT

import org.onap.ccsdk.cds.controllerblueprints.core.logger
import org.onap.ccsdk.cds.blueprintsprocessor.core.api.data.ExecutionServiceInput
import org.onap.ccsdk.cds.blueprintsprocessor.services.execution.AbstractScriptComponentFunction
import org.onap.ccsdk.cds.blueprintsprocessor.services.execution.ComponentScriptExecutor
import org.onap.ccsdk.cds.controllerblueprints.core.asJsonType
import org.onap.ccsdk.cds.blueprintsprocessor.rest.service.BasicAuthRestClientService
import org.onap.ccsdk.cds.blueprintsprocessor.rest.BasicAuthRestClientProperties
import kotlinx.coroutines.delay

open class ProcessOperation : AbstractScriptComponentFunction() {

    private val log = logger(ProcessOperation::class)

    override suspend fun processNB(executionRequest: ExecutionServiceInput) {
        val time : Long = 30_000
        try {
            log.info("Processing for $time ms... ${executionRequest.commonHeader.requestId}")
            delay(time)
            log.info("Done processing ${executionRequest.commonHeader.requestId}!")
            setAttribute(ComponentScriptExecutor.ATTRIBUTE_RESPONSE_DATA, "Success: ${executionRequest.commonHeader.requestId}".asJsonType())
        } catch (e: Exception) {
            e.message?.let { addError(it) }
        }
    }

    override suspend fun recoverNB(runtimeException: RuntimeException, executionRequest: ExecutionServiceInput) {
        setAttribute(ComponentScriptExecutor.ATTRIBUTE_RESPONSE_DATA, runtimeException.message!!.asJsonType())
        addError(runtimeException.message!!)
        log.info("Executing Recovery")
    }
}
