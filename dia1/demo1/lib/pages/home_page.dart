import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Titulo del App demo'), centerTitle: true),
        body: Center(child: Text('Curso de Flutter')),
      );
}
