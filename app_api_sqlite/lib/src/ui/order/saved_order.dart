import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_api_sqlite/src/class/alert.dart';
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/db/order_db.dart';
import 'package:app_api_sqlite/src/db/order_item_db.dart';
import 'package:app_api_sqlite/src/db/session_db.dart';
import 'package:app_api_sqlite/src/ui/home/home.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';
//import 'dart:io';

class SavedOrder extends StatefulWidget {
  const SavedOrder({Key? key}) : super(key: key);

  @override
  _SavedOrderState createState() => _SavedOrderState();
}

class _SavedOrderState extends State<SavedOrder> {
  List<Map> _savedItems = [];
  final InputWithKeyboardControlFocusNode _focus =
      InputWithKeyboardControlFocusNode();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    _getOrders();
    super.initState();
  }

  void _getOrders() async {
    List<Map> auxOrder = await OrderDB.getNotSendOrder();

    if (auxOrder.isNotEmpty) {
      if (mounted) {
        setState(() {
          _savedItems = auxOrder;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _savedItems = [];
        });
      }
    }
  }

  void _updateAmount(int idOrderItem, int amount) async {
    int result = await OrderItemDB.updateAmount(
        idOrderItem: idOrderItem, amount: amount);
    if (result > 0) {
      _getOrders();
    }
  }

  void _deleteOrderItem(int idOrderItem) async {
    int result = await OrderItemDB.delete(idOrderItem: idOrderItem);
    if (result > 0) {
      _getOrders();
    }
  }

  void _sendOrder(BuildContext context) async {
    String url = '${Constant.basePoint}/order/create_new/';

    try {
      if (_savedItems.isNotEmpty) {
        Alert.loaderDialog(context, 'Enviando...');
        Map client = await SessionDB.currentSession();
        //String token = client['client']['token'];
        /*String token =
            'db37f3276c5f4e462a12b2a3a58a567b723a8b8b8351b85d754b2a5f0b4795751c90fa1074c50143cf8cc65d4c87e135442dd1256a0b2e1e7ae76fe7cc097e60';
        */
        Map data = {
          'cod_tienda': client['client']['cod_store'],
          'id_cliente': client['client']['id_client'],
          'tienda_nombre': client['client']['name'],
          //'enviado': 'E',
          //VPR: envio de email por masterbase 05302022
          'enviado': 'N',
          'items': _savedItems
        };

        //headers: {HttpHeaders.authorizationHeader: token},
        var response =
            await http.post(Uri.parse(url), body: convert.json.encode(data));
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['error'] == false) {
          int idOrder = 0;
          for (var item in _savedItems) {
            if (item['id_order'] != idOrder) {
              idOrder = item['id_order'];
              await OrderDB.setSendOrder(idOrder: idOrder);
            }
          }
          _getOrders();
          Navigator.of(context).pop();
          _showMessage(context, 'Enviado con éxito');
        } else {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('$e');
      Navigator.of(context).pop();
      _showMessage(context, 'Error al intentar enviar el pedido');
    }
  }

  void _showMessage(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _modalEdit(
      BuildContext contextParent, int idOrderItem, String title, int amount) {
    _amountController.text = amount.toString();
    showDialog(
        context: contextParent,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title, style: const TextStyle(fontSize: 14.0)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                padding: const EdgeInsets.all(0.3),
                child: Container(
                  height: 40.0,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: InputWithKeyboardControl(
                    focusNode: _focus,
                    cursorColor: Colors.blue,
                    controller: _amountController,
                    width: double.infinity,
                    startShowKeyboard: false,
                    buttonColorEnabled: Colors.blue,
                    buttonColorDisabled: Colors.black54,
                    underlineColor: Colors.blue,
                    showButton: true,
                    showUnderline: false,
                  ),
                ),
              )
            ]),
            actions: [
              TextButton(
                child:
                    const Text('Eliminar', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  _confirmationDelete(contextParent, idOrderItem);
                },
              ),
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _updateAmount(idOrderItem, int.parse(_amountController.text));
                },
              ),
            ],
          );
        });
  }

  void _confirmationSendOrder(BuildContext contextParent) {
    showDialog(
        context: contextParent,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('¿Está seguro que quiere enviar este pedido?'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Enviar'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _sendOrder(contextParent);
                },
              ),
            ],
          );
        });
  }

  void _confirmationDelete(BuildContext contextParent, int idOrderItem) {
    showDialog(
        context: contextParent,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('¿Está seguro que quiere eliminar este item?'),
            actions: [
              TextButton(
                child: const Text('Sí, eliminar',
                    style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteOrderItem(idOrderItem);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: _savedItems.isNotEmpty
          ? Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0.0),
              child: Column(children: [
                const SizedBox(height: 10.0),
                Table(
                  columnWidths: const {
                    0: FractionColumnWidth(0.1),
                    1: FractionColumnWidth(0.2),
                    2: FractionColumnWidth(0.4),
                    3: FractionColumnWidth(0.2),
                    4: FractionColumnWidth(0.1),
                  },
                  children: [
                    TableRow(children: [
                      Column(children: [
                        Container(
                            width: double.infinity,
                            color: Constant.accentColor,
                            child: const Text('Dispo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Constant.primaryColor)))
                      ]),
                      Column(children: [
                        Container(
                            width: double.infinity,
                            color: Constant.accentColor,
                            child: const Text('Sku',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Constant.primaryColor)))
                      ]),
                      Column(children: [
                        Container(
                            width: double.infinity,
                            color: Constant.accentColor,
                            child: const Text('Descrip.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Constant.primaryColor)))
                      ]),
                      Column(children: [
                        Container(
                            width: double.infinity,
                            color: Constant.accentColor,
                            child: const Text('Cant.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Constant.primaryColor)))
                      ]),
                      Column(children: [
                        Container(
                            width: double.infinity,
                            color: Constant.accentColor,
                            child: const Text('',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Constant.primaryColor)))
                      ]),
                    ])
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _savedItems.length,
                      itemBuilder: (context, i) {
                        return Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FractionColumnWidth(0.1),
                            1: FractionColumnWidth(0.2),
                            2: FractionColumnWidth(0.4),
                            3: FractionColumnWidth(0.2),
                            4: FractionColumnWidth(0.1),
                          },
                          children: [
                            TableRow(children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_savedItems[i]['id_dispo'] != 0
                                        ? '${_savedItems[i]['id_dispo']}'
                                        : 'P')
                                  ]),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text(_savedItems[i]['cod_item'])]),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 70.0,
                                      child: Center(
                                          child: Text(_savedItems[i]
                                                  ['description'] ??
                                              'hola')))
                                ],
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${_savedItems[i]['cantidad']}')
                                  ]),
                              Column(children: [
                                IconButton(
                                    onPressed: () {
                                      _modalEdit(
                                          context,
                                          _savedItems[i]['id_order_item'],
                                          _savedItems[i]['description'],
                                          _savedItems[i]['cantidad']);
                                    },
                                    icon: const Icon(Icons.more_vert))
                              ]),
                            ])
                          ],
                        );
                      }),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                          (Route<dynamic> route) => false);
                    },
                    child: const Text('Elegir otra dispo',
                        style: TextStyle(color: Constant.accentColor)),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          side: const BorderSide(color: Constant.accentColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      overlayColor: MaterialStateProperty.all(Colors.white12),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      _confirmationSendOrder(context);
                    },
                    child: const Text(
                        'Colocar en base para que se envien los pedidos',
                        style: TextStyle(color: Constant.primaryColor)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Constant.accentColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      overlayColor: MaterialStateProperty.all(Colors.white12),
                    ),
                  ),
                ),
              ]),
            )
          : const SizedBox(
              width: double.infinity,
              child: Center(child: Text('No hay pedidos guardados'))),
    );
  }
}
