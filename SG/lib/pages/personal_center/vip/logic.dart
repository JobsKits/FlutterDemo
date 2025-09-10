import 'dart:developer';

import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/model/notifis/exchange_rate.dart';
import 'package:flutter_bet/model/user.dart';
import 'package:flutter_bet/model/viplevel/vip_availiable_amount_model.dart';
import 'package:flutter_bet/model/viplevel/vip_fenglu_config_model.dart';
import 'package:flutter_bet/model/viplevel/vip_jifen_rate_model.dart';
import 'package:flutter_bet/model/viplevel/vip_rate_multiple.dart';
import 'package:flutter_bet/model/viplevel/vip_rebate_config_model.dart';
import 'package:flutter_bet/model/viplevel/viplevel_config_model.dart';
import 'package:flutter_bet/model/wallet/CurrencyBean.dart';
import 'package:flutter_bet/pages/main/code.dart';
import 'package:flutter_bet/pages/personal_center/vip/vipdetails/logic.dart';
import 'package:flutter_bet/pages/personal_center/vip/widgets/vip_FanshuiList_view.dart';
import 'package:flutter_bet/pages/personal_center/vip/widgets/vip_jinji_guize.dart';
import 'package:flutter_bet/pages/personal_center/vip/widgets/vip_lingqu_record.dart';
import 'package:flutter_bet/pages/personal_center/vip_club/vip_club_view_swiper.dart';
import 'package:flutter_bet/pages/sport/tabmodel.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/vip_api_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:flutter_bet/services/event/event_service.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/json_util.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/utils/sp_util.dart';
import 'package:flutter_bet/widget/custom_progress_hud.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import 'widgets/vip_FanshuiListDetails_view.dart';
import 'widgets/vip_baojiTips_view.dart';

const kCustomVipBonusWidget = 'CustomVipBonusWidget';
const kCustomVipTipsWidget = 'CustomVipTipsWidget';
const kCustomVipFanshuiWidget = 'kCustomVipFanshuiWidget';

class VipHomeLogic extends BaseController with GetTickerProviderStateMixin {
  // tab 控制器
  late TabController tabController;
  late User currentUser;
  String vipLevel = "0";
  String nextLevelAmount = "0";
  int selectedCoinIndex = 0;

  List<VipLevelModel> dataList = [];
  List<List<dynamic>> fengLudataList = [];
  Map<String, bool> fengLuNav = {};

  List<VipRateMultiple> rateList = [];
  List<VipRebateConfigModel> fanshuiList = [];
  late VipRebateConfigModel rebateConfigModle;

  final GlobalStateController globalController = Get.find<GlobalStateController>();

// tab 控制器
  int tabIndex = 0;
  int selectedFanshuiIndex = 0;
  List<Tab> tabsNoIcons = [
    Tab(
      text: S.current.vip_tab_bouns,
    ),
    Tab(
      text: S.current.random_text_1120,
    ),
    Tab(
      text: S.current.random_text_403,
    ),
    Tab(
      text: S.current.receive,
    ),
  ];
  List<SportHallCountModel> fanshuiTitleList = [];

  /// 币种列表
  List<CurrencyBean> coinInfos = [];

  /// 所选币种
  late CurrencyBean selCoin;

  /// 汇率信息
  late ExchangeRateModel rateTool = ExchangeRateModel(date: 1, rates: {});

  /// 所选币种汇率
  Decimal selCoinRate = Decimal.parse('0');

  /// 转换后的奖金
  String userCoinBonus = '0';

  late String bonus = "0";

  /// 所选俸禄
  int selJiangJinStringIndex = 0;

  bool isLoading = true;
  // 是否显示返水按钮
  bool showRebeatButton = false;

  List<VipAviliableAmountModel> availiableList = <VipAviliableAmountModel>[];

  Map<String, List<VipAviliableAmountModel>> availiableMap = {
    'daily': [
      VipAviliableAmountModel(
          id: "111",
          amount: "1",
          cashType: 820,
          vip: "1",
          state: 2,
          receiveAmount: "0.00",
          availableAmount: "0.00")
    ],
    'weekly': [
      VipAviliableAmountModel(
          id: "111",
          amount: "2",
          cashType: 820,
          vip: "1",
          state: 2,
          receiveAmount: "0.00",
          availableAmount: "0.00")
    ],
    "monthly": [
      VipAviliableAmountModel(
          id: "111",
          amount: "3",
          cashType: 820,
          vip: "1",
          state: 2,
          receiveAmount: "0.00",
          availableAmount: "0.00")
    ]
  };

  // 筛选货币的string
  String selectedCeachCoinString = "";

//输入框输入的领取金额
  String inputJieSuanString = "0.00";

