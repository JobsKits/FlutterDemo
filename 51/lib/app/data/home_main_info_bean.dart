// ignore_for_file: non_constant_identifier_names

import 'package:flutter_tiyu_app/app/modules/activity/data/activity_bean.dart';
import 'package:flutter_tiyu_app/utils/app_json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_main_info_bean.g.dart';

///首页游戏信息的主体类，banner、公告、游戏都在里面
@JsonSerializable()
class HomeMainInfoBean implements AppJsonSerializable {
  BannerAndAnnouncementBean? news; //公告
  Map<String, dynamic>? banners; //banner
  List<ThirdGamesItem>? thirdGames; //三方游戏
  HomeHotGameBean? homeHotGames;
  List<VersionTypeItem>? version_type; // 游戏控制
  GameStateBean? gameState; // 所有游戏销售状态
  List<GamesTryBean>? gamesTry; // 试玩游戏

  HomeMainInfoBean({
    this.news,
    this.banners,
    this.thirdGames,
    this.homeHotGames,
    this.version_type,
    this.gameState,
    this.gamesTry,
  });
  factory HomeMainInfoBean.fromJson(Map<String, dynamic> json) =>
      _$HomeMainInfoBeanFromJson(json);

  Map<String, dynamic> toJson() => _$HomeMainInfoBeanToJson(this);

  @override
  String toString() {
    return 'HomeMainInfoBean{news: $news, banners: $banners, thirdGames: $thirdGames, homeHotGames: $homeHotGames, version_type: $version_type, gameState: $gameState, gamesTry: $gamesTry}';
  }
}

///游戏试玩
@JsonSerializable()
class GamesTryBean implements AppJsonSerializable {
  GamesTryBean({
    this.icon_url,
    this.play_id,
    this.play_cname,
    this.subList,
    this.logo3_img_url,
    this.big_type,
  });

  String? icon_url;
  num? play_id;
  num? big_type;
  String? play_cname;
  List<GamesTryItemBean>? subList;
  String? logo3_img_url; //游戏TAB高亮ICON

  factory GamesTryBean.fromJson(Map<String, dynamic> json) =>
      _$GamesTryBeanFromJson(json);

  Map<String, dynamic> toJson() => _$GamesTryBeanToJson(this);

  @override
  String toString() {
    return 'GamesTryBean{big_type:$big_type logo3_img_url:$logo3_img_url icon_url: $icon_url, play_id: $play_id, play_cname: $play_cname, subList: $subList}';
  }
}

@JsonSerializable()
class GamesTryItemBean implements AppJsonSerializable {
  GamesTryItemBean({
    this.play_id,
    this.play_name,
    this.upper_play_cname,
    this.gtype,
    this.play_cname,
    this.upper_play_id,
    this.play_collection,
    this.state,
    this.play_cat,
    this.type,
    this.big_type,
    this.tid,
  });
  num? play_id;
  String? play_name;
  String? upper_play_cname;
  String? gtype;
  String? play_cname;
  num? upper_play_id;
  num? play_collection;
  num? state;
  num? play_cat;
  num? type;
  num? big_type;
  num? tid;

  factory GamesTryItemBean.fromJson(Map<String, dynamic> json) =>
      _$GamesTryItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$GamesTryItemBeanToJson(this);

  @override
  String toString() {
    return 'GamesTryItemBean{play_id: $play_id, play_name: $play_name, upper_play_cname: $upper_play_cname, gtype: $gtype, play_cname: $play_cname, upper_play_id: $upper_play_id, play_collection: $play_collection, state: $state, play_cat: $play_cat, type: $type, big_type: $big_type, tid: $tid}';
  }
}

///公告数据bean
@JsonSerializable()
class BannerAndAnnouncementBean implements AppJsonSerializable {
  BannerAndAnnouncementBean({
    this.count,
    this.data,
  });

  num? count;
  List<BannerAndAnnouncementItem>? data;
  factory BannerAndAnnouncementBean.fromJson(Map<String, dynamic> json) =>
      _$BannerAndAnnouncementBeanFromJson(json);

  Map<String, dynamic> toJson() => _$BannerAndAnnouncementBeanToJson(this);
  @override
  String toString() {
    return 'SystemAnnouncementBean{count: $count, data: $data}';
  }
}

