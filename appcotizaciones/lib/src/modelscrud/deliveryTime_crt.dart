import 'package:appcotizaciones/src/models/delivery_time_model.dart';
import 'package:appcotizaciones/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class DeliveryTimeCrt {
  DatabaseHelper con = new DatabaseHelper();

  Future<List<DeliveryTime>> getDataDeliveryTime() async {
    var dbProduct = await con.db;
    final List<Map<String, dynamic>> maps =
        await dbProduct.query("DeliveryTime");

    return maps.map((c) => DeliveryTime.fromMap(c)).toList();
  }

  Future<int> insertDeliverytime(DeliveryTime deliverytime) async {
    // Get a reference to the database.

    var dbCustomer = await con.db;

    ///await deleteDeliveryTime(deliverytime.id);

    var raw = await dbCustomer.insert(
      'DeliveryTime',
      deliverytime.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<int> deleteDeliveryTime(int codDeliveryTIme) async {
    var dbAuth = await con.db;
    String cod = codDeliveryTIme.toString();
    final res =
        await dbAuth.rawDelete('DELETE FROM DeliveryTime where id = $cod');

    return res;
  }

  Future<int> deleteAllDeliverytime() async {
    var dbAuth = await con.db;
    //String cod = codDeliveryType.toString();
    final res = await dbAuth.delete('DeliveryTime');

    return res;
  }
}
