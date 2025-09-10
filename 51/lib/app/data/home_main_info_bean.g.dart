// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_main_info_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeMainInfoBean _$HomeMainInfoBeanFromJson(Map<String, dynamic> json) =>
    HomeMainInfoBean(
      news: json['news'] == null
          ? null
          : BannerAndAnnouncementBean.fromJson(
              json['news'] as Map<String, dynamic>),
      banners: json['banners'] as Map<String, dynamic>?,
      thirdGames: (json['thirdGames'] as List<dynamic>?)
          ?.map((e) => ThirdGamesItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      homeHotGames: json['homeHotGames'] == null
          ? null
          : HomeHotGameBean.fromJson(
              json['homeHotGames'] as Map<String, dynamic>),
      version_type: (json['version_type'] as List<dynamic>?)
          ?.map((e) => VersionTypeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      gameState: json['gameState'] == null
          ? null
          : GameStateBean.fromJson(json['gameState'] as Map<String, dynamic>),
      gamesTry: (json['gamesTry'] as List<dynamic>?)
          ?.map((e) => GamesTryBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeMainInfoBeanToJson(HomeMainInfoBean instance) =>
    <String, dynamic>{
      'news': instance.news,
      'banners': instance.banners,
      'thirdGames': instance.thirdGames,
      'homeHotGames': instance.homeHotGames,
      'version_type': instance.version_type,
      'gameState': instance.gameState,
      'gamesTry': instance.gamesTry,
    };

GamesTryBean _$GamesTryBeanFromJson(Map<String, dynamic> json) => GamesTryBean(
      icon_url: json['icon_url'] as String?,
      play_id: json['play_id'] as num?,
      play_cname: json['play_cname'] as String?,
      subList: (json['subList'] as List<dynamic>?)
          ?.map((e) => GamesTryItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
      logo3_img_url: json['logo3_img_url'] as String?,
      big_type: json['big_type'] as num?,
    );

Map<String, dynamic> _$GamesTryBeanToJson(GamesTryBean instance) =>
    <String, dynamic>{
      'icon_url': instance.icon_url,
      'play_id': instance.play_id,
      'big_type': instance.big_type,
      'play_cname': instance.play_cname,
      'subList': instance.subList,
      'logo3_img_url': instance.logo3_img_url,
    };

GamesTryItemBean _$GamesTryItemBeanFromJson(Map<String, dynamic> json) =>
    GamesTryItemBean(
      play_id: json['play_id'] as num?,
      play_name: json['play_name'] as String?,
      upper_play_cname: json['upper_play_cname'] as String?,
      gtype: json['gtype'] as String?,
      play_cname: json['play_cname'] as String?,
      upper_play_id: json['upper_play_id'] as num?,
      play_collection: json['play_collection'] as num?,
      state: json['state'] as num?,
      play_cat: json['play_cat'] as num?,
      type: json['type'] as num?,
      big_type: json['big_type'] as num?,
      tid: json['tid'] as num?,
    );

Map<String, dynamic> _$GamesTryItemBeanToJson(GamesTryItemBean instance) =>
    <String, dynamic>{
      'play_id': instance.play_id,
      'play_name': instance.play_name,
      'upper_play_cname': instance.upper_play_cname,
      'gtype': instance.gtype,
      'play_cname': instance.play_cname,
      'upper_play_id': instance.upper_play_id,
      'play_collection': instance.play_collection,
      'state': instance.state,
      'play_cat': instance.play_cat,
      'type': instance.type,
      'big_type': instance.big_type,
      'tid': instance.tid,
    };

BannerAndAnnouncementBean _$BannerAndAnnouncementBeanFromJson(
        Map<String, dynamic> json) =>
    BannerAndAnnouncementBean(
      count: json['count'] as num?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              BannerAndAnnouncementItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BannerAndAnnouncementBeanToJson(
        BannerAndAnnouncementBean instance) =>
    <String, dynamic>{
      'count': instance.count,
      'data': instance.data,
    };

BannerAndAnnouncementItem _$BannerAndAnnouncementItemFromJson(
        Map<String, dynamic> json) =>
    BannerAndAnnouncementItem(
      bulletinId: json['bulletinId'] as num?,
      message_id: json['message_id'] as num?,
      subject: json['subject'] as String?,
      contentType: json['contentType'] as num?,
      content: json['content'] as String?,
      chanCon: json['chanCon'] as num?,
      operCode: json['operCode'] as String?,
      create_time: (json['create_time'] as num?)?.toInt(),
      state: json['state'] as num?,
      stateTime: json['stateTime'] as num?,
      effTime: json['effTime'] as num?,
      expTime: json['expTime'] as num?,
      tid: json['tid'] as num?,
      title: json['title'] as String?,
      maId: json['maId'] as num?,
      picAddr: json['picAddr'] as String?,
      sortV: json['sortV'] as num?,
      custGroupId: json['custGroupId'] as num?,
      scheduleId: json['scheduleId'] as num?,
      bulletinScheduleId: json['bulletinScheduleId'] as num?,
      apply: json['apply'] as num?,
      activeType: json['activeType'] as num?,
      bigSortV: json['bigSortV'] as num?,
      eventApply: json['eventApply'] as num?,
      proxy: json['proxy'] as num?,
      isPopUp: json['isPopUp'] as num?,
      autoDelivery: json['autoDelivery'] as num?,
      linkType: json['linkType'] as num?,
      gameType: json['gameType'] as num?,
      platform: json['platform'] as num?,
      game: json['game'] as num?,
      taskType: json['taskType'] as num?,
      gameTaskClass: json['gameTaskClass'] as num?,
      playState: json['playState'] as num?,
      language: json['language'] as num?,
      vipLevel: json['vipLevel'] as num?,
      android: json['android'] as bool?,
      ios: json['ios'] as bool?,
      web: json['web'] as bool?,
      weiXin: json['weiXin'] as bool?,
      is_save_pic: json['is_save_pic'] as num?,
    );

Map<String, dynamic> _$BannerAndAnnouncementItemToJson(
        BannerAndAnnouncementItem instance) =>
    <String, dynamic>{
      'bulletinId': instance.bulletinId,
      'message_id': instance.message_id,
      'subject': instance.subject,
      'contentType': instance.contentType,
      'content': instance.content,
      'chanCon': instance.chanCon,
      'operCode': instance.operCode,
      'create_time': instance.create_time,
      'state': instance.state,
      'stateTime': instance.stateTime,
      'effTime': instance.effTime,
      'expTime': instance.expTime,
      'tid': instance.tid,
      'title': instance.title,
      'maId': instance.maId,
      'picAddr': instance.picAddr,
      'sortV': instance.sortV,
      'custGroupId': instance.custGroupId,
      'scheduleId': instance.scheduleId,
      'bulletinScheduleId': instance.bulletinScheduleId,
      'apply': instance.apply,
      'activeType': instance.activeType,
      'bigSortV': instance.bigSortV,
      'eventApply': instance.eventApply,
      'proxy': instance.proxy,
      'isPopUp': instance.isPopUp,
      'autoDelivery': instance.autoDelivery,
      'linkType': instance.linkType,
      'gameType': instance.gameType,
      'platform': instance.platform,
      'game': instance.game,
      'taskType': instance.taskType,
      'gameTaskClass': instance.gameTaskClass,
      'playState': instance.playState,
      'language': instance.language,
      'vipLevel': instance.vipLevel,
      'android': instance.android,
      'ios': instance.ios,
      'web': instance.web,
      'weiXin': instance.weiXin,
      'is_save_pic': instance.is_save_pic,
    };

GameBeanItem _$GameBeanItemFromJson(Map<String, dynamic> json) => GameBeanItem(
      play_name: json['play_name'] as String?,
      upper_play_cname: json['upper_play_cname'] as String?,
      gtype: json['gtype'] as String?,
      play_cname: json['play_cname'] as String?,
      play_collection: json['play_collection'] as num?,
      play_cat: json['play_cat'] as num?,
      type: json['type'] as num?,
      hot_val: (json['hot_val'] as num?)?.toInt(),
      tid: json['tid'] as num?,
      game_fever: json['game_fever'] as num?,
      play_is_hot: json['play_is_hot'] as num?,
      is_top: (json['is_top'] as num?)?.toInt(),
      play_id: (json['play_id'] as num?)?.toInt(),
      upper_play_id: json['upper_play_id'] as num?,
      state: json['state'] as num?,
      sub_play_id: (json['sub_play_id'] as num?)?.toInt(),
      upper_id: json['upper_id'] as num?,
      gameImgUrl: json['gameImgUrl'] as String?,
      logo1_img_url: json['logo1_img_url'] as String?,
      logo2_img_url: json['logo2_img_url'] as String?,
      logo3_img_url: json['logo3_img_url'] as String?,
      big_type: json['big_type'] as num?,
      thumbnail_img_url: json['thumbnail_img_url'] as String?,
      play_sort: json['play_sort'] as num?,
      hot_play_sort: json['hot_play_sort'] as num?,
    );

Map<String, dynamic> _$GameBeanItemToJson(GameBeanItem instance) =>
    <String, dynamic>{
      'play_name': instance.play_name,
      'upper_play_cname': instance.upper_play_cname,
      'gameImgUrl': instance.gameImgUrl,
      'thumbnail_img_url': instance.thumbnail_img_url,
      'gtype': instance.gtype,
      'play_cname': instance.play_cname,
      'logo1_img_url': instance.logo1_img_url,
      'logo2_img_url': instance.logo2_img_url,
      'logo3_img_url': instance.logo3_img_url,
      'sub_play_id': instance.sub_play_id,
      'play_collection': instance.play_collection,
      'play_cat': instance.play_cat,
      'type': instance.type,
      'hot_val': instance.hot_val,
      'tid': instance.tid,
      'game_fever': instance.game_fever,
      'play_is_hot': instance.play_is_hot,
      'play_sort': instance.play_sort,
      'is_top': instance.is_top,
      'play_id': instance.play_id,
      'upper_play_id': instance.upper_play_id,
      'upper_id': instance.upper_id,
      'state': instance.state,
      'big_type': instance.big_type,
      'hot_play_sort': instance.hot_play_sort,
    };

GameFishingItem _$GameFishingItemFromJson(Map<String, dynamic> json) =>
    GameFishingItem(
      game_fever: json['game_fever'] as num?,
      hot_val: json['hot_val'] as num?,
      is_top: json['is_top'] as num?,
      play_cat: json['play_cat'] as num?,
      play_collection: json['play_collection'] as num?,
      play_id: json['play_id'] as num?,
      big_type: json['big_type'] as num?,
      state: (json['state'] as num?)?.toInt(),
      upper_play_id: json['upper_play_id'] as num?,
    );

Map<String, dynamic> _$GameFishingItemToJson(GameFishingItem instance) =>
    <String, dynamic>{
      'game_fever': instance.game_fever,
      'hot_val': instance.hot_val,
      'is_top': instance.is_top,
      'play_cat': instance.play_cat,
      'play_collection': instance.play_collection,
      'play_id': instance.play_id,
      'big_type': instance.big_type,
      'upper_play_id': instance.upper_play_id,
      'state': instance.state,
    };

ThirdGamesItem _$ThirdGamesItemFromJson(Map<String, dynamic> json) =>
    ThirdGamesItem(
      icon_url: json['icon_url'] as String?,
      play_name: json['play_name'] as String?,
      gtype: json['gtype'] as String?,
      play_cname: json['play_cname'] as String?,
      play_collection: json['play_collection'] as num?,
      play_cat: json['play_cat'] as num?,
      play_id: (json['play_id'] as num?)?.toInt(),
      state: json['state'] as num?,
      big_type: json['big_type'] as num?,
      upper_id: json['upper_id'] as num?,
      hot_val: json['hot_val'] as num?,
      game_fever: json['game_fever'] as num?,
      play_is_hot: json['play_is_hot'] as num?,
      gameImgUrl: json['gameImgUrl'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      isLoadImgError: json['isLoadImgError'] as bool?,
      logo1_img_url: json['logo1_img_url'] as String?,
      logo2_img_url: json['logo2_img_url'] as String?,
      logo3_img_url: json['logo3_img_url'] as String?,
      thumbnail_img_url: json['thumbnail_img_url'] as String?,
      bg_img_url: json['bg_img_url'] as String?,
      play_sort: json['play_sort'] as num?,
      hot_play_sort: json['hot_play_sort'] as num?,
    );

Map<String, dynamic> _$ThirdGamesItemToJson(ThirdGamesItem instance) =>
    <String, dynamic>{
      'icon_url': instance.icon_url,
      'play_id': instance.play_id,
      'play_name': instance.play_name,
      'gtype': instance.gtype,
      'play_cname': instance.play_cname,
      'gameImgUrl': instance.gameImgUrl,
      'play_collection': instance.play_collection,
      'play_cat': instance.play_cat,
      'state': instance.state,
      'play_sort': instance.play_sort,
      'big_type': instance.big_type,
      'upper_id': instance.upper_id,
      'hot_val': instance.hot_val,
      'game_fever': instance.game_fever,
      'hot_play_sort': instance.hot_play_sort,
      'play_is_hot': instance.play_is_hot,
      'balance': instance.balance,
      'isLoadImgError': instance.isLoadImgError,
      'logo1_img_url': instance.logo1_img_url,
      'logo2_img_url': instance.logo2_img_url,
      'logo3_img_url': instance.logo3_img_url,
      'thumbnail_img_url': instance.thumbnail_img_url,
      'bg_img_url': instance.bg_img_url,
    };

HomeHotGameBean _$HomeHotGameBeanFromJson(Map<String, dynamic> json) =>
    HomeHotGameBean(
      gameList1: (json['1'] as List<dynamic>?)
          ?.map((e) => GameBeanItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      gameList2: (json['2'] as List<dynamic>?)
          ?.map((e) => GameBeanItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      gameList3: (json['3'] as List<dynamic>?)
          ?.map((e) => GameBeanItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      gameList5: (json['5'] as List<dynamic>?)
          ?.map((e) => GameBeanItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      gameList6: (json['6'] as List<dynamic>?)
          ?.map((e) => GameBeanItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      gameList7: (json['7'] as List<dynamic>?)
          ?.map((e) => GameBeanItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      gameList8: (json['8'] as List<dynamic>?)
          ?.map((e) => GameBeanItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeHotGameBeanToJson(HomeHotGameBean instance) =>
    <String, dynamic>{
      '1': instance.gameList1,
      '2': instance.gameList2,
      '3': instance.gameList3,
      '5': instance.gameList5,
      '6': instance.gameList6,
      '7': instance.gameList7,
      '8': instance.gameList8,
    };

GameUrlBean _$GameUrlBeanFromJson(Map<String, dynamic> json) => GameUrlBean(
      url: json['url'] as String,
    );

Map<String, dynamic> _$GameUrlBeanToJson(GameUrlBean instance) =>
    <String, dynamic>{
      'url': instance.url,
    };

VersionTypeItem _$VersionTypeItemFromJson(Map<String, dynamic> json) =>
    VersionTypeItem(
      id: json['id'] as num?,
      oper_code: json['oper_code'] as String?,
      play_name: json['play_name'] as String?,
      sort_v: json['sort_v'] as num?,
      state: json['state'] as num?,
      tid: json['tid'] as num?,
      type: (json['type'] as num?)?.toInt(),
      state_time: json['state_time'] as num?,
      create_time: json['create_time'] as num?,
    );

Map<String, dynamic> _$VersionTypeItemToJson(VersionTypeItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'oper_code': instance.oper_code,
      'play_name': instance.play_name,
      'sort_v': instance.sort_v,
      'state': instance.state,
      'tid': instance.tid,
      'type': instance.type,
      'state_time': instance.state_time,
      'create_time': instance.create_time,
    };

GameStateBean _$GameStateBeanFromJson(Map<String, dynamic> json) =>
    GameStateBean(
      (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
      ),
    );

Map<String, dynamic> _$GameStateBeanToJson(GameStateBean instance) =>
    <String, dynamic>{
      'data': instance.data?.map((k, e) => MapEntry(k.toString(), e)),
    };

GameLotteryBean _$GameLotteryBeanFromJson(Map<String, dynamic> json) =>
    GameLotteryBean(
      (json['data'] as List<dynamic>?)
          ?.map((e) => GameLotteryItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameLotteryBeanToJson(GameLotteryBean instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

GameLotteryItemBean _$GameLotteryItemBeanFromJson(Map<String, dynamic> json) =>
    GameLotteryItemBean(
      base: json['base'] as String?,
      begin_time: (json['begin_time'] as num?)?.toInt(),
      end_time: (json['end_time'] as num?)?.toInt(),
      hot_val: (json['hot_val'] as num?)?.toInt(),
      img_url: json['img_url'] as String?,
      is_top: (json['is_top'] as num?)?.toInt(),
      is_xy: (json['is_xy'] as num?)?.toInt(),
      play_cat: (json['play_cat'] as num?)?.toInt(),
      play_cname: json['play_cname'] as String?,
      play_collection: (json['play_collection'] as num?)?.toInt(),
      play_des: json['play_des'] as String?,
      play_id: (json['play_id'] as num?)?.toInt(),
      play_name: json['play_name'] as String?,
      play_state: (json['play_state'] as num?)?.toInt(),
      start_sale_offset: (json['start_sale_offset'] as num?)?.toInt(),
      stopTime: (json['stopTime'] as num?)?.toInt(),
      stop_sale_offset: (json['stop_sale_offset'] as num?)?.toInt(),
      sub_play_id: (json['sub_play_id'] as num?)?.toInt(),
      sys_time: (json['sys_time'] as num?)?.toInt(),
      term_code: (json['term_code'] as num?)?.toInt(),
      timeout: json['timeout'] as bool?,
      type: (json['type'] as num?)?.toInt(),
      thumbnail_img_url: json['thumbnail_img_url'] as String?,
    );

Map<String, dynamic> _$GameLotteryItemBeanToJson(
        GameLotteryItemBean instance) =>
    <String, dynamic>{
      'base': instance.base,
      'begin_time': instance.begin_time,
      'end_time': instance.end_time,
      'hot_val': instance.hot_val,
      'img_url': instance.img_url,
      'thumbnail_img_url': instance.thumbnail_img_url,
      'is_top': instance.is_top,
      'is_xy': instance.is_xy,
      'play_cat': instance.play_cat,
      'play_cname': instance.play_cname,
      'play_collection': instance.play_collection,
      'play_des': instance.play_des,
      'play_id': instance.play_id,
      'play_name': instance.play_name,
      'play_state': instance.play_state,
      'start_sale_offset': instance.start_sale_offset,
      'stopTime': instance.stopTime,
      'stop_sale_offset': instance.stop_sale_offset,
      'sub_play_id': instance.sub_play_id,
      'sys_time': instance.sys_time,
      'term_code': instance.term_code,
      'timeout': instance.timeout,
      'type': instance.type,
    };

GameChessAndElectronicBean _$GameChessAndElectronicBeanFromJson(
        Map<String, dynamic> json) =>
    GameChessAndElectronicBean(
      (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            int.parse(k),
            (e as List<dynamic>)
                .map((e) => GameChessAndElectronicItemBean.fromJson(
                    e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$GameChessAndElectronicBeanToJson(
        GameChessAndElectronicBean instance) =>
    <String, dynamic>{
      'data': instance.data?.map((k, e) => MapEntry(k.toString(), e)),
    };

GameChessAndElectronicItemBean _$GameChessAndElectronicItemBeanFromJson(
        Map<String, dynamic> json) =>
    GameChessAndElectronicItemBean(
      big_type: (json['big_type'] as num?)?.toInt(),
      game_fever: (json['game_fever'] as num?)?.toInt(),
      gtype: json['gtype'] as String?,
      hot_val: json['hot_val'] as num?,
      icon_url: json['icon_url'] as String?,
      play_cat: json['play_cat'] as num?,
      play_cname: json['play_cname'] as String?,
      play_collection: (json['play_collection'] as num?)?.toInt(),
      play_id: json['play_id'] as num?,
      play_name: json['play_name'] as String?,
      play_state_id: json['play_state_id'] as num?,
      state: json['state'] as num?,
      upper_id: json['upper_id'] as num?,
      thumbnail_img_url: json['thumbnail_img_url'] as String?,
      play_sort: json['play_sort'] as num?,
      play_is_hot: json['play_is_hot'] as num?,
      hot_play_sort: json['hot_play_sort'] as num?,
    );

Map<String, dynamic> _$GameChessAndElectronicItemBeanToJson(
        GameChessAndElectronicItemBean instance) =>
    <String, dynamic>{
      'big_type': instance.big_type,
      'game_fever': instance.game_fever,
      'gtype': instance.gtype,
      'hot_val': instance.hot_val,
      'icon_url': instance.icon_url,
      'play_cat': instance.play_cat,
      'play_cname': instance.play_cname,
      'play_collection': instance.play_collection,
      'play_id': instance.play_id,
      'play_name': instance.play_name,
      'thumbnail_img_url': instance.thumbnail_img_url,
      'play_state_id': instance.play_state_id,
      'state': instance.state,
      'upper_id': instance.upper_id,
      'play_sort': instance.play_sort,
      'play_is_hot': instance.play_is_hot,
      'hot_play_sort': instance.hot_play_sort,
    };

HomeCollectionListBean _$HomeCollectionListBeanFromJson(
        Map<String, dynamic> json) =>
    HomeCollectionListBean(
      (json['data'] as List<dynamic>?)
          ?.map((e) =>
              HomeCollectionListItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeCollectionListBeanToJson(
        HomeCollectionListBean instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

HomeCollectionListItemBean _$HomeCollectionListItemBeanFromJson(
        Map<String, dynamic> json) =>
    HomeCollectionListItemBean(
      collectionId: json['collectionId'] as num?,
      msg: json['msg'] as String?,
      playCname: json['playCname'] as String?,
      playName: json['playName'] as String?,
      play_big_type: (json['play_big_type'] as num?)?.toInt(),
      play_cat: (json['play_cat'] as num?)?.toInt(),
      play_id: (json['play_id'] as num?)?.toInt(),
      play_state: (json['play_state'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
      big_type: (json['big_type'] as num?)?.toInt(),
      upper_name: json['upper_name'] as String?,
      gameImgUrl: json['gameImgUrl'] as String?,
      gtype: json['gtype'] as String?,
      upper_play_id: (json['upper_play_id'] as num?)?.toInt(),
      isRecord: json['isRecord'] as bool?,
      thumbnail_img_url: json['thumbnail_img_url'] as String?,
    );

Map<String, dynamic> _$HomeCollectionListItemBeanToJson(
        HomeCollectionListItemBean instance) =>
    <String, dynamic>{
      'collectionId': instance.collectionId,
      'msg': instance.msg,
      'playCname': instance.playCname,
      'playName': instance.playName,
      'play_big_type': instance.play_big_type,
      'play_cat': instance.play_cat,
      'play_id': instance.play_id,
      'play_state': instance.play_state,
      'type': instance.type,
      'upper_name': instance.upper_name,
      'gameImgUrl': instance.gameImgUrl,
      'thumbnail_img_url': instance.thumbnail_img_url,
      'upper_play_id': instance.upper_play_id,
      'big_type': instance.big_type,
      'gtype': instance.gtype,
      'isRecord': instance.isRecord,
    };

HomeProfitListBean _$HomeProfitListBeanFromJson(Map<String, dynamic> json) =>
    HomeProfitListBean(
      (json['data'] as List<dynamic>?)
          ?.map(
              (e) => HomeProfitListItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeProfitListBeanToJson(HomeProfitListBean instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

HomeProfitListItemBean _$HomeProfitListItemBeanFromJson(
        Map<String, dynamic> json) =>
    HomeProfitListItemBean(
      amount: json['amount'] as num?,
      cust_name: json['cust_name'] as String?,
      id: json['id'] as num?,
      oper_code: json['oper_code'] as String?,
      tid: json['tid'] as num?,
    )..state = json['state'] as num?;

Map<String, dynamic> _$HomeProfitListItemBeanToJson(
        HomeProfitListItemBean instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'cust_name': instance.cust_name,
      'id': instance.id,
      'oper_code': instance.oper_code,
      'state': instance.state,
      'tid': instance.tid,
    };

AllLotteryDataBean _$AllLotteryDataBeanFromJson(Map<String, dynamic> json) =>
    AllLotteryDataBean(
      (json['data'] as List<dynamic>?)
          ?.map(
              (e) => AllLotteryDataItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllLotteryDataBeanToJson(AllLotteryDataBean instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

AllLotteryDataItemBean _$AllLotteryDataItemBeanFromJson(
        Map<String, dynamic> json) =>
    AllLotteryDataItemBean(
      hot_val: json['hot_val'] as num?,
      img_url: json['img_url'] as String?,
      is_top: (json['is_top'] as num?)?.toInt(),
      play_cat: (json['play_cat'] as num?)?.toInt(),
      play_cname: json['play_cname'] as String?,
      play_des: json['play_des'] as String?,
      play_id: (json['play_id'] as num?)?.toInt(),
      play_name: json['play_name'] as String?,
      play_state: (json['play_state'] as num?)?.toInt(),
      sub_play_id: (json['sub_play_id'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AllLotteryDataItemBeanToJson(
        AllLotteryDataItemBean instance) =>
    <String, dynamic>{
      'hot_val': instance.hot_val,
      'img_url': instance.img_url,
      'is_top': instance.is_top,
      'play_cat': instance.play_cat,
      'play_cname': instance.play_cname,
      'play_des': instance.play_des,
      'play_id': instance.play_id,
      'play_name': instance.play_name,
      'play_state': instance.play_state,
      'sub_play_id': instance.sub_play_id,
      'type': instance.type,
    };
