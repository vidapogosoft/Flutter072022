// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sqlite_ui/main.dart';
import 'package:sqlite_ui/model/client_model.dart';
import 'package:sqlite_ui/db/db.dart';

class AddClient extends StatefulWidget {
  const AddClient({Key? key}) : super(key: key);

  @override
  _AddClientState createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add client"),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      const FlutterLogo(
                        size: 150,
                      ),
                      textFormField(nameEditingController, "Name", "Enter Name",
                          Icons.person, "name"),
                      textFormFieldPhone(
                        phoneEditingController,
                        "Phone",
                        "Enter phone",
                        Icons.person,
                        "phone",
                      ),
                      RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.white),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            Scaffold.of(context).showSnackBar(const SnackBar(
                                content: Text('Processing Data')));
                          } else {
                            await Db.addClientToDatabase(Client(
                                id: 0,
                                name: nameEditingController.text,
                                phone: phoneEditingController.text));
                            //Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                          }
                        },
                      )
                    ])))));
  }

  textFormField(TextEditingController t, String label, String hint,
      IconData iconData, String initialValue) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: TextFormField(
        controller: t,
        //keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
            prefixIcon: Icon(iconData),
            hintText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  textFormFieldPhone(TextEditingController t, String label, String hint,
      IconData iconData, String initialValue) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: TextFormField(
        controller: t,
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
            prefixIcon: Icon(iconData),
            hintText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
