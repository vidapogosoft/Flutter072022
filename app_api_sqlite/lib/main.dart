import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_api_sqlite/src/db/db.dart';
import 'package:app_api_sqlite/src/db/session_db.dart';
import 'package:app_api_sqlite/src/ui/home/home.dart';
import 'package:app_api_sqlite/src/ui/auth/login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  void deleteDb() async {
    await Db.deleteDataBase();
  }

  Future<bool> _hasActiveSession() async {
    bool result = await SessionDB.hasActiveSession();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/images/logo.png"), context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));

    return MaterialApp(
      title: 'Pedidos App',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _hasActiveSession(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return const Home();
              }
            }
            return const Login();
          } else {
            return const Scaffold(
              body: Center(child: Text('')),
            );
          }
        },
      ),
    );
  }
}