@JsonSerializable()
class BannerAndAnnouncementItem {
  BannerAndAnnouncementItem({
    this.bulletinId,
    this.message_id,
    this.subject,
    this.contentType,
    this.content,
    this.chanCon,
    this.operCode,
    this.create_time,
    this.state,
    this.stateTime,
    this.effTime,
    this.expTime,
    this.tid,
    this.title,
    this.maId,
    this.picAddr,
    this.sortV,
    this.custGroupId,
    this.scheduleId,
    this.bulletinScheduleId,
    this.apply,
    this.activeType,
    this.bigSortV,
    this.eventApply,
    this.proxy,
    this.isPopUp,
    this.autoDelivery,
    this.linkType,
    this.gameType,
    this.platform,
    this.game,
    this.taskType,
    this.gameTaskClass,
    this.playState,
    this.language,
    this.vipLevel,
    this.android,
    this.ios,
    this.web,
    this.weiXin,
    this.is_save_pic,
  });

  num? bulletinId;
  num? message_id;
  String? subject;
  num? contentType;
  String? content;
  num? chanCon;
  String? operCode;
  int? create_time;
  num? state;
  num? stateTime;
  num? effTime;
  num? expTime;
  num? tid;
  String? title;
  num? maId;
  String? picAddr;
  num? sortV;
  num? custGroupId;
  num? scheduleId;
  num? bulletinScheduleId;
  num? apply;
  num? activeType;
  num? bigSortV;
  num? eventApply;
  num? proxy;
  num? isPopUp;
  num? autoDelivery;
  num? linkType;
  num? gameType;
  num? platform;
  num? game;
  num? taskType;
  num? gameTaskClass;
  num? playState;
  num? language;
  num? vipLevel;
  bool? android;
  bool? ios;
  bool? web;
  bool? weiXin;
  num? is_save_pic;

  factory BannerAndAnnouncementItem.fromJson(Map<String, dynamic> json) =>
      _$BannerAndAnnouncementItemFromJson(json);

  Map<String, dynamic> toJson() => _$BannerAndAnnouncementItemToJson(this);

  @override
  String toString() {
    return 'SystemAnnouncementItem{bulletinId: $bulletinId, messageId: $message_id, subject: $subject, contentType: $contentType, content: $content, chanCon: $chanCon, operCode: $operCode, createTime: $create_time, state: $state, stateTime: $stateTime, effTime: $effTime, expTime: $expTime, tid: $tid, title: $title, maId: $maId, picAddr: $picAddr, sortV: $sortV, custGroupId: $custGroupId, scheduleId: $scheduleId, bulletinScheduleId: $bulletinScheduleId, apply: $apply, activeType: $activeType, bigSortV: $bigSortV, eventApply: $eventApply, proxy: $proxy, isPopUp: $isPopUp, autoDelivery: $autoDelivery, linkType: $linkType, gameType: $gameType, platform: $platform, game: $game, taskType: $taskType, gameTaskClass: $gameTaskClass, playState: $playState, language: $language, vipLevel: $vipLevel, android: $android, ios: $ios, web: $web, weiXin: $weiXin, is_save_pic: $is_save_pic}';
  }
}

///游戏的实体类
//{
// "play_name":"120"
// "upper_play_cname":"DB棋牌"
// "gtype":""
// "play_cname":"梭哈"
// "play_collection":1
// "play_cat":3
// "type":0
// "hot_val":10000
// "tid":3
// "game_fever":1
// "is_top":1
// "play_id":1383019
// "upper_play_id":1383
// "state":1
// }
@JsonSerializable()
class GameBeanItem {
  GameBeanItem({
    this.play_name,
    this.upper_play_cname,
    this.gtype,
    this.play_cname,
    this.play_collection,
    this.play_cat,
    this.type,
    this.hot_val,
    this.tid,
    this.game_fever,
    this.play_is_hot,
    this.is_top,
    this.play_id,
    this.upper_play_id,
    this.state,
    this.sub_play_id,
    this.upper_id,
    this.gameImgUrl,
    this.logo1_img_url,
    this.logo2_img_url,
    this.logo3_img_url,
    this.big_type,
    this.thumbnail_img_url,
    this.play_sort,
    this.hot_play_sort,
  });

