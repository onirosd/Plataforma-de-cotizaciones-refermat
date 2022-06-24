import 'dart:convert';

class LastCompany {
  int company;
  String lastDate;

  LastCompany({
    required this.company,
    required this.lastDate,
  });

  LastCompany copyWith({
    int? company,
    String? lastDate,
  }) {
    return LastCompany(
      company: company ?? this.company,
      lastDate: lastDate ?? this.lastDate,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'company': company});
    result.addAll({'lastDate': lastDate});

    return result;
  }

  factory LastCompany.fromMap(Map<String, dynamic> map) {
    return LastCompany(
      company: map['company']?.toInt() ?? 0,
      lastDate: map['lastDate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LastCompany.fromJson(String source) =>
      LastCompany.fromMap(json.decode(source));

  @override
  String toString() => 'LastCompany(company: $company, lastDate: $lastDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LastCompany &&
        other.company == company &&
        other.lastDate == lastDate;
  }

  @override
  int get hashCode => company.hashCode ^ lastDate.hashCode;
}
