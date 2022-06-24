import 'package:appcotizaciones/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class ProductCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<List<Product>> getDataProduct() async {
    var dbProduct = await con.db;

    final List<Map<String, dynamic>> maps =
        await dbProduct.rawQuery("SELECT * FROM Product ");

    return maps.map((c) => Product.fromMap(c)).toList();
  }

  Future<int> insertProduct(Product product) async {
    // Get a reference to the database.

    var dbCustomer = await con.db;
    //var maxcodCustomer = await dbCustomer.rawQuery(
    //   "SELECT MAX(codUser)+1 as last_inserted_id FROM Autentication");
    //var cod = maxcodCustomer.first["last_inserted_id"] == null
    //   ? 1
    //   : maxcodCustomer.first["last_inserted_id"];

    // autentication.codUser = cod;
    // print(maxcodCustomer.first["last_inserted_id"]);

    await deleteCompany(product.id);

    var raw = await dbCustomer.insert(
      'Product',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<int> deleteCompany(int codCompany) async {
    var dbAuth = await con.db;
    String cod = codCompany.toString();
    final res =
        await dbAuth.rawDelete('DELETE FROM Company where codCompany = $cod');

    return res;
  }
}
