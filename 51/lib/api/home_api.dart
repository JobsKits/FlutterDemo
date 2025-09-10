import 'dart:convert';
import 'dart:io';

import 'package:flutter_tiyu_app/app/data/login_bean.dart';
// import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';
import 'package:flutter_tiyu_app/app/data/tenant_bean.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';

import '../app/data/home_main_info_bean.dart';
import '../app/data/home_tab_data.dart';
import '../app/data/real_time_prizes_bean.dart';
import '../app/modules/home/home_view_const.dart';

class HomeApi {
  /// 请求首页数据，包含banner、公告、游戏
  static Future<NetworkResponse> reqHomeData() async {
    TenantBean? tenantInfo = TenantManager.instance.tenantBean;
    LoginBean? loginInfo = LoginManager.instance.loginInfo;
    //获取游戏大类平台数据
    int cmdId = 381119;
    int? proxy = tenantInfo?.proxy;
    int? tid = tenantInfo?.tid;
    int custId = loginInfo?.custId ?? 0;
    var data = {
      'tid': tid, // tenantInfo.value.tid
      'aseq': {
        'aseq': '7',
      },
      'version_type': {
        'version_type': 3, // 1 是棋牌, 2 是网赚 3, 是综合彩票
      },
      'news': {
        'page_start': 1,
        'num_per_page': 999,
        'chan_con': 8,
        'state': 1,
        'message_id': '10,13',
        'sort_flag': 1,
        'vip_level': 0,
        'proxy': proxy,
        'apply': 8, // // 1 棋牌；2 网赚；3 综合彩票；3 老版彩票； (apply后端设置默认为1，为可选参数)
        'language': 0,
      },
      'game_news': {
        'page_start': 1,
        'num_per_page': 9999,
        'state': 1,
        'message_id': 17,
        'sort_flag': 1,
        'tid': tid, // tenantInfo.value.tid
        'proxy': proxy, // tenantInfo.value.proxy
        'chan_con': 0,
        'apply': 8,
        'ma_id': 10,
        'vip_level': 0,
        'type': 'MWEB', // getDeviceType: MWEB, PC, IOS, ANDROID
        'language': 0, // 固定传中文语言类型，游戏公告在其他语言类型下不会返回
      },
      'banners': {
        'page_start': 1,
        'num_per_page': 999,
        'chan_con': 8,
        'state': 1,
        'message_id': 12,
        'sort_flag': 1,
        'proxy': proxy,
        'apply': 8,
        'language': 0,
      },
      'homeHotGames': {
        'cust_id': custId ?? '0', // userInfo.value.cust_id || '0'
      },
      'proxyConfig': {
        'proxy': proxy,
      },
      'hotGames': {
        'size': 12,
      },
    };
    // print("输出一下首页请求：${data}");
    int paramType = 1;

    return await NetworkService().request(
      cmdId,
      isApiV2: true,
      data: data,
      paramType: paramType,
      headerType: 1,
      logError: true,
    );
  }

