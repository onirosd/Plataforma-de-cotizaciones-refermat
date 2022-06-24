import 'dart:convert';

import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/autentication.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/modelscrud/customer_crt.dart';
//import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:appcotizaciones/src/config/variables.dart';

class CustomerApiProvider {
  DatabaseHelper con = new DatabaseHelper();
  // ignore: non_constant_identifier_names
  var url_customer =
      DIR_URL + "Appstock/controller/services/listarCustomer.php";
  // ignore: non_constant_identifier_names
  var url_autentication =
      DIR_URL + "Appstock/controller/services/listarAutentication.php";

  Future<List<Customer>> getAllCustomer() async {
    // CustomerCtr crt = new CustomerCtr();

    final response = await http.get(Uri.parse(url_customer),
        headers: {"Content-Type": "application/json"});

    List list = json.decode(response.body);

    //return data.map((customer) async {
    //crt.createCustomer(Customer.fromMap(customer));
    //});
    return list.map((job) => new Customer.fromMap(job)).toList();
    //return (response.data as List).map((customer) {}).toList();
  }

  Future<List<Authentication>> getAllAutentication() async {
    // CustomerCtr crt = new CustomerCtr();

    final response = await http.get(Uri.parse(url_autentication),
        headers: {"Content-Type": "application/json"});

    List list = json.decode(response.body);

    //return data.map((customer) async {
    //crt.createCustomer(Customer.fromMap(customer));
    //});
    return list.map((job) => new Authentication.fromMap(job)).toList();
    //return (response.data as List).map((customer) {}).toList();
  }
}
