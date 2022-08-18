import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/models/dispo_test_model.dart';

class DispoTestApiProvider {
  static const String _point = Constant.basePoint;

  static Future<List<DispoTestModel>> getFileDispo(
      String codStore, String token) async {
    try {
      String url = '$_point/test_file_dispo?user_cod_store=' + codStore;
      var uriUrl = Uri.parse(url);
      var response = await http.get(
        uriUrl,
        headers: {HttpHeaders.authorizationHeader: token},
      );
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        return (jsonResponse["data"] as List)
            .map((e) => DispoTestModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      // ignore: avoid_print
      print('Exception in DispoTestProvider method getFileDispo: $e');
      return [];
    }
  }
}
