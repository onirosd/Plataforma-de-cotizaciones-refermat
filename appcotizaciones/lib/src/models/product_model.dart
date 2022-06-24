// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

List<Product> productFromMap(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromMap(x)));

String productToMap(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Product {
  Product({
    required this.id,
    required this.nameProduct,
    required this.unit,
    required this.diameter,
    required this.theoreticalWeight,
    required this.categoryProduct,
  });

  int id;
  String nameProduct;
  String unit;
  String diameter;
  String theoreticalWeight;
  String categoryProduct;

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"] == null ? null : json["id"],
        nameProduct: json["name_product"] == null ? null : json["name_product"],
        unit: json["unit"] == null ? null : json["unit"],
        diameter: json["diameter"] == null ? null : json["diameter"],
        theoreticalWeight: json["theoretical_weight"] == null
            ? null
            : json["theoretical_weight"],
        categoryProduct:
            json["category_product"] == null ? null : json["category_product"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name_product": nameProduct == null ? null : nameProduct,
        "unit": unit == null ? null : unit,
        "diameter": diameter == null ? null : diameter,
        "theoretical_weight":
            theoreticalWeight == null ? null : theoreticalWeight,
        "category_product": categoryProduct == null ? null : categoryProduct,
      };
}
