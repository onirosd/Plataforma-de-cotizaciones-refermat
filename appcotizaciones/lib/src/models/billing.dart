import 'dart:convert';

class Billing {
  String codBillingUniq;
  int codUser;
  String codCustomer;
  int codBillingType;
  int codPaymentMethod;
  String strOperation;
  String dteBillingDate;
  int codBank;
  int codCurrency;
  double numAmountOperation;
  String? strComments;
  int flgState;
  String strCreateUser;
  String? dteCreateDate;
  int codCompany;
  int flgSync;
  int flgCodRealSystem;
  String latitude;
  String longitude;

  Billing({
    required this.codBillingUniq,
    required this.codUser,
    required this.codCustomer,
    required this.codBillingType,
    required this.codPaymentMethod,
    required this.strOperation,
    required this.dteBillingDate,
    required this.codBank,
    required this.codCurrency,
    required this.numAmountOperation,
    this.strComments,
    required this.flgState,
    required this.strCreateUser,
    this.dteCreateDate,
    required this.codCompany,
    required this.flgSync,
    required this.flgCodRealSystem,
    required this.latitude,
    required this.longitude,
  });

  Billing copyWith({
    String? codBillingUniq,
    int? codUser,
    String? codCustomer,
    int? codBillingType,
    int? codPaymentMethod,
    String? strOperation,
    String? dteBillingDate,
    int? codBank,
    int? codCurrency,
    double? numAmountOperation,
    String? strComments,
    int? flgState,
    String? strCreateUser,
    String? dteCreateDate,
    int? codCompany,
    int? flgSync,
    int? flgCodRealSystem,
    String? latitude,
    String? longitude,
  }) {
    return Billing(
      codBillingUniq: codBillingUniq ?? this.codBillingUniq,
      codUser: codUser ?? this.codUser,
      codCustomer: codCustomer ?? this.codCustomer,
      codBillingType: codBillingType ?? this.codBillingType,
      codPaymentMethod: codPaymentMethod ?? this.codPaymentMethod,
      strOperation: strOperation ?? this.strOperation,
      dteBillingDate: dteBillingDate ?? this.dteBillingDate,
      codBank: codBank ?? this.codBank,
      codCurrency: codCurrency ?? this.codCurrency,
      numAmountOperation: numAmountOperation ?? this.numAmountOperation,
      strComments: strComments ?? this.strComments,
      flgState: flgState ?? this.flgState,
      strCreateUser: strCreateUser ?? this.strCreateUser,
      dteCreateDate: dteCreateDate ?? this.dteCreateDate,
      codCompany: codCompany ?? this.codCompany,
      flgSync: flgSync ?? this.flgSync,
      flgCodRealSystem: flgCodRealSystem ?? this.flgCodRealSystem,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'codBillingUniq': codBillingUniq});
    result.addAll({'codUser': codUser});
    result.addAll({'codCustomer': codCustomer});
    result.addAll({'codBillingType': codBillingType});
    result.addAll({'codPaymentMethod': codPaymentMethod});
    result.addAll({'strOperation': strOperation});
    result.addAll({'dteBillingDate': dteBillingDate});
    result.addAll({'codBank': codBank});
    result.addAll({'codCurrency': codCurrency});
    result.addAll({'numAmountOperation': numAmountOperation});
    if (strComments != null) {
      result.addAll({'strComments': strComments});
    }
    result.addAll({'flgState': flgState});
    result.addAll({'strCreateUser': strCreateUser});
    if (dteCreateDate != null) {
      result.addAll({'dteCreateDate': dteCreateDate});
    }
    result.addAll({'codCompany': codCompany});
    result.addAll({'flgSync': flgSync});
    result.addAll({'flgCodRealSystem': flgCodRealSystem});
    result.addAll({'latitude': latitude});
    result.addAll({'longitude': longitude});

    return result;
  }

  factory Billing.fromMap(Map<String, dynamic> map) {
    return Billing(
      codBillingUniq: map['codBillingUniq'] ?? '',
      codUser: map['codUser']?.toInt() ?? 0,
      codCustomer: map['codCustomer'] ?? '',
      codBillingType: map['codBillingType']?.toInt() ?? 0,
      codPaymentMethod: map['codPaymentMethod']?.toInt() ?? 0,
      strOperation: map['strOperation'] ?? '',
      dteBillingDate: map['dteBillingDate'] ?? '',
      codBank: map['codBank']?.toInt() ?? 0,
      codCurrency: map['codCurrency']?.toInt() ?? 0,
      numAmountOperation: map['numAmountOperation']?.toDouble() ?? 0.0,
      strComments: map['strComments'],
      flgState: map['flgState']?.toInt() ?? 0,
      strCreateUser: map['strCreateUser'] ?? '',
      dteCreateDate: map['dteCreateDate'],
      codCompany: map['codCompany']?.toInt() ?? 0,
      flgSync: map['flgSync']?.toInt() ?? 0,
      flgCodRealSystem: map['flgCodRealSystem']?.toInt() ?? 0,
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Billing.fromJson(String source) =>
      Billing.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Billing(codBillingUniq: $codBillingUniq, codUser: $codUser, codCustomer: $codCustomer, codBillingType: $codBillingType, codPaymentMethod: $codPaymentMethod, strOperation: $strOperation, dteBillingDate: $dteBillingDate, codBank: $codBank, codCurrency: $codCurrency, numAmountOperation: $numAmountOperation, strComments: $strComments, flgState: $flgState, strCreateUser: $strCreateUser, dteCreateDate: $dteCreateDate, codCompany: $codCompany, flgSync: $flgSync, flgCodRealSystem: $flgCodRealSystem, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Billing &&
        other.codBillingUniq == codBillingUniq &&
        other.codUser == codUser &&
        other.codCustomer == codCustomer &&
        other.codBillingType == codBillingType &&
        other.codPaymentMethod == codPaymentMethod &&
        other.strOperation == strOperation &&
        other.dteBillingDate == dteBillingDate &&
        other.codBank == codBank &&
        other.codCurrency == codCurrency &&
        other.numAmountOperation == numAmountOperation &&
        other.strComments == strComments &&
        other.flgState == flgState &&
        other.strCreateUser == strCreateUser &&
        other.dteCreateDate == dteCreateDate &&
        other.codCompany == codCompany &&
        other.flgSync == flgSync &&
        other.flgCodRealSystem == flgCodRealSystem &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return codBillingUniq.hashCode ^
        codUser.hashCode ^
        codCustomer.hashCode ^
        codBillingType.hashCode ^
        codPaymentMethod.hashCode ^
        strOperation.hashCode ^
        dteBillingDate.hashCode ^
        codBank.hashCode ^
        codCurrency.hashCode ^
        numAmountOperation.hashCode ^
        strComments.hashCode ^
        flgState.hashCode ^
        strCreateUser.hashCode ^
        dteCreateDate.hashCode ^
        codCompany.hashCode ^
        flgSync.hashCode ^
        flgCodRealSystem.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }
}
