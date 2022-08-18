import 'package:flutter/material.dart';
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/db/dispo_test_db.dart';
import 'package:app_api_sqlite/src/db/order_db.dart';
import 'package:app_api_sqlite/src/db/order_item_db.dart';
import 'package:app_api_sqlite/src/db/session_db.dart';
import 'package:app_api_sqlite/src/models/client_model.dart';
import 'package:app_api_sqlite/src/models/dispo_test_model.dart';
import 'package:app_api_sqlite/src/route/route.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';

class DispoTest extends StatefulWidget {
  const DispoTest({Key? key}) : super(key: key);

  @override
  _DispoTestState createState() => _DispoTestState();
}

class _DispoTestState extends State<DispoTest> {
  List<DispoTestModel> _dispoItems = [];
  ClientModel _client = ClientModel(idClient: 0, name: '', codStore: '');
  List<TextEditingController> _listController = [];
  List<InputWithKeyboardControlFocusNode> _listFocus = [];

  final Map<String, dynamic> _lastOrderItem = {};
  final TextEditingController _amountController = TextEditingController();
  final double _paddingCell = 3.0;

  @override
  void initState() {
    _getClient();
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    for (var controller in _listController) {
      controller.dispose();
    }
    super.dispose();
  }

  void _getClient() async {
    Map<String, dynamic> map = await SessionDB.currentSession();
    if (map['status'] == 'success') {
      setState(() {
        _client = ClientModel(
            idClient: map['client']['id_client'],
            name: map['client']['name'],
            codStore: map['client']['cod_store'],
            monthlySale: map['client']['monthly_sale'],
            daysMonth: map['client']['days_month']);
      });
      _getItems();
    }
  }

  void _getItems() async {
    List<DispoTestModel> auxDispoItems =
        await DispoTestDB.filter(codStore: _client.codStore);

    if (auxDispoItems.isNotEmpty) {
      List<TextEditingController> auxControllerList = [];
      List<InputWithKeyboardControlFocusNode> auxListFocus = [];

      for (var i = 0; i < auxDispoItems.length; i++) {
        Map aux = await OrderItemDB.lastAmount(
            idDispo: auxDispoItems[i].idDispo, sku: auxDispoItems[i].codItem);

        if (aux.isNotEmpty) {
          _lastOrderItem[auxDispoItems[i].codItem] = aux;
        }

        TextEditingController controller = TextEditingController(text: '0');
        auxControllerList.add(controller);

        InputWithKeyboardControlFocusNode focus =
            InputWithKeyboardControlFocusNode();
        auxListFocus.add(focus);
      }
      setState(() {
        _dispoItems = auxDispoItems;
        _listController = auxControllerList;
        _listFocus = auxListFocus;
      });
    }
  }

