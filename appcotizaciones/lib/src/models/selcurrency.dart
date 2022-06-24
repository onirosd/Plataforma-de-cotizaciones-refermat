import 'dart:convert';

class Cmoneda {
  int codmoneda;
  Cmoneda({
    required this.codmoneda,
  });

  Cmoneda copyWith({
    int? codmoneda,
  }) {
    return Cmoneda(
      codmoneda: codmoneda ?? this.codmoneda,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codmoneda': codmoneda,
    };
  }

  factory Cmoneda.fromMap(Map<String, dynamic> map) {
    return Cmoneda(
      codmoneda: map['codmoneda'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Cmoneda.fromJson(String source) =>
      Cmoneda.fromMap(json.decode(source));

  @override
  String toString() => 'Cmoneda(codmoneda: $codmoneda)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cmoneda && other.codmoneda == codmoneda;
  }

  @override
  int get hashCode => codmoneda.hashCode;
}
