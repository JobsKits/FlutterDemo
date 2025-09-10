// To parse this JSON data, do
//
//     final sportDetailModel = sportDetailModelFromJson(jsonString);

import 'package:flutter_bet/generated/l10n.dart';
import 'dart:convert';

SportDetailModel sportDetailModelFromJson(String str) =>
    SportDetailModel.fromJson(json.decode(str));

String sportDetailModelToJson(SportDetailModel data) => json.encode(data.toJson());

class SportDetailModel {
  int? delta;
  int? status;
  List<SportMatchModel>? list; //列表数据；
  int? t; //总页数；

  SportDetailModel({
    this.delta,
    this.status,
    this.list,
    this.t = 1,
  });

  factory SportDetailModel.fromJson(Map<String, dynamic> json) => SportDetailModel(
        delta: json["delta"],
        status: json["status"],
        list: json["list"] == null
            ? []
            : List<SportMatchModel>.from(json["list"]!.map((x) => SportMatchModel.fromJson(x))),
        t: json["t"],
      );

  Map<String, dynamic> toJson() => {
        "delta": delta,
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
        "t": t,
      };
}

///某个联赛的model
class SportMatchModel {
  bool? isFav;
  String? ei;
  int? si;
  String? sn;

  String? oen; //欧洲冠军联赛2023/12/13 - 最多進球的球隊

  ///"m": 2, //market 1:早盘 2:今日 3:滚球
  int? m;
  String? ci;
  String? cn;
  String? hti;
  String? htn;
  String? ati;
  String? atn;
  String? rbt;
  String? rbtd;
  String? rbtt;
  int? ts;

  ///"rbts": 0, //RBTimeStatus 0:未开赛 1:开始 2:进行中 3:暂停
  int? rbts;

  ///赛事列表页面赛事投注玩法数量取值，我们移动端也取这个MC哈，如果有提单反馈这个MC数量不准，把单子转后端确认即可
  int? mc;
  int? ed;
  int? ep;

  ///"es": 1, //RBTimeStatus 0:未开赛 1:开始 2:进行中 3:暂停
  int? es;
  int? ic;
  int? hot;
  int? on;
  int? hp;
  int? ap;
  Map<String, String>? pol;
  String? pgid;
  String? pgn;
  int? ls;
  List<dynamic>? lsu;
  String? eifo;
  List<Tgl>? tgl;
  List<Ml>? ml; //赛事盘口 比分模式
  String? htpic;
  String? atpic;

  SportMatchModel({
    this.oen,
    this.htpic,
    this.atpic,
    this.isFav,
    this.ei,
    this.si,
    this.sn,
    this.m,
    this.ci,
    this.cn,
    this.hti,
    this.htn,
    this.ati,
    this.atn,
    this.rbt,
    this.rbts,
    this.mc,
    this.ed,
    this.ep,
    this.es,
    this.ic,
    this.hot,
    this.on,
    this.hp,
    this.ap,
    this.pol,
    this.pgid,
    this.pgn,
    this.ls,
    this.lsu,
    this.eifo,
    this.tgl,
    this.ml,
    this.ts,
    this.rbtd,
    this.rbtt,
  });

  factory SportMatchModel.fromJson(Map<String, dynamic> json) => SportMatchModel(
        oen: json["oen"],
        isFav: false,
        rbtd: json["rbtd"],
        rbtt: json["rbtt"],
        htpic: json["htpic"],
        atpic: json["atpic"],
        ei: json["ei"],
        si: json["si"],
        sn: json["sn"],
        m: json["m"],
        ci: json["ci"],
        cn: json["cn"],
        hti: json["hti"],
        htn: json["htn"],
        ati: json["ati"],
        atn: json["atn"],
        rbt: json["rbt"],
        rbts: json["rbts"],
        mc: json["mc"],
        ed: json["ed"],
        ep: json["ep"],
        es: json["es"],
        ic: json["ic"],
        hot: json["hot"],
        on: json["on"],
        hp: json["hp"],
        ap: json["ap"],
        pol: json["pol"] != null
            ? Map.from(json["pol"]).map((k, v) => MapEntry<String, String>(k, v))
            : null,
        pgid: json["pgid"],
        pgn: json["pgn"],
        ls: json["ls"],
        lsu: json["lsu"] == null ? [] : List<dynamic>.from(json["lsu"]!.map((x) => x)),
        eifo: json["eifo"],
        tgl: json["tgl"] == null ? [] : List<Tgl>.from(json["tgl"]!.map((x) => Tgl.fromJson(x))),
        ml: json["ml"] == null
            ? []
            : List<Ml>.from(json["ml"]!.map((x) => Ml.fromJson(x
              ..['ts'] = json["ts"]
              ..['rbtd'] = json["rbtd"]
              ..['rbtt'] = json["rbtt"]
              ..['isFav'] = json["isFav"]
              ..['cn'] = json["cn"]
              ..['htn'] = json["htn"]
              ..['atn'] = json["atn"]
              ..['rbt'] = json["rbt"]
              ..['rbts'] = json["rbts"]
              ..['es'] = json["es"]
              ..['si'] = json["si"]
              ..['ei'] = json["ei"]
              ..['hp'] = json["hp"]
              ..['ap'] = json["ap"]
              ..['mc'] = json["mc"]
              ..['ed'] = json["ed"]
              ..['cn'] = json["cn"]
              ..['ic'] = json["ic"]
              ..['ci'] = json["ci"]
              ..['m'] = json["m"]))),
        ts: json["ts"],
      );

