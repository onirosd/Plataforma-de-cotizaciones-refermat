import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:appcotizaciones/src/models/billing.dart';
import 'package:appcotizaciones/src/models/quotation_model.dart';
import 'package:appcotizaciones/src/models/quotation_product_model.dart';

class ComplementsBillQuo {
  List<Quotation> quotations;
  List<QuotationProduct> quotationsproducts;
  List<Billing> billings;

  ComplementsBillQuo({
    required this.quotations,
    required this.quotationsproducts,
    required this.billings,
  });

  ComplementsBillQuo copyWith({
    List<Quotation>? quotations,
    List<QuotationProduct>? quotationsproducts,
    List<Billing>? billings,
  }) {
    return ComplementsBillQuo(
      quotations: quotations ?? this.quotations,
      quotationsproducts: quotationsproducts ?? this.quotationsproducts,
      billings: billings ?? this.billings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quotations': quotations.map((x) => x.toMap()).toList(),
      'quotationsproducts': quotationsproducts.map((x) => x.toMap()).toList(),
      'billings': billings.map((x) => x.toMap()).toList(),
    };
  }

  factory ComplementsBillQuo.fromMap(Map<String, dynamic> map) {
    return ComplementsBillQuo(
      quotations: List<Quotation>.from(
          map['quotations']?.map((x) => Quotation.fromMap(x))),
      quotationsproducts: List<QuotationProduct>.from(
          map['quotationsproducts']?.map((x) => QuotationProduct.fromMap(x))),
      billings:
          List<Billing>.from(map['billings']?.map((x) => Billing.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ComplementsBillQuo.fromJson(String source) =>
      ComplementsBillQuo.fromMap(json.decode(source));

  @override
  String toString() =>
      'ComplementsBillQuo(quotations: $quotations, quotationsproducts: $quotationsproducts, billings: $billings)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ComplementsBillQuo &&
        listEquals(other.quotations, quotations) &&
        listEquals(other.quotationsproducts, quotationsproducts) &&
        listEquals(other.billings, billings);
  }

  @override
  int get hashCode =>
      quotations.hashCode ^ quotationsproducts.hashCode ^ billings.hashCode;
}
