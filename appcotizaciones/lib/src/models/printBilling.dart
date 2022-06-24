import 'dart:convert';

class PrintBilling {
  String nombreCliente;
  String direccion;
  String monto;
  String numRecibo;
  String tipoCobro;
  String metodoPago;
  String nroOperacion;
  String banco;
  String observaciones;
  String vendedor;
  String fecha;
  String ruc;

  PrintBilling({
    required this.nombreCliente,
    required this.direccion,
    required this.monto,
    required this.numRecibo,
    required this.tipoCobro,
    required this.metodoPago,
    required this.nroOperacion,
    required this.banco,
    required this.observaciones,
    required this.vendedor,
    required this.fecha,
    required this.ruc,
  });

  PrintBilling copyWith({
    String? nombreCliente,
    String? direccion,
    String? monto,
    String? numRecibo,
    String? tipoCobro,
    String? metodoPago,
    String? nroOperacion,
    String? banco,
    String? observaciones,
    String? vendedor,
    String? fecha,
    String? ruc,
  }) {
    return PrintBilling(
      nombreCliente: nombreCliente ?? this.nombreCliente,
      direccion: direccion ?? this.direccion,
      monto: monto ?? this.monto,
      numRecibo: numRecibo ?? this.numRecibo,
      tipoCobro: tipoCobro ?? this.tipoCobro,
      metodoPago: metodoPago ?? this.metodoPago,
      nroOperacion: nroOperacion ?? this.nroOperacion,
      banco: banco ?? this.banco,
      observaciones: observaciones ?? this.observaciones,
      vendedor: vendedor ?? this.vendedor,
      fecha: fecha ?? this.fecha,
      ruc: ruc ?? this.ruc,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'nombreCliente': nombreCliente});
    result.addAll({'direccion': direccion});
    result.addAll({'monto': monto});
    result.addAll({'numRecibo': numRecibo});
    result.addAll({'tipoCobro': tipoCobro});
    result.addAll({'metodoPago': metodoPago});
    result.addAll({'nroOperacion': nroOperacion});
    result.addAll({'banco': banco});
    result.addAll({'observaciones': observaciones});
    result.addAll({'vendedor': vendedor});
    result.addAll({'fecha': fecha});
    result.addAll({'ruc': ruc});

    return result;
  }

  factory PrintBilling.fromMap(Map<String, dynamic> map) {
    return PrintBilling(
      nombreCliente: map['nombreCliente'] ?? '',
      direccion: map['direccion'] ?? '',
      monto: map['monto'] ?? '',
      numRecibo: map['numRecibo'] ?? '',
      tipoCobro: map['tipoCobro'] ?? '',
      metodoPago: map['metodoPago'] ?? '',
      nroOperacion: map['nroOperacion'] ?? '',
      banco: map['banco'] ?? '',
      observaciones: map['observaciones'] ?? '',
      vendedor: map['vendedor'] ?? '',
      fecha: map['fecha'] ?? '',
      ruc: map['ruc'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PrintBilling.fromJson(String source) =>
      PrintBilling.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PrintBilling(nombreCliente: $nombreCliente, direccion: $direccion, monto: $monto, numRecibo: $numRecibo, tipoCobro: $tipoCobro, metodoPago: $metodoPago, nroOperacion: $nroOperacion, banco: $banco, observaciones: $observaciones, vendedor: $vendedor, fecha: $fecha, ruc: $ruc)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PrintBilling &&
        other.nombreCliente == nombreCliente &&
        other.direccion == direccion &&
        other.monto == monto &&
        other.numRecibo == numRecibo &&
        other.tipoCobro == tipoCobro &&
        other.metodoPago == metodoPago &&
        other.nroOperacion == nroOperacion &&
        other.banco == banco &&
        other.observaciones == observaciones &&
        other.vendedor == vendedor &&
        other.fecha == fecha &&
        other.ruc == ruc;
  }

  @override
  int get hashCode {
    return nombreCliente.hashCode ^
        direccion.hashCode ^
        monto.hashCode ^
        numRecibo.hashCode ^
        tipoCobro.hashCode ^
        metodoPago.hashCode ^
        nroOperacion.hashCode ^
        banco.hashCode ^
        observaciones.hashCode ^
        vendedor.hashCode ^
        fecha.hashCode ^
        ruc.hashCode;
  }
}
