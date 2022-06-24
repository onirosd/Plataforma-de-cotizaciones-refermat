import 'dart:convert';

import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/autentication.dart';
// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:appcotizaciones/src/config/variables.dart';

class AutenticationApiProvider {
  DatabaseHelper con = new DatabaseHelper();

  // ignore: non_constant_identifier_names
  var url_autentication =
      DIR_URL + "Appstock/controller/services/listarAutentication.php";

  Future<List<Authentication>> getAllAutentication(int company) async {
    listcomopanies listcompan = new listcomopanies(company: company.toString());
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    String jsondata = encoder.convert(listcompan).toString();

    List list = [];
    try {
      // final response = await http.get(Uri.parse(url_autentication),
      //     headers: {"Content-Type": "application/json"});

      final response = await http.post(
        Uri.parse(url_autentication),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsondata,
      );

      list = json.decode(response.body);
      print(response.body);
    } catch (e) {
      print(e);
    }

    print(list);

    return list.map((job) => new Authentication.fromMap(job)).toList();
    //return (response.data as List).map((customer) {}).toList();
  }
}

class listcomopanies {
  String company;
  listcomopanies({
    required this.company,
  });

  listcomopanies copyWith({
    String? company,
  }) {
    return listcomopanies(
      company: company ?? this.company,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'company': company});

    return result;
  }

  factory listcomopanies.fromMap(Map<String, dynamic> map) {
    return listcomopanies(
      company: map['company'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory listcomopanies.fromJson(String source) =>
      listcomopanies.fromMap(json.decode(source));

  @override
  String toString() => 'listcomopanies(company: $company)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is listcomopanies && other.company == company;
  }

  @override
  int get hashCode => company.hashCode;
}
