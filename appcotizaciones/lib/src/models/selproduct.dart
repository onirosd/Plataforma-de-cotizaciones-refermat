import 'dart:convert';

class Selproduct {
  int codProducts;
  Selproduct({
    required this.codProducts,
  });

  Selproduct copyWith({
    int? codProducts,
  }) {
    return Selproduct(
      codProducts: codProducts ?? this.codProducts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codProducts': codProducts,
    };
  }

  factory Selproduct.fromMap(Map<String, dynamic> map) {
    return Selproduct(
      codProducts: map['codProducts']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Selproduct.fromJson(String source) =>
      Selproduct.fromMap(json.decode(source));

  @override
  String toString() => 'Selproduct(codProducts: $codProducts)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Selproduct && other.codProducts == codProducts;
  }

  @override
  int get hashCode => codProducts.hashCode;
}
