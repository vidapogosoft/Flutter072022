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
      title: 'Form Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Form Validation demo')),
        body: const MyCustomForm(),
      ),
    );
  }
}

// Crea un Widget Form
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Crea una clase State correspondiente. Esta clase contendrá los datos relacionados con
// el formulario.
class MyCustomFormState extends State<MyCustomForm> {
  // Crea una clave global que identificará de manera única el widget Form
  // y nos permita validar el formulario

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Ingrese algun valor';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // devolverá true si el formulario es válido, o falso si
                // el formulario no es válido.
                if (_formKey.currentState!.validate()) {
                  // Si el formulario es válido, queremos mostrar un Snackbar
                  Scaffold.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')));
                }
              },
              child: const Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}
