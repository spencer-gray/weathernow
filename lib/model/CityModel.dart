import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'db_utils.dart';
import 'city.dart';

class CityModel {  
  Future<int> insertCity(City city) async {
    final db = await DBUtils.init();
    return await db.insert(
      'citiesdb',
      city.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateCity(City city) async {
    final db = await DBUtils.init();
    return await db.update(
      'citiesdb',
      city.toMap(), // data to replace with
      where: 'id = ?',
      whereArgs: [city.id],
    );
  }

  Future<int> deleteCityById(int id) async {
    final db = await DBUtils.init();
    return await db.delete(
      'citiesdb',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<City>> getAllCities() async {
    final db = await DBUtils.init();
    List<Map<String,dynamic>> maps = await db.query('citiesdb');
    List<City> cities = [];
    for (int i = 0; i < maps.length; i++) {
      cities.add(City.fromMap(maps[i]));
    }
    return cities;
  }

  Future<City> getCityWithId(int id) async {
    final db = await DBUtils.init();
    List<Map<String,dynamic>> maps = await db.query(
      'citiesdb',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return City.fromMap(maps[0]);
    } else {
      return null;
    }
  }
}