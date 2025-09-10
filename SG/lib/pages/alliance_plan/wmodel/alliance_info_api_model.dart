
///个人信息 /agency/info
class AllianceInfoApiModel {
  // "level": 5, //佣金等级
  // "balance": "1447.75", //佣金余额
  // "uid": "7745422158131254",
  // "username": "link999", //会员名
  // "parent_name": "sg" //上级代理
  int? level;
  String? balance;
  String? uid;
  String? username;
  String? parentName;

  AllianceInfoApiModel({
    this.level,
    this.balance,
    this.uid,
    this.username,
    this.parentName,
  });

  factory AllianceInfoApiModel.fromJson(Map<String, dynamic> json) => AllianceInfoApiModel(
    level: json["level"],
    balance: json["balance"],
    uid: json["uid"],
    username: json["username"],
    parentName: json["parent_name"],
  );

  Map<String, dynamic> toJson() => {
    "level": level,
    "balance": balance,
    "uid": uid,
    "username": username,
    "parent_name": parentName,
  };
}
