import 'dart:ui';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import '../api/activity_api.dart';
import '../api/home_api.dart';
import '../app/modules/activity/controllers/activity_controller.dart';
import '../app/modules/activity/controllers/activity_detail_controller.dart';
import '../app/modules/activity/data/activity_bean.dart';
import '../app/modules/activity/data/activity_coding_model/activity_coding_model.dart';
import '../app/modules/activity/data/lucky_bet_model/lucky_bet_model.dart';
import '../app/modules/home/model/activity_redbag_detail_model/activity_redbag_detail_model.dart';
import '../app/routes/app_pages.dart';
import '../constants/activity_constants.dart';
import '../kernel/network/service.dart';
import '../kernel/utils/app_utils.dart';
import 'login_manager.dart';

class BannerJumpUtils {
  // 创建一个私有静态变量来存储实例
  static final BannerJumpUtils _instance = BannerJumpUtils._internal();

  // 工厂构造函数，用来返回实例
  factory BannerJumpUtils() {
    return _instance;
  }

  // 私有命名构造函数
  BannerJumpUtils._internal();

  /// 点击活动
  Future<void> handleActivity(ActivityListItemBean itemData) async {
    print("输出一下banner点击数据：${itemData.toString()}");
    String content = itemData.content ?? '';
    // 空就去掉
    if (content.isEmpty) {
      return;
    }
    if (!content.contains('http')) {
      String? aidValue = getQueryParamValue(content, 'aid');
      String aid = '${aidValue ?? itemData.id}';
      print('content:$content, aid:$aid');
      if (content.contains('activity/rank')) {
        _isUserLogin(() {
          // 排行榜
          Get.toNamed(Routes.LEADERBOARD_REWARD, arguments: {
            'aid': aid,
          });
        });
      } else if (content.contains('activity/newcomer')) {
        _isUserLogin(() {
          // 新人彩金
          Get.toNamed(Routes.WELCOME_BONUS, arguments: {
            'aid': aid,
          });
        });
      } else if (content.contains('activity/relayRoulette')) {
        // 助力转盘
        _withAuthJumpToH5Activity(uri: '/activity/relayRoulette', aid: aid);
      } else if (content.contains('activity/newsalary')) {
        // 分享赚现金
        _withAuthJumpToH5Activity(uri: '/activity/newsalary', aid: aid);
      } else if (content.contains('activity/reliefFund')) {
        // 救援金活动
        Get.toNamed(Routes.RELIEF_FUND, arguments: {
          'aid': aid,
          'title': itemData.subject,
          "type": ActivityTypsEnum.none,
        });
        // _withAuthJumpToH5Activity(uri: '/activity/reliefFund', aid: aid);
      } else if (content.contains('activity/rechargeGift')) {
        // 充值活动
        Get.toNamed(Routes.RELIEF_FUND, arguments: {
          'aid': aid,
          'title': itemData.activeName,
          "type": ActivityTypsEnum.recharge,
        });
        // _withAuthJumpToH5Activity(uri: '/activity/reliefFund', aid: aid);
      } else if (content.contains('activity/registerBonus')) {
        // final res = await HomeApi.getRedbagData();
        // if (res.type == NetworkService.networkTypeSuccess) {
        //   final logredModel = ActivityLogredbagModel.fromJson(res.data);
        String? tasks_id = getQueryParamValue(content, 'tasks_id');
        final detail = await HomeApi.getRedbagDetailData(tasks_id!);
        final data = ActivityRedbagDetailModel.fromJson(detail.data);
        Get.toNamed(
          Routes.ACTIVITY_DETAIL,
          arguments: {
            "title": itemData.subject,
            "itemData": null,
            "isRedbag": true,
            "logRedbagModel": null,
            "redbagDetailModel": data
          },
        );
        // }
      } else if (content.contains('activity/lucky-bet')) {
        final res = await ActivityApi.reqLuckyActivityDetail(aid);
        if (res.type == NetworkService.networkTypeSuccess) {
          final data = LuckyBetModel.fromJson(res.data);
          Get.toNamed(
            Routes.ACTIVITY_DETAIL,
            arguments: {
              "title": itemData.subject,
              "type": ActivityTypsEnum.lucky,
              "luckyBetModel": data,
            },
          );
        }
      } else if (content.contains('activity/play')) {
        final res = await ActivityApi.reqActivityDetails(aid);
        if (res.type == NetworkService.networkTypeSuccess) {
          final data = ActivityCodingModel.fromJson(res.data);
          Get.toNamed(
            Routes.ACTIVITY_DETAIL,
            arguments: {
              "title": itemData.subject,
              "type": ActivityTypsEnum.coding,
              "codingModel": data,
            },
          );
        }
      } else if (content.contains('activity/redPackets')) {
        final res = await ActivityApi.reqActivityDetails(aid);
        if (res.type == NetworkService.networkTypeSuccess) {
          final data = ActivityCodingModel.fromJson(res.data);
          Get.toNamed(
            Routes.REDBAG_DETAIL,
            arguments: {
              "model": data.t,
            },
          );
        }
      }

      return;
    }
    if (itemData.link_type == 1 || itemData.link_type == 2) {
      if (itemData.content != null && itemData.content!.isNotEmpty) {
        // launchUrl(Uri.parse(itemData.content!),
        //     mode: LaunchMode.externalApplication);
        Get.toNamed(Routes.WEB_VIEW, arguments: {
          "url": itemData.content, //请求地址
          "isShowGameBack": false,
          "isShowTitle": true,
          "title": itemData.activeName,
          "isShowRecharge": false,
        });
        return;
      }
    } else {
      // 游戏1 任务2
      if (itemData.task_type == 1) {
        // 充值
        Get.toNamed(Routes.RECHARGE);
      } else if (itemData.task_type == 3) {
        // 分享赚现金
        _withAuthJumpToH5Activity(uri: '/activity/newsalary');
      } else if (itemData.task_type == 7) {
        // 幸运大转盘
        _withAuthJumpToH5Activity(uri: '/activity/roulette');
      } else if (itemData.task_type == 8) {
        // 助力转盘
        _withAuthJumpToH5Activity(uri: '/activity/relayRoulette');
      } else if (itemData.task_type == 16) {
        //  分享赚现金
        _withAuthJumpToH5Activity(uri: '/activity/newsalary');
      } else if (itemData.task_type == 13) {
        // 救援金活动
        _withAuthJumpToH5Activity(uri: '/activity/reliefFund');
      } else if (itemData.task_type == 2) {
        actController.jumpToPage(1);
        actController.taskTabIndex.value = ActivityConstants.ACTIVITY_TYPE_102;
      } else if (itemData.activeType == 199 && itemData.content_type == 4) {
        final signInIndex = actController.activityData.value.indexWhere(
          (activity) => activity.title == '签到',
        );
        actController.jumpToPage(signInIndex);
      } else if (itemData.task_type == 4) {
        actController.jumpToPage(1);
        actController.taskTabIndex.value = ActivityConstants.ACTIVITY_TYPE_103;
      }
      // else {
      //   EasyLoading.showToast('敬请期待～');
      // }
      print(
          'name:${itemData.activeName}, task_type:${itemData.task_type}, content:${itemData.content}');
      return;
    }

    if (itemData.content_type == ActivityContentType.Image &&
        itemData.activeType == 71) {
      String content = itemData.content ?? '';
      String? aidValue = getQueryParamValue(content, 'aid');
      String aid = '${aidValue ?? itemData.id}';
      Get.toNamed(Routes.RELIEF_FUND, arguments: {
        'aid': aid,
        'title': itemData.subject,
        "type": ActivityTypsEnum.recharge,
      });
      return;
    }

    final result = await Get.toNamed(
      Routes.ACTIVITY_DETAIL,
      arguments: {"title": itemData.subject, "itemData": itemData},
    );

    if (result != null) {
      handleReturnCallback(result);
    }

    // Get.toNamed(Routes.ACTIVITY);
    // // 文字和图片
    // if (itemData.bulletin_id != 0) {
    //   isShowBulletinId.value = isShowBulletinId.value == itemData.bulletin_id
    //       ? 0
    //       : itemData.bulletin_id!;
    // }
  }

