import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils {
  static Future<Database> init() async {
    return openDatabase(
      path.join(await getDatabasesPath(), 'citiesdb.db'),
      onCreate: (db, version) {
        if (version > 1) {
          // downgrade path
        }
        db.execute('CREATE TABLE citiesdb(id INTEGER PRIMARY KEY, name TEXT, latitude TEXT, longitude TEXT)');
      },
      version: 1,
    );
  }
}