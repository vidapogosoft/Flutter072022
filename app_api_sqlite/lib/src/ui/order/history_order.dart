import 'package:flutter/material.dart';
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/db/order_db.dart';
import 'package:app_api_sqlite/src/db/order_item_db.dart';
import 'package:app_api_sqlite/src/ui/home/home.dart';

class HistoryOrder extends StatefulWidget {
  const HistoryOrder({Key? key}) : super(key: key);

  @override
  _HistoryOrderState createState() => _HistoryOrderState();
}

class _HistoryOrderState extends State<HistoryOrder> {
  List<Map> _sendItems = [];
  Color styleColor = Colors.blue[900] ?? Colors.blue;

  @override
  void initState() {
    _getOrders();
    super.initState();
  }

  void _getOrders() async {
    List<Map> auxOrder = await OrderDB.getSendedOrder();
    if (auxOrder.isNotEmpty) {
      if (mounted) {
        setState(() {
          _sendItems = auxOrder;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _sendItems = [];
        });
      }
    }
  }

  void _deleteOrderItem(int idOrderItem) async {
    int result = await OrderItemDB.delete(idOrderItem: idOrderItem);
    if (result > 0) {
      _getOrders();
    }
  }

  void _deleteAllOrderItem() async {
    if (_sendItems.isNotEmpty) {
      int idOrder = 0;
      for (var item in _sendItems) {
        if (item['id_order'] != idOrder) {
          idOrder = item['id_order'];
          await OrderItemDB.deleteAll(idOrder: idOrder);
        }
      }
      if (mounted) {
        setState(() {
          _sendItems = [];
        });
      }
    }
  }

  void _confirmationDeleteHistory(BuildContext contextParent, int idOrderItem) {
    showDialog(
        context: contextParent,
        builder: (BuildContext context) {
          return AlertDialog(
            content:
                const Text('¿Está seguro que quiere eliminar este registro?'),
            actions: [
              TextButton(
                child: const Text('Sí, eliminar',
                    style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteOrderItem(idOrderItem);
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

  void _confirmationDeleteAll(BuildContext contextParent) {
    showDialog(
        context: contextParent,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text(
                '¿Está seguro que quiere limpiar todo el historial?'),
            actions: [
              TextButton(
                child: const Text('Sí, eliminar',
                    style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteAllOrderItem();
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
      child: _sendItems.isNotEmpty
          ? Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0.0),
              child: Column(children: [
                const SizedBox(height: 10.0),
                Table(
                  columnWidths: const {
                    0: FractionColumnWidth(0.2),
                    1: FractionColumnWidth(0.1),
                    2: FractionColumnWidth(0.2),
                    3: FractionColumnWidth(0.3),
                    4: FractionColumnWidth(0.1),
                    5: FractionColumnWidth(0.1),
                  },
                  children: [
                    TableRow(children: [
                      Column(children: [
                        Container(
                            width: double.infinity,
                            color: styleColor,
                            child: const Text('Fecha',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Constant.primaryColor)))
                      ]),
                      Column(children: [
                        Container(
                            width: double.infinity,
                            color: styleColor,
                            child: const Text('Dis.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Constant.primaryColor)))
                      ]),
                      Column(children: [
                        Container(
                            width: double.infinity,
                            color: styleColor,
                            child: const Text('Sku',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Constant.primaryColor)))
                      ]),
                      Column(children: [
                        Container(
                            width: double.infinity,
                            color: styleColor,
                            child: const Text('Descrip.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Constant.primaryColor)))
                      ]),
                      Column(children: [
                        Container(
                            width: double.infinity,
                            color: styleColor,
                            child: const Text('Cant.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Constant.primaryColor)))
                      ]),
                      Column(children: [
                        Container(
                            width: double.infinity,
                            color: styleColor,
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
                      itemCount: _sendItems.length,
                      itemBuilder: (context, i) {
                        return Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FractionColumnWidth(0.2),
                            1: FractionColumnWidth(0.1),
                            2: FractionColumnWidth(0.2),
                            3: FractionColumnWidth(0.3),
                            4: FractionColumnWidth(0.1),
                            5: FractionColumnWidth(0.1),
                          },
                          children: [
                            TableRow(children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 55.0,
                                      child: Center(
                                          child: Text(
                                              _sendItems[i]['creation_date'])))
                                ],
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_sendItems[i]['id_dispo'] != 0
                                        ? '${_sendItems[i]['id_dispo']}'
                                        : 'P')
                                  ]),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text(_sendItems[i]['sku'])]),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 75.0,
                                      child: Center(
                                          child: Text(
                                              _sendItems[i]['description'])))
                                ],
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${_sendItems[i]['amount']}')
                                  ]),
                              Column(children: [
                                IconButton(
                                    onPressed: () {
                                      _confirmationDeleteHistory(context,
                                          _sendItems[i]['id_order_item']);
                                    },
                                    icon: const Icon(Icons.delete_outline))
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
                      _confirmationDeleteAll(context);
                    },
                    child: const Text('Limpiar historial',
                        style: TextStyle(color: Constant.primaryColor)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(styleColor),
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
              child: Center(child: Text('Sin resultados'))),
    );
  }
}
