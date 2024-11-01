import 'package:lack_off_debug_logs/lack_off_log_type.dart';

class LackOffBean {
  LogType logType;
  String logTitle;
  String logDetail;
  String date;
  bool updated;

  LackOffBean({
    required this.logType,
    required this.logTitle,
    required this.logDetail,
    required this.date,
    this.updated = false,
  });

  String _logTypeToString(LogType type) {
    return type.toString().split('.').last;
  }

  LogType _stringToLogType(String type) {
    return LogType.values
        .firstWhere((e) => e.toString().split('.').last == type);
  }

  Map<String, dynamic> toJson() {
    return {
      'logType': _logTypeToString(logType),
      'logTitle': logTitle,
      'logDetail': logDetail,
      'date': date,
      'updated': updated,
    };
  }

  factory LackOffBean.fromJson(Map<String, dynamic> json) {
    return LackOffBean(
      logType: LogType.values
          .firstWhere((e) => e.toString().split('.').last == json['logType']),
      logTitle: json['logTitle'] as String,
      logDetail: json['logDetail'] as String,
      date: json['date'] as String,
      updated: json['updated'] as bool,
    );
  }

  @override
  String toString() {
    return 'LackOffBean(logType: $logType, logTitle: $logTitle, logDetail: $logDetail, date: $date, updated: $updated)';
  }
}