  String? play_name;
  String? upper_play_cname;
  String? gameImgUrl;
  String? thumbnail_img_url;
  String? gtype;
  String? play_cname;
  String? logo1_img_url;
  String? logo2_img_url;
  String? logo3_img_url;
  int? sub_play_id;
  num? play_collection;
  num? play_cat;
  num? type;
  int? hot_val;
  num? tid;
  num? game_fever;
  num? play_is_hot;
  num? play_sort;
  int? is_top;
  int? play_id;
  num? upper_play_id;
  num? upper_id;
  num? state;
  num? big_type;
  num? hot_play_sort;
  factory GameBeanItem.fromJson(Map<String, dynamic> json) =>
      _$GameBeanItemFromJson(json);

  Map<String, dynamic> toJson() => _$GameBeanItemToJson(this);

  @override
  String toString() {
    return 'GameBeanItem{play_collection:$play_collection hot_play_sort:$hot_play_sort play_name: $play_name, upper_play_cname: $upper_play_cname, gameImgUrl: $gameImgUrl, thumbnail_img_url: $thumbnail_img_url, gtype: $gtype, play_cname: $play_cname, logo1_img_url: $logo1_img_url, logo2_img_url: $logo2_img_url, logo3_img_url: $logo3_img_url, sub_play_id: $sub_play_id, play_collection: $play_collection, play_cat: $play_cat, type: $type, hot_val: $hot_val, tid: $tid, game_fever: $game_fever, play_is_hot: $play_is_hot, is_top: $is_top, play_id: $play_id, upper_play_id: $upper_play_id, upper_id: $upper_id, state: $state, big_type: $big_type}';
  }
}

@JsonSerializable()
class GameFishingItem {
  GameFishingItem({
    this.game_fever,
    this.hot_val,
    this.is_top,
    this.play_cat,
    this.play_collection,
    this.play_id,
    this.big_type,
    this.state,
    this.upper_play_id,
  });

  num? game_fever;
  num? hot_val;
  num? is_top;
  num? play_cat;
  num? play_collection;
  num? play_id;
  num? big_type;
  num? upper_play_id;
  int? state;

  factory GameFishingItem.fromJson(Map<String, dynamic> json) {
    json['state'] =
        json['play_id'] != null ? json[json['play_id'].toString()] : 3;
    return _$GameFishingItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GameFishingItemToJson(this);

  @override
  String toString() {
    return 'GameFishingItem{game_fever: $game_fever, hot_val: $hot_val, is_top: $is_top, play_cat: $play_cat, play_collection: $play_collection, play_id: $play_id, big_type: $big_type, upper_play_id: $upper_play_id, state: $state}';
  }
}

///三方游戏item 实体类
@JsonSerializable()
class ThirdGamesItem implements AppJsonSerializable {
  ThirdGamesItem({
    this.icon_url,
    this.play_name,
    this.gtype,
    this.play_cname,
    this.play_collection,
    this.play_cat,
    this.play_id,
    this.state,
    this.big_type,
    this.upper_id,
    this.hot_val,
    this.game_fever,
    this.play_is_hot,
    this.gameImgUrl,
    this.balance,
    this.isLoadImgError,
    this.logo1_img_url,
    this.logo2_img_url,
    this.logo3_img_url,
    this.thumbnail_img_url,
    this.bg_img_url,
    this.play_sort,
    this.hot_play_sort,
  });

  String? icon_url; // 该值无用途
  int? play_id;
  String? play_name;
  String? gtype; // 数据上均无值，不知用途
  String? play_cname;
  String? gameImgUrl;
  num? play_collection; // 是否收藏
  num? play_cat; // 类别
  num? state; // 状态
  num? play_sort; // 排序
  num? big_type; // 游戏大类 big_type: "2",  -- 2棋牌，3电子，4捕鱼，5真人，6体育，7彩票，8红包,9电竞
  num? upper_id; // 上级ID ？？？
  num? hot_val; // 热度排序
  num? game_fever; // 热度排序
  num? hot_play_sort; // 热度排序
  num? play_is_hot; // 新热度排序
  double? balance; // 余额
  bool? isLoadImgError; // 余额
  String? logo1_img_url; //游戏TAB ICON
  String? logo2_img_url; //游戏TAB选中ICON
  String? logo3_img_url; //游戏TAB高亮ICON
  String? thumbnail_img_url; //游戏列表ICON
  String? bg_img_url; //首页平台ICON
  factory ThirdGamesItem.fromJson(Map<String, dynamic> json) =>
      _$ThirdGamesItemFromJson(json);

