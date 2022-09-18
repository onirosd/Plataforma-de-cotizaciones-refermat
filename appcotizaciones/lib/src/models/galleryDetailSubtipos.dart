import 'dart:convert';

class GalleryDetailSubtipos {
  String codGallerySubtipo;
  int subTipoMultimedia;
  String comentario;
  String fechaCreacion;
  String codGallery;

  GalleryDetailSubtipos({
    required this.codGallerySubtipo,
    required this.subTipoMultimedia,
    required this.comentario,
    required this.fechaCreacion,
    required this.codGallery,
  });

  GalleryDetailSubtipos copyWith({
    String? codGallerySubtipo,
    int? subTipoMultimedia,
    String? comentario,
    String? fechaCreacion,
    String? codGallery,
  }) {
    return GalleryDetailSubtipos(
      codGallerySubtipo: codGallerySubtipo ?? this.codGallerySubtipo,
      subTipoMultimedia: subTipoMultimedia ?? this.subTipoMultimedia,
      comentario: comentario ?? this.comentario,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      codGallery: codGallery ?? this.codGallery,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'codGallerySubtipo': codGallerySubtipo});
    result.addAll({'subTipoMultimedia': subTipoMultimedia});
    result.addAll({'comentario': comentario});
    result.addAll({'fechaCreacion': fechaCreacion});
    result.addAll({'codGallery': codGallery});

    return result;
  }

  factory GalleryDetailSubtipos.fromMap(Map<String, dynamic> map) {
    return GalleryDetailSubtipos(
      codGallerySubtipo: map['codGallerySubtipo'] ?? '',
      subTipoMultimedia: map['subTipoMultimedia']?.toInt() ?? 0,
      comentario: map['comentario'] ?? '',
      fechaCreacion: map['fechaCreacion'] ?? '',
      codGallery: map['codGallery'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GalleryDetailSubtipos.fromJson(String source) =>
      GalleryDetailSubtipos.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GalleryDetailSubtipos(codGallerySubtipo: $codGallerySubtipo, subTipoMultimedia: $subTipoMultimedia, comentario: $comentario, fechaCreacion: $fechaCreacion, codGallery: $codGallery)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GalleryDetailSubtipos &&
        other.codGallerySubtipo == codGallerySubtipo &&
        other.subTipoMultimedia == subTipoMultimedia &&
        other.comentario == comentario &&
        other.fechaCreacion == fechaCreacion &&
        other.codGallery == codGallery;
  }

  @override
  int get hashCode {
    return codGallerySubtipo.hashCode ^
        subTipoMultimedia.hashCode ^
        comentario.hashCode ^
        fechaCreacion.hashCode ^
        codGallery.hashCode;
  }
}
