import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

void main() {
  initProxy();
}

initProxy() async {
  Dio dio = Dio();
  MethodChannel channel = const MethodChannel('com.muzi.http.proxy');
  Future<String?> getHost = channel.invokeMethod('getProxyHost');
  Future<String?> getPort = channel.invokeMethod('getProxyPort');
  var result = await Future.wait([getHost, getPort]);
  if (result.length == 2 &&
      result[0] != null &&
      result[0]!.isNotEmpty &&
      result[1] != null &&
      result[1]!.isNotEmpty) {
    String host = result[0].toString();
    String port = result[1].toString();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.findProxy = (uri) {
        return 'PROXY $host:$port';
      };
    };
  }
}
