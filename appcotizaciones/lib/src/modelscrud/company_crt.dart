import 'package:appcotizaciones/src/models/company.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class CompanyCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<List<Company>> getAllCompany() async {
    var dbConnection = await con.db;
    //String cod = codCompany.toString();
    final List<Map<String, dynamic>> maps =
        await dbConnection.rawQuery("select * from Company");

    return maps.map((c) => Company.fromMap(c)).toList();
  }

  Future<List<Company>> getCompany(String codCompany) async {
    var dbConnection = await con.db;
    String cod = codCompany.toString();
    final List<Map<String, dynamic>> maps = await dbConnection
        .rawQuery("select * from Company where codCompany = $cod ");

    return maps.map((c) => Company.fromMap(c)).toList();
  }

  Future<int> insertCompany(Company company) async {
    // Get a reference to the database.

    var dbConnection = await con.db;
    //var maxcodCustomer = await dbCustomer.rawQuery(
    //   "SELECT MAX(codUser)+1 as last_inserted_id FROM Autentication");
    //var cod = maxcodCustomer.first["last_inserted_id"] == null
    //   ? 1
    //   : maxcodCustomer.first["last_inserted_id"];

    // autentication.codUser = cod;
    // print(maxcodCustomer.first["last_inserted_id"]);

    await deleteCompany(company.codCompany!);

    var raw = await dbConnection.insert(
      'Company',
      company.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<int> deleteCompany(int codCompany) async {
    var dbConnection = await con.db;
    String cod = codCompany.toString();
    final res = await dbConnection
        .rawDelete('DELETE FROM Company where codCompany = $cod');

    return res;
  }

  Future<int> deleteAllCompany() async {
    var dbAuth = await con.db;
    final res = await dbAuth.rawDelete('DELETE FROM Company');

    return res;
  }
}