  String? getQueryParamValue(String url, String param) {
    final uri = Uri.parse(url);
    return uri.queryParameters[param];
  }

  _isUserLogin(VoidCallback callBack) {
    bool isNotLogin = !LoginManager.instance.isLogin.value;

    // 未登录
    if (isNotLogin) {
      showLoginDialog(callback: () {
        callBack();
      });
      return;
    }

    callBack();
  }

  // 跳转H5活动
  _withAuthJumpToH5Activity({required String uri, String? aid}) {
    _isUserLogin(() {
      _gotoH5Acticity(uri: uri, aid: aid);
    });
  }

  final ActivityController actController = Get.find();
  void handleReturnCallback(dynamic result) {
    actController.jumpToPage(6);
  }

  RxInt isShowBulletinId = 0.obs; // 点击了当前子项目
  /// 跳转H5活动公用方法
  _gotoH5Acticity({
    required String uri,
    String? aid,
  }) {
    String accessToken = '';
    String custId = '';
    if (LoginManager.instance.loginInfo != null) {
      accessToken = LoginManager.instance.loginInfo!.accessToken ?? '';
      custId = '${LoginManager.instance.loginInfo!.custId}';
    }

    if (accessToken.isNotEmpty && custId.isNotEmpty) {
      String platform = getBetPlatform();
      NetworkService ns = NetworkService();
      String url =
          '${ns.baseURL}${uri}?token=${accessToken}&cust_id=${custId}&platform=${platform}';

      if (aid != null) {
        url = '${url}&aid=${aid}';
      }
    }
  }
}
