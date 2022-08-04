// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Persona {
  final int id;
  final String name;
  final int age;

  const Persona({
    required this.id,
    required this.name,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  @override
  String toString() {
    return 'Persona{id: $id, name: $name, age: $age}';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // crear la base de datos
  final database =
      openDatabase(join(await getDatabasesPath(), 'persona_data.db'),
          onCreate: (db, version) {
    return db.execute(
        'create table persona(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)');
  }, version: 1);

  //Funcion de registro de datos
  Future<void> insertPersona(Persona per) async {
    //Hacer referencia a la base de datos
    final db = await database;

    await db.insert(
      'persona',
      per.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //funcion de update
  Future<void> updatePersona(Persona per) async {
    //Hacer referencia a la base de datos
    final db = await database;

    await db
        .update('persona', per.toMap(), where: 'id = ?', whereArgs: [per.id]);
  }

  //funcion de delete
  Future<void> deletePersona(int id) async {
    //Hacer referencia a la base de datos
    final db = await database;

    await db.delete('persona', where: 'id = ?', whereArgs: [id]);
  }

  //Funcion de lectura de datos
  Future<List<Persona>> personas() async {
    //Hacer referencia a la base de datos
    final db = await database;

    //Query de consulta de datos
    final List<Map<String, dynamic>> maps = await db.query('persona');

    //Conversion de la lista map de strings a Lista de model persona
    return List.generate(maps.length, (i) {
      return Persona(
          id: maps[i]['id'], name: maps[i]['name'], age: maps[i]['age']);
    });
  }

//print en consola de depuracion
//declaro la clase
  var vpr = const Persona(id: 0, name: 'Victor Portugal', age: 40);
  var vpr2 = const Persona(id: 1, name: 'Vidapogosoft', age: 40);
  var vpr3 = const Persona(id: 2, name: 'Vidapogosoft', age: 40);
  var vpr4 = const Persona(id: 3, name: 'Vidapogosoft', age: 40);

  //realizo la insercion de registros
  await insertPersona(vpr);
  await insertPersona(vpr2);
  await insertPersona(vpr3);
  await insertPersona(vpr4);

  //presento la lista
  print(await personas());

  //update de registros
  vpr3 = Persona(id: vpr3.id, name: 'Vidapogosoft - vpr', age: vpr3.age + 2);
  await updatePersona(vpr3);
  print(await personas());

  //Delete de registros
  await deletePersona(vpr4.id);
  print(await personas());
}
