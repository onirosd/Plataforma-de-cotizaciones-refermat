import 'dart:convert';

class PayCondition {
  int? codPayCondition;
  String? strDescription;

  PayCondition({
    this.codPayCondition,
    this.strDescription,
  });

  PayCondition copyWith({
    int? codPayCondition,
    String? strDescription,
  }) {
    return PayCondition(
      codPayCondition: codPayCondition ?? this.codPayCondition,
      strDescription: strDescription ?? this.strDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codPayCondition': codPayCondition,
      'strDescription': strDescription,
    };
  }

  factory PayCondition.fromMap(Map<String, dynamic> map) {
    return PayCondition(
      codPayCondition: map['codPayCondition'],
      strDescription: map['strDescription'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PayCondition.fromJson(String source) =>
      PayCondition.fromMap(json.decode(source));

  @override
  String toString() =>
      'PayCondition(codPayCondition: $codPayCondition, strDescription: $strDescription)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PayCondition &&
        other.codPayCondition == codPayCondition &&
        other.strDescription == strDescription;
  }

  @override
  int get hashCode => codPayCondition.hashCode ^ strDescription.hashCode;
}
