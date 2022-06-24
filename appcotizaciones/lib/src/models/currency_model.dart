// To parse this JSON data, do
//
//     final currencyModel = currencyModelFromMap(jsonString);

import 'dart:convert';

List<Currency> currencyModelFromMap(String str) =>
    List<Currency>.from(json.decode(str).map((x) => Currency.fromMap(x)));

String currencyModelToMap(List<Currency> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Currency {
  Currency({
    this.id,
    this.currency,
  });

  int? id;
  String? currency;

  factory Currency.fromMap(Map<String, dynamic> json) => Currency(
        id: json["id"] == null ? null : json["id"],
        currency: json["currency"] == null ? null : json["currency"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "currency": currency == null ? null : currency,
      };
}
