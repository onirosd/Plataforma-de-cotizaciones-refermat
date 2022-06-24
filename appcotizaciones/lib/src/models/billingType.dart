import 'dart:convert';

class BillingType {
  int? codBillingType;
  String? strDescription;

  BillingType({
    this.codBillingType,
    this.strDescription,
  });

  BillingType copyWith({
    int? codBillingType,
    String? strDescription,
  }) {
    return BillingType(
      codBillingType: codBillingType ?? this.codBillingType,
      strDescription: strDescription ?? this.strDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codBillingType': codBillingType,
      'strDescription': strDescription,
    };
  }

  factory BillingType.fromMap(Map<String, dynamic> map) {
    return BillingType(
      codBillingType: map['codBillingType'],
      strDescription: map['strDescription'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BillingType.fromJson(String source) =>
      BillingType.fromMap(json.decode(source));

  @override
  String toString() =>
      'BillingType(codBillingType: $codBillingType, strDescription: $strDescription)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BillingType &&
        other.codBillingType == codBillingType &&
        other.strDescription == strDescription;
  }

  @override
  int get hashCode => codBillingType.hashCode ^ strDescription.hashCode;
}
