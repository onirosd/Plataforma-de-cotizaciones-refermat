import 'package:appcotizaciones/src/models/delivery_type_model.dart';
import 'package:appcotizaciones/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class DeliveryTypeCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<List<DeliveryType>> getDataDeliveryTipe() async {
    var dbProduct = await con.db;
    //var res = await dbProduct.query("DeliveryType");

    final List<Map<String, dynamic>> maps =
        await dbProduct.query("DeliveryType");

    return maps.map((c) => DeliveryType.fromMap(c)).toList();
  }

  Future<int> insertDeliveryType(DeliveryType deliverytype) async {
    // Get a reference to the database.
    var dbCustomer = await con.db;
    //await deleteDeliveryType(deliverytype.id);

    var raw = await dbCustomer.insert(
      'DeliveryType',
      deliverytype.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<int> deleteDeliveryType(int codDeliveryType) async {
    var dbAuth = await con.db;
    String cod = codDeliveryType.toString();
    final res =
        await dbAuth.rawDelete('DELETE FROM DeliveryType where id = $cod');

    return res;
  }

  Future<int> deleteAllDeliverytype() async {
    var dbAuth = await con.db;
    //String cod = codDeliveryType.toString();
    final res = await dbAuth.delete('DeliveryType');

    return res;
  }
}
