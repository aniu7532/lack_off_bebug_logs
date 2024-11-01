import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lack_off_debug_logs/lack_off_floating_window.dart';
import 'package:lack_off_debug_logs/lack_off.dart';
import 'package:lack_off_debug_logs/lack_off_bean.dart';
import 'package:lack_off_debug_logs/lack_off_log_type.dart';

///
/// 全局异常的捕捉
///
class AppCatchError {
  static run(Widget app) {
    ///主要用于捕获 Flutter 框架内部抛出的未处理异常，比如在 widget 树构建过程中或事件处理期间出现的异常。
    FlutterError.onError = (FlutterErrorDetails details) async {
      ///线上环境
      if (kReleaseMode) {
        //开发期间 print
        FlutterError.dumpErrorToConsole(details);
      } else {
        LackOff.addLog(LackOffBean(
          logType: LogType.flutterRuntime,
          logTitle: details.exception.toString(),
          logDetail: details.stack.toString(),
          date: DateTime.now().toString(),
        ));
      }
    };

    ///runZonedGuarded 用于捕获 Dart 异步任务中的异常，不仅限于 Flutter 框架，还包括自定义的 Dart 异步操作。例如网络请求、数据库操作、定时器等异步代码中的异常都可以被捕获。
    runZonedGuarded(() {
      runApp(app);
    }, (Object error, StackTrace stack) {
      debugPrint('AppCatchError message:$error,stack$stack');
      LackOff.addLog(LackOffBean(
        logType: LogType.dartRuntime,
        logTitle: error.toString(),
        logDetail: stack.toString(),
        date: DateTime.now().toString(),
      ));
      LackOffFloatingWindow.refresh();
    });
  }
}
