import 'dart:convert';

import 'package:flutter_bet/utils/common_util.dart';

LoginLogModel loginLogModelFromJson(String str) => LoginLogModel.fromJson(json.decode(str));

String loginLogModelToJson(LoginLogModel data) => json.encode(data.toJson());

class LoginLogModel {
  String? id;
  String? browser;
  String? loginip;
  String? ipaddress;
  int? createdAt;

  LoginLogModel({
    this.id,
    this.browser,
    this.loginip,
    this.ipaddress,
    this.createdAt,
  });

  factory LoginLogModel.fromJson(Map<String, dynamic> json) => LoginLogModel(
    id: json["id"],
    browser: json["browser"],
    loginip: json["loginip"],
    ipaddress: json["ipaddress"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "browser": browser,
    "loginip": loginip,
    "ipaddress": ipaddress,
    "created_at": createdAt,
  };

  String? get getIpAddress {
    return ipaddress?.isEmpty == true ? '--' : ipaddress;
  }

  String? get getRecentTime {
    return createdAt == null ? '--' : CommonUtil.getRecentTime(createdAt!);
  }
}
