///系统公告的实体类
class SystemNotifyBean {
  SystemNotifyBean({
    this.count,
    this.data,
  });

  SystemNotifyBean.fromJson(dynamic json) {
    count = json['count'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(SystemNotifyItemBean.fromJson(v));
      });
    }
  }
  num? count;
  List<SystemNotifyItemBean>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = count;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class SystemNotifyItemBean {
  SystemNotifyItemBean({
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

  SystemNotifyItemBean.fromJson(dynamic json) {
    bulletinId = json['bulletin_id'];
    messageId = json['message_id'];
    subject = json['subject'];
    contentType = json['content_type'];
    content = json['content'];
    chanCon = json['chan_con'];
    operCode = json['oper_code'];
    createTime = json['create_time'];
    state = json['state'];
    stateTime = json['state_time'];
    effTime = json['eff_time'];
    expTime = json['exp_time'];
    tid = json['tid'];
    title = json['title'];
    maId = json['ma_id'];
    picAddr = json['pic_addr'];
    sortV = json['sort_v'];
    custGroupId = json['cust_group_id'];
    scheduleId = json['schedule_id'];
    bulletinScheduleId = json['bulletin_schedule_id'];
    apply = json['apply'];
    activeType = json['activeType'];
    bigSortV = json['big_sort_v'];
    eventApply = json['event_apply'];
    proxy = json['proxy'];
    isPopUp = json['is_pop_up'];
    autoDelivery = json['auto_delivery'];
    linkType = json['link_type'];
    gameType = json['game_type'];
    platform = json['platform'];
    game = json['game'];
    taskType = json['task_type'];
    gameTaskClass = json['game_task_class'];
    playState = json['play_state'];
    language = json['language'];
    vipLevel = json['vip_level'];
    android = json['android'];
    ios = json['ios'];
    web = json['web'];
    weiXin = json['weiXin'];
  }
  num? bulletinId;
  num? messageId;
  String? subject;
  num? contentType;
  String? content;
  num? chanCon;
  String? operCode;
  int? createTime;
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bulletin_id'] = bulletinId;
    map['message_id'] = messageId;
    map['subject'] = subject;
    map['content_type'] = contentType;
    map['content'] = content;
    map['chan_con'] = chanCon;
    map['oper_code'] = operCode;
    map['create_time'] = createTime;
    map['state'] = state;
    map['state_time'] = stateTime;
    map['eff_time'] = effTime;
    map['exp_time'] = expTime;
    map['tid'] = tid;
    map['title'] = title;
    map['ma_id'] = maId;
    map['pic_addr'] = picAddr;
    map['sort_v'] = sortV;
    map['cust_group_id'] = custGroupId;
    map['schedule_id'] = scheduleId;
    map['bulletin_schedule_id'] = bulletinScheduleId;
    map['apply'] = apply;
    map['activeType'] = activeType;
    map['big_sort_v'] = bigSortV;
    map['event_apply'] = eventApply;
    map['proxy'] = proxy;
    map['is_pop_up'] = isPopUp;
    map['auto_delivery'] = autoDelivery;
    map['link_type'] = linkType;
    map['game_type'] = gameType;
    map['platform'] = platform;
    map['game'] = game;
    map['task_type'] = taskType;
    map['game_task_class'] = gameTaskClass;
    map['play_state'] = playState;
    map['language'] = language;
    map['vip_level'] = vipLevel;
    map['android'] = android;
    map['ios'] = ios;
    map['web'] = web;
    map['weiXin'] = weiXin;
    return map;
  }
}
