import 'package:appcotizaciones/src/helpers/database_helper.dart';
//import 'package:appcotizaciones/src/models/Quotation.dart';
import 'package:appcotizaciones/src/models/querys.dart';
import 'package:appcotizaciones/src/models/quotation_model.dart';
import 'package:appcotizaciones/src/models/quotation_product_model.dart';
import 'package:appcotizaciones/src/models/quotationplusproducst.dart';
import 'package:appcotizaciones/src/models/quotationv0.dart';
import 'package:appcotizaciones/src/modelscrud/quotationProduct_crt.dart';
import 'package:appcotizaciones/src/modelscrud/quotation_crt.dart';
import 'package:sqflite/sqflite.dart' as sql;
//import 'package:flutter/material.dart';

class QuotationProductExport {
  DatabaseHelper con = new DatabaseHelper();

  Future<List<QuotationProductsExport>> getDataQuotationProdExp(
      int enablepreproc) async {
    QuotationCrt crt1 = new QuotationCrt();
    QuotationProductCrt crt2 = new QuotationProductCrt();

    List<QuotationProductsExport> listExport = [];
    List<QuotationProduct> quotationproducts = [];
    List<Quotation> quotations =
        await crt1.getQuotationSincronice(enablepreproc);

    for (Quotation quotation in quotations) {
      quotationproducts =
          await crt2.getDataQuotationProductsperCode(quotation.id.toString());

      listExport.add(new QuotationProductsExport(
          quotat: quotation, listproduct: quotationproducts));
    }

    return listExport;
  }
}
