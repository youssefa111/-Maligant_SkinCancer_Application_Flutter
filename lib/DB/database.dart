import 'package:gp/models/history.dart';
import 'package:gp/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDataBase {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'appDatabase.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''
          CREATE TABLE users(
            user_id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT ,
            password TEXT ,
            confirmPassword ,
            age INTEGER ,
            gendar TEXT,
            photo TEXT
            )
          ''',
        );

        await database.execute(
          '''
          CREATE TABLE userHistory(
            history_id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            date TEXT,
            result TEXT,
            picture TEXT,
            FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
            )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<int> insertUser(User user) async {
    int result = 0;
    final Database db = await initializeDB();

    result = await db.insert('users', user.toMap());

    return result;
  }

  Future<List<User>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object>> queryResult = await db.query('users');
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  Future<void> deleteUser(int id) async {
    final db = await initializeDB();
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> insertHistory(History history) async {
    int result = 0;
    final Database db = await initializeDB();

    result = await db.insert('userHistory', history.toMap());

    return result;
  }

  Future<List<History>> retrieveHistorys() async {
    final Database db = await initializeDB();
    final List<Map<String, Object>> queryResult = await db.query('userHistory');
    var result = queryResult.map((e) => History.fromMap(e)).toList();
    return result;
  }

  Future<void> deleteHistory(int id) async {
    final db = await initializeDB();
    await db.delete(
      'userHistory',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
