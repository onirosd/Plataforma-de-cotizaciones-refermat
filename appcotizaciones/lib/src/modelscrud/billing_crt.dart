import 'package:appcotizaciones/src/models/autentication.dart';
import 'package:appcotizaciones/src/models/billing.dart';
import 'package:appcotizaciones/src/models/querys.dart';
import 'package:appcotizaciones/src/models/synclog.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class BillingCrt {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> updateBilling(Billing billing) async {
    // Get a reference to the database.
    final db = await con.db;

    // Update the given Dog.
    return await db.update(
      'Billing',
      billing.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'codBillingUniq = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [billing.codBillingUniq],
    );
  }

  Future<int> insertNewBilling(Billing billing) async {
    // Get a reference to the database.

    DateTime now = DateTime.now();
    String dateAndMoment = DateFormat('yyMMddkkmm').format(now);

    print(dateAndMoment);
    var dbCustomer = await con.db;
    var cod = billing.codCustomer.toString() +
        dateAndMoment; // esta es la lave de un registro nuevo
    billing.codBillingUniq = cod;
    // print(maxcodCustomer.first["last_inserted_id"]);

    var raw = await dbCustomer.insert(
      'Billing',
      billing.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<List<Billing>> getBillingsSincronice(int enablepreproc) async {
    var dbBilling = await con.db;
    String query = "";
    if (enablepreproc == 1) {
      query = "SELECT * FROM Billing WHERE flgState in (1, 5, 0) ";
    } else {
      query = "SELECT * FROM Billing WHERE flgState in (1, 5) ";
    }

    final List<Map<String, dynamic>> maps = await dbBilling.rawQuery(query);

    return maps.map((c) => Billing.fromMap(c)).toList();
  }

  Future<List<Billing>> getDataBillingsperCode(String codBillingUniq) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "SELECT * FROM Billing WHERE codBillingUniq = '${codBillingUniq.toString()}'");

    return maps.map((c) => Billing.fromMap(c)).toList();
  }

  Future<List<SelectBilling>> getSelectBillingByCustomer(
      String customer) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "select a.codBillingUniq id, dteBillingDate date, b.numRucCustomer ruc, c.strNameUser salesperson, case when a.flgState = 0 then 'pendiente' else 'Cerrado' end state, a.flgState as numstate  from Billing a inner join Customer b on a.codCustomer = b.codCustomer inner join Autentication c on a.codUser = c.codUser where b.codCustomer = '$customer' order by date(dteBillingDate) desc");

    return maps.map((c) => SelectBilling.fromMap(c)).toList();
  }
}
