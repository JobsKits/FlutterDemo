// To parse this JSON data, do
//
//     final trBetModel = trBetModelFromJson(jsonString);

import 'dart:convert';

TrBetModel trBetModelFromJson(String str) => TrBetModel.fromJson(json.decode(str));

String trBetModelToJson(TrBetModel data) => json.encode(data.toJson());

class TrBetModel {
  String billNo;
  int betTime;
  String platformId;
  String platformName;
  String username;
  String gameClass;
  String gameName;
  String gameCode;
  String betAmount;
  String validBetAmount;
  String netAmount;
  String currencyId;

  TrBetModel({
    required this.billNo,
    required this.betTime,
    required this.platformId,
    required this.platformName,
    required this.username,
    required this.gameClass,
    required this.gameName,
    required this.gameCode,
    required this.betAmount,
    required this.validBetAmount,
    required this.netAmount,
    required this.currencyId,
  });

  factory TrBetModel.fromJson(Map<String, dynamic> json) => TrBetModel(
    billNo: json["bill_no"],
    betTime: json["bet_time"],
    platformId: json["platform_id"],
    platformName: json["platform_name"],
    username: json["username"],
    gameClass: json["game_class"],
    gameName: json["game_name"],
    gameCode: json["game_code"],
    betAmount: json["bet_amount"],
    validBetAmount: json["valid_bet_amount"],
    netAmount: json["net_amount"],
    currencyId: json["currency_id"],
  );

  Map<String, dynamic> toJson() => {
    "bill_no": billNo,
    "bet_time": betTime,
    "platform_id": platformId,
    "platform_name": platformName,
    "username": username,
    "game_class": gameClass,
    "game_name": gameName,
    "game_code": gameCode,
    "bet_amount": betAmount,
    "valid_bet_amount": validBetAmount,
    "net_amount": netAmount,
    "currency_id": currencyId,
  };
}
