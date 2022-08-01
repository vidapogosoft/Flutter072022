// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, unnecessary_new, avoid_print

import 'package:flutter/material.dart';

import 'package:flutter_componentes/src/pages/alert_page.dart';
import 'package:flutter_componentes/src/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Componentes APP',
      debugShowCheckedModeBanner: false,
      routes: getApplicationRoutes(),
      onGenerateRoute: (RouteSettings settings) {
        print('Ruta seleccinada: ${settings.name}');

        return MaterialPageRoute(
            builder: (BuildContext context) => AlertPage());
      },
    );
  }
}
