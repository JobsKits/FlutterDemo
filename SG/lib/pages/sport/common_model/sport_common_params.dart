import 'dart:convert';

import 'package:flutter_bet/generated/l10n.dart';

///体育模块公共，常量配置
class SportCommonConfig {
  /// 赛事列表种， 国家 图标
  static const String countryIconAsset = "assets/images/sport/ic_sport_area_world.webp";
  static const double countryIconSize = 14;

  ///10s
  static const int sportEventTime_20s = 20; //循环定时器，时间间隔
  static const int sportEventTime_60s = 60; //循环定时器，时间间隔
}

///进入页面的体育类型：比如早盘、冠军赛事、viewAll、联赛
enum SportOpenType {
  ///早盘
  live(type: 1),

  ///冠军赛事
  outright(type: 2),

  ///ViewAll
  viewAll(type: 3),

  ///某个联赛 下的比赛
  league(type: 4),

  ///所有体育
  sport(type: 5);

  final int type;

  // final String _name;

  const SportOpenType({required this.type});

  String getName() {
    switch (this) {
      case live:
        return S.current.random_text_486;
      case outright:
        return S.current.random_text_487;
      case viewAll:
        return "View All";
      case league:
        return S.current.random_text_488;
      case sport:
        return S.current.random_text_489;

      default:
        return "";
    }
  }
}

///market 0:取所有 1:早盘 2:今日 3:滚球 4:即将开赛 5:即将开赛及滚球
///请求接口参数，event/list
enum SportMarketApiType {
  ///所有
  all(type: 0),

  ///早盘
  live(type: 1),

  ///今日
  today(type: 2),

  ///滚球
  rolling(type: 3),

  ///即将开赛
  coming(type: 4),

  ///即将开赛及滚球
  comingAndRolling(type: 5);

  final int type;

  // final String name;

  const SportMarketApiType({required this.type});

  ///判断是否是滚球
  static bool isRolling(SportMarketApiType type) {
    return type == rolling;
  }

  /// 对api接口数值 进行枚举封装
  static SportMarketApiType checkMarketType(int? typeCode) {
    for (var clazz in SportMarketApiType.values) {
      if (clazz.type == typeCode) {
        return clazz;
      }
    }
    //默认的
    return all;
  }
}

///赛事列表 -
///接口event/list
///"rbts": 0, //RBTimeStatus 0:未开赛 1:开始 2:进行中 3:暂停
///"es": 1, //RBTimeStatus 0:未开赛 1:开始 2:进行中 3:暂停
///"ep": 1, //当前是第几盘或者第几局
///有2个字段，拿es 比较好
enum SportEventStateApiType {
  ///未开赛
  unBegin(type: 0),
  ///开始
  begin(type: 1),
  ///进行中
  opening(type: 2),
  ///暂停
  stopped(type: 3);

  final int type;
  // final String name;

  const SportEventStateApiType({required this.type});

  /// 对api接口数值 进行枚举封装
  static SportEventStateApiType checkEventStateType(int? typeCode) {
    for (var clazz in SportEventStateApiType.values) {
      if (clazz.type == typeCode) {
        return clazz;
      }
    }
    //默认的
    return unBegin;
  }

  ///是否开始
  static bool isBegin(SportEventStateApiType type) {
    return type != unBegin;
  }
}

///盘口model Ml 里面的 int? mls; //0:关盘  1:开盘  2:锁盘
///盘口状态
enum SportHandicapApiType {
  ///关盘
  closed(type: 0),
  ///开盘
  opening(type: 1),
  ///锁盘
  locked(type: 2);

  final int type;
  // final String name;

  const SportHandicapApiType({required this.type});

  /// 对api接口数值 进行枚举封装
  static SportHandicapApiType checkHandicap(int? handicapCode) {
    for (var handicap in SportHandicapApiType.values) {
      if (handicap.type == handicapCode) {
        return handicap;
      }
    }
    //默认的
    return opening;
  }

  ///是否可以点击
  static bool isCanClick(SportHandicapApiType type) {
    return type == opening;
  }

  ///是否开始
  static bool isOpening(SportHandicapApiType type) {
    return type == opening;
  }

  ///是否结束
  static bool isClosed(SportHandicapApiType type) {
    return type == closed;
  }
}

///打开体育赛事页面，传参数，封装
class SportOpenPageParams {
  final SportOpenType sportOpenType; //页面类型
  ///球种Id
  final int si;
  final String title; //标题
  final String? pgid; //地区Id
  ///联赛id
  final String? ci;
  final String? eid;
  final int? t;

  final String? categoryTitle;//比如 足球、篮球

  SportOpenPageParams({
    required this.sportOpenType,
    required this.si,
    required this.title,
    this.pgid,
    this.ci,
    this.t,
    this.eid,
    this.categoryTitle,
  });

  ///判断是是否某个联赛
  bool isLeagueEvent() {
    return sportOpenType == SportOpenType.league;
  }

  ///是否是冠军投注tab
  bool isOutRightTab() {
    return sportOpenType == SportOpenType.outright;
  }

  ///是否是 全部xx  tab
  bool isViewAllTab() {
    return sportOpenType == SportOpenType.viewAll;
  }

  @override
  String toString() {
    return 'SportOpenPageParams{sportOpenType: $sportOpenType, title: $title, si: $si, pgid: $pgid, ci: $ci}';
  }
}

/// 具体赛事接口 请求参数封装
/// 接口URL: POST {{sport_url}}{{sport_platId}}/event/list
SportGameParams sportGameParamsFromJson(String str) => SportGameParams.fromJson(json.decode(str));

String sportGameParamsToJson(SportGameParams data) => json.encode(data.toJson());

class SportGameParams {
  int si; //球种Id
  ///使用[SportMarketApiType]来管理数值
  int m; //market 0:取所有 1:早盘 2:今日 3:滚球 4:即将开赛 5:即将开赛及滚球
  List<String> ci; //联赛id
  int hot; // 是否热门 0:全部 1:热门赛事
  String pgid; //	地区id
  int page;
  int pageSize;

  SportGameParams({
    required this.si,
    required this.m,
    required this.ci,
    this.hot = 0, //默认全部
    this.pgid = "",
    this.page = 1,
    this.pageSize = 30,
  });

  factory SportGameParams.fromJson(Map<String, dynamic> json) => SportGameParams(
        si: json["si"],
        m: json["m"],
        ci: List<String>.from(json["ci"].map((x) => x)),
        hot: json["hot"],
        pgid: json["pgid"],
        page: json["page"],
        pageSize: json["page_size"],
      );

  Map<String, dynamic> toJson() => {
        "si": si,
        "m": m,
        "ci": List<dynamic>.from(ci.map((x) => x)),
        "hot": hot,
        "pgid": pgid,
        "page": page,
        "page_size": pageSize,
      };
}

///冠军投注 请求需要的参数
class SportOutrightParams {
  int si; //球种Id
  String? ci; //联赛id
  String? pgid; //	地区id

  SportOutrightParams({
    required this.si,
    required this.ci,
    required this.pgid,
  });
}
