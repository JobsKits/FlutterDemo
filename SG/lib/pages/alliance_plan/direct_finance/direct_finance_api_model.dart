


///直属财务 /agency/report/finance
class DirectFinanceApiModel {
  // "uid": "48359506800075917", //会员ID
  // "username": "yuyu88", //会员账号
  // "currency_id": "701", //货币ID
  // "currency_name": "CNY", //货币名称
  // "deposit_amount": "1.0000000", //存款金额
  // "deposit_count": 1, //存款次数
  // "withdraw_amount": "1.0000000", //取款金额
  // "withdraw_count": 1, //取款次数
  // "deposit_withdraw_amount": "0", //存取差额
  // "balance": "0.00", //账户余额
  // "vip": "1", //vip等级
  // "time": 0, //统计日期
  // "created_at": 0 //创建时间

  String? uid;
  String? username;
  String? currencyId;
  String? currencyName;
  String? depositAmount;
  int? depositCount;
  String? withdrawAmount;
  int? withdrawCount;
  String? depositWithdrawAmount;
  String? balance;
  String? vip;
  int? time;
  int? createdAt;

  DirectFinanceApiModel({
    this.uid,
    this.username,
    this.currencyId,
    this.currencyName,
    this.depositAmount,
    this.depositCount,
    this.withdrawAmount,
    this.withdrawCount,
    this.depositWithdrawAmount,
    this.balance,
    this.vip,
    this.time,
    this.createdAt,
  });

  factory DirectFinanceApiModel.fromJson(Map<String, dynamic> json) => DirectFinanceApiModel(
    uid: json["uid"],
    username: json["username"],
    currencyId: json["currency_id"],
    currencyName: json["currency_name"],
    depositAmount: json["deposit_amount"],
    depositCount: json["deposit_count"],
    withdrawAmount: json["withdraw_amount"],
    withdrawCount: json["withdraw_count"],
    depositWithdrawAmount: json["deposit_withdraw_amount"],
    balance: json["balance"],
    vip: json["vip"],
    time: json["time"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "currency_id": currencyId,
    "currency_name": currencyName,
    "deposit_amount": depositAmount,
    "deposit_count": depositCount,
    "withdraw_amount": withdrawAmount,
    "withdraw_count": withdrawCount,
    "deposit_withdraw_amount": depositWithdrawAmount,
    "balance": balance,
    "vip": vip,
    "time": time,
    "created_at": createdAt,
  };
}
