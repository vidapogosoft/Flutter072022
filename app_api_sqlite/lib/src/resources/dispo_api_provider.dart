import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/models/dispo_model.dart';
import 'dart:io';

class DispoApiProvider {
  static const String _point = Constant.basePoint;

  static Future<List<DispoModel>> getDispo(
      String userCodStore, String token) async {
    try {
      String url = '$_point/dispo/all_records/';
      var uriUrl = Uri.parse(url);
      var response = await http.post(uriUrl, headers: {
        HttpHeaders.authorizationHeader: token
      }, body: {
        "user_cod_store": userCodStore,
      });
      var jsonResponse = convert.jsonDecode(response.body);
      return (jsonResponse["data"] as List)
          .map((e) => DispoModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
