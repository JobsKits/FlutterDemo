import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/yuebao_bean.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../views/yuebao/yuebao_page_rule.dart';
import '../views/yuebao/yuebao_page_record.dart';

class YueBaoTabDataBean {
  YueBaoTabDataBean({
    required this.child,
    required this.title,
    required this.show,
  });

  final String title;
  final Widget child;
  final bool show;
}

// 跳转模式
enum JumpToPageMode {
  fixed, // 固定方案
  live, // 活期方案
  hasBuy, // 已购买方案
}

class ControllerYuebaoPage extends GetxController
    with GetTickerProviderStateMixin {
  // ----------------------------------------
  RxInt currentTabIndex = 0.obs;
  late PageController pageController;
  // Tab数据
  late RxList<YueBaoTabDataBean> tabData = <YueBaoTabDataBean>[].obs;
  late TabController tabController;
  // ----------------保险箱数据----------------
  RxDouble acctBalance = 0.00.obs; // 余额宝余额
  RxDouble balanceTreasure = 0.00.obs; // 钱包金币
  RxDouble genAmount = 0.00.obs; // 钱包金币
  RxDouble reciveAmount = 0.00.obs; // 钱包金币
  RxInt standard = 0.obs; // 钱包金币
  RxString remark = ''.obs; // 钱包金币

  RxString defaultTransferAmount = ''.obs; // 转入转出余额宝的金额
  RxString transferAmount = ''.obs; // 转入转出余额宝的金额
  RxBool isTransferLoading = false.obs;
  // ----------------------------------------
  Rx<YueBaoDataConfigBean> yuebaoDataConfig =
      YueBaoDataConfigBean().obs; // 余额宝数据配置
  Rx<YueBaoInterestDataBean> yuebaoInterestData =
      YueBaoInterestDataBean().obs; // 余额宝利息相关
  // ----------------------------------------
  Timer? timer; // 因10分钟结算周期，增加定时器查询金额变化
  // ----------------------------------------
  RxList<YueBaoInterestPlanItemBean> fixedPlan =
      <YueBaoInterestPlanItemBean>[].obs; // 固定方案
  RxList<YueBaoInterestPlanItemBean> livePlan =
      <YueBaoInterestPlanItemBean>[].obs; // 活动定方案

  Rx<YueBaoInterestPlanItemBean> detailData =
      YueBaoInterestPlanItemBean().obs; // 详情数据
  Rx<JumpToPageMode> pageMode = JumpToPageMode.fixed.obs; // 详情模式
  RxBool isDetailBtnLoading = false.obs;
  RxString buyAmount = ''.obs; // 购买金额
  RxString defaultBuyAmount = ''.obs; // 购买金额

  // ----------------------------------------
  RxList<YueBaoRecordDataItemBean> recordData =
      <YueBaoRecordDataItemBean>[].obs; // 记录明细的数据

  RxBool isLoading = false.obs;
  int page = 1;
  late ScrollController scrollController;
  // ----------------------------------------
  RxList<YueBaoHasBuyPlanItemBean> buyPlanData =
      <YueBaoHasBuyPlanItemBean>[].obs; // 已购买方案

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoading.value) {
        reqYueBaoRecord(isRefresh: false);
      }
    });

    _initTabData();
    _initData();

    // 监听登录
    ever(LoginManager.instance.isLogin, (isLogin) async {
      if (isLogin) {
        _initTabData();
        _initData();
      } else {
        _clearData();
        showLoginDialog();
      }
    });

    _startTimer();
  }

  @override
  void onClose() {
    timer?.cancel(); // 取消定时器

    tabController.dispose();
    pageController.dispose();
    super.onClose();
  }

  void _clearData() {
    acctBalance.value = 0.00; // 余额宝余额
    balanceTreasure.value = 0.00; // 钱包金币
    genAmount.value = 0.00; // 待领取金币
    reciveAmount.value = 0.00; // 待领取金币
    yuebaoDataConfig.value = YueBaoDataConfigBean();
    yuebaoInterestData.value = YueBaoInterestDataBean();
  }

  // 增加轮训查询余额
  _startTimer() {
    timer = Timer.periodic(const Duration(minutes: 10), (Timer t) {
      _reqSafeData(); // 每10分钟调用
    });
  }

  jumpToPage(int index, {required bool isTab}) {
    // 防止重复调用
    if (currentTabIndex.value == index) {
      return;
    }

    currentTabIndex.value = index;

    if (isTab) {
      pageController.jumpToPage(index);
    } else {
      tabController.animateTo(index);
    }
    _pageJumpToRequest();
  }

  void _initTabData() {
    List<YueBaoTabDataBean> curTabData = [
      // YueBaoTabDataBean(
      //   title: '定期方案',
      //   show: true,
      //   child: const YuebaoPagePlan(isFixed: true),
      // ),
      // YueBaoTabDataBean(
      //   title: '活期方案',
      //   show: true,
      //   child: const YuebaoPagePlan(isFixed: false),
      // ),
      // YueBaoTabDataBean(
      //   title: '已购买方案',
      //   show: true,
      //   child: const YuebaoPageHasBuy(),
      // ),
      YueBaoTabDataBean(
        title: '记录明细',
        show: true,
        child: const YuebaoPageRecord(),
      ),
      YueBaoTabDataBean(
        title: '利息规则',
        show: true,
        child: const YuebaoPageRule(),
      ),
    ];
    pageController = PageController(initialPage: 0);
    tabData.value = curTabData;
    tabController = TabController(length: curTabData.length, vsync: this);
  }

  // 初始化
  Future<void> _initData({bool? needLoading = true}) async {
    try {
      if (needLoading == true) {
        EasyLoading.show(status: '加载中...');
      }
      await _reqSafeData();
      await _reqWaitingCollection();
      await _reqYueBaoDataConfig();
      await _reqYueBaoInterest();
      await _pageJumpToRequest(needLoading: false);
    } finally {
      if (needLoading == true) {
        EasyLoading.dismiss();
      }
    }
  }

  // 页面跳转数据请求
  Future<void> _pageJumpToRequest({bool? needLoading = true}) async {
    try {
      if (needLoading == true) {
        EasyLoading.show(status: '加载中...');
      }

      // if (currentTabIndex.value == 0) {
      //   await _reqFixedPlan();
      // } else if (currentTabIndex.value == 0) {
      //   await _reqLivePlan();
      // } else if (currentTabIndex.value == 1) {
      //   // 已购买方案
      //   await _reqHasBuyPlanList();
      // } else
      if (currentTabIndex.value == 0) {
        // 记录
        await reqYueBaoRecord();
      }
    } finally {
      if (needLoading == true) {
        EasyLoading.dismiss();
      }
    }
  }

  // 更新详情数据
  void setDetailData({
    required YueBaoInterestPlanItemBean detail,
    required JumpToPageMode mode,
  }) {
    detailData.value = detail;
    pageMode.value = mode;

    // 处理默认值问题
    setDefaultBuyAmount('');
    setBuyAmount('');
  }

  // 跳转到详情
  void jumpToDetail({
    required YueBaoInterestPlanItemBean detail,
    required JumpToPageMode mode,
  }) {
    setDetailData(detail: detail, mode: mode);

    Get.toNamed(Routes.YUEBAO_DETAIL);
  }

  // 详情操作按钮点击
  void handleDetailBtn() {
    try {
      isDetailBtnLoading.value = true;
    } finally {
      isDetailBtnLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await _initData(needLoading: true);
  }

  // 获取保险箱相关数据
  Future<void> _reqSafeData() async {
    final response = await ActivityApi.reqSafeData();
    if (response.type == NetworkService.networkTypeSuccess) {
      var data = YueBaoSafeDataBean.fromJson(response.data);
      acctBalance.value =
          double.tryParse('${(data.acctBalance ?? 0) / 1000}') ?? 0;
      balanceTreasure.value =
          double.tryParse('${(data.balanceTreasure ?? 0) / 1000}') ?? 0;
      remark.value = data.remark ?? '';
      standard.value = data.activityStandard ?? 0;
    }
  }

  // 获取保险箱相关数据
  Future<void> _reqWaitingCollection() async {
    final response = await ActivityApi.reqWaitingCollection();
    print({'response ========${response.data}'});
    if (response.type == NetworkService.networkTypeSuccess) {
      genAmount.value =
          double.tryParse('${(response.data['gen_amount'] ?? 0) / 1000}') ?? 0;
      reciveAmount.value =
          double.tryParse('${(response.data['recive_amount'] ?? 0) / 1000}') ??
              0;
    }
  }

  /// 余额宝数据配置
  Future<void> _reqYueBaoDataConfig() async {
    final response = await ActivityApi.reqYueBaoDataConfig();
    if (response.type == NetworkService.networkTypeSuccess) {
      yuebaoDataConfig.value = YueBaoDataConfigBean.fromJson(response.data);
    }
  }

  /// 余额宝利息相关
  Future<void> _reqYueBaoInterest() async {
    // 判断状态
    if (yuebaoDataConfig.value.state != 1) {
      return;
    }

    final response = await ActivityApi.reqYueBaoInterest();
    if (response.type == NetworkService.networkTypeSuccess) {
      yuebaoInterestData.value = YueBaoInterestDataBean.fromJson(response.data);
    }
  }

  void setTransferAmount(String value) {
    transferAmount.value = double.parse(value).truncateToFixed(3);
  }

  void clearTransferValue() {
    transferAmount.value = '';
    defaultTransferAmount.value = '';
  }

  // 点击最大值
  Future<void> setMaxTransferAmount(double maxVal) async {
    if (defaultTransferAmount.value != '') {
      defaultTransferAmount.value = '';
      // 延迟150ms
      await Future.delayed(const Duration(milliseconds: 150));
    }

    defaultTransferAmount.value = '${maxVal}';
    transferAmount.value = '${maxVal}';
  }

  /// 转入余额宝
  Future<void> reqTransferInSafe() async {
    double amount = double.tryParse(transferAmount.value) ?? 0;

    if (transferAmount.value.trim() == '') {
      EasyLoading.showToast('请输入转入金额');
      return;
    }

    if (double.parse(transferAmount.value) == 0) {
      EasyLoading.showToast('转入金额需大于0');
      return;
    }

    double minDeposit =
        (yuebaoDataConfig.value.deposit_amount_mini ?? 0) / 1000;

    if (amount < minDeposit) {
      EasyLoading.showToast('最少转入金额${parseNumber(minDeposit)}');
      return;
    }

    try {
      isTransferLoading.value = true;

      //  验证余额宝
      final res = await ActivityApi.reqCheckYueBao();

      /// 验证余额宝成功
      if (res.type == NetworkService.networkTypeSuccess &&
          res.data['response_code'] == '9999') {
        final response = await ActivityApi.reqTransferInSafe(amount * 1000);

        if (response.type == NetworkService.networkTypeSuccess) {
          // 刷新数据
          await _initData(needLoading: false);
          await LoginManager.instance.reqMoney();

          EasyLoading.showSuccess('转入成功!');
          Get.back();
        }
      }
    } finally {
      isTransferLoading.value = false;
    }
  }

  /// 转出余额宝
  Future<void> reqTransferOutSafe() async {
    double amount = double.tryParse(transferAmount.value) ?? 0;

    if (transferAmount.value.trim() == '') {
      EasyLoading.showToast('请输入转出金额');
      return;
    }

    if (double.parse(transferAmount.value) == 0) {
      EasyLoading.showToast('转出金额需大于0');
      return;
    }

    try {
      isTransferLoading.value = true;
      final response = await ActivityApi.reqTransferOutSafe(amount * 1000);

      if (response.type == NetworkService.networkTypeSuccess) {
        // 刷新数据
        await _initData(needLoading: false);
        await LoginManager.instance.reqMoney();

        EasyLoading.showSuccess('转出成功!');
        Get.back();
      }
    } finally {
      isTransferLoading.value = false;
    }
  }

  // 获取利息方案
  Future<List<YueBaoInterestPlanItemBean>> _reqInterestPlan({
    required int page,
    required int pageSize,
    required bool isLive,
  }) async {
    final response = await ActivityApi.reqInterestPlan(
      page: 1,
      pageSize: 100,
      interestType: isLive == true ? 0 : 1, // 是否为活期方案
    );

    if (response.type == NetworkService.networkTypeSuccess) {
      List<YueBaoInterestPlanItemBean> data =
          YueBaoInterestPlanBean.fromJson(response.data).data ?? [];

      return data;
    }

    return [];
  }

  // 活期活期方案
  Future<void> _reqLivePlan() async {
    List<YueBaoInterestPlanItemBean> planData =
        await _reqInterestPlan(isLive: true, page: 1, pageSize: 100);

    livePlan.value = planData;
  }

  // 活期定期方案
  Future<void> _reqFixedPlan() async {
    List<YueBaoInterestPlanItemBean> planData =
        await _reqInterestPlan(isLive: false, page: 1, pageSize: 100);

    fixedPlan.value = planData;
  }

  /// 已购买方案
  Future<void> _reqHasBuyPlanList() async {
    final response =
        await ActivityApi.reqHasBuyPlanList(page: 1, pageSize: 200);

    if (response.type == NetworkService.networkTypeSuccess) {
      // buyPlanData.value =
      //     (YueBaoHasBuyPlanBean.fromJson(response.data).data ?? [])
      //         .where((item) => item.state == 1)
      //         .toList();
      buyPlanData.value =
          YueBaoHasBuyPlanBean.fromJson(response.data).data ?? [];
    }
  }

  /// 记录明细
  Future<void> reqYueBaoRecord({bool? isRefresh = true}) async {
    if (isRefresh == true) {
      page = 1;
    }
    // 获取请求前的时间戳
    final startTime = DateTime.now().millisecondsSinceEpoch;

    final response =
        await ActivityApi.reqYueBaoListData(page: page, pageSize: 10);
    // 获取请求后的时间戳
    final endTime = DateTime.now().millisecondsSinceEpoch;
    // 计算耗时
    final duration = endTime - startTime;

    print('=======> ${duration}');

    if (response.type == NetworkService.networkTypeSuccess) {
      YueBaoRecordDataBean record =
          YueBaoRecordDataBean.fromJson(response.data);
      if (page == 1) {
        recordData.value = record.data ?? [];
      } else {
        recordData.addAll(record.data ?? []);
      }
      page += 1;
    }
  }

  Future<void> setDefaultBuyAmount(String amount) async {
    if (defaultBuyAmount.value != '') {
      defaultBuyAmount.value = '';
      // 延迟150ms
      await Future.delayed(const Duration(milliseconds: 150));
    }
    defaultBuyAmount.value = amount;
  }

  // 更新值
  void setBuyAmount(String amount) {
    buyAmount.value = amount;
  }

  /// 购买方案
  Future<void> reqBuyPlan() async {
    if (buyAmount.value == '') {
      EasyLoading.showToast('请输入金额');
      return;
    }
    if (double.parse(buyAmount.value) == 0) {
      EasyLoading.showToast('请输入大于0的金额');
      return;
    }

    try {
      isDetailBtnLoading.value = true;

      double amount = double.parse(buyAmount.value) * 1000;

      final response = await ActivityApi.reqBuyPlan(
          amount: parseNumber(amount), planId: detailData.value.plan_id!);

      if (response.type == NetworkService.networkTypeSuccess) {
        EasyLoading.showSuccess('购买成功');
        await LoginManager.instance.reqMoney();

        // 刷新接口
        if (pageMode.value == JumpToPageMode.live) {
          await _reqLivePlan();
        } else {
          await _reqFixedPlan();
        }
        Get.back();
      }
    } finally {
      isDetailBtnLoading.value = false;
    }
  }

  // 赎回方案
  Future<void> reqSellPlan(int planId) async {
    try {
      isDetailBtnLoading.value = true;

      final response = await ActivityApi.reqSellPlan(planId: planId);

      if (response.type == NetworkService.networkTypeSuccess) {
        await _reqHasBuyPlanList(); // 刷新接口
        await _initData(needLoading: false); // 刷新余额
        await LoginManager.instance.reqMoney();

        EasyLoading.showSuccess('赎回成功');
        Get.back();
      }
    } finally {
      isDetailBtnLoading.value = false;
    }
  }

  Future<void> reqReviceYuEbao() async {
    final response = await ActivityApi.reqReviceYuEbao();
    if (response.type == NetworkService.networkTypeSuccess) {
      await _initData(needLoading: false); // 刷新余额
      await LoginManager.instance.reqMoney();
      reciveAmount.value = 0.0;
      EasyLoading.showSuccess('领取成功');
    }
  }
}
