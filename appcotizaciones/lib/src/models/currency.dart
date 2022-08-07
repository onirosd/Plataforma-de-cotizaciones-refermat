import 'dart:convert';

class Currency {
  int? codCurrency;
  String? strDescription;
  String? strName;
  String? symbol;

  Currency({
    this.codCurrency,
    this.strDescription,
    this.strName,
    this.symbol,
  });

  Currency copyWith({
    int? codCurrency,
    String? strDescription,
    String? strName,
    String? symbol,
  }) {
    return Currency(
      codCurrency: codCurrency ?? this.codCurrency,
      strDescription: strDescription ?? this.strDescription,
      strName: strName ?? this.strName,
      symbol: symbol ?? this.symbol,
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
    if (symbol != null) {
      result.addAll({'symbol': symbol});
    }

    return result;
  }

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      codCurrency: map['codCurrency']?.toInt(),
      strDescription: map['strDescription'],
      strName: map['strName'],
      symbol: map['symbol'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Currency.fromJson(String source) =>
      Currency.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Currency(codCurrency: $codCurrency, strDescription: $strDescription, strName: $strName, symbol: $symbol)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Currency &&
        other.codCurrency == codCurrency &&
        other.strDescription == strDescription &&
        other.strName == strName &&
        other.symbol == symbol;
  }

  @override
  int get hashCode {
    return codCurrency.hashCode ^
        strDescription.hashCode ^
        strName.hashCode ^
        symbol.hashCode;
  }
}
