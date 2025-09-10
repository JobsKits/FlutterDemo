import 'package:json_annotation/json_annotation.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
  @JsonKey(name: 'bulletin_id')
  int? bulletinId;
  @JsonKey(name: 'message_id')
  int? messageId;
  String? subject;
  @JsonKey(name: 'content_type')
  int? contentType;
  String? content;
  @JsonKey(name: 'chan_con')
  int? chanCon;
  @JsonKey(name: 'oper_code')
  String? operCode;
  @JsonKey(name: 'create_time')
  int? createTime;
  int? state;
  @JsonKey(name: 'state_time')
  int? stateTime;
  @JsonKey(name: 'eff_time')
  int? effTime;
  @JsonKey(name: 'exp_time')
  int? expTime;
  int? tid;
  String? title;
  @JsonKey(name: 'ma_id')
  int? maId;
  @JsonKey(name: 'pic_addr')
  String? picAddr;
  @JsonKey(name: 'sort_v')
  int? sortV;
  @JsonKey(name: 'cust_group_id')
  int? custGroupId;
  @JsonKey(name: 'schedule_id')
  int? scheduleId;
  @JsonKey(name: 'bulletin_schedule_id')
  int? bulletinScheduleId;
  int? apply;
  int? activeType;
  @JsonKey(name: 'big_sort_v')
  int? bigSortV;
  @JsonKey(name: 'event_apply')
  int? eventApply;
  int? proxy;
  @JsonKey(name: 'is_pop_up')
  int? isPopUp;
  @JsonKey(name: 'auto_delivery')
  int? autoDelivery;
  @JsonKey(name: 'link_type')
  int? linkType;
  @JsonKey(name: 'game_type')
  int? gameType;
  int? platform;
  int? game;
  @JsonKey(name: 'task_type')
  int? taskType;
  @JsonKey(name: 'game_task_class')
  int? gameTaskClass;
  @JsonKey(name: 'play_state')
  int? playState;
  int? language;
  @JsonKey(name: 'vip_level')
  int? vipLevel;
  bool? android;
  bool? ios;
  bool? web;
  bool? weiXin;

  Datum({
    this.bulletinId,
    this.messageId,
    this.subject,
    this.contentType,
    this.content,
    this.chanCon,
    this.operCode,
    this.createTime,
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
  });

  @override
  String toString() {
    return 'Datum(bulletinId: $bulletinId, messageId: $messageId, subject: $subject, contentType: $contentType, content: $content, chanCon: $chanCon, operCode: $operCode, createTime: $createTime, state: $state, stateTime: $stateTime, effTime: $effTime, expTime: $expTime, tid: $tid, title: $title, maId: $maId, picAddr: $picAddr, sortV: $sortV, custGroupId: $custGroupId, scheduleId: $scheduleId, bulletinScheduleId: $bulletinScheduleId, apply: $apply, activeType: $activeType, bigSortV: $bigSortV, eventApply: $eventApply, proxy: $proxy, isPopUp: $isPopUp, autoDelivery: $autoDelivery, linkType: $linkType, gameType: $gameType, platform: $platform, game: $game, taskType: $taskType, gameTaskClass: $gameTaskClass, playState: $playState, language: $language, vipLevel: $vipLevel, android: $android, ios: $ios, web: $web, weiXin: $weiXin)';
  }

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);

  Datum copyWith({
    int? bulletinId,
    int? messageId,
    String? subject,
    int? contentType,
    String? content,
    int? chanCon,
    String? operCode,
    int? createTime,
    int? state,
    int? stateTime,
    int? effTime,
    int? expTime,
    int? tid,
    String? title,
    int? maId,
    String? picAddr,
    int? sortV,
    int? custGroupId,
    int? scheduleId,
    int? bulletinScheduleId,
    int? apply,
    int? activeType,
    int? bigSortV,
    int? eventApply,
    int? proxy,
    int? isPopUp,
    int? autoDelivery,
    int? linkType,
    int? gameType,
    int? platform,
    int? game,
    int? taskType,
    int? gameTaskClass,
    int? playState,
    int? language,
    int? vipLevel,
    bool? android,
    bool? ios,
    bool? web,
    bool? weiXin,
  }) {
    return Datum(
      bulletinId: bulletinId ?? this.bulletinId,
      messageId: messageId ?? this.messageId,
      subject: subject ?? this.subject,
      contentType: contentType ?? this.contentType,
      content: content ?? this.content,
      chanCon: chanCon ?? this.chanCon,
      operCode: operCode ?? this.operCode,
      createTime: createTime ?? this.createTime,
      state: state ?? this.state,
      stateTime: stateTime ?? this.stateTime,
      effTime: effTime ?? this.effTime,
      expTime: expTime ?? this.expTime,
      tid: tid ?? this.tid,
      title: title ?? this.title,
      maId: maId ?? this.maId,
      picAddr: picAddr ?? this.picAddr,
      sortV: sortV ?? this.sortV,
      custGroupId: custGroupId ?? this.custGroupId,
      scheduleId: scheduleId ?? this.scheduleId,
      bulletinScheduleId: bulletinScheduleId ?? this.bulletinScheduleId,
      apply: apply ?? this.apply,
      activeType: activeType ?? this.activeType,
      bigSortV: bigSortV ?? this.bigSortV,
      eventApply: eventApply ?? this.eventApply,
      proxy: proxy ?? this.proxy,
      isPopUp: isPopUp ?? this.isPopUp,
      autoDelivery: autoDelivery ?? this.autoDelivery,
      linkType: linkType ?? this.linkType,
      gameType: gameType ?? this.gameType,
      platform: platform ?? this.platform,
      game: game ?? this.game,
      taskType: taskType ?? this.taskType,
      gameTaskClass: gameTaskClass ?? this.gameTaskClass,
      playState: playState ?? this.playState,
      language: language ?? this.language,
      vipLevel: vipLevel ?? this.vipLevel,
      android: android ?? this.android,
      ios: ios ?? this.ios,
      web: web ?? this.web,
      weiXin: weiXin ?? this.weiXin,
    );
  }
}
