import 'package:appcotizaciones/src/models/autentication.dart';
import 'package:appcotizaciones/src/models/confgeneral.dart';
import 'package:appcotizaciones/src/models/querys.dart';
import 'package:appcotizaciones/src/models/response_error.dart';
import 'package:appcotizaciones/src/models/synclog.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class ConfigGeneralCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> deleteInsertConfGeneralperUser(ConfGeneral conf) async {
    // Get a reference to the database.
    //print(" --------------- veremos -----------------");
    //print(conf);
    var dbCustomer = await con.db;
    //await deleteConfGeneralperUser(conf.codUser, conf.codconfigGeneral);

    var raw = await dbCustomer.insert(
      'Conf_General',
      conf.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    //print(raw);

    return raw;
  }

  Future<int> deleteAllConfGeneralperUser(int codUser) async {
    var dbAuth = await con.db;
    String cod = codUser.toString();
    //String codConf = codConfig.toString();

    final res = await dbAuth.rawDelete('DELETE FROM Conf_General');

    return res;
  }

  Future<int> deleteCustomerandGaleriesfinish() async {
    var dbAuth = await con.db;
    //String cod = codUser.toString();
    //String codConf = codConfig.toString();

    final res0 = await dbAuth.rawQuery(
        'DELETE FROM GalleryDetailSubtipos WHERE codGallery NOT IN (SELECT codGallery FROM Gallery WHERE flatEstado IN (0))');
    final res = await dbAuth.rawQuery(
        'DELETE FROM GalleryDetail WHERE codGallery NOT IN (SELECT codGallery FROM Gallery WHERE flatEstado IN (0))');
    final res2 = await dbAuth
        .rawQuery('DELETE FROM Gallery WHERE flatEstado NOT IN (0)');
    final res3 = await dbAuth
        .rawQuery('DELETE FROM Customer WHERE asyncFlag  NOT IN  (0)');

    return 1;
  }

  Future<int> deleteBillandQuotationwithoutdatanotfinish() async {
    var dbAuth = await con.db;
    //String cod = codUser.toString();
    //String codConf = codConfig.toString();

    final res = await dbAuth.rawQuery(
        'DELETE FROM QuotationProducts WHERE quotation_id NOT IN (SELECT id FROM Quotation WHERE state IN (0,1))');
    final res2 =
        await dbAuth.rawQuery('DELETE FROM Quotation WHERE state NOT IN (0,1)');
    final res3 = await dbAuth
        .rawQuery('DELETE FROM BILLING WHERE flgState NOT IN  (0,1)');

    return 1;
  }

  Future<int> deleteConfGeneralperUser(int codUser, int codConfig) async {
    var dbAuth = await con.db;
    String cod = codUser.toString();
    String codConf = codConfig.toString();

    final res = await dbAuth.rawDelete(
        'DELETE FROM Conf_General WHERE codUser =$cod AND codconfigGeneral =$codConf');

    return res;
  }

  Future<List<ConfGeneral>> getConfigGeneralforUser(int codUser) async {
    var dbCustomer = await con.db;
    String cod = codUser.toString();
    final List<Map<String, dynamic>> maps = await dbCustomer
        .rawQuery("select * from Conf_General where codUser = $cod ");

    return maps.map((c) => ConfGeneral.fromMap(c)).toList();
  }

  Future<ConfGeneral> getConfigGeneralforUserforRule(String rule) async {
    var dbCustomer = await con.db;
    ConfGeneral conf = new ConfGeneral(
        codconfigGeneral: 0,
        strCodOperation: "",
        strDescription: "",
        flgEnabled: 999,
        pivot1: "",
        pivot2: "",
        pivot3: "",
        codUser: 999,
        flgSync: 999);
    //String cod = codUser.toString();
    final maps = await dbCustomer.rawQuery(
        "select * from Conf_General where strCodOperation = '$rule' and flgEnabled = 1 LIMIT 1");

    //print(maps);
    // return maps.map((c) => ConfGeneral.fromMap(c)).toList();

    //print(maps.length.toString() + " ------------------ ");

    if (maps.length > 0) {
      conf.codconfigGeneral = maps.first["codconfigGeneral"];
      conf.strCodOperation = maps.first["strCodOperation"];
      conf.strDescription = maps.first["strDescription"];
      conf.flgEnabled = maps.first["flgEnabled"];
      conf.pivot1 = maps.first["pivot1"];
      conf.pivot2 = maps.first["pivot2"];
      conf.pivot3 = maps.first["pivot3"];
      conf.codUser = maps.first["codUser"];
      conf.flgSync = maps.first["flgSync"];
    }

    return conf;
  }

  Future<List<SelectPendingSync>> getPendingSync() async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "select 'Cotizacion' as evento, count(1) cantidad from Quotation where state in ('1', '5') UNION select 'Recibos' as evento, count(1) cantidad from Billing where flgState in (1,5) UNION select 'Clientes' as evento, count(1) cantidad from Customer where asyncFlag = 0");

    return maps.map((c) => SelectPendingSync.fromMap(c)).toList();
  }

  Future<List<SelectPendingSync>> getTotalPendingSync() async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "  select 'total' as evento, sum(cantidad) cantidad from ( select 'Cotizacion' as evento, count(1) cantidad from Quotation where state in ('1', '5') UNION select 'Recibos' as evento, count(1) cantidad from Billing where flgState in (1, 5) UNION select 'Clientes' as evento, count(1) cantidad from Customer where asyncFlag = 0 ) a  ");

    return maps.map((c) => SelectPendingSync.fromMap(c)).toList();
  }

  Future<ResponseError> batchCleanPrincipalTables() async {
    var dbconn = await con.db;
    Batch batch = dbconn.batch();
    int estado = 0;

    ResponseError responseerror =
        new ResponseError(description: '', error: 1, success: 0);

    batch.delete('LastAutentication');
    //batch.delete('Quotation');
    //batch.delete('QuotationProducts');
    batch.delete('Product');
    batch.delete('Product_Stock');
    //batch.delete('Customer');
    //batch.delete('Billing');

    try {
      // await deleteDataComplements(queryDelet);
      await batch.commit(continueOnError: false);
      responseerror.error = 0;
      responseerror.success = 1;
      responseerror.description = 'Tablas Principales Borradas con exito.';
    } catch (e) {
      estado = 0;

      responseerror.description = e.toString();

      print(e.toString());
    }

    return responseerror;
  }
}
