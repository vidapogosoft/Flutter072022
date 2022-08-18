import 'package:flutter/material.dart';
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/db/order_db.dart';
import 'package:app_api_sqlite/src/db/order_item_db.dart';
import 'package:app_api_sqlite/src/models/order_model.dart';
import 'package:app_api_sqlite/src/ui/home/home.dart';

class UnfinishedOrder extends StatefulWidget {
  const UnfinishedOrder({Key? key}) : super(key: key);

  @override
  _UnfinishedOrderState createState() => _UnfinishedOrderState();
}

class _UnfinishedOrderState extends State<UnfinishedOrder> {
  int _idOrder = 0;
  List<Map> _orderItems = [];
  double paddingCell = 5.0;

  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    _getOrders();
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _getOrders() async {
    List<OrderModel> aux = await OrderDB.all();
    if (aux.isNotEmpty) {
      setState(() {
        _idOrder = aux[0].idOrder;
      });
      List<Map> auxItem = await OrderItemDB.all(idOrder: aux[0].idOrder);
      if (auxItem.isNotEmpty) {
        if (mounted) {
          setState(() {
            _orderItems = auxItem;
            _idOrder = aux[0].idOrder;
          });
        }
      } else {
        await OrderDB.delete(idOrder: _idOrder);
        if (mounted) {
          setState(() {
            _orderItems = [];
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _orderItems = [];
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

  void _modalEdit(
      BuildContext contextParent, int idOrderItem, String title, int amount) {
    _amountController.text = amount.toString();
    showDialog(
        context: contextParent,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title, style: const TextStyle(fontSize: 14.0)),
            content: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
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

  void _confirmationFinishOrder(BuildContext contextParent) {
    showDialog(
        context: contextParent,
        builder: (BuildContext context) {
          return AlertDialog(
            content:
                const Text('¿Está seguro que quiere finalizar este pedido?'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
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
        child: _orderItems.isNotEmpty
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0.0),
                child: Column(children: [
                  const SizedBox(height: 10.0),
                  /* const SizedBox(height: 30.0,  child: Center(child: Text('Tu selección'))), */
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
                              color: Colors.blue[900],
                              child: const Text('Dispo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Constant.primaryColor)))
                        ]),
                        Column(children: [
                          Container(
                              width: double.infinity,
                              color: Colors.blue[900],
                              child: const Text('Sku',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Constant.primaryColor)))
                        ]),
                        Column(children: [
                          Container(
                              width: double.infinity,
                              color: Colors.blue[900],
                              child: const Text('Descrip.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Constant.primaryColor)))
                        ]),
                        Column(children: [
                          Container(
                              width: double.infinity,
                              color: Colors.blue[900],
                              child: const Text('Cant.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Constant.primaryColor)))
                        ]),
                        Column(children: [
                          Container(
                              width: double.infinity,
                              color: Colors.blue[900],
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
                        itemCount: _orderItems.length,
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
                                      Text('${_orderItems[i]['id_dispo']}')
                                    ]),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text(_orderItems[i]['sku'])]),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 70.0,
                                        child: Center(
                                            child: Text(
                                                _orderItems[i]['description'])))
                                  ],
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${_orderItems[i]['amount']}')
                                    ]),
                                Column(children: [
                                  IconButton(
                                      onPressed: () {
                                        _modalEdit(
                                            context,
                                            _orderItems[i]['id_order_item'],
                                            _orderItems[i]['description'],
                                            _orderItems[i]['amount']);
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
                            MaterialPageRoute(
                                builder: (context) => const Home()),
                            (Route<dynamic> route) => false);
                      },
                      child: const Text('Agregar otra dispo',
                          style: TextStyle(color: Constant.accentColor)),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                  color: Constant.accentColor, width: 1)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        if (_idOrder != 0) {
                          _confirmationFinishOrder(context);
                        }
                      },
                      child: const Text('Finalizar pedido',
                          style: TextStyle(color: Constant.primaryColor)),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[900]),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              )
            : const SizedBox(
                width: double.infinity,
                child: Center(child: Text('No hay pedidos sin finalizar'))));
  }
}
