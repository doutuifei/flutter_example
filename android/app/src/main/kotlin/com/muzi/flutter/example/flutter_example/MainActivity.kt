package com.muzi.flutter.example.flutter_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        HttpProxyPlugin(flutterEngine.dartExecutor.binaryMessenger)
    }

}
