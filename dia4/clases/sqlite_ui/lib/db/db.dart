import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Db {
  static Future<String> getPathDb() async {
    String path = join(await getDatabasesPath(), 'db_ui.db');
    return path;
  }

  static deleteDataBase() async {
    String path = await getPathDb();
    await deleteDatabase(path);
  }

  static Future<Database> openDB() async {
    String path = await getPathDb();
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "id integer primary key AUTOINCREMENT,"
          "name TEXT,"
          "phone TEXT"
          ")");
    });
    return database;
  }
}
