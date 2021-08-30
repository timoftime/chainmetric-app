package network.chainmetric.talos.controllers

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import plugins.Plugins;
import plugins.VaultConfig

class AuthVault(sdk: hyperledger.SDK) : MethodChannel.MethodCallHandler {
    private val plugin = Plugins.newAuthVault(sdk)

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            when (call.method) {
                "init" -> try {
                    val config = VaultConfig()
                    config.address = call.argument("address")
                    config.defaultToken = call.argument("default_token")
                    plugin.init(config)
                    withContext(Dispatchers.Main) {
                        result.success()
                    }
                } catch (e: Exception) {
                    withContext(Dispatchers.Main) {
                        result.error("AuthVault_init", e.message, null)
                    }
                }
                "authenticate" -> try {
                    plugin.authenticate(call.argument("orgID"), call.argument("path"),
                            call.argument("token"))
                    withContext(Dispatchers.Main) {
                        result.success()
                    }
                } catch (e: Exception) {
                    withContext(Dispatchers.Main) {
                        result.error("AuthVault_authenticate", e.message, null)
                    }
                }
                else -> throw IllegalStateException("Invalid operation: ${call.method}")
            }
        }
    }
}