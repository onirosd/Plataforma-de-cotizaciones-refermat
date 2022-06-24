import 'dart:convert';

class ProductStock {
  int codProducts;
  String strNameProduct;
  String strNameProductReal;
  String numUnit;
  String numDiameter;
  String numTeoricalWeight;
  int codCategoryProduct;
  String strCategoryProduct;
  String numPriceMin;
  String numPriceMax;
  String numStock;
  int codList;
  int codTiAlmacen;
  int codCurrency;
  String? cod_TiProducts;
  String desTiAlmacen;
  int num_Empaque;

  ProductStock({
    required this.codProducts,
    required this.strNameProduct,
    required this.strNameProductReal,
    required this.numUnit,
    required this.numDiameter,
    required this.numTeoricalWeight,
    required this.codCategoryProduct,
    required this.strCategoryProduct,
    required this.numPriceMin,
    required this.numPriceMax,
    required this.numStock,
    required this.codList,
    required this.codTiAlmacen,
    required this.codCurrency,
    this.cod_TiProducts,
    required this.desTiAlmacen,
    required this.num_Empaque,
  });

  ProductStock copyWith({
    int? codProducts,
    String? strNameProduct,
    String? strNameProductReal,
    String? numUnit,
    String? numDiameter,
    String? numTeoricalWeight,
    int? codCategoryProduct,
    String? strCategoryProduct,
    String? numPriceMin,
    String? numPriceMax,
    String? numStock,
    int? codList,
    int? codTiAlmacen,
    int? codCurrency,
    String? cod_TiProducts,
    String? desTiAlmacen,
    int? num_Empaque,
  }) {
    return ProductStock(
      codProducts: codProducts ?? this.codProducts,
      strNameProduct: strNameProduct ?? this.strNameProduct,
      strNameProductReal: strNameProductReal ?? this.strNameProductReal,
      numUnit: numUnit ?? this.numUnit,
      numDiameter: numDiameter ?? this.numDiameter,
      numTeoricalWeight: numTeoricalWeight ?? this.numTeoricalWeight,
      codCategoryProduct: codCategoryProduct ?? this.codCategoryProduct,
      strCategoryProduct: strCategoryProduct ?? this.strCategoryProduct,
      numPriceMin: numPriceMin ?? this.numPriceMin,
      numPriceMax: numPriceMax ?? this.numPriceMax,
      numStock: numStock ?? this.numStock,
      codList: codList ?? this.codList,
      codTiAlmacen: codTiAlmacen ?? this.codTiAlmacen,
      codCurrency: codCurrency ?? this.codCurrency,
      cod_TiProducts: cod_TiProducts ?? this.cod_TiProducts,
      desTiAlmacen: desTiAlmacen ?? this.desTiAlmacen,
      num_Empaque: num_Empaque ?? this.num_Empaque,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'codProducts': codProducts});
    result.addAll({'strNameProduct': strNameProduct});
    result.addAll({'strNameProductReal': strNameProductReal});
    result.addAll({'numUnit': numUnit});
    result.addAll({'numDiameter': numDiameter});
    result.addAll({'numTeoricalWeight': numTeoricalWeight});
    result.addAll({'codCategoryProduct': codCategoryProduct});
    result.addAll({'strCategoryProduct': strCategoryProduct});
    result.addAll({'numPriceMin': numPriceMin});
    result.addAll({'numPriceMax': numPriceMax});
    result.addAll({'numStock': numStock});
    result.addAll({'codList': codList});
    result.addAll({'codTiAlmacen': codTiAlmacen});
    result.addAll({'codCurrency': codCurrency});
    if (cod_TiProducts != null) {
      result.addAll({'cod_TiProducts': cod_TiProducts});
    }
    result.addAll({'desTiAlmacen': desTiAlmacen});
    result.addAll({'num_Empaque': num_Empaque});

    return result;
  }

  factory ProductStock.fromMap(Map<String, dynamic> map) {
    return ProductStock(
      codProducts: map['codProducts']?.toInt() ?? 0,
      strNameProduct: map['strNameProduct'] ?? '',
      strNameProductReal: map['strNameProductReal'] ?? '',
      numUnit: map['numUnit'] ?? '',
      numDiameter: map['numDiameter'] ?? '',
      numTeoricalWeight: map['numTeoricalWeight'] ?? '',
      codCategoryProduct: map['codCategoryProduct']?.toInt() ?? 0,
      strCategoryProduct: map['strCategoryProduct'] ?? '',
      numPriceMin: map['numPriceMin'] ?? '',
      numPriceMax: map['numPriceMax'] ?? '',
      numStock: map['numStock'] ?? '',
      codList: map['codList']?.toInt() ?? 0,
      codTiAlmacen: map['codTiAlmacen']?.toInt() ?? 0,
      codCurrency: map['codCurrency']?.toInt() ?? 0,
      cod_TiProducts: map['cod_TiProducts'],
      desTiAlmacen: map['desTiAlmacen'] ?? '',
      num_Empaque: map['num_Empaque']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductStock.fromJson(String source) =>
      ProductStock.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductStock(codProducts: $codProducts, strNameProduct: $strNameProduct, strNameProductReal: $strNameProductReal, numUnit: $numUnit, numDiameter: $numDiameter, numTeoricalWeight: $numTeoricalWeight, codCategoryProduct: $codCategoryProduct, strCategoryProduct: $strCategoryProduct, numPriceMin: $numPriceMin, numPriceMax: $numPriceMax, numStock: $numStock, codList: $codList, codTiAlmacen: $codTiAlmacen, codCurrency: $codCurrency, cod_TiProducts: $cod_TiProducts, desTiAlmacen: $desTiAlmacen, num_Empaque: $num_Empaque)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductStock &&
        other.codProducts == codProducts &&
        other.strNameProduct == strNameProduct &&
        other.strNameProductReal == strNameProductReal &&
        other.numUnit == numUnit &&
        other.numDiameter == numDiameter &&
        other.numTeoricalWeight == numTeoricalWeight &&
        other.codCategoryProduct == codCategoryProduct &&
        other.strCategoryProduct == strCategoryProduct &&
        other.numPriceMin == numPriceMin &&
        other.numPriceMax == numPriceMax &&
        other.numStock == numStock &&
        other.codList == codList &&
        other.codTiAlmacen == codTiAlmacen &&
        other.codCurrency == codCurrency &&
        other.cod_TiProducts == cod_TiProducts &&
        other.desTiAlmacen == desTiAlmacen &&
        other.num_Empaque == num_Empaque;
  }

  @override
  int get hashCode {
    return codProducts.hashCode ^
        strNameProduct.hashCode ^
        strNameProductReal.hashCode ^
        numUnit.hashCode ^
        numDiameter.hashCode ^
        numTeoricalWeight.hashCode ^
        codCategoryProduct.hashCode ^
        strCategoryProduct.hashCode ^
        numPriceMin.hashCode ^
        numPriceMax.hashCode ^
        numStock.hashCode ^
        codList.hashCode ^
        codTiAlmacen.hashCode ^
        codCurrency.hashCode ^
        cod_TiProducts.hashCode ^
        desTiAlmacen.hashCode ^
        num_Empaque.hashCode;
  }
}
