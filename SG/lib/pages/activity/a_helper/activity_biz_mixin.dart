import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bet/app/modules/vault/views/vault_dialog_view.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/widget/custom_toast.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:get/get.dart';

import '../../../app/modules/rotary/views/lucky_wheel/view.dart';
import '../../../constant/app_values.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/route_util.dart';
import '../../../utils/url_launch_util.dart';
import '../../account/login/login_widget.dart';
import '../../alliance_plan/alliance_plan_view.dart';
import '../../home/home_logic.dart';
import '../../main/code.dart';
import '../../main/logic.dart';
import '../a_model/activity_common_params.dart';
import '../a_model/activity_quick_api_model.dart';
import '../a_model/activty_sidebar_api_model.dart';
import '../activity_cash_back/activity_cash_back_view.dart';
import '../activity_custom/activity_custom_view.dart';
import '../activity_promotion/activity_promotion_view.dart';
import '../all_promotions/all_promotions_api_model.dart';
import '../all_promotions/all_promotions_view.dart';
import 'activity_biz_helper.dart';

///活动 公共业务 mixin
mixin ActivityBizMixin {
  // final MainLogic logic = Get.find<MainLogic>();
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  ///自定义生命周期方法， 方便使用去调用初始化
  void onInitActivityBizMixin() {
    log("onInitActivityBizMixin...");
  }

  ///当点击活动菜单 item
  void onClickActivityMenuMixin(ActivitySidebarApiModel model) {
    //{
    //   "id": "39501624986258877",
    //   "name": "小猫咪喵喵喵",
    //   "ty": 1,
    //   "icon": "/promos/icons/1.webp"
    // }
    // log('点击了...促销活动...itemModel.ty...${itemModel.ty}');
    log("活动菜单 item 点击... ${model.toString()}");
    // _dealItemClickAdapter(model.ty, model.id);
    // 判断是否是点击全部
    // if (model.ty == ActivityTypeEnum.all.type) {
    //   AllPromotionsPage.openPage();
    // } else {
    //   _dealItemClickAdapter(
    //     displayType: model.displayType,
    //     buttonType: model.buttonType,
    //     buttonRedirect: model.buttonRedirect,
    //     ty: model.ty,
    //     pid: model.id,
    //   );
    // }
    _commonItemClickAdapter(
      displayType: model.displayType,
      buttonType: model.buttonType,
      buttonRedirect: model.buttonRedirect,
      ty: model.ty,
      pid: model.id,
    );
  }

  ///当点击活动列表 item
  void onClickActivityItemMixin(AllPromotionsApiModel model) {
    log("活动列表 item 点击... ${model.toString()}");
    // _dealItemClickAdapter(model.ty, model.id);
    _commonItemClickAdapter(
      displayType: model.displayType,
      buttonType: model.buttonType,
      buttonRedirect: model.buttonRedirect,
      ty: model.ty,
      pid: model.id,
      state: model.state, //活动状态
    );
  }

  ///当点快捷入口 item
  void onQuickActivityItemClickMixin(ActivityQuickApiModel model) {
    log("活动 快捷入口 点击... ${model.toString()}");
    _commonItemClickAdapter(
      displayType: model.displayType,
      buttonType: model.buttonType,
      buttonRedirect: model.buttonRedirect,
      ty: model.ty,
      pid: model.id,
      state: model.state, //活动状态
    );
  }
  ///点击内部公用方法
  void _commonItemClickAdapter({
    required String? displayType,
    required int? buttonType,
    required String? buttonRedirect,
    int? ty,
    String? pid,
    int? state, //活动状态
  }) {
    var activityType = ActivityTypeEnum.adaptor(ty);
    log("活动菜单跳转参数：displayType=$displayType（1:内置页面 2:跳转外部链接）...buttonType=$buttonType...buttonRedirect=$buttonRedirect");

    //todo: 0510 【APP-登录/注册】未登录点击活动，应该跳注册的页面
    //todo: 0529 【APP-登录/注册】未登录点击活动，可以跳转推广活动详情
    //排除查看全部
    // if (activityType == ActivityTypeEnum.promotion && !globalController.isLoginState()) {
    //   globalController.doGoToRegister(Get.overlayContext, duration: 100);
    //   return;
    // }
    /// ty 1-轮盘抽奖 2-推广 3-抢红包活动 4-负盈利 5-自定义
    GlobalStateController.of().showOverlayView(isShowTopBarView: true, isShowBottomBarView: true);
    switch (activityType) {
      case ActivityTypeEnum.promotion:
        ActivityPromotionPage.openPage(pid, ActivityTimeState.adaptor(state));
        break;
      case ActivityTypeEnum.turntable:
        pushView(pid!);
        break;
      case ActivityTypeEnum.redPacket:
        RouteUtil.pushToView(Routes.redPacket, arguments: {"pid": pid});
        break;
      case ActivityTypeEnum.negativeProfit:
        ActivityCashBackPage.openPage(pid!);
        break;
      case ActivityTypeEnum.custom:
        // ActivityCustomPage.openPage(pid);
        customActivityJumpBizAdapter(
          displayType: displayType,
          buttonType: buttonType,
          buttonRedirect: buttonRedirect,
          ty: ty,
          pid: pid,
        );
        break;
      case ActivityTypeEnum.all:
        AllPromotionsPage.openPage();
        break;
      default:
        break;
    }
  }

  /// display_type 展示方式 1:内置页面 2:跳转外部链接
  /// button_type 跳转类型 1自定义 2娱乐城 3体育 4保险库 5VIP 6联盟计画 7优惠活动 8在线客服
  ///自定义活动跳转逻辑,适配不同的model
  void customActivityJumpBizAdapter({
    required String? displayType,
    required int? buttonType,
    required String? buttonRedirect,
    int? ty,
    String? pid,
  }) {
    // "button_redirect": "",
    // "button_type": "3",
    if (ActivityBizHelper.isOutsideLink(displayType)) {
      //外部链接
      if (buttonType == ActivityCustomJumpEnum.custom.type) {
        ActivityBizHelper.launchBtnURL(buttonRedirect);
      } else {
        dealCustomJumpPage(buttonType: buttonType, ty: ty, pid: pid);
      }
    } else {
      //内置页面
      ActivityCustomPage.openPage(pid);
    }
  }

  /// display_type 展示方式 1:内置页面 2:跳转外部链接
  /// button_type 跳转类型 1自定义 2娱乐城 3体育 4保险库 5VIP 6联盟计画 7优惠活动 8在线客服
  /// 自定义活动，页面跳转逻辑
  void dealCustomJumpPage({int? buttonType, int? ty, String? pid}) {
    var menuEnum = ActivityCustomJumpEnum.adaptor(buttonType);
    log("活动菜单跳转类型：menuEnum...${menuEnum?.label}");
    switch (menuEnum) {
      case ActivityCustomJumpEnum.custom:
        ActivityCustomPage.openPage(pid);
        break;
      case ActivityCustomJumpEnum.casino:
        MainLogic.of().onMenuSelected(MenuCode.GAME);
        break;
      case ActivityCustomJumpEnum.sport:
        RouteUtil.popView();
        GlobalState.instance.index = 3;
        MainLogic.of().onMenuSelected(MenuCode.MSG);
        break;
      case ActivityCustomJumpEnum.vault:
        RouteUtil.popView();
        // RouteUtil.pushToView(Routes.personalVault);
        VaultDialogView.openDialog();
        break;
      case ActivityCustomJumpEnum.vip:
        RouteUtil.popView();
        GlobalState.instance.index = 3;
        DialogUtils.goToPage(Routes.personalVip);
        break;
      case ActivityCustomJumpEnum.alliance:
        GlobalState.instance.index = 4;
        AlliancePlanPage.openPage();
        break;
      case ActivityCustomJumpEnum.activity:
        AllPromotionsPage.openPage();
        // _dealItemClickAdapter(ty, pid);
        break;
      case ActivityCustomJumpEnum.onlineService:
        RouteUtil.popView();
        if (globalController.csUrl.isEmpty) {
          globalController.brandCS();
          return;
        }
        UrlLaunchUtil.jumpCs();
        break;
      default:
        break;
    }
  }

  /// 页面跳转 ---没有ty，pid，有url
  /// display_type 展示方式 1:内置页面 2:跳转外部链接
  /// button_type 跳转类型 1自定义 2娱乐城 3体育 4保险库 5VIP 6联盟计画 7优惠活动 8在线客服
  void onTapJumpPage(
      {String? displayType,
      int buttonType = 0,
      String buttonRedirect = '',
      BuildContext? context}) {
    if (ActivityBizHelper.isOutsideLink(displayType)) {
      //外部链接
      ActivityBizHelper.launchBtnURL(buttonRedirect);
    } else {
      //内置页面
      switch (buttonType) {
        //跳转类型 1自定义 2娱乐城 3体育 4优惠活动 5联盟中心
        case 1:
          // ActivityCustomPage.openPage(pid);
          break;
        case 2:
          MainLogic.of().onMenuSelected(MenuCode.GAME);
          break;
        case 3:
          MainLogic.of().onMenuSelected(MenuCode.MSG);
          break;
        case 4:
          RouteUtil.popView();
          // RouteUtil.pushToView(Routes.personalVault);
          VaultDialogView.openDialog();
          break;
        case 5:
          RouteUtil.popView();
          GlobalState.instance.index = 3;
          DialogUtils.goToPage(Routes.personalVip);
          break;
        case 6:
          GlobalState.instance.index = 4;
          AlliancePlanPage.openPage();
          break;
        case 7:
          AllPromotionsPage.openPage();
          break;
        default:
      }
    }
  }
  ///转盘
  pushView(String id) {
    HomeLogic homeLogic = HomeLogic.of();
    GlobalStateController globalController = GlobalStateController.of();
    if (homeLogic.state.luckyRecordState == LuckyRecordState.first &&
        globalController.isLogin.value) {
      showLuckyWheelWidget(
          id: id,
          currencyId: homeLogic.state.currencyId,
          rollTimes: homeLogic.state.rollTimes.value
      );
    } else {
      RouteUtil.pushToView(
          Routes.rotary,
          arguments: {
            'id': id,
            'currencyId': homeLogic.state.currencyId
          });
    }
  }
  //启动app  装盘显示逻辑，等不登陆直接弹窗
  void showTurntableView({required String id, void Function()? onDialogDelete}) {
    HomeLogic homeLogic = HomeLogic.of();
    // GlobalStateController globalController = GlobalStateController.of();
    showLuckyWheelWidget(
        id: id,
        currencyId: homeLogic.state.currencyId,
        rollTimes: homeLogic.state.rollTimes.value,
        onDialogDelete: onDialogDelete);
  }
}
