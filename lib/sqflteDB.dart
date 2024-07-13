import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class database {
  static Database? _database;
  Future<Database?> get db async {
    if (_database == null) {
      _database = await CreateDb();
      return _database;
    } else {
      return _database;
    }
  }

  CreateDb() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');
    Database database = (await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
      onUpgrade: _onUpgrade,
    )) as Database;
    return database;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("db upgraded");
  }

  _createDb(Database db, int version) async {
    await db.execute('''
            CREATE TABLE tasks (
              id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)
            ''').then((value) {
      print("table created");
    }).catchError((error) {
      print("error creating table$error");
    });
  }
}
