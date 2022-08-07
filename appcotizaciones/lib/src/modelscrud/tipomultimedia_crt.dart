import 'package:appcotizaciones/src/models/tipo_multimedia.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TipoMultimedia_crt {
  DatabaseHelper con = new DatabaseHelper();

  Future<List<TipoMultimedia>> getDataTipoMultimedia() async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps =
        await dbCustomer.rawQuery("SELECT * FROM TipoMultimedia ");

    return maps.map((c) => TipoMultimedia.fromMap(c)).toList();
  }
}
