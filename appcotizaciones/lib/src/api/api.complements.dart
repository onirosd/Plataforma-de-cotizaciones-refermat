import 'dart:convert';

import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/bank.dart';
import 'package:appcotizaciones/src/models/billingType.dart';
import 'package:appcotizaciones/src/models/company.dart';
import 'package:appcotizaciones/src/models/complements.dart';
import 'package:appcotizaciones/src/models/currency.dart';
import 'package:appcotizaciones/src/models/delivery_time_model.dart';
import 'package:appcotizaciones/src/models/delivery_type_model.dart';
import 'package:appcotizaciones/src/models/indicators.dart';
import 'package:appcotizaciones/src/models/payCondition.dart';
import 'package:appcotizaciones/src/models/paymentMethod.dart';
import 'package:appcotizaciones/src/models/response_error.dart';
import 'package:appcotizaciones/src/models/sub_tipo_multimedia.dart';
import 'package:appcotizaciones/src/models/tilist.dart';
import 'package:appcotizaciones/src/models/tiperson.dart';
import 'package:appcotizaciones/src/models/tipo_multimedia.dart';
// / import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import 'package:appcotizaciones/src/config/variables.dart';

class ComplementsApiProvider {
  DatabaseHelper con = new DatabaseHelper();

  // ignore: non_constant_identifier_names
  var url_complements =
      DIR_URL + "Appstock/controller/services/listarComplementarios.php";

  Future<List<Complements>> uploadComplements(
      int coduser, String company) async {
    // ResponseError error =
    //     new ResponseError(description: "", error: 0, success: 0);
    print("llegamos por aqui tambien !!! ....");
    SendUser user = new SendUser(user: coduser, company: company);
    List data = [];

    try {
      final response = await http.post(
        Uri.parse(url_complements),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user),
      );

      if (response.statusCode == 200) {
        data = json.decode(response.body);
      }
    } catch (e) {
      print("No tenemos Internet para complementos");
    }