  // 规则
  late List<String> ruleTitles;
  late List<String> ruleContents;

  //vipclub 的头部数据
  final swiperModelList = [
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper05.webp',
        title: 'Bespoke',
        detail: S.current.random_text_424),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper01.webp',
        title: S.current.random_text_416,
        detail: S.current.random_text_417),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper02.webp',
        title: S.current.random_text_693,
        detail: S.current.random_text_694),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper03.webp',
        title: S.current.random_text_420,
        detail: S.current.random_text_421),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper04.webp',
        title: S.current.random_text_422,
        detail: S.current.random_text_423),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper05.webp',
        title: 'Bespoke',
        detail: S.current.random_text_424),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper01.webp',
        title: S.current.random_text_416,
        detail: S.current.random_text_417),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper02.webp',
        title: S.current.random_text_693,
        detail: S.current.random_text_694),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper03.webp',
        title: S.current.random_text_420,
        detail: S.current.random_text_421),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper04.webp',
        title: S.current.random_text_422,
        detail: S.current.random_text_423),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper05.webp',
        title: 'Bespoke',
        detail: S.current.random_text_424),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper01.webp',
        title: S.current.random_text_416,
        detail: S.current.random_text_417),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper02.webp',
        title: S.current.random_text_693,
        detail: S.current.random_text_694),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper03.webp',
        title: S.current.random_text_420,
        detail: S.current.random_text_421),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper04.webp',
        title: S.current.random_text_422,
        detail: S.current.random_text_423),
  ];

  String? pageType = Get.arguments?["pageType"] ?? "vipRank";
  final ScrollController pageScrollController = ScrollController();

// 返水数据
  List<List<VipRebateConfigModel>> reSort = [];

//返水加载中
  bool isVipFanShuiLoading = true;
// 领取奖金的text controller

  late TextEditingController textEditingController;
  VipJifenRateModel vipRateModel = VipJifenRateModel(key: "702", value: "0,0", ty: 2);
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (pageType == "vipRank") {
      GlobalState.instance.index = 3;
    }
    ever(globalController.currTypeSelected, (CurrencyBean bean) {
      initData();
      getFengLuAvailiable();
    });
    initRules();
    // reqGetCoinTypeInfos();
    // reqExchangeRate();

    getFengLuAvailiable();

    initScroll();
    textEditingController = TextEditingController(text: "");

    tabController = TabController(length: tabsNoIcons.length, vsync: this, initialIndex: 0);
    tabController.addListener(() {
      tabIndex = tabController.index;
      if (tabIndex == 3) {
        if (Get.isRegistered<VipLingQuLogic>() == false) {
          Get.put(VipLingQuLogic());
        }
        Get.find<VipLingQuLogic>().currentSelectedIndex = 0;
        Get.find<VipLingQuLogic>().currentTypeSelectedIndex = 0;
        if (Get.isRegistered<VipLingQuLogic>() == true) {
          Get.find<VipLingQuLogic>().onReady();
        }
      }
      if (tabIndex == 2) {
        selectedFanshuiIndex = 0;
        getVipRebateData(0);
        getrebateButtonstatus();
      }
      update(['vip_home']);
    });
  }

  // tabbar点击
  void tabbarClicked(index) {
    tabIndex = index;
    if (index == 3) {
      if (Get.isRegistered<VipLingQuLogic>() == true) {
        Get.find<VipLingQuLogic>().onReady();
      }
    }
    update(['vip_home']);
  }

  /// 佣金领取
  void receiveCommissionAction() {}

  /// 佣金历史记录
  void commissionHistoryAction() {}

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    initData();
  }

  initData() async {
    fanshuiTitleList.clear();
    SportHallCountModel model =
        SportHallCountModel(si: 1, sn: "12", lc: 3, nc: 4, c: 5, cc: 6, spic: "7");
    fanshuiTitleList.add(model);
    fanshuiTitleList.add(model);
    fanshuiTitleList.add(model);

    await ApiService.instance.getVipLevelConfig(
      success: (data) {
        isLoading = false;
        dataList.clear();
        dataList.addAll(data);

        if (globalController.isLogin.value == true) {
          AccountService.sharedInstance.refreshUserInfo();
          currentUser = AccountService.sharedInstance.currentUser!;
        }

        update(['vip_home']);
      },
      fail: (message) {
        isLoading = false;
        update(['vip_home']);
      },
    );
    await ApiService.instance.getVipJiangJinConfig(
      cur: globalController.coinCur,
      success: (data) {
        fengLudataList.clear();
        Map<String, List<VipFengluConfigModel>> map = data.data;
        fengLuNav = data.nav;
        List<String> keys = map.keys.toList();
        List<int> intList = keys.map((str) => int.parse(str.substring(1))).toList();
        intList.sort((a, b) => a.compareTo(b));

        for (var element in intList) {
          fengLudataList.add(data.data["v${element}"] as List<dynamic>);
        }
        isLoading = false;

        update(['vip_home']);
      },
      fail: (message) {
        isLoading = false;
        update(['vip_home']);
      },
    );
    await ApiService.instance.getVipJiFenRate(
      cur: globalController.coinCur,
      success: (data) {
        vipRateModel = data;
        update(['vip_home']);
      },
      fail: (message) {
        isLoading = false;
        update(['vip_home']);
      },
    );
    // getrebateButtonstatus();
  }

  //判断是否有日俸禄
  shouldDayilyBonusVisibility(type) {
    List<String> keys = fengLuNav.keys.toList();
    if (keys.isEmpty) {
      return true;
    }
    if (keys.contains(type)) {
      return fengLuNav[type];
    }
    return false;
    // fengLuNav["type"]
    // bool shouldVisible = false;
    // for (var element in fengLudataList) {
    //   if (element[1].amount != "") {
    //     if (double.parse(element[1].amount) > 0) {
    //       return true;
    //     }
    //   }
    // }
    // return shouldVisible;
  }

  String getCurName(cur) {
    for (var element in globalController.currTypeLists) {
      if (element.cur == cur) {
        return element.name!;
      }
    }
    return "";
  }

  Future<void> getVipRebateTitle(gameType) async {
    isVipFanShuiLoading = true;

    await ApiService.instance.getVipRebateConfig(
      gameType: gameType,
      cur: coinInfos.length > 0
          ? coinInfos[selectedCoinIndex].cur!
          : "702", // coinInfos.isEmpty ? "702" : coinInfos[selectedCoinIndex].uid!,
      success: (data) {
        rebateConfigModle = data;
        isVipFanShuiLoading = false;
        update(['vip_home']);
      },
      fail: (message) {
        isVipFanShuiLoading = false;
        update(['vip_home']);
      },
    );
  }

