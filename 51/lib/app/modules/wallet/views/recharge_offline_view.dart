import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/controllers/recharge_controller.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/controllers/recharge_offline_controller.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/data/recharge_type_bean.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_common_container.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_info_copy_item.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_info_qrcode_item.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_ok_button_widget.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_quick_input_money_widget.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/wallet_image_upload_widget.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/wallet_input_field_widget.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import '../../../../utils/debounce_throttle.dart';
import '../widget/recharge_module_title_widget.dart';
import '../widget/wallet_input_field_widget2.dart';
import './recharge_protocol_widget.dart';

///线下的充值方式
// ignore: must_be_immutable
class RechargeOfflineView extends StatelessWidget {
  RechargeOfflineView({super.key});
  late RechargeController controller = Get.find();
  late RechargeOfflineController offlineController =
      Get.put(RechargeOfflineController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 协议
        RechargeCommonContainer(
          child: RechargeProtocolWidget(),
        ),
        SizedBox(height: 10.h),
        // 收款人信息
        RechargeCommonContainer(
          child: Obx(() => _buildReceiveInfo()),
        ),
        SizedBox(height: 10.h),
        Obx(() => _buildFormInfo()),
      ],
    );
  }

  /// 构建收款人信息
  Widget _buildReceiveInfo() {
    if (controller.offLineProtocolList.isEmpty) {
      return const SizedBox();
    }
    TenantPayInfo currentPay = controller
        .offLineProtocolList[controller.currentSelectProtocalIndex.value];
    int selectPayOrgId = controller.currentRechargePayOrgId.value;

    if (selectPayOrgId == 188) {
      return RechargeInfoQrcodeItem(
        usdtType: currentPay.usdtType ?? '',
        qrCodeAddr: currentPay.qrCodeAddr ?? '',
        payNo: currentPay.payNo ?? '',
      );
    }

    return Column(
      children: [
        RechargeInfoCopyItem(
            title: '收款机构', content: currentPay.payOrgNameReal ?? ''),
        RechargeInfoCopyItem(title: '收款账号', content: currentPay.payNo ?? ''),
        RechargeInfoCopyItem(title: '收款户名', content: currentPay.payName ?? ''),
        [1, 7, 8].contains(selectPayOrgId)
            ? RechargeInfoCopyItem(
                title: '开户支行', content: currentPay.accountOpening ?? '')
            : const SizedBox()
      ],
    );
  }

  /// 构建form信息
  Widget _buildFormInfo() {
    if (controller.offLineProtocolList.isEmpty) {
      return const SizedBox();
    }
    List<Widget> formList = [];
    int selectPayOrgId = controller.currentRechargePayOrgId.value;

    // 通道汇率
    num rate = controller
        .offLineProtocolList[controller.currentSelectProtocalIndex.value].rate!;
    num handFee = controller
        .offLineProtocolList[controller.currentSelectProtocalIndex.value]
        .handFee!;
    var protocalItem = controller
        .offLineProtocolList[controller.currentSelectProtocalIndex.value]
        .percentageList
        ?.firstOrNull;

    /// 188 的处理
    if (selectPayOrgId == 188) {
      if (offlineController.isUsdtVisible.value) {
        formList.add(
          WalletInputFieldWidget(
            title: '我的USDT地址',
            placeholder: '请输入我的USDT地址',
            required: offlineController.isUsdtRequired.value,
            onChanged: (value) => offlineController.setUsdtAddress(value),
          ),
        );
      }

      formList.add(
        WalletInputFieldWidget2(
          title: '充值数量',
          placeholder: '请输入充值数量',
          textInputType: const TextInputType.numberWithOptions(decimal: true),
          maxLength: 15,
          isOffline: true,
          readOnly: !controller.isCanEnter.value,
          displayType: DisplayType.virtual,
          required: offlineController.isUsdtRequired.value,
          currencyType: offlineController.currencyType.value,
          defaultContent: offlineController.rechargeAmount.value,
          onChanged: (value) =>
              offlineController.setRechargeAmount(value, rate: rate),
          typeChange: (value) {
            offlineController.currencyType.value = value;
          },
          child: Visibility(
              visible:
                  offlineController.currencyType.value == CurrencyType.crypto,
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  '当前汇率：1USDT≈${parseNumber(rate)}CNY',
                  style: TextStyle(
                    fontSize: 36.sp,
                    color: const Color(colorFE000E),
                  ),
                ),
              )),
        ),
      );
      if (offlineController.currencyType.value == CurrencyType.fiat) {
        String showStr1 = (1 / (rate ?? 0)).truncateToFixed(2);
        var showStr2 = (double.parse(
                    (offlineController.rechargeAmount.value.isEmpty
                        ? "0"
                        : offlineController.rechargeAmount.value)) *
                double.parse(showStr1))
            .truncateToFixed(2);
        formList.add(Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("当前汇率：￥1≈${showStr1}"),
                Visibility(
                    visible: offlineController.rechargeAmount.value.isNotEmpty,
                    child: Text("上分：${showStr2}")),
              ],
            ),
            SizedBox(height: 30.h)
          ],
        ));
      } else {
        formList.add(Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                      text: "实际到账",
                      style: TextStyle(
                          fontSize: 36.sp, color: const Color(color979797)),
                      children: [
                        TextSpan(
                          text:
                              " ￥ ${parseNumber(double.parse(offlineController.xnbRealAmount.value))}元",
                          style: const TextStyle(
                            color: Color(colorFE000E),
                          ),
                        )
                      ]),
                ),
              ],
            ),
            SizedBox(height: 30.h)
          ],
        ));
      }

      if (controller.quickMoneyList.isNotEmpty) {
        formList.add(
          RechargeQuickInputMoneyWidget(
            rechargeAmount: offlineController.rechargeAmount.value,
            onChanged: (value) =>
                offlineController.setRechargeAmount(value, rate: rate),
          ),
        );
      }

      if (offlineController.isCustPayNoVisible.value) {
        formList.add(
          WalletInputFieldWidget(
            title: 'TXID',
            placeholder: '请输入TXID',
            maxLength: 64,
            required: offlineController.isCustPayNoRequired.value,
            onChanged: (value) => offlineController.setCustPayNo(value),
          ),
        );
      }

      if (!isSpecialTenant(clustersId: 17, tid: 9)) {
        formList.add(
          WalletInputFieldWidget(
            title: '存款汇率',
            placeholder: '',
            defaultContent: controller.currencyRate.value.toString(),
            readOnly: true,
            required: false,
          ),
        );
      }

      formList.add(
        WalletInputFieldWidget(
          title: '充值金额',
          placeholder: controller.getRechargeAmountPlaceholder(),
          textInputType: const TextInputType.numberWithOptions(decimal: true),
          maxLength: 15,
          readOnly: true,
          required: offlineController.isUsdtRequired.value,
          defaultContent: offlineController.xnbRealAmount.value == ''
              ? '0'
              : parseNumber(
                  double.parse(offlineController.xnbRealAmount.value)),
        ),
      );

      /// 非188的处理
    } else {
      // 8: 微信转账 183:QQ 184: 云闪付
      if ([8, 183, 184].contains(selectPayOrgId)) {
        // 账号
        if (offlineController.isCustPayNameVisible.value) {
          String placeholder = '';
          if (selectPayOrgId == 8) {
            placeholder = '请输入微信号的名称';
          } else if (selectPayOrgId == 183) {
            placeholder = '请输入QQ账号';
          } else {
            placeholder = '请输入云闪付的账号';
          }

          formList.add(
            WalletInputFieldWidget(
              title: '付款人姓名',
              placeholder: placeholder,
              maxLength: 64,
              required: offlineController.isCustPayNameRequired.value,
              onChanged: (value) => offlineController.setCustPayName(value),
            ),
          );
        }

        // 订单号
        if (offlineController.isCustPayNoVisible.value) {
          formList.add(
            WalletInputFieldWidget(
              title: '订单后6位',
              placeholder: '请输入订单号后6位',
              maxLength: 6,
              required: offlineController.isCustPayNoRequired.value,
              onChanged: (value) => offlineController.setThirdOrderId(value),
            ),
          );
        }
      } else if ([7, 191, 192, 196, 198, 301, 303, 325, 327, 329]
          .contains(selectPayOrgId)) {
        // 账号
        if (offlineController.isCustPayNameVisible.value) {
          formList.add(
            WalletInputFieldWidget(
              title: '付款人姓名',
              placeholder: '请输入汇款人姓名',
              maxLength: 64,
              required: offlineController.isCustPayNameRequired.value,
              onChanged: (value) => offlineController.setCustPayName(value),
            ),
          );
        }

        // 订单号
        if (offlineController.isCustPayNoVisible.value) {
          formList.add(
            WalletInputFieldWidget(
              title: '订单后6位',
              placeholder: '请输入订单号后6位',
              maxLength: 6,
              required: offlineController.isCustPayNoRequired.value,
              onChanged: (value) => offlineController.setThirdOrderId(value),
            ),
          );
        }
      } else {
        // 银行卡 汇款银行名称
        if (offlineController.isCustOrgNameVisible.value &&
            selectPayOrgId != 311) {
          formList.add(
            WalletInputFieldWidget(
              title: '汇款银行名称',
              placeholder: '请输入汇款银行名称',
              maxLength: 64,
              required: offlineController.isCustOrgNameRequired.value,
              onChanged: (value) => offlineController.setCustOrgName(value),
            ),
          );
        }

        // 账号
        if (offlineController.isCustPayNameVisible.value) {
          formList.add(
            WalletInputFieldWidget(
              title: '汇款人姓名',
              placeholder: '请输入汇款人姓名',
              maxLength: 64,
              required: offlineController.isCustPayNameRequired.value,
              onChanged: (value) => offlineController.setCustPayName(value),
            ),
          );
        }

        // 订单号
        if (offlineController.isCustPayNoVisible.value) {
          formList.add(
            WalletInputFieldWidget(
              title: '汇款卡号后4位',
              placeholder: '请输入汇款卡号后4位',
              maxLength: 4,
              required: offlineController.isCustPayNoRequired.value,
              onChanged: (value) => offlineController.setThirdOrderId(value),
            ),
          );
        }
      }

      formList.add(
        WalletInputFieldWidget(
          title: '充值金额',
          placeholder: controller.getRechargeAmountPlaceholder(),
          textInputType: const TextInputType.numberWithOptions(decimal: true),
          maxLength: 15,
          readOnly: !controller.isCanEnter.value,
          required: offlineController.isUsdtRequired.value,
          currencyType: CurrencyType.fiat,
          defaultContent: controller.quickMoneyList.isNotEmpty
              ? offlineController.rechargeAmount.value
              : '',
          onChanged: (value) =>
              offlineController.setRechargeAmount(value, rate: rate),
        ),
      );

      if (controller.quickMoneyList.isNotEmpty) {
        formList.add(
          RechargeQuickInputMoneyWidget(
            rechargeAmount: offlineController.rechargeAmount.value,
            onChanged: (value) =>
                offlineController.setRechargeAmount(value, rate: rate),
          ),
        );
      }
    }

    // 实际到账
    if (handFee.toInt() != 0 && selectPayOrgId != 188) {
      formList.add(
        WalletInputFieldWidget(
          title: '实际到账',
          placeholder: '',
          defaultContent: offlineController.realAmount.value == ''
              ? '0'
              : parseNumber(double.parse(offlineController.realAmount.value)),
          readOnly: true,
          required: false,
        ),
      );
    }

    // 备注
    if (offlineController.isRemarkVisible.value) {
      formList.add(
        WalletInputFieldWidget(
          title: '备注',
          placeholder: '请输入备注',
          maxLength: 30,
          required: offlineController.isRemarkRequired.value,
          onChanged: (value) => offlineController.setRemark(value),
        ),
      );
    }

    // 支付截图
    if (offlineController.isHeadPortraitVisible.value) {
      formList.add(WalletImageUploadWidget(
        title: '支付截图',
        required: offlineController.isHeadPortraitRequired.value,
        imageUrl: offlineController.headPortrait.value,
        onChanged: (value) => offlineController.setHeadPortrait(value),
      ));
    }

    if (formList.isEmpty) {
      return const SizedBox();
    }
    if (protocalItem != null) {
      formList.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RechargeModuleTitleWidget(
            str: "优惠比例",
            fontSize: 45.sp,
          ),
          SizedBox(
            height: 20.h,
          ),
          Text("${protocalItem!.a}%")
        ],
      ));
    }
    formList.add(RechargeOkButtonWidget(
      text: '确认充值',
      isCanRecharge: offlineController.isCanRecharge.value,
      clickButton: () {
        AppManager.instance.tapVibrate();
        DebounceThrottle.debounce(offlineController.clickOfflineRecharge)();
      },
    ));

    return RechargeCommonContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...formList,
          SizedBox(height: 60.h),
        ],
      ),
    );
  }
}
