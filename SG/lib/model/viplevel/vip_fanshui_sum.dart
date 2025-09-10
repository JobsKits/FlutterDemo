// To parse this JSON data, do
//
//     final vipFanshuiSumModel = vipFanshuiSumModelFromJson(jsonString);

import 'dart:convert';

List<VipFanshuiSumModel> vipFanshuiSumModelFromJson(String str) =>
    List<VipFanshuiSumModel>.from(json.decode(str).map((x) => VipFanshuiSumModel.fromJson(x)));

String vipFanshuiSumModelToJson(List<VipFanshuiSumModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VipFanshuiSumModel {
  String gameType;
  String validBetAmount;
  String currencyId;
  String rebateAmount;

  VipFanshuiSumModel({
    required this.gameType,
    required this.validBetAmount,
    required this.currencyId,
    required this.rebateAmount,
  });

  factory VipFanshuiSumModel.fromJson(Map<String, dynamic> json) => VipFanshuiSumModel(
        gameType: json["game_type"],
        validBetAmount: json["valid_bet_amount"],
        currencyId: json["currency_id"],
        rebateAmount: json["rebate_amount"],
      );

  Map<String, dynamic> toJson() => {
        "game_type": gameType,
        "valid_bet_amount": validBetAmount,
        "currency_id": currencyId,
        "rebate_amount": rebateAmount,
      };
}