  Map<String, dynamic> toJson() => {
        "ei": ei,
        "si": si,
        "sn": sn,
        "m": m,
        "ci": ci,
        "cn": cn,
        "hti": hti,
        "htn": htn,
        "ati": ati,
        "atn": atn,
        "rbt": rbt,
        "rbts": rbts,
        "mc": mc,
        "ed": ed,
        "ep": ep,
        "es": es,
        "ic": ic,
        "hot": hot,
        "on": on,
        "hp": hp,
        "ap": ap,
        "pol": Map.from(pol!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "pgid": pgid,
        "pgn": pgn,
        "ls": ls,
        "lsu": lsu == null ? [] : List<dynamic>.from(lsu!.map((x) => x)),
        "eifo": eifo,
        "tgl": tgl == null ? [] : List<dynamic>.from(tgl!.map((x) => x.toJson())),
        "ml": ml == null ? [] : List<dynamic>.from(ml!.map((x) => x.toJson())),
        "ts": ts,
      };
}

class Ml {
  bool? isFav;
  int? ed;
  String? rei;
  String? cn;
  String? htn;
  String? atn;
  String? mlid;
  int? bt; //盘总类型：
  String? btn;
  int? pid;
  String? pn;
  int? mll;
  int? mls; //0:关盘  1:开盘  2:锁盘
  int? pat;
  List<int>? tgis;
  List<M>? ms; //赔率， 2格子 或者 3格子
  int? si;
  String? ei;
  String? ci;
  int? ts;
  String? rbtd;
  String? rbtt;

  // "hp": 0, //主队比分
  // "ap": 0, //客队比分
  int? hp;
  int? ap;
  int? m;
  int? mc;
  int? ic;
  String? rbt;
  int? egi; //0103。新增接口字段。需求变更：盘口选择，需要改成用 bt 跟egi 都要相同来对应
  String? oen; //欧洲冠军联赛2023/12/13 - 最多進球的球隊


  Ml({
    this.rei,
    this.isFav,
    this.mlid,
    this.bt,
    this.btn,
    this.pid,
    this.pn,
    this.mll,
    this.mls,
    this.pat,
    this.tgis,
    this.ms,
    this.si,
    this.ei,
    this.hp,
    this.ap,
    this.m,
    this.mc,
    this.htn,
    this.atn,
    this.ed,
    this.cn,
    this.ic,
    this.ci,
    this.rbt,
    this.ts,
    this.rbtd,
    this.rbtt,
    this.egi,
    this.oen,
  });

