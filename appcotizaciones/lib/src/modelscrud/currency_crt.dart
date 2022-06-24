import 'package:appcotizaciones/src/models/bank.dart';
import 'package:appcotizaciones/src/models/billingType.dart';
import 'package:appcotizaciones/src/models/company.dart';
import 'package:appcotizaciones/src/models/currency.dart';
import 'package:appcotizaciones/src/models/payCondition.dart';
import 'package:appcotizaciones/src/models/paymentMethod.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class CurrencyCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> insertCurrency(Currency currency) async {
    // Get a reference to the database.

    var dbAuth = await con.db;
    await deleteCurrency(currency.codCurrency);

    var raw = await dbAuth.insert(
      'Currency',
      currency.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<int> deleteCurrency(int? codCurrency) async {
    var dbAuth = await con.db;
    String cod = codCurrency.toString();
    final res =
        await dbAuth.rawDelete('DELETE FROM Currency WHERE codCurrency = $cod');

    return res;
  }

  Future<List<Currency>> getDataCurrency() async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps =
        await dbCustomer.rawQuery("SELECT * FROM Currency ");

    return maps.map((c) => Currency.fromMap(c)).toList();
  }

  Future<List<Currency>> getDataCurrencyforCompany(String codCompany) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        " select a.codCurrency, a.strDescription, a.strName from Currency a inner join company b on cast(a.codCurrency as text) = cast(b.codCurrency as text) where b.codCompany  = $codCompany ");

    return maps.map((c) => Currency.fromMap(c)).toList();
  }
}
