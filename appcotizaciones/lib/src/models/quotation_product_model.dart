// To parse this JSON data, do
//
//     final quotationProduct = quotationProductFromMap(jsonString);

import 'dart:convert';

class QuotationProduct {
  String? id;
  String? quotation_id;
  int? product_id;
  String? create_date;
  String? create_user;
  String? width_internal_diameter;
  String? long;
  String? product_name;
  String? quantity;
  String sub_total;
  String? total;
  String? unity_price;
  String diameter;
  String theoretical_weight;
  String unity_product;
  String cod_TiProducts;
  String comment;
  String cod_TiAlmacen;

  QuotationProduct({
    this.id,
    this.quotation_id,
    this.product_id,
    this.create_date,
    this.create_user,
    this.width_internal_diameter,
    this.long,
    this.product_name,
    this.quantity,
    required this.sub_total,
    this.total,
    this.unity_price,
    required this.diameter,
    required this.theoretical_weight,
    required this.unity_product,
    required this.cod_TiProducts,
    required this.comment,
    required this.cod_TiAlmacen,
  });

  QuotationProduct copyWith({
    String? id,
    String? quotation_id,
    int? product_id,
    String? create_date,
    String? create_user,
    String? width_internal_diameter,
    String? long,
    String? product_name,
    String? quantity,
    String? sub_total,
    String? total,
    String? unity_price,
    String? diameter,
    String? theoretical_weight,
    String? unity_product,
    String? cod_TiProducts,
    String? comment,
    String? cod_TiAlmacen,
  }) {
    return QuotationProduct(
      id: id ?? this.id,
      quotation_id: quotation_id ?? this.quotation_id,
      product_id: product_id ?? this.product_id,
      create_date: create_date ?? this.create_date,
      create_user: create_user ?? this.create_user,
      width_internal_diameter:
          width_internal_diameter ?? this.width_internal_diameter,
      long: long ?? this.long,
      product_name: product_name ?? this.product_name,
      quantity: quantity ?? this.quantity,
      sub_total: sub_total ?? this.sub_total,
      total: total ?? this.total,
      unity_price: unity_price ?? this.unity_price,
      diameter: diameter ?? this.diameter,
      theoretical_weight: theoretical_weight ?? this.theoretical_weight,
      unity_product: unity_product ?? this.unity_product,
      cod_TiProducts: cod_TiProducts ?? this.cod_TiProducts,
      comment: comment ?? this.comment,
      cod_TiAlmacen: cod_TiAlmacen ?? this.cod_TiAlmacen,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (quotation_id != null) {
      result.addAll({'quotation_id': quotation_id});
    }
    if (product_id != null) {
      result.addAll({'product_id': product_id});
    }
    if (create_date != null) {
      result.addAll({'create_date': create_date});
    }
    if (create_user != null) {
      result.addAll({'create_user': create_user});
    }
    if (width_internal_diameter != null) {
      result.addAll({'width_internal_diameter': width_internal_diameter});
    }
    if (long != null) {
      result.addAll({'long': long});
    }
    if (product_name != null) {
      result.addAll({'product_name': product_name});
    }
    if (quantity != null) {
      result.addAll({'quantity': quantity});
    }
    result.addAll({'sub_total': sub_total});
    if (total != null) {
      result.addAll({'total': total});
    }
    if (unity_price != null) {
      result.addAll({'unity_price': unity_price});
    }
    result.addAll({'diameter': diameter});
    result.addAll({'theoretical_weight': theoretical_weight});
    result.addAll({'unity_product': unity_product});
    result.addAll({'cod_TiProducts': cod_TiProducts});
    result.addAll({'comment': comment});
    result.addAll({'cod_TiAlmacen': cod_TiAlmacen});

    return result;
  }

  factory QuotationProduct.fromMap(Map<String, dynamic> map) {
    return QuotationProduct(
      id: map['id'],
      quotation_id: map['quotation_id'],
      product_id: map['product_id']?.toInt(),
      create_date: map['create_date'],
      create_user: map['create_user'],
      width_internal_diameter: map['width_internal_diameter'],
      long: map['long'],
      product_name: map['product_name'],
      quantity: map['quantity'],
      sub_total: map['sub_total'] ?? '',
      total: map['total'],
      unity_price: map['unity_price'],
      diameter: map['diameter'] ?? '',
      theoretical_weight: map['theoretical_weight'] ?? '',
      unity_product: map['unity_product'] ?? '',
      cod_TiProducts: map['cod_TiProducts'] ?? '',
      comment: map['comment'] ?? '',
      cod_TiAlmacen: map['cod_TiAlmacen'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory QuotationProduct.fromJson(String source) =>
      QuotationProduct.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuotationProduct(id: $id, quotation_id: $quotation_id, product_id: $product_id, create_date: $create_date, create_user: $create_user, width_internal_diameter: $width_internal_diameter, long: $long, product_name: $product_name, quantity: $quantity, sub_total: $sub_total, total: $total, unity_price: $unity_price, diameter: $diameter, theoretical_weight: $theoretical_weight, unity_product: $unity_product, cod_TiProducts: $cod_TiProducts, comment: $comment, cod_TiAlmacen: $cod_TiAlmacen)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuotationProduct &&
        other.id == id &&
        other.quotation_id == quotation_id &&
        other.product_id == product_id &&
        other.create_date == create_date &&
        other.create_user == create_user &&
        other.width_internal_diameter == width_internal_diameter &&
        other.long == long &&
        other.product_name == product_name &&
        other.quantity == quantity &&
        other.sub_total == sub_total &&
        other.total == total &&
        other.unity_price == unity_price &&
        other.diameter == diameter &&
        other.theoretical_weight == theoretical_weight &&
        other.unity_product == unity_product &&
        other.cod_TiProducts == cod_TiProducts &&
        other.comment == comment &&
        other.cod_TiAlmacen == cod_TiAlmacen;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        quotation_id.hashCode ^
        product_id.hashCode ^
        create_date.hashCode ^
        create_user.hashCode ^
        width_internal_diameter.hashCode ^
        long.hashCode ^
        product_name.hashCode ^
        quantity.hashCode ^
        sub_total.hashCode ^
        total.hashCode ^
        unity_price.hashCode ^
        diameter.hashCode ^
        theoretical_weight.hashCode ^
        unity_product.hashCode ^
        cod_TiProducts.hashCode ^
        comment.hashCode ^
        cod_TiAlmacen.hashCode;
  }
}
