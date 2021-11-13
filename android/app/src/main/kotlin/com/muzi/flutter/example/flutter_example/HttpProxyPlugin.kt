package com.muzi.flutter.example.flutter_example

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class HttpProxyPlugin(messenger: BinaryMessenger): MethodChannel.MethodCallHandler {

    private var channel: MethodChannel? = null

    init {
        channel = MethodChannel(messenger, "com.muzi.http.proxy")
        channel?.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getProxyHost" -> result.success(getProxyHost())
            "getProxyPort" -> result.success(getProxyPort())
        }
    }

    private fun getProxyHost(): String? {
        return System.getProperty("http.proxyHost")
    }

    private fun getProxyPort(): String? {
        return System.getProperty("http.proxyPort")
    }
}
