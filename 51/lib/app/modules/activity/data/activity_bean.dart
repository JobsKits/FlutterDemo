// ignore_for_file: non_constant_identifier_names

import 'package:flutter_tiyu_app/app/modules/activity/data/activity_coding_model/t.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_bean.g.dart';

/// 活动tab数据
@JsonSerializable()
class ActivityTabsBean {
  ActivityTabsBean(this.data, this.count);

  List<ActivityTabsItemBean>? data;
  num? count;

  factory ActivityTabsBean.fromJson(Map<String, dynamic> json) =>
      _$ActivityTabsBeanFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityTabsBeanToJson(this);
}

@JsonSerializable()
class ActivityTabsItemBean {
  late num id;
  late num? sort_v;
  late num tid;
  late String? cat;
  num? state_time;
  num? create_time;
  late String? categoryName;
  late String? categoryType;
  late String? categoryPic;
  late String? categoryPic2;
  num? isShowCategoryPic;
  late String? status;
  num? orderNum;
  T? activity;

  ActivityTabsItemBean({
    required this.id,
    this.sort_v,
    required this.tid,
    this.cat,
    this.state_time,
    this.create_time,
    this.categoryName,
    this.categoryType,
    this.categoryPic,
    this.categoryPic2,
    this.isShowCategoryPic,
    this.status,
    this.orderNum,
    this.activity,
  });

  factory ActivityTabsItemBean.fromJson(Map<String, dynamic> json) =>
      _$ActivityTabsItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityTabsItemBeanToJson(this);
}

/// 活动列表数据
@JsonSerializable()
class ActivityListBean {
  ActivityListBean(this.data);

  List<ActivityListItemBean>? data;

  factory ActivityListBean.fromJson(List<dynamic>? list) {
    var result = list
        ?.map((json) =>
            ActivityListItemBean.fromJson(json as Map<String, dynamic>))
        .toList();
    return ActivityListBean(result);
  }

  List<Map<String, dynamic>> toJson() {
    return data!.map((item) => item.toJson()).toList();
  }
}

@JsonSerializable()
class ActivityListItemBean {
  ActivityListItemBean({
    this.activeName,
    this.activityName,
    this.activeType,
    this.activityType,
    this.android,
    this.apply,
    this.auto_delivery,
    this.big_sort_v,
    this.bulletin_id,
    this.bulletin_schedule_id,
    this.chan_con,
    this.content,
    this.content_type,
    this.create_time,
    this.cust_group_id,
    this.eff_time,
    this.event_apply,
    this.exp_time,
    this.game,
    this.game_task_class,
    this.game_type,
    this.ios,
    this.is_pop_up,
    this.language,
    this.link_type,
    this.ma_id,
    this.message_id,
    this.oper_code,
    this.pic_addr,
    this.platform,
    this.play_state,
    this.proxy,
    this.schedule_id,
    this.sort_v,
    this.state,
    this.state_time,
    this.subject,
    this.task_type,
    this.tid,
    this.vip_level,
    this.web,
    this.weiXin,
    this.id,
    this.actionCfg,
    this.isShowIndex,
    this.activityCategory,
    this.elotActivityPg,
  });

  String? activeName;
  String? activityName;
  String? activityType;
  num? activeType;
  bool? android;
  int? apply;
  num? auto_delivery;
  int? big_sort_v;
  int? bulletin_id;
  int? bulletin_schedule_id;
  num? chan_con;
  String? content;
  int? content_type; // ActivityContentType
  num? create_time;
  int? cust_group_id;
  num? eff_time;
  num? event_apply;
  num? exp_time;
  num? game;
  int? game_task_class; // ActivityGameType
  int? game_type; // ActivityGameType
  bool? ios;
  num? is_pop_up;
  num? language;
  int? link_type; // ActivityLinkType
  num? ma_id;
  int? message_id;
  String? oper_code;
  String? pic_addr;
  num? platform;
  num? play_state;
  num? proxy;
  int? schedule_id;
  int? sort_v;
  int? state;
  num? state_time;
  String? subject;
  int? task_type; // ActivityTaskType
  int? tid;
  int? vip_level;
  bool? web;
  bool? weiXin;
  int? id;
  String? actionCfg;
  String? isShowIndex;
  String? activityCategory;
  ActivityListItemElotBean? elotActivityPg;

  factory ActivityListItemBean.fromJson(Map<String, dynamic> json) =>
      _$ActivityListItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityListItemBeanToJson(this);

  @override
  String toString() {
    return 'ActivityListItemBean{activeName: $activeName, activityName: $activityName, activeType: $activeType, activityType: $activityType, android: $android, apply: $apply, auto_delivery: $auto_delivery, big_sort_v: $big_sort_v, bulletin_id: $bulletin_id, bulletin_schedule_id: $bulletin_schedule_id, chan_con: $chan_con, content: $content, content_type: $content_type, create_time: $create_time, cust_group_id: $cust_group_id, eff_time: $eff_time, event_apply: $event_apply, exp_time: $exp_time, game: $game, game_task_class: $game_task_class, game_type: $game_type, ios: $ios, is_pop_up: $is_pop_up, language: $language, link_type: $link_type, ma_id: $ma_id, message_id: $message_id, oper_code: $oper_code, pic_addr: $pic_addr, platform: $platform, play_state: $play_state, proxy: $proxy, schedule_id: $schedule_id, sort_v: $sort_v, state: $state, state_time: $state_time, subject: $subject, task_type: $task_type, tid: $tid, vip_level: $vip_level, web: $web, weiXin: $weiXin, id: $id, actionCfg: $actionCfg, isShowIndex: $isShowIndex, elotActivityPg: $elotActivityPg, activityCategory: $activityCategory}';
  }
}

@JsonSerializable()
class ActivityListItemElotBean {
  ActivityListItemElotBean({
    this.endTime,
    this.showAvatar,
    this.isShowAvatar,
  });

  String? endTime;
  String? showAvatar;
  String? isShowAvatar;

  factory ActivityListItemElotBean.fromJson(Map<String, dynamic> json) =>
      _$ActivityListItemElotBeanFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityListItemElotBeanToJson(this);
}