  Map<String, dynamic> toJson() => _$ThirdGamesItemToJson(this);

  @override
  String toString() {
    return 'ThirdGamesItem{icon_url: $icon_url, play_id: $play_id, play_name: $play_name, gtype: $gtype, play_cname: $play_cname, gameImgUrl: $gameImgUrl, play_collection: $play_collection, play_cat: $play_cat, state: $state, big_type: $big_type, upper_id: $upper_id, hot_val: $hot_val, game_fever: $game_fever,play_is_hot:$play_is_hot balance: $balance, isLoadImgError: $isLoadImgError, logo1_img_url: $logo1_img_url, logo2_img_url: $logo2_img_url, logo3_img_url: $logo3_img_url, thumbnail_img_url: $thumbnail_img_url, bg_img_url: $bg_img_url}';
  }
}

@JsonSerializable()
class HomeHotGameBean implements AppJsonSerializable {
  @JsonKey(name: '1')
  List<GameBeanItem>? gameList1;
  @JsonKey(name: '2')
  List<GameBeanItem>? gameList2;
  @JsonKey(name: '3')
  List<GameBeanItem>? gameList3;
  @JsonKey(name: '5')
  List<GameBeanItem>? gameList5;
  @JsonKey(name: '6')
  List<GameBeanItem>? gameList6;
  @JsonKey(name: '7')
  List<GameBeanItem>? gameList7;
  @JsonKey(name: '8')
  List<GameBeanItem>? gameList8;
  HomeHotGameBean(
      {this.gameList1,
      this.gameList2,
      this.gameList3,
      this.gameList5,
      this.gameList6,
      this.gameList7,
      this.gameList8});

  factory HomeHotGameBean.fromJson(Map<String, dynamic> json) =>
      _$HomeHotGameBeanFromJson(json);

  Map<String, dynamic> toJson() => _$HomeHotGameBeanToJson(this);
}

///游戏地址的实体类
@JsonSerializable()
class GameUrlBean {
  String url;
  GameUrlBean({required this.url});

  factory GameUrlBean.fromJson(Map<String, dynamic> json) =>
      _$GameUrlBeanFromJson(json);

  Map<String, dynamic> toJson() => _$GameUrlBeanToJson(this);
}

///游戏控制 version_type 实体类
@JsonSerializable()
class VersionTypeItem implements AppJsonSerializable {
  VersionTypeItem({
    this.id,
    this.oper_code,
    this.play_name,
    this.sort_v,
    this.state,
    this.tid,
    this.type,
    this.state_time,
    this.create_time,
  });

  num? id;
  String? oper_code;
  String? play_name;
  num? sort_v;
  num? state;
  num? tid;
  int? type;
  num? state_time;
  num? create_time;

  factory VersionTypeItem.fromJson(Map<String, dynamic> json) =>
      _$VersionTypeItemFromJson(json);

  Map<String, dynamic> toJson() => _$VersionTypeItemToJson(this);

  @override
  String toString() {
    return 'VersionTypeItem{id: $id, oper_code: $oper_code, play_name: $play_name, sort_v: $sort_v, state: $state, tid: $tid, type: $type, state_time: $state_time, create_time: $create_time}';
  }
}

///游戏控制 gameState 实体类
@JsonSerializable()
class GameStateBean implements AppJsonSerializable {
  GameStateBean(this.data);

  Map<int, int>? data;

  // JSON 转实体
  factory GameStateBean.fromJson(Map<String, dynamic> json) {
    return GameStateBean(
      (json.map((key, value) => MapEntry(int.parse(key), value as int))),
    );
  }
  // 实体转 JSON
  Map<String, dynamic> toJson() {
    return data?.map((key, value) => MapEntry(key.toString(), value)) ?? {};
  }
}

/// 彩票数据
@JsonSerializable()
class GameLotteryBean {
  GameLotteryBean(this.data);

  List<GameLotteryItemBean>? data;

