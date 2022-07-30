// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Demo navigate screen with routes',
        theme: ThemeData(primarySwatch: Colors.orange),
        routes: <String, WidgetBuilder>{
          "/inicio": (BuildContext context) => const Inicio(),
          "/empresa": (BuildContext context) => const Empresa(),
          "/productos": (BuildContext context) => const Productos(),
        },
        home: const Inicio());
  }
}

class Productos extends StatelessWidget {
  const Productos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PRODUCTOS")),
      body: const Center(
        child: Text("SECCCION DE PANTALLA DE PRODUCTOS"),
      ),
    );
  }
}

class Empresa extends StatelessWidget {
  const Empresa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EMPRESA")),
      body: const Center(
        child: Text("SECCCION DE PANTALLA DE EMPRESA"),
      ),
    );
  }
}

class Inicio extends StatelessWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PANTALLA PRINCIPAL")),
      body: Container(
        padding:
            const EdgeInsets.only(top: 100, bottom: 50, right: 10, left: 10),
        decoration: const BoxDecoration(
            color: Colors.indigo,
            image: DecorationImage(
                image: NetworkImage(
                    "https://vendedoresenlinea.com/assets/images/logo-dark.png"),
                alignment: Alignment.topCenter)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          Navigator.pushNamed(context, "/inicio");
                        },
                        child: const SizedBox(
                          width: 120,
                          height: 80,
                          child: Center(
                            child: Text(
                              "INICIO",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          Navigator.pushNamed(context, "/empresa");
                        },
                        child: const SizedBox(
                          width: 120,
                          height: 80,
                          child: Center(
                            child: Text(
                              "EMPRESA",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          Navigator.pushNamed(context, "/productos");
                        },
                        child: const SizedBox(
                          width: 120,
                          height: 80,
                          child: Center(
                            child: Text(
                              "PRODUCTOS",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
