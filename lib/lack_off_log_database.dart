import 'dart:async';

import 'package:lack_off_debug_logs/lack_off_bean.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LogDatabaseHelper {
  factory LogDatabaseHelper() => _instance;

  LogDatabaseHelper._internal();
  static final LogDatabaseHelper _instance = LogDatabaseHelper._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'logs.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            logType TEXT,
            logTitle TEXT,
            logDetail TEXT,
            date TEXT,
            updated  TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertLog(LackOffBean log) async {
    final db = await database;
    await db.insert(
      'logs',
      log.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LackOffBean>> fetchAllLogs() async {
    final db = await database;
    final List<Map<String, dynamic>> logs =
        await db.query('logs', orderBy: "date DESC");
    return logs.map((log) => LackOffBean.fromJson(log)).toList();
  }

  Future<List<LackOffBean>> fetchLogsByDate(
      String startDate, String endDate) async {
    final db = await database;
    final List<Map<String, dynamic>> logs = await db.query(
      'logs',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
      orderBy: "date DESC",
    );
    return logs.map((log) => LackOffBean.fromJson(log)).toList();
  }

  Future<void> clearLogs() async {
    final db = await database;
    await db.delete('logs');
  }

  Future<void> close() async {
    final db = await _database;
    db?.close();
  }
}
