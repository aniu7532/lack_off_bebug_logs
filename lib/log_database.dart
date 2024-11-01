import 'dart:async';

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
            type TEXT,
            message TEXT,
            stack TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertLog(Map<String, dynamic> log) async {
    final db = await database;
    await db.insert(
      'logs',
      log,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchAllLogs() async {
    final db = await database;
    return await db.query('logs', orderBy: "date DESC");
  }

  Future<List<Map<String, dynamic>>> fetchLogsByDate(
      String startDate, String endDate) async {
    final db = await database;
    return await db.query(
      'logs',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
      orderBy: "date DESC",
    );
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
