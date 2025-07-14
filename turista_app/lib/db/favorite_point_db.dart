import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/favorite_point.dart';

class FavoritePointDatabase {
  static final FavoritePointDatabase _instance = FavoritePointDatabase._internal();
  factory FavoritePointDatabase() => _instance;
  FavoritePointDatabase._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('favorites.db');
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            lat REAL NOT NULL,
            lon REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insert(FavoritePoint point) async {
    final db = await database;
    return await db.insert('favorites', point.toMap());
  }

  Future<List<FavoritePoint>> getAllPoints() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return maps.map((map) => FavoritePoint.fromMap(map)).toList();
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
