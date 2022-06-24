import 'package:appcotizaciones/src/models/bank.dart';
import 'package:appcotizaciones/src/models/company.dart';
import 'package:appcotizaciones/src/models/lastAutentication.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class LastAutenticationCrt {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> delAllLastAutentication() async {
    var dbAuth = await con.db;
    //String cod = codDeliveryType.toString();
    final res = await dbAuth.rawDelete('DELETE FROM LastAutentication');

    return res;
  }

  Future<int> delLastAutentication(int codUser) async {
    var dbAuth = await con.db;
    //String cod = codDeliveryType.toString();
    final res = await dbAuth.rawDelete(
        'DELETE FROM LastAutentication WHERE codUser = ${codUser.toString()}');

    return res;
  }

  Future<int> insLastAutentication(LastAutentication lastautentication) async {
    // Get a reference to the database.
    var dbCustomer = await con.db;
    //await deleteDeliveryType(deliverytype.id);

    var raw = await dbCustomer.insert(
      'LastAutentication',
      lastautentication.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<List<LastAutentication>> getLastAutentication(int codUser) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "SELECT * FROM LastAutentication WHERE codUser = ${codUser.toString()}");

    return maps.map((c) => LastAutentication.fromMap(c)).toList();
  }

  Future<int> updLastAutentication(LastAutentication lastautentication) async {
    // Get a reference to the database.
    final db = await con.db;

    // Update the given Dog.
    return await db.update(
      'LastAutentication',
      lastautentication.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'codUser = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [lastautentication.codUser],
    );
  }
}
