import 'package:appcotizaciones/src/models/tialmacen.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TiAlmacen_ctr {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> insertTiAlmacen() async {
    deleteTiAlmacen();

    var db = await con.db;
    //String cod = codList.toString();
    final res = await db.rawInsert(
        'INSERT INTO Ti_Almacen(codTiAlmacen, strDescription) SELECT A.codTiAlmacen, A.desTiAlmacen FROM ( SELECT codTiAlmacen, desTiAlmacen FROM Product_Stock GROUP BY codTiAlmacen, desTiAlmacen ) A');

    return res;
  }

  Future<List<TiAlmacen>> getTiAlmacen() async {
    var db = await con.db;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM Ti_Almacen");

    return maps.map((c) => TiAlmacen.fromMap(c)).toList();
  }

  Future<int> deleteTiAlmacen() async {
    var db = await con.db;
    //String cod = codList.toString();
    final res = await db.rawDelete('DELETE FROM Ti_Almacen');

    return res;
  }
}