  factory Ml.fromJson(Map<String, dynamic> json) => Ml(
        isFav: false,
        ts: json['ts'],
        rbtd: json['rbtd'],
        rbtt: json['rbtt'],
        rei: json['rei'],
        ed: json["ed"],
        cn: json["cn"],
        htn: json["htn"],
        atn: json["atn"],
        mc: json["mc"],
        m: json["m"],
        hp: json["hp"],
        ap: json["ap"],
        ei: json["ei"],
        si: json["si"],
        mlid: json["mlid"],
        bt: json["bt"],
        btn: json["btn"],
        pid: json["pid"],
        pn: json["pn"],
        mll: json["mll"],
        mls: json["mls"],
        pat: json["pat"],
        ci: json["ci"],
        rbt: json['rbt'],
        ic: json["ic"],
        egi: json["egi"],
        oen: json["oen"],
        tgis: json["tgis"] == null ? [] : List<int>.from(json["tgis"]!.map((x) => x)),
        ms: json["ms"] == null
            ? []
            : List<M>.from(json["ms"]!.map((x) => M.fromJson(x
              ..['rei'] = json["rei"]
              ..['cn'] = json["cn"]
              ..['htn'] = json["htn"]
              ..['atn'] = json["atn"]
              ..['rbt'] = json["rbt"]
              ..['rbts'] = json["rbts"]
              ..['es'] = json["es"]
              ..['si'] = json["si"]
              ..['ei'] = json["ei"]
              ..['m'] = json["m"]
              ..['btn'] = json["btn"]
              ..['bt'] = json["bt"]
              ..['pid'] = json["pid"]
              ..['mll'] = json["mll"]
              ..['hp'] = json["hp"]
              ..['ap'] = json["ap"]
              ..['ic'] = json["ic"]
              ..['ci'] = json["ci"]
              ..['mls'] = json["mls"]
              ..['mlid'] = json["mlid"]))),
      );

  Map<String, dynamic> toJson() => {
        "ed": ed,
        "mlid": mlid,
        "bt": bt,
        "btn": btn,
        "pid": pid,
        "pn": pnValues.reverse[pn],
        "mll": mll,
        "mls": mls,
        "pat": pat,
        "hp": hp,
        "ap": ap,
        "ic": ic,
        "tgis": tgis == null ? [] : List<dynamic>.from(tgis!.map((x) => x)),
        "ms": ms == null ? [] : List<dynamic>.from(ms!.map((x) => x.toJson())),
        "egi": egi,
        "oen": oen,
      };

  ///转城 M 模型 需要的数据字段
  Map<String, dynamic> toJsonToM() => {
        "mls": mls,
        "cn": cn,
        "htn": htn,
        "rbt": rbt,
        "atn": atn,
        "ei": ei,
        "m": m,
        "si": si,
        "btn": btn,
        "bt": bt,
        "pid": pid,
        "mll": mll,
        "mlid": mlid,
        "hp": hp,
        "ap": ap,
        "ic": ic,
        "ci": ci,
      };
}

class M {
  String? rei;
  String? wid; //更新 是根据该字段
  String? new_wid;
  String? sid;
  String? sn; //"sn": "利雅得希拉尔 (-1.5)",
  String? hdp;

  ///1230。需求变更：索取投注信息 place/betinfo投注、 place/bet这两只接口，需要增加入参sp
  String? sp;
  String? ov; //赔率
  String? ci;

  String? cn;
  String? htn; //主队名称
  String? atn; //客队名称
  String? rbt;
  int? rbts; //RBTimeStatus 0:未开赛 1:开始 2:进行中 3:暂停
  int? es;  //RBTimeStatus 0:未开赛 1:开始 2:进行中 3:暂停
  int? si;
  String? ei;
  int? m;//"m": 2, //market 1:早盘 2:今日 3:滚球 100:冠军赛

  String? btn;
  int? bt;
  int? pid;
  int? mll;

  ///接口是没有返回的
  int? mls; //0:关盘 1:开盘 2:锁盘
  int? hp;
  int? ap;
  String? mlid;

  String? oov;
  int? isUp;
  bool? isChoose;

  ///存储 单项投注金额
  num? amount;
  num? min;
  num? max;

  ///接口没有的， 自定义，为了在投注后做状态处理
  ///0正常投注单（还没执行投注）；1投注后成功状态；2投注后失败状态
  int? showState;

  /// 0:关盘 1:开盘; 增加状态 os = 2代表开盘中，但赔率低于1.1不支援串关
  /// os 目前有的状态：  0:关盘 1:开盘 2:不支援串关 3:赔率<1.1，不支援串关
  int? os;

  ///接口是没有这字段，自定义。 目的是索取投注信息，同一个单， 单式与复式的os不一样，存储复式的
  int? osDuplex;

  ///是否取得串关数量 1:支援串关 2:不支援串关
  int? ic;

  ///是否支持重投 1:支持 0:不支持
  int? reb; //后期添加的，是否支持复投

  ///0106接口变更。索取投注信息 接口多加这两个字段
  // "homeTeamName": "利雅得希拉尔",
  // "awayTeamName": "塔亚文FC",
  String? homeTeamName;
  String? awayTeamName;

