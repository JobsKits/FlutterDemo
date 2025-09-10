class TenantBean {
  TenantBean({
    this.domainTenantId,
    this.domainAddr,
    this.des,
    required this.tid,
    this.state,
    this.createTime,
    this.stateTime,
    this.kidnapCollocation,
    this.xmppOuter,
    this.chanCode,
    this.sysOptions,
    this.weight,
    this.tenant,
    required this.clustersId,
    this.isPromote,
    this.isDelay,
    required this.imgsDomain,
    this.proxy,
    this.area,
    this.rate,
    this.logoManage,
    this.music,
    this.listFeel,
    this.customer,
    this.customerNumber,
    this.isSpare,
    this.cannotLoginAgent,
    this.friendAddLimit,
    this.listShow,
    this.todaycount,
    this.zrcount,
    this.moncount,
    this.zctodaycount,
    this.zczrcount,
    this.zcmoncount,
    this.all,
    this.rightIds,
    this.liveSys,
    this.isOpenVideo,
    this.appDisplayAd,
    this.appDisplayAdUrl,
  });

  TenantBean.fromJson(dynamic json) {
    domainTenantId = json['domain_tenant_id'];
    domainAddr = json['domain_addr'];
    des = json['des'];
    tid = json['tid'];
    state = json['state'];
    createTime = json['create_time'];
    stateTime = json['state_time'];
    kidnapCollocation = json['kidnap_collocation'];
    xmppOuter = json['xmpp_outer'];
    chanCode = json['chan_code'];
    sysOptions = json['sysOptions'] != null
        ? SysOptions.fromJson(json['sysOptions'])
        : null;
    weight = json['weight'];
    tenant = json['tenant'] != null ? Tenant.fromJson(json['tenant']) : null;
    clustersId = json['clusters_id'];
    isPromote = json['is_promote'];
    isDelay = json['is_delay'];
    if (json['imgs_domain'] != null) {
      imgsDomain = [];
      json['imgs_domain'].forEach((v) {
        imgsDomain?.add(ImgsDomain.fromJson(v));
      });
    }
    proxy = json['proxy'];
    area = json['area'];
    rate = json['rate'];
    if (json['logo_manage'] != null) {
      logoManage = [];
      json['logo_manage'].forEach((v) {
        logoManage?.add(LogoManage.fromJson(v));
      });
    }
    music = json['music'];
    listFeel = json['listFeel'];
    customer = json['customer'];
    customerNumber = json['customerNumber'];
    isSpare = json['is_spare'];
    cannotLoginAgent = json['cannot_login_agent'];
    friendAddLimit = json['friend_add_limit'];
    if (json['listShow'] != null) {
      listShow = [];
      json['listShow'].forEach((v) {
        listShow?.add(ListShow.fromJson(v));
      });
    }
    todaycount = json['todaycount'];
    zrcount = json['zrcount'];
    moncount = json['moncount'];
    zctodaycount = json['zctodaycount'];
    zczrcount = json['zczrcount'];
    zcmoncount = json['zcmoncount'];
    all = json['all'];
    rightIds = json['rightIds'] != null ? json['rightIds'].cast<int>() : [];
    liveSys = json['liveSys'];
    isOpenVideo = json['isOpenVideo'];
    appDisplayAd = json['app_display_ad'];
    appDisplayAdUrl = json['app_display_ad_url'];
  }
  int? domainTenantId;
  String? domainAddr;
  String? des;
  late final int tid;
  int? state;
  int? createTime;
  int? stateTime;
  String? kidnapCollocation;
  String? xmppOuter;
  String? chanCode;
  SysOptions? sysOptions;
  int? weight;
  Tenant? tenant;
  late final int clustersId;
  int? isPromote;
  String? isDelay;
  late final List<ImgsDomain> imgsDomain;
  int? proxy;
  String? area;
  String? rate;
  List<LogoManage>? logoManage;
  String? music;
  String? listFeel;
  String? customer;
  String? customerNumber;
  String? isSpare;
  String? cannotLoginAgent;
  String? friendAddLimit;
  List<ListShow>? listShow;
  int? todaycount;
  int? zrcount;
  int? moncount;
  int? zctodaycount;
  int? zczrcount;
  int? zcmoncount;
  int? all;
  List<int>? rightIds;
  bool? liveSys;
  String? isOpenVideo;
  String? appDisplayAd;
  String? appDisplayAdUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['domain_tenant_id'] = domainTenantId;
    map['domain_addr'] = domainAddr;
    map['des'] = des;
    map['tid'] = tid;
    map['state'] = state;
    map['create_time'] = createTime;
    map['state_time'] = stateTime;
    map['kidnap_collocation'] = kidnapCollocation;
    map['xmpp_outer'] = xmppOuter;
    map['chan_code'] = chanCode;
    if (sysOptions != null) {
      map['sysOptions'] = sysOptions?.toJson();
    }
    map['weight'] = weight;
    if (tenant != null) {
      map['tenant'] = tenant?.toJson();
    }
    map['clusters_id'] = clustersId;
    map['is_promote'] = isPromote;
    map['is_delay'] = isDelay;
    if (imgsDomain != null) {
      map['imgs_domain'] = imgsDomain?.map((v) => v.toJson()).toList();
    }
    map['proxy'] = proxy;
    map['area'] = area;
    map['rate'] = rate;
    if (logoManage != null) {
      map['logo_manage'] = logoManage?.map((v) => v.toJson()).toList();
    }
    map['music'] = music;
    map['listFeel'] = listFeel;
    map['customer'] = customer;
    map['customerNumber'] = customerNumber;
    map['is_spare'] = isSpare;
    map['cannot_login_agent'] = cannotLoginAgent;
    map['friend_add_limit'] = friendAddLimit;
    if (listShow != null) {
      map['listShow'] = listShow?.map((v) => v.toJson()).toList();
    }
    map['todaycount'] = todaycount;
    map['zrcount'] = zrcount;
    map['moncount'] = moncount;
    map['zctodaycount'] = zctodaycount;
    map['zczrcount'] = zczrcount;
    map['zcmoncount'] = zcmoncount;
    map['all'] = all;
    map['rightIds'] = rightIds;
    map['liveSys'] = liveSys;
    map['isOpenVideo'] = isOpenVideo;
    map['app_display_ad'] = appDisplayAd;
    map['app_display_ad_url'] = appDisplayAdUrl;
    return map;
  }
}

