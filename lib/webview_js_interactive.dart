import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text(
          "JS交互",
          textDirection: TextDirection.ltr,
        )),
        body: const Web(),
      ),
    );
  }
}

class Web extends StatefulWidget {
  const Web({Key? key}) : super(key: key);

  @override
  _WebState createState() => _WebState();
}

class _WebState extends State<Web> {
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    String url = "";
    if (Platform.isAndroid) {
      url = "file:///android_asset/flutter_assets/assets/index.html";
    } else if (Platform.isIOS) {
      url = "file://Frameworks/App.framework/flutter_assets/assets/index.html";
    }

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            if (_controller != null) {
              _controller!
                  .runJavascriptReturningResult(
                      "flutterCallJsMethod('Flutter调用了JS')")
                  .then((value) {
                Fluttertoast.showToast(msg: value.toString());
              });
            }
          },
          child: Text("点击Flutter调用JS有返回值"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller != null) {
              _controller!
                  .runJavascript("flutterCallJsMethodNoResult('Flutter调用了JS')");
            }
          },
          child: Text("点击Flutter调用JS无返回值"),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Flexible(
            child: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: {
            JavascriptChannel(
                name: "toast",
                onMessageReceived: (message) {
                  Fluttertoast.showToast(msg: message.message.toString());
                }),
            JavascriptChannel(
                name: "jscomm",
                onMessageReceived: (message) {
                  Fluttertoast.showToast(msg: message.message.toString());
                }),
          },
          onWebViewCreated: (controller) {
            _controller = controller;
          },
        ))
      ],
    );
  }
}
