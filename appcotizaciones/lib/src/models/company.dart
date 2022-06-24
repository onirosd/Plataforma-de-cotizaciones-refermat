import 'dart:convert';

class Company {
  int? codCompany;
  String? strDesCompany;
  String? strRucCompany;
  String? strAddress;
  String? strPhone;
  String? strLogo;
  String? strPrintFormat;
  String? codCurrency;
  String? numImpuesto;
  String? campo1;
  String? campo2;
  String? campo3;
  String? campo4;
  String? campo5;
  String? campo6;
  String? campo7;
  String? campo8;
  String? campo9;
  String? campo10;
  String? str_image;

  Company({
    this.codCompany,
    this.strDesCompany,
    this.strRucCompany,
    this.strAddress,
    this.strPhone,
    this.strLogo,
    this.strPrintFormat,
    this.codCurrency,
    this.numImpuesto,
    this.campo1,
    this.campo2,
    this.campo3,
    this.campo4,
    this.campo5,
    this.campo6,
    this.campo7,
    this.campo8,
    this.campo9,
    this.campo10,
    this.str_image,
  });

  Company copyWith({
    int? codCompany,
    String? strDesCompany,
    String? strRucCompany,
    String? strAddress,
    String? strPhone,
    String? strLogo,
    String? strPrintFormat,
    String? codCurrency,
    String? numImpuesto,
    String? campo1,
    String? campo2,
    String? campo3,
    String? campo4,
    String? campo5,
    String? campo6,
    String? campo7,
    String? campo8,
    String? campo9,
    String? campo10,
    String? str_image,
  }) {
    return Company(
      codCompany: codCompany ?? this.codCompany,
      strDesCompany: strDesCompany ?? this.strDesCompany,
      strRucCompany: strRucCompany ?? this.strRucCompany,
      strAddress: strAddress ?? this.strAddress,
      strPhone: strPhone ?? this.strPhone,
      strLogo: strLogo ?? this.strLogo,
      strPrintFormat: strPrintFormat ?? this.strPrintFormat,
      codCurrency: codCurrency ?? this.codCurrency,
      numImpuesto: numImpuesto ?? this.numImpuesto,
      campo1: campo1 ?? this.campo1,
      campo2: campo2 ?? this.campo2,
      campo3: campo3 ?? this.campo3,
      campo4: campo4 ?? this.campo4,
      campo5: campo5 ?? this.campo5,
      campo6: campo6 ?? this.campo6,
      campo7: campo7 ?? this.campo7,
      campo8: campo8 ?? this.campo8,
      campo9: campo9 ?? this.campo9,
      campo10: campo10 ?? this.campo10,
      str_image: str_image ?? this.str_image,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (codCompany != null) {
      result.addAll({'codCompany': codCompany});
    }
    if (strDesCompany != null) {
      result.addAll({'strDesCompany': strDesCompany});
    }
    if (strRucCompany != null) {
      result.addAll({'strRucCompany': strRucCompany});
    }
    if (strAddress != null) {
      result.addAll({'strAddress': strAddress});
    }
    if (strPhone != null) {
      result.addAll({'strPhone': strPhone});
    }
    if (strLogo != null) {
      result.addAll({'strLogo': strLogo});
    }
    if (strPrintFormat != null) {
      result.addAll({'strPrintFormat': strPrintFormat});
    }
    if (codCurrency != null) {
      result.addAll({'codCurrency': codCurrency});
    }
    if (numImpuesto != null) {
      result.addAll({'numImpuesto': numImpuesto});
    }
    if (campo1 != null) {
      result.addAll({'campo1': campo1});
    }
    if (campo2 != null) {
      result.addAll({'campo2': campo2});
    }
    if (campo3 != null) {
      result.addAll({'campo3': campo3});
    }
    if (campo4 != null) {
      result.addAll({'campo4': campo4});
    }
    if (campo5 != null) {
      result.addAll({'campo5': campo5});
    }
    if (campo6 != null) {
      result.addAll({'campo6': campo6});
    }
    if (campo7 != null) {
      result.addAll({'campo7': campo7});
    }
    if (campo8 != null) {
      result.addAll({'campo8': campo8});
    }
    if (campo9 != null) {
      result.addAll({'campo9': campo9});
    }
    if (campo10 != null) {
      result.addAll({'campo10': campo10});
    }
    if (str_image != null) {
      result.addAll({'str_image': str_image});
    }

    return result;
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      codCompany: map['codCompany']?.toInt(),
      strDesCompany: map['strDesCompany'],
      strRucCompany: map['strRucCompany'],
      strAddress: map['strAddress'],
      strPhone: map['strPhone'],
      strLogo: map['strLogo'],
      strPrintFormat: map['strPrintFormat'],
      codCurrency: map['codCurrency'],
      numImpuesto: map['numImpuesto'],
      campo1: map['campo1'],
      campo2: map['campo2'],
      campo3: map['campo3'],
      campo4: map['campo4'],
      campo5: map['campo5'],
      campo6: map['campo6'],
      campo7: map['campo7'],
      campo8: map['campo8'],
      campo9: map['campo9'],
      campo10: map['campo10'],
      str_image: map['str_image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) =>
      Company.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Company(codCompany: $codCompany, strDesCompany: $strDesCompany, strRucCompany: $strRucCompany, strAddress: $strAddress, strPhone: $strPhone, strLogo: $strLogo, strPrintFormat: $strPrintFormat, codCurrency: $codCurrency, numImpuesto: $numImpuesto, campo1: $campo1, campo2: $campo2, campo3: $campo3, campo4: $campo4, campo5: $campo5, campo6: $campo6, campo7: $campo7, campo8: $campo8, campo9: $campo9, campo10: $campo10, str_image: $str_image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Company &&
        other.codCompany == codCompany &&
        other.strDesCompany == strDesCompany &&
        other.strRucCompany == strRucCompany &&
        other.strAddress == strAddress &&
        other.strPhone == strPhone &&
        other.strLogo == strLogo &&
        other.strPrintFormat == strPrintFormat &&
        other.codCurrency == codCurrency &&
        other.numImpuesto == numImpuesto &&
        other.campo1 == campo1 &&
        other.campo2 == campo2 &&
        other.campo3 == campo3 &&
        other.campo4 == campo4 &&
        other.campo5 == campo5 &&
        other.campo6 == campo6 &&
        other.campo7 == campo7 &&
        other.campo8 == campo8 &&
        other.campo9 == campo9 &&
        other.campo10 == campo10 &&
        other.str_image == str_image;
  }

  @override
  int get hashCode {
    return codCompany.hashCode ^
        strDesCompany.hashCode ^
        strRucCompany.hashCode ^
        strAddress.hashCode ^
        strPhone.hashCode ^
        strLogo.hashCode ^
        strPrintFormat.hashCode ^
        codCurrency.hashCode ^
        numImpuesto.hashCode ^
        campo1.hashCode ^
        campo2.hashCode ^
        campo3.hashCode ^
        campo4.hashCode ^
        campo5.hashCode ^
        campo6.hashCode ^
        campo7.hashCode ^
        campo8.hashCode ^
        campo9.hashCode ^
        campo10.hashCode ^
        str_image.hashCode;
  }
}
