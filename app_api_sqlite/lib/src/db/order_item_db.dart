import 'package:sqflite/sqflite.dart';
import 'package:app_api_sqlite/src/class/utils.dart';
import 'package:app_api_sqlite/src/db/db.dart';

class OrderItemDB {
  static Future<List<Map<String, dynamic>>> all({required int idOrder}) async {
    try {
      String sql = """
        SELECT oi.id_order_item, oi.id_order, oi.id_dispo, oi.sku, di.description, oi.amount, oi.creation_date
        FROM tuti_order_item as oi
        JOIN tuti_dispo_item as di ON di.cod_item = oi.sku
        WHERE oi.id_order = ? AND status = 'A'
      """;
      Database database = await Db.openDB();
      List<Map<String, dynamic>> list = await database.rawQuery(sql, [idOrder]);
      return List.generate(
          list.length,
          (i) => {
                'id_order_item': list[i]['id_order_item'],
                'id_order': list[i]['id_order'],
                'id_dispo': list[i]['id_dispo'],
                'sku': list[i]['sku'],
                'description': list[i]['description'],
                'amount': list[i]['amount'],
                'creation_date': list[i]['creation_date'],
              });
    } catch (e) {
      // ignore: avoid_print
      print('Exception in OrderItemDB method all: $e');
      return [];
    }
  }

  static Future<bool> exist({required int idOrder, required String sku}) async {
    Database database = await Db.openDB();
    final List<Map<String, dynamic>> list = await database.query(
        "tuti_order_item",
        where: "id_order = ? AND sku = ? AND status = ? ",
        whereArgs: [idOrder, sku, 'A']);
    if (list.isNotEmpty) return true;
    return false;
  }

  static Future<bool> insert(
      {required int idOrder,
      required int idDispo,
      required String observacion,
      required Map<String, dynamic> data}) async {
    try {
      String creationDate = Utils.strDateTime();
      Database database = await Db.openDB();
      data.forEach((sku, amount) async {
        if (amount != '' && amount != '0') {
          bool result = await exist(idOrder: idOrder, sku: sku);
          if (result) {
            await database.rawUpdate(
                "UPDATE tuti_order_item SET amount = ? WHERE id_order = ? AND sku = ?",
                [int.parse(amount), idOrder, sku]);
          } else {
            await database.rawInsert(
                "INSERT INTO tuti_order_item(id_order, id_dispo, sku, amount, status, creation_date, observacion) VALUES(?,?,?,?,?,?,?)",
                [
                  idOrder,
                  idDispo,
                  sku,
                  int.parse(amount),
                  'A',
                  creationDate,
                  observacion
                ]);
          }
        }
      });
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Exception in OrderItemDB method insert: $e');
      return false;
    }
  }

  static Future<bool> insertElement(
      {required int idOrder,
      required int idDispo,
      required String sku,
      required int amount,
      required String creationDate,
      required String observacion}) async {
    try {
      String creationDate = Utils.strDateTime();
      Database database = await Db.openDB();

      if (amount > 0) {
        bool result = await exist(idOrder: idOrder, sku: sku);
        if (result) {
          await database.rawUpdate(
              "UPDATE tuti_order_item SET amount = ? WHERE id_order = ? AND sku = ?",
              [amount, idOrder, sku]);
        } else {
          await database.rawInsert(
              "INSERT INTO tuti_order_item(id_order, id_dispo, sku, amount, status, creation_date, observacion) VALUES(?,?,?,?,?,?,?)",
              [idOrder, idDispo, sku, amount, 'A', creationDate, observacion]);
        }
      }
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Exception in OrderItemDB method insert: $e');
      return false;
    }
  }

  static Future<Map> insertFromSearch(
      {required int idOrder,
      required String observacion,
      required Map<String, dynamic> data}) async {
    try {
      String creationDate = Utils.strDateTime();
      Database database = await Db.openDB();
      data.forEach((sku, values) async {
        if (values['amount'] != '' && values['amount'] != '0') {
          bool result = await exist(idOrder: idOrder, sku: sku);
          if (result) {
            await database.rawUpdate(
                "UPDATE tuti_order_item SET amount = ? WHERE id_order = ? AND sku = ?",
                [int.parse(values['amount']), idOrder, sku]);
          } else {
            await database.rawInsert(
                "INSERT INTO tuti_order_item(id_order, id_dispo, sku, amount, status, creation_date, observacion) VALUES(?,?,?,?,?,?,?)",
                [
                  idOrder,
                  values['id_dispo'],
                  sku,
                  int.parse(values['amount']),
                  'A',
                  creationDate,
                  observacion
                ]);
          }
        }
      });
      return {'status': 'success'};
    } catch (e) {
      // ignore: avoid_print
      print('Exception in OrderItemDB method insertFromSearch: $e');
      return {'status': 'fail'};
    }
  }

  static Future<Map<String, dynamic>> lastAmount(
      {required int idDispo, required String sku}) async {
    try {
      Database database = await Db.openDB();

      String sql = """
        SELECT oi.id_order_item, torder.id_order, oi.sku, oi.amount
        FROM tuti_order_item as oi 
        JOIN tuti_order as torder ON torder.id_order = oi.id_order
        WHERE id_dispo = ? AND sku = ? AND torder.status = 'A' AND torder.send = 'Y'
        ORDER BY oi.id_order_item desc limit 0, 1
      """;
      final List<Map<String, dynamic>> list =
          await database.rawQuery(sql, [idDispo, sku]);

      if (list.isNotEmpty) {
        return {
          'id_order_item': list[0]['id_order_item'],
          'id_order': list[0]['id_order'],
          'amount': list[0]['amount']
        };
      }
      return {};
    } catch (e) {
      // ignore: avoid_print
      print('Exception in DispoItemDB method filter: $e');
      return {};
    }
  }

  static Future<int> updateAmount(
      {required int idOrderItem, required int amount}) async {
    Database database = await Db.openDB();
    int result = await database.rawUpdate(
        "UPDATE tuti_order_item SET amount = ? WHERE id_order_item = ? ",
        [amount, idOrderItem]);
    return result;
  }

  static Future<int> delete({required int idOrderItem}) async {
    Database database = await Db.openDB();
    int result = await database.rawUpdate(
        "UPDATE tuti_order_item SET status = ? WHERE id_order_item = ? ",
        ['D', idOrderItem]);
    return result;
  }

  static Future<Map> deleteAll({required int idOrder}) async {
    try {
      Database database = await Db.openDB();
      await database.rawUpdate(
          "UPDATE tuti_order_item SET status = ? WHERE id_order = ? ",
          ['D', idOrder]);
      return {'status': 'success'};
    } catch (e) {
      return {'status': 'fail'};
    }
  }
}
