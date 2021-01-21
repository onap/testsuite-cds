/*
 *  Copyright © 2020 Bell Canada.
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

import org.onap.ccsdk.cds.blueprintsprocessor.core.api.data.ExecutionServiceInput
import org.onap.ccsdk.cds.blueprintsprocessor.functions.resource.resolution.db.ResourceResolution
import org.onap.ccsdk.cds.blueprintsprocessor.functions.resource.resolution.storedContentFromResolvedArtifactNB
import org.onap.ccsdk.cds.blueprintsprocessor.functions.resource.resolution.storedResourceResolutionsNB
import org.onap.ccsdk.cds.blueprintsprocessor.services.execution.AbstractScriptComponentFunction
import org.onap.ccsdk.cds.blueprintsprocessor.services.execution.ComponentScriptExecutor
import org.onap.ccsdk.cds.controllerblueprints.core.asJsonType
import org.slf4j.LoggerFactory

open class RetrieveResolution : AbstractScriptComponentFunction() {

    private val log = LoggerFactory.getLogger(RetrieveResolution::class.java)!!
    private val OCCURENCE: Int = 1

    override suspend fun processNB(executionRequest: ExecutionServiceInput) {

        /*
         * Here resolution-key comes as part of retrieve-resolution request payload.
         */
        val resolution_key = getDynamicProperties("resolution-key").asText()
        log.info("Got the resolution_key: $resolution_key from RetrieveResolution")

        /*
         * Here artifact_name comes as part of retrieve-resolution request payload.
         */
        val artifact_name = getDynamicProperties("artifact-name").asText()
        log.info("Got the artifact_name: $artifact_name from RetrieveResolution")

        val output: List<ResourceResolution> = storedResourceResolutionsNB(resolution_key, artifact_name, OCCURENCE)
        val sortedValueOutput = output.sortedBy { it.value }.map { it -> it.value }

        val result = storedContentFromResolvedArtifactNB(resolution_key, artifact_name)
        val returnVal = mutableMapOf(
                "resolved-template" to result.asJsonType(),
                "retrieved-resolution" to mutableListOf(sortedValueOutput).asJsonType()
        ).asJsonType()

        log.info("Return Val: \n$returnVal\n")
        // Return the response.
        setAttribute(ComponentScriptExecutor.ATTRIBUTE_RESPONSE_DATA, returnVal)
    }

    override suspend fun recoverNB(runtimeException: RuntimeException, executionRequest: ExecutionServiceInput) {
        log.info("Executing Recovery")
    }
}
