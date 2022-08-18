import 'package:sqflite/sqflite.dart';
import 'package:app_api_sqlite/src/db/db.dart';
import 'package:app_api_sqlite/src/models/dispo_item_model.dart';

class DispoItemDB {
  static Future<void> insert(DispoItemModel dispo) async {
    Database database = await Db.openDB();
    database.insert("tuti_dispo_item", dispo.toMap());
  }

  static Future<String> dateWasUpdated() async {
    Database database = await Db.openDB();
    final List<Map<String, dynamic>> list = await database.query(
        'tuti_dispo_item',
        columns: ['creation_date'],
        orderBy: "id_dispo_item DESC",
        limit: 1);

    if (list.isNotEmpty) {
      DateTime date = DateTime.parse(list[0]['creation_date']);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }

    return '';
  }

  static Future<List<Map<String, dynamic>>> search(String codItem) async {
    Database database = await Db.openDB();
    final List<Map<String, dynamic>> list = await database
        .query("tuti_dispo_item", where: "cod_item = ?", whereArgs: [codItem]);

    return List.generate(
        list.length,
        (i) => {
              'id_item': list[i]['id_dispo_item'],
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

  static Future<List<DispoItemModel>> all() async {
    Database database = await Db.openDB();
    final List<Map<String, dynamic>> list =
        await database.query("tuti_dispo_item");
    return List.generate(
        list.length,
        (i) => DispoItemModel(
              idDispoItem: list[i]['id_dispo_item'],
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

  static Future<List<DispoItemModel>> filter({required int idDipo}) async {
    try {
      Database database = await Db.openDB();
      final List<Map<String, dynamic>> list = await database.query(
          "tuti_dispo_item",
          where: 'id_dispo = ? AND current = ? ',
          whereArgs: [idDipo, 'Y']);

      if (list.isNotEmpty) {
        return List.generate(
            list.length,
            (i) => DispoItemModel(
                  idDispoItem: list[i]['id_dispo_item'],
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
      print('Exception in DispoItemDB method filter: $e');
      return [];
    }
  }

  static Future<int> setCurrentStatus() async {
    Database database = await Db.openDB();
    int result = await database
        .rawUpdate("UPDATE tuti_dispo_item SET current = ? ", ['N']);
    return result;
  }

  static Future<void> delete(DispoItemModel dispoItem) async {
    Database database = await Db.openDB();
    database.delete("tuti_dispo_item",
        where: "id_dispo_item = ?", whereArgs: [dispoItem.idDispo]);
  }

  static Future<void> deleteAll() async {
    int id = 0;
    Database database = await Db.openDB();
    database
        .delete("tuti_dispo_item", where: "id_dispo_item > ?", whereArgs: [id]);
  }
}
