import 'dart:convert';

class Gallery {
  String codGallery;
  String codCustomer;
  int codUser;
  int tipoMultimedia;
  int subTipoMultimedia;
  String? comentario;
  String? latitud;
  String? longitud;
  String fechaCreacion;
  int flatEstado;

  Gallery({
    required this.codGallery,
    required this.codCustomer,
    required this.codUser,
    required this.tipoMultimedia,
    required this.subTipoMultimedia,
    this.comentario,
    this.latitud,
    this.longitud,
    required this.fechaCreacion,
    required this.flatEstado,
  });

  Gallery copyWith({
    String? codGallery,
    String? codCustomer,
    int? codUser,
    int? tipoMultimedia,
    int? subTipoMultimedia,
    String? comentario,
    String? latitud,
    String? longitud,
    String? fechaCreacion,
    int? flatEstado,
  }) {
    return Gallery(
      codGallery: codGallery ?? this.codGallery,
      codCustomer: codCustomer ?? this.codCustomer,
      codUser: codUser ?? this.codUser,
      tipoMultimedia: tipoMultimedia ?? this.tipoMultimedia,
      subTipoMultimedia: subTipoMultimedia ?? this.subTipoMultimedia,
      comentario: comentario ?? this.comentario,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      flatEstado: flatEstado ?? this.flatEstado,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'codGallery': codGallery});
    result.addAll({'codCustomer': codCustomer});
    result.addAll({'codUser': codUser});
    result.addAll({'tipoMultimedia': tipoMultimedia});
    result.addAll({'subTipoMultimedia': subTipoMultimedia});
    if (comentario != null) {
      result.addAll({'comentario': comentario});
    }
    if (latitud != null) {
      result.addAll({'latitud': latitud});
    }
    if (longitud != null) {
      result.addAll({'longitud': longitud});
    }
    result.addAll({'fechaCreacion': fechaCreacion});
    result.addAll({'flatEstado': flatEstado});

    return result;
  }

  factory Gallery.fromMap(Map<String, dynamic> map) {
    return Gallery(
      codGallery: map['codGallery'] ?? '',
      codCustomer: map['codCustomer'] ?? '',
      codUser: map['codUser'].toInt() ?? 0,
      tipoMultimedia: map['tipoMultimedia']?.toInt() ?? 0,
      subTipoMultimedia: map['subTipoMultimedia'].toInt() ?? 0,
      comentario: map['comentario'],
      latitud: map['latitud'],
      longitud: map['longitud'],
      fechaCreacion: map['fechaCreacion'] ?? '',
      flatEstado: map['flatEstado']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Gallery.fromJson(String source) =>
      Gallery.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Gallery(codGallery: $codGallery, codCustomer: $codCustomer, codUser: $codUser, tipoMultimedia: $tipoMultimedia, subTipoMultimedia: $subTipoMultimedia, comentario: $comentario, latitud: $latitud, longitud: $longitud, fechaCreacion: $fechaCreacion, flatEstado: $flatEstado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Gallery &&
        other.codGallery == codGallery &&
        other.codCustomer == codCustomer &&
        other.codUser == codUser &&
        other.tipoMultimedia == tipoMultimedia &&
        other.subTipoMultimedia == subTipoMultimedia &&
        other.comentario == comentario &&
        other.latitud == latitud &&
        other.longitud == longitud &&
        other.fechaCreacion == fechaCreacion &&
        other.flatEstado == flatEstado;
  }

  @override
  int get hashCode {
    return codGallery.hashCode ^
        codCustomer.hashCode ^
        codUser.hashCode ^
        tipoMultimedia.hashCode ^
        subTipoMultimedia.hashCode ^
        comentario.hashCode ^
        latitud.hashCode ^
        longitud.hashCode ^
        fechaCreacion.hashCode ^
        flatEstado.hashCode;
  }
}
