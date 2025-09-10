// To parse this JSON data, do
//
//     final betListModel = betListModelFromJson(jsonString);

import 'dart:convert';

import '../../pages/sport/sport_detail/model.dart';

BetListModel betListModelFromJson(String str) => BetListModel.fromJson(json.decode(str));

String betListModelToJson(BetListModel data) => json.encode(data.toJson());

///place/bet 投注接口
///betlist 索取投注明细
class BetListModel {
  List<ListElement> list;

  BetListModel({
    required this.list,
  });

  factory BetListModel.fromJson(Map<String, dynamic> json) => BetListModel(
        list: json["list"] == null
            ? []
            : List<ListElement>.from(json["list"]!.map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

//   2.  bi增加回传：
//     a.  reb 1:支持重新投注 0:不支持重新投注
//     b.  wid, mlid, mll, ic 用于购物车
class ListElement {
  int? a;
  String? ov;
  double? mwa;
  int? bt;
  String? ono;
  int? os;
  int? oc; //输赢结算状态
  num? pa;
  int? st;
  List<Bi> bi;

  ///非接口字段，业务需求添加，未结算的订单可以复投，需要的model，
  /// List<M>? ms; //赔率， 2格子 或者 3格子
  List<M> ms;

  ListElement({
    this.a,
    this.ov,
    this.mwa,
    this.bt,
    this.ono,
    this.os,
    this.oc,
    this.pa,
    this.st,
    required this.bi,
    required this.ms,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        a: json["a"],
        ov: json["ov"],
        mwa: json["mwa"]?.toDouble(),
        bt: json["bt"],
        ono: json["ono"],
        os: json["os"],
        oc: json["oc"],
        pa: json["pa"],
        st: json["st"],
        bi: json["bi"] == null ? [] : List<Bi>.from(json["bi"]!.map((x) => Bi.fromJson(x))),
        //对数据额外处理，添加ms, 方便后面未计算 进行复投
        ms: json["bi"] == null ? [] : List<M>.from(json["bi"]!.map((x) => M.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "a": a,
        "ov": ov,
        "mwa": mwa,
        "bt": bt,
        "ono": ono,
        "os": os,
        "oc": oc,
        "pa": pa,
        "st": st,
        "bi": bi == null ? [] : List<dynamic>.from(bi.map((x) => x.toJson())),
        "ms": ms == null ? [] : List<dynamic>.from(ms.map((x) => x.toJson())),
      };
}

//   2.  bi增加回传：
//     a.  reb 1:支持重新投注 0:不支持重新投注
//     b.  wid, mlid, mll, ic 用于购物车
class Bi {
  int? bt;
  String? btn;
  int? si;
  String? ei;
  String? ov;
  String? sn;
  String? re;
  String? hdp;
  String? htn;
  String? atn;
  String? htpic;
  String? atpic;
  int? ed;

  ///et = 1 显示主客队名称 (维持现状)
  // et = 2 显示联赛名称
  int? et; // "et": 2, //1:一般赛事 2:冠军赛
  ///"cn": "英格兰冠军联赛",
  String? cn;

  ///是否支持重投 1:支持 0:不支持
  int? reb;
  String? wid;
  String? mlid;
  int? mll;

  ///是否取得串关数量 0:全部 1:只限串关
  int? ic;

  ///1228需求变更：现在投注纪录接口，部分赛事有返回赛果比分资料，pol字段规则跟单场赛事详情相同
  ///添加字段 "pol": {"3": "0","4": "0","9": "0","10": "0" }
  ///字段使用说明查看[sport_biz_remark]文件
  Map<String, String>? pol;
  List? ml;
  String? pgn;

  // "hp": 0, //主队比分
  // "ap": 0, //客队比分
  int? hp;
  int? ap;

  Bi({
    this.btn,
    this.bt,
    this.si,
    this.ei,
    this.ov,
    this.sn,
    this.re,
    this.hdp,
    this.htn,
    this.atn,
    this.ed,
    this.htpic,
    this.atpic,
    this.et,
    this.cn,
    this.reb,
    this.wid,
    this.mlid,
    this.mll,
    this.ic,
    this.pol,
    this.hp,
    this.ap,
    this.ml,
    this.pgn,
  });

  factory Bi.fromJson(Map<String, dynamic> json) => Bi(
        btn: json["btn"] ?? json['ml'][0]['btn'],
        bt: json["bt"],
        si: json["si"],
        ei: json["ei"],
        ov: json["ov"],
        sn: json["sn"],
        re: json["re"],
        hdp: json["hdp"],
        htn: json["htn"],
        atn: json["atn"],
        ed: json["ed"],
        atpic: json["atpic"],
        htpic: json["htpic"],
        et: json["et"],
        cn: json["cn"],
        reb: json["reb"],
        wid: json["wid"],
        mlid: json["mlid"],
        mll: json["mll"],
        ic: json["ic"],
        pol: json["pol"] == null
            ? {}
            : Map.from(json["pol"]!).map((k, v) => MapEntry<String, String>(k, v)),
        hp: json["hp"],
        ap: json["ap"],
        ml: json['ml'],
        pgn: json['pgn'],
      );

  Map<String, dynamic> toJson() => {
        "btn": btn,
        "bt": bt,
        "si": si,
        "ei": ei,
        "ov": ov,
        "sn": sn,
        "re": re,
        "hdp": hdp,
        "htn": htn,
        "atn": atn,
        "ed": ed,
        "htpic": htpic,
        "atpic": atpic,
        "et": et,
        "cn": cn,
        "reb": reb,
        "wid": wid,
        "mlid": mlid,
        "mll": mll,
        "ic": ic,
        "pol": pol == null ? {} : Map.from(pol!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "hp": hp,
        "ap": ap,
      };
}

enum Re { THE_00 }

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
