import 'package:sqflite/sqflite.dart';
import 'package:app_api_sqlite/src/db/db.dart';
import 'package:app_api_sqlite/src/models/dispo_test_model.dart';

class DispoTestDB {
  static Future<int> insert(DispoTestModel dispo) async {
    Database database = await Db.openDB();
    int idInserted = await database.insert("tuti_dispo_test", dispo.toMap());
    return idInserted;
  }

  static Future<List<Map<String, dynamic>>> search(String codItem) async {
    Database database = await Db.openDB();
    final List<Map<String, dynamic>> list = await database
        .query("tuti_dispo_test", where: "cod_item = ?", whereArgs: [codItem]);

    return List.generate(
        list.length,
        (i) => {
              'id_item': list[i]['id_dispo_test'],
              'cod_store': list[i]['cod_store'],
              'cod_item': list[i]['cod_item'],
              'description': list[i]['description'],
              'uxc': list[i]['uxc'],
              'pallet': list[i]['pallet'],
              'sales_ratio': list[i]['sales_ratio'],
              'price': list[i]['price'],
              'id_dispo': list[i]['id_dispo'],
              'frequency': list[i]['frequency'],
              'current': list[i]['current'],
              'creation_date': list[i]['creation_date'],
            });
  }

  static Future<List<DispoTestModel>> all() async {
    Database database = await Db.openDB();
    final List<Map<String, dynamic>> list =
        await database.query("tuti_dispo_test");
    return List.generate(
        list.length,
        (i) => DispoTestModel(
              idDispoTest: list[i]['id_dispo_test'],
              codStore: list[i]['cod_store'],
              codItem: list[i]['cod_item'],
              description: list[i]['description'],
              uxc: list[i]['uxc'],
              pallet: list[i]['pallet'],
              salesRatio: list[i]['sales_ratio'],
              price: list[i]['price'],
              idDispo: list[i]['id_dispo'],
              frequency: list[i]['frequency'],
              current: list[i]['current'],
              creationDate: list[i]['creation_date'],
            ));
  }

  static Future<List<DispoTestModel>> filter({required String codStore}) async {
    try {
      Database database = await Db.openDB();
      final List<Map<String, dynamic>> list = await database.query(
          "tuti_dispo_test",
          where: 'cod_store = ? AND current = ? ',
          whereArgs: [codStore, 'Y']);

      if (list.isNotEmpty) {
        return List.generate(
            list.length,
            (i) => DispoTestModel(
                  idDispoTest: list[i]['id_dispo_test'],
                  codStore: list[i]['cod_store'],
                  codItem: list[i]['cod_item'],
                  description: list[i]['description'],
                  uxc: list[i]['uxc'],
                  pallet: list[i]['pallet'],
                  salesRatio: list[i]['sales_ratio'],
                  price: list[i]['price'],
                  idDispo: list[i]['id_dispo'],
                  frequency: list[i]['frequency'],
                  current: list[i]['current'],
                  creationDate: list[i]['creation_date'],
                ));
      }
      return [];
    } catch (e) {
      // ignore: avoid_print
      print('Exception in DispoTestDB method filter: $e');
      return [];
    }
  }

  static Future<int> setCurrentStatus() async {
    Database database = await Db.openDB();
    int result = await database
        .rawUpdate("UPDATE tuti_dispo_test SET current = ? ", ['N']);
    return result;
  }

  static Future<void> delete(DispoTestModel dispoItem) async {
    Database database = await Db.openDB();
    database.delete("tuti_dispo_test",
        where: "id_dispo_test = ?", whereArgs: [dispoItem.idDispo]);
  }

  static Future<void> deleteAll() async {
    int id = 0;
    Database database = await Db.openDB();
    database
        .delete("tuti_dispo_test", where: "id_dispo_test > ?", whereArgs: [id]);
  }
}