// 获取vip积分倍率
  String getMultipleWithGameType(gameType) {
    for (var element in rateList) {
      if (element.gameType.toString() == gameType.toString()) {
        return double.parse(element.rate).toStringAsFixed(0);
      }
    }
    return "1";
  }

  Future<void> getVipRebateData(gameType) async {
    isVipFanShuiLoading = true;

    await ApiService.instance.getVipRebateConfig(
      gameType: gameType,
      cur: coinInfos.length > 0
          ? coinInfos[selectedCoinIndex].cur!
          : "702", // coinInfos.isEmpty ? "702" : coinInfos[selectedCoinIndex].uid!,
      success: (data) {
        rebateConfigModle = data;
        isVipFanShuiLoading = false;
        update(['vip_home']);
      },
      fail: (message) {
        isVipFanShuiLoading = false;
        update(['vip_home']);
      },
    );
  }

  //获取返水标题
  List<String> getFanshuiTitle(menuList) {
    Map titel = {
      "3": S.current.yulecheng_slot,
      "2": S.current.random_text_84,
      // S.current.random_text_85,
      "1": S.current.game_live,
      "4": S.current.tab_bar_sports,
      "8": S.current.random_text_1158
    };

    List<String> titleList = [];
    for (var element in menuList) {
      titleList.add(titel[element]);
    }
    return titleList;
  }

  // 获取返水icon
  List<String> getFanshuiIcon(menuList) {
    Map titel = {
      "3": "vip_title_ic_slot",
      "2": "vip_title_ic_fish",
      // S.current.random_text_85,
      "1": "vip_title_ic_live",
      "4": "vip_title_ic_sports",
      "8": "vip_title_ic_original"
    };

    List<String> titleList = [];
    for (var element in menuList) {
      titleList.add(titel[element]);
    }
    return titleList;
  }

  /// 获取币种信息
  void reqGetCoinTypeInfos() {
    // if (pageType == "vipRank") {
    // globalController.syncData();
    coinInfos = globalController.currTypeLists;
    selCoin =
        globalController.currTypeSelected.value; //SPUtil().getCurrencyBean() ?? coinInfos.first;
    updateInfo();
    // } else {
    //   ApiService.instance.currencyConfig<CurrencyBean>(
    //     success: (list) {
    //       coinInfos = list;
    //       selCoin = SPUtil().getCurrencyBean() ?? coinInfos.first;

    //       updateInfo();
    //     },
    //     fail: (errorMessage) {},
    //   );
    // }
  }

  ///获取 汇率
  Future<void> reqExchangeRate() async {
    // await ApiService.instance.exchangeRateList<ExchangeRateModel>(
    //   success: (data) {
    //     rateTool = data;
    //     updateInfo();
    //   },
    //   fail: (message) {
    //     update(["vip_lingqu_record"]);
    //   },
    //   converter: (json) {
    //     return ExchangeRateModel.fromJson(json);
    //   },
    // );
  }

  /// 货币类型切换
  void changeCoinType(index) {
    selCoin = globalController.currTypeSelected.value;
    //coinInfos[index];
    userCoinBonus = "";
    updateInfo();
  }

  String getRate(item, multiple) {
    if (coinInfos.isNotEmpty && rateTool.rates.isNotEmpty) {
      final usdt = coinInfos.firstWhere((element) => element.name == "USDT");
      selCoinRate = rateTool.getRate(usdt, item);
      Decimal rate = selCoinRate;

      double result = double.parse(multiple.toString()) / rate.toDouble();
      String result0 = result.toStringAsFixed(9);
      return result0.substring(0, result0.length - 1);
    }
    return "0.00";
  }

  // 获取返水按钮是否显示
  void getrebateButtonstatus() {
    ApiService.instance.getVipRebateButtonStatus(
        success: (success) {
          showRebeatButton = !success;
          update(['vip_home']);
        },
        fail: (fail) {});
  }

  void updateInfo() {
    if (coinInfos.isNotEmpty && rateTool.rates.isNotEmpty) {
      final usdt = coinInfos.firstWhere((element) => element.name == "USDT");
      selCoinRate = rateTool.getRate(usdt, selCoin);
      Decimal coinBonus = Decimal.parse(bonus) * selCoinRate;
      userCoinBonus = coinBonus.toString();
    }
    update(["vip_lingqu_record"]);
  }

  showlingQuTanchuang(context) {
    showCustomFeedbackBonusWidget(
      context: context,
      feedId: "",
      bonus: "5",
    );
  }

  showVipRules(context, type) async {
    reqGetCoinTypeInfos();
    showCustomVipRulesWidget(context: context, type: type);
  }

  /// 确认领取
  void reqReceiveAction(context, jiangJinId, cur, amount, type) {
    // if (amount == "0.00") {
    //   CustomSnackBar.show(S.current.random_text_407, context,
    //       title: S.current.random_text_695, preIcon: CustomSnackBarIcons.error);
    //   return;
    // }
    CustomProgressHUD.show(context, content: S.current.random_text_4);
    lingquJiangJin(context, jiangJinId, cur, amount, type);
  }

  lingquJiangJin(context, jiangJinId, cur, amount, type) async {
    await ApiService.instance.lingQuDengJiJiangLi(
      jiangJinId: jiangJinId,
      cur: globalController.selectedCoin.cur ?? cur,
      amount: amount,
      success: (data) {
        CustomProgressHUD.dismiss(context);

        if (data == "0") {
          CustomSnackBar.show(S.current.random_text_1159, context,
              title: S.current.snack_bar_normal_tips, preIcon: CustomSnackBarIcons.activityWarn);
        } else {
          // RouteUtil.popView();
          // globalController.showOverlayView(isShowTopBarView: true, isShowBottomBarView: true);

          var is_th = "${type}${S.current.receive}";
          if (LangUtil().isTh()) {
            is_th = "${type}";
          }

          CustomSnackBar.show(
            "",
            context,
            title: S.current.random_text_96,
            preIcon: CustomSnackBarIcons.activitySuccess,
            subContent: <Widget>[
              CustomText(
                /*"${"S.current.random_text_696"}${type} ${data}"*/ "${S.current.random_text_1190}$data",
                style: ThemeService().textTheme.bodyMedium!.copyWith(color: Color(0xffb1bad3)),
              ),
              Image.network(
                      "${AppValues.defaultBranch.asset_url}/currency/${globalController.selectedCoin.cur ?? cur}.webp",
                      width: 15,
                      height: 15)
                  .paddingLeft(AppValues.halfPadding)
            ].toRow(),
          );
        }
        getFengLuAvailiable();
        update(['vip_home']);
      },
      fail: (message) {
        CustomProgressHUD.dismiss(context);
        CustomSnackBar.show(S.current.random_text_407, context,
            title: S.current.random_text_695, preIcon: CustomSnackBarIcons.error);
      },
    );
  }

  lingquQuabBuJiangJin(context, cur, flag) async {
    await ApiService.instance.lingQuQuanBuJinJiJiangLi(
      flag: flag,
      cur: globalController.selectedCoin.cur ?? "702",
      success: (data) {
        CustomProgressHUD.dismiss(context);
        if (data == "0") {
          CustomSnackBar.show(S.current.random_text_1159, context,
              title: S.current.snack_bar_normal_tips, preIcon: CustomSnackBarIcons.activityWarn);
        } else {
          // if (flag == "jifen") {
          CustomSnackBar.show(
            S.current.random_text_96,
            context,
            title: S.current.random_text_96,
            preIcon: CustomSnackBarIcons.activitySuccess,
            subContent: <Widget>[
              CustomText(
                "${S.current.random_text_1190}$data",
                style: ThemeService().textTheme.bodyMedium!.copyWith(color: Color(0xffb1bad3)),
              ),
              Image.network(
                      "${AppValues.defaultBranch.asset_url}/currency/${globalController.selectedCoin.cur}.webp",
                      width: 15,
                      height: 15)
                  .paddingLeft(AppValues.halfPadding)
            ].toRow(),
          );
          //   getFengLuAvailiable();
          // } else {
          //   CustomSnackBar.show(
          //     S.current.random_text_408 + data,
          //     context,
          //     title: S.current.random_text_697,
          //     preIcon: CustomSnackBarIcons.activitySuccess,
          //     subContent: <Widget>[
          //       CustomText(
          //         "${S.current.random_text_698}${data}",
          //         style: ThemeService().textTheme.bodyMedium!.copyWith(color: Color(0xffb1bad3)),
          //       ),
          //       Image.network(
          //               "${AppValues.defaultBranch.asset_url}/currency/${globalController.selectedCoin.cur}.webp",
          //               width: 15,
          //               height: 15)
          //           .paddingLeft(AppValues.halfPadding)
          //     ].toRow(),
          //   );
          // }
        }

        update(['vip_home']);
      },
      fail: (message) {
        CustomProgressHUD.dismiss(context);
        CustomSnackBar.show("", context,
            title: S.current.random_text_695, preIcon: CustomSnackBarIcons.error);
      },
    );
  }

  VipAviliableAmountModel getCurrentVipModel(int vipLevel) {
    for (var element in availiableList) {
      if (int.parse(element.vip) == vipLevel) {
        return element;
      }
    }
    return VipAviliableAmountModel(
        id: "111",
        vip: "0",
        cashType: 819,
        amount: "0.00",
        state: 2,
        receiveAmount: "0.00",
        availableAmount: "0.00");
  }

  showDengJiLingQuView(context) {
    showCustomFeedbackBonusWidget(
      context: context,
      feedId: "111111111",
      bonus: "0.00",
    );
  }

  // 查询可领取余额
  getFengLuAvailiable() async {
    // await ApiService.instance.getVipMutilple(
    //   success: (data) {
    //     print("-----rate------");
    //     rateList.clear();
    //     rateList.addAll(data);
    //     update(['vip_home']);
    //   },
    //   fail: (message) {
    //     print("-----rate------1");

    //     update(['vip_home']);
    //   },
    // );

    getVipRebateData(0);
    await ApiService.instance.getAvailiableAmount(
      cur: globalController.currTypeSelected.value.cur!,
      type: "818",
      success: (data) {
        availiableList.clear();
        availiableList = data.map((e) => VipAviliableAmountModel.fromJson(e)).toList();
        update(['vip_home']);
      },
      fail: (message) {},
    );
    await ApiService.instance.getAvailiableAmount(
      cur: globalController.currTypeSelected.value.cur!,
      type: "819",
      success: (data) {
        if (data.isNotEmpty) {
          List<VipAviliableAmountModel> list =
              data.map((e) => VipAviliableAmountModel.fromJson(e)).toList();
          availiableMap['daily'] = list;
        } else {
          availiableMap['daily'] = [
            VipAviliableAmountModel(
                id: "111",
                amount: "0",
                cashType: 820,
                vip: "1",
                state: 2,
                receiveAmount: "0.00",
                availableAmount: "0.00")
          ];
        }

        update(['vip_home']);
      },
      fail: (message) {},
    );
    await ApiService.instance.getAvailiableAmount(
      cur: globalController.currTypeSelected.value.cur!,
      type: "820",
      success: (data) {
        if (data.isNotEmpty) {
          List<VipAviliableAmountModel> list =
              data.map((e) => VipAviliableAmountModel.fromJson(e)).toList();
          availiableMap['weekly'] = list;
        } else {
          availiableMap['weekly'] = [
            VipAviliableAmountModel(
                id: "111",
                amount: "2",
                cashType: 820,
                vip: "1",
                state: 2,
                receiveAmount: "0.00",
                availableAmount: "0.00")
          ];
        }
        update(['vip_home']);
      },
      fail: (message) {},
    );
    await ApiService.instance.getAvailiableAmount(
      cur: globalController.currTypeSelected.value.cur!,
      type: "821",
      success: (data) {
        if (data.isNotEmpty) {
          List<VipAviliableAmountModel> list =
              data.map((e) => VipAviliableAmountModel.fromJson(e)).toList();
          availiableMap['monthly'] = list;
        } else {
          availiableMap['monthly'] = [
            VipAviliableAmountModel(
                id: "111",
                amount: "3",
                cashType: 820,
                vip: "1",
                state: 2,
                receiveAmount: "0.00",
                availableAmount: "0.00")
          ];
        }
        update(['vip_home']);
      },
      fail: (message) {},
    );
  }