  factory GameLotteryBean.fromJson(List<dynamic>? list) {
    var result = list
        ?.map((json) =>
            GameLotteryItemBean.fromJson(json as Map<String, dynamic>))
        .toList();
    return GameLotteryBean(result);
  }
}

/// 彩票子项数据
@JsonSerializable()
class GameLotteryItemBean {
  GameLotteryItemBean({
    this.base,
    this.begin_time,
    this.end_time,
    this.hot_val,
    this.img_url,
    this.is_top,
    this.is_xy,
    this.play_cat,
    this.play_cname,
    this.play_collection,
    this.play_des,
    this.play_id,
    this.play_name,
    this.play_state,
    this.start_sale_offset,
    this.stopTime,
    this.stop_sale_offset,
    this.sub_play_id,
    this.sys_time,
    this.term_code,
    this.timeout,
    this.type,
    this.thumbnail_img_url,
  });

  String? base;
  int? begin_time;
  int? end_time;
  int? hot_val;
  String? img_url;
  String? thumbnail_img_url;
  int? is_top;
  int? is_xy;
  int? play_cat;
  String? play_cname;
  int? play_collection;
  String? play_des;
  int? play_id;
  String? play_name;
  int? play_state;
  int? start_sale_offset;
  int? stopTime;
  int? stop_sale_offset;
  int? sub_play_id;
  int? sys_time;
  int? term_code;
  bool? timeout;
  int? type;

  factory GameLotteryItemBean.fromJson(Map<String, dynamic> json) =>
      _$GameLotteryItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$GameLotteryItemBeanToJson(this);

  @override
  String toString() {
    return 'GameLotteryItemBean{base: $base, begin_time: $begin_time, end_time: $end_time, hot_val: $hot_val, img_url: $img_url, is_top: $is_top, is_xy: $is_xy, play_cat: $play_cat, play_cname: $play_cname, play_collection: $play_collection, play_des: $play_des, play_id: $play_id, play_name: $play_name, play_state: $play_state, start_sale_offset: $start_sale_offset, stopTime: $stopTime, stop_sale_offset: $stop_sale_offset, sub_play_id: $sub_play_id, sys_time: $sys_time, term_code: $term_code, timeout: $timeout, type: $type}';
  }
}

@JsonSerializable()
class GameChessAndElectronicBean implements AppJsonSerializable {
  GameChessAndElectronicBean(this.data);

  Map<int, List<GameChessAndElectronicItemBean>>? data;

  factory GameChessAndElectronicBean.fromJson(Map<String, dynamic> json) {
    // 将 Map<String, dynamic> 转换为 Map<int, List<GameChessAndElectronicItemBean>>
    return GameChessAndElectronicBean(json.map((key, value) => MapEntry(
        int.parse(key),
        (value as List)
            .map((item) => GameChessAndElectronicItemBean.fromJson(item))
            .toList())));
  }

  Map<String, dynamic> toJson() {
    return data!.map((key, value) =>
        MapEntry(key.toString(), value.map((item) => item.toJson()).toList()));
  }
}

@JsonSerializable()
class GameChessAndElectronicItemBean {
  GameChessAndElectronicItemBean({
    this.big_type,
    this.game_fever,
    this.gtype,
    this.hot_val,
    this.icon_url,
    this.play_cat,
    this.play_cname,
    this.play_collection,
    this.play_id,
    this.play_name,
    this.play_state_id,
    this.state,
    this.upper_id,
    this.thumbnail_img_url,
    this.play_sort,
    this.play_is_hot,
    this.hot_play_sort,
  });

  int? big_type;
  int? game_fever;
  String? gtype;
  num? hot_val;
  String? icon_url;
  num? play_cat;
  String? play_cname;
  int? play_collection;
  num? play_id;
  String? play_name;
  String? thumbnail_img_url;
  num? play_state_id;
  num? state;
  num? upper_id;
  num? play_sort;
  num? play_is_hot;
  num? hot_play_sort;

  factory GameChessAndElectronicItemBean.fromJson(Map<String, dynamic> json) =>
      _$GameChessAndElectronicItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$GameChessAndElectronicItemBeanToJson(this);

  @override
  String toString() {
    return 'GameChessAndElectronicItemBean{big_type: $big_type, game_fever: $game_fever, gtype: $gtype, hot_val: $hot_val, icon_url: $icon_url, play_cat: $play_cat, play_cname: $play_cname, play_collection: $play_collection, play_id: $play_id, play_name: $play_name, play_state_id: $play_state_id, state: $state, upper_id: $upper_id}';
  }
}

/// 收藏列表数据
@JsonSerializable()
class HomeCollectionListBean {
  HomeCollectionListBean(this.data);

  final List<HomeCollectionListItemBean>? data;

