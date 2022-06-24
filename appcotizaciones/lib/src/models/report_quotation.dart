import 'dart:convert';
import 'dart:io' as io2;

import 'package:flutter/foundation.dart';

import 'package:appcotizaciones/src/models/company.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/quotation_model.dart';
import 'package:appcotizaciones/src/models/quotation_product_model.dart';

class ReportDataQuotation {
  String codCompany;
  Quotation quotationfin;
  List<QuotationProduct> listprodquotationfin;
  Customer customer;
  String salesperson;
  String paycondition;
  String deliverytype;
  String deliverytime;
  int currency;
  String? currencyName;
  String path;
  Company company;

  ReportDataQuotation({
    required this.codCompany,
    required this.quotationfin,
    required this.listprodquotationfin,
    required this.customer,
    required this.salesperson,
    required this.paycondition,
    required this.deliverytype,
    required this.deliverytime,
    required this.currency,
    this.currencyName,
    required this.path,
    required this.company,
  });

  ReportDataQuotation copyWith({
    String? codCompany,
    Quotation? quotationfin,
    List<QuotationProduct>? listprodquotationfin,
    Customer? customer,
    String? salesperson,
    String? paycondition,
    String? deliverytype,
    String? deliverytime,
    int? currency,
    String? currencyName,
    String? path,
    Company? company,
  }) {
    return ReportDataQuotation(
      codCompany: codCompany ?? this.codCompany,
      quotationfin: quotationfin ?? this.quotationfin,
      listprodquotationfin: listprodquotationfin ?? this.listprodquotationfin,
      customer: customer ?? this.customer,
      salesperson: salesperson ?? this.salesperson,
      paycondition: paycondition ?? this.paycondition,
      deliverytype: deliverytype ?? this.deliverytype,
      deliverytime: deliverytime ?? this.deliverytime,
      currency: currency ?? this.currency,
      currencyName: currencyName ?? this.currencyName,
      path: path ?? this.path,
      company: company ?? this.company,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'codCompany': codCompany});
    result.addAll({'quotationfin': quotationfin.toMap()});
    result.addAll({
      'listprodquotationfin':
          listprodquotationfin.map((x) => x.toMap()).toList()
    });
    result.addAll({'customer': customer.toMap()});
    result.addAll({'salesperson': salesperson});
    result.addAll({'paycondition': paycondition});
    result.addAll({'deliverytype': deliverytype});
    result.addAll({'deliverytime': deliverytime});
    result.addAll({'currency': currency});
    if (currencyName != null) {
      result.addAll({'currencyName': currencyName});
    }
    result.addAll({'path': path});
    result.addAll({'company': company.toMap()});

    return result;
  }

  factory ReportDataQuotation.fromMap(Map<String, dynamic> map) {
    return ReportDataQuotation(
      codCompany: map['codCompany'] ?? '',
      quotationfin: Quotation.fromMap(map['quotationfin']),
      listprodquotationfin: List<QuotationProduct>.from(
          map['listprodquotationfin']?.map((x) => QuotationProduct.fromMap(x))),
      customer: Customer.fromMap(map['customer']),
      salesperson: map['salesperson'] ?? '',
      paycondition: map['paycondition'] ?? '',
      deliverytype: map['deliverytype'] ?? '',
      deliverytime: map['deliverytime'] ?? '',
      currency: map['currency']?.toInt() ?? 0,
      currencyName: map['currencyName'],
      path: map['path'] ?? '',
      company: Company.fromMap(map['company']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportDataQuotation.fromJson(String source) =>
      ReportDataQuotation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReportDataQuotation(codCompany: $codCompany, quotationfin: $quotationfin, listprodquotationfin: $listprodquotationfin, customer: $customer, salesperson: $salesperson, paycondition: $paycondition, deliverytype: $deliverytype, deliverytime: $deliverytime, currency: $currency, currencyName: $currencyName, path: $path, company: $company)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReportDataQuotation &&
        other.codCompany == codCompany &&
        other.quotationfin == quotationfin &&
        listEquals(other.listprodquotationfin, listprodquotationfin) &&
        other.customer == customer &&
        other.salesperson == salesperson &&
        other.paycondition == paycondition &&
        other.deliverytype == deliverytype &&
        other.deliverytime == deliverytime &&
        other.currency == currency &&
        other.currencyName == currencyName &&
        other.path == path &&
        other.company == company;
  }

  @override
  int get hashCode {
    return codCompany.hashCode ^
        quotationfin.hashCode ^
        listprodquotationfin.hashCode ^
        customer.hashCode ^
        salesperson.hashCode ^
        paycondition.hashCode ^
        deliverytype.hashCode ^
        deliverytime.hashCode ^
        currency.hashCode ^
        currencyName.hashCode ^
        path.hashCode ^
        company.hashCode;
  }
}
