// To parse this JSON data, do
//
//     final deliveryTimeModel = deliveryTimeModelFromMap(jsonString);

import 'dart:convert';

List<DeliveryTime> deliveryTimeModelFromMap(String str) =>
    List<DeliveryTime>.from(
        json.decode(str).map((x) => DeliveryTime.fromMap(x)));

String deliveryTimeModelToMap(List<DeliveryTime> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class DeliveryTime {
  int id;
  String description;
  String deliveryTimeText;

  DeliveryTime({
    required this.id,
    required this.description,
    required this.deliveryTimeText,
  });

  factory DeliveryTime.fromMap(Map<String, dynamic> json) => DeliveryTime(
        id: json["id"] == null ? null : json["id"],
        description: json["description"] == null ? null : json["description"],
        deliveryTimeText:
            json["delivery_time"] == null ? null : json["delivery_time"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "description": description == null ? null : description,
        "delivery_time": deliveryTimeText == null ? null : deliveryTimeText,
      };
}
