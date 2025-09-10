// To parse this JSON data, do
//
//     final gameListModel = gameListModelFromJson(jsonString);

import 'dart:convert';
import 'dart:math';

import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/model/yulecheng/yulecheng_lobby_model.dart';
import 'package:flutter_bet/utils/lang_util.dart';

GameListModel gameListModelFromJson(String str) => GameListModel.fromJson(json.decode(str));

String gameListModelToJson(GameListModel data) => json.encode(data.toJson());

class GameListModel {
  String id;
  String platformId;
  String name;
  String gameType;
  String? zkOnline;
  String? online;
  String gameId;
  String img;
  int sorting;
  int createdAt;
  String? rtp;
  String? percent;
  String? updatedAt;
  String? platformName;
  int isHot;
  int isNew;
  int isFav;
  String? maintained;
  List<String>? currencys;
  late String _gameImgUrl;
  String? playerAmount;

  GameListModel({
    required this.id,
    required this.platformId,
    required this.name,
    required this.gameType,
    this.zkOnline,
    this.online,
    required this.gameId,
    required this.img,
    required this.sorting,
    required this.createdAt,
    this.rtp,
    this.percent,
    this.updatedAt,
    required this.isHot,
    required this.isNew,
    required this.isFav,
    this.maintained,
    this.currencys,
    this.platformName,
    this.playerAmount,
  });

  factory GameListModel.fromJson(Map<String, dynamic> json) => GameListModel(
        id: json["id"],
        platformId: json["platform_id"],
        name: json["name"],
        gameType: json["game_type"],
        zkOnline: json["zk_online"],
        online: json["online"],
        gameId: json["game_id"],
        img: json["img"],
        sorting: json["sorting"],
        createdAt: json["created_at"],
        rtp: json["rtp"],
        percent: json["percent"],
        updatedAt: json["updated_at"],
        isHot: json["is_hot"],
        isNew: json["is_new"],
        isFav: json["is_fav"],
        platformName: json["platform_name"],
        currencys:
            json["currencys"] == null ? [] : List<String>.from(json["currencys"].map((x) => x)),
        maintained: json["maintained"],
        playerAmount: getStringUnitAt(json["name"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "platform_id": platformId,
        "name": name,
        "game_type": gameType,
        "zk_online": zkOnline,
        "online": online,
        "game_id": gameId,
        "img": img,
        "sorting": sorting,
        "created_at": createdAt,
        "rtp": rtp,
        "percent": percent,
        "updated_at": updatedAt,
        "is_hot": isHot,
        "is_new": isNew,
        "is_fav": isFav,
        "currencys": List<dynamic>.from(currencys!.map((x) => x)),
        "platform_name": platformName,
        "maintained": maintained,
      };
  String get gameImgUrl {
    return img.replaceAll(
        "%lang%/",
        gameType == "8"
            ? "${LangUtil().getLangType()}/${AppValues.defaultBranch.ws_prefix}_"
            : "${LangUtil().getLangType()}/");
  }
}