class ListShow {
  ListShow(
      {this.confId,
      this.proxy,
      required this.name,
      required this.cname,
      this.showPc,
      required this.showMobile,
      this.state,
      this.stateTime,
      this.createTime,
      this.sortV,
      this.operCode,
      this.tid,
      this.showDes,
      this.detail});

  ListShow.fromJson(dynamic json) {
    confId = json['conf_id'];
    proxy = json['proxy'];
    name = json['name'];
    cname = json['cname'];
    showPc = json['show_pc'];
    showMobile = json['show_mobile'];
    state = json['state'];
    stateTime = json['state_time'];
    createTime = json['create_time'];
    sortV = json['sort_v'];
    operCode = json['oper_code'];
    tid = json['tid'];
    showDes = json['show_des'];
    detail = json['detail'];
  }
  int? confId;
  int? proxy;
  late final String name;
  late final String cname;
  int? showPc;
  late final int showMobile;
  int? state;
  int? stateTime;
  int? createTime;
  int? sortV;
  String? operCode;
  int? tid;
  String? showDes;
  String? detail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['conf_id'] = confId;
    map['proxy'] = proxy;
    map['name'] = name;
    map['cname'] = cname;
    map['show_pc'] = showPc;
    map['show_mobile'] = showMobile;
    map['state'] = state;
    map['state_time'] = stateTime;
    map['create_time'] = createTime;
    map['sort_v'] = sortV;
    map['oper_code'] = operCode;
    map['tid'] = tid;
    map['show_des'] = showDes;
    map['detail'] = detail;
    return map;
  }
}

