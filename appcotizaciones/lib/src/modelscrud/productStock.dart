import 'package:appcotizaciones/src/models/delivery_type_model.dart';
import 'package:appcotizaciones/src/models/product_model.dart';
import 'package:appcotizaciones/src/models/product_stock.dart';
import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class ProductStockCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<List<ProductStock>> getDataProductStockind(
      int codProducts, int codCurrency) async {
    var dbProduct = await con.db;
    //var res = await dbProduct.query("DeliveryType");
    String cod = codProducts.toString();
    String cur = codCurrency.toString();
    final List<Map<String, dynamic>> maps = await dbProduct.query(
        'Product_Stock',
        where: 'codProducts = ? and codCurrency = ? ',
        whereArgs: ['$cod', '$cur']);
    //query("Product_Stock");

    return maps.map((c) => ProductStock.fromMap(c)).toList();
  }

  Future<List<ProductStock>> getDataProductStock(int codMoneda) async {
    var dbProduct = await con.db;
    //var res = await dbProduct.query("DeliveryType");
    String cod = codMoneda.toString();
    final List<Map<String, dynamic>> maps = await dbProduct
        .query('Product_Stock', where: 'codCurrency = ?', whereArgs: ['$cod']);
    //query("Product_Stock");

    return maps.map((c) => ProductStock.fromMap(c)).toList();
  }

  Future<List<ProductStock>> getDataProductStock2(String codMoneda,
      String codlista, String codalmacen, String cod_tiproducts) async {
    var dbProduct = await con.db;
    //var res = await dbProduct.query("DeliveryType");
    //String cod = codMoneda.toString();
    final List<Map<String, dynamic>> maps = await dbProduct.query(
        'Product_Stock',
        where:
            'codCurrency = ? and codTiAlmacen = ? and codList = ? and cod_TiProducts = ? ',
        whereArgs: [
          '$codMoneda',
          '$codalmacen',
          '$codlista',
          '$cod_tiproducts'
        ]);
    //query("Product_Stock");

    return maps.map((c) => ProductStock.fromMap(c)).toList();
  }

  Future<int> insertProductStock(ProductStock productstock) async {
    var dbconn = await con.db;
    var raw = await dbconn.insert(
      'Product_Stock',
      productstock.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<int> batchInsertProductStock(
      List<ProductStock> listoproductsotcks) async {
    var dbconn = await con.db;
    Batch batch = dbconn.batch();
    int estado = 0;
    await deleteAllProductsStock();

    listoproductsotcks.forEach((listoproductsotck) {
      batch.insert('Product_Stock', listoproductsotck.toMap());
    });

    //await batch.commit(noResult: true);
    try {
      await batch.commit(continueOnError: false);
      estado = 1;
    } catch (e) {
      estado = 0;
    }

    /*
    final List<dynamic> res =
        (await batch.commit(continueOnError: false)).map<dynamic>((dynamic d) {
      if (d is DatabaseException) {
        debugPrint(d.toString());
        return -1;
      }
      return d;
    }).toList(); */

    return estado;
  }

  deleteAllProductsStock() async {
    var dbAuth = await con.db;
    //String cod = codDeliveryType.toString();

    final res = await dbAuth.rawQuery('DELETE FROM Product_Stock');

    //return res;
  }
}
