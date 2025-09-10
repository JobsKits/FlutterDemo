// ignore_for_file: non_constant_identifier_names

import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'dart:ffi';
import 'package:flutter_tiyu_app/api/login_api.dart';
// import 'package:flutter/material.dart';

import 'package:flutter_tiyu_app/app/modules/wallet/controllers/recharge_controller.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/data/recharge_offline_config_bean.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../api/system_api.dart';
import '../data/recharge_type_bean.dart';
import '../widget/recharge_tips_dialog.dart';
import '../widget/wallet_input_field_widget.dart';

class RechargeOfflineController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late Rx<RechargeOfflineConfigBean> offlineConfig =
      RechargeOfflineConfigBean().obs;

  late RechargeController controller = Get.find();

  /// -----------------------------------------------------
  RxString rechargeAmount = ''.obs; // 充值金额
  RxString realAmount = ''.obs; // 实际到账
  RxString xnbRealAmount = '0.00'.obs; // 虚拟币线下充值 是乘以渠道汇率 除以 地区汇率

  RxString cust_org_name = ''.obs; // 银行卡 汇款银行名称
  RxString remark = ''.obs; // 备注
  RxString cust_pay_no = ''.obs; // 地址或者id
  RxString cust_pay_name = ''.obs; // 汇款使用的户名
  RxString headPortrait = ''.obs; // 支付截图
  RxString usdt_address = ''.obs; // usdt地址
  RxString third_order_id = ''.obs; // qq 微信 闪付的ID

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
  ///
  RxBool isCanRecharge = false.obs; // 是否能充值
  RxBool isLoadingRecharge = false.obs; // 是否点击充值
  RechargeController rechargeController = Get.find();
  Rx<CurrencyType> currencyType = CurrencyType.crypto.obs;

  @override
  void onInit() {
    super.onInit();

    /// 请求线下充值配置
    _reqOffLineConfig();
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
        throw ArgumentError('value / value2 parse to json error.${err}');
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  _clearData() {
    rechargeAmount.value = ''; // 充值金额
    realAmount.value = ''; // 实际到账
    xnbRealAmount.value = '0.00'; // 虚拟币线下充值 是乘以渠道汇率 除以 地区汇率
    cust_org_name.value = ''; // 银行卡 汇款银行名称
    remark.value = ''; // 备注
    cust_pay_no.value = ''; // 地址或者id
    cust_pay_name.value = ''; // 汇款使用的户名
    headPortrait.value = ''; // 支付截图
    usdt_address.value = ''; // usdt地址
    third_order_id.value = ''; // qq 微信 闪付的ID

    isCanRecharge.value = _isCanRechargeValid();
  }

  // 设置usdt地址
  setUsdtAddress(String str) {
    usdt_address.value = str;

    isCanRecharge.value = _isCanRechargeValid();
  }

  // 设置充值金额
  setRechargeAmount(String str, {required num rate}) {
    rechargeAmount.value = str;

    xnbRealAmount.value = str == '' ? '0.00' : '${double.parse(str) * rate}';
    isCanRecharge.value = _isCanRechargeValid();
  }

  // 地址或者id
  setCustPayNo(String str) {
    cust_pay_no.value = str;
    isCanRecharge.value = _isCanRechargeValid();
  }

  // 汇款使用的户名
  setCustPayName(String str) {
    cust_pay_name.value = str;
    isCanRecharge.value = _isCanRechargeValid();
  }

  // 订单号后6位
  setThirdOrderId(String str) {
    third_order_id.value = str;
    isCanRecharge.value = _isCanRechargeValid();
  }

  // 银行卡号
  setCustOrgName(String str) {
    cust_org_name.value = str;
    isCanRecharge.value = _isCanRechargeValid();
  }

  // 备注
  setRemark(String str) {
    remark.value = str;
    isCanRecharge.value = _isCanRechargeValid();
  }

  // 支付图片
  setHeadPortrait(String str) {
    headPortrait.value = str;
    isCanRecharge.value = _isCanRechargeValid();
  }

  _showErrorTip({
    required bool isTip,
    required String msg,
  }) {
    if (isTip) {
      EasyLoading.showError(msg);
    }
  }

  // 验证是否能充值
  _isCanRechargeValid({bool isTip = false}) {
    int selectPayOrgId = controller.currentRechargePayOrgId.value;
    // 充值金额
    if (rechargeAmount.value.trim() == '') {
      _showErrorTip(
        isTip: isTip,
        msg: selectPayOrgId == 188 ? '请输入充值数量' : '请输入金额',
      );
      return false;
    }

    if (selectPayOrgId == 188) {
      /// USDT地址
      if (isUsdtVisible.value &&
          isUsdtRequired.value &&
          usdt_address.value.trim() == '') {
        _showErrorTip(
          isTip: isTip,
          msg: '请输入我的USDT地址',
        );
        return false;
      }

      /// TXID
      if (isCustPayNoVisible.value &&
          isCustPayNoRequired.value &&
          cust_pay_no.value.trim() == '') {
        _showErrorTip(
          isTip: isTip,
          msg: '请输入TXID',
        );
        return false;
      }
    } else {
      /// 汇款银行名称
      if (![7, 191, 192, 196, 198, 301, 303, 311, 325, 327, 329, 8, 183, 184]
          .contains(selectPayOrgId)) {
        if (isCustOrgNameVisible.value &&
            isCustOrgNameRequired.value &&
            cust_org_name.value.trim() == '') {
          _showErrorTip(
            isTip: isTip,
            msg: '请输入汇款银行名称',
          );
          return;
        }
      }

      /// 订单号
      if (isCustPayNoVisible.value &&
          isCustPayNoRequired.value &&
          third_order_id.value.trim() == '') {
        _showErrorTip(
          isTip: isTip,
          msg: '请输入订单号',
        );
        return false;
      }
    }

    ///付款人姓名
    if (isCustPayNameVisible.value &&
        isCustPayNameRequired.value &&
        cust_pay_name.value.trim() == '') {
      _showErrorTip(
        isTip: isTip,
        msg: '请输入付款人姓名',
      );
      return false;
    }

    /// 备注
    if (isRemarkVisible.value &&
        isRemarkRequired.value &&
        remark.value.trim() == '') {
      _showErrorTip(
        isTip: isTip,
        msg: '请输入备注',
      );
      return false;
    }

    /// 支付截图
    if (isHeadPortraitVisible.value &&
        isHeadPortraitRequired.value &&
        headPortrait.value.trim() == '') {
      _showErrorTip(
        isTip: isTip,
        msg: '请上传支付截图',
      );
      return false;
    }

    return true;
  }

  Future<void> clickOfflineRecharge() async {
    if (isLoadingRecharge.value) {
      return;
    }
    TenantPayInfo currentPay = controller
        .offLineProtocolList[controller.currentSelectProtocalIndex.value];
    if (currentPay?.popup_content != null &&
        currentPay!.popup_content!.isNotEmpty) {
      Get.dialog(RechargeTipsDialog(
        rechargeBtnStr: currentPay?.popupTenantPayInfo?.payOrgName ?? "",
        dialogContent: currentPay?.popup_content ?? "",
        normalRecharge: () {
          AppManager.instance.tapVibrate();
          Get.back();
          doRecharge(currentPay);
        },
        customRecharge: () {
          AppManager.instance.tapVibrate();
          // for (var item in rechargeController.showRechargeTypeList) {
          //   print("item1:${item.payOrgId}");
          // }
          Get.back();
          int index = rechargeController.showRechargeTypeList.indexWhere(
              (item) =>
                  item.payOrgId == currentPay.popupTenantPayInfo?.payOrgId);
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
      doRecharge(currentPay);
    }
  }

  void doRecharge(TenantPayInfo currentPay) async {
    // 验证
    if (_isCanRechargeValid(isTip: true)) {
      try {
        isLoadingRecharge.value = true;
        EasyLoading.show(indicator: const CommonLoadingView());
        bool is188 = controller.currentRechargePayOrgId.value == 188;
        var protocalItem = controller
            .offLineProtocolList[controller.currentSelectProtocalIndex.value]
            .percentageList
            ?.firstOrNull;
        Map<String, dynamic> data = {
          // 通道相关
          'tenant_pay_id': currentPay.tenantPayId,
          'pay_org_id': currentPay.payOrgId,
          'pay_org_name': currentPay.payOrgName,
          'pay_name': currentPay.payName,
          'pay_no': currentPay.payNo,
          // 数据相关
          'usdt_address': usdt_address.value,
          'cust_org_name': cust_org_name.value,
          'cust_pay_name': cust_pay_name.value,
          'cust_pay_no': cust_pay_no.value,
          'numbers': is188 ? rechargeAmount.value : null,
          'rate': is188 ? currentPay.rate : null,
          'third_order_id': third_order_id.value,
          'remark': remark.value,
          'headPortrait': headPortrait.value,
          'amount': double.parse(rechargeAmount.value) * 1000,
          'bonus_amount_percentage': protocalItem != null
              ? '${protocalItem.a},${protocalItem.b}'
              : "", // 当前选择优惠
        };
        final res = await SystemApi.reqOfflineRecharge(data);

        if (res.type == NetworkService.networkTypeSuccess) {
          // 临时使用这个
          EasyLoading.showSuccess(
            '充值提交成功 \n 请耐心等待，客服即将为您审核充值。',
            duration: const Duration(seconds: 3),
            dismissOnTap: false,
          );

          _clearData(); // 清理数据
        }
      } finally {
        EasyLoading.dismiss();
        isLoadingRecharge.value = false;
      }
    }
  }
}
