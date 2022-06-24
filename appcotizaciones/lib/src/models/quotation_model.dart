// To parse this JSON data, do
//
//     final quotation = quotationFromMap(jsonString);

import 'dart:convert';

class Quotation {
  String? id;
  int? currencyId;
  int? payId;
  int? deliveryTypeId;
  int? deliveryTimeId;
  String? customerId;
  int? userId;
  String? dateQuotation;
  String? nameBusiness;
  String? observation;
  String? subTotal;
  String? total;
  String? lgv;
  String? createDate;
  String? createUser;
  String? updateDate;
  String? updateUser;
  String? state;
  String? quotationParents;
  int? company;
  int? updateflg;
  String? latitude;
  String? longitude;

  Quotation({
    this.id,
    this.currencyId,
    this.payId,
    this.deliveryTypeId,
    this.deliveryTimeId,
    this.customerId,
    this.userId,
    this.dateQuotation,
    this.nameBusiness,
    this.observation,
    this.subTotal,
    this.total,
    this.lgv,
    this.createDate,
    this.createUser,
    this.updateDate,
    this.updateUser,
    this.state,
    this.quotationParents,
    this.company,
    this.updateflg,
    this.latitude,
    this.longitude,
  });

  Quotation copyWith({
    String? id,
    int? currencyId,
    int? payId,
    int? deliveryTypeId,
    int? deliveryTimeId,
    String? customerId,
    int? userId,
    String? dateQuotation,
    String? nameBusiness,
    String? observation,
    String? subTotal,
    String? total,
    String? lgv,
    String? createDate,
    String? createUser,
    String? updateDate,
    String? updateUser,
    String? state,
    String? quotationParents,
    int? company,
    int? updateflg,
    String? latitude,
    String? longitude,
  }) {
    return Quotation(
      id: id ?? this.id,
      currencyId: currencyId ?? this.currencyId,
      payId: payId ?? this.payId,
      deliveryTypeId: deliveryTypeId ?? this.deliveryTypeId,
      deliveryTimeId: deliveryTimeId ?? this.deliveryTimeId,
      customerId: customerId ?? this.customerId,
      userId: userId ?? this.userId,
      dateQuotation: dateQuotation ?? this.dateQuotation,
      nameBusiness: nameBusiness ?? this.nameBusiness,
      observation: observation ?? this.observation,
      subTotal: subTotal ?? this.subTotal,
      total: total ?? this.total,
      lgv: lgv ?? this.lgv,
      createDate: createDate ?? this.createDate,
      createUser: createUser ?? this.createUser,
      updateDate: updateDate ?? this.updateDate,
      updateUser: updateUser ?? this.updateUser,
      state: state ?? this.state,
      quotationParents: quotationParents ?? this.quotationParents,
      company: company ?? this.company,
      updateflg: updateflg ?? this.updateflg,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (currencyId != null) {
      result.addAll({'currencyId': currencyId});
    }
    if (payId != null) {
      result.addAll({'payId': payId});
    }
    if (deliveryTypeId != null) {
      result.addAll({'deliveryTypeId': deliveryTypeId});
    }
    if (deliveryTimeId != null) {
      result.addAll({'deliveryTimeId': deliveryTimeId});
    }
    if (customerId != null) {
      result.addAll({'customerId': customerId});
    }
    if (userId != null) {
      result.addAll({'userId': userId});
    }
    if (dateQuotation != null) {
      result.addAll({'dateQuotation': dateQuotation});
    }
    if (nameBusiness != null) {
      result.addAll({'nameBusiness': nameBusiness});
    }
    if (observation != null) {
      result.addAll({'observation': observation});
    }
    if (subTotal != null) {
      result.addAll({'subTotal': subTotal});
    }
    if (total != null) {
      result.addAll({'total': total});
    }
    if (lgv != null) {
      result.addAll({'lgv': lgv});
    }
    if (createDate != null) {
      result.addAll({'createDate': createDate});
    }
    if (createUser != null) {
      result.addAll({'createUser': createUser});
    }
    if (updateDate != null) {
      result.addAll({'updateDate': updateDate});
    }
    if (updateUser != null) {
      result.addAll({'updateUser': updateUser});
    }
    if (state != null) {
      result.addAll({'state': state});
    }
    if (quotationParents != null) {
      result.addAll({'quotationParents': quotationParents});
    }
    if (company != null) {
      result.addAll({'company': company});
    }
    if (updateflg != null) {
      result.addAll({'updateflg': updateflg});
    }
    if (latitude != null) {
      result.addAll({'latitude': latitude});
    }
    if (longitude != null) {
      result.addAll({'longitude': longitude});
    }

    return result;
  }

  factory Quotation.fromMap(Map<String, dynamic> map) {
    return Quotation(
      id: map['id'],
      currencyId: map['currencyId']?.toInt(),
      payId: map['payId']?.toInt(),
      deliveryTypeId: map['deliveryTypeId']?.toInt(),
      deliveryTimeId: map['deliveryTimeId']?.toInt(),
      customerId: map['customerId'].toString(),
      userId: map['userId']?.toInt(),
      dateQuotation: map['dateQuotation'],
      nameBusiness: map['nameBusiness'],
      observation: map['observation'],
      subTotal: map['subTotal'],
      total: map['total'],
      lgv: map['lgv'],
      createDate: map['createDate'],
      createUser: map['createUser'],
      updateDate: map['updateDate'],
      updateUser: map['updateUser'],
      state: map['state'],
      quotationParents: map['quotationParents'],
      company: map['company']?.toInt(),
      updateflg: map['updateflg']?.toInt(),
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Quotation.fromJson(String source) =>
      Quotation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Quotation(id: $id, currencyId: $currencyId, payId: $payId, deliveryTypeId: $deliveryTypeId, deliveryTimeId: $deliveryTimeId, customerId: $customerId, userId: $userId, dateQuotation: $dateQuotation, nameBusiness: $nameBusiness, observation: $observation, subTotal: $subTotal, total: $total, lgv: $lgv, createDate: $createDate, createUser: $createUser, updateDate: $updateDate, updateUser: $updateUser, state: $state, quotationParents: $quotationParents, company: $company, updateflg: $updateflg, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Quotation &&
        other.id == id &&
        other.currencyId == currencyId &&
        other.payId == payId &&
        other.deliveryTypeId == deliveryTypeId &&
        other.deliveryTimeId == deliveryTimeId &&
        other.customerId == customerId &&
        other.userId == userId &&
        other.dateQuotation == dateQuotation &&
        other.nameBusiness == nameBusiness &&
        other.observation == observation &&
        other.subTotal == subTotal &&
        other.total == total &&
        other.lgv == lgv &&
        other.createDate == createDate &&
        other.createUser == createUser &&
        other.updateDate == updateDate &&
        other.updateUser == updateUser &&
        other.state == state &&
        other.quotationParents == quotationParents &&
        other.company == company &&
        other.updateflg == updateflg &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        currencyId.hashCode ^
        payId.hashCode ^
        deliveryTypeId.hashCode ^
        deliveryTimeId.hashCode ^
        customerId.hashCode ^
        userId.hashCode ^
        dateQuotation.hashCode ^
        nameBusiness.hashCode ^
        observation.hashCode ^
        subTotal.hashCode ^
        total.hashCode ^
        lgv.hashCode ^
        createDate.hashCode ^
        createUser.hashCode ^
        updateDate.hashCode ^
        updateUser.hashCode ^
        state.hashCode ^
        quotationParents.hashCode ^
        company.hashCode ^
        updateflg.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }
}
