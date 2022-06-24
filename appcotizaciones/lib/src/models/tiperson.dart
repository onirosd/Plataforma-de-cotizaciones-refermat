import 'dart:convert';

class TiPerson {
  int? codPerson;
  String? strDesPerson;
  String? strPosition;
  String? strCelphone;

  TiPerson({
    this.codPerson,
    this.strDesPerson,
    this.strPosition,
    this.strCelphone,
  });

  Map<String, dynamic> toMap() {
    return {
      'codPerson': codPerson,
      'strDesPerson': strDesPerson,
      'strPosition': strPosition,
      'strCelphone': strCelphone,
    };
  }

  factory TiPerson.fromMap(Map<String, dynamic> map) {
    return TiPerson(
      codPerson: map['codPerson'],
      strDesPerson: map['strDesPerson'],
      strPosition: map['strPosition'],
      strCelphone: map['strCelphone'],
    );
  }

  factory TiPerson.fromMap2(Map<String, dynamic> map) {
    return TiPerson(
      codPerson: map.length > 0 ? map['codPerson'] : 0,
      strDesPerson: map.length > 0 ? map['strDesPerson'] : "",
      strPosition: map.length > 0 ? map['strPosition'] : "",
      strCelphone: map.length > 0 ? map['strCelphone'] : "",
    );
  }

  String toJson() => json.encode(toMap());

  factory TiPerson.fromJson(String source) =>
      TiPerson.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TiPerson(codPerson: $codPerson, strDesPerson: $strDesPerson, strPosition: $strPosition, strCelphone: $strCelphone)';
  }
}
