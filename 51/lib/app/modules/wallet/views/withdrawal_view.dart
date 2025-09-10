import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_common_container.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_ok_button_widget.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/withdraw_wallet_address_widget.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/tenant_manager.dart';
import '../controllers/withdrawal_controller.dart';
import '../data/withdraw_method_bean.dart';
import '../widget/recharge_expand_widget.dart';
import '../widget/recharge_rich_title_widget.dart';
import '../widget/recharge_tips_dialog.dart';
import '../widget/wallet_input_field_widget.dart';

//提现主界面
class WithdrawalView extends GetView<WithdrawalController> {
  const WithdrawalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(colorF4F4F4),
      appBar: AppBar(
        title: const Text("提现"),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 60.w),
            child: InkWell(
              onTap: () {
                AppManager.instance.tapVibrate();
                if (TenantManager.instance.isCanOpenCustomerService) {
                  Get.toNamed(Routes.CUSTOMER_SERVICE);
                } else {
                  String? onlineAddr =
                      TenantManager.instance.tenantBean?.tenant?.onlineAddr;
                  if (onlineAddr != null) {
                    String? type = TenantManager.instance.tenantBean?.sysOptions
                        ?.customerServiceSkipType;
                    if (type == '1') {
                      launchUrl(Uri.parse(onlineAddr),
                          mode: LaunchMode.externalApplication);
                    } else {
                      Get.toNamed(Routes.WEB_VIEW_INAPP, arguments: {
                        "url": onlineAddr, //请求地址
                        "title": "在线客服",
                      });
                    }
                  }
                }
              },
              child: SvgPicture.asset(
                Assets.theme1.images.recharge.iconCustom,
                width: 67.w,
                height: 67.h,
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
            Obx(() => _buildWithdrawTypeList(context)), // 提现渠道列表
            // Obx(() => _buildContent()), //当前内容组件 ： 可以根据不同提现内容替换
            _buildContent(),
            _buildBottomInfo() //底部信息栏
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
      height: 94.h,
      child: TabBar(
        onTap: (index) {
          if (controller.currentTabIndex.value != index) {
            AppManager.instance.tapVibrate();
          }
          controller.changeTabIndex(index);
        },
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        labelPadding: EdgeInsets.only(right: 50.w),
        labelStyle:
            TextStyle(color: context.theme.primaryColor, fontSize: 51.sp),
        indicatorColor: context.theme.primaryColor,
        unselectedLabelStyle:
            TextStyle(color: Color(color4B4B4B), fontSize: 42.sp),
        dividerHeight: 1.h,
        controller: controller.tabController,
        tabs: List.generate(controller.tabList.length, (index) {
          return Tab(
            text: controller.tabList[index].title,
          );
        }),
      ),
    );
  }

