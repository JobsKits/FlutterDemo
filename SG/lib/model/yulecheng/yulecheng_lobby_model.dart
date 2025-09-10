// To parse this JSON data, do
//
//     final yulechengLobbyModel = yulechengLobbyModelFromJson(jsonString);

import 'dart:convert';
import 'dart:math';

import 'package:flutter_bet/model/yulecheng/gamelist_model.dart';
import 'package:flutter_bet/model/yulecheng/index.dart';

YulechengLobbyModel yulechengLobbyModelFromJson(String str) =>
    YulechengLobbyModel.fromJson(json.decode(str));

class YulechengLobbyModel {
  String? id;
  String? name;
  String? icon;
  List<Nav>? navs;
  List<Litem>? items;
  List<Nav>? sidebars; //1220.接口变更，添加该字段。主要用来显示侧边菜单

  YulechengLobbyModel({
    this.id,
    this.name,
    this.icon,
    this.navs,
    this.items,
    this.sidebars,
  });

  factory YulechengLobbyModel.fromJson(Map<String, dynamic> json) => YulechengLobbyModel(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        navs: json["navs"] == null ? [] : List<Nav>.from(json["navs"].map((x) => Nav.fromJson(x))),
        items: json["litems"] == null
            ? []
            : List<Litem>.from(json["litems"].map((x) => Litem.fromJson(x))),
        sidebars: json["sidebars"] == null
            ? []
            : List<Nav>.from(json["sidebars"]!.map((x) => Nav.fromJson(x))),
      );

}

class Item {
  int ty;
  String cid;
  String platformId;
  String name;
  String icon;
  int total;
  List<GameLobbyModel>? games;
  List<List<GameListModel>>? navGames;

  Item({
    required this.ty,
    required this.cid,
    required this.platformId,
    required this.name,
    required this.icon,
    required this.total,
    required this.games,
    required this.navGames,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        ty: json["ty"],
        cid: json["cid"],
        platformId: json["platform_id"],
        name: json["name"],
        icon: json["icon"],
        total: json["total"],
        games: json["games"] == null
            ? []
            : List<GameLobbyModel>.from(json["games"]!.map((x) => GameLobbyModel.fromJson(x))),
        navGames: json["nav_games"] == null
            ? []
            : List<List<GameListModel>>.from(json["nav_games"]!
                .map((x) => List<GameListModel>.from(x.map((x) => GameListModel.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "ty": ty,
        "cid": cid,
        "platform_id": platformId,
        "name": name,
        "icon": icon,
        "total": total,
        "nav_games": navGames == null
            ? []
            : List<dynamic>.from(
                navGames!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "games": games == null ? [] : List<dynamic>.from(games!.map((x) => x.toJson())),
      };
}

class GameLobbyModel {
  String platformId;
  String id;
  String gameId;
  String img;
  String name;
  String? gameType;
  String? maintained;
  String? playerAmount;

  GameLobbyModel({
    required this.platformId,
    required this.id,
    required this.gameId,
    required this.img,
    required this.name,
    this.gameType,
    this.maintained,
    this.playerAmount,
  });

  factory GameLobbyModel.fromJson(Map<String, dynamic> json) => GameLobbyModel(
      platformId: json["platform_id"],
      id: json["id"],
      gameId: json["game_id"],
      img: json["img"],
      name: json["name"],
      gameType: json["game_type"],
      maintained: json["maintained"],
      playerAmount: getStringUnitAt(json["name"]));

  Map<String, dynamic> toJson() => {
        "platform_id": platformId,
        "id": id,
        "game_id": gameId,
        "img": img,
        "name": name,
        "maintained": maintained,
      };
}

String getStringUnitAt(String? name) {
  if (name?.isEmpty == true) {
    return Random().nextInt(1000).toString();
  } else {
    int unitAtCode = 0;
    for (int i = 0; i < name!.length; i++) {
      unitAtCode += name.codeUnitAt(i);
    }
    return '${unitAtCode % 1000 + Random().nextInt(10)}';
  }
}

class Nav {
  int ty;
  String cid;
  String platformId;
  String name;
  String? icon;

  Nav({
    required this.ty,
    required this.cid,
    required this.platformId,
    required this.name,
    required this.icon,
  });

  factory Nav.fromJson(Map<String, dynamic> json) => Nav(
        ty: json["ty"],
        cid: json["cid"],
        platformId: json["platform_id"],
        name: json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "ty": ty,
        "cid": cid,
        "platform_id": platformId,
        "name": name,
        "icon": icon,
      };
}
