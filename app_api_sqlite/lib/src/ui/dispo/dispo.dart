import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/db/dispo_db.dart';
import 'package:app_api_sqlite/src/models/dispo_model.dart';
import 'package:app_api_sqlite/src/route/route.dart';

class Dispo extends StatefulWidget {
  const Dispo({Key? key}) : super(key: key);

  @override
  _DispoState createState() => _DispoState();
}

class _DispoState extends State<Dispo> {
  List<DispoModel> _dispos = [];

  @override
  void initState() {
    _getDispos();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getDispos() async {
    List<DispoModel> auxPlaces = await DispoDB.all();
    if (auxPlaces.isNotEmpty) {
      if (mounted) {
        setState(() {
          _dispos = auxPlaces;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _listDispo();
  }

  Widget _listDispo() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _dispos.length,
            itemBuilder: (context, i) {
              return Card(
                elevation: 0.0,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black12, width: 1),
                ),
                child: ListTile(
                  title: Text(_dispos[i].name,
                      style: const TextStyle(color: Colors.black87)),
                  trailing: Builder(
                    builder: (context) {
                      return TextButton(
                        child: const Text(
                          'Realizar pedido',
                          style: TextStyle(color: Constant.accentColor),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                    color: Constant.accentColor, width: 1)),
                          ),
                        ),
                        onPressed: () {
                          _goToDispoProduct(context, _dispos[i].idDispo);
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Container(height: 30.0)
      ],
    );
  }

  void _goToDispoProduct(BuildContext context, int idDispo) {
    Timer(const Duration(milliseconds: Constant.beforeTransition), () {
      Navigator.of(context).push(MyRoute.productDispo(context, idDispo));
    });
  }
}
