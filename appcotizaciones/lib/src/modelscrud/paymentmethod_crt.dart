import 'package:appcotizaciones/src/models/bank.dart';
import 'package:appcotizaciones/src/models/company.dart';
import 'package:appcotizaciones/src/models/payCondition.dart';
import 'package:appcotizaciones/src/models/paymentMethod.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class PaymentMethodCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> insertPaymentMethod(PaymentMethod paymentmethod) async {
    // Get a reference to the database.

    var dbAuth = await con.db;
    await deletePaymentMethod(paymentmethod.codPaymentMethod!);

    var raw = await dbAuth.insert(
      'PaymentMethod',
      paymentmethod.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<int> deletePaymentMethod(int codPaymentMethod) async {
    var dbAuth = await con.db;
    String cod = codPaymentMethod.toString();
    final res = await dbAuth
        .rawDelete('DELETE FROM PaymentMethod WHERE codPaymentMethod = $cod');

    return res;
  }

  Future<List<PaymentMethod>> getDataPaymentMethods() async {
    var dbCustomer = await con.db;
    // String cod = codUser.toString();
    //List<Map<String, dynamic>> maps = [];

    //var person = await dbCustomer.rawQuery(
    //  "SELECT codPerson FROM Autentication where codUser = $cod LIMIT 1");
    //var codPerson =
    //  person.first["codPerson"] == null ? 0 : person.first["codPerson"];

    final List<Map<String, dynamic>> maps =
        await dbCustomer.rawQuery("SELECT * FROM PaymentMethod ");

    //if (maps2.first["codPerson"] != null) {
    //  maps = maps2;
    // }

    return maps.map((c) => PaymentMethod.fromMap(c)).toList();
  }
}