class LogoManage {
  LogoManage({
    this.bulletinId,
    this.messageId,
    this.subject,
    this.contentType,
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

  LogoManage.fromJson(dynamic json) {
    bulletinId = json['bulletin_id'];
    messageId = json['message_id'];
    subject = json['subject'];
    contentType = json['content_type'];
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
  int? bulletinId;
  int? messageId;
  String? subject;
  int? contentType;
  int? chanCon;
  String? operCode;
  int? createTime;
  int? state;
  int? stateTime;
  int? effTime;
  int? expTime;
  int? tid;
  String? title;
  int? maId;
  String? picAddr;
  int? sortV;
  int? custGroupId;
  int? scheduleId;
  int? bulletinScheduleId;
  int? apply;
  int? activeType;
  int? bigSortV;
  int? eventApply;
  int? proxy;
  int? isPopUp;
  int? autoDelivery;
  int? linkType;
  int? gameType;
  int? platform;
  int? game;
  int? taskType;
  int? gameTaskClass;
  int? playState;
  int? language;
  int? vipLevel;
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

class ImgsDomain {
  ImgsDomain({
    this.domainLineId,
    required this.domainAddr,
    this.domainIp,
    this.domainType,
    this.callbackAddr,
    this.weight,
    this.chanCode,
    this.clustersId,
    this.state,
    this.stateTime,
    this.operCode,
    this.createTime,
    this.tid,
    this.spareAddr,
  });

  ImgsDomain.fromJson(dynamic json) {
    domainLineId = json['domain_line_id'];
    domainAddr = json['domain_addr'];
    domainIp = json['domain_ip'];
    domainType = json['domain_type'];
    callbackAddr = json['callback_addr'];
    weight = json['weight'];
    chanCode = json['chan_code'];
    clustersId = json['clusters_id'];
    state = json['state'];
    stateTime = json['state_time'];
    operCode = json['oper_code'];
    createTime = json['create_time'];
    tid = json['tid'];
    spareAddr = json['spare_addr'];
  }
  int? domainLineId;
  late final String domainAddr;
  String? domainIp;
  int? domainType;
  String? callbackAddr;
  int? weight;
  String? chanCode;
  int? clustersId;
  int? state;
  int? stateTime;
  String? operCode;
  int? createTime;
  int? tid;
  String? spareAddr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['domain_line_id'] = domainLineId;
    map['domain_addr'] = domainAddr;
    map['domain_ip'] = domainIp;
    map['domain_type'] = domainType;
    map['callback_addr'] = callbackAddr;
    map['weight'] = weight;
    map['chan_code'] = chanCode;
    map['clusters_id'] = clustersId;
    map['state'] = state;
    map['state_time'] = stateTime;
    map['oper_code'] = operCode;
    map['create_time'] = createTime;
    map['tid'] = tid;
    map['spare_addr'] = spareAddr;
    return map;
  }
}

class Tenant {
  Tenant({
    this.tid,
    this.tenantName,
    this.tenantDes,
    this.xmpp,
    this.wdid,
    this.rdid,
    this.state,
    this.createTime,
    this.effTime,
    this.expTime,
    this.xmppOuter,
    this.dividendTt,
    this.officialAddr,
    this.qq,
    this.weixin,
    this.phone,
    this.email,
    this.onlineAddr,
    this.appRegAddr,
    this.operCode,
    this.modifyTime,
    this.resLoc,
    this.oddsRatio,
    this.agentModel,
    this.clustersId,
    this.qqAgent,
    this.activityAddress,
    this.openingNetwork,
    this.themeType,
    this.whatsApp,
    this.telegram,
    this.facebook,
    this.zalo,
    this.type,
    this.line,
    this.youtube,
    this.twitter,
    this.tiktok,
    this.instagram,
    this.changeLogId,
    this.moveCustType,
    this.count,
    this.type1,
    this.type2,
    this.type3,
    this.onlineAddr1,
    this.onlineAddr2,
    this.onlineAddr3,
    this.zhjyType,
    this.zhjyType1,
    this.zhjyType2,
    this.zhjyType3,
    this.activityAddress1,
    this.activityAddress2,
    this.activityAddress3,
    this.officialAddr1,
    this.officialAddr2,
    this.officialAddr3,
    this.appRegAddr1,
    this.appRegAddr2,
    this.appRegAddr3,
  });

  Tenant.fromJson(dynamic json) {
    tid = json['tid'];
    tenantName = json['tenant_name'];
    tenantDes = json['tenant_des'];
    xmpp = json['xmpp'];
    wdid = json['wdid'];
    rdid = json['rdid'];
    state = json['state'];
    createTime = json['create_time'];
    effTime = json['eff_time'];
    expTime = json['exp_time'];
    xmppOuter = json['xmpp_outer'];
    dividendTt = json['dividend_tt'];
    officialAddr = json['official_addr'];
    qq = json['qq'];
    weixin = json['weixin'];
    phone = json['phone'];
    email = json['email'];
    onlineAddr = json['online_addr'];
    appRegAddr = json['app_reg_addr'];
    operCode = json['oper_code'];
    modifyTime = json['modify_time'];
    resLoc = json['res_loc'];
    oddsRatio = json['odds_ratio'];
    agentModel = json['agent_model'];
    clustersId = json['clusters_id'];
    qqAgent = json['qq_agent'];
    activityAddress = json['activity_address'];
    openingNetwork = json['opening_network'];
    themeType = json['theme_type'];
    whatsApp = json['whatsApp'];
    telegram = json['telegram'];
    facebook = json['facebook'];
    zalo = json['zalo'];
    type = json['type'];
    line = json['line'];
    youtube = json['youtube'];
    twitter = json['twitter'];
    tiktok = json['tiktok'];
    instagram = json['instagram'];
    changeLogId = json['change_log_id'];
    moveCustType = json['move_cust_type'];
    count = json['count'];
    type1 = json['type1'];
    type2 = json['type2'];
    type3 = json['type3'];
    onlineAddr1 = json['online_addr1'];
    onlineAddr2 = json['online_addr2'];
    onlineAddr3 = json['online_addr3'];
    zhjyType = json['zhjy_type'];
    zhjyType1 = json['zhjy_type1'];
    zhjyType2 = json['zhjy_type2'];
    zhjyType3 = json['zhjy_type3'];
    activityAddress1 = json['activity_address1'];
    activityAddress2 = json['activity_address2'];
    activityAddress3 = json['activity_address3'];
    officialAddr1 = json['official_addr1'];
    officialAddr2 = json['official_addr2'];
    officialAddr3 = json['official_addr3'];
    appRegAddr1 = json['app_reg_addr1'];
    appRegAddr2 = json['app_reg_addr2'];
    appRegAddr3 = json['app_reg_addr3'];
  }
  int? tid;
  String? tenantName;
  String? tenantDes;
  String? xmpp;
  int? wdid;
  int? rdid;
  int? state;
  int? createTime;
  int? effTime;
  int? expTime;
  String? xmppOuter;
  int? dividendTt;
  String? officialAddr;
  String? qq;
  String? weixin;
  String? phone;
  String? email;
  String? onlineAddr;
  String? appRegAddr;
  String? operCode;
  int? modifyTime;
  String? resLoc;
  int? oddsRatio;
  int? agentModel;
  int? clustersId;
  String? qqAgent;
  String? activityAddress;
  String? openingNetwork;
  int? themeType;
  String? whatsApp;
  String? telegram;
  String? facebook;
  String? zalo;
  int? type;
  String? line;
  String? youtube;
  String? twitter;
  String? tiktok;
  String? instagram;
  int? changeLogId;
  int? moveCustType;
  int? count;
  int? type1;
  int? type2;
  int? type3;
  String? onlineAddr1;
  String? onlineAddr2;
  String? onlineAddr3;
  int? zhjyType;
  int? zhjyType1;
  int? zhjyType2;
  int? zhjyType3;
  String? activityAddress1;
  String? activityAddress2;
  String? activityAddress3;
  String? officialAddr1;
  String? officialAddr2;
  String? officialAddr3;
  String? appRegAddr1;
  String? appRegAddr2;
  String? appRegAddr3;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tid'] = tid;
    map['tenant_name'] = tenantName;
    map['tenant_des'] = tenantDes;
    map['xmpp'] = xmpp;
    map['wdid'] = wdid;
    map['rdid'] = rdid;
    map['state'] = state;
    map['create_time'] = createTime;
    map['eff_time'] = effTime;
    map['exp_time'] = expTime;
    map['xmpp_outer'] = xmppOuter;
    map['dividend_tt'] = dividendTt;
    map['official_addr'] = officialAddr;
    map['qq'] = qq;
    map['weixin'] = weixin;
    map['phone'] = phone;
    map['email'] = email;
    map['online_addr'] = onlineAddr;
    map['app_reg_addr'] = appRegAddr;
    map['oper_code'] = operCode;
    map['modify_time'] = modifyTime;
    map['res_loc'] = resLoc;
    map['odds_ratio'] = oddsRatio;
    map['agent_model'] = agentModel;
    map['clusters_id'] = clustersId;
    map['qq_agent'] = qqAgent;
    map['activity_address'] = activityAddress;
    map['opening_network'] = openingNetwork;
    map['theme_type'] = themeType;
    map['whatsApp'] = whatsApp;
    map['telegram'] = telegram;
    map['facebook'] = facebook;
    map['zalo'] = zalo;
    map['type'] = type;
    map['line'] = line;
    map['youtube'] = youtube;
    map['twitter'] = twitter;
    map['tiktok'] = tiktok;
    map['instagram'] = instagram;
    map['change_log_id'] = changeLogId;
    map['move_cust_type'] = moveCustType;
    map['count'] = count;
    map['type1'] = type1;
    map['type2'] = type2;
    map['type3'] = type3;
    map['online_addr1'] = onlineAddr1;
    map['online_addr2'] = onlineAddr2;
    map['online_addr3'] = onlineAddr3;
    map['zhjy_type'] = zhjyType;
    map['zhjy_type1'] = zhjyType1;
    map['zhjy_type2'] = zhjyType2;
    map['zhjy_type3'] = zhjyType3;
    map['activity_address1'] = activityAddress1;
    map['activity_address2'] = activityAddress2;
    map['activity_address3'] = activityAddress3;
    map['official_addr1'] = officialAddr1;
    map['official_addr2'] = officialAddr2;
    map['official_addr3'] = officialAddr3;
    map['app_reg_addr1'] = appRegAddr1;
    map['app_reg_addr2'] = appRegAddr2;
    map['app_reg_addr3'] = appRegAddr3;
    return map;
  }

  @override
  String toString() {
    return 'Tenant{tid: $tid, tenantName: $tenantName, tenantDes: $tenantDes, xmpp: $xmpp, wdid: $wdid, rdid: $rdid, state: $state, createTime: $createTime, effTime: $effTime, expTime: $expTime, xmppOuter: $xmppOuter, dividendTt: $dividendTt, officialAddr: $officialAddr, qq: $qq, weixin: $weixin, phone: $phone, email: $email, onlineAddr: $onlineAddr, appRegAddr: $appRegAddr, operCode: $operCode, modifyTime: $modifyTime, resLoc: $resLoc, oddsRatio: $oddsRatio, agentModel: $agentModel, clustersId: $clustersId, qqAgent: $qqAgent, activityAddress: $activityAddress, openingNetwork: $openingNetwork, themeType: $themeType, whatsApp: $whatsApp, telegram: $telegram, facebook: $facebook, zalo: $zalo, type: $type, line: $line, youtube: $youtube, twitter: $twitter, tiktok: $tiktok, instagram: $instagram, changeLogId: $changeLogId, moveCustType: $moveCustType, count: $count, type1: $type1, type2: $type2, type3: $type3, onlineAddr1: $onlineAddr1, onlineAddr2: $onlineAddr2, onlineAddr3: $onlineAddr3, zhjyType: $zhjyType, zhjyType1: $zhjyType1, zhjyType2: $zhjyType2, zhjyType3: $zhjyType3, activityAddress1: $activityAddress1, activityAddress2: $activityAddress2, activityAddress3: $activityAddress3, officialAddr1: $officialAddr1, officialAddr2: $officialAddr2, officialAddr3: $officialAddr3, appRegAddr1: $appRegAddr1, appRegAddr2: $appRegAddr2, appRegAddr3: $appRegAddr3}';
  }
}

class SysOptions {
  SysOptions({
    this.playplanrestrictrewardpertermcodepk,
    this.custregisterpasswordmode,
    this.pricingmethod,
    this.waihuitypedata,
    this.betamountunit,
    this.issd1,
    this.issd2,
    this.gmtsys1,
    this.gmtsys2,
    this.lotteryrebate,
    this.chargedesc2,
    this.custcontactlist,
    this.loginRegis,
    this.chargedesc1,
    this.custhtmlstr,
    this.playplanrestrictrewardpertermcode,
    this.onlinenumberpeople2,
    this.languageisdisplay,
    this.onlinenumberpeople1,
    this.custloginspecialcaptcha,
    this.bigWinGameRecommend,
    this.smsopencountry,
    this.pumpingnegativeprofit,
    this.custloginmode,
    this.custlogincaptchamode,
    this.isvirtualcurrencyversion1,
    this.isvirtualcurrencyversion2,
    this.option_code,
    this.registerShowMethodSwitch,
    this.loginMethodSwitch,
    this.customerServiceSkipType,
    this.YIDUN_CAPTCHA_ID
  });

  SysOptions.fromJson(dynamic json) {
    playplanrestrictrewardpertermcodepk =
        json['PLAYPLAN_RESTRICT_REWARD_PER_TERMCODE_PK'];
    custregisterpasswordmode = json['CUST_REGISTER_PASSWORD_MODE'];
    pricingmethod = json['PRICING_METHOD'];
    waihuitypedata = json['WAIHUI_TYPE_DATA'];
    betamountunit = json['BET_AMOUNT_UNIT'];
    issd1 = json['IS_SD_1'];
    issd2 = json['IS_SD_2'];
    gmtsys1 = json['GMT_SYS_1'];
    gmtsys2 = json['GMT_SYS_2'];
    lotteryrebate = json['LOTTERY_REBATE'];
    chargedesc2 = json['CHARGE_DESC_2'];
    custcontactlist = json['CUST_CONTACT_LIST'];
    loginRegis = json['login_regis'];
    chargedesc1 = json['CHARGE_DESC_1'];
    custhtmlstr = json['CUST_HTML_STR'];
    playplanrestrictrewardpertermcode =
        json['PLAYPLAN_RESTRICT_REWARD_PER_TERMCODE'];
    onlinenumberpeople2 = json['ONLINE_NUMBER_PEOPLE_2'];
    languageisdisplay = json['LANGUAGE_IS_DISPLAY'];
    onlinenumberpeople1 = json['ONLINE_NUMBER_PEOPLE_1'];
    custloginspecialcaptcha = json['CUST_LOGIN_SPECIAL_CAPTCHA'];
    bigWinGameRecommend = json['BIG_WIN_GAME_RECOMMEND'];
    smsopencountry = json['SMS_OPEN_COUNTRY'];
    pumpingnegativeprofit = json['PUMPING_NEGATIVE_PROFIT'];
    custloginmode = json['CUST_LOGIN_MODE'];
    custlogincaptchamode = json['CUST_LOGIN_CAPTCHA_MODE'];
    isvirtualcurrencyversion1 = json['IS_VIRTUAL_CURRENCY_VERSION_1'];
    isvirtualcurrencyversion2 = json['IS_VIRTUAL_CURRENCY_VERSION_2'];
    option_code = json['OPEN_HOT_PLATFORM'];
    loginMethodSwitch = json['LOGIN_METHOD_SWITCH'];
    registerShowMethodSwitch = json['REGISTER_SHOW_METHOD_SWITCH'];
    customerServiceSkipType = json['CUSTOMER_SERVICE_SKIP_TYPE'];
    YIDUN_CAPTCHA_ID = json['YIDUN_CAPTCHA_ID'];
  }
  int? playplanrestrictrewardpertermcodepk;
  String? custregisterpasswordmode;
  String? pricingmethod;
  String? waihuitypedata;
  String? betamountunit;
  String? issd1;
  String? issd2;
  String? gmtsys1;
  String? gmtsys2;
  String? lotteryrebate;
  String? chargedesc2;
  String? custcontactlist;
  String? loginRegis;
  String? chargedesc1;
  String? custhtmlstr;
  int? playplanrestrictrewardpertermcode;
  String? onlinenumberpeople2;
  String? languageisdisplay;
  String? onlinenumberpeople1;
  String? custloginspecialcaptcha;
  String? bigWinGameRecommend;
  String? smsopencountry;
  String? pumpingnegativeprofit;
  String? custloginmode;
  String? custlogincaptchamode;
  String? isvirtualcurrencyversion1;
  String? isvirtualcurrencyversion2;
  num? option_code;
  String? registerShowMethodSwitch;
  String? loginMethodSwitch;
  String? customerServiceSkipType;
  String? YIDUN_CAPTCHA_ID;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PLAYPLAN_RESTRICT_REWARD_PER_TERMCODE_PK'] =
        playplanrestrictrewardpertermcodepk;
    map['CUST_REGISTER_PASSWORD_MODE'] = custregisterpasswordmode;
    map['PRICING_METHOD'] = pricingmethod;
    map['WAIHUI_TYPE_DATA'] = waihuitypedata;
    map['BET_AMOUNT_UNIT'] = betamountunit;
    map['IS_SD_1'] = issd1;
    map['IS_SD_2'] = issd2;
    map['GMT_SYS_1'] = gmtsys1;
    map['GMT_SYS_2'] = gmtsys2;
    map['LOTTERY_REBATE'] = lotteryrebate;
    map['CHARGE_DESC_2'] = chargedesc2;
    map['CUST_CONTACT_LIST'] = custcontactlist;
    map['login_regis'] = loginRegis;
    map['CHARGE_DESC_1'] = chargedesc1;
    map['CUST_HTML_STR'] = custhtmlstr;
    map['PLAYPLAN_RESTRICT_REWARD_PER_TERMCODE'] =
        playplanrestrictrewardpertermcode;
    map['ONLINE_NUMBER_PEOPLE_2'] = onlinenumberpeople2;
    map['LANGUAGE_IS_DISPLAY'] = languageisdisplay;
    map['ONLINE_NUMBER_PEOPLE_1'] = onlinenumberpeople1;
    map['CUST_LOGIN_SPECIAL_CAPTCHA'] = custloginspecialcaptcha;
    map['BIG_WIN_GAME_RECOMMEND'] = bigWinGameRecommend;
    map['SMS_OPEN_COUNTRY'] = smsopencountry;
    map['PUMPING_NEGATIVE_PROFIT'] = pumpingnegativeprofit;
    map['CUST_LOGIN_MODE'] = custloginmode;
    map['CUST_LOGIN_CAPTCHA_MODE'] = custlogincaptchamode;
    map['IS_VIRTUAL_CURRENCY_VERSION_1'] = isvirtualcurrencyversion1;
    map['IS_VIRTUAL_CURRENCY_VERSION_2'] = isvirtualcurrencyversion2;
    map['OPEN_HOT_PLATFORM'] = option_code;
    map['LOGIN_METHOD_SWITCH'] = loginMethodSwitch;
    map['REGISTER_SHOW_METHOD_SWITCH'] = registerShowMethodSwitch;
    map['CUSTOMER_SERVICE_SKIP_TYPE'] = customerServiceSkipType;
    map['YIDUN_CAPTCHA_ID'] = YIDUN_CAPTCHA_ID;
    return map;
  }
}

class AseqBean {
  AseqBean({
    this.appType,
    this.aseqId,
    this.basicSettings,
    this.chanCode,
    this.collectState,
    this.downloadMethod,
    this.downloadUrl,
    this.fileSize,
    this.gameManagement,
    this.iosDownloadUrl,
    this.isMandatoryUpate,
    this.lastVersionSerial,
    this.magicKey,
    this.menuManagement,
    this.oldVersionSerial,
    this.regAddr,
    this.remark,
    this.renewalContent,
    this.shareUrl,
    this.state,
    this.tid,
    this.updateState,
    this.updateType,
    this.versionCode,
    this.versionDigest,
    this.versionName,
    this.versionSerial,
    this.wappayState,
  });

