// {
// "email": "1132321@gmail.com",
// "wechat": "",
// "telegram": "",
// "facebook": "",
// "zalo": "",
// "line": "",
// "area_code": "",
// "phone": "",
// "viber": "",
// "whatsapp": "",
// "twitter": "",
// "sex": 1
// }

import 'dart:convert';

UpdateUserParamModel updateUserParamModelFromJson(String str) => UpdateUserParamModel.fromJson(json.decode(str));

String updateUserParamModelToJson(UpdateUserParamModel data) => json.encode(data.toJson());

class UpdateUserParamModel {
  String? email;
  String? wechat;
  String? telegram;
  String? facebook;
  String? zalo;
  String? line;
  String? areaCode;
  String? phone;
  String? viber;
  String? whatsapp;
  String? twitter;
  String? qq;
  int? sex;
  List<String>? d;

  UpdateUserParamModel({
    this.email,
    this.wechat,
    this.telegram,
    this.facebook,
    this.zalo,
    this.line,
    this.areaCode,
    this.phone,
    this.viber,
    this.whatsapp,
    this.twitter,
    this.sex,
    this.qq,
    this.d
  });

  factory UpdateUserParamModel.fromJson(Map<String, dynamic> json) => UpdateUserParamModel(
    email: json["email"],
    wechat: json["wechat"],
    telegram: json["telegram"],
    facebook: json["facebook"],
    zalo: json["zalo"],
    line: json["line"],
    areaCode: json["area_code"],
    phone: json["phone"],
    viber: json["viber"],
    whatsapp: json["whatsapp"],
    twitter: json["twitter"],
    sex: json["sex"],
    qq: json["qq"],
    d: json["d"]
  );
  UpdateUserParamModel copyWith({
    String? email,
    String? wechat,
    String? telegram,
    String? facebook,
    String? zalo,
    String? line,
    String? areaCode,
    String? phone,
    String? viber,
    String? whatsapp,
    String? twitter,
    int? sex,
    String? qq,
    List<String>? d,
  }) =>
      UpdateUserParamModel(
        email: email ?? this.email,
        wechat: wechat ?? this.wechat,
        telegram: telegram ?? this.telegram,
        facebook: facebook ?? this.facebook,
        zalo: zalo ?? this.zalo,
        line: line ?? this.line,
        areaCode: areaCode ?? this.areaCode,
        phone: phone ?? this.phone,
        viber: viber ?? this.viber,
        whatsapp: whatsapp ?? this.whatsapp,
        twitter: twitter ?? this.twitter,
        sex: sex ?? this.sex,
        qq: qq ?? this.qq,
        d: d ?? this.d,
      );

  Map<String, dynamic> toJson() => {
    "email": email,
    "wechat": wechat,
    "telegram": telegram,
    "facebook": facebook,
    "zalo": zalo,
    "line": line,
    "area_code": areaCode,
    "phone": phone,
    "viber": viber,
    "whatsapp": whatsapp,
    "twitter": twitter,
    "sex": sex,
    "qq": qq,
    "d": d,
  };
}
