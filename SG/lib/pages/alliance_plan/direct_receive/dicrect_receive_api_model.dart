

///直属领取   /agency/report/receive
class DirectReceiveApiModel {
  // "uid": "48359506800075917", //会员ID
  // "username": "yuyu88", //会员账号
  // "currency_id": "701", //货币ID
  // "currency_name": "CNY", //货币名称
  // "gift_amount": "0.0000000", //优惠金额
  // "commission_amount": "202.0000000", //代理佣金
  // "total_receive": "202.00", //总领取
  // "vip": "1", //vip等级
  // "time": 0, //统计日期
  // "created_at": 0 //创建时间
  String? uid;
  String? username; //会员账号
  String? currencyId; //货币ID
  String? currencyName; //货币名称
  String? giftAmount; //优惠金额
  String? commissionAmount;//代理佣金
  String? totalReceive;  //总领取
  String? vip;
  int? time; //统计日期
  int? createdAt;

  DirectReceiveApiModel({
    this.uid,
    this.username,
    this.currencyId,
    this.currencyName,
    this.giftAmount,
    this.commissionAmount,
    this.totalReceive,
    this.vip,
    this.time,
    this.createdAt,
  });

  factory DirectReceiveApiModel.fromJson(Map<String, dynamic> json) => DirectReceiveApiModel(
    uid: json["uid"],
    username: json["username"],
    currencyId: json["currency_id"],
    currencyName: json["currency_name"],
    giftAmount: json["gift_amount"],
    commissionAmount: json["commission_amount"],
    totalReceive: json["total_receive"],
    vip: json["vip"],
    time: json["time"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "currency_id": currencyId,
    "currency_name": currencyName,
    "gift_amount": giftAmount,
    "commission_amount": commissionAmount,
    "total_receive": totalReceive,
    "vip": vip,
    "time": time,
    "created_at": createdAt,
  };
}
