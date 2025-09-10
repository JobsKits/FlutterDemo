import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/services/api/extension/vip_api_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:get/get.dart';
import '../../../../controllers/global_state_controller.dart';
import '../../../../model/statisical_data/StatisicalDataBean.dart';
import '../../../../model/user.dart';
import '../../../../model/viplevel/viplevel_config_model.dart';
import '../../../../pages/front/front_state.dart';
import '../../../../services/account_service.dart';
import '../../../../services/api/api_service.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/time/time_utils.dart';

class StatisticalDataController extends GetxController with GetTickerProviderStateMixin {
  //TODO: Implement StatisticalDataController
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final coinIcDomain = '${AppValues.defaultBranch.asset_url}/currency/';
  final coinIcExtensionName = ".webp";
  final statisticalData = [].obs;
  List<VipLevelModel> dataList = [];
  late final FrontState state = FrontState();
  late User currentUser;
  final currentLevel = "0".obs;
  final vipLevel = "0".obs;
  final nextLevelAmount = "0".obs;
  final currentAlias = "".obs;
  final nextAlias = "".obs;
  final completeRate = 0.00.obs;
  AccountServiceListener? accountListener;
  final isLoadComplete = false.obs;
  final loadingData = false.obs;
  final pageIndex = 0.obs;
  var oldIndex = 0;
  var username = "";
  var showAppBar = true;
  var currencyWidth = 80.0.obs;
  var countWidth = 90.0.obs;
  var betWidth = 0.0.obs;
  var winWidth = 0.0.obs;
  var allWidth = 0.0.obs;
  // late ScrollController scrollController = ScrollController();
  late TabController tabController;

