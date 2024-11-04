import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:lack_off_debug_logs/lock_off_dio_log_intercpetor.dart';

late Dio dio;

class DioUtil {
  factory DioUtil() => _getInstance();

  DioUtil._internal() {
    initDio();
  }
  // 单例模式
  static DioUtil? _instance;

  static DioUtil get instance => _getInstance();

  static DioUtil _getInstance() {
    _instance ??= DioUtil._internal();
    return _instance!;
  }

  void get() {
    dio.get('https://pub.dev/packages/lack_off_debug_logs');
  }

  void initDio() {
    dio = Dio();
    dio.options.sendTimeout = 15000;
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 60000;

    dio.httpClientAdapter = DefaultHttpClientAdapter();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };

    dio.interceptors.add(
      PrettyDioLogger(
        request: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
  }
}
