// To parse this JSON data, do
//
//     final sportBetModel = sportBetModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_bet/pages/sport/sport_detail/model.dart';

SportBetModel sportBetModelFromJson(String str) => SportBetModel.fromJson(json.decode(str));

String sportBetModelToJson(SportBetModel data) => json.encode(data.toJson());

class SportBetModel {
  int ao;//"ao": 2, //0:不接受任何赔率变化 1:接受更高赔率 2:接受任何赔率
  List<Bl> bl;
  String cur;

  SportBetModel({
    required this.ao,
    required this.bl,
    required this.cur,
  });

  factory SportBetModel.fromJson(Map<String, dynamic> json) => SportBetModel(
    ao: json["ao"],
    bl: List<Bl>.from(json["bl"].map((x) => Bl.fromJson(x))),
    cur: json["cur"],
  );

  Map<String, dynamic> toJson() => {
    "ao": ao,
    "bl": List<dynamic>.from(bl.map((x) => x.toJson())),
    "cur": cur,
  };
}

class Bl {
  ///串关类型,// 由place/betinfo 取得
  int pt;
  num a; //投注金额
  List<M> bi;

  Bl({
    required this.pt,
    required this.a,
    required this.bi,
  });

  factory Bl.fromJson(Map<String, dynamic> json) => Bl(
    pt: json["pt"],
    a: json["a"],
    bi: List<M>.from(json["bi"].map((x) => M.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pt": pt,
    "a": a,
    "bi": List<dynamic>.from(bi.map((x) => x.toJson())),
  };
}

