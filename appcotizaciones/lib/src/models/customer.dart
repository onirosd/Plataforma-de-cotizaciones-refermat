import 'dart:convert';

class Customer {
  String? codCustomer;
  String? numRucCustomer;
  String? numRut;
  String? strName;
  String? strCelphone;
  String? strMail;
  String? strAddress;
  int? codTiCustomer;
  int? codCompany;
  int? asyncFlag;
  String? latitude;
  String? longitude;

  int? flagForceMultimedia;
  int? flagTipoMultimedia;

  String? selectid;

  Customer({
    this.codCustomer,
    this.numRucCustomer,
    this.numRut,
    this.strName,
    this.strCelphone,
    this.strMail,
    this.strAddress,
    this.codTiCustomer,
    this.codCompany,
    this.asyncFlag,
    this.latitude,
    this.longitude,
    this.flagForceMultimedia,
    this.flagTipoMultimedia,
  });

  Customer copyWith({
    String? codCustomer,
    String? numRucCustomer,
    String? numRut,
    String? strName,
    String? strCelphone,
    String? strMail,
    String? strAddress,
    int? codTiCustomer,
    int? codCompany,
    int? asyncFlag,
    String? latitude,
    String? longitude,
    int? flagForceMultimedia,
    int? flagTipoMultimedia,
  }) {
    return Customer(
      codCustomer: codCustomer ?? this.codCustomer,
      numRucCustomer: numRucCustomer ?? this.numRucCustomer,
      numRut: numRut ?? this.numRut,
      strName: strName ?? this.strName,
      strCelphone: strCelphone ?? this.strCelphone,
      strMail: strMail ?? this.strMail,
      strAddress: strAddress ?? this.strAddress,
      codTiCustomer: codTiCustomer ?? this.codTiCustomer,
      codCompany: codCompany ?? this.codCompany,
      asyncFlag: asyncFlag ?? this.asyncFlag,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      flagForceMultimedia: flagForceMultimedia ?? this.flagForceMultimedia,
      flagTipoMultimedia: flagTipoMultimedia ?? this.flagTipoMultimedia,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (codCustomer != null) {
      result.addAll({'codCustomer': codCustomer});
    }
    if (numRucCustomer != null) {
      result.addAll({'numRucCustomer': numRucCustomer});
    }
    if (numRut != null) {
      result.addAll({'numRut': numRut});
    }
    if (strName != null) {
      result.addAll({'strName': strName});
    }
    if (strCelphone != null) {
      result.addAll({'strCelphone': strCelphone});
    }
    if (strMail != null) {
      result.addAll({'strMail': strMail});
    }
    if (strAddress != null) {
      result.addAll({'strAddress': strAddress});
    }
    if (codTiCustomer != null) {
      result.addAll({'codTiCustomer': codTiCustomer});
    }
    if (codCompany != null) {
      result.addAll({'codCompany': codCompany});
    }
    if (asyncFlag != null) {
      result.addAll({'asyncFlag': asyncFlag});
    }
    if (latitude != null) {
      result.addAll({'latitude': latitude});
    }
    if (longitude != null) {
      result.addAll({'longitude': longitude});
    }
    if (flagForceMultimedia != null) {
      result.addAll({'flagForceMultimedia': flagForceMultimedia});
    }
    if (flagTipoMultimedia != null) {
      result.addAll({'flagTipoMultimedia': flagTipoMultimedia});
    }

    return result;
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      codCustomer: map['codCustomer'],
      numRucCustomer: map['numRucCustomer'],
      numRut: map['numRut'],
      strName: map['strName'],
      strCelphone: map['strCelphone'],
      strMail: map['strMail'],
      strAddress: map['strAddress'],
      codTiCustomer: map['codTiCustomer']?.toInt(),
      codCompany: map['codCompany']?.toInt(),
      asyncFlag: map['asyncFlag']?.toInt(),
      latitude: map['latitude'],
      longitude: map['longitude'],
      flagForceMultimedia: map['flagForceMultimedia']?.toInt(),
      flagTipoMultimedia: map['flagTipoMultimedia']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Customer(codCustomer: $codCustomer, numRucCustomer: $numRucCustomer, numRut: $numRut, strName: $strName, strCelphone: $strCelphone, strMail: $strMail, strAddress: $strAddress, codTiCustomer: $codTiCustomer, codCompany: $codCompany, asyncFlag: $asyncFlag, latitude: $latitude, longitude: $longitude, flagForceMultimedia: $flagForceMultimedia, flagTipoMultimedia: $flagTipoMultimedia)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Customer &&
        other.codCustomer == codCustomer &&
        other.numRucCustomer == numRucCustomer &&
        other.numRut == numRut &&
        other.strName == strName &&
        other.strCelphone == strCelphone &&
        other.strMail == strMail &&
        other.strAddress == strAddress &&
        other.codTiCustomer == codTiCustomer &&
        other.codCompany == codCompany &&
        other.asyncFlag == asyncFlag &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.flagForceMultimedia == flagForceMultimedia &&
        other.flagTipoMultimedia == flagTipoMultimedia;
  }

  @override
  int get hashCode {
    return codCustomer.hashCode ^
        numRucCustomer.hashCode ^
        numRut.hashCode ^
        strName.hashCode ^
        strCelphone.hashCode ^
        strMail.hashCode ^
        strAddress.hashCode ^
        codTiCustomer.hashCode ^
        codCompany.hashCode ^
        asyncFlag.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        flagForceMultimedia.hashCode ^
        flagTipoMultimedia.hashCode;
  }
}
