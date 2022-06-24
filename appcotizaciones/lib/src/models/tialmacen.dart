import 'dart:convert';

class TiAlmacen {
  int codTiAlmacen;
  String strDescription;

  TiAlmacen({
    required this.codTiAlmacen,
    required this.strDescription,
  });

  TiAlmacen copyWith({
    int? codTiAlmacen,
    String? strDescription,
  }) {
    return TiAlmacen(
      codTiAlmacen: codTiAlmacen ?? this.codTiAlmacen,
      strDescription: strDescription ?? this.strDescription,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'codTiAlmacen': codTiAlmacen});
    result.addAll({'strDescription': strDescription});

    return result;
  }

  factory TiAlmacen.fromMap(Map<String, dynamic> map) {
    return TiAlmacen(
      codTiAlmacen: map['codTiAlmacen']?.toInt() ?? 0,
      strDescription: map['strDescription'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TiAlmacen.fromJson(String source) =>
      TiAlmacen.fromMap(json.decode(source));

  @override
  String toString() =>
      'TiAlmacen(codTiAlmacen: $codTiAlmacen, strDescription: $strDescription)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TiAlmacen &&
        other.codTiAlmacen == codTiAlmacen &&
        other.strDescription == strDescription;
  }

  @override
  int get hashCode => codTiAlmacen.hashCode ^ strDescription.hashCode;
}
