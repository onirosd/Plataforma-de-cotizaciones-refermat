import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/gallery.dart';

class GalleryCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<int> insertUpdateGallery(Gallery galery, int flag) async {
    var dbconn = await con.db;
    int raw = 0;
    if (flag == 1) {
      String cod_gallery = galery.codGallery;
      await dbconn.update('Gallery', galery.toMap(),
          where: 'codGallery = $cod_gallery');
      raw = 1;
    } else {
      raw = await dbconn.insert(
        'Gallery',
        galery.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return raw;
  }

  Future<List<SelectGallery>> getGalleryCustomers(String codCustomer) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "SELECT a.codGallery, a.fechaCreacion, b.desTipomultimedia, a.flatEstado FROM Gallery a inner join tipoMultimedia b on a.tipoMultimedia = b.codTipomultimedia where a.codCustomer = '$codCustomer' order by date(a.fechaCreacion) desc");

    //List<String>
    return maps.map((c) => SelectGallery.fromMap(c)).toList();
  }

// DELETE FROM GalleryDetail WHERE codGallery NOT IN (SELECT codGallery FROM Gallery WHERE flatEstado IN (0))

  Future<List<Gallery>> getGallery(String codgallery) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer
        .rawQuery("SELECT * FROM Gallery where codGallery = '$codgallery'");

    //List<String>
    return maps.map((c) => Gallery.fromMap(c)).toList();
  }

  Future<List<Gallery>> getGallerySync() async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps =
        await dbCustomer.rawQuery("SELECT * FROM Gallery where flatEstado = 0");

    //List<String>
    return maps.map((c) => Gallery.fromMap(c)).toList();
  }

  Future<int> updateGallery(Gallery gallery) async {
    // Get a reference to the database.
    final db = await con.db;

    // Update the given Dog.
    return await db.update(
      'Gallery',
      gallery.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'codGallery = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [gallery.codGallery],
    );
  }

  Future<List<SelectGallerImages>> getGalleriesImages() async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "select b.nameImage, b.pathImage, a.codCustomer from Gallery a inner join GalleryDetail b on a.codGallery = b.codGallery where a.flatEstado = 0");

    //List<String>
    return maps.map((c) => SelectGallerImages.fromMap(c)).toList();
  }
}

class SelectGallerImages {
  String nameImage;
  String pathImage;
  String codCustomer;

  SelectGallerImages({
    required this.nameImage,
    required this.pathImage,
    required this.codCustomer,
  });

  SelectGallerImages copyWith({
    String? nameImage,
    String? pathImage,
    String? codCustomer,
  }) {
    return SelectGallerImages(
      nameImage: nameImage ?? this.nameImage,
      pathImage: pathImage ?? this.pathImage,
      codCustomer: codCustomer ?? this.codCustomer,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'nameImage': nameImage});
    result.addAll({'pathImage': pathImage});
    result.addAll({'codCustomer': codCustomer});

    return result;
  }

  factory SelectGallerImages.fromMap(Map<String, dynamic> map) {
    return SelectGallerImages(
      nameImage: map['nameImage'] ?? '',
      pathImage: map['pathImage'] ?? '',
      codCustomer: map['codCustomer'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectGallerImages.fromJson(String source) =>
      SelectGallerImages.fromMap(json.decode(source));

  @override
  String toString() =>
      'SelectGallerImages(nameImage: $nameImage, pathImage: $pathImage, codCustomer: $codCustomer)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SelectGallerImages &&
        other.nameImage == nameImage &&
        other.pathImage == pathImage &&
        other.codCustomer == codCustomer;
  }

  @override
  int get hashCode =>
      nameImage.hashCode ^ pathImage.hashCode ^ codCustomer.hashCode;
}

class SelectGallery {
  String codGallery;
  String fechaCreacion;
  String desTipomultimedia;
  int flatEstado;

  bool selected = false;

  SelectGallery({
    required this.codGallery,
    required this.fechaCreacion,
    required this.desTipomultimedia,
    required this.flatEstado,
  });

  SelectGallery copyWith({
    String? codGallery,
    String? fechaCreacion,
    String? desTipomultimedia,
    int? flatEstado,
  }) {
    return SelectGallery(
      codGallery: codGallery ?? this.codGallery,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      desTipomultimedia: desTipomultimedia ?? this.desTipomultimedia,
      flatEstado: flatEstado ?? this.flatEstado,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'codGallery': codGallery});
    result.addAll({'fechaCreacion': fechaCreacion});
    result.addAll({'desTipomultimedia': desTipomultimedia});
    result.addAll({'flatEstado': flatEstado});

    return result;
  }

  factory SelectGallery.fromMap(Map<String, dynamic> map) {
    return SelectGallery(
      codGallery: map['codGallery'] ?? '',
      fechaCreacion: map['fechaCreacion'] ?? '',
      desTipomultimedia: map['desTipomultimedia'] ?? '',
      flatEstado: map['flatEstado']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectGallery.fromJson(String source) =>
      SelectGallery.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SelectGallery(codGallery: $codGallery, fechaCreacion: $fechaCreacion, desTipomultimedia: $desTipomultimedia, flatEstado: $flatEstado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SelectGallery &&
        other.codGallery == codGallery &&
        other.fechaCreacion == fechaCreacion &&
        other.desTipomultimedia == desTipomultimedia &&
        other.flatEstado == flatEstado;
  }

  @override
  int get hashCode {
    return codGallery.hashCode ^
        fechaCreacion.hashCode ^
        desTipomultimedia.hashCode ^
        flatEstado.hashCode;
  }
}
