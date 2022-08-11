// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';

class Fotos extends StatefulWidget {
  const Fotos({Key? key}) : super(key: key);

  @override
  _FotosState createState() => _FotosState();
}

class _FotosState extends State<Fotos> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_setImageView()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSelectionDialog(context);
        },
        child: const Icon(Icons.photo_album),
      ),
    );
  }

  Widget _setImageView() {
    if (imageFile != null) {
      return Image.file(imageFile!, width: 500, height: 500);
    } else {
      return const Text("Selecciona una imagen");
    }
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Seleccionar Foto"),
              content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  GestureDetector(
                    child: const Text("Gallery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: const Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ]),
              ));
        });
  }

  void _openGallery(BuildContext context) async {
    var picture = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(picture!.path);
    });
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    var picture = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(picture!.path);
    });
    Navigator.of(context).pop();
  }
}
