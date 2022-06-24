import 'package:appcotizaciones/src/models/bank.dart';
import 'package:appcotizaciones/src/models/company.dart';
import 'package:appcotizaciones/src/models/payCondition.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class PayConditionCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> insertPayCondition(PayCondition paycondition) async {
    // Get a reference to the database.

    var dbAuth = await con.db;
    await deletePayCondition(paycondition.codPayCondition!);

    var raw = await dbAuth.insert(
      'PayCondition',
      paycondition.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<int> deletePayCondition(int codPayCondition) async {
    var dbAuth = await con.db;
    String cod = codPayCondition.toString();
    final res = await dbAuth
        .rawDelete('DELETE FROM PayCondition where codPayCondition = $cod');

    return res;
  }

  Future<List<PayCondition>> getDataPayCondition() async {
    var dbProduct = await con.db;
    var res = await dbProduct.query("PayCondition");
    // final List<Map<String, dynamic>> maps =
    //   await dbProduct.rawQuery("SELECT * FROM DeliveryTime ");

    final List<Map<String, dynamic>> maps =
        await dbProduct.query("PayCondition");

    return maps.map((c) => PayCondition.fromMap(c)).toList();
  }
}
