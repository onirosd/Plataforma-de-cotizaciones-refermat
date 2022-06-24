import 'dart:convert';

class LastAutentication {
  int codUser;
  String lastDate;

  LastAutentication({
    required this.codUser,
    required this.lastDate,
  });

  LastAutentication copyWith({
    int? codUser,
    String? lastDate,
  }) {
    return LastAutentication(
      codUser: codUser ?? this.codUser,
      lastDate: lastDate ?? this.lastDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codUser': codUser,
      'lastDate': lastDate,
    };
  }

  factory LastAutentication.fromMap(Map<String, dynamic> map) {
    return LastAutentication(
      codUser: map['codUser'],
      lastDate: map['lastDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LastAutentication.fromJson(String source) =>
      LastAutentication.fromMap(json.decode(source));

  @override
  String toString() =>
      'LastAutentication(codUser: $codUser, lastDate: $lastDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LastAutentication &&
        other.codUser == codUser &&
        other.lastDate == lastDate;
  }

  @override
  int get hashCode => codUser.hashCode ^ lastDate.hashCode;
}
