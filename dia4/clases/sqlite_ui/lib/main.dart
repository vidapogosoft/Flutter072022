// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sqlite_ui/add_client.dart';
import 'package:sqlite_ui/add_editclient.dart';

import 'package:sqlite_ui/model/client_model.dart';
import 'package:sqlite_ui/db/db.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SqFlite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Sqlite"),
          actions: <Widget>[
            RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Db.deleteAllClient();
                setState(() {});
              },
              child: const Text('Delete All',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.white)),
            )
          ],
        ),
        body: FutureBuilder<List<Client>>(
          future: Db.getallClients(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    Client item = snapshot.data![index];
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(color: Colors.red),
                      onDismissed: (diretion) {
                        Db.deleteClientWithId(item.id);
                      },
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(item.phone),
                        leading: CircleAvatar(child: Text(item.id.toString())),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddEditClient(
                                    true,
                                    client: item,
                                  )));
                        },
                      ),
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddClient()));
            }));
  }
}
