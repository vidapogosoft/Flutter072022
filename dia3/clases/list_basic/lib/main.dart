import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final titlevar = 'Basic List demo';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: titlevar,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('List View'),
          ),
          body: ListView(
            children: const <Widget>[
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Map'),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('Email'),
              ),
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Folder'),
              ),
              ListTile(
                leading: Icon(Icons.plus_one),
                title: Text('Plus'),
              ),
            ],
          ),
        ));
  }
}
