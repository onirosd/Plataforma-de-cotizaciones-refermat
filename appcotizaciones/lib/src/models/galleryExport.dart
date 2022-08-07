import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:appcotizaciones/src/models/gallery.dart';
import 'package:appcotizaciones/src/models/galleryDetail.dart';

class GalleryExport {
  Gallery gallery;
  List<GalleryDetail> galleryDetail;

  GalleryExport({
    required this.gallery,
    required this.galleryDetail,
  });

  GalleryExport copyWith({
    Gallery? gallery,
    List<GalleryDetail>? galleryDetail,
  }) {
    return GalleryExport(
      gallery: gallery ?? this.gallery,
      galleryDetail: galleryDetail ?? this.galleryDetail,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'gallery': gallery.toMap()});
    result.addAll(
        {'galleryDetail': galleryDetail.map((x) => x.toMap()).toList()});

    return result;
  }

  factory GalleryExport.fromMap(Map<String, dynamic> map) {
    return GalleryExport(
      gallery: Gallery.fromMap(map['gallery']),
      galleryDetail: List<GalleryDetail>.from(
          map['galleryDetail']?.map((x) => GalleryDetail.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory GalleryExport.fromJson(String source) =>
      GalleryExport.fromMap(json.decode(source));

  @override
  String toString() =>
      'GalleryExport(gallery: $gallery, galleryDetail: $galleryDetail)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GalleryExport &&
        other.gallery == gallery &&
        listEquals(other.galleryDetail, galleryDetail);
  }

  @override
  int get hashCode => gallery.hashCode ^ galleryDetail.hashCode;
}
