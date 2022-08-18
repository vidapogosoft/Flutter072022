import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_api_sqlite/src/class/alert.dart';
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/db/dispo_db.dart';
import 'package:app_api_sqlite/src/db/dispo_item_db.dart';
import 'package:app_api_sqlite/src/db/dispo_test_db.dart';
import 'package:app_api_sqlite/src/db/order_db.dart';
import 'package:app_api_sqlite/src/db/session_db.dart';
import 'package:app_api_sqlite/src/models/dispo_item_model.dart';
import 'package:app_api_sqlite/src/models/dispo_model.dart';
import 'package:app_api_sqlite/src/models/dispo_test_model.dart';
import 'package:app_api_sqlite/src/resources/dispo_api_provider.dart';
import 'package:app_api_sqlite/src/resources/dispo_item_api_provider.dart';
import 'package:app_api_sqlite/src/resources/dispo_test_api_provider.dart';
import 'package:app_api_sqlite/src/route/route.dart';

class Config extends StatefulWidget {
  const Config({Key? key}) : super(key: key);

  @override
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  void _updateData(BuildContext context) async {
    try {
      Alert.loaderDialog(context, 'Actualizando...');
      Map<String, dynamic> client = await SessionDB.currentSession();
      if (client.isNotEmpty) {
        String codStore = client['client']['cod_store'];
        String token = client['client']['token'];
        bool dispo = await _downloadDispo(codStore, token);
        bool dispoItem = await _downloadDispoItem(codStore, token);
        bool dispoTest = await _downloadDispoTest(codStore, token);
        Navigator.of(context).pop();

        if (dispo && dispoItem && dispoTest) {
          _showSnackMessage(context, 'Datos actualizado con éxito');
        } else {
          _showSnackMessage(context, 'Error al actualizar');
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Exception in Config method _updateData: $e');
      Navigator.of(context).pop();
      _showSnackMessage(context, 'Ha ocurrido un error');
    }
  }

  Future<bool> _downloadDispo(String codStore, String token) async {
    List<DispoModel> dispos = await DispoApiProvider.getDispo(codStore, token);
    if (dispos.isNotEmpty) {
      await DispoDB.setCurrentStatus();
      for (final dispo in dispos) {
        DispoDB.insert(dispo);
      }
      return true;
    }
    return false;
  }

  Future<bool> _downloadDispoItem(String codStore, String token) async {
    List<DispoItemModel> dispoItems =
        await DispoItemApiProvider.getFileDispo(codStore, token);
    if (dispoItems.isNotEmpty) {
      await DispoItemDB.setCurrentStatus();
      for (var item in dispoItems) {
        DispoItemDB.insert(item);
      }
      return true;
    }
    return false;
  }

  Future<bool> _downloadDispoTest(String codStore, String token) async {
    List<DispoTestModel> dispoTest =
        await DispoTestApiProvider.getFileDispo(codStore, token);
    if (dispoTest.isNotEmpty) {
      DispoTestDB.setCurrentStatus();
      for (var item in dispoTest) {
        await DispoTestDB.insert(item);
      }
      return true;
    }
    return false;
  }

  void _verifyUpdate(BuildContext context) async {
    List<Map> auxOrder = await OrderDB.getNotSendOrder();
    if (auxOrder.isNotEmpty) {
      _confirmationUpdateData(context);
    } else {
      _updateData(context);
    }
  }

  void _confirmationUpdateData(BuildContext contextParent) {
    showDialog(
        context: contextParent,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Advertencia'),
            content: const Text(
                'Se encontraron pedidos sin enviar. Se recomienda enviar los pedidos antes de realizar una actualización de todas las dispos'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Actualizar'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _updateData(contextParent);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Constant.lightTheme,
      child: Scaffold(
          backgroundColor: Constant.backgroundColor,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Constant.primaryColor,
            leading: IconButton(
              icon:
                  const Icon(Icons.arrow_back, color: Constant.secondaryColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Configuración',
                style: TextStyle(color: Constant.secondaryColor)),
          ),
          body: contentConfig(context)),
    );
  }

  Widget contentConfig(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //UPDATE METADATA
        ListTile(
          leading: const Icon(Icons.file_download_outlined,
              color: Constant.secondaryColor),
          title: const Text('Actualizar dispos'),
          onTap: () {
            _verifyUpdate(context);
          },
        ),

        ListTile(
          leading: const Icon(Icons.home, color: Constant.secondaryColor),
          title: const Text('Home'),
          onTap: () {
            Navigator.of(context).push(MyRoute.home(context));
          },
        ),

        Container(
          padding: const EdgeInsets.only(
              top: 20.0, left: 19.0, bottom: 10.0, right: 19.0),
          child: const Text("Inicio de sesión",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        ),

        //LOGOUT
        ListTile(
          leading:
              const Icon(Icons.exit_to_app, color: Constant.secondaryColor),
          title: const Text('Salir'),
          onTap: () {
            Alert.logout(context);
          },
        ),
      ],
    ));
  }

  void _showSnackMessage(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
