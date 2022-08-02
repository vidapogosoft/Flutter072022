import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Form Get text demo')),
        body: const MyCustomForm(),
      ),
    );
  }
}

// Define un widget de formulario personalizado
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define la clase State correspondiente. Esta clase contendrá los datos relacionados con
// nuestro formulario.
class _MyCustomFormState extends State<MyCustomForm> {
// Crea un controlador de texto. Lo usaremos para recuperar el valor actual
  // del TextField!
  final myController = TextEditingController();

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get Text Forms')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Cuando el usuario pulsa el botón, muestra un diálogo de alerta con el
        // texto que el usuario ha digitado en nuestro campo de texto.
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Recupera el texto que el usuario ha digitado utilizando nuestro
                // TextEditingController
                content: Text(myController.text),
              );
            }),
        tooltip: 'Revisar valor ingresado',
        child: const Icon(Icons.access_alarms),
      ),
    );
  }
}