  final tabs = [
    Tab(
      child: Text(S.current.sport_all,
          style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ),
    Tab(
      child: Text(S.current.tab_bar_ent,
          style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ),
    Tab(
      child: Text(S.current.tab_bar_sports,
          style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ),
  ];

  final showDetail = false.obs;
  List<StatisicalDataBean> detailList = [];

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(vsync: this, length: tabs.length);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        onTap(tabController.index);
      }
    });
    if (AccountService.sharedInstance.isLogin()) {
      currentUser = AccountService.sharedInstance.currentUser!;
    }
    loadVipLevelData();
    accountListener = AccountServiceListener(
        onLoginSuccess: (model) {
          loadVipLevelData();
          print("接收到登录成功");
        },
        onLogout: () {},
        onTokenInvalid: () async {});
    AccountService.sharedInstance.addListener(accountListener!);
  }

  @override
  void onReady() {
    super.onReady();
    betReport(0);
  }

  void onTap(index) {
    if (index == oldIndex) return;
    pageIndex.value = -1;
    // scrollController.animateTo(Get.width * index, duration: const Duration(milliseconds: 200), curve: Curves.ease);
    Future.delayed(const Duration(milliseconds: 200), () {
      pageIndex.value = index;
      oldIndex = index;
      betReport(index);
      showDetail.value = false;
    });
  }

  @override
  void onClose() {
    if (AccountService.sharedInstance.isLogin()) {
      currentUser = AccountService.sharedInstance.currentUser!;
    }
    // scrollController.dispose();
    super.onClose();
  }

  loadVipLevelData() async {
    if (AccountService.sharedInstance.isLogin() == false) {
      print("登录中");
      return;
    }

    // AccountService.sharedInstance.refreshUserInfo();
    currentUser = AccountService.sharedInstance.currentUser!;
    currentLevel.value = (int.parse(currentUser.vip!)).toString();
    vipLevel.value = (int.parse(currentUser.vip!) + 1).toString();

    currentAlias.value = "VIP${currentUser.vip}";
    nextAlias.value = "VIP${vipLevel.value}";
    // update(['front_view_vip']);

    await ApiService.instance.getVipLevelConfig(
      success: (data) {
        dataList.assignAll(data);
        VipLevelModel currentModel = dataList[int.parse(currentUser.vip!)];
        currentLevel.value = currentUser.vip!;
        log("neco 用户当前等级 ${currentUser.vip}---分数 ${currentUser.score}");
        if (int.parse(currentUser.vip!) < 10) {
          VipLevelModel model = dataList[int.parse(currentUser.vip!) + 1];
          if (currentUser.score == "") {
            nextLevelAmount.value = model.total.toString();
          } else {
            if (double.parse(model.total.toString()) > double.parse(currentUser.score!)) {
              String currentUserScore = currentUser.score!;
              String modelScore = model.total.toString();

              double result = (double.parse(modelScore) - double.parse(currentUserScore));

              nextLevelAmount.value = "$result";
            }
          }

          if (currentUser.score == "") {
            completeRate.value = 0;
          } else {
            String modelScore = model.total.toString();
            String currentUserScore = currentUser.score?.toString() ?? '0';
            double result = 0.0;
            if (double.parse(modelScore) != 0) {
              result = (double.parse(currentUserScore) / double.parse(modelScore) * 100);
            }
            if (double.parse(currentUserScore) > double.parse(modelScore)) {
              //特殊情况 当前等级的分数大于下一级的分数
              completeRate.value = 1 * 100;
            } else {
              completeRate.value = result;
            }
          }
        } else {
          VipLevelModel model = dataList[int.parse(currentUser.vip!)];
          completeRate.value = 1 * 100;

          if (currentUser.score == "") {
            nextLevelAmount.value = model.total.toString();
            nextAlias.value = "VIP${model.level}";
          } else {
            final currentUserScore = currentUser.score ?? '0';
            final modelScore = model.total.toString();

            final result = (int.parse(modelScore) - int.parse(currentUserScore)).toString();
            nextLevelAmount.value = result;
          }
        }

        // update(['front_view_vip']);
      },
      fail: (message) {
        print(message);
        print("登录中3");
      },
    );
  }

  void animate() {
    // 设置位移动画
    state.xOffset.value = 30.0;
    // 延迟一段时间后恢复原位
    Future.delayed(const Duration(milliseconds: 500), () {
      state.xOffset.value = 0.0;
    });
  }

  String getJoinTime() {
    //需求变更 无需额外处理
    // if(globalController.isVi()){
    //  return TimeUtils.timeStampToTimeDMY(AccountService.sharedInstance.currentUser?.createdAt ?? 0);
    // }
    // else if(LangUtil().isTh()){
    //   return TimeUtils.timeStampToTimeDMYThia(AccountService.sharedInstance.currentUser?.createdAt ?? 0);
    // }
    // else{
    //   return TimeUtils.timeStampToTimeYMD(AccountService.sharedInstance.currentUser?.createdAt ?? 0);
    // }
    return TimeUtils.timeStampToTimeYMD(AccountService.sharedInstance.currentUser?.createdAt ?? 0);
  }

  String getTime(String time) {
    switch (time) {
      case "1":
        return S.current.date_past_today;
      case "7":
        return S.current.random_text_621;
      case "30":
        return S.current.random_text_622;
      case "90":
        return S.current.random_text_623;
    }
    return "";
  }

  betReport(gameClass) async {
    loadingData.value = true;
    await ApiService.instance.betReport<StatisicalDataBean>(
        gameClass: gameClass == 0 ? '' : gameClass.toString(),
        username: username,
        success: (bean) {
          isLoadComplete.value = true;
          loadingData.value = false;
          statisticalData.assignAll(bean);
          for (var element in bean) {
            if (betWidth.value < element.validBetAmount!.length) {
              betWidth.value = element.validBetAmount!.length * 9 + 32;
            }
            if (winWidth.value < element.netAmount!.length) {
              winWidth.value = element.netAmount!.length * 9 + 32;
            }
          }
          if (showAppBar) {
            if (betWidth.value < 98) {
              betWidth.value = 98;
            }
            if (winWidth.value < 98) {
              winWidth.value = 98;
            }
          } else {
            if (betWidth.value < 89) {
              betWidth.value = 89;
            }
            if (winWidth.value < 89) {
              winWidth.value = 89;
            }
          }
          if (!globalController.isChinese()) {
            currencyWidth.value = 120;
            countWidth.value = 120;
            if (betWidth.value < 120) betWidth.value = 120;
          }
          allWidth.value = currencyWidth.value + countWidth.value + betWidth.value + winWidth.value;
        },
        fail: (message) {
          isLoadComplete.value = false;
          loadingData.value = false;
        },
        converter: (json) {
          return StatisicalDataBean.fromJson(json);
        });
  }
}
