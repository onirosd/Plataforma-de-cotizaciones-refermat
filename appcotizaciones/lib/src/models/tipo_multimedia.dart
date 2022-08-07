import 'dart:convert';

class TipoMultimedia {
  int codTipomultimedia;
  String desTipomultimedia;
  int flagAdjuntar;

  TipoMultimedia({
    required this.codTipomultimedia,
    required this.desTipomultimedia,
    required this.flagAdjuntar,
  });

  TipoMultimedia copyWith({
    int? codTipomultimedia,
    String? desTipomultimedia,
    int? flagAdjuntar,
  }) {
    return TipoMultimedia(
      codTipomultimedia: codTipomultimedia ?? this.codTipomultimedia,
      desTipomultimedia: desTipomultimedia ?? this.desTipomultimedia,
      flagAdjuntar: flagAdjuntar ?? this.flagAdjuntar,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'codTipomultimedia': codTipomultimedia});
    result.addAll({'desTipomultimedia': desTipomultimedia});
    result.addAll({'flagAdjuntar': flagAdjuntar});

    return result;
  }

  factory TipoMultimedia.fromMap(Map<String, dynamic> map) {
    return TipoMultimedia(
      codTipomultimedia: map['codTipomultimedia']?.toInt() ?? 0,
      desTipomultimedia: map['desTipomultimedia'] ?? '',
      flagAdjuntar: map['flagAdjuntar']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TipoMultimedia.fromJson(String source) =>
      TipoMultimedia.fromMap(json.decode(source));

  @override
  String toString() =>
      'TipoMultimedia(codTipomultimedia: $codTipomultimedia, desTipomultimedia: $desTipomultimedia, flagAdjuntar: $flagAdjuntar)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TipoMultimedia &&
        other.codTipomultimedia == codTipomultimedia &&
        other.desTipomultimedia == desTipomultimedia &&
        other.flagAdjuntar == flagAdjuntar;
  }

  @override
  int get hashCode =>
      codTipomultimedia.hashCode ^
      desTipomultimedia.hashCode ^
      flagAdjuntar.hashCode;
}
