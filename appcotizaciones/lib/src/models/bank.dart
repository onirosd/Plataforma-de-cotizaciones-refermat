import 'dart:convert';

class Bank {
  int? codBank;
  String? strDescription;
  Bank({
    this.codBank,
    this.strDescription,
  });

  Bank copyWith({
    int? codBank,
    String? strDescription,
  }) {
    return Bank(
      codBank: codBank ?? this.codBank,
      strDescription: strDescription ?? this.strDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codBank': codBank,
      'strDescription': strDescription,
    };
  }

  factory Bank.fromMap(Map<String, dynamic> map) {
    return Bank(
      codBank: map['codBank'],
      strDescription: map['strDescription'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Bank.fromJson(String source) => Bank.fromMap(json.decode(source));

  @override
  String toString() =>
      'Bank(codBank: $codBank, strDescription: $strDescription)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Bank &&
        other.codBank == codBank &&
        other.strDescription == strDescription;
  }

  @override
  int get hashCode => codBank.hashCode ^ strDescription.hashCode;
}
