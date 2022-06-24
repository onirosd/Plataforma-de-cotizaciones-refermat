import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/autentication.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class AuthenticationCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<List<Authentication>> checkAutentication2(
      String strNameUser, String strPassUser, String codCompany) async {
    var dbProduct = await con.db;
    //var res = await dbProduct.query("DeliveryType");

    final List<Map<String, dynamic>> maps = await dbProduct.rawQuery(
        "SELECT  a.*, b.strPosition AS strPosition FROM Autentication a LEFT JOIN Ti_Person b ON a.codPerson = b.codPerson WHERE strNameUser = '$strNameUser' and strPassUser = '$strPassUser' and codCompany = $codCompany",
        null);

    return maps.map((c) => Authentication.fromMap(c)).toList();
  }

  Future<int> checkAutentication(
      String strNameUser, String strPassUser, int codCompany) async {
    String company = codCompany.toString();
    //print(' $strNameUser  || $strPassUser || $company ');
    var dbCustomer = await con.db;
    var res = await dbCustomer.rawQuery(
        "SELECT codUser FROM Autentication WHERE strNameUser = '$strNameUser' and strPassUser = '$strPassUser' and codCompany = $company",
        null);

    if (res.length > 0) {
      return res.first["codUser"] != null || res.first["codUser"] > 0
          ? res.first["codUser"]
          : 0;
    }
    return 0;
  }

  Future<int> insertAutentication(Authentication autentication) async {
    // Get a reference to the database.

    var dbCustomer = await con.db;
    //var maxcodCustomer = await dbCustomer.rawQuery(
    //  "SELECT MAX(codUser)+1 as last_inserted_id FROM Autentication");
    //var cod = maxcodCustomer.first["last_inserted_id"] == null
    //  ? 1
    //  : maxcodCustomer.first["last_inserted_id"];

    // autentication.codUser = cod;
    // print(maxcodCustomer.first["last_inserted_id"]);

    var raw = await dbCustomer.insert(
      'Autentication',
      autentication.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<int> deleteAllAutentication() async {
    var dbAuth = await con.db;
    final res = await dbAuth.rawDelete('DELETE FROM Autentication');

    return res;
  }

  Future<List<Authentication>> getDataUserAutentication(int codUser) async {
    var dbCustomer = await con.db;
    String cod = codUser.toString();
    final List<Map<String, dynamic>> maps = await dbCustomer
        .rawQuery("SELECT * FROM Autentication WHERE codUser = $cod");

    return maps.map((c) => Authentication.fromMap(c)).toList();
  }
}
