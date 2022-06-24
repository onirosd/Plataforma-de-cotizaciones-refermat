import 'dart:convert';

class Ti_IndicatorsUser {
  String strDescription;
  String strValue;
  int codUser;

  Ti_IndicatorsUser({
    required this.strDescription,
    required this.strValue,
    required this.codUser,
  });

  Ti_IndicatorsUser copyWith({
    String? strDescription,
    String? strValue,
    int? codUser,
  }) {
    return Ti_IndicatorsUser(
      strDescription: strDescription ?? this.strDescription,
      strValue: strValue ?? this.strValue,
      codUser: codUser ?? this.codUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'strDescription': strDescription,
      'strValue': strValue,
      'codUser': codUser,
    };
  }

  factory Ti_IndicatorsUser.fromMap(Map<String, dynamic> map) {
    return Ti_IndicatorsUser(
      strDescription: map['strDescription'],
      strValue: map['strValue'],
      codUser: map['codUser'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Ti_IndicatorsUser.fromJson(String source) =>
      Ti_IndicatorsUser.fromMap(json.decode(source));

  @override
  String toString() =>
      'Ti_IndicatorsUser(strDescription: $strDescription, strValue: $strValue, codUser: $codUser)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ti_IndicatorsUser &&
        other.strDescription == strDescription &&
        other.strValue == strValue &&
        other.codUser == codUser;
  }

  @override
  int get hashCode =>
      strDescription.hashCode ^ strValue.hashCode ^ codUser.hashCode;
}
