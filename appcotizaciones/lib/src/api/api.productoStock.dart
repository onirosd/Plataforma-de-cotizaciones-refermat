import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:appcotizaciones/src/config/variables.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/product_stock.dart';
import 'package:appcotizaciones/src/models/response_error.dart';
import 'package:appcotizaciones/src/modelscrud/productStock.dart';

class StockProductApiProvider {
  DatabaseHelper con = new DatabaseHelper();

  // ignore: non_constant_identifier_names
  var _url_pos_productstock =
      DIR_URL + "Appstock/controller/services/insertarProductsStock.php";

/*
  Future<List<Billing>> getAllBilling() async {
    // CustomerCtr crt = new CustomerCtr();

    final response = await http.get(Uri.parse(_url_get_billing),
        headers: {"Content-Type": "application/json"});

    List list = json.decode(response.body);

    //return data.map((customer) async {
    //crt.createCustomer(Customer.fromMap(customer));
    //});
    return list.map((job) => new Billing.fromMap(job)).toList();
    //return (response.data as List).map((customer) {}).toList();
  }
*/

  Future<ResponseError> uploadProductsStock(
      int sendlista, String company) async {
    ResponseError error =
        new ResponseError(description: "", error: 0, success: 0);
    SendList lista = new SendList(lista: sendlista, company: company);

    final response = await http.post(
      Uri.parse(_url_pos_productstock),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(lista),
    );

    //  print(jsonEncode(billings));
    //print(response.statusCode);

    if (response.statusCode == 200) {
      ProductStockCtr pr = new ProductStockCtr();

      List list = json.decode(response.body);
      List<ProductStock> listaProductStock =
          list.map((job) => new ProductStock.fromMap(job)).toList();
      final rpt = await pr.batchInsertProductStock(listaProductStock);

      if (rpt == 1) {
        error.success = 1;
        error.error = 0;
        error.description = 'Productos con stock insertados con exito';
      } else {
        error.description = 'Tenemos errores en la insercion , revisar.';
      }
    } else {
      error.description = response.body.toString();
    }

    return error;
  }
}

class SendList {
  int lista;
  String company;

  SendList({
    required this.lista,
    required this.company,
  });

  SendList copyWith({
    int? lista,
    String? company,
  }) {
    return SendList(
      lista: lista ?? this.lista,
      company: company ?? this.company,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'lista': lista});
    result.addAll({'company': company});

    return result;
  }

  factory SendList.fromMap(Map<String, dynamic> map) {
    return SendList(
      lista: map['lista']?.toInt() ?? 0,
      company: map['company'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SendList.fromJson(String source) =>
      SendList.fromMap(json.decode(source));

  @override
  String toString() => 'SendList(lista: $lista, company: $company)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SendList &&
        other.lista == lista &&
        other.company == company;
  }

  @override
  int get hashCode => lista.hashCode ^ company.hashCode;
}
