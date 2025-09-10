import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/api/system_api.dart';
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
import 'package:get/get.dart';
import '../../../../gen/assets.gen.dart';
import '../../user/widget/change_phone_dialog.dart';
import '../data/withdraw_method_bean.dart';
import '../data/withdraw_type_bean.dart';
import '../data/withdraw_type_new_bean.dart';
import '../widget/recharge_ok_button_widget.dart';
import '../widget/recharge_tips_dialog.dart';
import '../widget/wallet_input_field_widget.dart';

class WithdrawalController extends GetxController
    with GetTickerProviderStateMixin {
  final RxList<WithdrawMethodBean> showWithrawMethodList =
      <WithdrawMethodBean>[].obs; // 提现方式
  final RxInt currentWithdrawTypeIndex = 0.obs; //当前选中的充值类型
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
  Rx<WithdrawBindCardItemBean?> defaultWithdrawAccount =
      Rx<WithdrawBindCardItemBean?>(null); // 定义默认提现账户
  // ------------------------------------------------

  RxString rate = ''.obs; // 汇率
  RxString currency = ''.obs; // 币种
  RxInt withdrawType = 0.obs; // 提现模式 1: 固定金额 2: 百分比
  RxString withdrawFee = ''.obs; // 提现手续费

  RxDouble limitMin = 1.0.obs; // 最小限额
  RxDouble limitMax = 10e8.obs; // 最大限额

  RxString withdrawAmount = ''.obs; // 提现金额
  RxString realWithdrawAmount = ''.obs; // 真实到账金额
  RxString acctPwd = ''.obs; // 资金密码

  RxBool isClickWithdraw = false.obs;
  Worker? loginListener;

  late TabController tabController;
  RxInt currentTabIndex = 0.obs; //当前选中的tab
  late WithdrawTypeNewBean currentWithdrawType;
  late ScrollController withdrawScrollController;
  RxList<WithdrawTypeTabBean> tabList = <WithdrawTypeTabBean>[].obs;

  bool isBand = false; //其他页面错误跳转的标识，禁用绑定手机号逻辑
  late CertificationInfoBean data; //保存认证信息
  @override
  void onInit() async {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    isBand = arguments['isBand'] ?? false;
    withdrawScrollController = ScrollController();
    tabController = TabController(length: 0, vsync: this);
    animationController = AnimationController(
      duration: const Duration(seconds: 1), // 动画持续时间
      vsync: this,
    )..repeat(); // 循环动画

    initData();

    // 使用 ever 方法监听 登录状态，状态发生改变， 请求余额数据
    loginListener = ever(LoginManager.instance.isLogin, (value) {
      initData();
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    animationController.dispose(); // 先释放 AnimationController
    // 取消监听，避免销毁后仍然触发
    loginListener?.dispose();
    super.onClose(); // 然后调用父类的 dispose 方法
  }

  /// 恢复默认值
  _reset() {
    showWithrawMethodList.clear(); // 清空显示的充值列表
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

  // 提现限制
  Future<void> reqWithdrawLimint() async {
    final res = await SystemApi.reqWithdrawLimint();

    if (res.type == NetworkService.networkTypeSuccess) {
      final data = WithdrawLimitConfigBean.fromJson(res.data);

      final withdrawMinAmount =
          data.withdrawMinAmount ?? data.withdrawMinAmountAli;
      final withdrawAmount = data.withdrawAmount ?? data.withdrawAmountAli;

      limitMin.value = double.parse(withdrawMinAmount as String) / 1000;
      limitMax.value = double.parse(withdrawAmount as String) / 1000;

      try {
        final feeList = json.decode(data.listFeel!);

        if (feeList is List) {
          Map<String, dynamic>? feeMap = feeList[0];

          if (feeMap != null) {
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
        _updateCurrentBindCardList(0);
      }
    } finally {
      isReqWithdrawAccountFinish.value = true;
    }
  }

  // 获取提现认证
  Future<void> reqCertificationInfo() async {
    final res = await SystemApi.reqCertificationInfo();
    if (res.type == NetworkService.networkTypeSuccess) {
      data = CertificationInfoBean.fromJson(res.data);
      // rz2_state 0都没认证，2已认证，3待审核，4审核拒绝需要重新认证
      // withdraw_attestation: '0', // 是否开启认证 0否 1是
      int withdrawAttestation = int.parse(data.withdrawAttestation!);
      int certStatus = int.parse(data.rz2State == '' ? '-1' : data.rz2State!);
      // 开启了认证 且 未认证
      if (withdrawAttestation == 1 && certStatus != 2) {
        comfirmDialog(
          title: '提示',
          content: certStatus == 3 ? '身份认证审核中，请耐心等待' : '请完成身份认证',
          confirmText: '去认证',
          onConfirm: () {
            Get.back(); // 关闭弹窗
            Get.offNamed(Routes.USER_INFO); // 身份认证，暂时无页面
          },
        );
      } else {
        // 用户钱包地址
        reqBindBankList();
      }
    }
  }

  /// 获取提现方式
  Future<void> reqDefaultBankCard() async {
    final res = await SystemApi.reqDefaultBankCard2();
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data is List) {
        tabList.clear();
        for (var item in res.data) {
          tabList.add(WithdrawTypeTabBean.fromJson(item));
        }
        if (tabList.isNotEmpty) {
          tabController.dispose();
          tabController = TabController(length: tabList.length, vsync: this);
        }
      }
      refreshWithdrawTypeList();

      // 初始化账户数据
      _updateCurrentBindCardList(currentWithdrawTypeIndex.value);
    }
  }

  void refreshWithdrawTypeList() {
    showWithrawMethodList.clear();

    List<WithdrawMethodBean> currentWithrawMethodList = [];

    List<WithdrawTypeNewBean> dataList =
        tabList[currentTabIndex.value].data ?? [];

    for (var item in dataList) {
      currentWithrawMethodList.add(
        WithdrawMethodBean(
          label: item.payOrgName ?? "",
          value: item.payInfo?[0].cut ?? 0,
          payType: item.payOrgId ?? 0,
          add: "",
          key: "",
          icon:
              'assets/theme1/images/withdraw/icons/ico_cut_${item.payInfo?[0].cut ?? 0}.png',
        ),
      );
    }

    showWithrawMethodList.value = currentWithrawMethodList;
    isShowMore.value = currentWithrawMethodList.length > 9;

    if (showWithrawMethodList.isNotEmpty) {
      //首次请求成功的时候，切换到0
      changeWithdrawTypeIndex(0);
    }
    // showWithrawMethodList.value = currentWithrawMethodList;
    // isShowMore.value = currentWithrawMethodList.length > 9;
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

  //切换选中的充值类型的index
  void changeWithdrawTypeIndex(int index) {
    currentWithdrawTypeIndex.value = index;
    _updateCurrentBindCardList(index);
  }

  // 更新当前绑定卡列表
  void _updateCurrentBindCardList(int index) {
    if (showWithrawMethodList.isEmpty) {
      return;
    }

    final WithdrawMethodBean currentMethod = showWithrawMethodList[index];
    // 提现账户数据不为空
    if (withdrawAccountList.isNotEmpty) {
      // 银行卡
      if (currentMethod.payType == 0) {
        List<WithdrawBindCardItemBean> filterAccountList =
            withdrawAccountList.where((element) {
          if (element.payOrgId == 0) {
            return true;
          }
          return !notBankList.contains(element.payOrgId);
        }).toList();

        currentWithdrawAccountList.value = filterAccountList;
      } else {
        /// 其他卡号
        List<WithdrawBindCardItemBean> filterAccountList = withdrawAccountList
            .where((element) => element.payOrgId == currentMethod.payType)
            .toList();
        print("有数据吗222222：${filterAccountList.length}");
        currentWithdrawAccountList.value = filterAccountList;
      }

      // 有数据
      if (currentWithdrawAccountList.isNotEmpty) {
        // 返回默认的那一个
        var matches =
            currentWithdrawAccountList.where((element) => element.sortV == 1);
        // 设置当前默认账户
        defaultWithdrawAccount.value =
            matches.isNotEmpty ? matches.first : currentWithdrawAccountList[0];
      } else {
        // 清空
        defaultWithdrawAccount.value = null;
      }
    }
  }

  // 修改当前默认的提现账户
  void updateDefaultWithdrawAccount(WithdrawBindCardItemBean account) {
    defaultWithdrawAccount.value = account;
  }

  /// 获取当前提现项目
  WithdrawMethodBean? getWithdrawItem() {
    if (showWithrawMethodList.isEmpty) {
      return null;
    }
    return showWithrawMethodList[currentWithdrawTypeIndex.value];
  }

  //收起或者展开列表
  void openOrExpandList() {
    isExpand.value = !isExpand.value;
  }

  void showAllList() {
    //
  }

  // 修改提现金额
  void setWithdrawAmount(String value) {
    withdrawAmount.value = value;

    // 没有提现金额
    if (value == '' || value == '0') {
      realWithdrawAmount.value = '0';
    } else {
      if (withdrawType.value == 1) {
        double diff = double.parse(value) - double.parse(withdrawFee.value);
        realWithdrawAmount.value = diff.truncateToFixed(3);
      }

      if (withdrawType.value == 2) {
        double diff =
            (double.parse(value) * double.parse(withdrawFee.value)) / 100;

        realWithdrawAmount.value =
            (double.parse(value) - diff).truncateToFixed(3);
      }
    }
  }

  // 修改资金密码
  void setAcctPwd(String str) {
    acctPwd.value = str;
  }

  // 提现手续费文本
  String getWithdrawFeeStr() {
    // 固定金额
    if (withdrawType.value == 1) {
      return '￥${double.parse(withdrawFee.value).truncateToFixed(2)}';
    }

    // 百分比
    if (withdrawType.value == 2) {
      return '${double.parse(withdrawFee.value).truncateToFixed(2)}%';
    }

    return '0.00';
  }

  String getWithdrawRealStr() {
    if (realWithdrawAmount.value == '0') {
      return '0.00';
    }

    WithdrawMethodBean? withdrawItem = getWithdrawItem();
    return "${realWithdrawAmount.value}${withdrawItem!.value == 2 ? 'USDT' : currency.value}";
  }

  bool validWithdraw() {
    WithdrawMethodBean withdrawItem =
        showWithrawMethodList[currentWithdrawTypeIndex.value];

    if (double.parse(realWithdrawAmount.value) < limitMin.value) {
      EasyLoading.showToast('提现金额不可小于${parseNumber(limitMin.value)}');
      return false;
    }

    if (double.parse(realWithdrawAmount.value) > limitMax.value) {
      EasyLoading.showToast('提现金额不可大于${parseNumber(limitMax.value)}');
      return false;
    }

    if (withdrawItem.payType < 0) {
      EasyLoading.showToast('未绑定货币信息');
      return false;
    }

    // 未绑定提现钱包
    if (defaultWithdrawAccount.value == null) {
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
        'pay_org_id': defaultWithdrawAccount.value!.payOrgId,
        'pay_no': defaultWithdrawAccount.value!.payNo,
        'pay_org_name': defaultWithdrawAccount.value!.payOrgName,
        'pay_info_id': defaultWithdrawAccount.value!.payInfoId,
        'pay_name': defaultWithdrawAccount.value!.payName,
      };

      final res = await SystemApi.reqWithdraw(data);

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

  void changeTabIndex(int index) {
    currentTabIndex.value = index;
    refreshWithdrawTypeList();
  }

  void scrollTop() {
    withdrawScrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  //检测是否绑定了手机号
  void checkIsBandPhone() {
    if (int.parse(data.isBindingPhone ?? "0") == 0 && isBand) {
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

  void test() {
    if (int.parse(data.isBindingPhone ?? "0") == 0 && isBand) {
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
    } else {
      var currentTab = tabList[currentTabIndex.value].data ?? [];
      var bean = currentTab[currentWithdrawTypeIndex.value];

      if (validWithdraw()) {
        //先进行是否能提现的判断
        //通过判断能提现后，判断是否有推荐提现渠道
        //如果有推荐提现渠道，弹窗
        if (bean.popupContent != null && bean.popupContent!.isNotEmpty) {
          Get.dialog(RechargeTipsDialog(
            rechargeBtnStr: bean.popupWithdrawalInfo?.payOrgName ?? "",
            dialogContent: bean?.popupContent ?? "",
            normalRecharge: () {
              AppManager.instance.tapVibrate();
              Get.back();
              showConfirmPop();
            },
            customRecharge: () {
              AppManager.instance.tapVibrate();
              Get.back();
              int index = showWithrawMethodList.indexWhere((item) =>
                  item.payType == bean?.popupWithdrawalInfo?.payOrgId);
              changeWithdrawTypeIndex(index);
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
    Get.bottomSheet(
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.r), topRight: Radius.circular(50.r)),
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
                                  text: getWithdrawFeeStr(),
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
                                  text: getWithdrawRealStr(),
                                  style: const TextStyle(
                                      color: Color(colorFE6D02)))
                            ])),
                        SizedBox(
                          height: 100.h,
                        ),
                        WalletInputFieldWidget(
                          title: '交易密码',
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
                      child: GestureDetector(
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
}
