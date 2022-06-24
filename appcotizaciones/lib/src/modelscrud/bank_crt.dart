import 'package:appcotizaciones/src/models/bank.dart';
import 'package:appcotizaciones/src/models/company.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class BankCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> insertBank(Bank bank) async {
    // Get a reference to the database.

    var dbauth = await con.db;
    await deleteBank(bank.codBank!);

    var raw = await dbauth.insert(
      'Bank',
      bank.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<int> deleteBank(int codBank) async {
    var dbAuth = await con.db;
    String cod = codBank.toString();
    final res = await dbAuth.rawDelete('DELETE FROM Bank where codBank = $cod');

    return res;
  }

  Future<List<Bank>> getDataBanks() async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps =
        await dbCustomer.rawQuery("SELECT * FROM Bank ");

    return maps.map((c) => Bank.fromMap(c)).toList();
  }
}
