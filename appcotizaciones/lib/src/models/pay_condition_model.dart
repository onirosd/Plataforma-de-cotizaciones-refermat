// To parse this JSON data, do
//
//     final PayCondition2Model = PayCondition2ModelFromMap(jsonString);

import 'dart:convert';

List<PayCondition2> PayCondition2ModelFromMap(String str) =>
    List<PayCondition2>.from(
        json.decode(str).map((x) => PayCondition2.fromMap(x)));

String PayCondition2ModelToMap(List<PayCondition2> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class PayCondition2 {
  int id;
  String description;

  PayCondition2({
    required this.id,
    required this.description,
  });

  factory PayCondition2.fromMap(Map<String, dynamic> json) => PayCondition2(
        id: json["id"] == null ? null : json["id"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "description": description == null ? null : description,
      };
}
