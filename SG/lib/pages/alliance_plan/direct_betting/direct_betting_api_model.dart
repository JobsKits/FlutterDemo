
///直属投注  /agency/report/bet
class DirectBettingApiModel {
  // "uid": "48359506800075917", //会员ID
  // "username": "yuyu88", //会员账号
  // "currency_id": "701", //货币ID
  // "currency_name": "CNY", //货币名称
  // "bet_count": 0, //注单数量
  // "valid_bet_amount": "0.0000000", //有效投注
  // "net_amount": "0.0000000", //总输赢
  // "vip": "1", //vip等级
  // "time": 0, //统计日期
  // "created_at": 0 //创建时间

  String? uid;
  String? username;
  String? currencyId;
  String? currencyName;
  int? betCount;
  String? validBetAmount;
  String? netAmount;
  String? vip;
  int? time;
  int? createdAt;

  DirectBettingApiModel({
    this.uid,
    this.username,
    this.currencyId,
    this.currencyName,
    this.betCount,
    this.validBetAmount,
    this.netAmount,
    this.vip,
    this.time,
    this.createdAt,
  });

  factory DirectBettingApiModel.fromJson(Map<String, dynamic> json) => DirectBettingApiModel(
    uid: json["uid"],
    username: json["username"],
    currencyId: json["currency_id"],
    currencyName: json["currency_name"],
    betCount: json["bet_count"],
    validBetAmount: json["valid_bet_amount"],
    netAmount: json["net_amount"],
    vip: json["vip"],
    time: json["time"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "currency_id": currencyId,
    "currency_name": currencyName,
    "bet_count": betCount,
    "valid_bet_amount": validBetAmount,
    "net_amount": netAmount,
    "vip": vip,
    "time": time,
    "created_at": createdAt,
  };
}
