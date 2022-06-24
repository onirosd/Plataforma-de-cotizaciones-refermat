import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/billing.dart';
import 'package:appcotizaciones/src/models/complementsBillQuo.dart';
import 'package:appcotizaciones/src/models/quotation_model.dart';
import 'package:appcotizaciones/src/models/quotation_product_model.dart';
import 'package:appcotizaciones/src/models/response_error.dart';

import 'package:appcotizaciones/src/config/variables.dart';

class ComplementsQuoBillApiProvider {
  DatabaseHelper con = new DatabaseHelper();

  // ignore: non_constant_identifier_names
  var url_complements =
      DIR_URL + "Appstock/controller/services/SyncBillQuotation.php";

  Future<List<ComplementsBillQuo>> uploadComplements(
      int coduser, String bgn, String end, String position) async {
    // ResponseError error =
    //     new ResponseError(description: "", error: 0, success: 0);

    RequestBillQuo reqe = new RequestBillQuo(
        bgn: bgn, end: end, codUser: coduser, position: position);
    List data = [];

    try {
      final response = await http.post(
        Uri.parse(url_complements),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(reqe),
      );

      if (response.statusCode == 200) {
        data = json.decode(response.body);
        //  print(data);
      }
    } catch (e) {}

    return data.map((job) => new ComplementsBillQuo.fromMap(job)).toList();
  }

  Future<ResponseError> batchInsertComplements(
      List<ComplementsBillQuo> complements) async {
    var dbconn = await con.db;
    Batch batch = dbconn.batch();
    int estado = 0;
    ResponseError responseerror =
        new ResponseError(description: '', error: 1, success: 0);

    List<Quotation>? listQuotation = complements[0].quotations;
    List<QuotationProduct>? listQuotationProduct =
        complements[0].quotationsproducts;
    List<Billing>? listtiBilling = complements[0].billings;

    if (listQuotation.length > 0) {
      // batch.delete('Quotation'); //('Company', company.toMap());

      listQuotation.forEach((quotation) {
        if (quotation.state == '5' && quotation.updateflg == 1) {
          quotation.state = '2';
        }
        batch.insert('Quotation', quotation.toMap());
      });
      // queryDelet = queryDelet + " DELETE FROM Company;  ";
    }

    if (listQuotationProduct.length > 0) {
      // batch.delete('QuotationProducts'); //('Company', company.toMap());
      listQuotationProduct.forEach((quotationprod) {
        batch.insert('QuotationProducts', quotationprod.toMap());
      });
      // queryDelet = queryDelet + " DELETE FROM Company;  ";
    }

    if (listtiBilling.length > 0) {
      // batch.delete('Billing'); //('Company', company.toMap());
      listtiBilling.forEach((billing) {
        batch.insert('Billing', billing.toMap());
      });
    }
    // queryDelet = queryDelet + " DELETE FROM Company;  ";

    try {
      // await deleteDataComplements(queryDelet);
      await batch.commit(continueOnError: false);
      responseerror.error = 0;
      responseerror.success = 1;
      responseerror.description =
          'Tablas de Recibos y Cotizacion Sincronizadas con Exito';
    } catch (e) {
      estado = 0;

      responseerror.description = e.toString();

      print(e.toString());
    }

    return responseerror;
  }
}

class RequestBillQuo {
  int codUser;
  String bgn;
  String end;
  String position;

  RequestBillQuo({
    required this.codUser,
    required this.bgn,
    required this.end,
    required this.position,
  });

  RequestBillQuo copyWith({
    int? codUser,
    String? bgn,
    String? end,
    String? position,
  }) {
    return RequestBillQuo(
      codUser: codUser ?? this.codUser,
      bgn: bgn ?? this.bgn,
      end: end ?? this.end,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codUser': codUser,
      'bgn': bgn,
      'end': end,
      'position': position,
    };
  }

  factory RequestBillQuo.fromMap(Map<String, dynamic> map) {
    return RequestBillQuo(
      codUser: map['codUser'],
      bgn: map['bgn'],
      end: map['end'],
      position: map['position'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RequestBillQuo.fromJson(String source) =>
      RequestBillQuo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RequestBillQuo(codUser: $codUser, bgn: $bgn, end: $end, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RequestBillQuo &&
        other.codUser == codUser &&
        other.bgn == bgn &&
        other.end == end &&
        other.position == position;
  }

  @override
  int get hashCode {
    return codUser.hashCode ^ bgn.hashCode ^ end.hashCode ^ position.hashCode;
  }
}
