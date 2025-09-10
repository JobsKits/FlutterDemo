// To parse this JSON data, do
//
//     final vipFanshuiDetailListModel = vipFanshuiDetailListModelFromJson(jsonString);

import 'dart:convert';

VipFanshuiDetailListModel vipFanshuiDetailListModelFromJson(String str) =>
    VipFanshuiDetailListModel.fromJson(json.decode(str));

String vipFanshuiDetailListModelToJson(VipFanshuiDetailListModel data) =>
    json.encode(data.toJson());

class VipFanshuiDetailListModel {
  String id;
  String uid;
  String username;
  String date;
  String gameType;
  String platformId;
  String platformName;
  int cashType;
  String currencyId;
  String validBetAmount;
  String rate;
  String rebateAmount;
  int createdAt;

  VipFanshuiDetailListModel({
    required this.id,
    required this.uid,
    required this.username,
    required this.date,
    required this.gameType,
    required this.platformId,
    required this.platformName,
    required this.cashType,
    required this.currencyId,
    required this.validBetAmount,
    required this.rate,
    required this.rebateAmount,
    required this.createdAt,
  });

  factory VipFanshuiDetailListModel.fromJson(Map<String, dynamic> json) =>
      VipFanshuiDetailListModel(
        id: json["id"],
        uid: json["uid"],
        username: json["username"],
        date: json["date"],
        gameType: json["game_type"],
        platformId: json["platform_id"],
        platformName: json["platform_name"],
        cashType: json["cash_type"],
        currencyId: json["currency_id"],
        validBetAmount: json["valid_bet_amount"],
        rate: json["rate"],
        rebateAmount: json["rebate_amount"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "username": username,
        "date": date,
        "game_type": gameType,
        "platform_id": platformId,
        "platform_name": platformName,
        "cash_type": cashType,
        "currency_id": currencyId,
        "valid_bet_amount": validBetAmount,
        "rate": rate,
        "rebate_amount": rebateAmount,
        "created_at": createdAt,
      };
}
