import 'package:sqflite/sqflite.dart';
import 'package:tasks/models/task.dart';

class DBhelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "tasks";
  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = "${await getDatabasesPath()}tasks.db";
      _db =
          await openDatabase(path, version: _version, onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $_tableName("
          "id INTEGER  PRIMARY KEY AUTOINCREMENT, "
          "title TEXT, note TEXT,date TEXT, "
          "startTime TEXT,endTime TEXT, "
          "remind INTEGER,repeat TEXT, "
          "color INTEGER, "
          "isCompleted INTEGER)",
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<int> insert(Task? task) async {
    try {
      return await _db?.insert(_tableName, task!.toMap()) ?? 1;
    } catch (e) {
      return 0;
    }
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static delete(int id) async {
    await _db!.delete(_tableName, where: 'id=?', whereArgs: [id]);
  }

  static update(int id) async {
    return await _db!.rawUpdate("""
  UPDATE tasks 
  SET isCompleted = ?
  WHERE id =?
  """, [1, id]);
  }
}
