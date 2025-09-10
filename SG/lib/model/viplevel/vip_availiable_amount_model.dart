// To parse this JSON data, do
//
//     final vipAviliableAmountModel = vipAviliableAmountModelFromJson(jsonString);

import 'dart:convert';

VipAviliableAmountModel vipAviliableAmountModelFromJson(String str) =>
    VipAviliableAmountModel.fromJson(json.decode(str));

String vipAviliableAmountModelToJson(VipAviliableAmountModel data) => json.encode(data.toJson());

class VipAviliableAmountModel {
  String id;
  String vip;
  int cashType;
  String amount;
  String receiveAmount;
  String availableAmount;
  int state;

  VipAviliableAmountModel({
    required this.id,
    required this.vip,
    required this.cashType,
    required this.amount,
    required this.receiveAmount,
    required this.availableAmount,
    required this.state,
  });

  factory VipAviliableAmountModel.fromJson(Map<String, dynamic> json) => VipAviliableAmountModel(
        id: json["id"],
        vip: json["vip"],
        cashType: json["cash_type"],
        amount: json["amount"],
        receiveAmount: json["receive_amount"],
        availableAmount: json["available_amount"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vip": vip,
        "cash_type": cashType,
        "amount": amount,
        "receive_amount": receiveAmount,
        "available_amount": availableAmount,
        "state": state,
      };
}
