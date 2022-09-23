import 'package:appcotizaciones/src/api/api.customer.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:async';
//import 'package:simple_form_crud/data/database_helper.dart';
class CustomerCtr {
  DatabaseHelper con = new DatabaseHelper();
//insertion
  /*Future<int> saveCustomer(Customer customer) async {
    var dbCustomer = await con.db;
    int res = await dbCustomer.insert("Customer", customer.toMap());
    return res;
  }
*/

  Future<int> batchInsertCustomers(List<Customer> listcustomers) async {
    var dbconn = await con.db;
    Batch batch = dbconn.batch();
    int estado = 0;
    await deleteAllCustomer();

    listcustomers.forEach((customer) {
      batch.insert('Customer', customer.toMap());
    });

    //await batch.commit(noResult: true);
    try {
      await batch.commit(continueOnError: false);
      estado = 1;
    } catch (e) {
      estado = 0;
    }

    return estado;
  }

  deleteAllCustomer() async {
    var dbCustomer = await con.db;
    await dbCustomer.rawQuery('DELETE FROM Customer');

    //return res;
  }

  Future<int> createCustomer(Customer newCustomer) async {
    //await deleteCustomer(newCustomer.codCustomer!);
    //await deleteAllCustomer();
    var dbCustomer = await con.db;
    int res = await dbCustomer.insert('Customer', newCustomer.toMap());

    return res;
  }

  //deletion
  Future<int> deleteCustomer(int customer) async {
    var dbCustomer = await con.db;
    //int res = await dbCustomer.rawDelete(
    //  'DELETE FROM Customer WHERE codCustomer = ${customer.toString()}');
    return await dbCustomer
        .rawDelete("DELETE FROM Customer where codCustomer = '$customer'");
    // return res;
  }

  /*Future<List<Customer>> getAllCustomer() async {
    var dbCustomer = await con.db;
    var res = await dbCustomer.query("Customer");

    List<Customer> list =
        res.isNotEmpty ? res.map((c) => Customer.fromMap(c)).toList() : null;
    return list;
  }
*/

  insertCustomer(Customer customer) async {
    // Get a reference to the database.

    var dbCustomer = await con.db;
    //var maxcodCustomer = await dbCustomer.rawQuery(
    //  "SELECT MAX(codCustomer)+1 as last_inserted_id FROM Customer");
    //customer.codCustomer = maxcodCustomer.first["last_inserted_id"];
    var raw = await dbCustomer.insert(
      'Customer',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  upDataCustomer() async {
    CustomerApiProvider api = new CustomerApiProvider();
    final customerData = await getCustomernoSincronice();
    api.uploadCustomers(customerData);
  }

  Future<int> updateCustomerOnebyOneInd(Customer customer) async {
    // Get a reference to the database.
    final db = await con.db;
    String asyncflag = customer.asyncFlag.toString();
    String flagforcemultimedia = customer.flagForceMultimedia.toString();
    String codCustomer = customer.codCustomer.toString();

    // Update the given Dog.
    return await db.rawUpdate(
        "UPDATE Customer SET asyncFlag = $asyncflag , flagForceMultimedia = $flagforcemultimedia WHERE codCustomer = '$codCustomer'");
  }

  Future<int> updateCustomerOnebyOne(Customer customer) async {
    // Get a reference to the database.
    final db = await con.db;
    String codCustomer = customer.codCustomer.toString();
    // Update the given Dog.
    return await db.update('Customer', customer.toMap(),
        // Ensure that the Dog has a matching id.
        where: "codCustomer = '$codCustomer'"
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        );
  }

  Future<List<Customer>> getCustomernoSincronice() async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer
        .rawQuery("SELECT * FROM Customer WHERE asyncFlag = 0 ");

    return maps.map((c) => Customer.fromMap(c)).toList();
  }

  Future<List<Customer>> getCustomerBycodUser(String codUser) async {
    var dbCustomer = await con.db;
    // String cod = codUser.toString();
    final List<Map<String, dynamic>> maps = await dbCustomer
        .rawQuery("SELECT * FROM Customer WHERE codCustomer = '$codUser' ");

    return maps.map((c) => Customer.fromMap(c)).toList();
  }

  Future<List<Customer>> getCustomerByName(String search) async {
    var dbCustomer = await con.db;

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "SELECT * FROM Customer WHERE numRucCustomer || ' ' || strName like '%$search%' ");

    return maps.map((c) => Customer.fromMap(c)).toList();
  }

  Future<List<Customer>> getCustomerByRUC(String ruc, String codCompany) async {
    var dbCustomer = await con.db;
    // var codcomp = codCompany.toString();
    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        "SELECT * FROM Customer WHERE numRucCustomer ='$ruc' and codCompany = $codCompany ");

    return maps.map((c) => Customer.fromMap(c)).toList();
  }

  /*Future<Customer> checkCustomer(String customer, String password) async {
    var dbCustomer = await con.db;
    var res = await dbCustomer.rawQuery("SELECT * FROM Customer WHERE username = '$user' and password = '$password'");
    
    if (res.length > 0) {
      return new User.fromMap(res.first);
    }
    return null;
  }*/

}
