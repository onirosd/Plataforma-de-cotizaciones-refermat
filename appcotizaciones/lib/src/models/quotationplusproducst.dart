import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/quotation_model.dart';
import 'package:appcotizaciones/src/models/quotation_product_model.dart';

class QuotationPlusProducts {
  Quotation quotat;
  List<QuotationProduct> listproduct;
  String salesperson;
  Customer customer;
  int? main_switch;

  QuotationPlusProducts({
    required this.quotat,
    required this.listproduct,
    required this.salesperson,
    required this.customer,
    this.main_switch,
  });

  QuotationPlusProducts copyWith({
    Quotation? quotat,
    List<QuotationProduct>? listproduct,
    String? salesperson,
    Customer? customer,
    int? main_switch,
  }) {
    return QuotationPlusProducts(
      quotat: quotat ?? this.quotat,
      listproduct: listproduct ?? this.listproduct,
      salesperson: salesperson ?? this.salesperson,
      customer: customer ?? this.customer,
      main_switch: main_switch ?? this.main_switch,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'quotat': quotat.toMap()});
    result.addAll({'listproduct': listproduct.map((x) => x.toMap()).toList()});
    result.addAll({'salesperson': salesperson});
    result.addAll({'customer': customer.toMap()});
    if (main_switch != null) {
      result.addAll({'main_switch': main_switch});
    }

    return result;
  }

  factory QuotationPlusProducts.fromMap(Map<String, dynamic> map) {
    return QuotationPlusProducts(
      quotat: Quotation.fromMap(map['quotat']),
      listproduct: List<QuotationProduct>.from(
          map['listproduct']?.map((x) => QuotationProduct.fromMap(x))),
      salesperson: map['salesperson'] ?? '',
      customer: Customer.fromMap(map['customer']),
      main_switch: map['main_switch']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuotationPlusProducts.fromJson(String source) =>
      QuotationPlusProducts.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuotationPlusProducts(quotat: $quotat, listproduct: $listproduct, salesperson: $salesperson, customer: $customer, main_switch: $main_switch)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuotationPlusProducts &&
        other.quotat == quotat &&
        listEquals(other.listproduct, listproduct) &&
        other.salesperson == salesperson &&
        other.customer == customer &&
        other.main_switch == main_switch;
  }

  @override
  int get hashCode {
    return quotat.hashCode ^
        listproduct.hashCode ^
        salesperson.hashCode ^
        customer.hashCode ^
        main_switch.hashCode;
  }
}

class QuotationProductsExport {
  Quotation quotat;
  List<QuotationProduct> listproduct;
  QuotationProductsExport({
    required this.quotat,
    required this.listproduct,
  });

  QuotationProductsExport copyWith({
    Quotation? quotat,
    List<QuotationProduct>? listproduct,
  }) {
    return QuotationProductsExport(
      quotat: quotat ?? this.quotat,
      listproduct: listproduct ?? this.listproduct,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quotat': quotat.toMap(),
      'listproduct': listproduct.map((x) => x.toMap()).toList(),
    };
  }

  factory QuotationProductsExport.fromMap(Map<String, dynamic> map) {
    return QuotationProductsExport(
      quotat: Quotation.fromMap(map['quotat']),
      listproduct: List<QuotationProduct>.from(
          map['listproduct']?.map((x) => QuotationProduct.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuotationProductsExport.fromJson(String source) =>
      QuotationProductsExport.fromMap(json.decode(source));

  @override
  String toString() =>
      'QuotationProductsExport(quotat: $quotat, listproduct: $listproduct)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuotationProductsExport &&
        other.quotat == quotat &&
        listEquals(other.listproduct, listproduct);
  }

  @override
  int get hashCode => quotat.hashCode ^ listproduct.hashCode;
}
