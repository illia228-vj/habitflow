import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/habit.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'habits.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        frequency TEXT NOT NULL,
        isFavorite INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        completedDates TEXT
      )
    ''');
  }

  Future<int> insertHabit(Habit habit) async {
    final db = await database;
    final map = habit.toMap();
    map['completedDates'] = jsonEncode(
        habit.completedDates.map((e) => e.toIso8601String()).toList());
    return await db.insert('habits', map);
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await database;
    final map = habit.toMap();
    map['completedDates'] = jsonEncode(
        habit.completedDates.map((e) => e.toIso8601String()).toList());
    return await db.update(
      'habits',
      map,
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    final db = await database;
    return await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Habit>> getAllHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return maps.map((map) {
      final datesJson = map['completedDates'] as String?;
      List<DateTime> dates = [];
      if (datesJson != null && datesJson.isNotEmpty) {
        try {
          final List<dynamic> decoded = jsonDecode(datesJson);
          dates = decoded.map((e) => DateTime.parse(e as String)).toList();
        } catch (_) {}
      }
      return Habit(
        id: map['id'] as int?,
        name: map['name'] as String,
        category: map['category'] as String,
        description: (map['description'] as String?) ?? '',
        frequency: map['frequency'] as String,
        isFavorite: (map['isFavorite'] as int) == 1,
        createdAt: DateTime.parse(map['createdAt'] as String),
        completedDates: dates,
      );
    }).toList();
  }

  Future<Habit?> getHabitById(int id) async {
    final db = await database;
    final maps = await db.query('habits', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    final map = maps.first;
    final datesJson = map['completedDates'] as String?;
    List<DateTime> dates = [];
    if (datesJson != null && datesJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(datesJson);
        dates = decoded.map((e) => DateTime.parse(e as String)).toList();
      } catch (_) {}
    }
    return Habit(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String,
      description: (map['description'] as String?) ?? '',
      frequency: map['frequency'] as String,
      isFavorite: (map['isFavorite'] as int) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
      completedDates: dates,
    );
  }
}
