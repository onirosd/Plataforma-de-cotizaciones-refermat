import 'package:appcotizaciones/src/models/gallery.dart';
import 'package:appcotizaciones/src/models/galleryDetail.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class GalleryDetailCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> insertGalleryDetail(GalleryDetail galerydetail) async {
    var dbconn = await con.db;
    var raw = await dbconn.insert(
      'GalleryDetail',
      galerydetail.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  deleteGalleryDetailforcodGallery(String codGallery) async {
    var dbAuth = await con.db;
    //String cod = codDeliveryType.toString();

    final res = await dbAuth
        .rawQuery("DELETE FROM GalleryDetail WHERE codGallery = '$codGallery'");

    //return res;
  }

  Future<List<GalleryDetail>> getGalleryDetailSync(String codgallery) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "SELECT * FROM GalleryDetail WHERE codGallery  = '$codgallery' ");

    //List<String>
    return maps.map((c) => GalleryDetail.fromMap(c)).toList();
  }

  Future<List<GalleryDetail>> getGalleryDetail(String codgallery) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "SELECT * FROM GalleryDetail where codGallery = '$codgallery'");

    //List<String>
    return maps.map((c) => GalleryDetail.fromMap(c)).toList();
  }
}
