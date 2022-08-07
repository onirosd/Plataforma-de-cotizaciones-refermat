import 'dart:convert';

class GalleryDetail {
  String codGallery;
  String codImage;
  String nameImage;
  String pathImage;
  String? latitud;
  String? longitud;
  String fechaCreacion;

  GalleryDetail({
    required this.codGallery,
    required this.codImage,
    required this.nameImage,
    required this.pathImage,
    this.latitud,
    this.longitud,
    required this.fechaCreacion,
  });

  GalleryDetail copyWith({
    String? codGallery,
    String? codImage,
    String? nameImage,
    String? pathImage,
    String? latitud,
    String? longitud,
    String? fechaCreacion,
  }) {
    return GalleryDetail(
      codGallery: codGallery ?? this.codGallery,
      codImage: codImage ?? this.codImage,
      nameImage: nameImage ?? this.nameImage,
      pathImage: pathImage ?? this.pathImage,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'codGallery': codGallery});
    result.addAll({'codImage': codImage});
    result.addAll({'nameImage': nameImage});
    result.addAll({'pathImage': pathImage});
    if (latitud != null) {
      result.addAll({'latitud': latitud});
    }
    if (longitud != null) {
      result.addAll({'longitud': longitud});
    }
    result.addAll({'fechaCreacion': fechaCreacion});

    return result;
  }

  factory GalleryDetail.fromMap(Map<String, dynamic> map) {
    return GalleryDetail(
      codGallery: map['codGallery'] ?? '',
      codImage: map['codImage'] ?? '',
      nameImage: map['nameImage'] ?? '',
      pathImage: map['pathImage'] ?? '',
      latitud: map['latitud'],
      longitud: map['longitud'],
      fechaCreacion: map['fechaCreacion'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GalleryDetail.fromJson(String source) =>
      GalleryDetail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GalleryDetail(codGallery: $codGallery, codImage: $codImage, nameImage: $nameImage, pathImage: $pathImage, latitud: $latitud, longitud: $longitud, fechaCreacion: $fechaCreacion)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GalleryDetail &&
        other.codGallery == codGallery &&
        other.codImage == codImage &&
        other.nameImage == nameImage &&
        other.pathImage == pathImage &&
        other.latitud == latitud &&
        other.longitud == longitud &&
        other.fechaCreacion == fechaCreacion;
  }

  @override
  int get hashCode {
    return codGallery.hashCode ^
        codImage.hashCode ^
        nameImage.hashCode ^
        pathImage.hashCode ^
        latitud.hashCode ^
        longitud.hashCode ^
        fechaCreacion.hashCode;
  }
}
