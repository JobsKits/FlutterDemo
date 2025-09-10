import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_common_container.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_ok_button_widget.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../../utils/clipboard_util.dart';
import '../../../../utils/tenant_manager.dart';
import '../../settings/views/settings_withdrawal_pwd_dialog.dart';
import '../controllers/new_withdrawal_controller.dart';
import '../widget/new_withdraw_wallet_address_widget.dart';
import '../widget/recharge_rich_title_widget.dart';
import '../widget/recharge_tips_dialog.dart';
import '../widget/wallet_input_field_widget.dart';

//新版提现主界面
class NewWithdrawalView extends GetView<NewWithdrawalController> {
  const NewWithdrawalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        title: Text(
          "提现",
          style: TextStyle(color: context.customTheme?.appbarText),
        ),
        backgroundColor: context.customTheme?.navbarBg,
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20.w),
            child: CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                if (TenantManager.instance.isCanOpenCustomerService) {
                  Get.toNamed(Routes.CUSTOMER_SERVICE);
                } else {
                  Get.toNamed(Routes.WEB_VIEW_INAPP, arguments: {
                    "url": TenantManager
                        .instance.tenantBean?.tenant?.onlineAddr, //请求地址
                    "title": "在线客服",
                  });
                }
              },
              child: SvgPicture.asset(
                Assets.theme1.images.user.iconCustomServiceSvg,
                width: 60.w,
                height: 60.h,
                color: context.customTheme?.appbarText,
              ),
            ),
          ),
          CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              Get.toNamed(Routes.DW_RECORDS, arguments: {"isRecharge": false});
            },
            child: Container(
              margin: EdgeInsets.only(right: 40.w),
              child: SvgPicture.asset(
                Assets.theme1.images.recharge.iconDwRecords,
                width: 60.w,
                height: 60.h,
                color: context.customTheme?.appbarText,
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.initData(),
        child: _buildBody(context),
      ),
    );
  }

  //内容主体
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        margin: EdgeInsets.only(top: 20.h),
        child: Column(
          children: [
            Obx(() => _buildWithdrawTypeTab(context)),
            SizedBox(
              height: 32.h,
            ),
            Obx(() => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _buildContent(context)),
            // _buildBottomInfo() //底部信息栏
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawTypeTab(BuildContext context) {
    if (controller.tabList.isEmpty) {
      return const SizedBox();
    }
    return SizedBox(
      width: double.infinity,
      height: 120.h,
      child: TabBar(
        onTap: (index) {
          if (controller.currentTabIndex.value != index) {
            AppManager.instance.tapVibrate();
          }
          controller.changeTabIndex(index);
        },
        // tabAlignment: TabAlignment.start,
        // isScrollable: true,
        labelPadding: EdgeInsets.only(right: 50.w),
        labelStyle:
            TextStyle(color: context.theme.primaryColor, fontSize: 51.sp),
        indicatorColor: context.theme.primaryColor,
        unselectedLabelStyle:
            TextStyle(color: Color(color4B4B4B), fontSize: 42.sp),
        dividerHeight: 1.h,
        controller: controller.tabController,
        tabs: List.generate(controller.tabList.length, (index) {
          // return Tab(
          //   text: controller.tabList[index].title,
          // );
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Tab(
                text: controller.tabList[index].title,
              ),
              Obx(() {
                if (controller.tabList[index].label == null ||
                    controller.tabList[index].label!.isEmpty)
                  return SizedBox.shrink();
                return Positioned(
                  top: -20.h,
                  right: -60.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: const Color(colorF70054), // 标签背景颜色
                      borderRadius: BorderRadius.circular(36.r), // 圆角
                    ),
                    child: Text(
                      '${controller.tabList[index].label}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  //构建底部信息
  Widget _buildBottomInfo() {
    return Obx(() => controller.tabList.isNotEmpty
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 50.h),
            child: HtmlWidget(
                "${controller.tabList[controller.currentTabIndex.value].describeinfo ?? ''}"),
          )
        : SizedBox.shrink());
  }

  //构建内容
  Widget _buildContent(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildAccountInfo(context),
      Obx(() => controller.isLoadNoPayView.value
          ? SizedBox()
          : (!controller.isNoPayBind.value && controller.isNoPay.value)
              ? noPayNotBindView(context)
              : (controller.isNoPayBind.value && controller.isNoPay.value)
                  ? noPayBindView(context)
                  : SizedBox()),
      if (!controller.isNoPay.value) ...[
        NewWithdrawWalletAddressWidget(
          onTap: () async {
            AppManager.instance.tapVibrate();
            if (controller.hasPwd) {
              var realIndex = controller.noPayInfo != null
                  ? controller.currentTabIndex.value - 1
                  : controller.currentTabIndex.value;
              Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT,
                  arguments: {"tabIndex": realIndex})?.then((_) {
                controller.reqDefaultBankCard(
                    defaultIndex: controller.currentTabIndex.value);
              });
            } else {
              // Get.toNamed(Routes.EDIT_PASSWORD,
              //     arguments: {"isLoginPwd": false})?.then((_) {
              //   controller.checkPwdStatus();
              // });
              await Get.dialog(SettingsWithdrawalPwdDialog());
              controller.checkPwdStatus();
            }
          },
        ),
        _buildWithdrawInputWidget(context),
        Obx(() => controller.describe.isNotEmpty
            ? Container(
                margin: EdgeInsets.only(
                  top: 50.h,
                  bottom: 100.h,
                ),
                child: HtmlWidget(
                  "${controller.describe}",
                ),
              )
            : SizedBox())
      ]
    ]);
  }

  //已经绑定了nopay钱包后的组件
  Widget noPayBindView(BuildContext context) {
    return Column(
      children: [
        RechargeCommonContainer(
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 60.w,
                    child: Image.asset(
                      controller.getRechargeTypeIcon(
                        payOrgId: 308,
                      ),
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          Assets.theme1.images.home.errorImg.path,
                          fit: BoxFit.cover, // 根据需要调整 fit 属性
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 25.w,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${controller.noPayInfo?.payOrgName}",
                          style: TextStyle(
                              fontSize: 45.sp, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Text(
                            "￥${(controller.walletBean.value?.walletBalance ?? 0) / 1000}",
                            style: TextStyle(
                                fontSize: 45.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 12.sp,
                          ),
                          CommonRipple(
                            onTap: () {
                              AppManager.instance.tapVibrate();
                              controller.reqUserInfo(isRefresh: true);
                            },
                            child: SvgPicture.asset(
                              Assets.theme1.images.user.iconRefresh,
                              width: 45.w,
                              height: 45.h,
                            ),
                          )
                        ],
                      )
                    ],
                  )),
                  CommonRipple(
                    onTap: () async {
                      AppManager.instance.tapVibrate();
                      String jumpUrl = await controller.getJumpUrl() ?? "";
                      if (jumpUrl.isEmpty) return;
                      final Uri url = Uri.parse(jumpUrl);
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 267.w,
                      height: 87.h,
                      decoration: BoxDecoration(
                          color: const Color(theme01MainColor),
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Text(
                        "挂单出售",
                        style: TextStyle(fontSize: 43.sp, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Text(
                      "钱包地址: ${controller.walletBean.value?.walletAddress ?? ''}"),
                  SizedBox(
                    width: 10.w,
                  ),
                  CommonRipple(
                    onTap: () {
                      ClipboardUtil.copy(
                          controller.walletBean.value?.walletAddress);
                    },
                    child: SvgPicture.asset(
                      Assets.theme1.images.user.iconCopy,
                      width: 40.w,
                      height: 40.h,
                      colorFilter: const ColorFilter.mode(
                          Color(theme01MainColor), BlendMode.srcIn),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        _buildWithdrawInputWidget(context),
        Obx(() => controller.describe.isNotEmpty
            ? Container(
                margin: EdgeInsets.only(
                  top: 50.h,
                  bottom: 100.h,
                ),
                child: HtmlWidget(
                  "${controller.describe}",
                ),
              )
            : const SizedBox())
      ],
    );
  }

  //no钱包内嵌未绑定的组件
  Widget noPayNotBindView(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40.h),
      child: Row(
        children: [
          Expanded(
              child: Column(
            children: [
              Text(
                "已有账号，可立即绑定",
                maxLines: 1,
                style: TextStyle(fontSize: 32.sp),
              ),
              CommonRipple(
                onTap: () async {
                  String? registerUrl = await controller.reqRegisterUrl(true);
                  if (registerUrl != null && registerUrl.isNotEmpty) {
                    final Uri url = Uri.parse(registerUrl);
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  alignment: Alignment.center,
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: context.theme.primaryColor,
                  ),
                  child: const Text(
                    "立即绑定",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          )),
          SizedBox(
            width: 40.w,
          ),
          Expanded(
              child: Column(
            children: [
              Text(
                "首次使用？只需设置支付密码",
                maxLines: 1,
                style: TextStyle(fontSize: 32.sp),
              ),
              CommonRipple(
                  onTap: () async {
                    showTipsDialog();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10.h),
                    alignment: Alignment.center,
                    height: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: Color(theme01MainColor),
                    ),
                    child: const Text("立即设置", style: TextStyle(color: Colors.white)),
                  )),
            ],
          ))
        ],
      ),
    );
  }

  showTipsDialog() {
    Get.dialog(
        Dialog(
          insetPadding: EdgeInsets.zero,
          child: IntrinsicHeight(
            child: Container(
              width: 0.7.sw,
              padding: EdgeInsets.all(20.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r)),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "重要提醒",
                        style: TextStyle(
                            fontSize: 50.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 60.h,
                      ),
                      Text("是否确定要新创建一个NO钱包账号?",
                          style: TextStyle(fontSize: 40.sp)),
                      SizedBox(
                        height: 80.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: CommonRipple(
                            onTap: () async {
                              Get.back();
                              String? registerUrl =
                                  await controller.reqRegisterUrl(true);
                              if (registerUrl != null &&
                                  registerUrl.isNotEmpty) {
                                final Uri url = Uri.parse(registerUrl);
                                await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: 100.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                        color: Color((theme01MainColor)))),
                                child: const Text(
                                  "已有nopay钱包",
                                  style:
                                      TextStyle(color: Color(theme01MainColor)),
                                )),
                          )),
                          SizedBox(
                            width: 20.w,
                          ),
                          Expanded(
                              child: CommonRipple(
                            onTap: () async {
                              Get.back();
                              String? registerUrl =
                                  await controller.reqRegisterUrl(false);
                              if (registerUrl != null &&
                                  registerUrl.isNotEmpty) {
                                final Uri url = Uri.parse(registerUrl);
                                await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                String? registerUrl =
                                    await controller.getJumpUrl();
                                if (registerUrl != null &&
                                    registerUrl.isNotEmpty) {
                                  final Uri url = Uri.parse(registerUrl);
                                  await launchUrl(url,
                                      mode: LaunchMode.externalApplication);
                                }
                              }
                            },
                            child: Container(
                              height: 100.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: Color((theme01MainColor))),
                              child: const Text(
                                "确认",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                          SizedBox(
                            height: 100.h,
                          ),
                        ],
                      )
                    ],
                  ),
                  Positioned(
                      right: 10.w,
                      top: 10.h,
                      child: CommonRipple(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.close),
                      ))
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false);
  }

  /// 账号详情
  Widget _buildAccountInfo(BuildContext context) {
    return RechargeCommonContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                Assets.theme1.images.withdraw.iconWallet.path,
                width: 64.w,
                color: context.customTheme?.appbarText,
                height: 60.h,
              ),
              SizedBox(
                width: 29.w,
              ),
              Text(
                "账户余额",
                style: TextStyle(
                    fontSize: 45.sp, color: context.customTheme?.titleColor),
              )
            ],
          ),
          Row(
            children: [
              Obx(() => Text(
                    "¥ ${LoginManager.instance.balanceStr.value}",
                    style: TextStyle(
                      fontSize: 50.sp,
                      color: context.customTheme?.titleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              SizedBox(
                width: 50.w,
              ),
              _buildRefreshIcon(),
            ],
          ),
        ],
      ),
    );
  }

  // 刷新Icon
  Widget _buildRefreshIcon() {
    return Obx(() {
      if (controller.isRefreshBalance.value) {
        return AnimatedBuilder(
          animation: controller.animationController,
          child: SvgPicture.asset(
            Assets.theme1.images.recharge.iconRefresh,
            width: 50.w,
            height: 50.h,
          ),
          builder: (context, child) {
            return Transform.rotate(
              angle: controller.animationController.value * 2.0 * pi, // 旋转角度
              child: child,
            );
          },
        );
      }

      return CommonRipple(
        onTap: () {
          AppManager.instance.tapVibrate();
          DebounceThrottle.debounce(controller.reqMoney)();
        },
        child: SvgPicture.asset(
          Assets.theme1.images.recharge.iconRefresh,
          width: 50.w,
          height: 50.h,
        ),
      );
    });
  }

  // 构建提现输入框
  Widget _buildWithdrawInputWidget(BuildContext context) {
    return Obx(() {
      // if (controller.currentSelectItem.value == null) {
      //   return const SizedBox();
      // }
      if (controller.tabList.isEmpty) {
        return const SizedBox();
      }
      int rechargeTypeId =
          controller.tabList[controller.currentTabIndex.value].rechargeTypeId ??
              0;
      // 虚拟币
      bool isVirtual = rechargeTypeId == 1;
      // 数字钱包
      bool isDigitalWallets = rechargeTypeId == 2;
      // String showStr1 =
      //     controller.truncateToFixed(controller.digitalCurrencyRate.value, 2);
      return Container(
        margin: EdgeInsets.only(top: 30.h),
        padding: EdgeInsets.all(46.w),
        decoration: BoxDecoration(
            color: context.customTheme?.pageTwoBg,
            borderRadius: BorderRadius.circular(36.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RechargeRichTitleWidget(fontSize: 45.sp, str: "提现金额"),
            WalletInputFieldWidget(
              title: '',
              placeholder:
                  "限额${parseNumber(controller.limitMin.value)}-${parseNumber(controller.limitMax.value)}",
              currencyType: CurrencyType.fiat,
              defaultContent: controller.showAmount.value,
              textInputType: TextInputType.number,
              // textInputType: const TextInputType.numberWithOptions(decimal: true),
              minValue: controller.limitMin.value,
              maxValue: controller.limitMax.value,
              onChanged: (value) => controller.setWithdrawAmount(value),
            ),
            if (num.parse(controller.withdrawFee.value) > 0)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Row(
                    children: [
                      isVirtual
                          ? Text(
                              '手续费：${controller.getWithdrawFeeStr()}CNY',
                              style: TextStyle(
                                  fontSize: 36.sp,
                                  color: context.customTheme?.titleColor),
                            )
                          : Text(
                              '手续费：${controller.getWithdrawFeeStr()}',
                              style: TextStyle(
                                  fontSize: 36.sp,
                                  color: context.customTheme?.titleColor),
                            ),
                      SizedBox(
                        width: 30.w,
                      ),
                      if (controller.withdrawFeeDesc.isNotEmpty)
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
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '手续费规则',
                                            style: TextStyle(
                                              fontSize: 50.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          HtmlWidget(
                                            controller.withdrawFeeDesc.value,
                                            textStyle: const TextStyle(
                                              color: Color(color4B4B4B),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 150.w,
                                              right: 150.w,
                                              bottom: 60.h,
                                            ),
                                            child: RechargeOkButtonWidget(
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
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            AppManager.instance.tapVibrate();
                                            Get.back();
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(10.w),
                                            child: const Icon(
                                              Icons.close,
                                              color: Color(0xffc6c6c6),
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
                            '详见规则',
                            style: TextStyle(
                              fontSize: 30.sp,
                              color: const Color(colorFE6D02),
                            ),
                          ),
                        ),
                    ],
                  ),
                  isVirtual
                      ? RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: 36.r,
                                  color: context.customTheme?.titleColor),
                              text: "预计到账：",
                              children: [
                              TextSpan(
                                  text: controller.getWithdrawRealStr2(),
                                  style: const TextStyle(
                                      color: Color(colorFE6D02)))
                            ]))
                      : RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: 36.r,
                                  color: context.customTheme?.titleColor),
                              text: "预计到账：",
                              children: [
                              TextSpan(
                                  text: controller.getWithdrawRealStr(),
                                  style: const TextStyle(
                                      color: Color(colorFE6D02)))
                            ])),
                ],
              ),
            Visibility(
                visible: (controller.withdrawAmount.value.isNotEmpty &&
                        controller.withdrawAmount.value != "0") &&
                    (double.parse(controller.withdrawAmount.value) <
                            controller.limitMin.value ||
                        double.parse(controller.withdrawAmount.value) >
                            controller.limitMax.value),
                child: Text(
                  "单笔提现 ${parseNumber(controller.limitMin.value)}~${parseNumber(controller.limitMax.value)}",
                  style: TextStyle(color: Colors.red),
                )),
            SizedBox(
              height: 4.h,
            ),
            if (isDigitalWallets)
              Text(
                controller.getWithdrawBonusStr(),
                style: TextStyle(
                    fontSize: 36.sp, color: context.customTheme?.titleColor),
              ),
            SizedBox(
              height: 7.h,
            ),
            Visibility(
                visible: isDigitalWallets,
                child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: 36.r,
                            color: context.customTheme?.titleColor),
                        text: "预计到账：",
                        children: [
                      TextSpan(
                          text: controller.getWithdrawRealStr(),
                          style: const TextStyle(color: Color(colorFE6D02)))
                    ]))),
            isVirtual
                ? Row(
                    children: [
                      // Text(
                      //   "汇率：￥1≈${showStr1}U",
                      //   style: TextStyle(fontSize: 36.sp),
                      // ),
                      Text(
                        "汇率：1U：${controller.digitalCurrencyRate.value}￥",
                        style: TextStyle(
                            fontSize: 36.sp,
                            color: context.customTheme?.titleColor),
                      ),
                      CommonRipple(
                        onTap: () async {
                          AppManager.instance.tapVibrate();
                          controller.reqPayoutsRates();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: AnimatedBuilder(
                            animation: controller.animationController,
                            child: SvgPicture.asset(
                              Assets.theme1.images.user.iconRefresh,
                              width: 40.w,
                              colorFilter: ColorFilter.mode(
                                  context.customTheme?.titleColor ??
                                      Colors.black,
                                  BlendMode.srcIn),
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
                  )
                : const SizedBox(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 26.h),
              height: 1.h,
              color: const Color(colorE5E5E5),
            ),
            RichText(
                text: TextSpan(
                    style: TextStyle(
                        fontSize: 36.r,
                        color: context.customTheme?.title2Color),
                    text: "提现还需投注",
                    children: [
                  TextSpan(
                      text:
                          " ${((LoginManager.instance.userBalance?.markingQuantitySum ?? 0) / 1000).truncateToFixed(3)}",
                      style: TextStyle(color: context.theme.primaryColor)),
                ])),
            Row(
              children: [
                Expanded(
                    child: RechargeOkButtonWidget(
                  isCanRecharge:
                      (LoginManager.instance.userBalance?.markingQuantitySum ??
                                  0) ==
                              0 &&
                          (controller.withdrawAmount.value.isEmpty
                                  ? 0
                                  : int.parse(
                                      controller.withdrawAmount.value ?? "0")) >
                              0 &&
                          (double.parse(controller.withdrawAmount.value) >=
                                  controller.limitMin.value &&
                              double.parse(controller.withdrawAmount.value) <=
                                  controller.limitMax.value),
                  text: '立即提现',
                  clickButton: () {
                    AppManager.instance.tapVibrate();
                    if (LoginManager.instance.checkIsFrozen()) {
                      return;
                    }
                    controller.withdrawal();
                    // withdrawalMoney();
                  },
                )),
                SizedBox(width: 40.w),
                Expanded(
                    child: RechargeOkButtonWidget(
                  text: '存利息宝赚利息',
                  clickButton: () {
                    AppManager.instance.tapVibrate();
                    Get.toNamed(Routes.YUEBAO, arguments: {
                      'showTitle': true,
                    });
                    // showRiskDialog();
                  },
                )),
              ],
            ),
          ],
        ),
      );
    });
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
                                "￥${controller.withdrawAmount.value}",
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
                                  text: controller.getWithdrawFeeStr(),
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
                                  text: controller.getWithdrawRealStr(),
                                  style: const TextStyle(
                                      color: Color(colorFE6D02)))
                            ])),
                        SizedBox(
                          height: 100.h,
                        ),
                        WalletInputFieldWidget(
                          title: '交易密码',
                          placeholder: '请输入交易密码',
                          onChanged: (value) => controller.setAcctPwd(value),
                        ),
                        RechargeOkButtonWidget(
                          text: "确认提现",
                          clickButton: () {
                            AppManager.instance.tapVibrate();
                            controller.handleWithdraw(() {
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
                          controller.setAcctPwd('');
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

  void showRiskDialog() {
    Get.dialog(
        Dialog(
          child: Container(
            width: 782.w,
            height: 612.h,
            decoration: BoxDecoration(
                color: Get.context?.customTheme?.dialogBgColor,
                borderRadius: BorderRadius.circular(43.r)),
            child: Stack(
              children: [
                Positioned(
                    right: 10.w,
                    top: 10.h,
                    child: CommonRipple(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        Get.back();
                      },
                      child: const Icon(Icons.close, color: Color(colorB7B7B7)),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 50.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          SvgPicture.asset(
                            Assets.theme1.images.recharge.iconRisk,
                            width: 110.w,
                            height: 110.h,
                          ),
                          SizedBox(
                            height: 18.h,
                          ),
                          Text(
                            "风控提示",
                            style: TextStyle(
                                fontSize: 45.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 18.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 100.w),
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 33.sp,
                                        color: const Color(color909090)),
                                    text: "由于现阶段银行卡风控严，为了您的 资金安全，",
                                    children: const [
                                  TextSpan(
                                      text: "建议选择【数字钱包】",
                                      style:
                                          TextStyle(color: Color(colorFD0F5A))),
                                  TextSpan(text: "提现"),
                                ])),
                          ),
                        ],
                      )),
                      Container(
                        height: 162.h,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                          width: 1.w,
                        ))),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text("坚持银行卡",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 45.sp,
                                        color: const Color(color666666)))),
                            const VerticalDivider(),
                            Expanded(
                                child: Text(
                              "选择数字钱包",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 45.sp),
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false);
  }

  //提现
  void withdrawalMoney() {
    if (int.parse(controller.certificationInfoData.isBindingPhone ?? "0") ==
            0 &&
        controller.isBand) {
      controller.comfirmDialog(
        title: '提示',
        content: "请绑定手机号码!",
        confirmText: '去绑定',
        onConfirm: () async {
          Get.back(); // 关闭弹窗

          // String? value = await Get.dialog(
          //   const ChangePhoneDialog(
          //     isShowSendCode: true,
          //   ),
          //   barrierDismissible: false,
          // );
          //
          // if (value != null) {
          //   controller.reqCertificationInfo();
          // }
          Get.toNamed(Routes.USER_INFO, arguments: {
            "isShowSendCode": int.parse(
                    controller.certificationInfoData.phone_sms_verify ?? "0") !=
                0,
            "isShowBindPhoneDialog": true,
          })?.then((value) {
            controller.reqCertificationInfo();
          }); // 身份认证，暂时无页面
        },
        // onBack: () {
        //   Get.back(); // 关闭弹窗
        // }
      );
    } else {
      var tempList =
          controller.tabList[controller.currentTabIndex.value].data ?? [];

      if (tempList.isEmpty) return;
      var bean = tempList[0];

      if (controller.validWithdraw()) {
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
              // int index = controller.showWithrawMethodList.indexWhere((item) =>
              //     item.payType == bean?.popupWithdrawalInfo?.payOrgId);
              // controller.changeWithdrawTypeIndex(index);
            },
          ));
        } else {
          //如果没有推荐渠道，直接显示确认弹窗
          showConfirmPop();
        }
      }
    }
  }
}
