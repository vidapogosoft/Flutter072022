import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:sqlite_ui/model/client_model.dart';

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

  //Query
  //muestra todos los clientes de la base de datos
  static Future<List<Client>> getallClients() async {
    Database database = await openDB();
    var response = await database.query("Client");
    List<Client> list = response.map((c) => Client.fromMap(c)).toList();

    return list;
  }

  //Query
  //muestro un solo cliente por el id de la base de datos
  static Future<Client?> getClientWithId(int id) async {
    Database database = await openDB();
    var response =
        await database.query("Client", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Client.fromMap(response.first) : null;
  }

  //Insert
  static addClientToDatabase(Client client) async {
    Database database = await openDB();
    var raw = await database.insert("Client", client.toMap());
    return raw;
  }

  //Delete all
  static deleteAllClient() async {
    Database database = await openDB();
    database.delete("Client");
  }

  //Update
  static updateClient(Client client) async {
    Database database = await openDB();
    var response = await database.update("Client", client.toMap(),
        where: "id = ?", whereArgs: [client.id]);
    return response;
  }

  //Delete with id
  static deleteClientWithId(int id) async {
    Database database = await openDB();
    return database.delete("Client", where: "id = ?", whereArgs: [id]);
  }
}