  M({
    this.rei,
    this.wid,
    this.new_wid,
    this.sid,
    this.sn,
    this.hdp,
    this.sp,
    this.ov,
    this.cn,
    this.htn,
    this.atn,
    this.rbt,
    this.rbts,
    this.es,
    this.si,
    this.ei,
    this.m,
    this.btn,
    this.bt,
    this.pid,
    this.mll,
    this.mlid,
    this.oov,
    this.isUp,
    this.isChoose,
    this.amount,
    this.mls,
    this.hp,
    this.ap,
    this.min,
    this.max,
    this.showState,
    this.os,
    this.ic,
    this.ci,
    this.reb,
    this.homeTeamName,
    this.awayTeamName,
  });

  factory M.fromJson(Map<String, dynamic> json) {
    String sn = json["sn"];
    try {
      RegExp regExp = RegExp(r'{(.*?)}');
      RegExpMatch? match = regExp.firstMatch(json['sn'] ?? '');
      var k = (match != null ? match.group(1) ?? "" : "");
      if (k.isNotEmpty) {
        List<String> parts = json['sn'].split('&');
        Map<String, String> resultMap = {};
        for (String part in parts) {
          List<String> keyValue = part.split('=');
          if (keyValue.length == 2) {
            resultMap[keyValue[0]] = keyValue[1];
          }
        }
        RegExp regExp = RegExp(r'{(.*?)}');
        sn = sn.replaceAllMapped(regExp, (Match match) {
          return resultMap[k] ?? '';
        });
      }
    } catch (e) {
      print("");
    }

    return M(
      mls: json["mls"] ?? 1,
      rei: json["rei"],
      wid: json["wid"],
      new_wid: json["wid"],
      sid: json["sid"],
      sn: sn,
      hdp: json["hdp"],
      sp: json["sp"],
      ov: json["ov"],
      cn: json["cn"],
      htn: json["htn"],
      atn: json["atn"],
      rbt: json["rbt"],
      rbts: json["rbts"],
      es: json["es"],
      si: json["si"],
      ei: json["ei"],
      m: json["m"],
      btn: json["btn"],
      bt: json["bt"],
      pid: json["pid"],
      mll: json["mll"],
      mlid: json["mlid"],
      min: json["min"],
      max: json["max"],
      hp: json["hp"],
      ap: json["ap"],
      ic: json["ic"],
      os: json["os"],
      ci: json["ci"],
      oov: '',
      isUp: 2,
      showState: 0,
      isChoose: false,
      amount: 0.00,
      reb: json["reb"],
      //后期添加的，是否支持复投
      homeTeamName: json["homeTeamName"],
      awayTeamName: json["awayTeamName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "mls": mls,
        "wid": wid,
        "new_wid": new_wid,
        "sid": sid,
        "sn": sn,
        "hdp": hdp,
        "sp": sp,
        "ov": ov,
        "oov": oov,
        "isUp": isUp,
        "isChoose": isChoose,
        "amount": amount,
        "cn": cn,
        "htn": htn,
        "rbt": rbt,
        "atn": atn,
        "rbts": rbts,
        "es": es,
        "ei": ei,
        "m": m,
        "si": si,
        "btn": btn,
        "bt": bt,
        "pid": pid,
        "mll": mll,
        "mlid": mlid,
        "min": min,
        "max": max,
        "hp": hp,
        "ap": ap,
        "ic": ic,
        "os": os,
        "ci": ci,
        "showState": showState,
        "reb": reb, //后期添加的，是否支持复投
      };

  ///来自冠军赛事接口
  factory M.fromJsonWithOutright(Map<String, dynamic> json) => M(
        wid: json["wid"],
        sid: json["sid"],
        sn: json["sn"],
        hdp: json["hdp"],
        sp: json["sp"],
        ov: json["ov"],
      );

  ///来自冠军赛事接口
  Map<String, dynamic> toJsonWithOutright() => {
        "wid": wid,
        "sid": sid,
        "sn": sn,
        "hdp": hdp,
        "sp": sp,
        "ov": ov,
      };
}

enum Pn { EMPTY, PN, PURPLE }

final pnValues = EnumValues({
  S.current.random_text_491: Pn.EMPTY,
  S.current.random_text_393: Pn.PN,
  S.current.random_text_492: Pn.PURPLE
});

class Tgl {
  int? tgi;
  String? tgn;

  Tgl({
    this.tgi,
    this.tgn,
  });

  factory Tgl.fromJson(Map<String, dynamic> json) => Tgl(
        tgi: json["tgi"],
        tgn: json["tgn"],
      );

  Map<String, dynamic> toJson() => {
        "tgi": tgi,
        "tgn": tgn,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