  /// 请求彩票的数据列表
  static Future<NetworkResponse> reqLotteryData() async {
    int cmdId = 320542;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid, // 租户标识
      "cust_id": LoginManager.instance.loginInfo?.custId ?? '',
      "play_cat": 1,
      "type": 0,
      "size": 10,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
    );
  }

  /// 请求天成彩票的数据列表
  static Future<NetworkResponse> reqLegLotteryData() async {
    int cmdId = 317104;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid, // 租户标识
      "cust_id": LoginManager.instance.loginInfo?.custId ?? '',
    };
    return await NetworkService().request(
      cmdId,
      data: data,
    );
  }

  /// 租户的彩种配置 (此处逻辑很奇怪，取了首页的gameState, 又查询该接口改值！！！)
  static Future<NetworkResponse> reqConfigJson() async {
    int cmdId = 320151;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid, // 租户标识
    };

    return await NetworkService().request(
      cmdId,
      data: data,
    );
  }

  /// 请求3方游戏地址
  static Future<NetworkResponse> req3GameUrl(
      Map<String, dynamic> payload, String params) async {
    LoginBean? loginInfo = LoginManager.instance.loginInfo;
    // 请求第三方游戏url
    int cmdId = 314501;
    Map<String, dynamic> payloadData = payload['data'] ?? {};

    if (payloadData.isNotEmpty) {
      payload.remove('data');
    }

    var data = {
      ...payload,
      ...payloadData,
      'tid': TenantManager.instance.tenantBean?.tid, // 租户标识
      'cust_id': loginInfo!.custId, // 用户标识
      'params': params, // 用户标识
    };
    // print("请求游戏的传参是：${data}");
    int paramType = 0;
    var res = await NetworkService().request(
      cmdId,
      isApiV2: true,
      data: data,
      paramType: paramType,
    );
    // print("请求参数：${data}  响应参数:${res}");
    return res;
  }

  /// 请求试玩游戏地址
  static Future<NetworkResponse> reqTryGameUrl(
      Map<String, dynamic> payload) async {
    LoginBean? loginInfo = LoginManager.instance.loginInfo;
    // 请求第三方游戏url
    int cmdId = 314521;
    Map<String, dynamic> payloadData = payload['data'] ?? {};

    if (payloadData.isNotEmpty) {
      payload.remove('data');
    }

    var data = {
      ...payload,
      ...payloadData,
      'tid': AppConfigs.tid, // 租户标识
      'cust_id': 0, // 用户标识
    };

    int paramType = 0;

    return await NetworkService().request(
      cmdId,
      isApiV2: true,
      data: data,
      paramType: paramType,
    );
  }

  /// 收藏游戏
  static Future<NetworkResponse> reqCollectGame({
    required String msg,
    required playId,
    required type,
    required playCat,
    required status,
  }) async {
    // 首页游戏 收藏/取消收藏
    // 测试时需要修改service.dart中的accessToken, tid, Custid
    // 首页游戏对象中 play_collection=2表示已收藏，play_collection=1表示未收藏，
    int cmdId = 320567;
    // int status = 1; // 1:收藏 2:取消收藏
    var data = {
      'tid': AppConfigs.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'play_id': playId,
      'type': type,
      'play_cat': playCat,
      'status': status,
      'msg': msg,
    };
    print('=====> ${data}');

    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      isApiV2: false,
      paramType: 0,
      logError: true,
    );
  }

  /// 请求收藏列表
  static Future<List<HomeCollectionListItemBean>> reqCollectionList() async {
    List<HomeCollectionListItemBean> tempList = [];
    int cmdId = 320566;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid, // 租户标识
      "cust_id": LoginManager.instance.loginInfo?.custId ?? '',
    };
    var res = await NetworkService().request(
      cmdId,
      data: data,
      isApiV2: false,
      paramType: 0,
      headerType: 2,
    );
    if (res.data is List) {
      for (var item in res.data) {
        HomeCollectionListItemBean bean =
            HomeCollectionListItemBean.fromJson(item);
        if (item['msg'] != null) {
          final msg = jsonDecode(item['msg']);
          if (msg['upper_play_id'] != null) {
            // print('${item['playCname']}: ${msg['upper_play_id']}');
            bean.upper_play_id = msg['upper_play_id'];
          }
          if (msg['big_type'] != null) {
            bean.big_type = msg['big_type'];
          }
          if (msg['gtype'] != null) {
            bean.gtype = msg['gtype'];
          }
        }
        tempList.add(bean);
      }
    }
    return tempList;
  }

  /// 请求电子或者棋牌 子游戏的数据
  static Future<NetworkResponse> reqChessOrElectronicGameData(
      HomePageDetailEnum homePageEnum) async {
    int cmdId = 320146;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid, // 租户标识
      "cust_id": LoginManager.instance.loginInfo?.custId ?? '0',
    };
    switch (homePageEnum) {
      case HomePageDetailEnum.chess:
        data['upper_id'] = '0';
        break;
      case HomePageDetailEnum.electronic:
        data['upper_id'] = '-1';
        break;
      case HomePageDetailEnum.fishing:
        data['upper_id'] = '-2';
        break;
      case HomePageDetailEnum.blockChain:
        data['upper_id'] = '-3';
        break;
      case HomePageDetailEnum.collect:
      case HomePageDetailEnum.recent:
      case HomePageDetailEnum.live:
      case HomePageDetailEnum.sports:
      case HomePageDetailEnum.lottery:
        break;
    }
    return NetworkService().request(
      cmdId,
      data: data,
      isApiV2: true,
      paramType: 0,
      headerType: 2,
    );
  }

  /// 请求盈利榜
  static reqProfitList() async {
    int cmdId = 341533;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid, // 租户标识
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      headerType: 1,
    );
  }

  /// 检测3方游戏余额限制
  static checking3GameLimited(int playId) async {
    int cmdId = 315605;

    var data = {
      'play_id': playId,
      'tid': TenantManager.instance.tenantBean?.tid, // 租户标识
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      headerType: 2,
    );
  }

  /// 检测3方平台
  static checking3Game(int playId) async {
    int cmdId = 321543;

    var data = {
      'play_id': playId,
      'tid': TenantManager.instance.tenantBean?.tid, // 租户标识
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      headerType: 2,
    );
  }

  /// 获取所有彩票数据（不分销售状态）
  static getAllLottery() async {
    int cmdId = 320549;

    var data = {
      'tid': TenantManager.instance.tenantBean?.tid, // 租户标识
    };

    return await NetworkService().request(
      cmdId,
      data: data,
    );
  }

  static Future<NetworkResponse> getRankList() async {
    int cmdId = 341534;
    var data = {
      'tid': AppConfigs.tid,
      'page_start': 1,
      'num_per_page': 10,
    };
    return await NetworkService().request(cmdId, data: data, headerType: 2);
  }

  /// 获取所有红包数据
  static Future<NetworkResponse> getNotLoginRedbagData() async {
    int cmdId = 377001;

    var data = {
      'tid': TenantManager.instance.tenantBean?.tid, // 租户标识
      'terminal': Platform.isAndroid ? 1 : 3,
    };

    return await NetworkService().request(cmdId, data: data, headerType: 2);
  }

  static Future<NetworkResponse> getRedbagData() async {
    int cmdId = 377003;

    var data = {
      'tid': TenantManager.instance.tenantBean?.tid, // 租户标识
      "cust_id": LoginManager.instance.loginInfo?.custId ?? '',
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  static Future<NetworkResponse> getRedbagDetailData(String taskId) async {
    int cmdId = 377004;

    var data = {
      'tid': TenantManager.instance.tenantBean?.tid, // 租户标识
      'tasks_id': taskId,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  static Future<NetworkResponse> checkRedbagCanReceive(
      int receive_log_id) async {
    int cmdId = 7242010;

    var data = {
      'tid': TenantManager.instance.tenantBean?.tid, // 租户标识
      "cust_id": LoginManager.instance.loginInfo?.custId ?? '',
      "receive_log_id": receive_log_id,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  //请求新版热门数据
  static Future<GameBeanItem?> reqNewHotGame() async {
    int cmdId = 321552;
    var data = {
      'tid': AppConfigs.tid, // 租户标识
      'cust_id': LoginManager.instance.loginInfo?.custId ?? '', // 租户标识
    };
    NetworkResponse res =
        await NetworkService().request(cmdId, data: data, headerType: 2);
    if (res.type == NetworkService.networkTypeSuccess && res.data != null) {
      return GameBeanItem.fromJson(res.data);
    }
    return null;
  }

  //请求首页tab配置
  static Future<List<HomeTabData>?> reqHomeTab() async {
    List<HomeTabData> homeTabList = [];
    int cmdId = 724300;
    var data = {
      'tid': AppConfigs.tid, // 租户标识
    };
    NetworkResponse res =
        await NetworkService().request(cmdId, data: data, headerType: 2);

    if (res.data is List) {
      for (var item in res.data) {
        homeTabList.add(HomeTabData.fromJson(item));
      }
    }

    return homeTabList;
  }

  /// 获取首页百万福利活动图标
  static Future<Map<String, String>> reqHomeFloatIcon() async {
    int cmdId = 370730;

    var data = {
      'tid': AppConfigs.tid,
      'option_code': 'HOME_TEN_MILLION_BENEFITS', // 亚马逊 S3 存储
    };
    var iconStr = "";
    Map<String, String> test = {};
    try {
      var res = await NetworkService().request(
        cmdId,
        data: data,
        logError: true,
      );
      print("输出一下请求结果:${res}");
      iconStr = res.data?['value'];
      test['img'] = iconStr;
      test['name'] = res.data?['value2'];
    } catch (e) {
      print("获取首页百万福利活动图标报错:$e");
    }
    return test;
  }

  //请求首页实时爆奖数据
  static Future<List<RealTimePrizesItemBean>?> reqRealTimePrizesData() async {
    List<RealTimePrizesItemBean> homeTabList = [];
    int cmdId = 3109013;
    var data = {
      'tid': 3,
      'page_start': 1,
      'num_per_page': 20,
    };
    NetworkResponse res =
        await NetworkService().request(cmdId, data: data, headerType: 1);
    if (res.data != null && res.type == NetworkService.networkTypeSuccess) {
      RealTimePrizesBean realTimePrizesBean =
          RealTimePrizesBean.fromJson(res.data);

      if (realTimePrizesBean.data?.isNotEmpty == true) {
        return realTimePrizesBean.data;
      }
    }
    return homeTabList;
  }
}
