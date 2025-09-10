// To parse this JSON data, do
//
//     final bigWinsModel = bigWinsModelFromJson(jsonString);

import 'dart:convert';
import 'package:flutter_bet/model/sport/sport_bet_list_model.dart';
import 'package:flutter_bet/pages/betting/common_model/betting_record_api_model.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/utils/money_util.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bet/model/yulecheng/casino_record_model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/utils/common_util.dart';



BigWinsModel bigWinsModelFromJson(String str) => BigWinsModel.fromJson(json.decode(str));

/// 大赢家/幸运赢家/排行榜等
/// TODO:待删除 转为使用BettingRecordApiModel
class BigWinsModel {
  String billNo;
  String uid;
  String username;
  String gameClass;
  String gameName;
  String gameCode;
  String betAmount;
  String payAmount;
  String createdAt;
  String state;
  String currencyId;
  String icon;

  int? betTime;
  String? platformId;
  String? platformName;
  String? validBetAmount;
  String? netAmount;
  String? settleAmount;
  String? detail;
  String? factor;
  dynamic? billNoHash;

  BigWinsModel({
      required this.billNo,
      required this.uid,
      required this.username,
      required this.gameClass,
      required this.gameName,
      required this.gameCode,
      required this.betAmount,
      required this.payAmount,
      required this.createdAt,
      required this.state,
      required this.currencyId,
      required this.icon,
      this.betTime,
      this.platformId,
      this.platformName,
      this.validBetAmount,
      this.netAmount,
      this.detail,
      this.settleAmount,
      this.factor,
      this.billNoHash,
   });

  factory BigWinsModel.fromJson(Map<String, dynamic> json) => BigWinsModel(
        billNo: json["bill_no"],
        uid: json["uid"],
        username: json["username"],
        gameClass: json["game_class"],
        gameName: json["game_name"],
        gameCode: json["game_code"],
        betAmount: json["bet_amount"],
        payAmount: json["pay_amount"],
        createdAt: json["created_at"],
        state: json["state"],
        currencyId: json["currency_id"],
        icon: json["icon"],
        settleAmount: json["settle_amount"],
        netAmount: json["net_amount"],
        betTime: json["bet_time"],
        platformId: json["platform_id"],
        detail: json["detail"],
        platformName: json["platform_name"],
        factor: json["factor"],
        billNoHash: json["bill_no_hash"],
      );

  Map<String, dynamic> toJson() => {
    "bill_no": billNo,
    "uid": uid,
    "bet_time": betTime,
    "created_at": createdAt,
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
    "icon": icon,
    "pay_amount": payAmount,
    "settle_amount": settleAmount,
    "factor": factor,
    "bill_no_hash": billNoHash
  };



  // 用户是否隐藏
  bool get isHidden {
    // state1正常2隐身
    return state == "2";
  }

  // 日期title
  String get timeTitle {
    return CommonUtil.getLocalTimeTitle(int.parse(createdAt), cIncludeFormats: [yyyy, mm, dd]);
  }

  // 游戏类型icon
  String get gameClassIcon {
    // return "assets/images/yulecheng/game_class/e_game.webp";
    if (icon.isEmpty) {
      return "";
    }
    return '${BranchService.instance.current.asset_url}$icon';
  }

  // 货币url
  String get coinImgUrl {
    return '${BranchService.instance.current.asset_url}/currency/$currencyId.webp';
  }

  // 倍率
  String get multipller {
    double multipller = double.parse(payAmount) / double.parse(betAmount);
    // 格式化数字，添加千位分隔符
    String formattedString = NumberFormat("#,###.0#").format(multipller);
    return "${formattedString}x";
  }

  // 投注额
  String get betAmountTitle {
    return MoneyUtil.toCoinAmountFormat(currencyId, betAmount);
  }

  // 支付额
  String get payout {
    var amountString = payAmount;
    // 我的投注
    if(username == AccountService.sharedInstance.currentUser?.username) {
      amountString =  settleAmount ?? payAmount;
    }
    return MoneyUtil.toCoinAmountFormat(currencyId, amountString);
  }

