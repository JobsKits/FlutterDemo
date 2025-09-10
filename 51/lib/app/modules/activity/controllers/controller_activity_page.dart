import 'dart:convert';
import 'package:flutter_tiyu_app/utils/JobsCommonUtil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/home_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_detail_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_coding_model/activity_coding_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_right_model/activity_pg_list.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_right_model/activity_right_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/activity_turntable_detail_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/lucky_bet_model/lucky_bet_model.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/model/activity_redbag_detail_model/activity_redbag_detail_model.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/kernel/utils/app_utils.dart';
import 'package:flutter_tiyu_app/utils/activity_manager.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
// import 'package:flutter_tiyu_app/utils/activity_manager.dart';
// import 'package:flutter_tiyu_app/utils/public_util.dart';

import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/constants/activity_constants.dart';

import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../home/model/activity_logredbag_model/activity_logredbag_model.dart';
import '../data/activity_bean.dart';

class ControllerActivityPage extends GetxController
    with GetTickerProviderStateMixin {
  RxInt tabCurrentIndex = 0.obs;

  final ActivityController actController = Get.find();
  final NewHomeController homeController = Get.find();

  RxList<ActivityTabsItemBean> tabList = <ActivityTabsItemBean>[].obs;
  TabController? tabActivityListController;
  late PageController pageController;

  // 用于缓存数据
  // final _dataMap = <String, List<ActivityListItemBean>>{}.obs;
  // List<ActivityListItemBean> getData(RxInt index) =>
  //     _dataMap[index.toString()] ?? [];
  Rx<ActivityRightModel> rightModel = ActivityRightModel().obs;

  RxInt isShowBulletinId = 0.obs; // 点击了当前子项目

  RxBool isLoading = false.obs;

  late WebViewController webViewController;
  final String _jsChannelName = 'FlutterJSChannel';

  late ActivityTurntableDetailModel? activityTurntableDetailData;

  @override
  onInit() async {
    super.onInit();

    pageController = PageController(initialPage: 0);
    // Tabs数据获取
    await requestActivityData();

    /// 监听玩家或者退出
    // ever(LoginManager.instance.isLogin, (isLogin) async {
    //   await requestActivityData();
    // });

    ever(homeController.tabsController.currentIndex, (index) async {
      int idx = homeController.tabsController.defaultBottomItemList
          .indexWhere((e) => e.title == 'events');
      if (idx == index && actController.currentTabIndex == 0) {
        await requestActivityData();
        await requestActivityDetail(forceRefresh: false);
      }
    });

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(_jsChannelName,
          onMessageReceived: _handleJavaScriptMessage)
      ..addJavaScriptChannel('RouteChange',
          onMessageReceived: (JavaScriptMessage message) {
        final url = message.message;
        if (!url.contains('/activity/')) {
          Get.back();
        }
      })
      ..runJavaScript('document.activeElement.blur();')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // print('onPageStarted $url');
          },
          onPageFinished: (String url) {
            // print('onPageFinished $url');
            if (url.contains('/activity/')) {
              webViewController.runJavaScript('''
              // 注入 JavaScript 脚本，监听 Vue Router 的变化
              (function() {
                const originalPush = history.pushState;
                history.pushState = function(...args) {
                  originalPush.apply(this, args);
                  window.RouteChange.postMessage(location.href);
                };
                const originalReplace = history.replaceState;
                history.replaceState = function(...args) {
                  originalReplace.apply(this, args);
                  window.RouteChange.postMessage(location.href);
                };
                window.addEventListener('popstate', function() {
                  window.RouteChange.postMessage(location.href);
                });
              })();
              ''');
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            // print('onNavigationRequest: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    if (tabActivityListController != null) {
      tabActivityListController!.dispose();
    }

    pageController.dispose();
    super.onClose();
  }

  onRefresh() {
    requestActivityData();
    requestActivityDetail();
  }

  // 请求优惠活动Tab数据
  requestActivityData() async {
    // final res = await ActivityApi.reqActivityData();
    final res = await ActivityApi.reqTabsData();
    // print({'object =======${res.data}'});
    if (res.type == NetworkService.networkTypeSuccess) {
      // print("data:${jsonEncode(res.data)}");
      final resultTabData = ActivityTabsBean.fromJson(res.data);
      // final resultTabData =
      //     ActivityTabsBean.fromJson(res.data['data']).data ?? [];

      // var allActivitiesTab = ActivityTabsItemBean(
      //   cat: "全部活动",
      //   sort_v: -1,
      //   id: 0,
      //   tid: 0,
      // );
      // resultTabData.add(allActivitiesTab);

      // resultTabData.data?.sort((a, b) => a.orderNum!.compareTo(b.orderNum!));

      final filteredData =
          resultTabData.data?.where((item) => item.status != '0').toList();
      tabList.value = filteredData!;
      int initialIndex = 0;
      if (tabActivityListController != null) {
        initialIndex = tabActivityListController!.index;
      }
      tabActivityListController = TabController(
          initialIndex: initialIndex,
          length: resultTabData.data!.length,
          vsync: this)
        ..addListener(() {
          if (tabActivityListController!.indexIsChanging) {
            AppManager.instance.tapVibrate();
            jumpToPage(tabActivityListController!.index);
            // tabCurrentIndex.value = tabActivityListController.index;
            // requestActivityDetail(forceRefresh: false);
            // pageController.animateToPage(
            //   tabActivityListController.index,
            //   duration: const Duration(milliseconds: 300),
            //   curve: Curves.easeInOut,
            // );
          }
        });

      if (resultTabData.data!.isNotEmpty) {
        // 请求活动详情
        await requestActivityDetail();
      }

      // 通知 UI 更新
      update();
    }
  }

  jumpToPage(int index) {
    tabCurrentIndex.value = index;
    pageController.jumpToPage(index);

    requestActivityDetail(forceRefresh: false);
  }

  // 请求活动详情
  requestActivityDetail({bool? forceRefresh = true}) async {
    /// 非强制刷新
    /// 当 forceRefresh = false 且 当前tab缓存有数据时不请求
    // if (forceRefresh != null && !forceRefresh) {
    //   List list = getData(tabCurrentIndex);
    //   if (list.isNotEmpty) {
    //     return;
    //   }
    // }

    try {
      isLoading.value = true;
      EasyLoading.show(status: '加载中...');

      final res = await ActivityApi.reqActivityDetail(
        tabList[tabCurrentIndex.value].categoryName == '全部活动'
            ? '-'
            : tabList[tabCurrentIndex.value].id.toString(),
      );

      if (res.type == NetworkService.networkTypeSuccess) {
        final models = ActivityRightModel.fromJson(res.data['t']);

        // 优化筛选逻辑，确保 activityPgList 非空，并过滤 status == '1' 的数据
        models.activityPgList = (models.activityPgList ?? [])
            .where((item) => item.isShowPic?.toString() == '1')
            .toList();

        rightModel.value = models;
      }
      // num tabId = tabList[tabCurrentIndex.value].id;
      // final res = await ActivityApi.reqTabListData(tabId);
      // if (res.type == NetworkService.networkTypeSuccess) {
      //   List<ActivityListItemBean> result =
      //       ActivityListBean.fromJson(res.data['data']).data!;
      //   if (res.data['data'] is List && res.data['data'].length > 0) {
      //     _dataMap[tabCurrentIndex.toString()] = result;
      //   } else {
      //     _dataMap[tabCurrentIndex.toString()] = [];
      //   }
      // }
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  void sortAndGroupByActiveType(List<ActivityListItemBean> result) {
    final List<ActivityListItemBean> itemsWithEndTime = [];
    final List<ActivityListItemBean> itemsWithoutEndTime = [];

    for (var item in result) {
      if (item.elotActivityPg?.endTime?.isNotEmpty == true) {
        itemsWithEndTime.add(item);
      } else {
        itemsWithoutEndTime.add(item);
      }
    }

    itemsWithoutEndTime.sort((a, b) {
      if (a.activeType == null) return 1;
      if (b.activeType == null) return -1;
      return a.activeType!.compareTo(b.activeType!);
    });

    final Map<num?, List<ActivityListItemBean>> groupedMap = {};
    for (var item in itemsWithoutEndTime) {
      final key = item.activeType;
      groupedMap.putIfAbsent(key, () => []).add(item);
    }

    final sortedAndGroupedList =
        groupedMap.values.expand((group) => group).toList();

    final finalList = [...sortedAndGroupedList, ...itemsWithEndTime];

    result.clear();
    result.addAll(finalList);
  }

  // 点击领取
  Future<void> handleReceive() async {
    ActivityConfigurationInt activeConfiguration =
        ActivityManager.instance.activeConfiguration;

    // 有活动
    if (activeConfiguration['50']! == 0) {
      EasyLoading.showToast('当前暂无活动');
      return;
    }

    bool isLogin = LoginManager.instance.isLogin.value;
    if (isLogin) {
      // 访问任务的 113 活动
      // /task?type=1&taskType=113
    } else {
      showLoginDialog();
    }
  }

  String? getQueryParamValue(String url, String param) {
    final uri = Uri.parse(url);
    return uri.queryParameters[param];
  }

  // 转盘
  _gotoRelayRoulette() {
    // https://51zhh5.lg0808.com/activity/newsalary?token=3790700c-22a2-45f3-83a2-925f95c51fd2&cust_id=424168
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
          '${ns.baseURL}/activity/relayRoulette?token=${accessToken}&cust_id=${custId}&platform=${platform}';
      // print('url: ${url}');
      webViewController.loadRequest(Uri.parse(url));
      Get.toNamed(
        Routes.WEB_PAGE,
        arguments: {
          'webViewController': webViewController,
        },
      );
    }
  }

  /// 推广 分享赚现金
  _gotoNewsalary() {
    // 推广 分享赚现金
    // https://51zhh5.lg0808.com/activity/newsalary?token=3790700c-22a2-45f3-83a2-925f95c51fd2&cust_id=424168
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
          '${ns.baseURL}/activity/newsalary?token=${accessToken}&cust_id=${custId}&platform=${platform}';
      // print('url: ${url}');
      webViewController.loadRequest(Uri.parse(url));
      Get.toNamed(
        Routes.WEB_PAGE,
        arguments: {
          'webViewController': webViewController,
        },
      );
    }
  }

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

      // print('_gotoH5Acticity url: ${url}');
      webViewController.loadRequest(Uri.parse(url));
      Get.toNamed(
        Routes.WEB_PAGE,
        arguments: {
          'webViewController': webViewController,
        },
      );
    }
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

  /// 点击活动
  Future<void> handleActivity(ActivityPgList itemData) async {
    print("输出一下活动点击数据：${itemData.toString()}");
    final data = jsonDecode(itemData.actionCfg ?? '');
    if (data != null && data['showType'] == 2) {
      Get.toNamed(Routes.WEB_VIEW, arguments: {
        "url": data['links'], //请求地址
        "isShowGameBack": false,
        "isShowTitle": true,
        "title": itemData.activityName,
        "isShowRecharge": false,
      });
    } else {
      switch (itemData.activityType) {
        case '1':
          Get.toNamed(Routes.RELIEF_FUND, arguments: {
            'aid': itemData.id.toString(),
            'title': itemData.activityName,
            "type": ActivityTypsEnum.recharge,
          });
        case '2':
          final res =
              await ActivityApi.reqActivityDetails(itemData.id.toString());
          if (res.type == NetworkService.networkTypeSuccess) {
            final data = ActivityCodingModel.fromJson(res.data);
            Get.toNamed(
              Routes.ACTIVITY_DETAIL,
              arguments: {
                "title": itemData.activityName,
                "type": ActivityTypsEnum.coding,
                "codingModel": data,
              },
            );
          }
        case '3':
          Get.toNamed(Routes.RELIEF_FUND, arguments: {
            'aid': itemData.id.toString(),
            'title': itemData.activityName,
            "type": ActivityTypsEnum.none,
          });
        case '4':
          final signInIndex = actController.activityData.indexWhere(
            (activity) => activity.title == '签到',
          );
          actController.jumpToPage(signInIndex);
        case '5':
          Get.toNamed(Routes.LEADERBOARD_REWARD, arguments: {
            'aid': itemData.id.toString(),
          });
        case '6':
          Get.toNamed(Routes.WELCOME_BONUS, arguments: {
            'aid': itemData.id.toString(),
          });
        case '7':
          final res =
              await ActivityApi.reqActivityDetails(itemData.id.toString());
          if (res.type == NetworkService.networkTypeSuccess) {
            final data = ActivityCodingModel.fromJson(res.data);
            Get.toNamed(
              Routes.ACTIVITY_DETAIL,
              arguments: {
                "title": itemData.activityName,
                "type": ActivityTypsEnum.custom,
                "customModel": data,
              },
            );
          }
        case '8':
          // final res = await ActivityApi.reqLuckyActivityDetail(itemData.id.toString());
          // if (res.type == NetworkService.networkTypeSuccess) {
          //   final data = LuckyBetModel.fromJson(res.data);
          //   Get.toNamed(
          //     Routes.ACTIVITY_DETAIL,
          //     arguments: {
          //       "title": itemData.activityName,
          //       "type": ActivityTypsEnum.lucky,
          //       "luckyBetModel": data,
          //       "listItemBean": itemData
          //     },
          //   );
          // }
          final res =
              await ActivityApi.reqActivityDetails(itemData.id.toString());
          if (res.type == NetworkService.networkTypeSuccess &&
              res.data['t'] != null) {
            print({'ActivityTurntableDetailModel ====== ${res.data['t']}'});
            activityTurntableDetailData =
                ActivityTurntableDetailModel.fromJson(res.data['t']);
            Get.toNamed(
              Routes.ACTIVITY_TURNTABLE,
              arguments: {
                "model": activityTurntableDetailData,
              },
            );
          } else {
            EasyLoading.showToast('活动不存在');
          }
        case '9':
          final signInIndex = actController.activityData.indexWhere(
            (activity) => activity.title == '任务',
          );
          actController.jumpToPage(signInIndex);
        case '10':
          final res =
              await ActivityApi.reqActivityDetails(itemData.id.toString());
          if (res.type == NetworkService.networkTypeSuccess) {
            final data = ActivityCodingModel.fromJson(res.data);
            Get.toNamed(
              Routes.REDBAG_DETAIL,
              arguments: {
                "model": data.t,
              },
            );
          }
        case '11':
          final res =
              await ActivityApi.reqActivityDetails(itemData.id.toString());
          if (res.type == NetworkService.networkTypeSuccess) {
            final data = ActivityCodingModel.fromJson(res.data);
            Get.toNamed(
              Routes.ACTIVITY_DETAIL,
              arguments: {
                "title": itemData.activityName,
                "type": ActivityTypsEnum.presave,
                "presaveModel": data,
              },
            );
          }
        case '12':
          _withAuthJumpToH5Activity(
              uri: '/activity/newsalary', aid: itemData.id.toString());
        case '13':
          final res =
              await ActivityApi.reqLuckyActivityDetail(itemData.id.toString());
          if (res.type == NetworkService.networkTypeSuccess) {
            final data = LuckyBetModel.fromJson(res.data);
            Get.toNamed(
              Routes.ACTIVITY_DETAIL,
              arguments: {
                "title": itemData.activityName,
                "type": ActivityTypsEnum.lucky,
                "luckyBetModel": data,
                "listItemBean": itemData
              },
            );
          }
          break;
        default:
      }
    }

    //   // print({'object ==========${itemData.toJson()}'});
    //   if (!content.contains('http')) {
    //     String? aidValue = getQueryParamValue(content, 'aid');
    //     String aid = '${aidValue ?? itemData.id}';
    //     print('content:$content, aid:$aid');
    //     if (content.contains('activity/rank')) {
    //       _isUserLogin(() {
    //         // 排行榜
    //         Get.toNamed(Routes.LEADERBOARD_REWARD, arguments: {
    //           'aid': aid,
    //         });
    //       });
    //     } else if (content.contains('activity/newcomer')) {
    //       _isUserLogin(() {
    //         // 新人彩金
    //         Get.toNamed(Routes.WELCOME_BONUS, arguments: {
    //           'aid': aid,
    //         });
    //       });
    //     } else if (content.contains('activity/relayRoulette')) {
    //       // 助力转盘
    //       _withAuthJumpToH5Activity(uri: '/activity/relayRoulette', aid: aid);
    //     } else if (content.contains('activity/newsalary')) {
    //       // 分享赚现金
    //       _withAuthJumpToH5Activity(uri: '/activity/newsalary', aid: aid);
    //     } else if (content.contains('activity/reliefFund')) {
    //       // 救援金活动
    //       Get.toNamed(Routes.RELIEF_FUND, arguments: {
    //         'aid': aid,
    //         'title': itemData.subject,
    //         "type": ActivityTypsEnum.none,
    //       });
    //       // _withAuthJumpToH5Activity(uri: '/activity/reliefFund', aid: aid);
    //     } else if (content.contains('activity/rechargeGift')) {
    //       // 充值活动
    //       Get.toNamed(Routes.RELIEF_FUND, arguments: {
    //         'aid': aid,
    //         'title': itemData.subject,
    //         "type": ActivityTypsEnum.recharge,
    //       });
    //       // _withAuthJumpToH5Activity(uri: '/activity/reliefFund', aid: aid);
    //     } else if (content.contains('activity/registerBonus')) {
    //       // final res = await HomeApi.getRedbagData();
    //       // if (res.type == NetworkService.networkTypeSuccess) {
    //       //   final logredModel = ActivityLogredbagModel.fromJson(res.data);
    //       String? tasksId = getQueryParamValue(content, 'tasks_id');
    //       final detail = await HomeApi.getRedbagDetailData(tasksId!);
    //       final data = ActivityRedbagDetailModel.fromJson(detail.data);
    //       Get.toNamed(
    //         Routes.ACTIVITY_DETAIL,
    //         arguments: {
    //           "title": itemData.subject,
    //           "itemData": null,
    //           "isRedbag": true,
    //           "logRedbagModel": null,
    //           "redbagDetailModel": data
    //         },
    //       );
    //       // }
    //     } else if (content.contains('activity/lucky-bet')) {
    //       final res = await ActivityApi.reqLuckyActivityDetail(aid);
    //       if (res.type == NetworkService.networkTypeSuccess) {
    //         final data = LuckyBetModel.fromJson(res.data);
    //         Get.toNamed(
    //           Routes.ACTIVITY_DETAIL,
    //           arguments: {
    //             "title": itemData.subject,
    //             "type": ActivityTypsEnum.lucky,
    //             "luckyBetModel": data,
    //             "listItemBean": itemData
    //           },
    //         );
    //       }
    //     } else if (content.contains('activity/play')) {
    //       final res = await ActivityApi.reqActivityDetails(aid);
    //       if (res.type == NetworkService.networkTypeSuccess) {
    //         final data = ActivityCodingModel.fromJson(res.data);
    //         Get.toNamed(
    //           Routes.ACTIVITY_DETAIL,
    //           arguments: {
    //             "title": itemData.subject,
    //             "type": ActivityTypsEnum.coding,
    //             "codingModel": data,
    //           },
    //         );
    //       }
    //     } else if (content.contains('activity/redPackets')) {
    //       final res = await ActivityApi.reqActivityDetails(aid);
    //       if (res.type == NetworkService.networkTypeSuccess) {
    //         final data = ActivityCodingModel.fromJson(res.data);
    //         Get.toNamed(
    //           Routes.REDBAG_DETAIL,
    //           arguments: {
    //             "model": data.t,
    //           },
    //         );
    //       }
    //     } else if (content.contains('activity/luckyWheel')) {
    //       // if (!LoginManager.instance.isLogin.value) {
    //       //   showLoginDialog();
    //       //   return;
    //       // }
    //       final res = await ActivityApi.reqActivityDetails(aid);
    //       if (res.type == NetworkService.networkTypeSuccess &&
    //           res.data['t'] != null) {
    //         print({'ActivityTurntableDetailModel ====== ${res.data['t']}'});
    //         final data = ActivityTurntableDetailModel.fromJson(res.data['t']);
    //         Get.toNamed(
    //           Routes.ACTIVITY_TURNTABLE,
    //           arguments: {
    //             "model": data,
    //           },
    //         );
    //       } else {
    //         EasyLoading.showToast('活动不存在');
    //       }
    //     } else if (content.contains('activity/custom')) {
    //       final res = await ActivityApi.reqActivityDetails(aid);
    //       if (res.type == NetworkService.networkTypeSuccess) {
    //         final data = ActivityCodingModel.fromJson(res.data);
    //         Get.toNamed(
    //           Routes.ACTIVITY_DETAIL,
    //           arguments: {
    //             "title": itemData.subject,
    //             "type": ActivityTypsEnum.custom,
    //             "customModel": data,
    //           },
    //         );
    //       }
    //     } else if (content.contains('activity/prestoreReward')) {
    //       final res = await ActivityApi.reqActivityDetails(aid);
    //       if (res.type == NetworkService.networkTypeSuccess) {
    //         final data = ActivityCodingModel.fromJson(res.data);
    //         Get.toNamed(
    //           Routes.ACTIVITY_DETAIL,
    //           arguments: {
    //             "title": itemData.subject,
    //             "type": ActivityTypsEnum.presave,
    //             "presaveModel": data,
    //           },
    //         );
    //       }
    //     } else {
    //       EasyLoading.showToast('敬请期待～');
    //     }

    //     return;
    //   }

    //   // 使用内嵌方式打开
    //   Get.toNamed(Routes.WEB_VIEW, arguments: {
    //     "url": itemData.content, //请求地址
    //     "isShowGameBack": false,
    //     "isShowTitle": true,
    //     "title": itemData.subject,
    //     "isShowRecharge": false,
    //   });
    //   return;
    // }

    // // 内部链接
    // if (itemData.content_type == ActivityContentType.Link) {
    //   // 游戏1 任务2
    //   if (itemData.link_type == 1) {
    //     //
    //   } else if (itemData.task_type == 1) {
    //     // 充值
    //     Get.toNamed(Routes.RECHARGE);
    //   } else if (itemData.task_type == 3) {
    //     // 分享赚现金
    //     _withAuthJumpToH5Activity(uri: '/activity/newsalary');
    //   } else if (itemData.task_type == 7) {
    //     // 幸运大转盘
    //     _withAuthJumpToH5Activity(uri: '/activity/roulette');
    //   } else if (itemData.task_type == 8) {
    //     // 助力转盘
    //     _withAuthJumpToH5Activity(uri: '/activity/relayRoulette');
    //   } else if (itemData.task_type == 16) {
    //     //  分享赚现金
    //     _withAuthJumpToH5Activity(uri: '/activity/newsalary');
    //   } else if (itemData.task_type == 13) {
    //     // 救援金活动
    //     _withAuthJumpToH5Activity(uri: '/activity/reliefFund');
    //   } else if (itemData.task_type == 2) {
    //     actController.jumpToPage(1);
    //     actController.taskTabIndex.value = ActivityConstants.ACTIVITY_TYPE_102;
    //   } else if (itemData.activeType == 199 && itemData.content_type == 4) {
    //     final signInIndex = actController.activityData.value.indexWhere(
    //       (activity) => activity.title == '签到',
    //     );
    //     actController.jumpToPage(signInIndex);
    //   } else if (itemData.task_type == 4) {
    //     actController.jumpToPage(1);
    //     actController.taskTabIndex.value = ActivityConstants.ACTIVITY_TYPE_103;
    //   } else {
    //     EasyLoading.showToast('敬请期待～');
    //   }
    //   print(
    //       'name:${itemData.activeName}, task_type:${itemData.task_type}, content:${itemData.content}');
    //   return;
    // }

    // if (itemData.content_type == ActivityContentType.Image &&
    //     itemData.activeType == 71) {
    //   String content = itemData.content ?? '';
    //   String? aidValue = getQueryParamValue(content, 'aid');
    //   String aid = '${aidValue ?? itemData.id}';
    //   Get.toNamed(Routes.RELIEF_FUND, arguments: {
    //     'aid': aid,
    //     'title': itemData.subject,
    //     "type": ActivityTypsEnum.recharge,
    //   });
    //   return;
    // }

    // final result = await Get.toNamed(
    //   Routes.ACTIVITY_DETAIL,
    //   arguments: {"title": itemData.subject, "itemData": itemData},
    // );

    // if (result != null) {
    //   handleReturnCallback(result);
    // }

    // Get.toNamed(Routes.ACTIVITY);
    // // 文字和图片
    // if (itemData.bulletin_id != 0) {
    //   isShowBulletinId.value = isShowBulletinId.value == itemData.bulletin_id
    //       ? 0
    //       : itemData.bulletin_id!;
    // }
  }

  void handleReturnCallback(dynamic result) {
    actController.jumpToPage(6);
  }

  void _handleJavaScriptMessage(JavaScriptMessage message) {
    try {
      final data = json.decode(message.message);
      if (data['type'] == 'backToFlutter') {
        Get.back();
      }
    } catch (e) {
      print('Failed to parse message: $e');
    }
  }

  void nextPage() {
    if (tabCurrentIndex.value < tabList.length - 1) {
      tabCurrentIndex.value++;
      pageController.animateToPage(
        tabCurrentIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (tabCurrentIndex.value > 0) {
      tabCurrentIndex.value--;
      pageController.animateToPage(
        tabCurrentIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
