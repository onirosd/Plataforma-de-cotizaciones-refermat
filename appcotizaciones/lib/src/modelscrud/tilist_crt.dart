import 'package:appcotizaciones/src/models/tilist.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class TiListCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> insertTiList(TiList tilist) async {
    // Get a reference to the database.

    var dbCustomer = await con.db;
    //var maxcodCustomer = await dbCustomer.rawQuery(
    //   "SELECT MAX(codUser)+1 as last_inserted_id FROM Autentication");
    //var cod = maxcodCustomer.first["last_inserted_id"] == null
    //   ? 1
    //   : maxcodCustomer.first["last_inserted_id"];

    // autentication.codUser = cod;
    // print(maxcodCustomer.first["last_inserted_id"]);

    await deleteTiList(tilist.codList!);

    var raw = await dbCustomer.insert(
      'Ti_List',
      tilist.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<int> deleteTiList(int codList) async {
    var dbAuth = await con.db;
    String cod = codList.toString();
    final res =
        await dbAuth.rawDelete('DELETE FROM Ti_List where codList = $cod');

    return res;
  }
}