  num? appType;
  num? aseqId;
  String? basicSettings;
  String? chanCode;
  num? collectState;
  num? downloadMethod;
  String? downloadUrl;
  num? fileSize;
  String? gameManagement;
  String? iosDownloadUrl;
  num? isMandatoryUpate;
  num? lastVersionSerial;
  num? oldVersionSerial;
  String? magicKey;
  String? menuManagement;
  String? regAddr;
  String? remark;
  String? renewalContent;
  String? shareUrl;
  num? state;
  num? tid;
  num? updateState;
  num? updateType;
  String? versionCode;
  String? versionDigest;
  String? versionName;
  num? versionSerial;
  num? wappayState;

  AseqBean.fromJson(dynamic json) {
    appType = json['app_type'];
    aseqId = json['aseq_id'];
    basicSettings = json['basic_settings'];
    chanCode = json['chan_code'];
    collectState = json['collect_state'];
    downloadMethod = json['download_method'];
    downloadUrl = json['download_url'];
    fileSize = json['filesize'];
    gameManagement = json['game_management'];
    iosDownloadUrl = json['ios_download_url'];
    isMandatoryUpate = json['is_mandatory_upate'];
    lastVersionSerial = json['last_version_serial'];
    oldVersionSerial = json['old_version_serial'];
    magicKey = json['magic_key'];
    menuManagement = json['menu_management'];
    regAddr = json['reg_addr'];
    remark = json['remark'];
    renewalContent = json['renewal_content'];
    shareUrl = json['share_url'];
    state = json['state'];
    tid = json['tid'];
    updateState = json['update_state'];
    updateType = json['update_type'];
    versionCode = json['version_code'];
    versionDigest = json['version_digest'];
    versionName = json['version_name'];
    versionSerial = json['version_serial'];
    wappayState = json['wappay_state'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['app_type'] = appType;
    map['aseq_id'] = aseqId;
    map['basic_settings'] = basicSettings;
    map['chan_code'] = chanCode;
    map['collect_state'] = collectState;
    map['download_method'] = downloadMethod;
    map['download_url'] = downloadUrl;
    map['filesize'] = fileSize;
    map['game_management'] = gameManagement;
    map['ios_download_url'] = iosDownloadUrl;
    map['is_mandatory_upate'] = isMandatoryUpate;
    map['last_version_serial'] = lastVersionSerial;
    map['old_version_serial'] = oldVersionSerial;
    map['magic_key'] = magicKey;
    map['menu_management'] = menuManagement;
    map['reg_addr'] = regAddr;
    map['remark'] = remark;
    map['renewal_content'] = renewalContent;
    map['share_url'] = shareUrl;
    map['state'] = state;
    map['tid'] = tid;
    map['update_state'] = updateState;
    map['update_type'] = updateType;
    map['version_code'] = versionCode;
    map['version_digest'] = versionDigest;
    map['version_name'] = versionName;
    map['version_serial'] = versionSerial;
    map['wappay_state'] = wappayState;
    return map;
  }
}
