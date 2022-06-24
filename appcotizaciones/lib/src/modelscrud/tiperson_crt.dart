import 'package:appcotizaciones/src/models/tilist.dart';
import 'package:appcotizaciones/src/models/tiperson.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class TiPersonCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> insertTiPerson(TiPerson tiperson) async {
    // Get a reference to the database.
    var dbCustomer = await con.db;
    await deleteTiPerson(tiperson.codPerson!);

    var raw = await dbCustomer.insert(
      'Ti_Person',
      tiperson.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<int> deleteTiPerson(int codPerson) async {
    var dbAuth = await con.db;
    String cod = codPerson.toString();
    final res =
        await dbAuth.rawDelete('DELETE FROM Ti_Person where codPerson = $cod');

    return res;
  }

  Future<List<TiPerson>> getdataPersonfromUser(int codUser) async {
    var dbCustomer = await con.db;
    String cod = codUser.toString();
    //List<Map<String, dynamic>> maps = [];

    var person = await dbCustomer.rawQuery(
        "SELECT codPerson FROM Autentication where codUser = $cod LIMIT 1");
    var codPerson =
        person.first["codPerson"] == null ? 0 : person.first["codPerson"];

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "SELECT * FROM Ti_Person WHERE codPerson = $codPerson LIMIT 1");

    //if (maps2.first["codPerson"] != null) {
    //  maps = maps2;
    // }

    return maps.map((c) => TiPerson.fromMap(c)).toList();
  }

  Future<TiPerson> getdataPersonfromUser_V2(int codUser) async {
    var dbCustomer = await con.db;
    String cod = codUser.toString();
    List<Map<String, dynamic>> maps = [];
    TiPerson tiperson = new TiPerson(
        codPerson: 0, strCelphone: "", strDesPerson: "", strPosition: "");

    var person = await dbCustomer.rawQuery(
        "SELECT codPerson FROM Autentication where codUser = $cod LIMIT 1");
    var codPerson =
        person.first["codPerson"] == null ? 0 : person.first["codPerson"];

    final List<Map<String, dynamic>> maps2 = await dbCustomer.rawQuery(
        "SELECT * FROM Ti_Person WHERE codPerson = $codPerson LIMIT 1");

    if (maps2.first["codPerson"] != null) {
      tiperson.codPerson = maps2.first["codPerson"];
      tiperson.strCelphone = maps2.first["strCelphone"];
      tiperson.strDesPerson = maps2.first["strDesPerson"];
      tiperson.strPosition = maps2.first["strPosition"];
    }

    return tiperson;
  }
}
