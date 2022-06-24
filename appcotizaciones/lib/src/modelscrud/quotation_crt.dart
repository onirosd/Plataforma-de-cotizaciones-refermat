import 'package:appcotizaciones/src/helpers/database_helper.dart';
//import 'package:appcotizaciones/src/models/Quotation.dart';
import 'package:appcotizaciones/src/models/querys.dart';
import 'package:appcotizaciones/src/models/quotation_model.dart';
import 'package:appcotizaciones/src/models/quotationv0.dart';
import 'package:sqflite/sqflite.dart' as sql;
//import 'package:flutter/material.dart';

class QuotationCrt0 {
  DatabaseHelper con = new DatabaseHelper();

  Future<List<Quotationv0>> getQuotationByCustomer(int customer) async {
    var dbCustomer = await con.db;
    final List<Map<String, dynamic>> maps = await dbCustomer
        .query('Customer', where: 'codCustomer', whereArgs: ['$customer']);

    return maps.map((c) => Quotationv0.fromMap(c)).toList();
  }

  Future<List<SelectQuotation>> getSelectQuotationByCustomer(
      String customer) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "select a.id, b.numRucCustomer as ruc, a.dateQuotation as fec, count(c.id) as prods, '' as state, cast(a.state as int) as numstate, a.total from quotation a inner join customer b on cast(b.codCustomer as TEXT) = a.customerId inner join QuotationProducts c on a.id = c.quotation_id where b.codCustomer = '$customer' group by a.id, b.numRucCustomer, a.dateQuotation, cast(a.state as int) order by date(a.dateQuotation)  desc");

    //List<String>
    return maps.map((c) => SelectQuotation.fromMap(c)).toList();
  }
}

class QuotationCrt {
  DatabaseHelper con = new DatabaseHelper();

  // ADD QUOTATION PRODUCT
  Future<int> insertQuotation(Quotation item) async {
    final db = await await con.db;
    var res = await db.insert("Quotation", item.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print(res);
    return res;
  }

  Future<List<Quotation>> getDataQuotationsperCode(String codQuotation) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "SELECT * FROM Quotation WHERE id = '${codQuotation.toString()}'");

    return maps.map((c) => Quotation.fromMap(c)).toList();
  }

  Future<int> updateQuotation(Quotation quotation) async {
    // Get a reference to the database.
    final db = await con.db;

    // Update the given Dog.
    return await db.update(
      'Quotation',
      quotation.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [quotation.id],
    );
  }

  Future<List<Quotation>> getQuotationSincronice(int enablepreproc) async {
    var dbQuotation = await con.db;
    String query = "";

    if (enablepreproc == 1) {
      query = "SELECT * FROM Quotation WHERE state in ('1', '5', '0') ";
    } else {
      query = "SELECT * FROM Quotation WHERE state in ('1', '5') ";
    }

    final List<Map<String, dynamic>> maps = await dbQuotation.rawQuery(query);

    return maps.map((c) => Quotation.fromMap(c)).toList();
  }
}
