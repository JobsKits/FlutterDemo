import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/pages/alliance_plan/whepler/alliance_biz_helper.dart';
import 'package:flutter_bet/pages/alliance_plan/widget/custom_select_model.dart';
import 'package:flutter_bet/pages/alliance_plan/wmodel/alliance_common_params.dart';
import 'package:flutter_bet/pages/alliance_plan/wmodel/alliance_game_type_api_model.dart';
import 'package:flutter_bet/pages/alliance_plan/wmodel/alliance_info_api_model.dart';
import 'package:flutter_bet/services/api/extension/alliance_api_service.dart';
import 'package:get/get.dart';

import '../../app/modules/commission_wallet/views/commission_wallet_dialog.dart';
import '../../app/modules/commission_wallet/views/commission_wallet_view.dart';
import '../../base/getx/page_state.dart';
import '../../services/api/api_service.dart';
import '../../services/lang_service.dart';
import '../../services/theme/theme_service.dart';
import '../../utils/keyboard_util.dart';
import '../../widget/custom_text.dart';
import 'all_data/all_data_view.dart';
import 'alliance_plan_state.dart';
import 'commission_history/commission_history_dialog.dart';
import 'commission_history/commission_history_view.dart';
import 'commission_rate/commission_rate_view.dart';
import 'direct_betting/direct_betting_view.dart';
import 'direct_finance/direct_finance_view.dart';
import 'direct_user/direct_user_view.dart';
import 'my_commission/my_commission_view.dart';
import 'my_performance/my_performance_logic.dart';
import 'my_performance/my_performance_view.dart';
import 'my_promotion/my_promotion_view.dart';
import 'study/promotion_study_view.dart';
import 'wmodel/alliance_condition_model.dart';

///新版联盟计划1021-controller控制器
///账号 yuyu/YDv2j3t7
///账号 yi02/Yy123456
class AlliancePlanLogic extends BaseController with GetTickerProviderStateMixin {
  final AlliancePlanState state = AlliancePlanState();
  late TabController tabController;
  final ScrollController scrollController = ScrollController();

  ///对外提供 获取对象
  static AlliancePlanLogic of() {
    return Get.find<AlliancePlanLogic>();
  }

  //一共有11
  var tabLabel = [
    S.current.random_text_54,
    S.current.random_text_55,
    S.current.random_text_56,
    S.current.random_text_57,
    S.current.random_text_58,
    S.current.random_text_59,
    S.current.random_text_60,
    S.current.random_text_61,
    // S.current.random_text_62,//产品确认要隐藏。联盟计划 隐藏直属领取模块
    S.current.random_text_63,
    // S.current.random_text_64
    // S.current.random_text_513, //0124.联盟计划 把注册子代理给删除【老板反馈】
  ];

  ///货币类型选择范围
  // final CustomSelectModel defaultCoinSelectModel =
  //     CustomSelectModel(S.current.random_text_514, data: '');
  //【0229】【app】联盟计划，筛选币种，全部货币修改为全部币种
  final CustomSelectModel defaultCoinSelectModel =
      CustomSelectModel(S.current.random_text_876, data: '');

  ///游戏类型选择范围
  final CustomSelectModel defaultTypeSelectModel =
      CustomSelectModel(S.current.random_text_188, data: '');
  final selectTypeListObs = <CustomSelectModel>[].obs;

  List<CustomSelectModel> selectCoinList = <CustomSelectModel>[];

  late List<Tab> tabList;

  final apiModelObs = AllianceInfoApiModel().obs;
  final pageStateObs = PageState.UPDATED.obs;

  ///是否登陆
  bool get isLogin => GlobalStateController.of().isLogin.value;

  @override
  void onInit() {
    super.onInit();
    GlobalState.instance.index = 4;
    initData();
    initTabView();
    initConfigData();
    isNeedSwitchTab();
  }

  AlliancePageEnum? initPageEnum;

  ///判断一下是否需要指定切换tab
  void isNeedSwitchTab() {
    initPageEnum = Get.arguments["pageEnum"];
    if (initPageEnum != null) {
      switchAllianceTab(pageEnum: initPageEnum);
    }
  }

  //初始化数据
  void initData() {
    selectTypeListObs.add(defaultTypeSelectModel);
  }

