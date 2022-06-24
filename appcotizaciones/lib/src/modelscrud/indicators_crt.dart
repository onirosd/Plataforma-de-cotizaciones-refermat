import 'package:appcotizaciones/src/models/company.dart';
import 'package:appcotizaciones/src/models/indicators.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class IndicatorsCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<List<Ti_IndicatorsUser>> getDataIndicators() async {
    var dbProduct = await con.db;
    //var res = await dbProduct.query("DeliveryType");

    final List<Map<String, dynamic>> maps =
        await dbProduct.query("Ti_IndicatorsUser");

    return maps.map((c) => Ti_IndicatorsUser.fromMap(c)).toList();
  }

  Future<int> insertIndicators(Ti_IndicatorsUser indicator) async {
    // Get a reference to the database.

    var dbSqllite = await con.db;
    //var maxcodCustomer = await dbCustomer.rawQuery(
    //   "SELECT MAX(codUser)+1 as last_inserted_id FROM Autentication");
    //var cod = maxcodCustomer.first["last_inserted_id"] == null
    //   ? 1
    //   : maxcodCustomer.first["last_inserted_id"];

    // autentication.codUser = cod;
    // print(maxcodCustomer.first["last_inserted_id"]);

    await deleteIndicators();

    var raw = await dbSqllite.insert(
      'Ti_IndicatorsUser',
      indicator.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  deleteIndicators() async {
    var dbSqllite = await con.db;
    //String cod = codCompany.toString();
    final res = await dbSqllite.rawDelete('DELETE FROM Ti_IndicatorsUser');

    //  return res;
  }
}
