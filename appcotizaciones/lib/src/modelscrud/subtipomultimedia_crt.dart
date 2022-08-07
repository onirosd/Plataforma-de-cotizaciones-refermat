import 'package:appcotizaciones/src/models/sub_tipo_multimedia.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';

class SubTipoMultimedia_crt {
  DatabaseHelper con = new DatabaseHelper();

  Future<List<SubTipoMultimedia>> getsubTipoMultimedia(
      String codtipomultimedia) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "SELECT * FROM SubTipoMultimedia where codTipomultimedia = '$codtipomultimedia' ");

    return maps.map((c) => SubTipoMultimedia.fromMap(c)).toList();
  }
}
