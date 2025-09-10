// To parse this JSON data, do
//
//     final vipLevelLingQuModel = vipLevelLingQuModelFromJson(jsonString);

import 'dart:convert';

VipLevelLingQuModel vipLevelLingQuModelFromJson(String str) =>
    VipLevelLingQuModel.fromJson(json.decode(str));

String vipLevelLingQuModelToJson(VipLevelLingQuModel data) => json.encode(data.toJson());

class VipLevelLingQuModel {
  String id;
  String rid;
  String vip;
  String currencyId;
  String receiveCurrencyId;
  String amount;
  String receiveAmount;
  String availableAmount;
  int multiple;
  int cashType;
  int createdAt;
  int updatedAt;

  VipLevelLingQuModel({
    required this.id,
    required this.rid,
    required this.vip,
    required this.currencyId,
    required this.receiveCurrencyId,
    required this.amount,
    required this.receiveAmount,
    required this.availableAmount,
    required this.multiple,
    required this.cashType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VipLevelLingQuModel.fromJson(Map<String, dynamic> json) => VipLevelLingQuModel(
        id: json["id"],
        rid: json["rid"],
        vip: json["vip"],
        currencyId: json["currency_id"],
        receiveCurrencyId: json["receive_currency_id"],
        amount: json["amount"],
        receiveAmount: json["receive_amount"],
        availableAmount: json["available_amount"],
        multiple: json["multiple"],
        cashType: json["cash_type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rid": rid,
        "vip": vip,
        "currency_id": currencyId,
        "receive_currency_id": receiveCurrencyId,
        "amount": amount,
        "receive_amount": receiveAmount,
        "available_amount": availableAmount,
        "multiple": multiple,
        "cash_type": cashType,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
