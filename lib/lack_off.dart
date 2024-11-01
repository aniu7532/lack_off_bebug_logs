import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lack_off_debug_logs/lack_off_app_exception_util.dart';
import 'package:lack_off_debug_logs/lack_off_floating_window.dart';
import 'package:lack_off_debug_logs/lack_off_bean.dart';
import 'package:lack_off_debug_logs/lack_off_log_database.dart';

class LackOff {
  static void initialize(
    Widget app,
  ) async {
    /// 加载本地日志
    await loadLogsFromDb();

    /// 异常捕获
    AppCatchError.run(app);
  }

  static void showLackOffButton(
    BuildContext context,
  ) {
    LackOffFloatingWindow.show(context);
  }

  static final List<LackOffBean> _logs = [];
  static final StreamController<List<LackOffBean>> _logController =
      StreamController.broadcast();

  // 获取日志的 Stream
  static Stream<List<LackOffBean>> get logStream => _logController.stream;

  static void addLog(LackOffBean log) async {
    _logs.insert(0, log);
    _logController.add(List.from(_logs)); // 发送更新
    if (true) {
      //是否缓存日志
      // 缓存日志到本地数据库
      await LogDatabaseHelper().insertLog(log);
    }
  }

  // 获取所有日志
  static List<LackOffBean> getLogs() => List.from(_logs);

  // 清理 StreamController
  static void dispose() {
    _logController.close();
  }

  // 按日期范围获取日志
  static Future<void> fetchLogsByDate(String startDate, String endDate) async {
    final dbLogs =
        await LogDatabaseHelper().fetchLogsByDate(startDate, endDate);
    _logs
      ..clear()
      ..addAll(dbLogs);
    _logController.add(List.from(_logs)); // 更新 Stream 数据
  }

  // 从数据库中加载日志并添加到内存
  static Future<void> loadLogsFromDb() async {
    final dbLogs = await LogDatabaseHelper().fetchAllLogs();
    _logs
      ..clear()
      ..addAll(dbLogs);
    _logController.add(List.from(_logs));
  }
}
