import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/notifis/notification.dart';
import 'package:flutter_bet/model/notifis/announcement.dart';
import 'package:flutter_bet/model/page.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/notifs_api_service.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/refresh/custom_pull_to_refresh_controller.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:get/get.dart';
import '../main/logic.dart';

class NotifsLogic extends BaseController with GetTickerProviderStateMixin {
  late BuildContext ctx;
  final MainLogic logic = Get.find<MainLogic>();

  /// 类型列表
  List<String> typeTitles = [
    S.current.notification,
    S.current.notifs_site_message,
    S.current.notifs_announcement,
    // S.current.notifs_marquee,
    S.current.notifs_rewarded_feedback,
  ];

  late TabController tabController;


  /// 当前类型下标
  int typeSelIndex = 0;

  /// Page
  var cPage = 1;
  final cPageSize = 20;

  final CustomPullToRefreshController pullToRefreshController =
  CustomPullToRefreshController(controlFinishRefresh: true, controlFinishLoad: true);

  /// 消息列表 当前消息类型选项消息
  List notifsInfos = [];

  /// 列表数据加载 loding
  var isInitLoding = true;
  
  var timenow = 0;
  
  /// 消息类型选择
  void typeDidSelIndex(int index) {

    // 组件点击，两次回调事件抵消
    if(DateTime.now().millisecondsSinceEpoch - timenow < 100) {
      return;
    }
    timenow = DateTime.now().millisecondsSinceEpoch;

    typeSelIndex = index;
    cPage = 1;
    notifsInfos = [];
    isInitLoding = true;
    reqNotifsList();
    update(["notifs_index"]);
  }

  /// 下拉刷新
  Future<void> onRefresh() async {
    cPage = 1;
    reqNotifsList();
  }

  /// 加载更多
  Future<void> onLoadMore() async {
    reqNotifsList();
  }

  /// 通知消息列表
  Future<void> reqNotifsList() async {
    final temTypeSelIndex = typeSelIndex;
    switch (temTypeSelIndex) {
      case 0:
        await ApiService.instance.notificationsList(page: cPage, pageSize: cPageSize, success: (page) {
          parsePageInfo(page);
        }, fail: (errorMessage) {
          CustomSnackBar.showError(errorMessage!, ctx);
          isInitLoding = false;
          pullToRefreshController.finishRefresh();
          update(["notifs_index"]);
        });

        break;
      case 1:
        await ApiService.instance.inboxMsgList(page: cPage, pageSize: cPageSize, success: (page) {
          parsePageInfo(page);
        }, fail: (errorMessage) {
          CustomSnackBar.showError(errorMessage!, ctx);
          isInitLoding = false;
          pullToRefreshController.finishRefresh();
          update(["notifs_index"]);
        });
        break;
      case 2:
        await ApiService.instance.announcementList(
            page: cPage, pageSize: cPageSize,
            typeCode: "1",
            success: (page) {
              parsePageInfo(page);
            },
            fail: (errorMessage) {
              CustomSnackBar.showError(errorMessage!, ctx);
              isInitLoding = false;
              pullToRefreshController.finishRefresh();
              update(["notifs_index"]);
            });
        break;
      default:
    }
  }

  void parsePageInfo(PageModel page) {
    final milliseconds = (isInitLoding) ? 150 : 0;
    final temTypeSelIndex = typeSelIndex;
    Future.delayed(Duration(milliseconds: milliseconds), () {
      if (temTypeSelIndex == typeSelIndex) {
        if (cPage == 1) {
          notifsInfos = [];
          pullToRefreshController.finishLoad();
        }

        if (page.curPageSize == cPageSize) {
          cPage += 1;
          pullToRefreshController.finishLoad();
        } else {
          cPage += 1;
          pullToRefreshController.finishLoad(result: CustomIndicatorResult.noMore);
        }

        notifsInfos.addAll(page.content);
        isInitLoding = false;
        update(["notifs_index"]);
      } else {
        isInitLoding = false;
        update(["notifs_index"]);
      }
    });
  }

  /// 消息全部已读
  Future<void> notifsStateAllRead() async {
    switch (typeSelIndex) {
      case 0:
        ApiService.instance.notificationsMsgState(id: "", success: (data) {
          for (var element in notifsInfos) {
            element.isRead = 2;
          }
          update(["notifs_index"]);
        }, fail: (String? message) {});
        break;
      case 1:
        ApiService.instance.inboxMsgState(id: "", success: (data) {
          for (var element in notifsInfos) {
            element.state = 1;
          }
          update(["notifs_index"]);
        }, fail: (String? message) {});
        break;
      default:
    }

  }

  /// 消息改为已读
  /// AnnouncementModel /
  Future<void> notifsState(model) async {
    if (!model.isUnread) {
      return;
    }

    if(model.runtimeType == AnnouncementModel) {
      model.state = 1;
    }
    if(model.runtimeType == NotifsInfo) {
      model?.isRead = 2;
    }
    update(["notifs_index"]);

    switch (typeSelIndex) {
      case 0:
        await ApiService.instance
            .notificationsMsgState(id: model.id, success: (data) {}, fail: (String? message) {});
        break;
      case 1:
        await ApiService.instance
            .inboxMsgState(id: model.id, success: (data) {}, fail: (String? message) {});
        break;
      case 2:
        await ApiService.instance
            .announcementState(id: model.id, success: (data) {}, fail: (String? message) {});
        break;
      default:
    }
  }

  /// 通知/站内信 删除
  Future<void> notifsDelete(model) async {

    switch (typeSelIndex) {
      case 0:
        notifsInfos.remove(model);
        update(["notifs_index"]);
        await ApiService.instance
            .notificationsMsgDelete(id: model.id, success: (data) {
        }, fail: (String? message) {});
        break;
      case 1:
        notifsInfos.remove(model);
        update(["notifs_index"]);
        await ApiService.instance
            .inboxMsgDelete(id: model.id, success: (data) {
        }, fail: (String? message) {});
        break;
      case 2:
      default:
    }

  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: typeTitles.length, vsync: this);

    // 推送更新消息列表
    final GlobalStateController globalController = Get.find<GlobalStateController>();
    ever(globalController.newNoticeUpdate, (newNoticeUpdate) {
      cPage = 1;
      reqNotifsList();
    });
  }

  @override
  void onReady() {
    super.onReady();
    reqNotifsList();
  }

  @override
  void onClose() {
    super.onClose();
    logic.notificationsCount();
  }
}