  factory HomeCollectionListBean.fromJson(List<dynamic>? list) {
    var result = list
        ?.map((json) =>
            HomeCollectionListItemBean.fromJson(json as Map<String, dynamic>))
        .toList();
    return HomeCollectionListBean(result);
  }

  List<Map<String, dynamic>> toJson() {
    return data!.map((item) => item.toJson()).toList();
  }
}

@JsonSerializable()
class HomeCollectionListItemBean {
  HomeCollectionListItemBean({
    this.collectionId,
    this.msg,
    this.playCname,
    this.playName,
    this.play_big_type,
    this.play_cat,
    this.play_id,
    this.play_state,
    this.type,
    this.big_type,
    this.upper_name,
    this.gameImgUrl,
    this.gtype,
    this.upper_play_id,
    this.isRecord,
    this.thumbnail_img_url,
  });

  num? collectionId;
  String? msg;
  String? playCname;
  String? playName;
  int? play_big_type;
  int? play_cat;
  int? play_id;
  int? play_state;
  int? type;
  String? upper_name;
  String? gameImgUrl;
  String? thumbnail_img_url;
  int? upper_play_id;
  int? big_type;
  String? gtype;
  bool? isRecord;

  factory HomeCollectionListItemBean.fromJson(Map<String, dynamic> json) =>
      _$HomeCollectionListItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$HomeCollectionListItemBeanToJson(this);

  @override
  String toString() {
    return 'HomeCollectionListItemBean{collectionId: $collectionId, msg: $msg, playCname: $playCname, playName: $playName, play_big_type: $play_big_type, play_cat: $play_cat, play_id: $play_id, play_state: $play_state, type: $type, upper_name: $upper_name, gameImgUrl: $gameImgUrl, thumbnail_img_url: $thumbnail_img_url, upper_play_id: $upper_play_id, gtype: $gtype, isRecord: $isRecord}';
  }
}

/// 盈利排行榜数据
@JsonSerializable()
class HomeProfitListBean {
  HomeProfitListBean(this.data);

  final List<HomeProfitListItemBean>? data;

  factory HomeProfitListBean.fromJson(List<dynamic>? list) {
    var result = list
        ?.map((json) =>
            HomeProfitListItemBean.fromJson(json as Map<String, dynamic>))
        .toList();
    return HomeProfitListBean(result);
  }

  List<Map<String, dynamic>> toJson() {
    return data!.map((item) => item.toJson()).toList();
  }
}

/// 盈利排行榜子项
@JsonSerializable()
class HomeProfitListItemBean {
  HomeProfitListItemBean({
    this.amount,
    this.cust_name,
    this.id,
    this.oper_code,
    this.tid,
  });

  num? amount;
  String? cust_name;
  num? id;
  String? oper_code;
  num? state;
  num? tid;

  factory HomeProfitListItemBean.fromJson(Map<String, dynamic> json) =>
      _$HomeProfitListItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$HomeProfitListItemBeanToJson(this);
}

/// 所有彩票数据（不分销售状态）
@JsonSerializable()
class AllLotteryDataBean {
  AllLotteryDataBean(this.data);

  final List<AllLotteryDataItemBean>? data;

  factory AllLotteryDataBean.fromJson(List<dynamic>? list) {
    var result = list
        ?.map((json) =>
            AllLotteryDataItemBean.fromJson(json as Map<String, dynamic>))
        .toList();
    return AllLotteryDataBean(result);
  }

  List<Map<String, dynamic>> toJson() {
    return data!.map((item) => item.toJson()).toList();
  }
}

/// 所有彩票数据（不分销售状态） 子项
@JsonSerializable()
class AllLotteryDataItemBean {
  AllLotteryDataItemBean({
    this.hot_val,
    this.img_url,
    this.is_top,
    this.play_cat,
    this.play_cname,
    this.play_des,
    this.play_id,
    this.play_name,
    this.play_state,
    this.sub_play_id,
    this.type,
  });

  num? hot_val;
  String? img_url;
  int? is_top;
  int? play_cat;
  String? play_cname;
  String? play_des;
  int? play_id;
  String? play_name;
  int? play_state;
  int? sub_play_id;
  int? type;

  factory AllLotteryDataItemBean.fromJson(Map<String, dynamic> json) =>
      _$AllLotteryDataItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$AllLotteryDataItemBeanToJson(this);
}
