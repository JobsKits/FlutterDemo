// To parse this JSON data, do
//
//     final sportBetInfoModel = sportBetInfoModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_bet/pages/sport/sport_detail/model.dart';

SportBetInfoModel sportBetInfoModelFromJson(String str) => SportBetInfoModel.fromJson(json.decode(str));

String sportBetInfoModelToJson(SportBetInfoModel data) => json.encode(data.toJson());

class SportBetInfoModel {
  /// 0:单向投注 1:复式投注
  int ic;//"ic": 1, //0:非串关 1:串关
  List<M> bi; //投注单
  String cur;

  SportBetInfoModel({
    required this.ic,
    required this.bi,
    required this.cur,
  });

  factory SportBetInfoModel.fromJson(Map<String, dynamic> json) => SportBetInfoModel(
    ic: json["ic"],
    bi: List<M>.from(json["bi"].map((x) => M.fromJson(x))),
    cur: json["cur"],
  );

  Map<String, dynamic> toJson() => {
    "ic": ic,
    "bi": List<dynamic>.from(bi.map((x) => x.toJson())),
    "cur": cur,
  };
}
