package org.onap.ccsdk.cds.blueprintsprocessor.functions.netconf.executor

import org.onap.ccsdk.cds.blueprintsprocessor.services.execution.AbstractScriptComponentFunction
import org.onap.ccsdk.cds.blueprintsprocessor.core.api.data.ExecutionServiceInput
import org.onap.ccsdk.cds.blueprintsprocessor.functions.resource.resolution.storedContentFromResolvedArtifactNB
import org.onap.ccsdk.cds.controllerblueprints.core.utils.JacksonUtils
import org.slf4j.LoggerFactory

open class ConfigDeploy : AbstractScriptComponentFunction() {

    private val log = LoggerFactory.getLogger(ConfigDeploy::class.java)!!

    override suspend fun processNB(executionRequest: ExecutionServiceInput) {
        val device = netconfDevice("netconf-connection")
        val client = device.netconfRpcService
        val session = device.netconfSession

        val payload="""
        <configuration xmlns:junos="http://xml.juniper.net/junos/17.4R1/junos">
        <system xmlns="http://yang.juniper.net/junos-qfx/conf/system">
            <host-name operation="delete" />
            <host-name operation="create">Regression-Mock</host-name>
        </system>
        </configuration>
        """

        val response: MutableMap<String, Boolean> = mutableMapOf("deploySuccess" to false)

        try {
            session.connect()
            client.lock()
            client.editConfig(payload)
            client.commit()
            client.unLock()
            session.disconnect()
            response["deploySuccess"] = true
        } catch (e: Exception) {
            e.message?.let { super.addError(it) }
        }

        super.setAttribute("response-data", JacksonUtils.jsonNodeFromObject(response))
    }

    override suspend fun recoverNB(runtimeException: RuntimeException, executionRequest: ExecutionServiceInput) {
        log.info("Executing Recovery")
    }
}
