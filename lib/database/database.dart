import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'audio_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE audio (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertAudio(Map<String, dynamic> audio) async {
    Database db = await database;
    return await db.insert('audio', audio);
  }

  Future<List<Map<String, dynamic>>> getAudioList() async {
    Database db = await database;
    return await db.query('audio');
  }
}
