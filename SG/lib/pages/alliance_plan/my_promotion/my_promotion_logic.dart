import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/widget/share/custom_share_widget_model.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../base/getx/page_state.dart';
import '../../../constant/app_urls_values.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../model/wallet/CurrencyBean.dart';
import '../../../services/api/api_service.dart';
import '../../../services/api/extension/alliance_api_service.dart';
import '../../../utils/permission_utils.dart';
import '../../../utils/ui_image_loader_util.dart';
import '../../../utils/url_launch_util.dart';
import '../../../widget/custom_toast.dart';
import '../../../widget/dialog/custom_dialog.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';
import '../../../widget/share/custom_share_params.dart';
import '../wmodel/alliance_common_params.dart';
import 'my_promotion_view_card_model.dart';

import 'dart:ui' as ui;

class MyPromotionLogic extends GetxController with GetTickerProviderStateMixin {
  final pageStateObs = PageState.DEFAULT.obs;

  final refreshCtrl = CustomRefreshController(controlFinishRefresh: true, controlFinishLoad: true);

  ///模拟card详情数据源
  final cardModelListObs = [
    //佣金card
    [
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_137,
        content: '0.00',
        contentType: ContentType.moneyWithCoin,
      ),
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_138,
        content: '0.00',
        contentType: ContentType.moneyWithCoin,
      ),
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_139,
        content: '0.00',
        contentType: ContentType.moneyWithCoin,
      ),
    ],
    //业绩card
    [
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_140,
        content: S.current.random_text_526,
      ),
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_142,
        content: S.current.random_text_526,
      ),
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_143,
        content: S.current.random_text_526,
      ),
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_157,
        content: "0.00",
        contentType: ContentType.moneyWithCoin,
      ),
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_144,
        content: "0.00",
        contentType: ContentType.moneyWithCoin,
      ),
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_145,
        content: "0.00",
        contentType: ContentType.moneyWithCoin,
      ),
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_971,
        content: "0.00",
        contentType: ContentType.moneyWithCoin,
      ),
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_972,
        content: "0.00",
        contentType: ContentType.moneyWithCoin,
      ),
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_973,
        content: "0.00",
        contentType: ContentType.moneyWithCoin,
      ),
    ],
    //直属投注
    [
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_527,
        content: "0.00",
        contentType: ContentType.moneyWithCoin,
      ),
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_148,
        content: "0",
      ),
      MyPromotionCardItemModel(
        isTitle: false,
        label: S.current.random_text_150,
        content: "0.00",
        colorType: ColorType.colorSwitch,
        contentType: ContentType.moneyWithCoin,
      ),
    ],
  ].obs;

  final tabList = [
    Tab(text: S.current.alliance_commission),
    Tab(text: S.current.random_text_129),
    Tab(text: S.current.random_text_60),
  ];
  late TabController tabController;

  final tabIndexObs = 0.obs;

  final myLink = "".obs;

  // final dataModelObs = AllianceMyPromotionApiModel().obs;
  final GlobalKey qrGlobalKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabList.length, initialIndex: 0, vsync: this);
    tabController.addListener(() {
      if (tabController.index.toDouble() == tabController.animation!.value) {
        tabIndexObs.value = tabController.index;
        // switch (tabController.index) {
        //   case 0:
        //     print("佣金");
        //     break;
        //   case 1:
        //     print("业绩");
        //     break;
        //   case 2:
        //     print("直属投注");
        //     break;
        // }
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    loadNetData(isRefresh: true, isFirst: true);
  }

  void loadNetData({required bool isRefresh, bool isFirst = false}) async {
    if (isFirst) {
      pageStateObs.value = PageState.LOADING;
    }
    await ApiService.instance.getMyPromotion(
      success: (model) {
        myLink.value = model.linkUrl ?? "";

        ///佣金
        cardModelListObs[0][0].content = model.commission!.accumulated;
        cardModelListObs[0][1].content = model.commission!.received;
        cardModelListObs[0][2].content = model.commission!.lastCommission;

        ///我的业绩
        cardModelListObs[1][0].content =
            "${model.performance!.teamNum} ${S.current.random_text_528}";
        cardModelListObs[1][1].content =
            "${model.performance!.directNum} ${S.current.random_text_528}";
        cardModelListObs[1][2].content =
            "${model.performance!.otherNum} ${S.current.random_text_528}";
        cardModelListObs[1][3].content = model.performance!.performanceAmount;
        cardModelListObs[1][4].content = model.performance!.directAmount;
        cardModelListObs[1][5].content = model.performance!.otherAmount;
        cardModelListObs[1][6].content = model.performance!.totalDeposit;
        cardModelListObs[1][6].contentSub =
            "/${model.performance!.depositNum}" + S.current.random_text_528;
        if (LangUtil().isViVn()) {
          cardModelListObs[1][6].contentSub =
              "/${model.performance!.depositNum} " + S.current.random_text_528;
        }
        cardModelListObs[1][7].content = model.performance!.directDeposit;
        cardModelListObs[1][8].content = model.performance!.otherDeposit;

        ///下属的赌注
        cardModelListObs[2][0].content = model.subordinate!.validBetAmount;
        cardModelListObs[2][1].content = "${model.subordinate!.betNum}";
        cardModelListObs[2][2].content = model.subordinate!.netAmount;
        update(["cardModelListObs"]);
        refreshCtrl.finishRefresh();
        pageStateObs.value = PageState.SUCCESS;
        // user.refresh();
      },
      fail: (isConnect, message, candy) {
        refreshCtrl.finishRefresh();
        //0216。未登录的情况下，我的推广也要显示界面数据
        pageStateObs.value = PageState.SUCCESS;
        // if (isConnect) {
        //   // pageStateObs.value = PageState.FAILED;
        //   //考虑到未登陆情况
        //   pageStateObs.value = PageState.EMPTY;
        // } else {
        //   pageStateObs.value = PageState.FAILED_SERVER;
        // }
      },
    );
  }

  // String get

  String getLink() {
    return '${AppUrlsValues.envConfig.api_url}${myLink.value}';
  }

  ///点击保存二维码
  void onClickSaveQr(BuildContext context) async {
    Permission permission;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if ((androidInfo.version.sdkInt ?? 0) <= 32) {
        permission = Permission.storage;
      } else {
        permission = Permission.photos;
      }
    } else {
      permission = Permission.photos;
    }

    bool result = false;
    await PermissionUtils.checkPermission(
        permission: permission,
        onSuccess: () {
          result = true;
        },
        goSetting: () async {
          bool? confirm = await showCustomDialog(
              title: S.current.random_text_347,
              confirm: S.current.random_text_529,
              content: S.current.random_text_530,
              context: context);
          if (confirm == true) {
            await openAppSettings();
          }
        });
    if (result) {
      await ImageLoaderUtil.saveImageToCamera(qrGlobalKey).then((success) {
        CustomToast.show(
            success ? S.current.random_text_531 : S.current.random_text_532, Get.overlayContext!);
      });
    }
  }

  ///复制链接
  void onClickCopyLink(BuildContext context, {bool toast = false}) {
    // Clipboard.setData(ClipboardData(text: connectionLink.value));
    Clipboard.setData(ClipboardData(text: getLink()));
    if (toast) CustomToast.show(S.current.random_text_151, context);
    log("复制成功");
  }

  ///跳转分享链接
  void onClickShareLaunchLink(BuildContext context, ShareTypeEnum typeEnum) {
    var shareUrl = '${typeEnum.baseShare}${getLink()}';
    // log("分享：$shareUrl");
    UrlLaunchUtil.launchURL(shareUrl).then((message) {
      if (message.isNotEmpty) {
        CustomToast.show(message, context);
      }
    });
  }

  CurrencyBean? currencyBean;

  CurrencyBean? getUsdtCoin() {
    if (currencyBean == null) {
      currencyBean = GlobalStateController.of()
          .localConfigCoinLists
          .firstWhere((element) => element.name!.contains("USDT"));
    }
    // log("我的推广货币：${JsonUtil.encodeObj(currencyBean)}");
    return currencyBean;
  }
}
