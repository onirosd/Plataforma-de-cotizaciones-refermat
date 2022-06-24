import 'package:appcotizaciones/src/models/bank.dart';
import 'package:appcotizaciones/src/models/billingType.dart';
import 'package:appcotizaciones/src/models/company.dart';
import 'package:appcotizaciones/src/models/payCondition.dart';
import 'package:appcotizaciones/src/models/paymentMethod.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class BillingTypeCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> insertBillingType(BillingType billingtype) async {
    // Get a reference to the database.

    var dbAuth = await con.db;
    await deleteBillingType(billingtype.codBillingType!);

    var raw = await dbAuth.insert(
      'BillingType',
      billingtype.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<int> deleteBillingType(int codBillingType) async {
    var dbAuth = await con.db;
    String cod = codBillingType.toString();
    final res = await dbAuth
        .rawDelete('DELETE FROM BillingType WHERE codBillingType = $cod');

    return res;
  }

  Future<List<BillingType>> getDataBillingType() async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps =
        await dbCustomer.rawQuery("SELECT * FROM BillingType ");

    return maps.map((c) => BillingType.fromMap(c)).toList();
  }
}
