// To parse this JSON data, do
//
//     final yuLeChengHotRecomentModel = yuLeChengHotRecomentModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_bet/model/yulecheng/gamelist_model.dart';

YuLeChengHotRecomentModel yuLeChengHotRecomentModelFromJson(String str) =>
    YuLeChengHotRecomentModel.fromJson(json.decode(str));

String yuLeChengHotRecomentModelToJson(YuLeChengHotRecomentModel data) =>
    json.encode(data.toJson());

class YuLeChengHotRecomentModel {
  int ty;
  String cid;
  String platformId;
  String name;
  String icon;
  String background;
  int total;
  List<GameListModel> games;

  YuLeChengHotRecomentModel({
    required this.ty,
    required this.cid,
    required this.platformId,
    required this.name,
    required this.icon,
    required this.background,
    required this.total,
    required this.games,
  });

  factory YuLeChengHotRecomentModel.fromJson(Map<String, dynamic> json) =>
      YuLeChengHotRecomentModel(
        ty: json["ty"],
        cid: json["cid"],
        platformId: json["platform_id"],
        name: json["name"],
        icon: json["icon"],
        background: json["background"],
        total: json["total"],
        games: List<GameListModel>.from(json["games"].map((x) => GameListModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ty": ty,
        "cid": cid,
        "platform_id": platformId,
        "name": name,
        "icon": icon,
        "background": background,
        "total": total,
        "games": List<dynamic>.from(games.map((x) => x.toJson())),
      };
}
