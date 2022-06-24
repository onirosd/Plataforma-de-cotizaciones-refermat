import 'dart:convert';

import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/confgeneral.dart';
//import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:appcotizaciones/src/config/variables.dart';

class ConfigGeneralApiProvider {
  DatabaseHelper con = new DatabaseHelper();
  // ignore: non_constant_identifier_names
  var url_configGeneral =
      DIR_URL + "Appstock/controller/services/listarConfiguracion.php";

  Future<List<ConfGeneral>> getConfigGeneralforUser(int codUser) async {
    // CustomerCtr crt = new CustomerCtr();
    var urlfinal = url_configGeneral + "?codUser=" + codUser.toString();
    List list = [];
    // print(urlfinal);

    try {
      final response = await http.get(Uri.parse(urlfinal),
          headers: {"Content-Type": "application/json"});

      // print(response);
      list = json.decode(response.body);
    } catch (e) {}

    //print(list);
    //return data.map((customer) async {
    //crt.createCustomer(Customer.fromMap(customer));
    //});
    return list.map((job) => new ConfGeneral.fromMap(job)).toList();
    //return (response.data as List).map((customer) {}).toList();
  }
}
