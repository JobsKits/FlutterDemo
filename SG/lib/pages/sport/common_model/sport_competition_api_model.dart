// To parse this JSON data, do
import 'package:lpinyin/lpinyin.dart';

import 'sport_game_model.dart';

///联赛列表
///接口：competition/list
///参数："si": 1, //球种Id  "kind": "normal" //种类 normal:一般赛事 outright:冠军赛
class SportCompetitionApiModel {
  List<SportGameModel> hot; // 热门

  List<SportGameModel> list; //全部

  SportCompetitionApiModel({
    required this.hot,
    required this.list,
  });

  ///对名字 进行排序处理
  void sortAb(){
    hot.sort((a, b) => PinyinHelper.getShortPinyin(a.pgn!).compareTo(PinyinHelper.getShortPinyin(b.pgn!)),);
    list.sort((a, b) => PinyinHelper.getShortPinyin(a.pgn!).compareTo(PinyinHelper.getShortPinyin(b.pgn!)),);
  }

  factory SportCompetitionApiModel.fromJson(Map<String, dynamic> json) => SportCompetitionApiModel(
        hot: json["hot"] == null
            ? []
            : List<SportGameModel>.from(json["hot"]!.map((x) => SportGameModel.fromJson(x))),
        list: json["list"] == null
            ? []
            : List<SportGameModel>.from(json["list"]!.map((x) => SportGameModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "hot": hot == null ? [] : List<dynamic>.from(hot.map((x) => x.toJson())),
        "list": list == null ? [] : List<dynamic>.from(list.map((x) => x.toJson())),
      };
}
