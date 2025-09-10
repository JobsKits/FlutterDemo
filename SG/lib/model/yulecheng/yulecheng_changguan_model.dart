// To parse this JSON data, do
//
//     final yuLeChengChangGuanModel = yuLeChengChangGuanModelFromJson(jsonString);

import 'dart:convert';

YuLeChengChangGuanApiModel yuLeChengChangGuanApiModelFromJson(String str) => YuLeChengChangGuanApiModel.fromJson(json.decode(str));

class YuLeChengChangGuanApiModel {
  String id;
  String name;
  String icon;
  List<YuLeChengChangGuanModel> games;

  YuLeChengChangGuanApiModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.games,
  });

  factory YuLeChengChangGuanApiModel.fromJson(Map<String, dynamic> json) => YuLeChengChangGuanApiModel(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    games: List<YuLeChengChangGuanModel>.from(json["games"].map((x) => YuLeChengChangGuanModel.fromJson(x))),
  );

}

class YuLeChengChangGuanModel {
  String id;
  String name;
  String icon;

  String maintained;

  YuLeChengChangGuanModel({
    required this.id,
    required this.name,
    required this.icon,
    this.maintained = "",
  });

  factory YuLeChengChangGuanModel.fromJson(Map<String, dynamic> json) => YuLeChengChangGuanModel(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
  };

  //
  // //TODO: 维护预留
  // String get maintained {
  //   return "";
  // }

  //TODO: 国际化名称title预留
  String get cTitle {
    return name;
  }

  //TODO: 预留 平台总游戏数量
  int get gameNum {
    return 0;
  }

}
