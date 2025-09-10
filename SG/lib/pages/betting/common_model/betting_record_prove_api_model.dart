import 'dart:convert';

import '../../../generated/l10n.dart';

///game/original/game/detail?id=66596818015017844&uid=29899334526508548
/// 投注记录， 详情对话框 可证明公平api model
class BettingRecordProveApiModel {
  String? orderId;
  String? uid;
  String? username;
  String? currencyId;
  String? betAmount;
  String? betDetail;
  String? netAmount;
  String? payoutMultiplier;
  String? settleAmount;
  String? remark;
  String? gameId;
  String? betType;
  int? createdAt;
  String? result;
  String? seedId;
  int? nonce;
  String? clientSeed;
  String? serverSeed;
  String? serverSeedHash;
  ProveBetDetail? proveBetDetail; //自定义字段， 对betDetail 进行解析

  BettingRecordProveApiModel({
    this.orderId,
    this.uid,
    this.username,
    this.currencyId,
    this.betAmount,
    this.betDetail,
    this.netAmount,
    this.payoutMultiplier,
    this.settleAmount,
    this.remark,
    this.gameId,
    this.betType,
    this.createdAt,
    this.result,
    this.seedId,
    this.nonce,
    this.clientSeed,
    this.serverSeed,
    this.serverSeedHash,
    this.proveBetDetail,
  });

  factory BettingRecordProveApiModel.fromJson(Map<String, dynamic> jsonMap) =>
      BettingRecordProveApiModel(
        orderId: jsonMap["order_id"],
        uid: jsonMap["uid"],
        username: jsonMap["username"],
        currencyId: jsonMap["currency_id"],
        betAmount: jsonMap["bet_amount"],
        betDetail: jsonMap["bet_detail"],
        netAmount: jsonMap["net_amount"],
        payoutMultiplier: jsonMap["payout_multiplier"],
        settleAmount: jsonMap["settle_amount"],
        remark: jsonMap["remark"],
        gameId: jsonMap["game_id"],
        betType: jsonMap["bet_type"],
        createdAt: jsonMap["created_at"],
        result: jsonMap["result"],
        seedId: jsonMap["seed_id"],
        nonce: jsonMap["nonce"],
        clientSeed: jsonMap["client_seed"],
        serverSeed: jsonMap["server_seed"],
        serverSeedHash: jsonMap["server_seed_hash"],
        proveBetDetail: jsonMap["bet_detail"] == null
            ? null
            : ProveBetDetail.fromJson(json.decode(jsonMap["bet_detail"])),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "uid": uid,
        "username": username,
        "currency_id": currencyId,
        "bet_amount": betAmount,
        "bet_detail": betDetail,
        "net_amount": netAmount,
        "payout_multiplier": payoutMultiplier,
        "settle_amount": settleAmount,
        "remark": remark,
        "game_id": gameId,
        "bet_type": betType,
        "created_at": createdAt,
        "result": result,
        "seed_id": seedId,
        "nonce": nonce,
        "client_seed": clientSeed,
        "server_seed": serverSeed,
        "server_seed_hash": serverSeedHash,
      };
}

/// 投注记录， 详情对话框 可证明公平api model
/// BettingRecordProveApiModel 接口中的对  String? betDetail; 解析
class ProveBetDetail {
  String? result; //结果
  String? winChance; //获胜机率
  String? multiplierTarget; //目标
  String? target; //掷小于 or  掷大于 ，取决于condition字段，
  String? condition; //"above"
  String? payoutMultiplier; //乘数
  int? index; //Plinko用到
  String? rows; //Plinko用到
  String? risk; //Plinko用到 "low"

  //是否大于
  bool isAbove() {
    return condition == "above";
  }

  ///Plinko获取风险等级
  String getRiskLabel() {
    if (risk == "low") {
      return S.current.random_text_1070;
    } else if (risk == "middle") {
      return S.current.random_text_804;
    } else if (risk == "high") {
      return S.current.random_text_1071;
    } else {
      return "";
    }
  }

  ProveBetDetail({
    this.result,
    this.winChance,
    this.multiplierTarget,
    this.target,
    this.condition,
    this.payoutMultiplier,
    this.risk,
    this.rows,
    this.index,
  });

  factory ProveBetDetail.fromJson(Map<String, dynamic> json) => ProveBetDetail(
        result: json["result"],
        winChance: json["win_chance"],
        multiplierTarget: json["multiplier_target"],
        target: json["target"],
        condition: json["condition"],
        payoutMultiplier: json["payout_multiplier"],
        risk: json["risk"],
        rows: json["rows"],
        index: json["index"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "win_chance": winChance,
        "multiplier_target": multiplierTarget,
        "target": target,
        "condition": condition,
        "payout_multiplier": payoutMultiplier,
        "risk": risk,
        "rows": rows,
        "index": index,
      };
}
