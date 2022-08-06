// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sqlite_ui/model/client_model.dart';
import 'package:sqlite_ui/db/db.dart';

class AddEditClient extends StatefulWidget {
  final bool edit;
  final Client client;

  const AddEditClient(this.edit, {required this.client}) : assert(edit == true);

  @override
  _AddEditClientState createState() => _AddEditClientState();
}

class _AddEditClientState extends State<AddEditClient> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //if you press the button to edit it must pass to true,
    //instantiate the name and phone in its respective controller, (link them to each controller)
    if (widget.edit == true) {
      nameEditingController.text = widget.client.name;
      phoneEditingController.text = widget.client.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.edit ? "Edit Client" : "Add client"),
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
                  size: 300,
                ),
                //if it is new record, it asks to enter data, : but it paints the data brought in the item
                textFormField(nameEditingController, "Name", "Enter Name",
                    Icons.person, widget.edit ? widget.client.name : "name"),
                textFormFieldPhone(
                  phoneEditingController,
                  "Phone",
                  "Enter phone",
                  Icons.person,
                  widget.edit ? widget.client.phone : "phone",
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
                      Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')));
                    } else if (widget.edit == true) {
                      Db.updateClient(Client(
                          name: nameEditingController.text,
                          phone: phoneEditingController.text,
                          id: widget.client.id));
                      Navigator.pop(context);
                    } else {
                      await Db.addClientToDatabase(Client(
                          id: 0,
                          name: nameEditingController.text,
                          phone: phoneEditingController.text));
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
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
