import 'package:decimal/decimal.dart';
import 'package:flutter_bet/utils/num_util.dart';

///【公用model】娱乐城列表item。 我的投注、所有投注、风云榜
///{{web_url}}/member/bet/list?game_code=highlights000000&game_class=3&page=1&page_size=10&type=0
class BettingRecordApiModel {
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
  // "created_at":1710316155
  //  "state": "2", //1开启2关闭

  String? billNo;
  int? betTime;
  String? createdAt;
  String? platformId;
  String? platformName;
  String? username;
  String? gameClass;
  String? gameName;
  String? gameCode;
  String? betAmount; //投注
  String? validBetAmount;
  String? netAmount;
  String? currencyId;
  String? icon;
  String? payAmount;
  String? settleAmount; //支付额
  String? uid; //投注记录详情对话框需要到
  String? factor; //乘数
  String? state; //todo:【0528】1开启2关闭， 1 显示用户名， 2 隐藏
  dynamic billNoHash; //todo:【0528】详情弹窗 编号 使用这个
  String? detail;


  BettingRecordApiModel({
    this.billNo,
    this.betTime,
    this.createdAt,
    this.platformId,
    this.platformName,
    this.username,
    this.gameClass,
    this.gameName,
    this.gameCode,
    this.betAmount,
    this.validBetAmount,
    this.netAmount,
    this.currencyId,
    this.icon,
    this.payAmount,
    this.settleAmount,
    this.uid, //投注记录详情对话框需要到
    this.factor,
    this.state,
    this.billNoHash,
    this.detail
  });

  ///是否是赢了
  bool isLoseAmount() {
    return settleAmount != null && settleAmount!.contains("-");
  }

  /// 是否隐藏 用户名
  ///1 显示用户名， 2 隐藏
  bool isHideUserName() {
    return state == "2";
  }

  ///适配不同接口的billNoHash，有时是double,有时是String
  String adaptorBillNoHash() {
    if (billNoHash is double) {
      //特殊处理， 直接billNoHash.toString() 会带有.0 的字符串
      return Decimal.parse(billNoHash.toString()).toString(); NumUtil.keepDecimals(billNoHash, digits: 0);
    } else {
      return billNoHash.toString();
    }
  }

  factory BettingRecordApiModel.fromJson(Map<String, dynamic> json) => BettingRecordApiModel(
        billNo: json["bill_no"],
        betTime: json["bet_time"],
        createdAt: json["created_at"],
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
        icon: json["icon"],
        payAmount: json["pay_amount"],
        settleAmount: json["settle_amount"],
        uid: json["uid"],
        factor: json["factor"],
        state: json["state"],
        billNoHash: json["bill_no_hash"],
        detail: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "bill_no": billNo,
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
        "uid": uid,
        "factor": factor,
        "state": state,
        "bill_no_hash": billNoHash,
        "detail": detail,
      };
}
