import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:app_api_sqlite/src/db/dispo_db.dart';
import 'package:app_api_sqlite/src/db/dispo_item_db.dart';
import 'package:app_api_sqlite/src/db/dispo_test_db.dart';
import 'package:app_api_sqlite/src/db/session_db.dart';
import 'package:app_api_sqlite/src/models/client_model.dart';
import 'package:app_api_sqlite/src/db/client_db.dart';
import 'package:app_api_sqlite/src/class/alert.dart';
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/models/dispo_model.dart';
import 'package:app_api_sqlite/src/models/dispo_item_model.dart';
import 'package:app_api_sqlite/src/models/dispo_test_model.dart';
import 'package:app_api_sqlite/src/models/session_model.dart';
import 'package:app_api_sqlite/src/resources/dispo_api_provider.dart';
import 'package:app_api_sqlite/src/resources/dispo_item_api_provider.dart';
import 'package:app_api_sqlite/src/resources/dispo_test_api_provider.dart';
import 'package:app_api_sqlite/src/resources/order_api_provider.dart';
import 'package:app_api_sqlite/src/ui/home/home.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginBody());
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  ImageProvider logo = const AssetImage('assets/images/logo.png');
  FocusNode focusNodeUser = FocusNode();
  FocusNode focusNodePass = FocusNode();

  final textControllerUser = TextEditingController();
  final textControllerPass = TextEditingController();
  final _url = '${Constant.basePoint}/auth/login/';

  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    focusNodeUser.dispose();
    focusNodePass.dispose();
    textControllerUser.dispose();
    textControllerPass.dispose();
    super.dispose();
  }

  void _requestFocus(FocusNode node) {
    setState(() {
      FocusScope.of(context).requestFocus(node);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Constant.lightTheme,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
              preferredSize:
                  const Size.fromHeight(0.0), // here the desired height
              child: AppBar(
                  backgroundColor: Constant.accentColor, elevation: 0.0)),
          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return Container(
                color: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Image(image: logo),
                    ),
                    const SizedBox(height: 20),
                    textFieldOutline(
                        label: 'Usuario',
                        controller: textControllerUser,
                        focusNode: focusNodeUser),
                    const SizedBox(height: 10),
                    textFieldPassOutline(
                        label: 'Contraseña',
                        controller: textControllerPass,
                        focusNode: focusNodePass),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Constant.accentColor)),
                        child: const Text(
                          'Iniciar sesión',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => _login(context),
                      ),
                    )
                  ],
                ),
              );
            }),
          )),
    );
  }

  Widget textFieldOutline(
      {String label = "Campo de texto",
      required TextEditingController controller,
      required FocusNode focusNode}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      cursorColor: Constant.accentColor,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Constant.accentColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Constant.accentColor),
        ),
        labelText: label,
        labelStyle: TextStyle(
            color: focusNode.hasFocus ? Constant.accentColor : Colors.black38),
      ),
      onTap: () => _requestFocus(focusNode),
    );
  }

  Widget textFieldPassOutline(
      {String label = "Campo de texto",
      required TextEditingController controller,
      required FocusNode focusNode}) {
    return TextField(
      controller: controller,
      obscureText: _isObscure,
      focusNode: focusNode,
      cursorColor: Constant.accentColor,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Constant.accentColor),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Constant.accentColor),
          ),
          labelText: label,
          labelStyle: TextStyle(
              color:
                  focusNode.hasFocus ? Constant.accentColor : Colors.black38),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility_off : Icons.visibility,
              color: focusNode.hasFocus ? Constant.accentColor : Colors.black38,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          )),
      onTap: () => _requestFocus(focusNode),
    );
  }

  void _login(BuildContext context) async {
    String user = textControllerUser.text;
    String password = textControllerPass.text;

    try {
      Alert.loaderDialog(context, 'Iniciando...');

      var url = Uri.parse(_url);
      var response = await http.post(url, body: {
        "user": user,
        "password": password,
      });
      final jsonResponse = json.decode(response.body);

      if (jsonResponse["status"] == 'success') {
        int idClient = jsonResponse['data']['id_cliente'];
        String name = jsonResponse['data']['nombre'];
        String codStore = jsonResponse['data']['user_cod_tienda'];
        double monthlySale =
            double.parse(jsonResponse['data']['venta_mensual']);
        int daysMonth = jsonResponse['data']['dias_del_mes'];
        String token = jsonResponse['data']['token'];

        bool exist =
            await ClientDB.exist(idClient: idClient, codStore: codStore);

        if (exist) {
          SessionDB.startSession(SessionModel(
            idClient: idClient,
            codStore: codStore,
            status: 'A',
          ));
        } else {
          ClientDB.insert(ClientModel(
              idClient: idClient,
              name: name,
              codStore: codStore,
              monthlySale: monthlySale,
              daysMonth: daysMonth,
              token: token));
          SessionDB.startSession(SessionModel(
              idClient: idClient,
              codStore: codStore,
              status: 'A',
              token: token));
        }

        await _downloadDispo(codStore, token);
        await _downloadDispoItem(codStore, token);
        await _downloadDispoTest(codStore, token);
        await _downloadLastOrder(codStore, token);

        Future.delayed(const Duration(milliseconds: Constant.delayTime), () {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Home()));
        });
      } else if (jsonResponse["status"] == 'fail') {
        Navigator.of(context).pop();
        _showErrorLogin(context, jsonResponse["msg"]);
      }
    } on Exception catch (e) {
      Navigator.of(context).pop();
      // ignore: avoid_print
      debugPrint('Login Exception: $e');
      _showErrorLogin(context, 'Ha ocurrido un error al iniciar sesión');
    }
  }

  void _showErrorLogin(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Future<bool> _downloadDispo(String codStore, String token) async {
    List<DispoModel> dispos = await DispoApiProvider.getDispo(codStore, token);
    if (dispos.isNotEmpty) {
      DispoDB.setCurrentStatus();
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
      DispoItemDB.setCurrentStatus();
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

  Future<bool> _downloadLastOrder(String codStore, String token) async {
    bool result = await OrderApiProvider.getLastOrder(codStore, token);
    return result;
  }
}
