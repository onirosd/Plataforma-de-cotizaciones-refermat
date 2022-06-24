import 'dart:convert';

class Currency {
  int? codCurrency;
  String? strDescription;
  String? strName;

  Currency({
    this.codCurrency,
    this.strDescription,
    this.strName,
  });

  Currency copyWith({
    int? codCurrency,
    String? strDescription,
    String? strName,
  }) {
    return Currency(
      codCurrency: codCurrency ?? this.codCurrency,
      strDescription: strDescription ?? this.strDescription,
      strName: strName ?? this.strName,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (codCurrency != null) {
      result.addAll({'codCurrency': codCurrency});
    }
    if (strDescription != null) {
      result.addAll({'strDescription': strDescription});
    }
    if (strName != null) {
      result.addAll({'strName': strName});
    }

    return result;
  }

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      codCurrency: map['codCurrency']?.toInt(),
      strDescription: map['strDescription'],
      strName: map['strName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Currency.fromJson(String source) =>
      Currency.fromMap(json.decode(source));

  @override
  String toString() =>
      'Currency(codCurrency: $codCurrency, strDescription: $strDescription, strName: $strName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Currency &&
        other.codCurrency == codCurrency &&
        other.strDescription == strDescription &&
        other.strName == strName;
  }

  @override
  int get hashCode =>
      codCurrency.hashCode ^ strDescription.hashCode ^ strName.hashCode;
}
