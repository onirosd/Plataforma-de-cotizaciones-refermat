import 'dart:convert';

class ConfGeneral {
  int codconfigGeneral;
  String strCodOperation;
  String strDescription;
  int flgEnabled;
  String pivot1;
  String pivot2;
  String pivot3;
  int codUser;
  int flgSync;

  ConfGeneral({
    required this.codconfigGeneral,
    required this.strCodOperation,
    required this.strDescription,
    required this.flgEnabled,
    required this.pivot1,
    required this.pivot2,
    required this.pivot3,
    required this.codUser,
    required this.flgSync,
  });

  Map<String, dynamic> toMap() {
    return {
      'codconfigGeneral': codconfigGeneral,
      'strCodOperation': strCodOperation,
      'strDescription': strDescription,
      'flgEnabled': flgEnabled,
      'pivot1': pivot1,
      'pivot2': pivot2,
      'pivot3': pivot3,
      'codUser': codUser,
      'flgSync': flgSync,
    };
  }

  factory ConfGeneral.fromMap(Map<String, dynamic> map) {
    return ConfGeneral(
      codconfigGeneral: map['codconfigGeneral'],
      strCodOperation: map['strCodOperation'],
      strDescription: map['strDescription'],
      flgEnabled: map['flgEnabled'],
      pivot1: map['pivot1'],
      pivot2: map['pivot2'],
      pivot3: map['pivot3'],
      codUser: map['codUser'],
      flgSync: map['flgSync'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfGeneral.fromJson(String source) =>
      ConfGeneral.fromMap(json.decode(source));
}
