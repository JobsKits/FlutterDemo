import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:flutter_tiyu_app/api/system_api.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/data/recharge_account_item_bean.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/data/recharge_offline_config_bean.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/data/recharge_type_bean.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/recharge_tips_dialog.dart';
import '../widget/wallet_input_field_widget.dart';
import './recharge_controller.dart';

class RechargeOnlineController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late Rx<RechargeOfflineConfigBean> offlineConfig =
      RechargeOfflineConfigBean().obs;
  late RechargeController controller = Get.find();

  /// -----------------------------------------------------

  final RxList<RechargeAccountItemBean> accountList =
      <RechargeAccountItemBean>[].obs;

  /// -----------------------------------------------------
  RxString rechargeAmount = ''.obs; // 充值金额
  RxString realAmount = ''.obs; // 实际到账
  RxString xnbRealAmount = '0.00'.obs; // 虚拟币线下充值 是乘以渠道汇率 除以 地区汇率

  RxBool isCustOrgNameVisible = false.obs; // 汇款银行显示
  RxBool isCustOrgNameRequired = false.obs; // 汇款银行必填
  RxBool isRemarkVisible = false.obs; // 备注显示
  RxBool isRemarkRequired = false.obs; // 备注必填
  RxBool isCustPayNoVisible = false.obs; // 汇款卡号显示
  RxBool isCustPayNoRequired = false.obs; // 汇款卡号必填
  RxBool isCustPayNameVisible = false.obs; // 付款人姓名显示
  RxBool isCustPayNameRequired = false.obs; //付款人姓名必填
  RxBool isHeadPortraitVisible = false.obs; // 支付截图显示
  RxBool isHeadPortraitRequired = false.obs; // 支付截图必填
  RxBool isUsdtVisible = false.obs; // usdt显示
  RxBool isUsdtRequired = false.obs; // usdt必填
  /// -----------------------------------------------------
  RxString virtulPayUrl = ''.obs; // 虚拟币地址
  RxBool isShowVirtulPayUrl = false.obs; // 是否显示
  ///-----------------------------------------------------

  RxBool isCanRecharge = false.obs; // 是否能充值
  RxBool isCanSendThirdCode = false.obs; // 是否能充值
  RxBool isCanBind = false.obs; // 是否能绑定
  RxBool isLoadingRecharge = false.obs; // 是否点击充值
  RechargeController rechargeController = Get.find();
  Rx<CurrencyType> currencyType = CurrencyType.crypto.obs;

  @override
  void onInit() {
    super.onInit();

    // 使用 ever 来监听让二维码不显示
    ever(controller.currentRechargePayOrgId, (value) {
      isShowVirtulPayUrl.value = false;
    });

    _initAccountList();

    /// 请求线下充值配置
    _reqOffLineConfig();
  }

  // _clearData() {
  //   rechargeAmount.value = ''; // 充值金额
  //   realAmount.value = ''; // 实际到账
  //   xnbRealAmount.value = '0.00'; // 虚拟币线下充值 是乘以渠道汇率 除以 地区汇率
  // }

  // 设置账号列表， 主要是34 京东钱包
  void _initAccountList() {
    accountList.value = [
      RechargeAccountItemBean.fromJson({
        'label': '充值账号',
        'value': LoginManager.instance.loginInfo!.custName,
      }),
      RechargeAccountItemBean.fromJson({
        'label': '充值类型',
        'value': '线上充值',
      }),
      RechargeAccountItemBean.fromJson({
        'label': '充值方式',
        'value': '网上银行',
      }),
    ];
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> _reqOffLineConfig() async {
    final res = await LoginApi.reqOffineConfig();

    if (res.type == NetworkService.networkTypeSuccess) {
      offlineConfig.value = RechargeOfflineConfigBean.fromJson(res.data);

      String value = offlineConfig.value.value!;
      String value2 = offlineConfig.value.value2!;

      try {
        var isVisible = GameUtils.parseJson(value)['Comprehensive'];
        var isRequire = GameUtils.parseJson(value2)['Comprehensive'];

        if (isVisible != null && isVisible['M'] != null) {
          List<dynamic> visibleList = isVisible['M'] ?? [];

          isCustOrgNameVisible.value = visibleList[0] == 1;
          isRemarkVisible.value = visibleList[1] == 1;
          isCustPayNoVisible.value = visibleList[2] == 1;
          isCustPayNameVisible.value = visibleList[3] == 1;
          isHeadPortraitVisible.value = visibleList[4] == 1;
          isUsdtVisible.value = visibleList[5] == 1;
        }

        if (isRequire != null && isRequire['M'] != null) {
          List<dynamic> requireList = isRequire['M'] ?? [];

          isCustOrgNameRequired.value = requireList[0] == 1;
          isRemarkRequired.value = requireList[1] == 1;
          isCustPayNoRequired.value = requireList[2] == 1;
          isCustPayNameRequired.value = requireList[3] == 1;
          isHeadPortraitRequired.value = requireList[4] == 1;
          isUsdtRequired.value = requireList[5] == 1;
        }
      } catch (err) {
        // throw ArgumentError('value / value2 parse to json error.');
      }
    }
  }

  // 获取当前渠道项
  TenantPayMerchant getCurrentPay() {
    TenantPayMerchant currentPay = controller
        .merchatProtocolList[controller.currentSelectProtocalIndex.value];

    return currentPay;
  }

  // 设置充值金额
  setRechargeAmount(String str, {required num rate}) {
    rechargeAmount.value = str;

    xnbRealAmount.value = str == ''
        ? '0.00'
        : '${double.parse(str) + (double.parse(str) * rate)}';
    isCanClickRecharge();
  }

  void isCanClickRecharge() {
    if (controller
            .merchatProtocolList[controller.currentSelectProtocalIndex.value]
            .isEmbed ==
        "1") {
      //如果是内嵌钱包
      bool allValuesNotNull = false;
      if (controller.thirdParameters.isNotEmpty) {
        allValuesNotNull = controller.thirdParameters.values
            .every((value) => (value != null && value.isNotEmpty));
      } else {
        allValuesNotNull = true; //没有三方参数
      }
      isCanRecharge.value = (rechargeAmount.value != '' &&
              double.parse(rechargeAmount.value) > 0) &&
          allValuesNotNull;
    } else {
      isCanRecharge.value =
          rechargeAmount.value != '' && double.parse(rechargeAmount.value) > 0;
    }
  }

  void isCanSendThirdCodes() {
    if (controller.thirdParameters.isNotEmpty) {
      bool allValuesNotNull = false;
      if (controller.thirdParameters.containsKey("3rdSmsCode")) {
        Map<String, String> tempMap = Map.of(controller.thirdParameters);
        tempMap.remove("3rdSmsCode");
        allValuesNotNull = tempMap.values
            .every((value) => (value != null && value.isNotEmpty));
        print("执行这里？${allValuesNotNull}");
      } else {
        allValuesNotNull = controller.thirdParameters.values
            .every((value) => (value != null && value.isNotEmpty));
      }
      print("执行这里？${controller.thirdParameters}");
      isCanSendThirdCode.value = allValuesNotNull;
    }
  }

  void isCanBinds() {
    if (controller.thirdParameters.isNotEmpty) {
      bool allValuesNotNull = false;
      allValuesNotNull = controller.thirdParameters.values
          .every((value) => (value != null && value.isNotEmpty));
      isCanBind.value = allValuesNotNull;
    }
  }

  // 点击线上充值
  void clickOnlineRecharge() async {
    if (isLoadingRecharge.value) {
      return;
    }
    if (num.parse(rechargeAmount.value) >
        (controller.walletBean.value?.walletBalance ?? 0) / 1000) {
      if (controller
              .merchatProtocolList[controller.currentSelectProtocalIndex.value]
              .isEmbed ==
          "1") {
        String jumpUrl = await controller.getJumpUrl() ?? "";
        if (jumpUrl.isNotEmpty) {
          final Uri url = Uri.parse(jumpUrl);
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
        return;
      }
    }
    TenantPayMerchant? currentPay = controller.merchatProtocolList.isNotEmpty
        ? controller
            .merchatProtocolList[controller.currentSelectProtocalIndex.value]
        : null;

    // 通道汇率
    num rate = controller
        .merchatProtocolList[controller.currentSelectProtocalIndex.value].rate!;

    String limitMin = '';
    String limitMax = '';
    num quatoMin = currentPay?.quotaMin ?? 0;
    num quatoMax = currentPay?.quotaMax ?? 0;

    if (quatoMin != 0 && quatoMax != 0) {
      limitMin = parseNumber((quatoMin / 1000) * rate);
      limitMax = parseNumber((quatoMax / 1000) * rate);
    }

    int selectPayOrgId = controller.currentRechargePayOrgId.value;

    print(
        '=====> ${limitMin} ${limitMax} ${selectPayOrgId} ${rechargeAmount.value}');

    // 非虚拟币
    if (selectPayOrgId != 187 && limitMin.isNotEmpty && limitMax.isNotEmpty) {
      if (double.parse(rechargeAmount.value) < double.parse(limitMin) ||
          double.parse(rechargeAmount.value) > double.parse(limitMax)) {
        EasyLoading.showToast('金额在${limitMin}~${limitMax}之间');
        return;
      }
    }

    // // 非配置币种
    // if (rechargeGetWay[selectPayOrgId] != 1) {
    //   print('=====error ${selectPayOrgId}');
    //   // 二维码页面，但是H5的页面本身就有问题，暂时不做
    //   return;
    // }

    if ((currentPay?.popup_content ?? '').isNotEmpty) {
      Get.dialog(RechargeTipsDialog(
        rechargeBtnStr: currentPay?.popupTenantPayInfo?.channelCustomName ?? "",
        dialogContent: currentPay?.popup_content ?? "",
        normalRecharge: () {
          AppManager.instance.tapVibrate();
          Get.back();
          doRecharge();
        },
        customRecharge: () {
          AppManager.instance.tapVibrate();
          // for (var item in rechargeController.showRechargeTypeList) {
          //   print("item1:${item.payOrgId}");
          // }
          Get.back();
          int index = rechargeController.showRechargeTypeList.indexWhere(
              (item) =>
                  item.payOrgId == currentPay?.popupTenantPayInfo?.payOrgId);
          if (index > 8 && !rechargeController.isExpand.value) {
            //如果查到的index大于8 并且没有展开列表
            rechargeController.openOrExpandList(); //先进行列表展开
            rechargeController.changeRechargeTypeIndex(index); //再切换到对应的索引
            rechargeController.scrollTop();
          } else {
            //否则，直接切换
            rechargeController.changeRechargeTypeIndex(index);
          }
        },
      ));
    } else {
      doRecharge();
    }
  }

  void doRecharge() async {
    try {
      EasyLoading.show(indicator: const CommonLoadingView());
      isLoadingRecharge.value = true;

      TenantPayMerchant currentPay = getCurrentPay();
      int selectPayOrgId = controller.currentRechargePayOrgId.value;
      var protocalItem = controller
          .merchatProtocolList[controller.currentSelectProtocalIndex.value]
          .percentageList
          ?.firstOrNull;
      var isV = [187, 188]
          .contains(controller.currentRechargePayOrgId.value); //是否是虚拟币
      String amount = isV
          ? (currencyType.value == CurrencyType.crypto
              ? "${(num.parse(rechargeAmount.value) * num.parse(controller.digitalCurrencyRate.value.truncateToFixed(2))).truncateToFixed(2)}"
              : rechargeAmount.value)
          : rechargeAmount.value;
      var params = {
        'amount': amount,
        'payEngName': currentPay.sourcetype!,
        'bonus_amount_percentage': protocalItem != null
            ? '${protocalItem.a},${protocalItem.b}'
            : "", // 当前选择优惠
      };
      if (isV) {
        params['rate'] = "${controller.digitalCurrencyRate.value}";
      }
      //如果是内嵌钱包，并且参数不为空
      // if(controller
      //     .merchatProtocolList[controller.currentSelectProtocalIndex.value].isEmbed == "1" && controller.thirdParameters.isNotEmpty){
      //   controller.thirdParameters.forEach((key,value){
      //     params[key] = value;
      //   });
      // }
      // 跳转方式 0 默认 1内跳 2外跳
      bool isJumpToInside = currentPay.jumpMethod == 1;
      final res =
          await SystemApi.reqOnlineRecharge(params, controller.thirdParameters);
      if (res.type == NetworkService.networkTypeSuccess) {
        final data = res.data;
        print('yyyy===> ${data}');
        // EasyLoading.show(status: "${data['msg']}");
        // Future.delayed(Duration(milliseconds: 1000),(){
        //   EasyLoading.dismiss();
        // });

        if (data['code'] != 200 || data['data'] == null) {
          if (data['msg'] == "cryptoRateIsChange") {
            EasyLoading.showError("当前汇率已更新(${data['data']}),请刷新当前汇率重新提交!");
            return;
          }
          EasyLoading.showError(data['msg'] ?? '提交失败');
          return;
        }

        String payUrl = data['data']['pay_url'] ?? '';
        String payType = data['data']['pay_type'] ?? '';

        // 如果是虚拟货币这里获取的是虚拟货币的汇率与收款地址
        if (selectPayOrgId == 187) {
          if (data['code'] == 200) {
            // 如果pay_type === 1 则需要跳转第三方
            // if (payType == '1') {
            if (currentPay.payMode == 2) {
              // 跳转方式 0 默认 1内跳 2外跳
              isJumpToInside ? _jumpToInSide(payUrl) : _jumpToOutSide(payUrl);
            } else {
              virtulPayUrl.value = payUrl;

              if (payUrl.isNotEmpty) {
                isShowVirtulPayUrl.value = true;
              }
            }
          }
        } else {
          // 成功
          if (data['code'] == 200) {
            if (controller
                    .merchatProtocolList[
                        controller.currentSelectProtocalIndex.value]
                    .isEmbed ==
                "1") {
              controller.reqUserInfo(isRefresh: true);
            }
            Get.snackbar("充值成功", "${data['msg']}");

            // 跳转
            if (payUrl.isNotEmpty) {
              /// TODO: 支付宝，需要唤醒原生支付宝去支付（未做, 需要后期考虑）
              if (currentPay.payType == 33) {
                return;
              }

              // 跳转方式 0 默认 1内跳 2外跳
              isJumpToInside ? _jumpToInSide(payUrl) : _jumpToOutSide(payUrl);
            }
          } else if (data['code'] == 1000) {
            /// TODO: 解析 URL
            Uri uri = Uri.parse(data['url']); // 没有对应属性，需要后期看字段。。
            ///
          } else {
            var msg = data['msg'] ?? '提交失败';
            EasyLoading.showError(msg);
          }
        }
      }
    } finally {
      EasyLoading.dismiss();
      isLoadingRecharge.value = false;
    }
  }

  Future<void> _openUrl(String urls) async {
    String jumpUrl = urls.contains('http') ? urls : 'https://${urls}';
    final Uri url = Uri.parse(jumpUrl);
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  // 内部跳转
  Future<void> _jumpToInSide(String url) async {
    Get.toNamed(Routes.WEB_VIEW, arguments: {
      "url": url, //请求地址
      "title": "充值",
      "isShowTitle": true, //是否显示title
      "isShowRecharge": false,
    });
  }

  // 外部跳转
  Future<void> _jumpToOutSide(String url) async {
    _openUrl(url);
    // Get.defaultDialog(
    //   title: '充值提示',
    //   titleStyle: TextStyle(
    //     fontSize: 54.sp,
    //     fontWeight: FontWeight.bold,
    //   ),
    //   titlePadding: EdgeInsets.symmetric(vertical: 30.h),
    //   barrierDismissible: false,
    //   content: Center(
    //     child: Text(
    //       '即将进入支付页面，请确认！',
    //       style: TextStyle(
    //         fontSize: 52.sp,
    //         color: Colors.black,
    //         height: 3,
    //       ),
    //     ),
    //   ),
    //   radius: 40.r,
    //   contentPadding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 40.h),
    //   confirm: SizedBox(
    //     width: 315.w,
    //     height: 105.h,
    //     child: ElevatedButton(
    //         onPressed: () {
    //           Get.back();
    //           _openUrl(url);
    //         },
    //         style: ButtonStyle(
    //           shape: WidgetStatePropertyAll(
    //             RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(20.r),
    //             ),
    //           ),
    //           backgroundColor: const WidgetStatePropertyAll(
    //             Color(theme01MainColor),
    //           ),
    //         ),
    //         child: const Text(
    //           '确认',
    //           style: TextStyle(color: Color(colorFFFFFF)),
    //         )),
    //   ),
    //   cancel: SizedBox(
    //     width: 315.w,
    //     height: 105.h,
    //     child: OutlinedButton(
    //       onPressed: () {
    //         Get.back(); // 路由返回
    //       },
    //       style: ButtonStyle(
    //         side: const WidgetStatePropertyAll(
    //           BorderSide(color: Color(colorEEEEEE)),
    //         ),
    //         shape: WidgetStatePropertyAll(
    //           RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(20.r),
    //           ),
    //         ),
    //       ),
    //       child: const Text(
    //         '取消',
    //         style: TextStyle(color: Color(colorAAAAAA)),
    //       ),
    //     ),
    //   ),
    // );
  }

  Future<void> sendThirdCode(Function callback) async {
    NetworkResponse res = await LoginApi.sendThirdCode(
        payEngName: controller
                .merchatProtocolList[
                    controller.currentSelectProtocalIndex.value]
                .sourcetype ??
            "",
        phone: controller.thirdParameters["3rdPhone"] ?? "");
    if (res.type == NetworkService.networkTypeSuccess) {
      callback();
    }
  }
}
