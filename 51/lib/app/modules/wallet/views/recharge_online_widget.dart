import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/data/recharge_type_bean.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/controllers/recharge_controller.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/controllers/recharge_online_controller.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_common_container.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/wallet_input_field_widget.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_ok_button_widget.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_quick_input_money_widget.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../theme/theme.service.dart';
import '../../../../utils/CommonRipple.dart';
import '../data/Third_wallet_bean.dart';
import '../widget/wallet_input_field_widget2.dart';
import './recharge_protocol_widget.dart';
import './recharge_online_manual_widget.dart';
import '../widget/recharge_info_qrcode_item.dart';

/// 线上充值（ 不考虑原始代码的 撮合充值逻辑）
// ignore: must_be_immutable
class RechargeOnlineWidget extends StatelessWidget {
  RechargeOnlineWidget({super.key});
  late RechargeController controller = Get.find();

  late RechargeOnlineController onlineController =
      Get.put(RechargeOnlineController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWiget(context));
  }

// 构建组件
  Widget _buildWiget(BuildContext context) {
    /// 人工充值 (做假数据 PAYTM pay)
    if ([197].contains(controller.currentRechargePayOrgId.value)) {
      return RechargeCommonContainer(
        child: RechargeOnlineManualWidget(),
      );
    }

    if (controller.currentRechargePayOrgId.value == 34) {
      return Column(
        children: [
          // 协议
          RechargeCommonContainer(
            child: RechargeProtocolWidget(),
          ),
          SizedBox(height: 10.h),
          _buildAccountInfo(),
          SizedBox(height: 10.h),
          RechargeCommonContainer(
            child: Obx(() => _buildFormInfo(context)),
          ),
        ],
      );
    }

    return RechargeCommonContainer(
      isMarginTop: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: onlineController.isShowVirtulPayUrl.value,
            child: RechargeInfoQrcodeItem(
              usdtType: '',
              qrCodeAddr: onlineController.virtulPayUrl.value,
              payNo: onlineController.virtulPayUrl.value,
              isChannel: true,
            ),
          ),
          Visibility(
            visible: onlineController.isShowVirtulPayUrl.value,
            child: SizedBox(height: 30.h),
          ),
          RechargeProtocolWidget(), // ?
          Visibility(
              visible: !(controller.isBindWallet.value == false &&
                  (controller.merchatProtocolList.isNotEmpty) &&
                  (controller
                          .merchatProtocolList[
                              controller.currentSelectProtocalIndex.value]
                          .isEmbed ==
                      "1")),
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  Obx(() => _buildFormInfo(context)),
                ],
              ))
        ],
      ),
    );
  }

  // 京东特殊处理
  Widget _buildAccountInfo() {
    var list = onlineController.accountList;
    return RechargeCommonContainer(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            padding: EdgeInsets.only(
              top: index != 0 ? 30.h : 0,
              bottom: index != list.length - 1 ? 30.h : 0,
            ),
            decoration: (index != list.length - 1)
                ? const BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: Colors.grey, width: 0.2), // 添加下划线
                    ),
                  )
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  list[index].label!,
                  style: TextStyle(
                      fontSize: 42.sp, color: const Color(color3B3B3B)),
                ),
                Text(
                  list[index].value!,
                  style: TextStyle(
                      fontSize: 42.sp, color: const Color(colorFE000E)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 表单
  Widget _buildFormInfo(BuildContext context) {
    List<Widget> formList = [];
    int selectPayOrgId = controller.currentRechargePayOrgId.value;
    // 通道汇率
    num rate = controller
            .merchatProtocolList[controller.currentSelectProtocalIndex.value]
            .rate ??
        0;
    var protocalItem = controller
        .merchatProtocolList[controller.currentSelectProtocalIndex.value]
        .percentageList
        ?.firstOrNull;
    if (controller.currentRechargeMarkType.value == RechargeMarkType.offline) {
      rate = num.parse((controller
                  .offLineProtocolList[
                      controller.currentSelectProtocalIndex.value]
                  .maxPercentage ??
              "0")) /
          100;
    } else {
      rate = num.parse((controller
                  .merchatProtocolList[
                      controller.currentSelectProtocalIndex.value]
                  .maxPercentage ??
              "0")) /
          100;
    }
    TenantPayMerchant currentPay = onlineController.getCurrentPay();
    bool isVirtual = [188, 187].contains(selectPayOrgId);
    // String label = isVirtual ? '虚拟币数量' : '充值金额';
    String label = isVirtual
        ? (onlineController.currencyType.value == CurrencyType.fiat
            ? '上分数量'
            : '充值金额')
        : '充值金额';
    if (isVirtual) {
      formList.add(WalletInputFieldWidget2(
        title: label,
        placeholder: controller.getRechargeAmountPlaceholder(),
        textInputType: const TextInputType.numberWithOptions(decimal: true),
        maxLength: 15,
        readOnly: !controller.isCanEnter.value,
        displayType: isVirtual ? DisplayType.virtual : DisplayType.none,
        currencyType: onlineController.currencyType.value,
        defaultContent: onlineController.rechargeAmount.value,
        onChanged: (value) => onlineController.setRechargeAmount(value,
            rate: controller.digitalCurrencyRate.value),
        typeChange: (value) {
          onlineController.currencyType.value = value;
          controller.currencyType.value = value;
        },
      ));
    } else {
      formList.add(WalletInputFieldWidget(
        title: label,
        placeholder: controller.getRechargeAmountPlaceholder(),
        textInputType: const TextInputType.numberWithOptions(decimal: true),
        maxLength: 15,
        readOnly: !controller.isCanEnter.value,
        displayType: isVirtual ? DisplayType.virtual : DisplayType.none,
        currencyType: isVirtual ? CurrencyType.crypto : CurrencyType.fiat,
        defaultContent: onlineController.rechargeAmount.value,
        onChanged: (value) =>
            onlineController.setRechargeAmount(value, rate: rate),
        child: isVirtual
            ? Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  '当前汇率：1USDT≈${parseNumber(currentPay.rate)}CNY',
                  style: TextStyle(
                    fontSize: 36.sp,
                    color: const Color(colorFE000E),
                  ),
                ),
              )
            : null,
      ));
    }

    if (isVirtual &&
        onlineController.currencyType.value == CurrencyType.crypto) {
      var showStr3 = controller.digitalCurrencyRate.value.truncateToFixed(2);
      var showStr2 = (double.parse(
                  (onlineController.rechargeAmount.value.isEmpty
                      ? "0"
                      : onlineController.rechargeAmount.value)) *
              double.parse(showStr3))
          .truncateToFixed(2);
      formList.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('当前汇率：1U≈${showStr3}CNY',
                      style: TextStyle(
                          fontSize: 33.sp, color: Color(color979797))),
                  CommonRipple(
                    onTap: () async {
                      AppManager.instance.tapVibrate();
                      controller.reqRates();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: AnimatedBuilder(
                        animation: controller.animationController,
                        child: SvgPicture.asset(
                          Assets.theme1.images.user.iconRefresh,
                          width: 40.w,
                          colorFilter:
                              ColorFilter.mode(Colors.black54, BlendMode.srcIn),
                        ),
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: controller.animationController.value *
                                2.0 *
                                pi, // 旋转角度
                            child: child,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: onlineController.rechargeAmount.value.isNotEmpty,
                  child: Text(
                    "上分≈${showStr2} CNY",
                    style: TextStyle(fontSize: 36.sp, color: Colors.red),
                  )),
            ],
          ),
          SizedBox(height: 30.h)
        ],
      ));
    } else if (isVirtual &&
        onlineController.currencyType.value == CurrencyType.fiat) {
      String showStr1 =
          (1 / controller.digitalCurrencyRate.value).truncateToFixed(2);
      var showStr2 = (double.parse(
                  (onlineController.rechargeAmount.value.isEmpty
                      ? "0"
                      : onlineController.rechargeAmount.value)) *
              double.parse(showStr1))
          .truncateToFixed(2);
      formList.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '当前汇率：￥1≈${showStr1}USDT',
                    style:
                        TextStyle(fontSize: 33.sp, color: Color(color979797)),
                  ),
                  CommonRipple(
                    onTap: () async {
                      AppManager.instance.tapVibrate();
                      controller.reqRates();
                    },
                    child: Padding(
                        padding: EdgeInsets.all(10.w),
                        child: AnimatedBuilder(
                          animation: controller.animationController,
                          child: SvgPicture.asset(
                            Assets.theme1.images.user.iconRefresh,
                            width: 40.w,
                            colorFilter: ColorFilter.mode(
                                Colors.black54, BlendMode.srcIn),
                          ),
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: controller.animationController.value *
                                  2.0 *
                                  pi, // 旋转角度
                              child: child,
                            );
                          },
                        )),
                  ),
                ],
              ),
              Visibility(
                  visible: onlineController.rechargeAmount.value.isNotEmpty,
                  child: Text(
                    "充值≈${showStr2} USDT",
                    style: TextStyle(fontSize: 36.sp, color: Colors.red),
                  )),
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
                            " ￥ ${parseNumber(isVirtual ? (double.parse(onlineController.xnbRealAmount.value) * (currentPay.rate ?? 0)) : double.parse(onlineController.xnbRealAmount.value))}元",
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

    List<Charge> tempList =
        controller.thirdWalletBean.value?.field?.charge ?? [];
    if (tempList.isNotEmpty) {
      for (var item in tempList) {
        formList.add(
          WalletInputFieldWidget(
              title: item.name ?? "",
              placeholder: item.desc ?? "",
              obscureText: item.key == '3rdPassword' ? true : false,
              textInputType: item.key == '3rdPassword'
                  ? TextInputType.visiblePassword
                  : TextInputType.number,
              onChanged: (value) {
                controller.thirdParameters['${item.key}'] = value;
                onlineController.isCanClickRecharge();
              }),
        );
      }
    }

    /// 快捷充值模块
    if (controller.quickMoneyList.isNotEmpty) {
      formList.add(
        RechargeQuickInputMoneyWidget(
          rechargeAmount: onlineController.rechargeAmount.value,
          onChanged: (value) =>
              onlineController.setRechargeAmount(value, rate: rate),
        ),
      );
    }

    // if (protocalItem != null) {
    //   formList.add(Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       RechargeModuleTitleWidget(
    //         str: "优惠比例",
    //         fontSize: 45.sp,
    //       ),
    //       SizedBox(
    //         height: 20.h,
    //       ),
    //       Text("${protocalItem!.a}%")
    //     ],
    //   ));
    // }
    formList.add(RechargeOkButtonWidget(
      text: ThemeService.to.currentTheme.value?.model == "blackGold"
          ? "立即充值"
          : '确认充值',
      isCanRecharge: onlineController.isCanRecharge.value,
      clickButton: () {
        AppManager.instance.tapVibrate();
        if (LoginManager.instance.checkIsFrozen()) {
          return;
        }
        if (controller
                .merchatProtocolList[
                    controller.currentSelectProtocalIndex.value]
                .isEmbed ==
            "1") {
          //如果点击的是内嵌充值的，检测内嵌余额是否大于充值金额
          if (num.parse(onlineController.rechargeAmount.value) <=
              (controller.walletBean.value?.walletBalance ?? 0) / 1000) {
            DebounceThrottle.debounce(onlineController.clickOnlineRecharge)();
          } else {
            Get.dialog(tipsDialog(context));
          }
          // Get.dialog(tipsDialog());
        } else {
          DebounceThrottle.debounce(onlineController.clickOnlineRecharge)();
        }
      },
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...formList,
        SizedBox(height: 60.h),
      ],
    );
  }

  Widget tipsDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.r), // ✅ 直接设置 Dialog 圆角
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 90.w),
      child: Container(
        height: 590.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: context.customTheme?.pageThreeBg,
            borderRadius: BorderRadius.circular(40.r)),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 55.h,
                ),
                Text(
                  "重要提醒",
                  style: TextStyle(
                      fontSize: 51.sp,
                      color: context.customTheme?.rechargeSecondTypeBgColor),
                ),
                SizedBox(
                  height: 130.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48.w),
                  child: Text(
                    "当前${controller.currentRechargeType.name}余额不足，是否立即购买?",
                    style: TextStyle(
                        fontSize: 40.sp,
                        color: context.customTheme?.rechargeTipsTxtColor),
                  ),
                ),
                SizedBox(
                  height: 110.h,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48.w),
                    child: Row(
                      children: [
                        Expanded(
                            child: CommonRipple(
                          onTap: () {
                            AppManager.instance.tapVibrate();
                            Get.back();
                          },
                          child: Container(
                            height: 115.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                border: Border.all(
                                    color: context.customTheme!
                                        .rechargeTipsDialogBorderLineColor!)),
                            child: Text(
                              "我再想想",
                              style: TextStyle(
                                  fontSize: 42.sp,
                                  color: context.theme.primaryColor),
                            ),
                          ),
                        )),
                        SizedBox(
                          width: 40.w,
                        ),
                        Expanded(
                          child: CommonRipple(
                            onTap: () {
                              AppManager.instance.tapVibrate();
                              DebounceThrottle.debounce(
                                  onlineController.clickOnlineRecharge)();
                            },
                            child: Container(
                              height: 115.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: context.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(30.r)),
                              child: Text(
                                "立即购买",
                                style: TextStyle(
                                    fontSize: 42.sp,
                                    color: context
                                        .customTheme?.rechargeMoneyColor),
                              ),
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
            Positioned(
                top: 38.h,
                right: 40.w,
                child: CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Color(colorCECECE),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