// 获取可领取的全部金额
  String getAllAvailiableAmount() {
    double amount = 0.00;
    for (var element in availiableList) {
      amount += double.parse(element.availableAmount);
    }
    return amount.toStringAsFixed(2);
  }

  int getVipLingQuStatus(level) {
    if (!availiableList.isEmpty) {
      for (var element in availiableList) {
        if (element.vip.toString() == level.toString()) {
          return element.state;
        }
      }
    }
    return 0;
  }

  chaKanLingQuJiLu(context) {
    print(currentUser.token);
    RouteUtil.pushToView(Routes.personalVipRecord);
  }

  // Future<void> showCustomRegisterProtocolWidget<T>({
  //   required BuildContext context,
  //   required String amount,
  // }) async {
  //   await CustomSafeDialog.show<T>(
  //       context: context,
  //       tag: "vipShowLingQuRecord",
  //       barrierDismissible: true,
  //       useRootNavigator: false,
  //       builder: (_) {
  //         return Container(
  //           color: Colors.transparent,
  //           width: double.infinity,
  //           height: double.infinity,
  //           alignment: Alignment.center,
  //           // padding:
  //           //     const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
  //           child: VipLingQuRecord(amount: amount)
  //               .tight(width: double.infinity, height: 250),
  //         ).onTap(() {
  //           RouteUtil.popView();
  //         });
  //       });
  // }
  // 弹窗显示晋级奖金和累积奖金领取
  Future<void> showCustomFeedbackBonusWidget({
    required BuildContext context,
    required String feedId,
    required String bonus,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) async {
    globalController.showOverlayView(isShowTopBarView: false, isShowBottomBarView: false);
    await CustomSafeDialog.show(
        context: context,
        tag: kCustomVipBonusWidget,
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
        builder: (_) {
          selJiangJinStringIndex = 0;
          reqExchangeRate();
          if (feedId.length > 0) {
            if (selJiangJinStringIndex > 0) {
              inputJieSuanString = availiableList[selJiangJinStringIndex - 1].availableAmount;
            } else {
              inputJieSuanString = getAllAvailiableAmount();
            }
          } else {
            if (selJiangJinStringIndex == 0) {
              inputJieSuanString = getFengLuTotalAmount();
            } else {
              List<String> keyString = ['daily', 'weekly', "monthly"];
              String amount = availiableMap[keyString[selJiangJinStringIndex - 1]]![0].state == 2
                  ? "0.00"
                  : availiableMap[keyString[selJiangJinStringIndex - 1]]![0].availableAmount;
              inputJieSuanString = amount;
            }
          }
          return Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
            child: VipLingQuRecord(feedId, bonus, context).onTap(() {}),
          ).onTap(() {
            globalController.showOverlayView(isShowTopBarView: true, isShowBottomBarView: true);
            RouteUtil.popView();
          });
        });
  }

  String getFengLuTotalAmount() {
    List<String> keyString = ['daily', 'weekly', "monthly"];
    double totalAmount = 0;
    for (var element in keyString) {
      String amount = availiableMap[element]![0].state == 2
          ? "0.00"
          : availiableMap[element]![0].availableAmount;
      totalAmount += double.parse(amount);
    }
    return totalAmount.toStringAsFixed(isFaBi(globalController.currTypeSelected.value) ? 8 : 2);
  }

  // 弹窗显示领取规则
  Future<void> showCustomVipRulesWidget({
    required BuildContext context,
    VIP_PAGE_TYPE type = VIP_PAGE_TYPE.dama,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) async {
    // reqExchangeRate();
    await CustomSafeDialog.show(
        context: context,
        tag: kCustomVipBonusWidget,
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
        builder: (_) {
          return Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
            child: VipJinJiGuiZe(type).onTap(() {}),
          ).onTap(() {
            RouteUtil.popView();
          });
        });
  }

  // 弹窗显示保级提示
  Future<void> showCustomVipBaoJiTipsWidget({
    required BuildContext context,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) async {
    int level = int.parse(currentUser.vip!);
    if (level == 0) {
      return;
    }
    VipLevelModel model = dataList[int.parse(currentUser.vip!)];
    if (model.retain == "") {
      return;
    }
    await CustomSafeDialog.show(
        context: context,
        tag: kCustomVipTipsWidget,
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
        builder: (_) {
          return Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
            child: Stack(children: [
              VipBaoJiTips(model.retain.split(",").first, model.retain.split(",").last)
                  .onTap(() {})
                  .tight(height: 134)
                  .positioned(left: 1, top: 204, right: 1)
            ]),
          ).onTap(() {
            RouteUtil.popView();
          });
        });
  }

