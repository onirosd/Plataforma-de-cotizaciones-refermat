import 'dart:convert';

import 'package:flutter/material.dart';

class Quotationv0 {
  int codQuotation;
  DateTime dteDateQuotation;
  String strNameBusiness;
  int codUser;
  int codCustomer;
  String strObservation;
  int codPayCondition;
  int codDeliveryType;
  int codDeliveryTime;
  int codCurrency;
  double numSubTotal;
  double numTotal;
  double numIgv;
  DateTime dteCreateDate;
  String strCreateUser;
  DateTime dteUpdateDate;
  String strUpdateUser;
  int flgState;
  int codQuotationParents;
  int codCompany;

  Quotationv0({
    required this.codQuotation,
    required this.dteDateQuotation,
    required this.strNameBusiness,
    required this.codUser,
    required this.codCustomer,
    required this.strObservation,
    required this.codPayCondition,
    required this.codDeliveryType,
    required this.codDeliveryTime,
    required this.codCurrency,
    required this.numSubTotal,
    required this.numTotal,
    required this.numIgv,
    required this.dteCreateDate,
    required this.strCreateUser,
    required this.dteUpdateDate,
    required this.strUpdateUser,
    required this.flgState,
    required this.codQuotationParents,
    required this.codCompany,
  });

  Map<String, dynamic> toMap() {
    return {
      'codQuotation': codQuotation,
      'dteDateQuotation': dteDateQuotation.millisecondsSinceEpoch,
      'strNameBusiness': strNameBusiness,
      'codUser': codUser,
      'codCustomer': codCustomer,
      'strObservation': strObservation,
      'codPayCondition': codPayCondition,
      'codDeliveryType': codDeliveryType,
      'codDeliveryTime': codDeliveryTime,
      'codCurrency': codCurrency,
      'numSubTotal': numSubTotal,
      'numTotal': numTotal,
      'numIgv': numIgv,
      'dteCreateDate': dteCreateDate.millisecondsSinceEpoch,
      'strCreateUser': strCreateUser,
      'dteUpdateDate': dteUpdateDate.millisecondsSinceEpoch,
      'strUpdateUser': strUpdateUser,
      'flgState': flgState,
      'codQuotationParents': codQuotationParents,
      'codCompany': codCompany,
    };
  }

  factory Quotationv0.fromMap(Map<String, dynamic> map) {
    return Quotationv0(
      codQuotation: map['codQuotation'],
      dteDateQuotation:
          DateTime.fromMillisecondsSinceEpoch(map['dteDateQuotation']),
      strNameBusiness: map['strNameBusiness'],
      codUser: map['codUser'],
      codCustomer: map['codCustomer'],
      strObservation: map['strObservation'],
      codPayCondition: map['codPayCondition'],
      codDeliveryType: map['codDeliveryType'],
      codDeliveryTime: map['codDeliveryTime'],
      codCurrency: map['codCurrency'],
      numSubTotal: map['numSubTotal'],
      numTotal: map['numTotal'],
      numIgv: map['numIgv'],
      dteCreateDate: DateTime.fromMillisecondsSinceEpoch(map['dteCreateDate']),
      strCreateUser: map['strCreateUser'],
      dteUpdateDate: DateTime.fromMillisecondsSinceEpoch(map['dteUpdateDate']),
      strUpdateUser: map['strUpdateUser'],
      flgState: map['flgState'],
      codQuotationParents: map['codQuotationParents'],
      codCompany: map['codCompany'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Quotationv0.fromJson(String source) =>
      Quotationv0.fromMap(json.decode(source));
}
