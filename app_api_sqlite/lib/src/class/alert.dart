import 'package:flutter/material.dart';
import 'package:app_api_sqlite/src/db/session_db.dart';
import 'package:app_api_sqlite/src/ui/auth/login.dart';
import 'package:app_api_sqlite/src/class/constant.dart';

class Alert {
  static void logout(BuildContext contextParent) {
    showDialog(
        context: contextParent,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('¿Está seguro que quiere salir?'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  loaderDialog(contextParent, 'Saliendo...');
                  SessionDB.endSession();
                  Future.delayed(
                      const Duration(milliseconds: Constant.delayTime), () {
                    Navigator.of(contextParent).pop();
                    Navigator.pushAndRemoveUntil(
                        contextParent,
                        MaterialPageRoute(builder: (context) => const Login()),
                        (Route<dynamic> route) => false);
                  });
                },
              ),
            ],
          );
        });
  }

  static void loaderDialog(BuildContext context, String msg) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: Row(children: [
          const SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(),
          ),
          Container(margin: const EdgeInsets.only(left: 20), child: Text(msg)),
        ]));
      },
    );
  }
}
