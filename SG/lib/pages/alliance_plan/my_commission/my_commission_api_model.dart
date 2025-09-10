

/// 联盟计划 - 我的佣金  model
/// /agency/commission
class MyCommissionApiModel{

  // "id": "1701907200_1701993599_1_702_60457634855166056",
  // "uid": "7745422158131254", //uid
  // "username": "link999", //会员名
  // "parent_uid": "0", //上级uid
  // "parent_name": "", //上级代理
  // "start_time": 1701907200, //开始时间
  // "end_time": 1701993599, //结束时间
  // "commission_level": 5, //佣金等级
  // "sub_user_count": 2, //总人数(贡献人数)
  // "direct_user_count": 2, //直属人数
  // "other_user_count": 0, //其它人数
  // "commission_amount_total": "1.14", //总佣金
  // "commission_amount_direct": "1.14", //直属佣金
  // "commission_amount_other": "0.00", //其它佣金
  // "valid_bet_amount_total": "114.08", //总业绩
  // "valid_bet_amount_direct": "114.08", //直属业绩
  // "valid_bet_amount_other": "0.00", //其它业绩
  // "currency_id": "702", //币种
  // "model_id": "60457634855166056", //模式id
  // "model_name": "", //模式名称(类型名称)
  // "created_at": 1702025565,
  // "send_time": 1702032863 //结算时间
  String id;
  String uid;
  String username;
  String parentUid;
  String parentName;
  int startTime;
  int endTime;
  int commissionLevel;
  int subUserCount;
  int directUserCount;
  int otherUserCount;
  String commissionAmountTotal;
  String commissionAmountDirect;
  String commissionAmountOther;
  String validBetAmountTotal;
  String validBetAmountDirect;
  String validBetAmountOther;
  String currencyId;
  String modelId;
  String modelName;
  int createdAt;
  int sendTime;

  MyCommissionApiModel({
    required this.id,
    required this.uid,
    required this.username,
    required this.parentUid,
    required this.parentName,
    required this.startTime,
    required this.endTime,
    required this.commissionLevel,
    required this.subUserCount,
    required this.directUserCount,
    required this.otherUserCount,
    required this.commissionAmountTotal,
    required this.commissionAmountDirect,
    required this.commissionAmountOther,
    required this.validBetAmountTotal,
    required this.validBetAmountDirect,
    required this.validBetAmountOther,
    required this.currencyId,
    required this.modelId,
    required this.modelName,
    required this.createdAt,
    required this.sendTime,
  });

  factory MyCommissionApiModel.fromJson(Map<String, dynamic> json) => MyCommissionApiModel(
    id: json["id"],
    uid: json["uid"],
    username: json["username"],
    parentUid: json["parent_uid"],
    parentName: json["parent_name"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    commissionLevel: json["commission_level"],
    subUserCount: json["sub_user_count"],
    directUserCount: json["direct_user_count"],
    otherUserCount: json["other_user_count"],
    commissionAmountTotal: json["commission_amount_total"],
    commissionAmountDirect: json["commission_amount_direct"],
    commissionAmountOther: json["commission_amount_other"],
    validBetAmountTotal: json["valid_bet_amount_total"],
    validBetAmountDirect: json["valid_bet_amount_direct"],
    validBetAmountOther: json["valid_bet_amount_other"],
    currencyId: json["currency_id"],
    modelId: json["model_id"],
    modelName: json["model_name"],
    createdAt: json["created_at"],
    sendTime: json["send_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "username": username,
    "parent_uid": parentUid,
    "parent_name": parentName,
    "start_time": startTime,
    "end_time": endTime,
    "commission_level": commissionLevel,
    "sub_user_count": subUserCount,
    "direct_user_count": directUserCount,
    "other_user_count": otherUserCount,
    "commission_amount_total": commissionAmountTotal,
    "commission_amount_direct": commissionAmountDirect,
    "commission_amount_other": commissionAmountOther,
    "valid_bet_amount_total": validBetAmountTotal,
    "valid_bet_amount_direct": validBetAmountDirect,
    "valid_bet_amount_other": validBetAmountOther,
    "currency_id": currencyId,
    "model_id": modelId,
    "model_name": modelName,
    "created_at": createdAt,
    "send_time": sendTime,
  };
}


