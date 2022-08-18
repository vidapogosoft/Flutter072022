import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Db {
  static Future<String> getPathDb() async {
    String path = join(await getDatabasesPath(), 'tuti_handheld.db');
    return path;
  }

  static deleteDataBase() async {
    String path = await getPathDb();
    await deleteDatabase(path);
  }

  static Future<Database> openDB() async {
    String path = await getPathDb();
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("""
          CREATE TABLE tuti_client (
            id_client INTEGER PRIMARY KEY, 
            name TEXT,
            cod_store TEXT,
            monthly_sale REAL,
            days_month INTEGER,
             token TEXT
          )""");
      await db.execute("""
          CREATE TABLE tuti_session (
            id_session INTEGER PRIMARY KEY AUTOINCREMENT,
            id_client INTEGER NOT NULL,
            cod_store TEXT NOT NULL,
            status TEXT DEFAULT 'A',
            creation_date TEXT NOT NULL,
            token TEXT
          )""");
      await db.execute("""
          CREATE TABLE tuti_dispo (
            tuti_dispo_id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_dispo INTEGER NOT NULL, 
            name TEXT, 
            current TEXT DEFAULT 'Y'
          )""");
      await db.execute("""
          CREATE TABLE tuti_dispo_item (
            tuti_dispo_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_dispo_item INTEGER NOT NULL, 
            cod_item TEXT NOT NULL,
            description TEXT NOT NULL,
            uxc INTEGER NOT NULL,
            pallet INTEGER,
            sales_ratio REAL,
            price REAL,
            id_dispo INTEGER,
            current TEXT DEFAULT 'Y',
            frequency INTEGER,
            creation_date TEXT NOT NULL
          )""");
      await db.execute("""
          CREATE TABLE tuti_dispo_test (
            id_dispo_test INTEGER PRIMARY KEY AUTOINCREMENT,
            cod_store TEXT NOT NULL,
            id_dispo INTEGER,
            cod_item TEXT NOT NULL,
            description TEXT NOT NULL,
            uxc INTEGER NOT NULL,
            pallet INTEGER,
            sales_ratio REAL,
            price REAL,
            current TEXT DEFAULT 'Y',
            frequency INTEGER,
            creation_date TEXT NOT NULL
          )""");
      await db.execute("""
          CREATE TABLE tuti_order (
            id_order INTEGER PRIMARY KEY AUTOINCREMENT, 
            cod_store TEXT NOT NULL,
            send TEXT DEFAULT 'N',
            status TEXT DEFAULT 'A',
            creation_date TEXT NOT NULL,
            send_date TEXT
          )""");
      await db.execute("""
          CREATE TABLE tuti_order_item (
            id_order_item INTEGER PRIMARY KEY AUTOINCREMENT,
            id_order INTEGER NOT NULL,
            id_dispo INTEGER NOT NULL,
            sku TEXT NOT NULL,
            amount INTEGER NOT NULL,
            status TEXT DEFAULT 'A',
            creation_date TEXT NOT NULL,
             observacion TEXT
          )""");
    });
    return database;
  }
}
