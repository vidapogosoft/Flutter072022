import 'package:sqflite/sqflite.dart';
import 'package:app_api_sqlite/src/class/utils.dart';
import 'package:app_api_sqlite/src/db/db.dart';
import 'package:app_api_sqlite/src/db/session_db.dart';
import 'package:app_api_sqlite/src/models/order_model.dart';

class OrderDB {
  static Future<int> currentOrder() async {
    Database database = await Db.openDB();
    Map<String, dynamic> map = await SessionDB.currentSession();

    if (map['status'] == 'success') {
      String codStore = map['client']['cod_store'];

      List<Map<String, dynamic>> list = await database.query('tuti_order',
          columns: ['id_order'],
          where: "cod_store = ? AND send = 'N' AND status = 'A' ",
          whereArgs: [codStore]);

      if (list.isNotEmpty) {
        return list[0]['id_order'];
      }
    }
    return 0;
  }

  static Future<bool> existOrder({required int idOrder}) async {
    try {
      Database database = await Db.openDB();
      Map<String, dynamic> map = await SessionDB.currentSession();
      String codStore = map['client']['cod_store'];

      final List<Map<String, dynamic>> list = await database.query("tuti_order",
          where: "id_order = ? AND cod_store = ?",
          whereArgs: [idOrder, codStore]);

      if (list.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('Exception in OrderDB method existOrder: $e');
      return false;
    }
  }

  static Future<List<OrderModel>> all() async {
    Database database = await Db.openDB();
    Map<String, dynamic> map = await SessionDB.currentSession();

    if (map['status'] == 'success') {
      String codStore = map['client']['cod_store'];
      final List<Map<String, dynamic>> list = await database.query("tuti_order",
          where: "cod_store = ? AND send = 'N' AND status = 'A' ",
          whereArgs: [codStore]);

      return List.generate(
          list.length,
          (i) => OrderModel(
              idOrder: list[i]['id_order'],
              codStore: list[i]['cod_store'],
              send: list[i]['send'],
              status: list[i]['status'],
              creationDate: list[i]['creation_date'],
              sendDate: list[i]['send_date'] ?? ''));
    }
    return [];
  }

  static Future<int> createOrder() async {
    try {
      Map<String, dynamic> map = await SessionDB.currentSession();
      int idInserted = 0;
      if (map['status'] == 'success') {
        String codStore = map['client']['cod_store'];
        String creationDate = Utils.strDateTime();
        Database database = await Db.openDB();
        idInserted = await database.rawInsert(
            "INSERT INTO tuti_order(cod_store, creation_date) VALUES(?,?)",
            [codStore, creationDate]);
      }
      return idInserted;
    } catch (e) {
      // ignore: avoid_print
      print('Exception in OrderDB method createOrder: $e');
      return 0;
    }
  }

  static Future<int> insert(
      {required int idOrder,
      required String codStore,
      String send = 'N'}) async {
    try {
      int idInserted = 0;
      String creationDate = Utils.strDateTime();
      Database database = await Db.openDB();
      idInserted = await database.rawInsert(
          "INSERT INTO tuti_order(id_order, cod_store, send, creation_date) VALUES(?,?,?,?)",
          [idOrder, codStore, send, creationDate]);
      return idInserted;
    } catch (e) {
      // ignore: avoid_print
      print('Exception in OrderDB insert: $e');
      return 0;
    }
  }

  static Future<List<Map<String, dynamic>>> getNotSendOrder() async {
    Map<String, dynamic> map = await SessionDB.currentSession();
    if (map['status'] == 'success') {
      String codStore = map['client']['cod_store'];
      Database database = await Db.openDB();
      String sql = """
        SELECT torder.id_order, torder.send, oi.id_order_item, oi.id_dispo, oi.sku, di.description, oi.amount, oi.observacion,
        torder.creation_date
        FROM tuti_order as torder
        JOIN tuti_order_item as oi ON oi.id_order = torder.id_order
        JOIN tuti_dispo_item as di ON di.cod_item = oi.sku
        WHERE torder.cod_store = ? AND torder.send = ? AND torder.status = ? AND oi.status = ?
        GROUP BY torder.id_order, oi.id_order_item, oi.id_dispo, oi.sku, di.description, oi.amount, torder.creation_date
        UNION ALL
        SELECT torder.id_order, torder.send, oi.id_order_item, oi.id_dispo, oi.sku, dt.description, oi.amount, oi.observacion,
        torder.creation_date
        FROM tuti_order as torder
        JOIN tuti_order_item as oi ON oi.id_order = torder.id_order
        JOIN tuti_dispo_test as dt ON dt.cod_item = oi.sku
        WHERE torder.cod_store = ? AND torder.send = ? AND torder.status = ? AND oi.status = ?
        GROUP BY torder.id_order, oi.id_order_item, oi.id_dispo, oi.sku, dt.description, oi.amount, torder.creation_date
      """;

      List<Map<String, dynamic>> list = await database
          .rawQuery(sql, [codStore, 'N', 'A', 'A', codStore, 'N', 'A', 'A']);
      return List.generate(
          list.length,
          (i) => {
                'id_order': list[i]['id_order'],
                'id_order_item': list[i]['id_order_item'],
                'id_dispo': list[i]['id_dispo'],
                'cod_item': list[i]['sku'],
                'description': list[i]['description'],
                'cantidad': list[i]['amount'],
                'observacion': list[i]['observacion'],
                'creation_date': list[i]['creation_date'],
                'send': list[i]['send']
              });
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> getSendedOrder() async {
    Map<String, dynamic> map = await SessionDB.currentSession();
    if (map['status'] == 'success') {
      String codStore = map['client']['cod_store'];
      Database database = await Db.openDB();
      String sql = """
        SELECT torder.id_order, oi.id_order_item, oi.id_dispo, oi.sku, di.description, oi.amount, torder.creation_date
        FROM tuti_order as torder
        JOIN tuti_order_item as oi ON oi.id_order = torder.id_order
        JOIN tuti_dispo_item as di ON di.cod_item = oi.sku
        WHERE torder.cod_store = ? AND torder.send = ? AND torder.status = ? AND oi.status = ?
        GROUP BY torder.id_order, oi.id_order_item, oi.id_dispo, oi.sku, di.description, oi.amount, torder.creation_date
        UNION ALL
        SELECT torder.id_order, oi.id_order_item, oi.id_dispo, oi.sku, dt.description, oi.amount, torder.creation_date
        FROM tuti_order as torder
        JOIN tuti_order_item as oi ON oi.id_order = torder.id_order
        JOIN tuti_dispo_test as dt ON dt.cod_item = oi.sku
        WHERE torder.cod_store = ? AND torder.send = ? AND torder.status = ? AND oi.status = ?
        GROUP BY torder.id_order, oi.id_order_item, oi.id_dispo, oi.sku, dt.description, oi.amount, torder.creation_date
      """;

      List<Map<String, dynamic>> list = await database
          .rawQuery(sql, [codStore, 'Y', 'A', 'A', codStore, 'Y', 'A', 'A']);

      return List.generate(
          list.length,
          (i) => {
                'id_order': list[i]['id_order'],
                'id_order_item': list[i]['id_order_item'],
                'id_dispo': list[i]['id_dispo'],
                'sku': list[i]['sku'],
                'description': list[i]['description'],
                'amount': list[i]['amount'],
                'creation_date': list[i]['creation_date'],
              });
    }
    return [];
  }

  static Future<int> setSendOrder({required int idOrder}) async {
    DateTime now = DateTime.now();
    String creationDate =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    Database database = await Db.openDB();
    int result = await database.rawUpdate(
        "UPDATE tuti_order SET send = ?, send_date = ? WHERE id_order = ? ",
        ['Y', creationDate, idOrder]);
    return result;
  }

  static Future<int> delete({required int idOrder}) async {
    Database database = await Db.openDB();
    int result = await database.rawUpdate(
        "UPDATE tuti_order SET status = ? WHERE id_order = ? ", ['D', idOrder]);
    return result;
  }
}