  // 用于排序的支付额
  double get settleDouble {
    return double.parse(settleAmount ?? "0.0");
  }

  // 体育投注信息
  ListElement? get detailSportInfo {

    Map<String, dynamic> jdetailMap = json.decode(detail ?? "");
    Map<String, dynamic> biMap = jdetailMap['bi'];
    jdetailMap.update("bi", (value) => [biMap]);

    final eve = ListElement.fromJson(jdetailMap);
    // print("============eve sn");
    // print(eve?.bi?.first.sn);
    // print("============eve ono");
    // print(eve?.ono);
    return eve;
  }

  // BettingRankApiModel ==>> BigWinsModel
  static BigWinsModel conversionWithBrModel(BettingRecordApiModel model) {
    return BigWinsModel(
      billNo: model.billNo ?? "",
      uid: model.uid ?? "",
      username: model.username ?? "",
      gameClass: model.gameClass ?? "",
      gameName: model.gameName ?? "",
      gameCode: model.gameCode ?? "",
      betAmount: model.betAmount ?? "",
      payAmount: model.payAmount ?? "",
      createdAt: model.createdAt.toString(),
      state: model.state ?? "",
      currencyId: model.currencyId ?? "",
      icon: model.icon ?? "",
      betTime: model.betTime,
      platformId: model.platformId,
      platformName: model.platformName,
      validBetAmount: model.validBetAmount,
      netAmount: model.netAmount,
      settleAmount: model.settleAmount,
      detail: model.detail,
      factor: model.factor,
      billNoHash: model.billNoHash,
    );
  }


  // BigWinsModel ==>> BettingRankApiModel
  BettingRecordApiModel get bettingRecordApiModel {
    return BettingRecordApiModel(
      billNo: billNo,
      betTime: betTime,
      createdAt: createdAt,
      state: state,
      platformId: platformId,
      platformName: platformName,
      username: username,
      gameClass: gameClass,
      gameName: gameName,
      gameCode: gameCode,
      betAmount: betAmount,
      validBetAmount: validBetAmount,
      netAmount: netAmount,
      currencyId: currencyId,
      icon: icon,
      payAmount: payAmount,
      settleAmount: settleAmount,
      detail: detail,
      factor: factor,
      billNoHash: billNoHash,
    );
  }

  // CasinoRecordModel ==>> BigWinsModel
  static BigWinsModel conversionWithCrModel(CasinoRecordModel model) {
    return BigWinsModel(
      billNo: model.billNo,
      uid: model.uid,
      username: model.username,
      gameClass: model.gameClass,
      gameName: model.gameName,
      gameCode: model.gameCode,
      betAmount: model.betAmount,
      payAmount: model.netAmount,
      createdAt: model.betTime.toString(),
      state: "1",
      currencyId: model.currencyId,
      icon: model.icon,
      betTime: model.betTime,
      platformId: model.platformId,
      platformName: model.platformName,
      validBetAmount: model.validBetAmount,
      netAmount: model.netAmount,
      settleAmount: model.settleAmount,
      factor: model.factor,
      billNoHash: model.billNoHash,
    );
  }

}

/*
*   // "bill_no": "501398729000", //注单流水号
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
*
* */




// //
// // BigWinsModel ==>> CasinoRecordModel
// CasinoRecordModel get conversionCasinoRecordModel {
//   return CasinoRecordModel(
//     billNo: billNo,
//     betTime: betTime ?? 0,
//     platformId: platformId ?? "",
//     platformName: platformName ?? "",
//     username: username,
//     gameClass: gameClass,
//     gameName: gameName,
//     gameCode: gameCode,
//     betAmount: betAmount,
//     validBetAmount: validBetAmount ?? "",
//     netAmount: netAmount ?? "",
//     currencyId: currencyId,
//     icon: icon,
//     settleAmount: settleAmount,
//   );
// }