import 'package:appcotizaciones/src/models/autentication.dart';
import 'package:appcotizaciones/src/models/synclog.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class SyncLogCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> insertNewSyncLog(SyncLog log) async {
    // Get a reference to the database.

    var dbCustomer = await con.db;
    var maxcodSync = await dbCustomer
        .rawQuery("SELECT MAX(codLog)+1 as last_inserted_id FROM Sync_Log");
    var cod = maxcodSync.first["last_inserted_id"] == null
        ? 1
        : maxcodSync.first["last_inserted_id"];

    log.codLog = cod;
    // print(maxcodCustomer.first["last_inserted_id"]);

    var raw = await dbCustomer.insert(
      'Sync_Log',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<List<SyncLog>> getLastLogFromUser(int codUser) async {
    var dbCustomer = await con.db;
    String cod = codUser.toString();
    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "SELECT codLog, dteSyncDate, strDay, strhour, codUser FROM Sync_Log WHERE codUser = $cod and seccion = 'Sync-general' ORDER BY dteCreateDate DESC LIMIT 1");

    return maps.map((c) => SyncLog.fromMap(c)).toList();
  }

  Future<int> saveLogtoUser(int codUser, String seccion, String message) async {
    DateTime startDate = await NTP.now(lookUpAddress: 'time.google.com');
    DateTime endDate = startDate.subtract(Duration(hours: 5));

    //print('NTP DateTime: ${endDate}');

    SyncLog log = new SyncLog(
        codLog: 1,
        dteSyncDate: endDate.millisecondsSinceEpoch,
        strDay: DateFormat('yyyy-MM-dd').format(endDate),
        strhour: DateFormat('kk:mm').format(endDate),
        codUser: codUser,
        seccion: seccion,
        strMessage: message);
    // SyncLogCtr crt = new SyncLogCtr();

    return insertNewSyncLog(log);
  }

  Future<int> deleteAlllogs() async {
    var dbAuth = await con.db;
    //String cod = codList.toString();
    final res = await dbAuth.rawDelete(" DELETE FROM Sync_Log ");

    return res;
  }
}
