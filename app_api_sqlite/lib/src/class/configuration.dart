import 'package:app_api_sqlite/src/db/dispo_db.dart';
import 'package:app_api_sqlite/src/db/dispo_item_db.dart';
import 'package:app_api_sqlite/src/models/dispo_item_model.dart';
import 'package:app_api_sqlite/src/models/dispo_model.dart';
import 'package:app_api_sqlite/src/resources/dispo_api_provider.dart';
import 'package:app_api_sqlite/src/resources/dispo_item_api_provider.dart';

class Configuration {
  static Map<String, dynamic> updateMetaData() {
    try {
      // ignore: avoid_print
      print('hola');
      return {'status': 'success'};
    } catch (e) {
      return {'status': 'fail'};
    }
  }

  static Future<bool> downloadDispo(String userCodStore, String token) async {
    List<DispoModel> dispos =
        await DispoApiProvider.getDispo(userCodStore, token);
    if (dispos.isNotEmpty) {
      DispoDB.deleteAll();
      for (final dispo in dispos) {
        DispoDB.insert(dispo);
      }
      return true;
    }
    return false;
  }

  static Future<bool> downloadDispoItem(
      String userCodStore, String token) async {
    List<DispoItemModel> dispoItems =
        await DispoItemApiProvider.getFileDispo(userCodStore, token);
    if (dispoItems.isNotEmpty) {
      DispoItemDB.deleteAll();
      for (var item in dispoItems) {
        DispoItemDB.insert(item);
      }
      return true;
    }
    return false;
  }
}
