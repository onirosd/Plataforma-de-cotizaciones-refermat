import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/gallery.dart';
import 'package:appcotizaciones/src/models/galleryDetail.dart';

class ComplementsCustoGalle {
  List<Customer> customer;
  List<Gallery> gallery;
  List<GalleryDetail> galleryDetail;

  ComplementsCustoGalle({
    required this.customer,
    required this.gallery,
    required this.galleryDetail,
  });

  ComplementsCustoGalle copyWith({
    List<Customer>? customer,
    List<Gallery>? gallery,
    List<GalleryDetail>? galleryDetail,
  }) {
    return ComplementsCustoGalle(
      customer: customer ?? this.customer,
      gallery: gallery ?? this.gallery,
      galleryDetail: galleryDetail ?? this.galleryDetail,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'customer': customer.map((x) => x.toMap()).toList()});
    result.addAll({'gallery': gallery.map((x) => x.toMap()).toList()});
    result.addAll(
        {'galleryDetail': galleryDetail.map((x) => x.toMap()).toList()});

    return result;
  }

  factory ComplementsCustoGalle.fromMap(Map<String, dynamic> map) {
    return ComplementsCustoGalle(
      customer:
          List<Customer>.from(map['customer']?.map((x) => Customer.fromMap(x))),
      gallery:
          List<Gallery>.from(map['gallery']?.map((x) => Gallery.fromMap(x))),
      galleryDetail: List<GalleryDetail>.from(
          map['galleryDetail']?.map((x) => GalleryDetail.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ComplementsCustoGalle.fromJson(String source) =>
      ComplementsCustoGalle.fromMap(json.decode(source));

  @override
  String toString() =>
      'ComplementsCustoGalle(customer: $customer, gallery: $gallery, galleryDetail: $galleryDetail)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ComplementsCustoGalle &&
        listEquals(other.customer, customer) &&
        listEquals(other.gallery, gallery) &&
        listEquals(other.galleryDetail, galleryDetail);
  }

  @override
  int get hashCode =>
      customer.hashCode ^ gallery.hashCode ^ galleryDetail.hashCode;
}
