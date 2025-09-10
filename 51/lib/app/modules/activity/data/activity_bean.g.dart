// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityTabsBean _$ActivityTabsBeanFromJson(Map<String, dynamic> json) =>
    ActivityTabsBean(
      (json['data'] as List<dynamic>?)
          ?.map((e) => ActivityTabsItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['count'] as num?,
    );

Map<String, dynamic> _$ActivityTabsBeanToJson(ActivityTabsBean instance) =>
    <String, dynamic>{
      'data': instance.data,
      'count': instance.count,
    };

ActivityTabsItemBean _$ActivityTabsItemBeanFromJson(
        Map<String, dynamic> json) =>
    ActivityTabsItemBean(
      id: json['id'] as num,
      sort_v: json['sort_v'] as num?,
      tid: json['tid'] as num,
      cat: json['cat'] as String?,
      state_time: json['state_time'] as num?,
      create_time: json['create_time'] as num?,
      categoryName: json['categoryName'] as String?,
      categoryType: json['categoryType'] as String?,
      categoryPic: json['categoryPic'] as String?,
      categoryPic2: json['categoryPic2'] as String?,
      isShowCategoryPic: json['isShowCategoryPic'] as num?,
      status: json['status'] as String?,
      orderNum: json['orderNum'] as num?,
      activity: json['activity'] == null
          ? null
          : T.fromJson(json['activity'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivityTabsItemBeanToJson(
        ActivityTabsItemBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sort_v': instance.sort_v,
      'tid': instance.tid,
      'cat': instance.cat,
      'state_time': instance.state_time,
      'create_time': instance.create_time,
      'categoryName': instance.categoryName,
      'categoryType': instance.categoryType,
      'categoryPic': instance.categoryPic,
      'categoryPic2': instance.categoryPic2,
      'isShowCategoryPic': instance.isShowCategoryPic,
      'status': instance.status,
      'orderNum': instance.orderNum,
      'activity': instance.activity,
    };

ActivityListBean _$ActivityListBeanFromJson(Map<String, dynamic> json) =>
    ActivityListBean(
      (json['data'] as List<dynamic>?)
          ?.map((e) => ActivityListItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActivityListBeanToJson(ActivityListBean instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

ActivityListItemBean _$ActivityListItemBeanFromJson(
        Map<String, dynamic> json) =>
    ActivityListItemBean(
      activeName: json['activeName'] as String?,
      activityName: json['activityName'] as String?,
      activeType: json['activeType'] as num?,
      activityType: json['activityType'] as String?,
      android: json['android'] as bool?,
      apply: (json['apply'] as num?)?.toInt(),
      auto_delivery: json['auto_delivery'] as num?,
      big_sort_v: (json['big_sort_v'] as num?)?.toInt(),
      bulletin_id: (json['bulletin_id'] as num?)?.toInt(),
      bulletin_schedule_id: (json['bulletin_schedule_id'] as num?)?.toInt(),
      chan_con: json['chan_con'] as num?,
      content: json['content'] as String?,
      content_type: (json['content_type'] as num?)?.toInt(),
      create_time: json['create_time'] as num?,
      cust_group_id: (json['cust_group_id'] as num?)?.toInt(),
      eff_time: json['eff_time'] as num?,
      event_apply: json['event_apply'] as num?,
      exp_time: json['exp_time'] as num?,
      game: json['game'] as num?,
      game_task_class: (json['game_task_class'] as num?)?.toInt(),
      game_type: (json['game_type'] as num?)?.toInt(),
      ios: json['ios'] as bool?,
      is_pop_up: json['is_pop_up'] as num?,
      language: json['language'] as num?,
      link_type: (json['link_type'] as num?)?.toInt(),
      ma_id: json['ma_id'] as num?,
      message_id: (json['message_id'] as num?)?.toInt(),
      oper_code: json['oper_code'] as String?,
      pic_addr: json['pic_addr'] as String?,
      platform: json['platform'] as num?,
      play_state: json['play_state'] as num?,
      proxy: json['proxy'] as num?,
      schedule_id: (json['schedule_id'] as num?)?.toInt(),
      sort_v: (json['sort_v'] as num?)?.toInt(),
      state: (json['state'] as num?)?.toInt(),
      state_time: json['state_time'] as num?,
      subject: json['subject'] as String?,
      task_type: (json['task_type'] as num?)?.toInt(),
      tid: (json['tid'] as num?)?.toInt(),
      vip_level: (json['vip_level'] as num?)?.toInt(),
      web: json['web'] as bool?,
      weiXin: json['weiXin'] as bool?,
      id: (json['id'] as num?)?.toInt(),
      actionCfg: json['actionCfg'] as String?,
      isShowIndex: json['isShowIndex'] as String?,
      activityCategory: json['activityCategory'] as String?,
      elotActivityPg: json['elotActivityPg'] == null
          ? null
          : ActivityListItemElotBean.fromJson(
              json['elotActivityPg'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivityListItemBeanToJson(
        ActivityListItemBean instance) =>
    <String, dynamic>{
      'activeName': instance.activeName,
      'activityName': instance.activityName,
      'activityType': instance.activityType,
      'activeType': instance.activeType,
      'android': instance.android,
      'apply': instance.apply,
      'auto_delivery': instance.auto_delivery,
      'big_sort_v': instance.big_sort_v,
      'bulletin_id': instance.bulletin_id,
      'bulletin_schedule_id': instance.bulletin_schedule_id,
      'chan_con': instance.chan_con,
      'content': instance.content,
      'content_type': instance.content_type,
      'create_time': instance.create_time,
      'cust_group_id': instance.cust_group_id,
      'eff_time': instance.eff_time,
      'event_apply': instance.event_apply,
      'exp_time': instance.exp_time,
      'game': instance.game,
      'game_task_class': instance.game_task_class,
      'game_type': instance.game_type,
      'ios': instance.ios,
      'is_pop_up': instance.is_pop_up,
      'language': instance.language,
      'link_type': instance.link_type,
      'ma_id': instance.ma_id,
      'message_id': instance.message_id,
      'oper_code': instance.oper_code,
      'pic_addr': instance.pic_addr,
      'platform': instance.platform,
      'play_state': instance.play_state,
      'proxy': instance.proxy,
      'schedule_id': instance.schedule_id,
      'sort_v': instance.sort_v,
      'state': instance.state,
      'state_time': instance.state_time,
      'subject': instance.subject,
      'task_type': instance.task_type,
      'tid': instance.tid,
      'vip_level': instance.vip_level,
      'web': instance.web,
      'weiXin': instance.weiXin,
      'id': instance.id,
      'actionCfg': instance.actionCfg,
      'isShowIndex': instance.isShowIndex,
      'activityCategory': instance.activityCategory,
      'elotActivityPg': instance.elotActivityPg,
    };

ActivityListItemElotBean _$ActivityListItemElotBeanFromJson(
        Map<String, dynamic> json) =>
    ActivityListItemElotBean(
      endTime: json['endTime'] as String?,
      showAvatar: json['showAvatar'] as String?,
      isShowAvatar: json['isShowAvatar'] as String?,
    );

Map<String, dynamic> _$ActivityListItemElotBeanToJson(
        ActivityListItemElotBean instance) =>
    <String, dynamic>{
      'endTime': instance.endTime,
      'showAvatar': instance.showAvatar,
      'isShowAvatar': instance.isShowAvatar,
    };
