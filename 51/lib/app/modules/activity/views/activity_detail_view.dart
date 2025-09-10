import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_detail_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_coding_table_model/activity_coding_table_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity_webview.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/activity_winning_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/funding_type_pop_widget.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/constants/activity_constants.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/CommonRipple.dart';
class ActivityDetailView extends GetView<ActivityDetailController> {
  const ActivityDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvokedWithResult: (bool didPop, _) {
          FundingTypePopWidget.instance.hide();
        },
        child: Scaffold(
            backgroundColor: context.customTheme?.pageBg,
            appBar: AppBar(
              backgroundColor: context.customTheme?.navbarBg,
              leading: BackButton(
                color: context.customTheme?.titleColor,
                onPressed: () {
                  Get.back();
                  dismissPop();
                },
              ),
              title: Text(
                controller.title.value,
                style: TextStyle(color: context.customTheme?.titleColor),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 30.w),
                  child: CommonRipple(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      if (controller.type == ActivityTypsEnum.custom) {
                        bool isLogin = LoginManager.instance.isLogin.value;
                        if (isLogin) {
                          Get.toNamed(Routes.DISCOUNT_RECORD, arguments: {
                            "id": controller.customModel.value.t!.id ?? '',
                          });
                        } else {
                          showLoginDialog();
                        }
                        return;
                      } else if (TenantManager
                          .instance.isCanOpenCustomerService) {
                        Get.toNamed(Routes.CUSTOMER_SERVICE);
                      } else {
                        String? onlineAddr = TenantManager
                            .instance.tenantBean?.tenant?.onlineAddr;
                        if (onlineAddr != null) {
                          String? type = TenantManager.instance.tenantBean
                              ?.sysOptions?.customerServiceSkipType;
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
                    child: Text(controller.type == ActivityTypsEnum.custom
                        ? '申请记录'
                        : "在线客服"),
                  ),
                ),
              ],
            ),
            body: controller.type == ActivityTypsEnum.lucky ||
                    controller.type == ActivityTypsEnum.coding ||
                    controller.type == ActivityTypsEnum.presave
                ? _buildBody(context)
                : controller.type == ActivityTypsEnum.custom
                    ? SafeArea(
                        child: Obx(() => _buildCustomBody(context)),
                      )
                    : controller.isRedbag.value
                        ? _buildBody(context)
                        : SafeArea(
                            child: Obx(() => _buildChildWidget()),
                          )));
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final buttonHeight = 250.h;
                return SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: buttonHeight),
                  child: Column(
                    children: [
                      if (controller.codingModel.value.t?.isShowAvatar ==
                          '1') ...[
                        Container(
                          padding: EdgeInsets.only(
                              top: 10.h, left: 30.w, right: 30.w),
                          child: InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 5.0,
                            child: Image.network(
                              controller.codingModel.value.t?.showAvatar ?? '',
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      ] else if (controller.luckyItemModel.value.isShowAvatar ==
                          '1') ...[
                        Container(
                          padding: EdgeInsets.only(
                              top: 10.h, left: 30.w, right: 30.w),
                          child: InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 5.0,
                            child: Image.network(
                              controller.luckyItemModel.value.showAvatar ?? '',
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      ],

                      if (controller.type == ActivityTypsEnum.lucky) ...[
                        _buildDetailTitle(),
                      ],

                      // 活动时间部分
                      if (controller.type == ActivityTypsEnum.coding &&
                          controller.codingModel.value.t?.isShowDetailTime ==
                              '1') ...[
                        _buildTime(context)
                      ] else if (controller.type == ActivityTypsEnum.lucky &&
                          controller.luckyItemModel.value.isShowDetailTime ==
                              '1') ...[
                        _buildTime(context)
                      ] else if (controller.type == ActivityTypsEnum.presave &&
                          controller.codingModel.value.t?.isShowDetailTime ==
                              '1') ...[
                        _buildTime(context)
                      ],
                      // 活动详情部分
                      Container(
                        margin: EdgeInsets.only(
                            top: 38.h, left: 30.w, right: 30.w, bottom: 5.h),
                        padding: EdgeInsets.all(50.w),
                        decoration: BoxDecoration(
                          color: context.customTheme?.pageTwoBg,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12.w,
                                  height: 46.w,
                                  decoration: BoxDecoration(
                                    color: context.theme.primaryColor,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(6.w),
                                      bottom: Radius.circular(6.w),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Text(
                                  '活动详情',
                                  style: TextStyle(
                                    fontSize: 51.sp,
                                    color: context.customTheme?.titleColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.w),
                            HtmlWidget(
                              controller.type == ActivityTypsEnum.coding ||
                                      controller.type ==
                                          ActivityTypsEnum.presave
                                  ? controller.codingModel.value.t
                                          ?.activityContent ??
                                      ''
                                  : controller.type == ActivityTypsEnum.lucky
                                      ? controller.luckyItemModel.value
                                              .activityContent ??
                                          ''
                                      : controller.redbagDetailModel.value
                                              .activityRemark ??
                                          '',
                              textStyle: TextStyle(
                                fontSize: 39.sp,
                                color: const Color(0xFF4B4B4B),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            if (controller.showLuckyRow) ...[
                              Obx(() => Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 42.sp,
                                            color: const Color(0xFF2D2D2D),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          children: [
                                            const TextSpan(text: '总上限'),
                                            TextSpan(
                                              text:
                                                  '${controller.totalReceiveTimes.value}',
                                              style: const TextStyle(
                                                  color:
                                                      Color(theme01MainColor)),
                                            ),
                                            const TextSpan(text: '次，今日领取上限'),
                                            TextSpan(
                                              text:
                                                  '${controller.todayReceiveTimes.value}',
                                              style: const TextStyle(
                                                  color:
                                                      Color(theme01MainColor)),
                                            ),
                                            const TextSpan(text: '次（还剩'),
                                            TextSpan(
                                              text:
                                                  '${controller.lastReceiveTimes.value}',
                                              style: const TextStyle(
                                                  color:
                                                      Color(theme01MainColor)),
                                            ),
                                            const TextSpan(text: '次）'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                            if (controller.type == ActivityTypsEnum.coding ||
                                controller.type == ActivityTypsEnum.presave ||
                                controller.type == ActivityTypsEnum.lucky) ...[
                              SizedBox(height: 20.w),
                              _buildTable(context)
                            ]
                          ],
                        ),
                      ),
                      // 活动规则部分
                      Container(
                        margin:
                            EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
                        padding: EdgeInsets.all(50.w),
                        decoration: BoxDecoration(
                          color: context.customTheme?.pageTwoBg,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12.w,
                                  height: 46.w,
                                  decoration: BoxDecoration(
                                    color: context.theme.primaryColor,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(6.w),
                                      bottom: Radius.circular(6.w),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Text(
                                  '活动规则',
                                  style: TextStyle(
                                    fontSize: 51.sp,
                                    color: context.customTheme?.titleColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.w),
                            HtmlWidget(
                              controller.type == ActivityTypsEnum.coding ||
                                      controller.type ==
                                          ActivityTypsEnum.presave
                                  ? controller
                                          .codingModel.value.t?.activityRule ??
                                      ''
                                  : controller.type == ActivityTypsEnum.lucky
                                      ? controller.luckyItemModel.value
                                              .activityRule ??
                                          ''
                                      : controller.redbagDetailModel.value
                                              .activityRules ??
                                          '',
                              textStyle: TextStyle(
                                fontSize: 39.sp,
                                color: context.customTheme?.title2Color,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 底部按钮
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildClaimButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTime(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
      padding: EdgeInsets.all(50.w),
      decoration: BoxDecoration(
        color: context.customTheme?.pageTwoBg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.w),
                    topRight: Radius.circular(6.w),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Text(
                '活动时间',
                style: TextStyle(
                  fontSize: 51.sp,
                  color: context.customTheme?.titleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.w),
          // if (controller.type == ActivityTypsEnum.lucky) ...[
          //   Text(
          //     '活动对象：全体会员',
          //     style: TextStyle(
          //       fontSize: 39.sp,
          //       color: const Color(0xFF4B4B4B),
          //       fontWeight: FontWeight.w300,
          //     ),
          //   ),
          // ],
          Text(
            controller.type == ActivityTypsEnum.coding
                ? '活动时间：${controller.codingModel.value.t?.startTime} ~ ${controller.codingModel.value.t?.endTime}'
                : controller.type == ActivityTypsEnum.presave
                    ? '${controller.codingModel.value.t?.startTime} ~ ${controller.codingModel.value.t?.endTime}'
                    : controller.type == ActivityTypsEnum.lucky
                        ? '${controller.luckyItemModel.value.showStartTime} ~ ${controller.luckyItemModel.value.showEndTime}'
                        : '活动时间：${DateTimeUtils.formatTimestamp(controller.redbagDetailModel.value.startDate ?? 0, temp: 'yyyy-MM-dd')} ~ ${DateTimeUtils.formatTimestamp(controller.redbagDetailModel.value.endDate ?? 0, temp: 'yyyy-MM-dd')}',
            style: TextStyle(
              fontSize: 39.sp,
              color: context.customTheme?.title2Color,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTitle() {
    return Container(
      margin: EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
      padding: EdgeInsets.all(50.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        "中奖注单详情",
        style: TextStyle(
          fontSize: 51.sp,
          color: const Color(theme01MainColor),
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    ).onTap(() {
      AppManager.instance.tapVibrate();
      controller.reqWinningDetail().then((res) => {
            Get.dialog(
              ActivityWinningDialog(
                  bonusAmount: controller.bonusAmount,
                  winnerModel: controller.winnerModel.value),
              barrierDismissible: false,
            )
          });
    });
  }

  Widget _buildClaimButton(BuildContext context) {
    return Obx(() => Container(
          color: controller.type == ActivityTypsEnum.coding ||
                  controller.type == ActivityTypsEnum.presave
              ? context.theme.primaryColor
              : Colors.white,
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 10, bottom: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                            controller.type == ActivityTypsEnum.coding
                                ? '投注金额： '
                                : controller.type == ActivityTypsEnum.lucky
                                    ? '   赠送金额:  '
                                    : controller.type ==
                                            ActivityTypsEnum.presave
                                        ? '奖励金额: '
                                        : '赠送金额:  ',
                            style: TextStyle(
                                color: controller.type ==
                                            ActivityTypsEnum.coding ||
                                        controller.type ==
                                            ActivityTypsEnum.presave
                                    ? Colors.white
                                    : const Color(colorABAAAA),
                                fontSize: 12)),
                        Text(
                          controller.type == ActivityTypsEnum.coding
                              ? '¥${double.parse((controller.amount.value / 1000).truncateToFixed(2))}'
                              : controller.type == ActivityTypsEnum.lucky
                                  ? '¥${double.parse((controller.amount.value / 1000).truncateToFixed(2))}'
                                  : controller.type == ActivityTypsEnum.presave
                                      ? '${double.parse((controller.amount.value / 1000).truncateToFixed(2))}'
                                      : '¥${double.parse((controller.redbagDetailModel.value.accountMoney! / 1000).truncateToFixed(2))}',
                          style: TextStyle(
                              color: controller.type == ActivityTypsEnum.coding
                                  ? const Color(colorFFED50)
                                  : controller.type == ActivityTypsEnum.presave
                                      ? Colors.yellow
                                      : Colors.black,
                              fontSize: 14),
                        )
                      ]),
                      if (controller.type != ActivityTypsEnum.presave) ...[
                        Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // 行内子元素顶部对齐
                            children: [
                              Text(
                                  controller.type == ActivityTypsEnum.coding
                                      ? '奖励金额:  '
                                      : controller.type ==
                                              ActivityTypsEnum.lucky
                                          ? '中奖注单数:  '
                                          : '领取条件:  ',
                                  style: TextStyle(
                                      color: controller.type ==
                                              ActivityTypsEnum.coding
                                          ? Colors.white
                                          : const Color(colorABAAAA),
                                      fontSize: 12)),
                              Text(
                                  controller.type == ActivityTypsEnum.coding
                                      ? '  ¥${double.parse((controller.count.value / 1000).truncateToFixed(2))}'
                                      : controller.type ==
                                              ActivityTypsEnum.lucky
                                          ? '${controller.count.value}'
                                          : LoginManager.instance.isLogin.value
                                              ? '充值${double.parse((controller.logRedbagModel.value.recharger ?? 0 / 1000).truncateToFixed(2))}/${double.parse((controller.redbagDetailModel.value.rechargeAmount ?? 0 / 1000).truncateToFixed(2))}\n打码${double.parse((controller.logRedbagModel.value.playAmount ?? 0 / 1000).truncateToFixed(2))}/${double.parse((controller.redbagDetailModel.value.playAmount ?? 0 / 1000).truncateToFixed(2))}'
                                              : '-',
                                  style: controller.type ==
                                              ActivityTypsEnum.coding ||
                                          controller.type ==
                                              ActivityTypsEnum.lucky ||
                                          controller.type ==
                                              ActivityTypsEnum.presave
                                      ? TextStyle(
                                          color: controller.type ==
                                                  ActivityTypsEnum.coding
                                              ? const Color(colorFFED50)
                                              : Colors.black,
                                          fontSize: 14)
                                      : const TextStyle(
                                          color: Color(colorABAAAA),
                                          fontSize: 12))
                            ])
                      ]
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: controller.type == ActivityTypsEnum.presave
                            ? 160
                            : 140,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: controller.type ==
                                      ActivityTypsEnum.coding ||
                                  controller.type == ActivityTypsEnum.presave
                              ? BorderRadius.circular(60.r)
                              : BorderRadius.circular(16.r),
                          gradient: LinearGradient(
                            colors: controller.type == ActivityTypsEnum.lucky
                                ? (controller.amount.value > 0 &&
                                            controller.luckyState.value ==
                                                false &&
                                            controller.lastReceiveTimes.value >
                                                0) ||
                                        (controller.luckModel.value
                                                    .restrictionType ==
                                                1 &&
                                            controller.count.value > 0)
                                    ? [
                                        context.theme.primaryColor,
                                        context.theme.primaryColor
                                      ]
                                    : [
                                        const Color(colorD2F9FF),
                                        const Color(colorD2F9FF)
                                      ]
                                : controller.type == ActivityTypsEnum.presave
                                    ? controller.amount.value > 0
                                        ? [
                                            const Color(0xffd2f9ff),
                                            const Color(0xffd2f9ff)
                                          ]
                                        : [
                                            const Color(colorD2F9FF),
                                            const Color(colorD2F9FF)
                                          ]
                                    : controller.logRedbagModel.value.state ==
                                                0 ||
                                            !controller.reviceState.value
                                        ? [
                                            context.theme.primaryColor,
                                            context.theme.primaryColor
                                          ]
                                        : [
                                            context.theme.primaryColor,
                                            context.theme.primaryColor
                                          ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  context.theme.primaryColor.withOpacity(0.5),
                              offset: Offset(0, 6.w),
                              blurRadius: 10.w,
                            ),
                          ],
                        ),
                        height: 120.h,
                        child: ElevatedButton(
                          onPressed: () {
                            AppManager.instance.tapVibrate();
                            if (controller.type == ActivityTypsEnum.coding &&
                                LoginManager.instance.isLogin.value) {
                              switch (controller.codingState.value) {
                                case 1:
                                  controller.reqReviceCoding();
                                  break;
                                case 0:
                                case 4:
                                case 5:
                                  return;
                                default:
                                  Get.back();
                                  controller.tabsController.jumpToPage(0);
                                  break;
                              }
                            } else if (controller.type ==
                                ActivityTypsEnum.lucky) {
                              if ((controller.amount.value > 0 &&
                                      controller.luckModel.value.state == 0 &&
                                      controller.lastReceiveTimes.value > 0) ||
                                  (controller.luckModel.value.restrictionType ==
                                          1 &&
                                      controller.count.value > 0)) {
                                controller.receiveLuckyBet();
                              }
                            } else if (controller.type ==
                                    ActivityTypsEnum.presave &&
                                controller.amount.value > 0) {
                              controller.reqApplyPreview();
                            } else {
                              if (controller.logRedbagModel.value.state == 0 ||
                                  !controller.reviceState.value) {
                                return;
                              }
                              controller.checkRedbagCanReceive(true);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: double.infinity,
                            child: Text(
                              controller.type == ActivityTypsEnum.coding
                                  ? controller.codingButtonTitle()
                                  : controller.type == ActivityTypsEnum.lucky
                                      ? (controller.luckModel.value.state ==
                                                      0 &&
                                                  controller.amount.value >
                                                      0) ||
                                              !controller.luckyState.value
                                          ? '领取'
                                          : '已领取'
                                      : controller.type ==
                                              ActivityTypsEnum.presave
                                          ? '申请活动优惠'
                                          : controller.logRedbagModel.value
                                                      .state ==
                                                  0
                                              ? '已领取'
                                              : '领取',
                              style: TextStyle(
                                fontSize: controller.type ==
                                            ActivityTypsEnum.coding ||
                                        controller.type ==
                                            ActivityTypsEnum.presave
                                    ? 38.sp
                                    : 48.sp,
                                color:
                                    controller.type == ActivityTypsEnum.coding
                                        ? Colors.black
                                        : controller.type ==
                                                ActivityTypsEnum.presave
                                            ? controller.amount.value > 0
                                                ? Colors.black
                                                : const Color(0xff999999)
                                            : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ));
  }

  Widget _buildCustomBody(BuildContext context) {
    final data = jsonDecode(controller.customModel.value.t?.actionCfg ?? '');
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if ((controller.customModel.value.t?.isShowDetailTime ??
                          '') ==
                      '1') ...[_buildCustomTime(context)],
                  _buildCustomWidget(context),
                ],
              ),
            ),
          ),
          if (data['isApplication'] == 1) ...[_buildCustomButton(context)]
        ],
      ),
    );
  }

  Widget _buildCustomTime(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
      padding: EdgeInsets.all(50.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF00CAE6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.w),
                    topRight: Radius.circular(6.w),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Text(
                '活动时间',
                style: TextStyle(
                  fontSize: 51.sp,
                  color: const Color(0xFF2D2D2D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.w),
          if (controller.type == ActivityTypsEnum.lucky) ...[
            Text(
              '活动对象：全体会员',
              style: TextStyle(
                fontSize: 39.sp,
                color: const Color(0xFF4B4B4B),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
          Text(
            controller.type == ActivityTypsEnum.coding
                ? '活动时间：${controller.codingModel.value.t?.startTime} ~ ${controller.codingModel.value.t?.endTime}'
                : controller.type == ActivityTypsEnum.presave
                    ? '${controller.codingModel.value.t?.startTime} ~ ${controller.codingModel.value.t?.endTime}'
                    : controller.type == ActivityTypsEnum.lucky
                        ? '活动时间：${DateTimeUtils.formatTimestamp(controller.luckModel.value.dBeginTime ?? 0, temp: 'yyyy-MM-dd')} ~ ${DateTimeUtils.formatTimestamp(controller.luckModel.value.dEndTime ?? 0, temp: 'yyyy-MM-dd')}'
                        : controller.type == ActivityTypsEnum.custom
                            ? '${controller.customModel.value.t?.startTime} ~ ${controller.customModel.value.t?.endTime}'
                            : '活动时间：${DateTimeUtils.formatTimestamp(controller.redbagDetailModel.value.startDate ?? 0, temp: 'yyyy-MM-dd')} ~ ${DateTimeUtils.formatTimestamp(controller.redbagDetailModel.value.endDate ?? 0, temp: 'yyyy-MM-dd')}',
            style: TextStyle(
              fontSize: 39.sp,
              color: const Color(0xFF4B4B4B),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomWidget(BuildContext context) {
    final cfg = controller.customModel.value.t?.actionCfg;
    final data = cfg != null ? jsonDecode(cfg) : {};
    final html = data['html'] ?? '<p>暂无活动信息</p>';

    return Obx(() => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: controller.webviewHeight.value,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          color: Colors.white, // 父视图背景为白色
          padding:
              const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
          child: ActivityWebview(
            html: html,
            onChangeHeihgt: (height) {
              controller.webviewHeight.value = height;
            },
          ),
        )));
  }

  bool containsImage(String jsonString) {
    try {
      final data = json.decode(jsonString);
      final html = data['html'] as String?;
      return html?.contains('<img') ?? false;
    } catch (e) {
      return false;
    }
  }

  Widget _buildCustomButton(BuildContext context) {
    return Obx(() => Container(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 10, bottom: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.center, // 行内子元素顶部对齐
                          children: [
                            Text('剩余申请次数:  ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 42.sp)),
                            Text('${controller.count.value}',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 42.sp))
                          ])
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 140,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.r),
                          gradient: const LinearGradient(
                            colors: [
                              const Color(0xff999999),
                              const Color(0xff999999)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(colorABAAAA),
                              offset: Offset(0, 6.w),
                              blurRadius: 10.w,
                            ),
                          ],
                        ),
                        height: 120.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            AppManager.instance.tapVibrate();
                            final data = jsonDecode(
                                controller.customModel.value.t?.deviceCfg ??
                                    '');

                            if (Platform.isAndroid && data['isAndroid'] == 0) {
                              controller.displayTipsDialog('android');
                              return;
                            } else if (Platform.isIOS && data['isIos'] == 0) {
                              controller.displayTipsDialog('ios');
                              return;
                            }

                            if (controller.count.value <= 0) {
                              return;
                            }

                            final result = await Get.toNamed(
                                Routes.PROMOTION_DISCOUNT,
                                arguments: {
                                  "id":
                                      controller.customModel.value.t!.id ?? '',
                                  "customModel": controller
                                          .customModel.value.t!.actionCfg ??
                                      '',
                                });

                            if (result != null) {
                              controller.count.value =
                                  controller.count.value - 1;
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                controller.reqCustomApplyNumbers();
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(theme01MainColor),
                            shadowColor: Colors.transparent,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: double.infinity,
                            child: Text(
                              '优惠申请',
                              style: TextStyle(
                                fontSize: 38.sp,
                                color: controller.count.value <= 0
                                    ? const Color(0xff999999)
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ));
  }

  _buildChildWidget() {
    // 自定义任务，渲染一个领取按钮
    // if (controller.itemData.value.task_type == ActivityTaskType.CustomTask) {
    //   return Container(
    //     height: 86.h,
    //     margin: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 30.h),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: [
    //         ElevatedButton(
    //           style: ElevatedButton.styleFrom(
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(43.r), // 设置圆角半径
    //             ),
    //             backgroundColor: const Color(0XFF10c8e3),
    //             padding: EdgeInsets.zero,
    //           ),
    //           onPressed: () {
    //             //
    //           },
    //           child: Text(
    //             "领取",
    //             style: TextStyle(fontSize: 42.sp, color: Colors.white),
    //           ),
    //         )
    //       ],
    //     ),
    //   );
    // }

    // 图片
    if (controller.itemData.value.contentType == ActivityContentType.Image) {
      return SingleChildScrollView(
        child: Container(
          // height: Get,
          padding: const EdgeInsets.fromLTRB(
              15.0, 15.0, 15.0, 30.0), // 替换 .h 和 .w，如果需要适配工具可以保留。
          child: InteractiveViewer(
            // boundaryMargin: EdgeInsets.all(20.0),
            minScale: 0.5, // 最小缩放比例
            maxScale: 5.0, // 最大缩放比例
            child: Image.network(
              controller.itemData.value.activityContent ?? '',
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }

    // 网址
    if (controller.itemData.value.contentType == ActivityContentType.Text &&
        controller.itemData.value.activityContent!.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r), // 设置圆角半径
        ),
        child: HtmlWidget("${controller.itemData.value.activityContent}"),
      );
    }
    return const SizedBox();
  }

  void dismissPop() {
    if (FundingTypePopWidget.instance.isShowing()) {
      FundingTypePopWidget.instance.hide();
    }
  }

  Widget _buildTable(BuildContext context) {
    List<String> titleList = ["注单尾号", "注单金额", "赠送金额"];
    List<String> titleList2 = ["投注金额", "返奖比例", "打码倍数"];
    List<String> titleList3 = ["累计有效投注", "返奖比例"];
    List<String> titleList4 = ["充值金额", "充值次数", "赠送金额", "打码倍数"];
    List<dynamic> datas = [];
    late ActivityCodingTableModel codingTable = ActivityCodingTableModel();
    var bonusMethod = 1;

    if (controller.type == ActivityTypsEnum.coding) {
      final data = jsonDecode(controller.codingModel.value.t?.actionCfg ?? '');
      codingTable = ActivityCodingTableModel.fromJson(data);
      if (codingTable.rewardType == '2') {
        titleList3.add('奖金上限');
      } else if (codingTable.rewardType == '1') {
        titleList3[1] = "赠送金额";
      }
    } else if (controller.type == ActivityTypsEnum.presave) {
      final data = jsonDecode(controller.codingModel.value.t?.actionCfg ?? '');
      if (data['filter'] == 2) {
        return const SizedBox();
      }
      datas = data['rechargeMethod'] as List<dynamic>;
      bonusMethod = data['bonusMethod'];
      if (bonusMethod == 2) {
        titleList4[2] = "奖励比例";
      }
    } else {
      try {
        if (controller.luckModel.value.tailNum != null &&
            controller.luckModel.value.tailNum!.isNotEmpty) {
          datas =
              jsonDecode(controller.luckModel.value.tailNum!) as List<dynamic>;

          if (controller.luckModel.value.awardType == 1) {
            if (controller.luckModel.value.rewardType == 1) {
              titleList[1] = '中奖金额';
            }
            titleList[2] = '赠送比例';
            titleList.add("奖金上限");
          } else if (controller.luckModel.value.awardType != 1) {
            if (controller.luckModel.value.rewardType == 1) {
              titleList[1] = '中奖金额';
            }
          }
        }
      } catch (e) {
        print('Error decoding tailNum: $e');
        datas = [];
      }
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.w),
        border: Border.all(color: Colors.grey, width: 1), // 可选的边框
      ),
      child: Column(
        children: [
          // 表头
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: context.theme.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.w),
                topRight: Radius.circular(15.w),
              ),
            ),
            child: _rankItemHeaderRow(controller.type == ActivityTypsEnum.coding
                ? titleList3
                : controller.type == ActivityTypsEnum.presave
                    ? titleList4
                    : controller.type == ActivityTypsEnum.lucky
                        ? titleList
                        : titleList2),
          ),
          // 列表
          ListView.builder(
            shrinkWrap: true, // 高度自适应
            physics: const NeverScrollableScrollPhysics(), // 禁用单独滚动
            itemCount: controller.type == ActivityTypsEnum.coding
                ? codingTable.lossRewards?.length
                : datas.length,
            itemBuilder: (context, idx) {
              if (controller.type == ActivityTypsEnum.lucky) {
                final row = datas[idx];
                final quota = row["quota"].toString();
                List<String> listRow = ['', '', '', ''];

                if (controller.luckModel.value.awardType != 1) {
                  listRow = [
                    '${row["tail_num"]}',
                    '≥${(int.parse(row["lowest_award_amount"].toString()) / 1000).truncateToFixed(0)}',
                    '${moneyHandle(double.parse(row["award_amount"].toString()), precision: 2, mode: controller.luckModel.value.awardType == 0 ? 'floor' : 'ceil')}',
                  ];
                } else {
                  listRow = [
                    '${row["tail_num"]}',
                    '≥${(int.parse(row["lowest_award_amount"].toString()) / 1000).truncateToFixed(0)}',
                    '${(int.parse(row["award_amount"].toString()) / 100).truncateToFixed(0)}%',
                    quota.isEmpty || quota == '0'
                        ? '0.00'
                        : (int.parse((row["quota"].toString())) / 1000)
                            .truncateToFixed(2)
                  ];
                }
                return _rankItemRow(idx, listRow, '');
              } else if (controller.type == ActivityTypsEnum.coding) {
                final row = codingTable.lossRewards?[idx];
                String loss = (int.parse(row!.loss.toString()) ~/ 1000)
                    .truncateToFixed(0);
                String reward = codingTable.rewardType == '2'
                    ? '${row.reward.toString()}%'
                    : moneyHandle(double.parse(row.reward.toString()),
                        precision: 2,
                        mode: controller.luckModel.value.awardType == 0
                            ? 'floor'
                            : 'ceil');
                String maxReward = (int.parse(row.maxReward.toString()) ~/ 1000)
                    .truncateToFixed(2);
                List<String> listRow = [
                  '',
                  '',
                  '',
                ];
                if (codingTable.rewardType == '1') {
                  listRow = [
                    '≥${loss}',
                    reward,
                  ];
                } else {
                  listRow = [
                    '≥${loss}',
                    reward,
                    maxReward,
                  ];
                }
                return _rankItemRow(idx, listRow, '');
              } else if (controller.type == ActivityTypsEnum.presave) {
                final row = datas[idx];
                List<String> listRow = [
                  (int.parse(row['amount'].toString()) ~/ 1000)
                      .truncateToFixed(0),
                  '${row["count"]}',
                  bonusMethod == 2
                      ? '${row['rewardProportion'].toString()}%'
                      : (int.parse(row['rewardAmount'].toString()) ~/ 1000)
                          .truncateToFixed(0),
                  controller.codingModel.value.t?.auditTimes.toString() ?? '',
                ];
                return _rankItemRow(idx, listRow, '');
              } else {
                final row = codingTable.lossRewards?[idx];
                String loss = (int.parse(row!.loss.toString()) ~/ 1000)
                    .truncateToFixed(2);
                String reward = moneyHandle(double.parse(row.reward.toString()),
                    precision: 2,
                    mode: codingTable.rewardType == '0' ? 'floor' : 'ceil');
                String maxReward = (int.parse(row.maxReward.toString()) ~/ 1000)
                    .truncateToFixed(2);

                final listRow = [
                  loss,
                  reward,
                  maxReward,
                ];
                return _rankItemRow(idx, listRow, '');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _rankItemHeaderRow(List<String> values) {
    TextStyle style = TextStyle(
        color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold);

    // Create a list of widget columns based on the values
    List<Widget> columns = values.asMap().entries.map((entry) {
      String value = entry.value;

      // For the first and last item, use fixed width
      return Expanded(
        flex: 1,
        child: _rankItemCol(value, 100.w, style, true),
      );
    }).toList();

    return Row(
      children: columns,
    );
  }

  Widget _rankItemRow(int index, List<String> values, String? rollingType) {
    TextStyle defaultStyle = TextStyle(
      color: const Color.fromRGBO(102, 102, 102, 1),
      fontSize: 28.sp,
    );
    // Map each value to a column widget, with specific styling for the last column
    List<Widget> columns = values.asMap().entries.map((entry) {
      return Expanded(
        flex: 1,
        child: _rankItemCol(entry.value, 80.w, defaultStyle, false),
      );
    }).toList();
    // print({'object =======$index'});
    return Container(
      color: Colors.white,
      child: Row(
        children: columns,
      ),
    );
  }

  Widget _rankItemCol(
      String val, double width, TextStyle style, bool isheader) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        height: 35,
        alignment: Alignment.center,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(
              color: isheader ? Colors.transparent : Colors.grey,
              width: isheader ? 0 : 0.5), // 添加边框
        ),
        child: Text(val, style: style));
  }

  String moneyHandle(double num, {int precision = 2, String mode = 'floor'}) {
    double value = num;
    double result;

    if (mode == 'floor') {
      result = (value / 1000).floorToDouble(); // Perform division and floor
    } else if (mode == 'ceil') {
      result = (value / 1000).ceilToDouble(); // Perform division and ceil
    } else {
      throw ArgumentError("Invalid mode. Use 'floor' or 'ceil'.");
    }

    // Format to specified precision
    return result.truncateToFixed(precision);
  }
}
