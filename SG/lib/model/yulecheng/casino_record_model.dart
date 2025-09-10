// To parse this JSON data, do
//
//     final casinoRecordModel = casinoRecordModelFromJson(jsonString);

import 'dart:convert';

CasinoRecordModel casinoRecordModelFromJson(String str) => CasinoRecordModel.fromJson(json.decode(str));

String casinoRecordModelToJson(CasinoRecordModel data) => json.encode(data.toJson());

class CasinoRecordModel {
  // "bill_no": "501398729000", //注单流水号
  // "bet_time": 1701257957000, //投注时间
  // "platform_id": "303", //平台ID
  // "platform_name": "PP电子", //平台名称
  // "username": "dreamy6637", //投注人
  // "game_class": "3", //游戏类型
  // "game_name": "3个精灵的祝福", //游戏名称
  // "game_code": "imgame13118", //游戏编码
  // "bet_amount": "5.0000", //投注金额
  // "valid_bet_amount": "0.0000", //有效投注金额
  // "net_amount": "0.0000", //玩家输赢金额
  // "currency_id": "701" //币种ID
  // "settle_amount": "" //支付额
  String billNo;
  int betTime;
  String platformId;
  String platformName;
  String uid;
  String username;
  String gameClass;
  String gameName;
  String gameCode;
  String betAmount;
  String validBetAmount;
  String netAmount;
  String currencyId;
  String icon;
  String? settleAmount;
  String? factor;
  dynamic? billNoHash;


  CasinoRecordModel({
    required this.billNo,
    required this.betTime,
    required this.platformId,
    required this.platformName,
    required this.uid,
    required this.username,
    required this.gameClass,
    required this.gameName,
    required this.gameCode,
    required this.betAmount,
    required this.validBetAmount,
    required this.netAmount,
    required this.currencyId,
    required this.icon,
     this.settleAmount,
    this.factor,
    this.billNoHash
  });

  factory CasinoRecordModel.fromJson(Map<String, dynamic> json) => CasinoRecordModel(
    billNo: json["bill_no"],
    betTime: json["bet_time"],
    platformId: json["platform_id"],
    platformName: json["platform_name"],
    uid: json["uid"],
    username: json["username"],
    gameClass: json["game_class"],
    gameName: json["game_name"],
    gameCode: json["game_code"],
    betAmount: json["bet_amount"],
    validBetAmount: json["valid_bet_amount"],
    netAmount: json["net_amount"],
    currencyId: json["currency_id"],
    icon: json["icon"],
    settleAmount: json["settle_amount"],
    factor: json["factor"],
    billNoHash: json["bill_no_hash"],
  );

  Map<String, dynamic> toJson() => {
    "bill_no": billNo,
    "bet_time": betTime,
    "platform_id": platformId,
    "platform_name": platformName,
    "uid": uid,
    "username": username,
    "game_class": gameClass,
    "game_name": gameName,
    "game_code": gameCode,
    "bet_amount": betAmount,
    "valid_bet_amount": validBetAmount,
    "net_amount": netAmount,
    "currency_id": currencyId,
    "icon": icon,
    "settle_amount": settleAmount,
    "factor": factor,
    "bill_no_hash": billNoHash
  };
}
