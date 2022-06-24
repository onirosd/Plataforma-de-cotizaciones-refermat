import 'dart:convert';

class SelectQuotation {
  String id;
  String ruc;
  String fec;
  int prods;
  String state;
  int numstate;
  String total;

  bool selected = false;

  SelectQuotation({
    required this.id,
    required this.ruc,
    required this.fec,
    required this.prods,
    required this.state,
    required this.numstate,
    required this.total,
  });

  SelectQuotation copyWith({
    String? id,
    String? ruc,
    String? fec,
    int? prods,
    String? state,
    int? numstate,
    String? total,
  }) {
    return SelectQuotation(
      id: id ?? this.id,
      ruc: ruc ?? this.ruc,
      fec: fec ?? this.fec,
      prods: prods ?? this.prods,
      state: state ?? this.state,
      numstate: numstate ?? this.numstate,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'ruc': ruc});
    result.addAll({'fec': fec});
    result.addAll({'prods': prods});
    result.addAll({'state': state});
    result.addAll({'numstate': numstate});
    result.addAll({'total': total});

    return result;
  }

  factory SelectQuotation.fromMap(Map<String, dynamic> map) {
    return SelectQuotation(
      id: map['id'] ?? '',
      ruc: map['ruc'] ?? '',
      fec: map['fec'] ?? '',
      prods: map['prods']?.toInt() ?? 0,
      state: map['state'] ?? '',
      numstate: map['numstate']?.toInt() ?? 0,
      total: map['total'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectQuotation.fromJson(String source) =>
      SelectQuotation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SelectQuotation(id: $id, ruc: $ruc, fec: $fec, prods: $prods, state: $state, numstate: $numstate, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SelectQuotation &&
        other.id == id &&
        other.ruc == ruc &&
        other.fec == fec &&
        other.prods == prods &&
        other.state == state &&
        other.numstate == numstate &&
        other.total == total;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ruc.hashCode ^
        fec.hashCode ^
        prods.hashCode ^
        state.hashCode ^
        numstate.hashCode ^
        total.hashCode;
  }
}

class SelectPendingSync {
  String evento;
  int cantidad;

  SelectPendingSync({
    required this.evento,
    required this.cantidad,
  });

  Map<String, dynamic> toMap() {
    return {
      'evento': evento,
      'cantidad': cantidad,
    };
  }

  factory SelectPendingSync.fromMap(Map<String, dynamic> map) {
    return SelectPendingSync(
      evento: map['evento'],
      cantidad: map['cantidad'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectPendingSync.fromJson(String source) =>
      SelectPendingSync.fromMap(json.decode(source));
}

class SelectBilling {
  String id;
  String date;
  String ruc;
  String salesperson;
  String state;
  int numstate;

  bool selected = false;

  SelectBilling({
    required this.id,
    required this.date,
    required this.ruc,
    required this.salesperson,
    required this.state,
    required this.numstate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'ruc': ruc,
      'salesperson': salesperson,
      'state': state,
      'numstate': numstate
    };
  }

  factory SelectBilling.fromMap(Map<String, dynamic> map) {
    return SelectBilling(
      id: map['id'],
      date: map['date'],
      ruc: map['ruc'],
      salesperson: map['salesperson'],
      state: map['state'],
      numstate: map['numstate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectBilling.fromJson(String source) =>
      SelectBilling.fromMap(json.decode(source));
}

class SelectBillingQuotation {
  String id;
  String tipo;
  String codCustomer;
  String fec;
  String userId;
  String salesperson;
  int prods;
  int numstate;
  String total;

  bool selected = false;

  SelectBillingQuotation({
    required this.id,
    required this.tipo,
    required this.codCustomer,
    required this.fec,
    required this.userId,
    required this.salesperson,
    required this.prods,
    required this.numstate,
    required this.total,
  });

  SelectBillingQuotation copyWith({
    String? id,
    String? tipo,
    String? codCustomer,
    String? fec,
    String? userId,
    String? salesperson,
    int? prods,
    int? numstate,
    String? total,
  }) {
    return SelectBillingQuotation(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      codCustomer: codCustomer ?? this.codCustomer,
      fec: fec ?? this.fec,
      userId: userId ?? this.userId,
      salesperson: salesperson ?? this.salesperson,
      prods: prods ?? this.prods,
      numstate: numstate ?? this.numstate,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'tipo': tipo});
    result.addAll({'codCustomer': codCustomer});
    result.addAll({'fec': fec});
    result.addAll({'userId': userId});
    result.addAll({'salesperson': salesperson});
    result.addAll({'prods': prods});
    result.addAll({'numstate': numstate});
    result.addAll({'total': total});

    return result;
  }

  factory SelectBillingQuotation.fromMap(Map<String, dynamic> map) {
    return SelectBillingQuotation(
      id: map['id'] ?? '',
      tipo: map['tipo'] ?? '',
      codCustomer: map['codCustomer'] ?? '',
      fec: map['fec'] ?? '',
      userId: map['userId'] ?? '',
      salesperson: map['salesperson'] ?? '',
      prods: map['prods']?.toInt() ?? 0,
      numstate: map['numstate']?.toInt() ?? 0,
      total: map['total'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectBillingQuotation.fromJson(String source) =>
      SelectBillingQuotation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SelectBillingQuotation(id: $id, tipo: $tipo, codCustomer: $codCustomer, fec: $fec, userId: $userId, salesperson: $salesperson, prods: $prods, numstate: $numstate, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SelectBillingQuotation &&
        other.id == id &&
        other.tipo == tipo &&
        other.codCustomer == codCustomer &&
        other.fec == fec &&
        other.userId == userId &&
        other.salesperson == salesperson &&
        other.prods == prods &&
        other.numstate == numstate &&
        other.total == total;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        tipo.hashCode ^
        codCustomer.hashCode ^
        fec.hashCode ^
        userId.hashCode ^
        salesperson.hashCode ^
        prods.hashCode ^
        numstate.hashCode ^
        total.hashCode;
  }
}