  //构建底部信息
  Widget _buildBottomInfo() {
    return Column(
      children: [
        SizedBox(
          height: 57.h,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "温馨提示",
              style: TextStyle(
                  color: const Color(colorFE000E),
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16.h,
            ),
            Text(
              "为了确保您的资金安全和快速到账，我们推荐使用UBpay钱包提现。UBpay钱包提现的优势明显：到账只许5分钟，并且加送3%；银行卡提现需2~6小时，且易被风控。",
              style: TextStyle(fontSize: 36.sp),
            ),
          ],
        ),
        SizedBox(
          height: 62.h,
        )
      ],
    );
  }

  //构建内容
  Widget _buildContent() {
    return Column(
      children: [
        _buildAccountInfo(),
        Obx(
          () {
            WithdrawMethodBean? withdrawItem = controller.getWithdrawItem();
            if (withdrawItem == null ||
                !controller.isReqWithdrawAccountFinish.value) {
              return const SizedBox.shrink();
            }

            return WithdrawWalletAddressWidget(
              name: withdrawItem.label,
              payType: withdrawItem.payType,
              icon: withdrawItem.icon,
              defaultBindCard: controller.defaultWithdrawAccount.value,
              withdrawBindCardList: controller.currentWithdrawAccountList,
              onTap: () {
                AppManager.instance.tapVibrate();
                Get.toNamed(
                  Routes.RECHARGE_ADD_ADDRESS,
                  arguments: {
                    "title": "添加${withdrawItem.label}账号",
                    "payType": withdrawItem.payType,
                  },
                );
              },
            );
          },
        ),
        Obx(() => _buildWithdrawInputWidget()),
      ],
    );
  }

  /// 账号详情
  Widget _buildAccountInfo() {
    return RechargeCommonContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                Assets.theme1.images.withdraw.iconWallet.path,
                width: 64.w,
                height: 60.h,
              ),
              SizedBox(
                width: 29.w,
              ),
              Text(
                "账户余额",
                style: TextStyle(fontSize: 45.sp),
              )
            ],
          ),
          Row(
            children: [
              Obx(() => Text(
                    LoginManager.instance.balanceStr.value,
                    style: TextStyle(
                      fontSize: 50.sp,
                      color: Colors.black,
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

  // 构建动画列表
  Widget _buildWithdrawTypeAnimateList() {
    // 根据折叠状态决定显示的渠道数量
    final displayedChannels = !controller.isExpand.value
        ? controller.showWithrawMethodList.take(9).toList()
        : controller.showWithrawMethodList;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: Obx(() => controller.showWithrawMethodList.isNotEmpty
          ? GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: (!controller.isExpand.value
                      ? controller.showWithrawMethodList.take(9).toList()
                      : controller.showWithrawMethodList)
                  .length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15.h,
                  mainAxisSpacing: 20.w,
                  childAspectRatio: 2.87),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (controller.currentWithdrawTypeIndex.value != index) {
                      AppManager.instance.tapVibrate();
                    }
                    controller.changeWithdrawTypeIndex(index);
                  },
                  child: Obx(
                    () => Container(
                      height: 119.h,
                      padding: EdgeInsets.symmetric(horizontal: 26.w),
                      alignment: Alignment.center,
                      decoration: controller.currentWithdrawTypeIndex.value ==
                              index
                          ? BoxDecoration(
                              color: const Color(colorDFFDFF),
                              borderRadius: BorderRadius.circular(27.r),
                              border:
                                  Border.all(color: context.theme.primaryColor))
                          : BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(27.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 32.w,
                            child: Image.asset(
                              controller.showWithrawMethodList[index].icon,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  Assets.theme1.images.home.errorImg.path,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Text(
                                controller.showWithrawMethodList[index].label,
                                style: TextStyle(
                                  color: controller
                                              .currentWithdrawTypeIndex.value ==
                                          index
                                      ? context.theme.primaryColor
                                      : Colors.black,
                                  fontSize: 41.sp,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : SizedBox()),
    );
  }

  //提现渠道列表
  Widget _buildWithdrawTypeList(BuildContext context) {
    return Column(
      children: [
        _buildWithdrawTypeAnimateList(),
        Container(
          height: 12.h,
          // color: Colors.amber,
        ),
        RechargeExpandWidget(
          text: controller.isExpand.value ? "折叠" : "展开",
          isVisible: controller.isShowMore.value,
          openOrExpand: controller.openOrExpandList,
          isExpand: controller.isExpand.value,
        )
      ],
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

      return InkWell(
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
  Widget _buildWithdrawInputWidget() {
    WithdrawMethodBean? withdrawItem = controller.getWithdrawItem();
    if (withdrawItem == null) {
      return const SizedBox();
    }

    // 虚拟币
    bool isVirtual = withdrawItem.value == 2;
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      padding: EdgeInsets.all(46.w),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(36.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RechargeRichTitleWidget(fontSize: 45.sp, str: "提现金额"),
              isVirtual
                  ? Text(
                      "当前汇率：1USDT≈7.18${controller.currency.value}",
                      style: TextStyle(
                          fontSize: 36.sp, color: const Color(color0083EA)),
                    )
                  : const SizedBox()
            ],
          ),
          WalletInputFieldWidget(
            title: '',
            placeholder:
                "限额${parseNumber(controller.limitMin.value)}-${parseNumber(controller.limitMax.value)}",
            currencyType: CurrencyType.fiat,
            textInputType: TextInputType.number,
            // textInputType: const TextInputType.numberWithOptions(decimal: true),
            minValue: controller.limitMin.value,
            maxValue: controller.limitMax.value,
            onChanged: (value) => controller.setWithdrawAmount(value),
          ),
          Text(
            '手续费：${controller.getWithdrawFeeStr()}',
            style: TextStyle(fontSize: 36.sp, color: Colors.black),
          ),
          SizedBox(
            height: 7.h,
          ),
          RichText(
              text: TextSpan(
                  style: TextStyle(fontSize: 36.r, color: Colors.black),
                  text: "实际到账：",
                  children: [
                TextSpan(
                    text: controller.getWithdrawRealStr(),
                    style: const TextStyle(color: Color(colorFE6D02)))
              ])),
          Container(
            margin: EdgeInsets.symmetric(vertical: 26.h),
            height: 1.h,
            color: const Color(colorE5E5E5),
          ),
          // RichText(
          //     text: TextSpan(
          //         style: TextStyle(
          //             fontSize: 36.r, color: const Color(color888888)),
          //         text: "还需投注：",
          //         children: const [
          //       TextSpan(
          //           text: "xxx元",
          //           style: TextStyle(color: Color(theme01MainColor))),
          //       TextSpan(
          //           text: "才能提现", style: TextStyle(color: Color(color888888))),
          //     ])),
          Row(
            children: [
              Expanded(
                  child: RechargeOkButtonWidget(
                text: '立即提现',
                clickButton: () {
                  AppManager.instance.tapVibrate();
                  withdrawalMoney();
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
          )
        ],
      ),
    );
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
                      child: GestureDetector(
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
                color: Colors.white, borderRadius: BorderRadius.circular(43.r)),
            child: Stack(
              children: [
                Positioned(
                    right: 10.w,
                    top: 10.h,
                    child: GestureDetector(
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
    if (int.parse(controller.data.isBindingPhone ?? "0") == 0 &&
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
            "isShowSendCode":
                int.parse(controller.data.phone_sms_verify ?? "0") != 0,
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
      var currentTab =
          controller.tabList[controller.currentTabIndex.value].data ?? [];
      var bean = currentTab[controller.currentWithdrawTypeIndex.value];

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
              int index = controller.showWithrawMethodList.indexWhere((item) =>
                  item.payType == bean?.popupWithdrawalInfo?.payOrgId);
              controller.changeWithdrawTypeIndex(index);
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
