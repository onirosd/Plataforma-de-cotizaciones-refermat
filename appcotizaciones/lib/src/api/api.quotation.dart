import 'dart:convert';

import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/quotation_model.dart';
import 'package:appcotizaciones/src/models/quotationplusproducst.dart';
import 'package:appcotizaciones/src/models/response_error.dart';
//import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:appcotizaciones/src/config/variables.dart';

class QuotationApiProvider {
  DatabaseHelper con = new DatabaseHelper();
  // ignore: non_constant_identifier_names
  var _url_get_quotation =
      DIR_URL + "Appstock/controller/services/listarQuotation.php";

  // ignore: non_constant_identifier_names
  var _url_pos_quotation =
      DIR_URL + "Appstock/controller/services/insertarQuotation.php";

  Future<List<Quotation>> getAllQuotation() async {
    // CustomerCtr crt = new CustomerCtr();

    final response = await http.get(Uri.parse(_url_get_quotation),
        headers: {"Content-Type": "application/json"});

    List list = json.decode(response.body);
    return list.map((job) => new Quotation.fromMap(job)).toList();
    //return (response.data as List).map((customer) {}).toList();
  }

  Future<ResponseError> uploadQuotationProductsExport(
      List<QuotationProductsExport> listExport) async {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    String jsondata =
        encoder.convert(listExport).toString(); //json.encode(listExport);

    // print(jsondata);

    ResponseError error =
        new ResponseError(description: "", error: 0, success: 0);
    final response = await http.post(
      Uri.parse(_url_pos_quotation),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsondata,
    );

    //print(response.statusCode);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      //final respon = jsonDecode(response.body);
      Map<String, dynamic> map = jsonDecode(response.body);
      String description = map['description'];
      int er = map['error'];
      int cant = map['cant'];

      if (er == 1) {
        error.error = cant > 0 ? 2 : 1;
        error.description = description;
      } else {
        error.description = description;
      }

      //print(respon["error"]);
      //return Customer.fromJson(jsonDecode(response.body));
    } else {
      error.description = response.body.toString();
    }

    return error;
  }
}