// 领取返水
// 获取返水列表
  receiveFanshui(context) {
    ApiService.instance.receiveFanshui(success: (success) {
      if (success == "0") {
        CustomSnackBar.show(S.current.random_text_1073, context,
            title: S.current.random_text_695, preIcon: CustomSnackBarIcons.error);
        return;
      }
      CustomSnackBar.show(
        S.current.random_text_1072,
        context,
        title: S.current.random_text_96,
        preIcon: CustomSnackBarIcons.activitySuccess,
        // subContent: CustomText(
        //   S.current.random_text_1072,
        //   style: ThemeService()
        //       .textTheme
        //       .bodyMedium!
        //       .copyWith(color: Color(0xffb1bad3), fontWeight: FontWeight.w500),
        // ),
      );
    }, fail: (fail) {
      // CustomSnackBar.show(
      //   S.current.random_text_978,
      //   context,
      //   title: S.current.random_text_695,
      //   preIcon: CustomSnackBarIcons.error,
      //   // subContent: CustomText(
      //   //   S.current.random_text_1073,
      //   //   style: ThemeService()
      //   //       .textTheme
      //   //       .bodyMedium!
      //   //       .copyWith(color: Color(0xffb1bad3), fontWeight: FontWeight.w500),
      //   // ),
      // );
      CustomSnackBar.show(S.current.random_text_1073, context,
          title: S.current.random_text_695, preIcon: CustomSnackBarIcons.error);
    });
  }

