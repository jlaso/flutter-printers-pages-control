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
      String query;
      _db = await openDatabase(
          path,
          version: 2,
          onUpgrade: (Database db, int oldVersion, int newVersion) async {
            while (newVersion > oldVersion) {
              switch (oldVersion) {
                case 1:
                  {
                    query = "ALTER TABLE $table ADD COLUMN plan_name TEXT;"
                        "ALTER TABLE $table ADD COLUMN pages_plan INT;"
                        "ALTER TABLE $table ADD COLUMN pages_accum INT;"
                        "ALTER TABLE $table ADD COLUMN pages_curr INT;"
                        "ALTER TABLE $table ADD COLUMN invoicing_day INT";
                    break;
                  }
              }
              await db.execute(query);
              oldVersion++;
            }
          },
          onCreate: (Database db, int version) async {
            switch (version) {
              case 1:
                {
                  query =
                  "CREATE TABLE $table (id INTEGER PRIMARY KEY, name TEXT, url TEXT)";
                  break;
                }
              case 2:
                {
                  query =
                  "CREATE TABLE $table (id INTEGER PRIMARY KEY, name TEXT, url TEXT, "
                      "plan_name TEXT, pages_plan INT, pages_accum INT, pages_curr INT, invoicing_day INT)";
                  break;
                }
              default:
                query = null;
            }
            if (query != null) {
              await db.execute(query);
            }
          }
      );
    }
    return _db;
  }

  static Future<List<Printer>> getPrinters() async {
    List<Printer> result = List<Printer>();
    var records = await (await db).query(table);
    if (records.length > 0) {
       records.forEach((element) {
          result.add(Printer(element['name'], element['url'], element['id']));
       });
    }
    return result;
  }

  static Future<Printer> getPrinter(int id) async {
    var records = await (await db).query(table, where: "id = ?", whereArgs: [id]);
    if (records.length > 0) {
      return Printer.fromMap(records[0]);
    }
    return null;
  }

  static Future<bool> insertPrinter(Printer printer) async {
    var __db = await db;
    if (printer.id != 0){
      await __db.delete(table, where: "id = ?", whereArgs: [printer.id]);
    }
    var id = await __db.insert(table, printer.toMap());
    return id > 0;
  }
}
