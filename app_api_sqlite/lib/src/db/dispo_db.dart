import 'package:sqflite/sqflite.dart';
import 'package:app_api_sqlite/src/db/db.dart';
import 'package:app_api_sqlite/src/models/dispo_model.dart';

class DispoDB {
  static Future<void> insert(DispoModel dispo) async {
    Database database = await Db.openDB();
    database.insert("tuti_dispo", dispo.toMap());
  }

  static Future<List<DispoModel>> all() async {
    Database database = await Db.openDB();
    final List<Map<String, dynamic>> list = await database
        .query("tuti_dispo", where: "current = ?", whereArgs: ['Y']);
    return List.generate(
        list.length,
        (i) => DispoModel(
              idDispo: list[i]['id_dispo'],
              name: list[i]['name'],
            ));
  }

  static Future<int> setCurrentStatus() async {
    Database database = await Db.openDB();
    int result =
        await database.rawUpdate("UPDATE tuti_dispo SET current = ? ", ['N']);
    return result;
  }

  static Future<void> delete(DispoModel dispo) async {
    Database database = await Db.openDB();
    database.delete("tuti_dispo",
        where: "id_dispo = ?", whereArgs: [dispo.idDispo]);
  }

  static Future<void> deleteAll() async {
    int id = 0;
    Database database = await Db.openDB();
    database.delete("tuti_dispo", where: "id_dispo > ?", whereArgs: [id]);
  }
}
