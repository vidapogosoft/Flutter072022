import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/db/order_db.dart';
import 'package:app_api_sqlite/src/db/order_item_db.dart';
import 'package:app_api_sqlite/src/models/order_model.dart';

class OrderApiProvider {
  static const String _point = Constant.basePoint;

  static Future<bool> getLastOrder(String codStore, String token) async {
    try {
      String url = '$_point/order/' + codStore + '?is_last=true';
      var uriUrl = Uri.parse(url);
      var response = await http.get(
        uriUrl,
        headers: {HttpHeaders.authorizationHeader: token},
      );
      var jsonResponse = convert.jsonDecode(response.body);
      var data = jsonResponse['pedidoByCliente'];

      for (var values in data) {
        for (var item in values) {
          var codStore = item['id_cliente']['user_cod_tienda'];
          var idDispo = item['dispo'];

          if (!await OrderDB.existOrder(idOrder: item['id_pedido'])) {
            OrderDB.insert(
                idOrder: item['id_pedido'], codStore: codStore, send: 'Y');
          }

          await OrderItemDB.insertElement(
              idOrder: item['id_pedido'],
              idDispo: idDispo,
              sku: item['cod_item'],
              amount: item['cantidad'],
              observacion: item['observacion'],
              creationDate: item['fecha']);
        }
      }

      url = '$_point/order_test/' + codStore + '?is_last=1';
      uriUrl = Uri.parse(url);
      response = await http.get(uriUrl);
      jsonResponse = convert.jsonDecode(response.body);
      data = jsonResponse['pedidoByCliente'];

      for (var item in data) {
        var codStore = item['id_cliente']['user_cod_tienda'];
        var idDispo = 0;

        if (!await OrderDB.existOrder(idOrder: item['id_pedido'])) {
          OrderDB.insert(
              idOrder: item['id_pedido'], codStore: codStore, send: 'Y');
        }

        await OrderItemDB.insertElement(
            idOrder: item['id_pedido'],
            idDispo: idDispo,
            sku: item['cod_item'],
            amount: item['cantidad'],
            observacion: item['observacion'],
            creationDate: item['fecha']);
      }
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Exception in OrderApiProvider method getLastOrder: $e');
      return false;
    }
  }

  static Future<List<OrderModel>> getLastOderTest(String codStore) async {
    try {
      String url = '$_point/pedidos_dispo_prueba/' + codStore + '/';
      var uriUrl = Uri.parse(url);
      var response = await http.get(uriUrl);
      var jsonResponse = convert.jsonDecode(response.body);
      // ignore: avoid_print
      print('Response: $jsonResponse');
      return (jsonResponse["data"] as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
