import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:appcotizaciones/src/models/gallery.dart';
import 'package:appcotizaciones/src/models/galleryDetail.dart';
import 'package:appcotizaciones/src/models/galleryDetailSubtipos.dart';

class GalleryExport {
  Gallery gallery;
  List<GalleryDetail> galleryDetail;
  List<GalleryDetailSubtipos> galleriesdetailsubtipos;

  GalleryExport({
    required this.gallery,
    required this.galleryDetail,
    required this.galleriesdetailsubtipos,
  });

  GalleryExport copyWith({
    Gallery? gallery,
    List<GalleryDetail>? galleryDetail,
    List<GalleryDetailSubtipos>? galleriesdetailsubtipos,
  }) {
    return GalleryExport(
      gallery: gallery ?? this.gallery,
      galleryDetail: galleryDetail ?? this.galleryDetail,
      galleriesdetailsubtipos:
          galleriesdetailsubtipos ?? this.galleriesdetailsubtipos,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'gallery': gallery.toMap()});
    result.addAll(
        {'galleryDetail': galleryDetail.map((x) => x.toMap()).toList()});
    result.addAll({
      'galleriesdetailsubtipos':
          galleriesdetailsubtipos.map((x) => x.toMap()).toList()
    });

    return result;
  }

  factory GalleryExport.fromMap(Map<String, dynamic> map) {
    return GalleryExport(
      gallery: Gallery.fromMap(map['gallery']),
      galleryDetail: List<GalleryDetail>.from(
          map['galleryDetail']?.map((x) => GalleryDetail.fromMap(x))),
      galleriesdetailsubtipos: List<GalleryDetailSubtipos>.from(
          map['galleriesdetailsubtipos']
              ?.map((x) => GalleryDetailSubtipos.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory GalleryExport.fromJson(String source) =>
      GalleryExport.fromMap(json.decode(source));

  @override
  String toString() =>
      'GalleryExport(gallery: $gallery, galleryDetail: $galleryDetail, galleriesdetailsubtipos: $galleriesdetailsubtipos)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GalleryExport &&
        other.gallery == gallery &&
        listEquals(other.galleryDetail, galleryDetail) &&
        listEquals(other.galleriesdetailsubtipos, galleriesdetailsubtipos);
  }

  @override
  int get hashCode =>
      gallery.hashCode ^
      galleryDetail.hashCode ^
      galleriesdetailsubtipos.hashCode;
}
