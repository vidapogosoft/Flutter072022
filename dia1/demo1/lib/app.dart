import 'package:flutter/material.dart';

//importo mis clases que desarrollo
import 'pages/home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: Center(child: HomePage()));
  }
}
