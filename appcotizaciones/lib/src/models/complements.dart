import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:appcotizaciones/src/models/bank.dart';
import 'package:appcotizaciones/src/models/billingType.dart';
import 'package:appcotizaciones/src/models/company.dart';
import 'package:appcotizaciones/src/models/currency.dart';
import 'package:appcotizaciones/src/models/delivery_time_model.dart';
import 'package:appcotizaciones/src/models/delivery_type_model.dart';
import 'package:appcotizaciones/src/models/indicators.dart';
import 'package:appcotizaciones/src/models/payCondition.dart';
import 'package:appcotizaciones/src/models/paymentMethod.dart';
import 'package:appcotizaciones/src/models/tilist.dart';
import 'package:appcotizaciones/src/models/tiperson.dart';

class Complements {
  List<TiPerson>? tiperson;
  List<TiList>? tilist;
  List<Bank>? bank;
  List<PayCondition>? paycondition;
  List<PaymentMethod>? paymentmethod;
  List<BillingType>? billingtype;
  List<Currency>? currency;
  List<DeliveryTime>? deliverytime;
  List<DeliveryType>? deliverytype;
  List<Ti_IndicatorsUser>? indicators;

  Complements({
    this.tiperson,
    this.tilist,
    this.bank,
    this.paycondition,
    this.paymentmethod,
    this.billingtype,
    this.currency,
    this.deliverytime,
    this.deliverytype,
    this.indicators,
  });

  Complements copyWith({
    List<TiPerson>? tiperson,
    List<TiList>? tilist,
    List<Bank>? bank,
    List<PayCondition>? paycondition,
    List<PaymentMethod>? paymentmethod,
    List<BillingType>? billingtype,
    List<Currency>? currency,
    List<DeliveryTime>? deliverytime,
    List<DeliveryType>? deliverytype,
    List<Ti_IndicatorsUser>? indicators,
  }) {
    return Complements(
      tiperson: tiperson ?? this.tiperson,
      tilist: tilist ?? this.tilist,
      bank: bank ?? this.bank,
      paycondition: paycondition ?? this.paycondition,
      paymentmethod: paymentmethod ?? this.paymentmethod,
      billingtype: billingtype ?? this.billingtype,
      currency: currency ?? this.currency,
      deliverytime: deliverytime ?? this.deliverytime,
      deliverytype: deliverytype ?? this.deliverytype,
      indicators: indicators ?? this.indicators,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (tiperson != null) {
      result.addAll({'tiperson': tiperson!.map((x) => x?.toMap()).toList()});
    }
    if (tilist != null) {
      result.addAll({'tilist': tilist!.map((x) => x?.toMap()).toList()});
    }
    if (bank != null) {
      result.addAll({'bank': bank!.map((x) => x?.toMap()).toList()});
    }
    if (paycondition != null) {
      result.addAll(
          {'paycondition': paycondition!.map((x) => x?.toMap()).toList()});
    }
    if (paymentmethod != null) {
      result.addAll(
          {'paymentmethod': paymentmethod!.map((x) => x?.toMap()).toList()});
    }
    if (billingtype != null) {
      result.addAll(
          {'billingtype': billingtype!.map((x) => x?.toMap()).toList()});
    }
    if (currency != null) {
      result.addAll({'currency': currency!.map((x) => x?.toMap()).toList()});
    }
    if (deliverytime != null) {
      result.addAll(
          {'deliverytime': deliverytime!.map((x) => x?.toMap()).toList()});
    }
    if (deliverytype != null) {
      result.addAll(
          {'deliverytype': deliverytype!.map((x) => x?.toMap()).toList()});
    }
    if (indicators != null) {
      result
          .addAll({'indicators': indicators!.map((x) => x?.toMap()).toList()});
    }

    return result;
  }

  factory Complements.fromMap(Map<String, dynamic> map) {
    return Complements(
      tiperson: map['tiperson'] != null
          ? List<TiPerson>.from(
              map['tiperson']?.map((x) => TiPerson.fromMap(x)))
          : null,
      tilist: map['tilist'] != null
          ? List<TiList>.from(map['tilist']?.map((x) => TiList.fromMap(x)))
          : null,
      bank: map['bank'] != null
          ? List<Bank>.from(map['bank']?.map((x) => Bank.fromMap(x)))
          : null,
      paycondition: map['paycondition'] != null
          ? List<PayCondition>.from(
              map['paycondition']?.map((x) => PayCondition.fromMap(x)))
          : null,
      paymentmethod: map['paymentmethod'] != null
          ? List<PaymentMethod>.from(
              map['paymentmethod']?.map((x) => PaymentMethod.fromMap(x)))
          : null,
      billingtype: map['billingtype'] != null
          ? List<BillingType>.from(
              map['billingtype']?.map((x) => BillingType.fromMap(x)))
          : null,
      currency: map['currency'] != null
          ? List<Currency>.from(
              map['currency']?.map((x) => Currency.fromMap(x)))
          : null,
      deliverytime: map['deliverytime'] != null
          ? List<DeliveryTime>.from(
              map['deliverytime']?.map((x) => DeliveryTime.fromMap(x)))
          : null,
      deliverytype: map['deliverytype'] != null
          ? List<DeliveryType>.from(
              map['deliverytype']?.map((x) => DeliveryType.fromMap(x)))
          : null,
      indicators: map['indicators'] != null
          ? List<Ti_IndicatorsUser>.from(
              map['indicators']?.map((x) => Ti_IndicatorsUser.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Complements.fromJson(String source) =>
      Complements.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Complements(tiperson: $tiperson, tilist: $tilist, bank: $bank, paycondition: $paycondition, paymentmethod: $paymentmethod, billingtype: $billingtype, currency: $currency, deliverytime: $deliverytime, deliverytype: $deliverytype, indicators: $indicators)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Complements &&
        listEquals(other.tiperson, tiperson) &&
        listEquals(other.tilist, tilist) &&
        listEquals(other.bank, bank) &&
        listEquals(other.paycondition, paycondition) &&
        listEquals(other.paymentmethod, paymentmethod) &&
        listEquals(other.billingtype, billingtype) &&
        listEquals(other.currency, currency) &&
        listEquals(other.deliverytime, deliverytime) &&
        listEquals(other.deliverytype, deliverytype) &&
        listEquals(other.indicators, indicators);
  }

  @override
  int get hashCode {
    return tiperson.hashCode ^
        tilist.hashCode ^
        bank.hashCode ^
        paycondition.hashCode ^
        paymentmethod.hashCode ^
        billingtype.hashCode ^
        currency.hashCode ^
        deliverytime.hashCode ^
        deliverytype.hashCode ^
        indicators.hashCode;
  }
}
