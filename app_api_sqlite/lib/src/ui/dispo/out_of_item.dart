import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/db/dispo_item_db.dart';
import 'package:app_api_sqlite/src/db/dispo_test_db.dart';
import 'package:app_api_sqlite/src/db/order_db.dart';
import 'package:app_api_sqlite/src/db/order_item_db.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';
import 'package:app_api_sqlite/src/route/route.dart';

class OutOfProduct extends StatefulWidget {
  const OutOfProduct({Key? key}) : super(key: key);

  @override
  _OutOfProductState createState() => _OutOfProductState();
}

class _OutOfProductState extends State<OutOfProduct> {
  List<Map> _listItem = [];
  List<TextEditingController> _listController = [];
  final InputWithKeyboardControlFocusNode _searchFocus =
      InputWithKeyboardControlFocusNode();
  final TextEditingController _itemController = TextEditingController();
  final double _paddingCell = 3.0;

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  Future<void> _searchItem(BuildContext context) async {
    String codItem = _itemController.text;
    List auxList = [];

    auxList = await _searchItemNormal(context, codItem);

    if (auxList.isEmpty) {
      auxList = await _searchItemTest(context, codItem);
    }

    if (auxList.isNotEmpty) {
      if (!_existInList(codItem)) {
        setState(() {
          _listItem.add(auxList[0]);
        });
        _itemController.text = '';
      } else {
        _showMessage(context, 'El item ya se encuentra en la lista');
      }
    } else {
      _showMessage(context, 'No se hallaron resultados');
    }
  }

  Future<List> _searchItemNormal(BuildContext context, String codItem) async {
    List auxDispoItems = await DispoItemDB.search(codItem);
    return auxDispoItems;
  }

  Future<List> _searchItemTest(BuildContext context, String codItem) async {
    List auxDispoItems = await DispoTestDB.search(codItem);
    return auxDispoItems;
  }

  bool _existInList(String codItem) {
    for (var item in _listItem) {
      if (item['cod_item'] == codItem) {
        return true;
      }
    }
    return false;
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

  void _deleteItem(int index) {
    setState(() {
      _listItem.removeAt(index);
      _listController.removeAt(index);
    });
  }

  Future<void> _createOrder() async {
    Map<String, dynamic> savedItems = {};
    if (_listItem.isNotEmpty) {
      int index = 0;
      for (var item in _listItem) {
        if (_listController[index].text != '0' &&
            _listController[index].text != '') {
          savedItems[item['cod_item']] = {
            'amount': _listController[index].text,
            'id_dispo': item['id_dispo']
          };
        }
        index++;
      }
    }
    if (savedItems.isNotEmpty) {
      int idOrder = await OrderDB.createOrder();
      Map result = await OrderItemDB.insertFromSearch(
          idOrder: idOrder, observacion: "AGOTADO", data: savedItems);
      if (result['status'] == 'success') {
        setState(() {
          _listItem = [];
          _listController = [];
        });
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.of(context).push(MyRoute.orders(context));
        _showMessage(context, 'Se ha guardado con éxito');
      }
    } else {
      _showMessage(context, 'No se ha ingresado ninguna cantidad');
    }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Código del item',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              height: 40.0,
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              child: InputWithKeyboardControl(
                focusNode: _searchFocus,
                onSubmitted: (value) {
                  _searchItem(context);
                },
                cursorColor: Colors.blue,
                controller: _itemController,
                width: double.infinity,
                startShowKeyboard: false,
                buttonColorEnabled: Colors.blue,
                buttonColorDisabled: Colors.black54,
                underlineColor: Colors.blue,
                showButton: true,
                showUnderline: false,
              ),
            ),

            const SizedBox(height: 5.0),

            // BUTTON SEARCH
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _searchItem(context);
                },
                child:
                    const Text('Buscar', style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Constant.accentColor),
                  overlayColor: MaterialStateProperty.all(Colors.white30),
                ),
              ),
            ),

            _listItem.isNotEmpty
                ? SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        _createOrder();
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
                  )
                : const SizedBox(),

            // LISTVIEW
            _listItem.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _listItem.length,
                      itemBuilder: (context, i) {
                        TextEditingController controller =
                            TextEditingController(text: '');
                        _listController.add(controller);

                        //InputWithKeyboardControlFocusNode focus = InputWithKeyboardControlFocusNode();

                        final item = _listItem[i]['cod_item'].toString();
                        return Dismissible(
                          key: Key(item),
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            alignment: AlignmentDirectional.centerStart,
                            margin: const EdgeInsets.all(5.0),
                            color: Colors.red,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 0.0,
                              ),
                              child: Icon(Icons.delete,
                                  color: Colors.white, size: 30.0),
                            ),
                          ),
                          onDismissed: (direction) {
                            _deleteItem(i);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 5.0),
                            child: Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FractionColumnWidth(0.4),
                                1: FractionColumnWidth(0.6)
                              },
                              border: _tableBorder(),
                              children: [
                                // HEADER
                                TableRow(children: [
                                  _createColumn(
                                      text: 'Campo',
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      background: Constant.accentColorAlt),
                                  _createColumn(
                                      text: 'Valor',
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      background: Constant.accentColorAlt),
                                ]),

                                // BODY
                                TableRow(children: [
                                  _createColumn(text: 'Dispo'),
                                  _createColumn(
                                      text: _listItem[i]['id_dispo'] != 0
                                          ? _listItem[i]['id_dispo'].toString()
                                          : 'Prueba'),
                                ]),
                                TableRow(children: [
                                  _createColumn(text: 'Cod item'),
                                  _createColumn(text: _listItem[i]['cod_item']),
                                ]),
                                TableRow(children: [
                                  _createColumn(text: 'Item'),
                                  _createColumn(
                                      text: _listItem[i]['description']),
                                ]),
                                TableRow(children: [
                                  _createColumn(text: 'Pedido'),
                                  Column(children: [
                                    Container(
                                      padding: EdgeInsets.all(_paddingCell),
                                      child: Container(
                                        height: 50.0,
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey[50],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5.0)),
                                        ),
                                        child: TextField(
                                            cursorColor: Constant.accentColor,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            controller: _listController[i]),
                                        /*InputWithKeyboardControl(
                                          focusNode: focus,
                                          onSubmitted: (value) {
                                            _searchItem(context);
                                          },
                                          cursorColor: Colors.blue,
                                          controller: _listController[i],
                                          width: double.infinity,
                                          startShowKeyboard: false,
                                          buttonColorEnabled: Colors.blue,
                                          buttonColorDisabled: Colors.black54,
                                          underlineColor: Colors.blue,
                                          showButton: true,
                                          showUnderline: false,
                                        ),*/
                                      ),
                                    )
                                  ]),
                                ]),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(child: Container(color: Colors.transparent))
          ],
        ),
      ),
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
