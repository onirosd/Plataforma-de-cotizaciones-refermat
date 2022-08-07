import 'dart:convert';

class SubTipoMultimedia {
  int codSubtipomultimedia;
  int codTipomultimedia;
  String desSubtipomultimedia;

  SubTipoMultimedia({
    required this.codSubtipomultimedia,
    required this.codTipomultimedia,
    required this.desSubtipomultimedia,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'codSubtipomultimedia': codSubtipomultimedia});
    result.addAll({'codTipomultimedia': codTipomultimedia});
    result.addAll({'desSubtipomultimedia': desSubtipomultimedia});

    return result;
  }

  factory SubTipoMultimedia.fromMap(Map<String, dynamic> map) {
    return SubTipoMultimedia(
      codSubtipomultimedia: map['codSubtipomultimedia'].toInt() ?? 0,
      codTipomultimedia: map['codTipomultimedia'].toInt() ?? 0,
      desSubtipomultimedia: map['desSubtipomultimedia'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SubTipoMultimedia.fromJson(String source) =>
      SubTipoMultimedia.fromMap(json.decode(source));

  @override
  String toString() =>
      'SubTipoMultimedia(codSubtipomultimedia: $codSubtipomultimedia, codTipomultimedia: $codTipomultimedia, desSubtipomultimedia: $desSubtipomultimedia)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubTipoMultimedia &&
        other.codSubtipomultimedia == codSubtipomultimedia &&
        other.codTipomultimedia == codTipomultimedia &&
        other.desSubtipomultimedia == desSubtipomultimedia;
  }

  @override
  int get hashCode =>
      codSubtipomultimedia.hashCode ^
      codTipomultimedia.hashCode ^
      desSubtipomultimedia.hashCode;
}
