import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/printer.dart';

class MyDatabase {
  static final dbName = "printers.db";
  static final table = "printers";
  static Database _db;

  static Future<Database> get db async {
    if (_db == null) {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, dbName);
      _db = await openDatabase(path);
      try {
        await _db.execute(
            "CREATE TABLE $table (id INTEGER PRIMARY KEY, name TEXT, url TEXT)");
        await _db.rawInsert('INSERT INTO printers (name, url) VALUES (?, ?)', ['Envy 5540', '192.168.0.47']);
        await _db.rawInsert('INSERT INTO printers (name, url) VALUES (?, ?)', ['Envy 3383', '192.168.0.112']);
      }catch (e){
        print("table already exists");
      }
    }
    return _db;
  }

  static Future<List<Printer>> getPrinters() async {
    List<Printer> result = List<Printer>();
    var records = await (await db).query(table);
    if (records.length > 0) {
       records.forEach((element) {
          result.add(Printer(element['name'], element['url']));
       });
    }
    return result;
  }

  static Future<bool> insertPrinter(Printer printer) async {
    var __db = await db;
    var id = await __db.insert(table, {"name": printer.name, "url": printer.url});
    return id > 0;
  }
}
