// To parse this JSON data, do
//
//     final yulechengLobbyCateModel = yulechengLobbyCateModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_bet/model/yulecheng/index.dart';
import 'package:flutter_bet/model/yulecheng/yulecheng_lobby_model.dart';

YulechengLobbyCateModel yulechengLobbyCateModelFromJson(String str) =>
    YulechengLobbyCateModel.fromJson(json.decode(str));

class YulechengLobbyCateModel {
  String id;
  String name;
  String icon;
  int total;
  List<Sum>? sums;
  List<GameLobbyModel>? games;
  List<Litem> litems;

  YulechengLobbyCateModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.total,
    required this.games,
    required this.litems,
    required this.sums,
  });

  factory YulechengLobbyCateModel.fromJson(Map<String, dynamic> json) => YulechengLobbyCateModel(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        total: json["total"],
        litems: json["litems"] == null
            ? []
            : List<Litem>.from(json["litems"].map((x) => Litem.fromJson(x))),
        games: json["games"] == null
            ? []
            : List<GameLobbyModel>.from(json["games"].map((x) => GameLobbyModel.fromJson(x))),
        sums: json["sums"] == null ? [] : List<Sum>.from(json["sums"].map((x) => Sum.fromJson(x))),
      );
}

class Litem {
  int ty;
  String cid;
  String platformId;
  String name;
  String icon;
  String background;
  int total;
  List<List<GameListModel>> navGames;
  List<GameListModel>? games;

  Litem({
    required this.ty,
    required this.cid,
    required this.platformId,
    required this.name,
    required this.icon,
    required this.background,
    required this.total,
    required this.navGames,
    this.games,
  });

  factory Litem.fromJson(Map<String, dynamic> json) => Litem(
        ty: json["ty"],
        cid: json["cid"],
        platformId: json["platform_id"],
        name: json["name"],
        icon: json["icon"],
        background: json["background"],
        total: json["total"],
        navGames: json["nav_games"] == null
            ? []
            : List<List<GameListModel>>.from(json["nav_games"]
                .map((x) => List<GameListModel>.from(x.map((x) => GameListModel.fromJson(x))))),
      games: json["games"] == null ? [] : List<GameListModel>.from(json["games"]!.map((x) => GameListModel.fromJson(x))),
      );

}

class Sum {
  String platformId;
  String platformName;
  String venueId;
  int total;
  bool selected;

  Sum({
    required this.platformId,
    required this.platformName,
    required this.venueId,
    required this.total,
    this.selected = false,
  });

  factory Sum.fromJson(Map<String, dynamic> json) => Sum(
        platformId: json["platform_id"],
        platformName: json["platform_name"],
        venueId: json["venue_id"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "platform_id": platformId,
        "platform_name": platformName,
        "venue_id": venueId,
        "total": total,
      };
}
