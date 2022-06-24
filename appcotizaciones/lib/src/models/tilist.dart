import 'dart:convert';

class TiList {
  int? codList;
  String? strDescription;

  TiList({
    this.codList,
    this.strDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'codList': codList,
      'strDescription': strDescription,
    };
  }

  factory TiList.fromMap(Map<String, dynamic> map) {
    return TiList(
      codList: map['codList'],
      strDescription: map['strDescription'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TiList.fromJson(String source) => TiList.fromMap(json.decode(source));
}
