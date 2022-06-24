import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/quotation_product_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class QuotationProductCrt {
  DatabaseHelper con = new DatabaseHelper();

  // ADD QUOTATION PRODUCT
  insertQuotationProduct(QuotationProduct item) async {
    final db = await con.db;
    var res = await db.insert("QuotationProducts", item.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return res;
  }

  Future<List<QuotationProduct>> getDataQuotationProductsperCode(
      String codQuotation) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "SELECT * FROM QuotationProducts WHERE quotation_id = '$codQuotation' ");

    return maps.map((c) => QuotationProduct.fromMap(c)).toList();
  }

  Future<int> deleteQuotationProductsperCode(String codQuotation) async {
    var dbAuth = await con.db;
    //String cod = codCurrency.toString();
    final res = await dbAuth.rawDelete(
        "DELETE FROM QuotationProducts WHERE quotation_id = '$codQuotation' ");

    return res;
  }
}
