// To parse this JSON data, do
//
//     final deliveryTypeModel = deliveryTypeModelFromMap(jsonString);

import 'dart:convert';

List<DeliveryType> deliveryTypeModelFromMap(String str) =>
    List<DeliveryType>.from(
        json.decode(str).map((x) => DeliveryType.fromMap(x)));

String deliveryTypeModelToMap(List<DeliveryType> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class DeliveryType {
  int id;
  String description;

  DeliveryType({
    required this.id,
    required this.description,
  });

  factory DeliveryType.fromMap(Map<String, dynamic> json) => DeliveryType(
        id: json["id"] == null ? null : json["id"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "description": description == null ? null : description,
      };
}
