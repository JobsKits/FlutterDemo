import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/api/system_api.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/data/withdraw_type_new_bean2.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/constants/withdraw_constants.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../../api/login_api.dart';
import '../../../../api/user_api.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../kernel/configs/app_configs.dart';
import '../../../../utils/CommonRipple.dart';
import '../../user/widget/change_phone_dialog.dart';
import '../data/Third_wallet_bean.dart';
import '../data/Wallet_bean.dart';
import '../data/withdraw_type_bean.dart';
import '../data/withdraw_type_bean2.dart';
import '../data/withdraw_type_new_bean.dart';
import '../widget/recharge_ok_button_widget.dart';
import '../widget/recharge_tips_dialog.dart';
import '../widget/wallet_input_field_widget.dart';

class NewWithdrawalController extends GetxController
    with GetTickerProviderStateMixin, WidgetsBindingObserver {
  RxBool isExpand = false.obs; //是否已展开列表，默认为false
  final RxBool isShowMore = false.obs;

  final RxBool isRefreshBalance = false.obs; // 是否刷新余额
  late AnimationController animationController; // 刷新按钮动画

  // ------------------------------------------------
  RxBool isReqWithdrawAccountFinish = false.obs; // 是否请求完成用户钱包
  final List<int> notBankList =
      withdrawMethodConfigList.map((e) => e['payType'] as int).toList();
  RxList<WithdrawBindCardItemBean> withdrawAccountList =
      <WithdrawBindCardItemBean>[].obs; // 提现账户
  RxList<WithdrawBindCardItemBean> currentWithdrawAccountList =
      <WithdrawBindCardItemBean>[].obs; // 当前提现账户列表
  // ------------------------------------------------

  RxString rate = ''.obs; // 汇率
  RxString currency = ''.obs; // 币种
  RxInt withdrawType = 0.obs; // 提现模式 1: 比例 2: 固定
  RxString withdrawFee = '0'.obs; // 提现手续费
  RxString withdrawFeeDesc = ''.obs; // 手续费说明
  Map? withTypeMap; // 提现分类map

  int rounding = 1; // 1-向上取整，2-四舍五入，3-向下取整
  RxDouble limitMin = 1.0.obs; // 最小限额
  RxDouble limitMax = 10e8.obs; // 最大限额
  double oldLimitMin = 0.0; //保存上一次选择的最小值
  double oldLimitMax = 10e8; //保存上一次选择的最大值

  RxString withdrawAmount = '0'.obs; // 提现金额
  RxString showAmount = ''.obs; // 用来显示的
  RxDouble realWithdrawFee = 0.0.obs; // 计算出的手续费
  RxString realWithdrawAmount = '0'.obs; // 真实到账金额
  RxString acctPwd = ''.obs; // 资金密码

  RxBool isClickWithdraw = false.obs;
  Worker? loginListener;

  late TabController tabController;
  RxInt currentTabIndex = 0.obs; //当前选中的tab
  late ScrollController withdrawScrollController;
  RxList<WithdrawTypeTabBean2> tabList = <WithdrawTypeTabBean2>[].obs;

  bool isBand = false; //其他页面错误跳转的标识，禁用绑定手机号逻辑
  late CertificationInfoBean certificationInfoData; //保存认证信息
  RxInt currentSelectItemIndex = 0.obs;
  //===============================新提现⬇️
  RxList<PayInfo> bindList = <PayInfo>[].obs;
  List<List<PayInfo>> bindAllList = <List<PayInfo>>[];
  Rxn<PayInfo> currentSelectItem = Rxn();
  bool hasPwd = false; //是否有支付密码，默认false
  //===============================新提现⬆️
  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    if (Get.arguments != null) {
      final arguments = Get.arguments as Map<String, dynamic>;
      isBand = arguments['isBand'] ?? false;
    }
    withdrawScrollController = ScrollController();
    tabController = TabController(length: 0, vsync: this);
    animationController = AnimationController(
      duration: const Duration(seconds: 1), // 动画持续时间
      vsync: this,
    )..repeat(); // 循环动画
    checkPwdStatus();
    initData();

    // 使用 ever 方法监听 登录状态，状态发生改变， 请求余额数据
    loginListener = ever(LoginManager.instance.isLogin, (value) {
      initData();
    });
  }

  void checkPwdStatus() async {
    hasPwd = await UserApi().checkPwdStatus(2);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    tabController.dispose();
    animationController.dispose(); // 先释放 AnimationController
    // 取消监听，避免销毁后仍然触发
    loginListener?.dispose();
    super.onClose(); // 然后调用父类的 dispose 方法
  }

  /// 恢复默认值
  _reset() {
    isShowMore.value = false;
  }

  /// 初始化提现
  Future<void> initData() async {
    // 无租户信息时
    if (TenantManager.instance.tenantBean == null) {
      return;
    }
    // 用户已登录
    if (LoginManager.instance.isLogin.value) {
      rate.value = TenantManager.instance.tenantBean!.rate!;
      currency.value = TenantManager.instance.tenantBean!.area!;
      reqMoney(); // 获取余额
      reqWithdrawLimint(); // 获取提现限额
      reqCertificationInfo(); // 获取认证信息
      reqDefaultBankCard(); // 获取提现方式
    } else {
      _reset();
    }
  }

  Map? limitMap;
  // 提现限制
  Future<void> reqWithdrawLimint() async {
    final res = await SystemApi.reqWithdrawLimint();
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['withTypeMap'] is Map) {
        withTypeMap = res.data['withTypeMap'];
      }

      if (res.data['rounding'] != null) {
        rounding = int.tryParse(res.data['rounding']) ?? 1;
      }
      if (res.data['withdraw_setting_map'] is Map) {
        limitMap = res.data['withdraw_setting_map'];
      }
      final data = WithdrawLimitConfigBean.fromJson(res.data);

      final withdrawMinAmount =
          data.withdrawMinAmount ?? data.withdrawMinAmountAli;
      final withdrawAmount = data.withdrawAmount ?? data.withdrawAmountAli;

      limitMin.value = double.parse(withdrawMinAmount as String) / 1000;
      limitMax.value = double.parse(withdrawAmount as String) / 1000;
      oldLimitMin = limitMin.value;
      oldLimitMax = limitMax.value;
      getCurrentLimit();
      try {
        final feeList = json.decode(data.listFeel!);

        if (feeList is List) {
          Map<String, dynamic>? feeMap = feeList[0];

          if (withTypeMap == null && feeMap != null) {
            withdrawType.value = feeMap['type'] is int
                ? feeMap['type']
                : int.parse(feeMap['type']);
            withdrawFee.value = feeMap['withdrawal_fee'].toString();
          }
        }
      } catch (err) {
        throw Exception('decode listFeel error');
      }
    }
  }

  //  获取新增的针对单个渠道的限额
  getCurrentLimit() {
    bool hasData = false; //是否有指定数据
    double? tempLimitMin;
    double? tempLimitMax;
    if (limitMap != null) {
      limitMap!.forEach((key, value) {
        if (currentSelectItem.value?.payOrgId == int.parse(key)) {
          if (value['min'] != null && value['min'] != "") {
            if (value['min'] is String) {
              tempLimitMin = num.parse(value['min']) / 1000;
            }
            if (value['min'] is num) {
              tempLimitMin = value['min'] / 1000;
            }
          }
          if (value['max'] != null && value['max'] != "") {
            if (value['max'] is String) {
              tempLimitMax = num.parse(value['max']) / 1000;
            }
            if (value['max'] is num) {
              tempLimitMax = value['max'] / 1000;
            }
          }
          hasData = true;
        }
      });
    }
    if (hasData) {
      limitMin.value = tempLimitMin ?? oldLimitMin;
      limitMax.value = tempLimitMax ?? oldLimitMax;
    } else {
      limitMin.value = oldLimitMin;
      limitMax.value = oldLimitMax;
    }
  }

  /// 获取账户余额 （能点击刷新按钮，必定已登录，否则有BUG）
  Future<void> reqMoney() async {
    if (isRefreshBalance.value) return;

    isRefreshBalance.value = true;
    Future.delayed(const Duration(milliseconds: 1000), () async {
      await LoginManager.instance.reqMoney();

      isRefreshBalance.value = false;
    });
  }

  // 获取返回用户钱包地址
  Future<void> reqBindBankList() async {
    try {
      isReqWithdrawAccountFinish.value = false;
      final res = await SystemApi.reqBindBankList();

      if (res.type == NetworkService.networkTypeSuccess) {
        final data = WithdrawBindCardBean.fromJson(res.data);

        // 含有数据
        if (data.count! > 0) {
          withdrawAccountList.value = data.data!; // 更新提现账户列表
        }
        // _updateCurrentBindCardList(0);
      }
    } finally {
      isReqWithdrawAccountFinish.value = true;
    }
  }

  // 获取提现认证
  Future<void> reqCertificationInfo() async {
    final res = await SystemApi.reqCertificationInfo();
    if (res.type == NetworkService.networkTypeSuccess) {
      certificationInfoData = CertificationInfoBean.fromJson(res.data);
      // rz2_state 0都没认证，2已认证，3待审核，4审核拒绝需要重新认证
      // withdraw_attestation: '0', // 是否开启认证 0否 1是
      int.parse(certificationInfoData.withdrawAttestation!);
      int.parse(certificationInfoData.rz2State == ''
          ? '-1'
          : certificationInfoData.rz2State!);
      // 开启了认证 且 未认证
      // if (withdrawAttestation == 1 && certStatus != 2) {
      //   comfirmDialog(
      //     title: '提示',
      //     content: certStatus == 3 ? '身份认证审核中，请耐心等待' : '请完成身份认证',
      //     confirmText: '去认证',
      //     onConfirm: () {
      //       Get.back(); // 关闭弹窗
      //       Get.offNamed(Routes.USER_INFO); // 身份认证，暂时无页面
      //     },
      //   );
      // } else {
      // 用户钱包地址
      reqBindBankList();
      // }
    }
  }

  RxBool isLoading = false.obs;
  WithdrawTypeNewBean2? noPayInfo;

  /// 获取提现方式
  Future<void> reqDefaultBankCard({int? defaultIndex}) async {
    bindAllList.clear();
    isLoading.value = true;
    try {
      final res = await SystemApi.reqDefaultBankCard2();
      if (res.type == NetworkService.networkTypeSuccess) {
        if (res.data is List) {
          tabList.clear();

          for (var item in res.data) {
            List<PayInfo> tempList = [];

            WithdrawTypeTabBean2 secondItem =
                WithdrawTypeTabBean2.fromJson(item);
            if (secondItem.data != null && secondItem.data!.isNotEmpty) {
              for (var item2 in secondItem.data!) {
                if (item2.payInfo != null && item2.payInfo!.isNotEmpty) {
                  for (var item3 in item2.payInfo!) {
                    if (item3.payInfoId != 0) {
                      tempList.add(item3);
                    }
                  }
                }
              }
            }
            if (withTypeMap != null && withdrawType.value == 0) {
              int rechargeTypeId = secondItem.rechargeTypeId ?? 0;
              String key = '${rechargeTypeId}';
              if (withTypeMap != null && withTypeMap![key] != null) {
                Map info = withTypeMap![key];
                withdrawType.value = info['feeType'] is int
                    ? info['feeType']
                    : int.parse(info['feeType']);
                withdrawFee.value = info['feeNum'].toString();
                withdrawFeeDesc.value = info['feeDesc'] ?? '';
              }
            }

            tabList.add(secondItem);
            bindAllList.add(tempList);
            if (secondItem.rechargeTypeId == 2 &&
                secondItem.data?.first.payOrgId == 308) {
              //数字货币移除no钱包
              noPayInfo = secondItem.data!
                  .firstWhereOrNull((item) => item.payOrgId == 308);
              noPayInfo?.label = secondItem.label;
              tempList.removeWhere((item) => item.payOrgId == 308);
            }
          }
          if (noPayInfo != null) {
            tabList.insert(
                0,
                WithdrawTypeTabBean2(
                    title: noPayInfo!.payOrgName,
                    rechargeTypeId: 308,
                    label: noPayInfo?.label));
            bindAllList.insert(0, []);

            bindList.value = bindAllList[defaultIndex ?? 0];
          } else {
            bindList.value = bindAllList[0];
          }
          if (tabList.isNotEmpty) {
            tabController.dispose();
            tabController = TabController(length: tabList.length, vsync: this);
            if (noPayInfo != null) {
              // tabController.index = defaultIndex ?? 0;
              // currentTabIndex.value = defaultIndex ?? 0;
              changeTabIndex(defaultIndex ?? 0);
            }
            changeSelectItemIndex(0);
          }
        }
        // 初始化账户数据
        // _updateCurrentBindCardList(currentWithdrawTypeIndex.value);
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// 确认弹窗
  void comfirmDialog({
    required String title,
    required String content,
    required String confirmText,
    required VoidCallback onConfirm,
    VoidCallback? onBack,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(
        fontSize: 54.sp,
        fontWeight: FontWeight.bold,
      ),
      titlePadding: EdgeInsets.symmetric(vertical: 30.h),
      barrierDismissible: false,
      content: Center(
        child: Text(
          content,
          style: TextStyle(
            fontSize: 52.sp,
            color: Colors.black,
            height: 3,
          ),
        ),
      ),
      radius: 40.r,
      contentPadding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 40.h),
      confirm: SizedBox(
        width: 315.w,
        height: 105.h,
        child: ElevatedButton(
            onPressed: () {
              AppManager.instance.tapVibrate();
              onConfirm();
            },
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(
                Get.context?.theme.primaryColor,
              ),
            ),
            child: Text(
              confirmText,
              style: const TextStyle(color: Color(colorFFFFFF)),
            )),
      ),
      cancel: SizedBox(
        width: 315.w,
        height: 105.h,
        child: OutlinedButton(
          onPressed: () {
            AppManager.instance.tapVibrate();
            if (onBack != null) {
              onBack();
            } else {
              Get.back(); // 关闭对话框
              // Get.back(); // 路由返回
            }
          },
          style: ButtonStyle(
            side: const WidgetStatePropertyAll(
              BorderSide(color: Color(colorEEEEEE)),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
          child: const Text(
            '取消',
            style: TextStyle(color: Color(colorAAAAAA)),
          ),
        ),
      ),
    );
  }

  // 修改提现金额
  void setWithdrawAmount(String value) {
    withdrawAmount.value = value;
    showAmount.value = (value == '0' || value == "") ? "" : value;
    // 没有提现金额
    if (value == '' || value == '0') {
      realWithdrawFee.value = 0.0;
      realWithdrawAmount.value = '0';
    } else {
      if (withdrawType.value == 1) {
        double diff =
            (double.parse(value) * double.parse(withdrawFee.value)) / 100;
        if (rounding == 1) {
          diff = diff.ceilToDouble();
        } else if (rounding == 2) {
          diff = diff.roundToDouble();
        } else if (rounding == 3) {
          diff = diff.floorToDouble();
        }
        realWithdrawFee.value = diff;
        realWithdrawAmount.value =
            (double.parse(value) - diff).truncateToFixed(2);
      } else if (withdrawType.value == 2) {
        double diff = double.parse(value) - double.parse(withdrawFee.value);
        realWithdrawAmount.value = diff.truncateToFixed(2);
      }
    }
  }

  // 修改资金密码
  void setAcctPwd(String str) {
    acctPwd.value = str;
  }

  // 数字钱包彩金文本
  String getWithdrawBonusStr() {
    if (tabList[currentTabIndex.value].rechargeTypeId == 2) {
      if (withTypeMap != null && withTypeMap!['2'] != null) {
        Map info = withTypeMap!['2']!;
        if (info['bonusType'] == '1') {
          return '每日首次赠送: ${info['bonusNum']}%';
        } else if (info['bonusType'] == '2') {
          return '每日首次赠送: ${info['bonusNum']}元';
        }
      }
    }
    return '';
  }

  // 提现手续费文本
  String getWithdrawFeeStr() {
    // 比例
    if (withdrawType.value == 1) {
      return '${realWithdrawFee.value.truncateToFixed(2)} ';
    }

    // 固定
    if (withdrawType.value == 2) {
      return '￥${double.parse(withdrawFee.value).truncateToFixed(2)}';
    }

    return '0.00';
  }

  // 提现手续费文本
  String getWithdrawFeeStr2() {
    int rechargeTypeId = tabList[currentTabIndex.value].rechargeTypeId ?? 0;
    // 虚拟币
    bool isVirtual = rechargeTypeId == 1;
    // 比例
    if (withdrawType.value == 1) {
      return '${realWithdrawFee.value.truncateToFixed(2)} ${isVirtual ? "CNY" : ""}';
    }

    // 固定
    if (withdrawType.value == 2) {
      return '￥${double.parse(withdrawFee.value).truncateToFixed(2)}';
    }

    return '0.00';
  }

  String getWithdrawRealStr() {
    if (realWithdrawAmount.value == '0') {
      return '0.00';
    }

    bool isVirtual = tabList[currentTabIndex.value].rechargeTypeId == 1;
    return "${realWithdrawAmount.value}${isVirtual ? 'U' : currency.value}";
  }

  String getWithdrawRealStr2() {
    if (realWithdrawAmount.value == '0') {
      return '0.00';
    }
    return "${(double.parse(realWithdrawAmount.value) / digitalCurrencyRate.value).truncateToFixed(2)}U";
    // return "${truncateToFixed(double.parse(realWithdrawAmount.value) / digitalCurrencyRate.value, 2)}U";
  }

  bool validWithdraw() {
    PayInfo withdrawItem;
    if (isNoPay.value &&
        isNoPayBind.value &&
        noPayInfo?.payInfo?.isNotEmpty == true) {
      // withdrawItem = noPayInfo!.payInfo![0];
      withdrawItem = noPayInfo!.payInfo!
          .firstWhere((item) => item.pay_no == walletBean.value?.walletAddress);
      currentSelectItem.value = withdrawItem;
    } else {
      withdrawItem = bindList[currentSelectItemIndex.value];
    }
    if (double.parse(withdrawAmount.value) < limitMin.value) {
      EasyLoading.showToast('提现金额不可小于${parseNumber(limitMin.value)}');
      return false;
    }

    if (double.parse(withdrawAmount.value) > limitMax.value) {
      EasyLoading.showToast('提现金额不可大于${parseNumber(limitMax.value)}');
      return false;
    }

    if (withdrawItem.payOrgId! < 0) {
      EasyLoading.showToast('未绑定货币信息');
      return false;
    }

    // 未绑定提现钱包
    if (currentSelectItem.value == null && !isNoPay.value) {
      EasyLoading.showToast('请选择收款钱包');
      return false;
    }

    // 提现金额
    if (withdrawAmount.value.trim() == '') {
      EasyLoading.showToast('提现金额不能为空');
      return false;
    }

    if (double.parse(LoginManager.instance.balanceStr.value) <
        double.parse(withdrawAmount.value.trim())) {
      EasyLoading.showToast('账户余额不足，请修改提现金额');
      return false;
    }

    return true;
  }

  // 提现
  void handleWithdraw(VoidCallback callback) async {
    // 资金密码
    if (acctPwd.value.trim() == '') {
      EasyLoading.showToast('请输入资金密码');
      return;
    }

    if (isClickWithdraw.value) {
      return;
    }

    try {
      isClickWithdraw.value = true;
      EasyLoading.show(indicator: const CommonLoadingView());
      var data = {
        'amount': parseNumber(double.parse(withdrawAmount.value.trim()) * 1000),
        'acct_pwd': acctPwd.value,
        'open_addr': '',
        // 'rate': truncateToFixed((1 / digitalCurrencyRate.value), 2),
        'rate': digitalCurrencyRate.value,
        'pay_org_id': currentSelectItem.value!.payOrgId,
        'pay_no': currentSelectItem.value!.pay_no,
        'pay_org_name': currentSelectItem.value!.pay_org_name,
        'pay_info_id': currentSelectItem.value!.payInfoId,
        'pay_name': currentSelectItem.value!.pay_name,
      };
      final res = await SystemApi.reqWithdraw(data);
      print("提现传参：${data}  提现响应：${res}");
      print('====> ${res.type} ${res.data}');

      if (res.type == NetworkService.networkTypeSuccess) {
        // 成功
        if (res.data['response_code'].toString() == '5016') {
          EasyLoading.showError('尊敬的会员，请充值后申请提现');
          return;
        }

        callback();
      }
    } finally {
      EasyLoading.dismiss();
      isClickWithdraw.value = false;
    }
  }

  RxBool isNoPay = false.obs;
  void changeTabIndex(int index) {
    tabController.index = index;
    currentSelectItem.value = null;
    currentTabIndex.value = index;
    bindList.value = bindAllList[index];

    var currentItem = tabList[currentTabIndex.value];
    isNoPay.value = currentItem.rechargeTypeId == 308;
    if (isNoPay.value && noPayInfo != null) {
      reqNoPayStatus();
    }

    if (bindList.isNotEmpty) {
      currentSelectItem.value = bindList[0];
      changeSelectItemIndex(0);
      getCurrentLimit();
    } else if (isNoPay.value) {
      currentSelectItem.value = noPayInfo!.payInfo![0];
      describe.value = noPayInfo?.describeinfo ?? "";
      getCurrentLimit();
    } else {
      limitMin.value = oldLimitMin;
      limitMax.value = oldLimitMax;
    }

    int rechargeTypeId = tabList[index].rechargeTypeId ?? 0;
    bool isVirtual = rechargeTypeId == 1;
    if (isVirtual) {
      reqPayoutsRates();
    }
    String key = '${rechargeTypeId}';
    if (withTypeMap != null && withTypeMap![key] != null) {
      Map info = withTypeMap![key];
      withdrawType.value =
          info['feeType'] is int ? info['feeType'] : int.parse(info['feeType']);
      withdrawFee.value = info['feeNum'].toString();
      withdrawFeeDesc.value = info['feeDesc'] ?? '';
    }

    setWithdrawAmount('0');
  }

  void scrollTop() {
    withdrawScrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  //检测是否绑定了手机号
  void checkIsBandPhone() {
    if (int.parse(certificationInfoData.isBindingPhone ?? "0") == 0 && isBand) {
      comfirmDialog(
        title: '提示',
        content: "请绑定手机号码!",
        confirmText: '去绑定',
        onConfirm: () async {
          Get.back(); // 关闭弹窗

          String? value = await Get.dialog(
            const ChangePhoneDialog(
              isShowSendCode: true,
            ),
            barrierDismissible: false,
          );

          if (value != null) {
            reqCertificationInfo();
          }
          // Get.toNamed(Routes.USER_INFO, arguments: {
          //   "isShowSendCode": int.parse(data.phone_sms_verify ?? "0") != 0
          // })?.then((value) {
          //   reqCertificationInfo();
          // }); // 身份认证，暂时无页面
        },
        // onBack: () {
        //   Get.back(); // 关闭弹窗
        // }
      );
    }
  }

  //提现
  void withdrawal() {
    if (bindList.isEmpty && !isNoPay.value) {
      EasyLoading.showToast("请先添加提现账户");
      return;
    }
    if ((certificationInfoData.withdrawSmsVerify ?? "0") == "1" && isBand) {
      comfirmDialog(
        title: '提示',
        content: "请绑定手机号码!",
        confirmText: '去绑定',
        onConfirm: () async {
          Get.back(); // 关闭弹窗
          Get.toNamed(Routes.USER_INFO, arguments: {
            // "isShowSendCode":
            //     (certificationInfoData.phone_sms_verify ?? "0") != "0", //暂时写死
            "isShowSendCode": true,
            "isShowBindPhoneDialog": true,
          })?.then((value) {
            reqCertificationInfo();
          }); // 身份认证，暂时无页面
        },
      );
    } else {
      var tempList = tabList[currentTabIndex.value].data ?? [];
      if (!isNoPay.value && tempList.isEmpty) {
        //如果不是nopay，列表为空，直接返回
        return;
      }
      var bean;
      if (isNoPay.value && isNoPayBind.value) {
        bean = noPayInfo;
      } else {
        if (tempList.length > 1) {
          bean = tempList[currentSelectItemIndex.value];
        } else {
          bean = tempList[0];
        }
      }

      if (validWithdraw()) {
        //先进行是否能提现的判断
        //通过判断能提现后，判断是否有推荐提现渠道
        //如果有推荐提现渠道，弹窗
        if (bean.popupContent != null && bean.popupContent!.isNotEmpty) {
          Get.dialog(RechargeTipsDialog(
            rechargeBtnStr: bean.popupWithdrawalInfo?.payOrgName ?? "",
            dialogContent: bean?.popupContent ?? "",
            isRecharge: false,
            normalRecharge: () {
              AppManager.instance.tapVibrate();
              Get.back();
              showConfirmPop();
            },
            customRecharge: () {
              AppManager.instance.tapVibrate();
              Get.back();
              if (bindAllList.any((item) => item.any((item2) =>
                  item2.payOrgId == bean?.popupWithdrawalInfo?.popupPayId))) {
                //有这个推荐id，找到对应的tab，进行跳转
                int index = bindAllList.indexWhere((subList) => subList.any(
                    (obj) =>
                        obj.payOrgId == bean?.popupWithdrawalInfo?.popupPayId));
                if (index != -1) {
                  //找到了index，进行跳转
                  changeTabIndex(index);
                  if (bindList.isNotEmpty) {
                    var index2 = bindList.indexWhere((item) =>
                        item.payOrgId == bean?.popupWithdrawalInfo?.popupPayId);
                    if (index2 != -1) {
                      changeSelectItemIndex(index2);
                    }
                  }
                }
              } else {
                Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT); //新账户管理
              }
              // int index = showWithrawMethodList.indexWhere((item) =>
              //     item.payType == bean?.popupWithdrawalInfo?.payOrgId);
              // changeWithdrawTypeIndex(index);
            },
          ));
        } else {
          //如果没有推荐渠道，直接显示确认弹窗
          showConfirmPop();
        }
      }
    }
  }

  //显示提币确认弹窗
  void showConfirmPop() {
    int rechargeTypeId = tabList[currentTabIndex.value].rechargeTypeId ?? 0;
    // 虚拟币
    bool isVirtual = rechargeTypeId == 1;
    if (isVirtual) {
      Get.bottomSheet(
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.r),
                topRight: Radius.circular(50.r)),
            child: SingleChildScrollView(
              child: Container(
                height: 0.5.sh,
                color: Colors.white,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 100.h),
                      padding: EdgeInsets.symmetric(horizontal: 70.w),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "￥${withdrawAmount.value}",
                                  style: TextStyle(
                                      fontSize: 90.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "提现金额",
                                  style: TextStyle(fontSize: 40.sp),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 80.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 36.sp),
                                          text: "手续费：",
                                          children: [
                                        TextSpan(
                                            text: isVirtual
                                                ? getWithdrawFeeStr2()
                                                : getWithdrawFeeStr(),
                                            style: const TextStyle(
                                                color: Colors.black))
                                      ])),
                                  if (withdrawFeeDesc.isNotEmpty)
                                    CommonRipple(
                                      onTap: () {
                                        AppManager.instance.tapVibrate();
                                        // print('详见规则: ${controller.withdrawFeeDesc.value}');
                                        Get.dialog(
                                          Dialog(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                top: 40.w,
                                                left: 40.w,
                                                right: 40.w,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(40.r),
                                                ),
                                              ),
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        '手续费规则',
                                                        style: TextStyle(
                                                          fontSize: 50.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                      HtmlWidget(
                                                        withdrawFeeDesc.value,
                                                        textStyle:
                                                            const TextStyle(
                                                          color: Color(
                                                              color4B4B4B),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 150.w,
                                                          right: 150.w,
                                                          bottom: 60.h,
                                                        ),
                                                        child:
                                                            RechargeOkButtonWidget(
                                                          text: '确认',
                                                          clickButton: () {
                                                            AppManager.instance
                                                                .tapVibrate();
                                                            Get.back();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Positioned(
                                                    right: 0,
                                                    top: -20.h,
                                                    child: GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .translucent,
                                                      onTap: () {
                                                        AppManager.instance
                                                            .tapVibrate();
                                                        Get.back();
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            10.w),
                                                        child: const Icon(
                                                          Icons.close,
                                                          color:
                                                              Color(0xffc6c6c6),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        ' 详见规则',
                                        style: TextStyle(
                                          fontSize: 30.sp,
                                          color: const Color(colorFE6D02),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 36.sp),
                                      text: "预计到账：",
                                      children: [
                                    TextSpan(
                                        text: isVirtual
                                            ? getWithdrawRealStr2()
                                            : getWithdrawRealStr(),
                                        style: const TextStyle(
                                            color: Color(colorFE6D02)))
                                  ])),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "汇率：1U：${digitalCurrencyRate.value}￥",
                            style: TextStyle(fontSize: 36.sp),
                          ),
                          SizedBox(
                            height: 100.h,
                          ),
                          WalletInputFieldWidget(
                            title: '交易密码',
                            isPwdNewStyle: true,
                            displayType: DisplayType.password,
                            obscureText: true,
                            placeholder: '请输入交易密码',
                            onChanged: (value) => setAcctPwd(value),
                          ),
                          RechargeOkButtonWidget(
                            text: "确认提现",
                            clickButton: () {
                              AppManager.instance.tapVibrate();
                              handleWithdraw(() {
                                Get.back();
                                showSuccessDialog();
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        top: 40.h,
                        right: 40.w,
                        child: CommonRipple(
                          onTap: () {
                            AppManager.instance.tapVibrate();
                            setAcctPwd('');
                            Get.back();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Color(colorB7B7B7),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
          isDismissible: false);
    } else {
      Get.bottomSheet(
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.r),
                topRight: Radius.circular(50.r)),
            child: SingleChildScrollView(
              child: Container(
                height: 0.5.sh,
                color: Colors.white,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 100.h),
                      padding: EdgeInsets.symmetric(horizontal: 70.w),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "￥${withdrawAmount.value}",
                                  style: TextStyle(
                                      fontSize: 90.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "提现金额",
                                  style: TextStyle(fontSize: 40.sp),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 80.h,
                          ),
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: const Color(color949494),
                                      fontSize: 36.sp),
                                  text: "手续费：",
                                  children: [
                                TextSpan(
                                    text: isVirtual
                                        ? getWithdrawFeeStr2()
                                        : getWithdrawFeeStr(),
                                    style: const TextStyle(color: Colors.black))
                              ])),
                          SizedBox(
                            height: 10.h,
                          ),
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: const Color(color949494),
                                      fontSize: 36.sp),
                                  text: "实际到账：",
                                  children: [
                                TextSpan(
                                    text: isVirtual
                                        ? getWithdrawRealStr2()
                                        : getWithdrawRealStr(),
                                    style: const TextStyle(
                                        color: Color(colorFE6D02)))
                              ])),
                          SizedBox(
                            height: 100.h,
                          ),
                          WalletInputFieldWidget(
                            title: '交易密码',
                            isPwdNewStyle: true,
                            displayType: DisplayType.password,
                            obscureText: true,
                            placeholder: '请输入交易密码',
                            onChanged: (value) => setAcctPwd(value),
                          ),
                          RechargeOkButtonWidget(
                            text: "确认提现",
                            clickButton: () {
                              AppManager.instance.tapVibrate();
                              handleWithdraw(() {
                                Get.back();
                                showSuccessDialog();
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        top: 40.h,
                        right: 40.w,
                        child: CommonRipple(
                          onTap: () {
                            AppManager.instance.tapVibrate();
                            setAcctPwd('');
                            Get.back();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Color(colorB7B7B7),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
          isDismissible: false);
    }
  }

  //显示提币成功弹窗
  void showSuccessDialog() {
    Get.dialog(Dialog(
      child: Container(
        width: 660.w,
        height: 520.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(43.r), color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.theme1.images.recharge.iconSuccess,
              width: 158.w,
              height: 158.h,
            ),
            SizedBox(
              height: 24.h,
            ),
            Text(
              "已提交",
              style: TextStyle(fontSize: 45.sp),
            ),
            // SizedBox(
            //   height: 15.h,
            // ),
            // Text("请耐心等待，预估1分钟后到账",
            //     style: TextStyle(
            //         fontSize: 33.sp, color: const Color(color8D8D8D))),
          ],
        ),
      ),
    ));
    // 在两秒后关闭弹窗
    Future.delayed(const Duration(seconds: 2), () {
      if (Get.isDialogOpen ?? false) {
        Get.back(); // 关闭弹窗
      }
    });
  }

  RxString describe = "".obs;
  void changeSelectItemIndex(int index) {
    if (bindList.length > index) {
      currentSelectItemIndex.value = index;
      currentSelectItem.value = bindList[index];
      var tempList = tabList[currentTabIndex.value].data ?? [];
      int rechargeTypeId = tabList[currentTabIndex.value].rechargeTypeId ?? 0;
      WithdrawTypeNewBean2? bean;
      if (rechargeTypeId == 2) {
        bean = tempList.firstWhereOrNull(//数字货币
            (item) => item.payOrgId == currentSelectItem.value?.payOrgId);
      } else {
        bean = tempList[currentSelectItemIndex.value]; //银行卡
      }
      describe.value = bean?.describeinfo ?? "";
      getCurrentLimit();
    }
  }

  String getRechargeTypeIcon({required num payOrgId}) {
    Map<int, int> idMap = {183: 30, 184: 0, 200: 199, 204: 203};
    num iconId = idMap[payOrgId] ?? payOrgId;

    if ([9, 24, 33, 23].contains(payOrgId)) {
      return 'assets/theme1/images/recharge/icons/recharge_${iconId}${AppConfigs.lang == 'cn' ? '' : '_en'}.png';
    }

    return 'assets/theme1/images/recharge/icons/recharge_${iconId}.png';
  }

  reqPayoutsRates() async {
    animationController.forward(from: 0);
    String? rate = await LoginApi.reqPayoutsRates();
    if (rate != null && rate.isNotEmpty) {
      digitalCurrencyRate.value = num.parse(rate!);
    }
    animationController.stop();
  }

  RxNum digitalCurrencyRate = RxNum(0); //数字货币汇率
  Rxn<ThirdWalletBean> nopayBindBean = Rxn(); //nopay的数据类
  RxBool isNoPayBind = false.obs; //是否已经绑定noPay,默认false
  RxBool isLoadNoPayView = false.obs;
  reqNoPayStatus() async {
    if (noPayInfo == null) {
      return;
    }
    isLoadNoPayView.value = true;
    nopayBindBean.value = await LoginApi.reqUserBindStatus(
        payEngName: noPayInfo?.sourcetype ?? "");
    print("输出一下呢：${nopayBindBean.value?.isBind}");
    if (nopayBindBean != null) {
      isNoPayBind.value = nopayBindBean.value?.isBind == "1";
    }
    if (isNoPayBind.value) {
      await reqUserInfo();
    }
    isLoadNoPayView.value = false;
  }

  Future<String?> reqRegisterUrl(bool isBind) async {
    var thirdKey = nopayBindBean.value?.field?.bind?[0].key ?? "";

    var thirdValue = isBind ? "1" : "2";
    String? registerUrl = await LoginApi.reqRegisterAddress(
        payEngName: noPayInfo?.sourcetype ?? "",
        thirdData: {thirdKey: thirdValue});
    return registerUrl;
  }

  //////////////////////////////////////////////⬇️
  Rxn<WalletBean> walletBean = Rxn<WalletBean>();
//////////////////////////////////////////////⬆️

  Future<void> reqUserInfo({bool isRefresh = false}) async {
    if (isRefresh) {
      EasyLoading.show(indicator: CommonLoadingView());
      walletBean.value = await LoginApi.reqRechargeUserInfo(
          payEngName: noPayInfo?.sourcetype ?? "");
      EasyLoading.dismiss();
    } else {
      walletBean.value = await LoginApi.reqRechargeUserInfo(
          payEngName: noPayInfo?.sourcetype ?? "");
    }
    if (noPayInfo?.payOrgId == 308) {
      //只有308 nopay才需要额外判断
      isNoPayBind.value = walletBean.value?.walletBalance != -1; //只要不是-1,就绑定了
    }
  }

  Future<String?> getJumpUrl() async {
    String jumpUrl = await LoginApi.reqRechargeJumpAddress(
        payEngName: noPayInfo?.sourcetype ?? "");
    return jumpUrl;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      reqNoPayStatus();
    }
  }
}
