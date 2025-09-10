
///佣金历史  /agency/commission/records
class CommissionHistoryApiModel {
  // "id": "52991425232034912",
  // "bill_no": "52991425218017473", //订单号
  // "uid": "7745422158131254", //uid
  // "username": "link999", //会员名
  // "cash_type": 847, //全部为空，帐变id，取帐变类型中的关于代理钱包的cash_type
  // "business_type": 823,
  // "amount": "100.00", //金额
  // "before_amount": "10382.59",
  // "after_amount": "10282.59",
  // "multiple": 1,
  // "created_at": 1701504494865,
  // "tester": 0,
  // "remark": "dfsa",
  // "currency_id": "701", //币种
  // "operator_uid": "127646934193462684",
  // "operator_name": "Link001",
  // "device": 24,
  // "apply_at": 1701504494865, //时间（毫秒）
  // "cash_type_name": "人工佣金减款", //类型
  // "business_type_name": "佣金"
  String? id;
  String? billNo;
  String? uid;
  String? username;
  int? cashType;
  int? businessType;
  String? amount;
  String? beforeAmount;
  String? afterAmount;
  String? multiple;
  int? createdAt;
  int? tester;
  String? remark;
  String? currencyId;
  String? operatorUid;
  String? operatorName;
  int? device;
  int? applyAt; ////时间（毫秒）
  String? cashTypeName;
  String? businessTypeName;

  CommissionHistoryApiModel({
    this.id,
    this.billNo,
    this.uid,
    this.username,
    this.cashType,
    this.businessType,
    this.amount,
    this.beforeAmount,
    this.afterAmount,
    this.multiple,
    this.createdAt,
    this.tester,
    this.remark,
    this.currencyId,
    this.operatorUid,
    this.operatorName,
    this.device,
    this.applyAt,
    this.cashTypeName,
    this.businessTypeName,
  });

  factory CommissionHistoryApiModel.fromJson(Map<String, dynamic> json) => CommissionHistoryApiModel(
    id: json["id"],
    billNo: json["bill_no"],
    uid: json["uid"],
    username: json["username"],
    cashType: json["cash_type"],
    businessType: json["business_type"],
    amount: json["amount"],
    beforeAmount: json["before_amount"],
    afterAmount: json["after_amount"],
    multiple: json["multiple"],
    createdAt: json["created_at"],
    tester: json["tester"],
    remark: json["remark"],
    currencyId: json["currency_id"],
    operatorUid: json["operator_uid"],
    operatorName: json["operator_name"],
    device: json["device"],
    applyAt: json["apply_at"],
    cashTypeName: json["cash_type_name"],
    businessTypeName: json["business_type_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bill_no": billNo,
    "uid": uid,
    "username": username,
    "cash_type": cashType,
    "business_type": businessType,
    "amount": amount,
    "before_amount": beforeAmount,
    "after_amount": afterAmount,
    "multiple": multiple,
    "created_at": createdAt,
    "tester": tester,
    "remark": remark,
    "currency_id": currencyId,
    "operator_uid": operatorUid,
    "operator_name": operatorName,
    "device": device,
    "apply_at": applyAt,
    "cash_type_name": cashTypeName,
    "business_type_name": businessTypeName,
  };
}

