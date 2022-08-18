import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/models/dispo_item_model.dart';

class DispoItemApiProvider {
  static const String _point = Constant.basePoint;

  static Future<List<DispoItemModel>> getFileDispo(
      String codStore, String token) async {
    try {
      String url = '$_point/file_dispo/all_records/';
      var uriUrl = Uri.parse(url);
      var response = await http.post(uriUrl, headers: {
        HttpHeaders.authorizationHeader: token
      }, body: {
        "user_cod_store": codStore,
      });
      var jsonResponse = convert.jsonDecode(response.body);
      return (jsonResponse["data"] as List)
          .map((e) => DispoItemModel.fromJson(e))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('Exception in DispoItemProvider method getFileDispo: $e');
      return [];
    }
  }
}
