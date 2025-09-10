import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';

import '../data/rebate_bean.dart';

class ControllerRebatePage extends GetxController
    with GetTickerProviderStateMixin {
  RxInt currentTabIndex = 0.obs;
  PageController pageController = PageController(initialPage: 0);
  late TabController tabController;
  late NewHomeController homeController = Get.find();

  ///---------------------------详情用的-------------------------------
  RxInt detailCurrentTabIndex = 0.obs;
  PageController detailPageController = PageController(initialPage: 0);
  late TabController detailTabController;

  RxList<RebateTabBean> tabList = <RebateTabBean>[].obs; // tab数据

  ///----------------------------------------------------------
  Rx<RebateDataBean> reabteData = RebateDataBean().obs; // 返水数据
  RxList<RebateHistoryItemBean> historyData =
      <RebateHistoryItemBean>[].obs; // 返水记录

  Rx<RebateHistoryDetailBean> historyDetailData = RebateHistoryDetailBean(
    g100: [],
    g101: [],
    g102: [],
    g103: [],
    g104: [],
    g105: [],
    g106: [],
    g109: [],
  ).obs;

  ///----------------------------------------------------------
  RxBool isLoading = false.obs; // 一键领取loading
  RxBool isHistoryLoading = false.obs; // 返水历史
  RxBool isDetailLoading = false.obs; // 返水历史详情

  ///----------------------------------------------------------
  RxList<RebateProportionChildItemBean> proportionData =
      <RebateProportionChildItemBean>[].obs; // 返水比例数据
  RxBool isRequestProportion = false.obs;

  RxInt proportionGameType = 0.obs; // 游戏类别
  RxString proportionGameName = ''.obs; // 游戏标题
  RxInt proportionSubGameType = 0.obs; // 子游戏
  RxString proportionSubGameName = ''.obs; // 子游戏标题

  RxList<RebateProportionDataBean> gameTaData =
      <RebateProportionDataBean>[].obs; // 游戏类别公用配置
  RxList<RebateProportionDataBean> subGameTabData =
      <RebateProportionDataBean>[].obs; // 子游戏类别公用配置

  @override
  onInit() async {
    super.onInit();

    initData();

    // 监听登录
    ever(LoginManager.instance.isLogin, (isLogin) async {
      if (isLogin) {
        initData();
      } else {
        _clearData();
        showLoginDialog();
      }
    });
  }

  _clearData() {
    tabList.value = [];
    reabteData.value = RebateDataBean();
    historyData.value = [];
  }

  @override
  void onClose() {
    tabController.dispose();
    pageController.dispose();

    detailPageController.dispose();
    detailTabController.dispose();
    super.onClose();
  }

  Future<void> initData() async {
    _initTabList();

    await reqRebateData();
  }

  // 初始化tab数据
  void _initTabList() {
    List<VersionTypeItem> versionType = TenantManager.instance.versionType;
    print("这里是什么：${versionType}");
    List<RebateTabBean> tabListData = [];

    for (int i = 0; i < versionType.length; i++) {
      VersionTypeItem item = versionType[i];

      if ((item.sort_v ?? 0) > 0) {
        // 1: 棋牌，2: 彩票， 3: 电子, 4: 捕鱼， 5: 真人， 6: 体育， 7: 红包 8: 区块 9: 电竞
        switch (item.type) {
          case 1:
            tabListData.add(RebateTabBean(
              amount: 0,
              gameName: '棋牌',
              gameType: '100',
              imgUrl: Assets.theme1.images.home.iconGameChessAndCards,
            ));
            break;

          case 2:
            tabListData.add(RebateTabBean(
              amount: 0,
              gameName: '彩票',
              gameType: '106',
              imgUrl: Assets.theme1.images.home.iconGameSport,
            ));
            break;

          case 3:
            tabListData.add(RebateTabBean(
              amount: 0,
              gameName: '电子',
              gameType: '101',
              imgUrl: Assets.theme1.images.home.iconGameElectronic,
            ));
            break;

          case 4:
            tabListData.add(RebateTabBean(
              amount: 0,
              gameName: '捕鱼',
              gameType: '102',
              imgUrl: Assets.theme1.images.home.iconGameFishing,
            ));
            break;

          case 5:
            tabListData.add(RebateTabBean(
              amount: 0,
              gameName: '真人',
              gameType: '103',
              imgUrl: Assets.theme1.images.home.iconGameRealPerson,
            ));
            break;

          case 6:
            tabListData.add(RebateTabBean(
              amount: 0,
              gameName: '体育',
              gameType: '104',
              imgUrl: Assets.theme1.images.home.iconGameSport,
            ));
            break;
          case 39:
            tabListData.add(RebateTabBean(
              amount: 0,
              gameName: '区块链',
              gameType: '107',
              imgUrl: Assets.theme1.images.home.iconGameBlockchain,
            ));
            break;
        }
      }
    }

    tabList.value = tabListData;
    _setGameTaData(tabListData);
    tabController = TabController(length: tabListData.length, vsync: this);
    detailTabController =
        TabController(length: tabListData.length, vsync: this);
  }

  // 设置游戏类别公用数据
  void _setGameTaData(List<RebateTabBean> tabListData) {
    List<RebateProportionDataBean> list = [];

    for (int i = 0; i < tabListData.length; i++) {
      list.add(
        RebateProportionDataBean(
          gameName: tabListData[i].gameName,
          type: int.parse(tabListData[i].gameType),
        ),
      );
    }

    gameTaData.value = list;
  }

  String getImageUrl({
    required String gameType,
    required String playId,
  }) {
    switch (gameType) {
      case '100': // 棋牌
        // return '${NetworkService().baseURL}/assets/theme1/images/tab/chess/color_${playId}.png';
        return '${NetworkService().baseURL}/images/game/chess/color_${playId}.png';
      case '106': // 彩票
        // return '${NetworkService().baseURL}/assets/theme1/images/tab/lottery/color_${playId}.png';
        return '${NetworkService().baseURL}/images/game/lottery/color_${playId}.png';
      case '101': // 电子
        // return '${NetworkService().baseURL}/assets/theme1/images/tab/electronic/color_${playId}.png';
        return '${NetworkService().baseURL}/images/game/electronic/color_${playId}.png';
      case '102': // 捕鱼
        // return '${NetworkService().baseURL}/assets/theme1/images/tab/fishing/color_${playId}.png';
        return '${NetworkService().baseURL}/images/game/fishing/color_${playId}.png';
      case '103': // 真人
        // return '${NetworkService().baseURL}/assets/theme1/images/tab/live/color_${playId}.png';
        return '${NetworkService().baseURL}/images/game/live/color_${playId}.png';
      case '104': // 体育
        // return '${NetworkService().baseURL}/assets/theme1/images/tab/sports/color_${playId}.png';
        return '${NetworkService().baseURL}/images/game/sports/color_${playId}.png';
      case '107': // 体育
        // return '${NetworkService().baseURL}/assets/theme1/images/tab/blockChain/color_${playId}.png';
        return '${NetworkService().baseURL}/images/game/blockThird/color_${playId}.png';
      default:
        return '';
    }
  }

  // 获取返水数据
  Future<void> reqRebateData({bool? needLoading = true}) async {
    try {
      if (needLoading == true) {
        EasyLoading.show(status: '加载中...');
      }
      final response = await ActivityApi.reqRebateData();

      if (response.type == NetworkService.networkTypeSuccess) {
        RebateDataBean data = RebateDataBean.fromJson(response.data);
        reabteData.value = data;
      }
    } finally {
      if (needLoading == true) {
        EasyLoading.dismiss();
      }
    }
  }

  // 页面跳转
  void jumpToPage(int index) {
    currentTabIndex.value = index;
    pageController.jumpToPage(index);
  }

  // 详情页面跳转
  void jumpToDetailPage(int index) {
    detailCurrentTabIndex.value = index;
    detailPageController.jumpToPage(index);
  }

  /// 点击一键领取
  Future<void> handleReceiveRebate() async {
    if ((reabteData.value.shuffle_amount_sum ?? 0) <= 0) {
      EasyLoading.showToast('您的返水金币为0，无法一键返水操作');
      return;
    }

    try {
      isLoading.value = true;

      final response =
          await ActivityApi.reqReceiveRebate(reabteData.value.end_time!);

      // 成功
      if (response.type == NetworkService.networkTypeSuccess) {
        if (response.data['response_code'] == '0') {
          EasyLoading.showError('一键返水失败，请联系客服');
        } else if (response.data['response_code'] == '9999') {
          // 延迟300ms
          await Future.delayed(const Duration(milliseconds: 300));

          EasyLoading.showSuccess('一键返水成功');
          // 二次获取返水数据
          await reqRebateData(needLoading: false);
          await LoginManager.instance.reqMoney();
          // 刷新余额
          await LoginApi.reqBalance();
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  // 更新游戏类别相关信息
  void updateProportionGame(int gameType) {
    // 游戏类别类型ID
    proportionGameType.value = gameType;

    String title = '';
    for (int i = 0; i < tabList.length; i++) {
      if (tabList[i].gameType == '${gameType}') {
        title = tabList[i].gameName;
      }
    }

    // 游戏类别名称
    proportionGameName.value = title;
  }

  void _setSubGameTabData(List<RebateDataChildItemBean> dataList) {
    List<RebateProportionDataBean> list = [];

    for (int i = 0; i < dataList.length; i++) {
      list.add(
        RebateProportionDataBean(
          gameName: dataList[i].play_name!,
          type: int.parse(
            dataList[i].sgame_type!,
          ),
        ),
      );
    }
    subGameTabData.value = list;
  }

  // 更新子游戏相关信息
  void updateProportionSubGame(int sgameType) {
    // 子游戏类型ID
    proportionSubGameType.value = sgameType;

    int gameType = proportionGameType.value;
    List<RebateDataChildItemBean> dataList =
        reabteData.value.list?[gameType] ?? [];

    String title = '';
    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i].sgame_type == '${sgameType}') {
        title = dataList[i].play_name!;
      }
    }

    // 子游戏名称
    proportionSubGameName.value = title;

    _setSubGameTabData(dataList);
  }

  /// 返水比例
  Future<void> reqRebateProportion({
    required int gameType,
    required int sgameType,
    bool? needLoading = false,
  }) async {
    // 防重复
    if (isRequestProportion.value) {
      return;
    }

    try {
      isRequestProportion.value = true;
      if (needLoading == true) {
        EasyLoading.show(status: '加载中...');
      }

      final response = await ActivityApi.reqRebateProportion(
        gameType: gameType,
        sgameType: sgameType,
      );

      updateProportionGame(gameType);
      updateProportionSubGame(sgameType);

      if (response.type == NetworkService.networkTypeSuccess) {
        var data = response.data;

        if (data is List && data[0] is List) {
          List<RebateProportionChildItemBean> resData =
              RebateProportionItemBean.fromJson(data[0]).data ?? [];

          proportionData.value = resData;
          Get.toNamed(Routes.REBATE_PROPORTION);
        }
      }
    } finally {
      isRequestProportion.value = false;
      if (needLoading == true) {
        EasyLoading.dismiss();
      }
    }
  }

  /// 点击返水记录
  Future<void> handleRebateRecord() async {
    try {
      isHistoryLoading.value = true;

      final response = await ActivityApi.reqHistoryRebateData();

      if (response.type == NetworkService.networkTypeSuccess) {
        historyData.value =
            RebateHistoryBean.fromJson(response.data).data ?? [];

        print('===> ${response.data}');
        Get.toNamed(Routes.REBATE_RECORD);
      }
    } finally {
      isHistoryLoading.value = false;
    }
  }

  /// 点击返水记录详情
  Future<void> handleRebateRecordDetail(String logId) async {
    // 防重复点击
    if (isDetailLoading.value) {
      return;
    }

    try {
      isDetailLoading.value = true;

      final response = await ActivityApi.reqRebateDetail(logId);

      if (response.type == NetworkService.networkTypeSuccess) {
        var data = RebateHistoryDetailBean.fromJson(response.data);
        historyDetailData.value = data;

        Get.toNamed(Routes.REBATE_DETAIL);
      }
    } finally {
      isDetailLoading.value = false;
    }
  }
}
