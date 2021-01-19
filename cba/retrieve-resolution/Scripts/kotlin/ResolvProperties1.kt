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

open class ResolvProperties1Kt() : ResourceAssignmentProcessor() {

    override fun getName(): String {
        return "ResolvProperties1Kt"
    }

    override suspend fun processNB(resourceAssignment: ResourceAssignment) {
        ResourceAssignmentUtils.setResourceDataValue(resourceAssignment, raRuntimeService, "val1")
    }

    override suspend fun recoverNB(runtimeException: RuntimeException, resourceAssignment: ResourceAssignment) {
        raRuntimeService.getBluePrintError().addError("Failed in ResolvPropertiesKt-ResourceAssignmentProcessor : ${runtimeException.message}")
    }
}
