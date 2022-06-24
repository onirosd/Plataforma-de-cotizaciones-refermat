import 'dart:convert';

class Authentication {
  int codUser;
  String strNameUser;
  String strPassUser;
  int codCompany;
  int? codPerson;
  int? codList;
  int? flgState;
  String? strPosition;
  int? codTiAlmacen;

  Authentication({
    required this.codUser,
    required this.strNameUser,
    required this.strPassUser,
    required this.codCompany,
    this.codPerson,
    this.codList,
    this.flgState,
    this.strPosition,
    this.codTiAlmacen,
  });

  Authentication copyWith({
    int? codUser,
    String? strNameUser,
    String? strPassUser,
    int? codCompany,
    int? codPerson,
    int? codList,
    int? flgState,
    String? strPosition,
    int? codTiAlmacen,
  }) {
    return Authentication(
      codUser: codUser ?? this.codUser,
      strNameUser: strNameUser ?? this.strNameUser,
      strPassUser: strPassUser ?? this.strPassUser,
      codCompany: codCompany ?? this.codCompany,
      codPerson: codPerson ?? this.codPerson,
      codList: codList ?? this.codList,
      flgState: flgState ?? this.flgState,
      strPosition: strPosition ?? this.strPosition,
      codTiAlmacen: codTiAlmacen ?? this.codTiAlmacen,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'codUser': codUser});
    result.addAll({'strNameUser': strNameUser});
    result.addAll({'strPassUser': strPassUser});
    result.addAll({'codCompany': codCompany});
    if (codPerson != null) {
      result.addAll({'codPerson': codPerson});
    }
    if (codList != null) {
      result.addAll({'codList': codList});
    }
    if (flgState != null) {
      result.addAll({'flgState': flgState});
    }
    if (strPosition != null) {
      result.addAll({'strPosition': strPosition});
    }
    if (codTiAlmacen != null) {
      result.addAll({'codTiAlmacen': codTiAlmacen});
    }

    return result;
  }

  factory Authentication.fromMap(Map<String, dynamic> map) {
    return Authentication(
      codUser: map['codUser']?.toInt() ?? 0,
      strNameUser: map['strNameUser'] ?? '',
      strPassUser: map['strPassUser'] ?? '',
      codCompany: map['codCompany']?.toInt() ?? 0,
      codPerson: map['codPerson']?.toInt(),
      codList: map['codList']?.toInt(),
      flgState: map['flgState']?.toInt(),
      strPosition: map['strPosition'],
      codTiAlmacen: map['codTiAlmacen']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Authentication.fromJson(String source) =>
      Authentication.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Authentication(codUser: $codUser, strNameUser: $strNameUser, strPassUser: $strPassUser, codCompany: $codCompany, codPerson: $codPerson, codList: $codList, flgState: $flgState, strPosition: $strPosition, codTiAlmacen: $codTiAlmacen)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Authentication &&
        other.codUser == codUser &&
        other.strNameUser == strNameUser &&
        other.strPassUser == strPassUser &&
        other.codCompany == codCompany &&
        other.codPerson == codPerson &&
        other.codList == codList &&
        other.flgState == flgState &&
        other.strPosition == strPosition &&
        other.codTiAlmacen == codTiAlmacen;
  }

  @override
  int get hashCode {
    return codUser.hashCode ^
        strNameUser.hashCode ^
        strPassUser.hashCode ^
        codCompany.hashCode ^
        codPerson.hashCode ^
        codList.hashCode ^
        flgState.hashCode ^
        strPosition.hashCode ^
        codTiAlmacen.hashCode;
  }
}
