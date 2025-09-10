// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

// Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));
//
// String welcomeToJson(Welcome data) => json.encode(data.toJson());
/// 我的推广接口 网络model
/// 我的推广/agency/mypromotion
class AllianceMyPromotionApiModel {
  String? linkUrl;
  Commission? commission; //佣金信息
  Performance? performance; //我的业绩
  Subordinate? subordinate; //下属的赌注

  AllianceMyPromotionApiModel({
    this.linkUrl,
    this.commission,
    this.performance,
    this.subordinate,
  });

  factory AllianceMyPromotionApiModel.fromJson(Map<String, dynamic> json) =>
      AllianceMyPromotionApiModel(
        linkUrl: json["link_url"],
        commission: json["commission"] == null ? null : Commission.fromJson(json["commission"]),
        performance: json["performance"] == null ? null : Performance.fromJson(json["performance"]),
        subordinate: json["subordinate"] == null ? null : Subordinate.fromJson(json["subordinate"]),
      );

  Map<String, dynamic> toJson() => {
        "link_url": linkUrl,
        "commission": commission?.toJson(),
        "performance": performance?.toJson(),
        "subordinate": subordinate?.toJson(),
      };
}

class Commission {
  // "accumulated": "0.00", //佣金-累计佣金金额
  // "received": "0.00", //佣金-已经领取佣金
  // "last_commission": "0.00" //佣金-上次佣金
  String accumulated;
  String received;
  String lastCommission;

  Commission({
    required this.accumulated,
    required this.received,
    required this.lastCommission,
  });

  factory Commission.fromJson(Map<String, dynamic> json) => Commission(
        accumulated: json["accumulated"] ?? "0.00",
        received: json["received"] ?? "0.00",
        lastCommission: json["last_commission"] ?? "0.00",
      );

  Map<String, dynamic> toJson() => {
        "accumulated": accumulated,
        "received": received,
        "last_commission": lastCommission,
      };
}

class Performance {
  // "team_num": 0, //业绩-团队总人数
  // "direct_num": 0, //业绩-直属成员
  // "other_num": 0, //业绩-其他成员
  // "performance_amount": "0.0", //业绩-总业绩
  // "direct_amount": "0.0", //业绩-直属业绩
  // "other_amount": "0.0" //业绩-其他业绩

  // "deposit_num": 6, //总充值人数
  // "total_deposit": "1343.37",//总充值
  // "direct_deposit": "1343.37",//直属充值
  // "other_deposit": "0.00"//其他充值

  int teamNum;
  int directNum;
  int otherNum;
  String performanceAmount;
  String directAmount;
  String otherAmount;

  int depositNum; //总充值人数
  String totalDeposit; //总充值
  String directDeposit; //直属充值
  String otherDeposit; //其他充值

  Performance({
    required this.teamNum,
    required this.directNum,
    required this.otherNum,
    required this.performanceAmount,
    required this.directAmount,
    required this.otherAmount,
    required this.depositNum,
    required this.totalDeposit,
    required this.directDeposit,
    required this.otherDeposit,
  });

  factory Performance.fromJson(Map<String, dynamic> json) => Performance(
        teamNum: json["team_num"] ?? 0,
        directNum: json["direct_num"] ?? 0,
        otherNum: json["other_num"] ?? 0,
        performanceAmount: json["performance_amount"] ?? "0.0",
        directAmount: json["direct_amount"] ?? "0.0",
        otherAmount: json["other_amount"] ?? "0.0",
        depositNum: json["deposit_num"] ?? 0,
        totalDeposit: json["total_deposit"] ?? "0.0",
        directDeposit: json["direct_deposit"] ?? "0.0",
        otherDeposit: json["other_deposit"] ?? "0.0",
      );

  Map<String, dynamic> toJson() => {
        "team_num": teamNum,
        "direct_num": directNum,
        "other_num": otherNum,
        "performance_amount": performanceAmount,
        "direct_amount": directAmount,
        "other_amount": otherAmount,
        "deposit_num": depositNum,
        "total_deposit": totalDeposit,
        "direct_deposit": directDeposit,
        "other_deposit": otherDeposit,
      };
}

class Subordinate {
  // "valid_bet_amount": "0.00", //有效投注总额
  // "bet_num": 0, //投注单总数
  // "net_amount": "0.00" //总输/赢
  String validBetAmount;
  int betNum;
  String netAmount;

  Subordinate({
    required this.validBetAmount,
    required this.betNum,
    required this.netAmount,
  });

  factory Subordinate.fromJson(Map<String, dynamic> json) => Subordinate(
        validBetAmount: json["valid_bet_amount"] ?? "0.00",
        betNum: json["bet_num"] ?? 0,
        netAmount: json["net_amount"] ?? "0.00",
      );

  Map<String, dynamic> toJson() => {
        "valid_bet_amount": validBetAmount,
        "bet_num": betNum,
        "net_amount": netAmount,
      };
}
