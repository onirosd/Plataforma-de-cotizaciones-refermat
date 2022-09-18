import 'package:appcotizaciones/src/models/gallery.dart';
import 'package:appcotizaciones/src/models/galleryDetail.dart';
import 'package:appcotizaciones/src/models/galleryDetailSubtipos.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class GalleryDetailSubtipoCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> insertGalleryDetailSubtipos(
      GalleryDetailSubtipos galerydetailsubtipos) async {
    var dbconn = await con.db;
    var raw = await dbconn.insert(
      'GalleryDetailSubtipos',
      galerydetailsubtipos.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  deleteGalleryDetailSubtiposforcodGallery(String codGallery) async {
    var dbAuth = await con.db;
    //String cod = codDeliveryType.toString();

    final res = await dbAuth.rawQuery(
        "DELETE FROM GalleryDetailSubtipos WHERE codGallery = '$codGallery'");

    //return res;
  }

  Future<List<GalleryDetailSubtipos>> getGalleryDetailSubtiposSync(
      String codgallery) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "SELECT * FROM GalleryDetailSubtipos WHERE codGallery  = '$codgallery' ");

    //List<String>
    return maps.map((c) => GalleryDetailSubtipos.fromMap(c)).toList();
  }

  Future<List<GalleryDetailSubtipos>> getGalleryDetailSubtipos(
      String codgallery) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "SELECT * FROM GalleryDetailSubtipos where codGallery = '$codgallery'");

    //List<String>
    return maps.map((c) => GalleryDetailSubtipos.fromMap(c)).toList();
  }
}
