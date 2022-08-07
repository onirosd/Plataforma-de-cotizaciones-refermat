import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/gallery.dart';
import 'package:appcotizaciones/src/models/galleryDetail.dart';

class GalleriesplusCustomer {
  Customer? customer;
  Gallery? gallery;
  List<GalleryDetail>? galleriesdetail;

  GalleriesplusCustomer({
    this.customer,
    this.gallery,
    this.galleriesdetail,
  });

  GalleriesplusCustomer copyWith({
    Customer? customer,
    Gallery? gallery,
    List<GalleryDetail>? galleriesdetail,
  }) {
    return GalleriesplusCustomer(
      customer: customer ?? this.customer,
      gallery: gallery ?? this.gallery,
      galleriesdetail: galleriesdetail ?? this.galleriesdetail,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (customer != null) {
      result.addAll({'customer': customer!.toMap()});
    }
    if (gallery != null) {
      result.addAll({'gallery': gallery!.toMap()});
    }
    if (galleriesdetail != null) {
      result.addAll(
          {'galleriesdetail': galleriesdetail!.map((x) => x.toMap()).toList()});
    }

    return result;
  }

  factory GalleriesplusCustomer.fromMap(Map<String, dynamic> map) {
    return GalleriesplusCustomer(
      customer:
          map['customer'] != null ? Customer.fromMap(map['customer']) : null,
      gallery: map['gallery'] != null ? Gallery.fromMap(map['gallery']) : null,
      galleriesdetail: map['galleriesdetail'] != null
          ? List<GalleryDetail>.from(
              map['galleriesdetail']?.map((x) => GalleryDetail.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GalleriesplusCustomer.fromJson(String source) =>
      GalleriesplusCustomer.fromMap(json.decode(source));

  @override
  String toString() =>
      'GalleriesplusCustomer(customer: $customer, gallery: $gallery, galleriesdetail: $galleriesdetail)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GalleriesplusCustomer &&
        other.customer == customer &&
        other.gallery == gallery &&
        listEquals(other.galleriesdetail, galleriesdetail);
  }

  @override
  int get hashCode =>
      customer.hashCode ^ gallery.hashCode ^ galleriesdetail.hashCode;
}