  void _goToOrderDetail(BuildContext context) async {
    Map<String, dynamic> savedItems = {};
    if (_dispoItems.isNotEmpty) {
      int index = 0;
      for (var item in _dispoItems) {
        if (_listController[index].text != '0' &&
            _listController[index].text != '') {
          savedItems[item.codItem] = _listController[index].text;
        }
        index++;
      }
    }

    if (savedItems.isNotEmpty) {
      int idOrder = await OrderDB.currentOrder();
      if (idOrder == 0) {
        idOrder = await OrderDB.createOrder();
      }
      await OrderItemDB.insert(
          idOrder: idOrder,
          idDispo: 0,
          observacion: "PRUEBA",
          data: savedItems);
      Navigator.of(context).push(MyRoute.orderDetail(context));
    } else {
      _showMessage(context, 'No se ha ingresado ninguna cantidad');
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

  Widget _createColumn(
      {required String text, TextStyle? textStyle, Color? background}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            color: background,
            width: double.infinity,
            padding: EdgeInsets.all(_paddingCell),
            child: Text(text, style: textStyle))
      ],
    );
  }

  int calculateSuggestedOrder(double salesRatio, double monthlySale,
      int daysMonth, double price, int uxc, int pallet) {
    double dailyDemand =
        calculateDailyDemand(salesRatio, monthlySale, daysMonth, price);
    double frequencyDemand = dailyDemand * 12;

    if (uxc != 0 && pallet != 0) {
      double suggestedOrder = (frequencyDemand / uxc) / pallet;
      int suggestedOrderCeil = suggestedOrder.ceil();
      return suggestedOrderCeil;
    }
    return 0;
  }

  double calculateDailyDemand(
      double salesRatio, double monthlySale, int daysMonth, double price) {
    if (daysMonth != 0 && price != 0) {
      double dailyDemand = ((salesRatio * monthlySale) / daysMonth) / price;
      return dailyDemand;
    }
    return 0;
  }

  double calculateDailyDemandPallet(double dailyDemand, int pallet) {
    double dailyDemandPallet = dailyDemand / pallet;
    return dailyDemandPallet;
  }

  Widget _listDispoProduct(BuildContext context) {
    if (_dispoItems.isNotEmpty) {
      return Column(
        children: [
          Container(
              color: Colors.white,
              height: 20.0,
              width: double.infinity,
              child: Text('Pedido TuTi: Tienda ${_client.name}',
                  textAlign: TextAlign.center)),
          Expanded(
            child: ListView.builder(
                itemCount: _dispoItems.length,
                itemBuilder: (context, i) {
                  int suggestedOrderCeil = calculateSuggestedOrder(
                      _dispoItems[i].salesRatio,
                      _client.monthlySale,
                      _client.daysMonth,
                      _dispoItems[i].price,
                      _dispoItems[i].uxc,
                      _dispoItems[i].pallet);

                  return Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      color: Colors.white,
                      child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          border: _tableBorder(),
                          children: [
                            // HEADER
                            TableRow(children: [
                              _createColumn(
                                  text: 'Campo',
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Constant.secondaryColor),
                                  background: Constant.accentColorAlt),
                              _createColumn(
                                  text: 'Valor',
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Constant.secondaryColor),
                                  background: Constant.accentColorAlt),
                            ]),

                            // FREQUENCY
                            TableRow(children: [
                              _createColumn(text: 'Frecuencia'),
                              _createColumn(
                                  text: _dispoItems[i].frequency.toString())
                            ]),

                            // DISPO
                            TableRow(children: [
                              _createColumn(text: 'Dispo'),
                              _createColumn(
                                  text: _dispoItems[i].idDispo == 0
                                      ? 'Prueba'
                                      : '')
                            ]),

                            // COD ITEM
                            TableRow(children: [
                              _createColumn(text: 'Cod item'),
                              _createColumn(text: _dispoItems[i].codItem),
                            ]),

                            // ITEM
                            TableRow(children: [
                              _createColumn(text: 'Item'),
                              _createColumn(text: _dispoItems[i].description),
                            ]),

                            // PREVIOUS ORDER
                            TableRow(children: [
                              _createColumn(text: 'Pedido anterior'),
                              _createColumn(
                                  text: _lastOrderItem[
                                              _dispoItems[i].codItem] !=
                                          null
                                      ? _lastOrderItem[_dispoItems[i].codItem]
                                              ['amount']
                                          .toString()
                                      : '0'),
                            ]),

                            // WEEKLY DEMAND
                            TableRow(children: [
                              _createColumn(text: 'Demanda semanal (cajas)'),
                              _createColumn(
                                  text: suggestedOrderCeil != 0
                                      ? suggestedOrderCeil.toString()
                                      : 'N/A'),
                            ]),

                            // AMOUNT ORDER
                            TableRow(children: [
                              _createColumn(text: 'Pedido'),
                              Column(children: [
                                Container(
                                  padding: EdgeInsets.all(_paddingCell),
                                  width: double.infinity,
                                  child: Container(
                                    height: 40.0,
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[50],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    child: InputWithKeyboardControl(
                                      focusNode: _listFocus[i],
                                      cursorColor: Colors.blue,
                                      controller: _listController[i],
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
                              ])
                            ])
                          ]),
                    ),
                  );
                }),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                _goToOrderDetail(context);
              },
              child: const Text('Confirmar Pedido',
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
        ],
      );
    }
    return const Center(child: Text('No hay dispo de prueba para esta tienda'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: _listDispoProduct(context)),
      /*
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward_ios_rounded, color: Constant.primaryColor,),
        backgroundColor: Constant.accentColor,
        onPressed: () {
          _goToOrderDetail(context);
        },
      ),
      */
    );
  }

  TableBorder _tableBorder() {
    return const TableBorder(
        top: BorderSide(
            width: 1, color: Colors.black12, style: BorderStyle.solid),
        right: BorderSide(
            width: 1, color: Colors.black12, style: BorderStyle.solid),
        left: BorderSide(
            width: 1, color: Colors.black12, style: BorderStyle.solid),
        bottom: BorderSide(
            width: 1, color: Colors.black12, style: BorderStyle.solid),
        horizontalInside: BorderSide(
            width: 1, color: Colors.black12, style: BorderStyle.solid));
  }
}
