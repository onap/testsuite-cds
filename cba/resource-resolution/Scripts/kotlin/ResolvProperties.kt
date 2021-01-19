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

import org.onap.ccsdk.cds.blueprintsprocessor.functions.resource.resolution.processor.ResourceAssignmentProcessor
import org.onap.ccsdk.cds.blueprintsprocessor.functions.resource.resolution.utils.ResourceAssignmentUtils
import org.onap.ccsdk.cds.controllerblueprints.core.BluePrintProcessorException
import org.onap.ccsdk.cds.controllerblueprints.resource.dict.ResourceAssignment
import org.slf4j.LoggerFactory

open class ResolvPropertiesKt() : ResourceAssignmentProcessor() {

    private val log = LoggerFactory.getLogger(ResolvPropertiesKt::class.java)!!

    override fun getName(): String {
        return "ResolvPropertiesKt"
    }

    override suspend fun processNB(resourceAssignment: ResourceAssignment) {

        var retValue = "undefined"
        val resourceAssignmentNames = listOf<String>("j_kotlin","v_kotlin")

        try {
            if(resourceAssignment.name == "from_suspend_function") {
              retValue = getResolvedValue(resourceAssignment)
            }
            if(resourceAssignmentNames.contains(resourceAssignment.name)) {
              retValue = "ok"
            }
            ResourceAssignmentUtils.setResourceDataValue(resourceAssignment, raRuntimeService, retValue)

        } catch (e: Exception) {
            log.error(e.message, e)
            ResourceAssignmentUtils.setResourceDataValue(resourceAssignment, raRuntimeService, "ERROR")

            throw BluePrintProcessorException("Failed in template key ($resourceAssignment) assignments, cause: ${e.message}", e)
        }
    }

    /*
     * CCSDK-2150 : https://jira.onap.org/browse/CCSDK-2150
     */
    suspend fun getResolvedValue(resourceAssignment: ResourceAssignment): String {
      return "ok"
    }

    override suspend fun recoverNB(runtimeException: RuntimeException, resourceAssignment: ResourceAssignment) {
        raRuntimeService.getBluePrintError().addError("Failed in ResolvPropertiesKt-ResourceAssignmentProcessor : ${runtimeException.message}")
    }
}
