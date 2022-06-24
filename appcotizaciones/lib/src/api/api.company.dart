import 'dart:convert';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/autentication.dart';
import 'package:appcotizaciones/src/models/company.dart';
//import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:appcotizaciones/src/config/variables.dart';

class CompanyApiProvider {
  DatabaseHelper con = new DatabaseHelper();

  // ignore: non_constant_identifier_names
  var url_autentication =
      DIR_URL + "Appstock/controller/services/listarCompany.php";

  Future<List<Company>> getAllCompanys() async {
    // CustomerCtr crt = new CustomerCtr();
    List list = [];
    try {
      final response = await http.get(Uri.parse(url_autentication),
          headers: {"Content-Type": "application/json"});

      list = json.decode(response.body);
    } catch (e) {
      print(e);
    }

    return list.map((job) => new Company.fromMap(job)).toList();
    //return (response.data as List).map((customer) {}).toList();
  }
}
