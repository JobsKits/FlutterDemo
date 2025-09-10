
///竞赛排行榜  /member/competition/list
class BettingRaceApiModel {

  // "uid": "150469586126034360",
  // "username": "rumrum", //投注人
  // "currency_id": "706", //币种ID
  // "bet_amount": "90511.87397880000000", //投注金额
  // "net_amount": "370396.86372184200000", //支付金额
  // "state": "1" //1正常2隐藏
  String? uid;
  String? username;
  String? currencyId;
  String? betAmount;
  String? netAmount;
  String? state;
  String? percent;


  BettingRaceApiModel({
    this.uid,
    this.username,
    this.currencyId,
    this.betAmount,
    this.netAmount,
    this.state,
    this.percent,
  });

  ///是否隐藏
  bool isHideName(){
    return state!=null && state=="2";
  }

  factory BettingRaceApiModel.fromJson(Map<String, dynamic> json) => BettingRaceApiModel(
    uid: json["uid"],
    username: json["username"],
    currencyId: json["currency_id"],
    betAmount: json["bet_amount"],
    netAmount: json["net_amount"],
    state: json["state"],
    percent: json["percent"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "currency_id": currencyId,
    "bet_amount": betAmount,
    "net_amount": netAmount,
    "state": state,
    "percent": percent,
  };
}
