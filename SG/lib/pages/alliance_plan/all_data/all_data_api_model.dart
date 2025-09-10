

///所有数据 model
///agency/report/all

class AllDataApiModel {
  // "uid": "48359506800075917", //会员ID
  // "username": "yuyu88", //会员账号
  // "currency_id": "701", //货币ID
  // "currency_name": "CNY", //货币名称
  // "deposit_amount": "1.0000000", //存款金额
  // "valid_bet_amount": "0.0000000", //有效投注
  // "net_amount": "0.0000000", //输赢
  // "vip": "1", //vip等级
  // "time": 0 //加入时间
  // "created_at": 0 //创建时间
  String? uid;
  String? username;
  String? currencyId;
  String? currencyName;
  String? depositAmount;
  String? validBetAmount;
  String? netAmount;
  String? vip;
  // int? time;
  int? createdAt;
  bool isTotalItem; //自定义字段， 总共条目
  String? totalAmount;

  AllDataApiModel({
    this.uid,
    this.username,
    this.currencyId,
    this.currencyName,
    this.depositAmount,
    this.validBetAmount,
    this.netAmount,
    this.vip,
    // this.time,
    this.createdAt,
    this.isTotalItem = false,
    this.totalAmount,
  });

  factory AllDataApiModel.fromJson(Map<String, dynamic> json) => AllDataApiModel(
    uid: json["uid"],
    username: json["username"],
    currencyId: json["currency_id"],
    currencyName: json["currency_name"],
    depositAmount: json["deposit_amount"],
    validBetAmount: json["valid_bet_amount"],
    netAmount: json["net_amount"],
    vip: json["vip"],
    // time: json["time"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "currency_id": currencyId,
    "currency_name": currencyName,
    "deposit_amount": depositAmount,
    "valid_bet_amount": validBetAmount,
    "net_amount": netAmount,
    "vip": vip,
    // "time": time,
    "created_at": createdAt,
  };
}
