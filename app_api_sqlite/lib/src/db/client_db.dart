import 'package:sqflite/sqflite.dart';
import 'package:app_api_sqlite/src/db/db.dart';
import 'package:app_api_sqlite/src/models/client_model.dart';

class ClientDB {
  static Future<void> insert(ClientModel client) async {
    Database database = await Db.openDB();
    database.insert("tuti_client", client.toMap());
  }

  static Future<bool> exist(
      {required int idClient, required String codStore}) async {
    Database database = await Db.openDB();
    final List<Map<String, dynamic>> list = await database.query('tuti_client',
        where: 'id_client = ? and cod_store = ?',
        whereArgs: [idClient, codStore]);
    return list.isNotEmpty ? true : false;
  }

  static Future<List<ClientModel>> first() async {
    Database database = await Db.openDB();
    final List<Map<String, dynamic>> list =
        await database.query('tuti_client', limit: 1);

    return List.generate(
        list.length,
        (i) => ClientModel(
            idClient: list[i]['id_client'],
            name: list[i]['name'],
            codStore: list[i]['cod_store'],
            monthlySale: list[i]['monthly_sale'],
            daysMonth: list[i]['days_month']));
  }

  static Future<List<ClientModel>> all() async {
    Database database = await Db.openDB();
    final List<Map<String, dynamic>> list = await database.query('tuti_client');

    return List.generate(
        list.length,
        (i) => ClientModel(
            idClient: list[i]['id_client'],
            name: list[i]['name'],
            codStore: list[i]['cod_store'],
            monthlySale: list[i]['monthly_sale'],
            daysMonth: list[i]['days_month']));
  }

  static Future<void> delete(ClientModel client) async {
    Database database = await Db.openDB();
    database.delete('tuti_client',
        where: "id_client = ?", whereArgs: [client.idClient]);
  }
}
