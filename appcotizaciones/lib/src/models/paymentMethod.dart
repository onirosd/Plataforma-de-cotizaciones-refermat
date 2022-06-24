import 'dart:convert';

class PaymentMethod {
  int? codPaymentMethod;
  String? strDescription;
  PaymentMethod({
    this.codPaymentMethod,
    this.strDescription,
  });

  PaymentMethod copyWith({
    int? codPaymentMethod,
    String? strDescription,
  }) {
    return PaymentMethod(
      codPaymentMethod: codPaymentMethod ?? this.codPaymentMethod,
      strDescription: strDescription ?? this.strDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codPaymentMethod': codPaymentMethod,
      'strDescription': strDescription,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      codPaymentMethod: map['codPaymentMethod'],
      strDescription: map['strDescription'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMethod.fromJson(String source) =>
      PaymentMethod.fromMap(json.decode(source));

  @override
  String toString() =>
      'PaymentMethod(codPaymentMethod: $codPaymentMethod, strDescription: $strDescription)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentMethod &&
        other.codPaymentMethod == codPaymentMethod &&
        other.strDescription == strDescription;
  }

  @override
  int get hashCode => codPaymentMethod.hashCode ^ strDescription.hashCode;
}