    return data.map((job) => new Complements.fromMap(job)).toList();
  }

  Future<List<Complements>> getAllComplements() async {
    // CustomerCtr crt = new CustomerCtr();
    //List list = [];
    Complements com = new Complements();

    List data = [];
    //data['error'] = '';
    try {
      final response = await http.get(Uri.parse(url_complements),
          headers: {"Content-Type": "application/json"});

      data = json.decode(response.body); // Map.from(json.decode(response
      //.body)); //new Map<String, dynamic>.from(json.decode(response.body));

    } catch (e) {}

    return data.map((job) => new Complements.fromMap(job)).toList();
  }

  deleteDataComplements(String query) async {
    var dbCustomer = await con.db;

    final res = await dbCustomer.query(query);

    // return res;
  }

  Future<ResponseError> batchInsertComplements(
      List<Complements> complements) async {
    var dbconn = await con.db;
    Batch batch = dbconn.batch();
    int estado = 0;
    ResponseError responseerror =
        new ResponseError(description: '', error: 1, success: 0);

    // List<Company>? listcompany = complements[0].company!;
    List<TiList>? listtilist = complements[0].tilist!;
    List<TiPerson>? listtiperson = complements[0].tiperson!;
    List<Bank>? listbank = complements[0].bank!;
    List<PayCondition>? listpaycondition = complements[0].paycondition!;
    List<PaymentMethod>? listpaymentmethod = complements[0].paymentmethod!;
    List<BillingType>? listbillingtype = complements[0].billingtype!;
    List<Currency>? listcurrency = complements[0].currency!;
    List<DeliveryTime>? listdeliverytime = complements[0].deliverytime!;
    List<DeliveryType>? listdeliverytype = complements[0].deliverytype!;
    List<Ti_IndicatorsUser>? listindicators = complements[0].indicators!;
    List<TipoMultimedia>? listtipomultimedia = complements[0].tipomultimedia!;
    List<SubTipoMultimedia>? listsubtipomultimedia =
        complements[0].subtipomultimedia!;

    String queryDelet = "";

    print("entramos ....>>> ");
    print(complements);
    if (listtilist.length > 0) {
      batch.delete('Ti_List');
      listtilist.forEach((tilist) {
        batch.insert('Ti_List', tilist.toMap());
      });
      queryDelet = queryDelet + " DELETE FROM Ti_List;  ";
    }

    if (listtiperson.length > 0) {
      batch.delete('Ti_Person');
      listtiperson.forEach((tiperson) {
        batch.insert('Ti_Person', tiperson.toMap());
      });
      queryDelet = queryDelet + " DELETE FROM Ti_Person;  ";
    }

    if (listbank.length > 0) {
      batch.delete('Bank');
      listbank.forEach((bank) {
        batch.insert('Bank', bank.toMap());
      });
      queryDelet = queryDelet + " DELETE FROM Bank;  ";
    }

    if (listpaycondition.length > 0) {
      batch.delete('PayCondition');
      listpaycondition.forEach((paycondition) {
        batch.insert('PayCondition', paycondition.toMap());
      });
      queryDelet = queryDelet + " DELETE FROM PayCondition;  ";
    }

    if (listpaymentmethod.length > 0) {
      batch.delete('PaymentMethod');
      listpaymentmethod.forEach((paymentmethod) {
        batch.insert('PaymentMethod', paymentmethod.toMap());
      });
      queryDelet = queryDelet + " DELETE FROM PaymentMethod;  ";
    }

    if (listbillingtype.length > 0) {
      batch.delete('BillingType');
      listbillingtype.forEach((billingtype) {
        batch.insert('BillingType', billingtype.toMap());
      });
      queryDelet = queryDelet + " DELETE FROM BillingType;  ";
    }

    if (listcurrency.length > 0) {
      batch.delete('Currency');
      listcurrency.forEach((currency) {
        batch.insert('Currency', currency.toMap());
      });
      queryDelet = queryDelet + " DELETE FROM Currency;  ";
    }

    if (listdeliverytime.length > 0) {
      batch.delete('DeliveryTime');
      listdeliverytime.forEach((deliverytime) {
        batch.insert('DeliveryTime', deliverytime.toMap());
      });
      queryDelet = queryDelet + " DELETE FROM DeliveryTime;  ";
    }

    if (listdeliverytype.length > 0) {
      batch.delete('DeliveryType');
      listdeliverytype.forEach((deliverytype) {
        batch.insert('DeliveryType', deliverytype.toMap());
      });
      queryDelet = queryDelet + " DELETE FROM DeliveryType;  ";
    }

    //if (listindicators.length > 0) {
    batch.delete('Ti_IndicatorsUser');
    listindicators.forEach((indicator) {
      batch.insert('Ti_IndicatorsUser', indicator.toMap());
    });

    queryDelet = queryDelet + " DELETE FROM Ti_IndicatorsUser;  ";
    // }

    if (listtipomultimedia.length > 0) {
      batch.delete('TipoMultimedia');
      listtipomultimedia.forEach((tipomultimedia) {
        batch.insert('TipoMultimedia', tipomultimedia.toMap());
      });
      queryDelet = queryDelet + " DELETE FROM TipoMultimedia;  ";
    }

    if (listsubtipomultimedia.length > 0) {
      batch.delete('SubTipoMultimedia');
      listsubtipomultimedia.forEach((subtipomultimedia) {
        batch.insert('SubTipoMultimedia', subtipomultimedia.toMap());
      });
      queryDelet = queryDelet + " DELETE FROM SubTipoMultimedia;  ";
    }

    //await batch.commit(noResult: true);
    try {
      // await deleteDataComplements(queryDelet);
      await batch.commit(continueOnError: false);
      responseerror.error = 0;
      responseerror.success = 1;
      responseerror.description = 'Tablas Actualizadas con Exito';
    } catch (e) {
      estado = 0;

      responseerror.description = e.toString();

      print(e.toString());
    }

    /*
    final List<dynamic> res =
        (await batch.commit(continueOnError: false)).map<dynamic>((dynamic d) {
      if (d is DatabaseException) {
        debugPrint(d.toString());
        return -1;
      }
      return d;
    }).toList(); */

    return responseerror;
  }

  /*
  Future<Map<String, dynamic>> getAllCompanys() async {
    // CustomerCtr crt = new CustomerCtr();
    //List list = [];
    Map<String, dynamic> data = {};
    data['error'] = '';
    try {
      final response = await http.get(Uri.parse(url_complements),
          headers: {"Content-Type": "application/json"});

      data = Map.from(json.decode(response
          .body)); //new Map<String, dynamic>.from(json.decode(response.body));

      //list = json.decode(response.body);
    } catch (e) {
      data['error'] = e.toString();
    }

    //print(data['company']);

    return data; //list.toList();
    //return list.map((job) => new Company.fromMap(job)).toList();
    //return (response.data as List).map((customer) {}).toList();
  }

*/

}

class SendUser {
  int user;
  String company;

  SendUser({
    required this.user,
    required this.company,
  });

  SendUser copyWith({
    int? user,
    String? company,
  }) {
    return SendUser(
      user: user ?? this.user,
      company: company ?? this.company,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'user': user});
    result.addAll({'company': company});

    return result;
  }

  factory SendUser.fromMap(Map<String, dynamic> map) {
    return SendUser(
      user: map['user']?.toInt() ?? 0,
      company: map['company'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SendUser.fromJson(String source) =>
      SendUser.fromMap(json.decode(source));

  @override
  String toString() => 'SendUser(user: $user, company: $company)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SendUser && other.user == user && other.company == company;
  }

  @override
  int get hashCode => user.hashCode ^ company.hashCode;
}