// 弹窗显示返水
  Future<void> showCustomVipFanshuiViewWidget({
    required BuildContext context,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) async {
    RouteUtil.pushToView(Routes.vipFanshuiPage);
    // await CustomSafeDialog.show(
    //     context: context,
    //     tag: kCustomVipFanshuiWidget,
    //     barrierDismissible: barrierDismissible,
    //     useRootNavigator: useRootNavigator,
    //     builder: (_) {
    //       return Container(
    //         color: Colors.transparent,
    //         width: double.infinity,
    //         height: double.infinity,
    //         alignment: Alignment.center,
    //         padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
    //         child: Stack(children: [
    //           VipFanshuiList(
    //             callBack: () {
    //               // RouteUtil.popView();
    //               showCustomVipFanshuiDetailViewWidget(context: context);
    //             },
    //           ).onTap(() {}).positioned(left: 1, top: 204, right: 1)
    //         ]),
    //       ).onTap(() {
    //         RouteUtil.popView();
    //       });
    //     });
  }

// 返水点击切换
  void selectFanshuiIndex(index) {
    selectedFanshuiIndex = index;
    update(['vip_home']);
    getVipRebateData(int.parse(rebateConfigModle.menu[selectedFanshuiIndex]));
  }

  onJiangJinTypeChanged(jiangJinStringIndex, type) {
    selJiangJinStringIndex = jiangJinStringIndex;
    if (type == "jinji") {
      if (selJiangJinStringIndex > 0) {
        inputJieSuanString = availiableList[selJiangJinStringIndex - 1].availableAmount;
      } else {
        inputJieSuanString = getAllAvailiableAmount();
      }
    } else {
      if (selJiangJinStringIndex == 0) {
        inputJieSuanString = getFengLuTotalAmount();
      } else {
        List<String> keyString = ['daily', 'weekly', "monthly"];
        int seleIndex = selJiangJinStringIndex - 1;
        if (shouldDayilyBonusVisibility("819") == false) {
          seleIndex = selJiangJinStringIndex;
        }
        String amount = availiableMap[keyString[seleIndex]]![0].state == 2
            ? "0.00"
            : availiableMap[keyString[seleIndex]]![0].availableAmount;
        inputJieSuanString = double.parse(amount)
            .toStringAsFixed(isFaBi(globalController.currTypeSelected.value) ? 8 : 2);
      }
    }
    update(['vip_lingqu_record']);
  }

  // 更新赔率
  updateJieSuanAmount(value) {
    inputJieSuanString = value;
    if (inputJieSuanString == "") {
      inputJieSuanString = "0.00";
    }
    update(['jiesuan_amount']);
  }

  // 筛选coin 的关键词
  updateSearchList(value) {
    selectedCeachCoinString = value;
    update(['coin_show']);
  }

  String getCoinUrlWithCoinName(String name) {
    var coinInfo = coinInfos.firstWhere((element) => element.name == name);
    // print('"https://d2utx4nptvgikt.cloudfront.net/currency/${coinInfo.cur}.webp"');
    return "${AppValues.defaultBranch.asset_url}/currency/${coinInfo.cur}.webp";
  }

  void initRules() {
    ruleTitles = [
      S.current.random_text_1197,
      S.current.random_text_601,
      S.current.random_text_602,
      S.current.random_text_603,
      S.current.random_text_604,
      S.current.random_text_605,
      S.current.random_text_607,
      S.current.random_text_608,
      S.current.random_text_609
    ];

    ruleContents = [
      S.current.random_text_1198,
      S.current.random_text_1074,
      S.current.random_text_1075,
      S.current.random_text_612,
      S.current.random_text_613,
      S.current.random_text_614,
      S.current.random_text_616,
      S.current.random_text_617,
      S.current.random_text_618,
    ];
  }

  ///点击-开始游戏
  onClickBeginGame() {
    //回到 首页娱乐城，
    RouteUtil.popView();
    EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.GAME);
  }

  late SliverObserverController observerController;
  BuildContext? sliverListContext;

  void initScroll() {
    observerController = SliverObserverController(controller: pageScrollController);
  }

  ///点击-查看VIP级别表
  void onClickVipLevelTable(int index) {
    observerController.animateTo(
      sliverContext: sliverListContext,
      index: 3,
      duration: const Duration(milliseconds: 500),
      isFixedHeight: false,
      offset: (targetOffset) => AppValues.defaultMargin,
      renderSliverType: ObserverRenderSliverType.list,
      curve: Curves.ease,
      // curve: Curves.easeInOut,
    );

    // observerController.animateTo(
    //   sliverContext: contextTabView,
    //   index: 0,
    //   // isFixedHeight: true,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeInOut,
    // );
    // if (GlobalObjectKey(tabKey).currentContext != null) {
    //   Scrollable.ensureVisible(GlobalObjectKey(tabKey).currentContext!);
    // }
    // pageScrollController. = 1720.0;
    // pageScrollController.animateTo(
    //   1770.0,
    //   duration: const Duration(milliseconds: 500),
    //   curve: Curves.ease,
    // );
  }

  String removeTrailingZeros(stringValue) {
    if (stringValue.contains('.')) {
      // 去掉结尾的0
      stringValue = stringValue.replaceAll(RegExp(r'0*$'), '');
      // 如果最后一个字符是小数点，去掉它
      if (stringValue.endsWith('.')) {
        stringValue = stringValue.substring(0, stringValue.length - 1);
      }
    }
    return stringValue;
  }

  bool isFaBi(selCoin) {
    // return false;
    List<String> fabiLIst = [
      // "CNY",
      // "VND",
      // "THB",
      // "INR",
      // "BRL",
      // "EUR",
      // "JPY",
      // "CAD",
      // "ARS",
      // "CLP",
      // "PEN"
      "ETH",
      "BTC"
    ];
    for (var element in fabiLIst) {
      if (element == selCoin.name) {
        return true;
      }
    }
    return false;
  }

  String GetDuiHuanText(selCoin) {
    var duitext = S.current.random_text_650 + "${selCoin.name ?? "..."}";
    if (LangUtil().isPtBr()) {
      duitext = S.current.random_text_650 + "(${selCoin.name ?? "..."})";
    }
    return duitext;
  }

  // 获取100%
  double getVipProcessRate() {
    int vipLevel = int.parse(currentUser.vip!);
    double rate = 0;
    /*if (vipLevel == 0) {
      rate = double.parse(currentUser.score!) / double.parse(dataList[0].upgrade.split(",")[1]);
      return rate;
    } else */
    if (vipLevel == dataList.last.level.toString()) {
      rate == 1;
      return rate;
    } else {
      double dama0 = double.parse(dataList[vipLevel + 1].upgrade),
          rate = dama0 == 0 ? 0.0 : double.parse(currentUser.score!) / dama0;

      return rate;
    }
  }

  @override
  void onClose() {
    GlobalState.instance.index = -1;
    super.onClose();
    tabController.dispose();
    pageScrollController.dispose();
    textEditingController.dispose();
  }
}
