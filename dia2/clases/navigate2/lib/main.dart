// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      title: 'Routes screens',
      //iniciar la aplicacion con la ruta especificada
      //Definimos el inicio de la pantalla
      initialRoute: '/',
      routes: {
        // Cuando naveguemos hacia la ruta "/", crearemos el Widget FirstScreen
        '/': (context) => const FirstScreen(),
        // Cuando naveguemos hacia la ruta "/second", crearemos el Widget SecondScreen
        '/second': (context) => const SecondScreen(),
      }));
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Screen')),
      body: Center(
          child: RaisedButton(
        child: const Text('Launch Screen'),
        onPressed: () {
          // Navega a la segunda pantalla usando una ruta con nombre
          Navigator.pushNamed(context, '/second');
        },
      )),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: Center(
          child: RaisedButton(
        child: const Text('Go Back!!!'),
        onPressed: () {
          // Navega de regreso a la primera pantalla haciendo clic en la ruta actual
          // fuera de la pila
          Navigator.pop(context);
        },
      )),
    );
  }
}
