import 'package:sqflite/sqflite.dart';
import 'package:app_api_sqlite/src/db/db.dart';
import 'package:app_api_sqlite/src/models/session_model.dart';

class SessionDB {
  static Future<bool> hasActiveSession() async {
    Database database = await Db.openDB();
    final List<Map<String, dynamic>> list = await database
        .query('tuti_session', where: "status = ?", whereArgs: ['A']);
    return list.isNotEmpty ? true : false;
  }

  static Future<void> startSession(SessionModel data) async {
    DateTime now = DateTime.now();
    String creationDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    Database database = await Db.openDB();
    await database.rawInsert(
        "INSERT INTO tuti_session(id_client, cod_store, status, creation_date, token) VALUES(?,?,?,?,?)",
        [data.idClient, data.codStore, 'A', creationDate, data.token]);
  }

  static Future<Map<String, dynamic>> currentSession() async {
    try {
      Database database = await Db.openDB();
      final List<Map<String, dynamic>> list = await database.query(
          'tuti_session',
          columns: ['id_session', 'cod_store', 'token'],
          where: "status = 'A' ");

      if (list.isNotEmpty) {
        String codStore = list[0]['cod_store'];
        final List<Map<String, dynamic>> listClient = await database.query(
            'tuti_client',
            where: "cod_store = ?",
            whereArgs: [codStore]);
        if (listClient.isNotEmpty) {
          return {
            'status': 'success',
            'id_session': list[0]['id_session'],
            'client': {
              'id_client': listClient[0]['id_client'],
              'name': listClient[0]['name'],
              'cod_store': listClient[0]['cod_store'],
              'monthly_sale': listClient[0]['monthly_sale'],
              'days_month': listClient[0]['days_month'],
              'token': listClient[0]['token']
            }
          };
        }
      }
      return {'status': 'fail'};
    } catch (e) {
      return {'status': 'fail', 'msg': '$e'};
    }
  }

  static Future<void> endSession() async {
    Database database = await Db.openDB();
    Map<String, dynamic> session = await currentSession();
    if (session['status'] == 'success') {
      int idSession = session['id_session'];
      database.rawUpdate(
          "UPDATE tuti_session set status = ? where id_session = ? ",
          ['I', idSession]);
    }
  }

  static Future<List<SessionModel>> all() async {
    Database database = await Db.openDB();
    List<Map<String, dynamic>> list = await database.query('tuti_session');
    if (list.isNotEmpty) {
      return List.generate(
          list.length,
          (i) => SessionModel(
              idSession: list[i]['id_session'],
              idClient: list[i]['id_client'],
              codStore: list[i]['cod_store'],
              status: list[i]['status'],
              creationDate: list[i]['creation_date'],
              token: list[i]['token']));
    }
    return [];
  }
}
