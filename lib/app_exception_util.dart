import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lack_off_debug_logs/lack_floating_button.dart';
import 'package:lack_off_debug_logs/lack_off.dart';

///
/// 全局异常的捕捉
///
class AppCatchError {
  static run(Widget app) {
    ///Flutter 框架异常
    FlutterError.onError = (FlutterErrorDetails details) async {
      ///线上环境
      if (kReleaseMode) {
        //开发期间 print
        FlutterError.dumpErrorToConsole(details);
      } else {
        LackOff.addLog({
          'type': '1',
          'message': details.exception.toString(),
          'stack': details.stack.toString(),
          'date': DateTime.now().toString(),
        });
      }
    };

    runZonedGuarded(() {
      //受保护的代码块
      runApp(app);
    }, (Object error, StackTrace stack) {
      debugPrint('AppCatchError>>>>>>>>>>: $kReleaseMode'); //是否是 Release版本
      debugPrint('AppCatchError message:$error,stack$stack');
      LackOff.addLog(
        {
          'type': '2',
          'message': error.toString(),
          'stack': stack.toString(),
          'date': DateTime.now().toString(),
        },
      );
      LackFloatingButton.refresh();
    });
  }
}
