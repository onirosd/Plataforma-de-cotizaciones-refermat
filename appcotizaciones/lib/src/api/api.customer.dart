import 'dart:convert';

import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/response_error.dart';
// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:appcotizaciones/src/config/variables.dart';

class CustomerApiProvider {
  DatabaseHelper con = new DatabaseHelper();
  // ignore: non_constant_identifier_names
  var _url_get_customer =
      DIR_URL + "Appstock/controller/services/listarCustomer.php";

  // ignore: non_constant_identifier_names
  var _url_pos_customer =
      DIR_URL + "Appstock/controller/services/insertarCustomer.php";

  Future<List<Customer>> getAllCustomer() async {
    // CustomerCtr crt = new CustomerCtr();

    final response = await http.get(Uri.parse(_url_get_customer),
        headers: {"Content-Type": "application/json"});

    List list = json.decode(response.body);

    //return data.map((customer) async {
    //crt.createCustomer(Customer.fromMap(customer));
    //});
    return list.map((job) => new Customer.fromMap(job)).toList();
    //return (response.data as List).map((customer) {}).toList();
  }

  Future<List<Customer>> uploadAllCustomers(int IdEmpresa) async {
    Exempresa codempresa = new Exempresa(codEmpresa: IdEmpresa);
    List data = [];
    try {
      final response = await http.post(
        Uri.parse(_url_get_customer),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(codempresa),
      );

      if (response.statusCode == 200) {
        data = json.decode(response.body);
      }
    } catch (e) {}

    return data.map((job) => new Customer.fromMap(job)).toList();
  }

  Future<ResponseError> uploadCustomers(List<Customer> customers) async {
    ResponseError error =
        new ResponseError(description: "", error: 0, success: 0);
    final response = await http.post(
      Uri.parse(_url_pos_customer),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(customers),
    );

    print(jsonEncode(customers));
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

class Exempresa {
  int codEmpresa;

  Exempresa({
    required this.codEmpresa,
  });

  Map<String, dynamic> toMap() {
    return {
      'codEmpresa': codEmpresa,
    };
  }

  factory Exempresa.fromMap(Map<String, dynamic> map) {
    return Exempresa(
      codEmpresa: map['codEmpresa'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Exempresa.fromJson(String source) =>
      Exempresa.fromMap(json.decode(source));
}