  void initTabView() {
    tabList = tabLabel
        .map(
          (label) => Tab(
            child: CustomText(
              label,
              style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        )
        .toList();
    tabController = TabController(length: tabList.length, initialIndex: 0, vsync: this);
    tabController.addListener(() {
      if (tabController.index.toDouble() == tabController.animation!.value) {
        log("======tabController.index.....${tabController.index}");
        KeyboardUtils.hideKeyboard(Get.context!);
        // getTabBarView(tabController.index);
        tabIndex.value =tabController.index;
      }
    });
  }

  final tabIndex = 0.obs;

  void initConfigData() {
    //配置货币信息
    selectCoinList.clear();
    // GlobalStateController.of().currTypeInitialLists.map((bean){
    //    selectCoinList.add(CustomSelectModel(bean.name??"",data: bean.cur));
    // });
    var coinListTemp = <CustomSelectModel>[];
    //【0229需求变更】【app】联盟计划，筛选币种只显示开启的币种
    // var currTypeLists = GlobalStateController.of().currTypeLists;
    // var currTypeInitialLists = GlobalStateController.of().currTypeInitialLists;
    for (var bean in GlobalStateController.of().currTypeInitialLists) {
      coinListTemp.add(CustomSelectModel(bean.name ?? "", data: bean.cur));
    }

    //排序处理, 不排序，配置单默认排序
    //coinListTemp.sort(( a,  b) => a.label.compareTo(b.label));
    selectCoinList.add(defaultCoinSelectModel);
    selectCoinList.addAll(coinListTemp);

    // log("配置货币信息...${JsonUtil.encodeObj( GlobalStateController.of().currTypeInitialLists)}");
    // log("配置货币信息...${JsonUtil.encodeObj(selectCoinList)}");
    log("配置货币信息...${selectCoinList.length}");
  }

  @override
  void onReady() {
    super.onReady();
    loadNetData();
    //todo:0509 不用判断一直显示
    // loadNetShowAgencyData();
    loadGameTypeNetData();
  }

  @override
  void onClose() {
    GlobalState.instance.index = -1;
    tabController.dispose();
    super.onClose();
  }

  ///获取是否显示上级
  final isShowAgencyObs = Rxn<bool>(true);

  void loadNetShowAgencyData() async {
    await ApiService.instance.getIsShowAgency(
      success: (data) {
        isShowAgencyObs.value = AllianceBizHelper.isShowAgency(data);
      },
      fail: (isConnect, message, candy) {
        //todo: 0105 临时开通
        // pageStateObs.value = PageState.SUCCESS;
      },
    );
  }

  ///获取联盟计划-个人中心 信息
  void loadNetData() async {
    pageStateObs.value = PageState.LOADING;
    await ApiService.instance.getAllianceInfo(
      success: (data) {
        apiModelObs.value = data;
        // pageStateObs.value = PageState.SUCCESS;
      },
      fail: (isConnect, message, candy) {},
    );
  }

  ///获取联盟计划-游戏类型 - 下拉框
  Future<bool> loadGameTypeNetData() async {
    await ApiService.instance.getAllianceGameType(
      success: (List<AllianceGameTypeApiModel> dataList) {
        if (dataList.isNotEmpty) {
          var targetList = <CustomSelectModel>[];
          var tempList =
              dataList.map((model) => CustomSelectModel(model.name ?? '', data: model.id)).toList();
          targetList.add(defaultTypeSelectModel);
          targetList.addAll(tempList);
          selectTypeListObs.assignAll(targetList);
        }
      },
      fail: (isConnect, message, candy) {
        log('游戏类型异常：$message');
      },
    );

    return true;
  }

  //改方法随时可调用
  Future<List<CustomSelectModel>> getGameType() async {
    //如果数据为空，等待加载完毕
    if (selectTypeListObs.isEmpty) {
      await loadGameTypeNetData();
    }
    return selectTypeListObs;
    // return Future.value([]);
  }

  /*==========================事件交互处理==========================*/

  String getLevelImageAsset(int? level) {
    String assetPath = "";

    ///取巧写法：
    if (level != null && (level > 0 && level <= 10)) {
      assetPath = "assets/images/alliance/ic_alliance_ranking_${level}.webp";
    } else {
      assetPath = "assets/images/alliance/ic_alliance_ranking_new.webp";
    }

    return assetPath;
  }

  ///点击头像-代理等级
  void onClickAvatar() {
    //目前不跳转
    // AgentLevelPage.openPage();
  }

  ///领取佣金
  void onClickCommissionReceive(BuildContext context) {
    // CommissionReceivePage.openPage();
    // CommissionWalletView.openPage();
    CommissionWalletDialog.openDialog();
  }

  //佣金历史
  void onClickCommissionHistory(BuildContext context) {
    // CommissionHistoryPage.openPage();
    CommissionHistoryDialog.openDialog();
  }

  ///切换tab 界面
  void switchAllianceTab({
    AlliancePageEnum? pageEnum,
    AllianceConditionModel? conditionModel,
  }) async {
    if (pageEnum != null && pageEnum == AlliancePageEnum.myPromotion) {
      tabController.animateTo(pageEnum.pageIndex);
    } else if (pageEnum != null && pageEnum == AlliancePageEnum.myPerformance) {
      tabController.animateTo(pageEnum.pageIndex);
      // tabIndex.value = pageEnum.pageIndex;
      //延迟一下避免没有初始化
      Future.delayed(
        const Duration(milliseconds: 200),
        () => MyPerformanceLogic.of().updateCondition(conditionModel),
      );
    }
  }

  ///切换获取不同的view
  Widget getTabBarView(int index) {
    AlliancePageEnum? pageEnum = AlliancePageEnum.adaptor(index);
    switch (pageEnum) {
      case AlliancePageEnum.study:
        return PromotionStudyPage();
      case AlliancePageEnum.myPromotion:
        return MyPromotionPage();
      case AlliancePageEnum.myCommission:
        return MyCommissionPage();
      case AlliancePageEnum.myPerformance:
        return MyPerformancePage();
      case AlliancePageEnum.allData:
        return AllDataPage();
      case AlliancePageEnum.directFinance:
        return DirectFinancePage();
      case AlliancePageEnum.directBetting:
        return DirectBettingPage();
      case AlliancePageEnum.directUser:
        return DirectUserPage();
      case AlliancePageEnum.commissionRate:
        return CommissionRatePage();
      default:
        return Container();
    }
  }
}
