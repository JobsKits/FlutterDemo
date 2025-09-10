import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_button.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/bet_recording_controller.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/clipboard_util.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../data/bet_list_bean.dart';
import '../widget/funding_type_pop_widget.dart';

import 'package:flutter_tiyu_app/app/modules/activity/widget/empty_widget.dart';

//投注记录页面
class BetRecordingView extends GetView<BetRecordingController> {
  const BetRecordingView({super.key});

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
              color: context.customTheme?.appbarText,
              onPressed: () {
                Get.back();
                dismissPop();
              },
            ),
            title: Text(
              "投注记录",
              style: TextStyle(color: context.customTheme?.appbarText),
            ),
            centerTitle: true,
          ),
          body: _buildBody(context),
        ));
  }

  Widget _buildTypeView(BuildContext context) {
    return _buildSelectButton(context, onTap: () {
      AppManager.instance.tapVibrate();
      dismissPop();
      FundingTypePopWidget.instance.show(
          context,
          _buildSelectList(context, child: _buildTypeGrid(), clickClose: () {
            AppManager.instance.tapVibrate();
            FundingTypePopWidget.instance.hide();
          }),
          top: controller.timeWidgetHeight);
    }, key: controller.typeKey, showName: controller.currentTypeName);
  }

  Widget _buildTimeView(context) {
    return _buildSelectButton(context, onTap: () {
      AppManager.instance.tapVibrate();
      dismissPop();
      FundingTypePopWidget.instance.show(
          context,
          _buildSelectList(context, child: _buildTimeGrid(), clickClose: () {
            AppManager.instance.tapVibrate();
            FundingTypePopWidget.instance.hide();
          }),
          top: controller.timeWidgetHeight);
    }, key: controller.timeKey, showName: controller.currentTimeName);
  }

  Widget _buildPlatformView(context) {
    return _buildSelectButton(context, onTap: () {
      AppManager.instance.tapVibrate();
      dismissPop();
      FundingTypePopWidget.instance.show(
          context,
          _buildSelectList(context, child: _buildPlatformGrid(),
              clickClose: () {
            AppManager.instance.tapVibrate();
            FundingTypePopWidget.instance.hide();
          }),
          top: controller.timeWidgetHeight);
    }, key: controller.platformKey, showName: controller.currentPlatformName);
  }

  Widget _buildQueryView() {
    return Container(
      constraints: BoxConstraints(maxWidth: 200.w),
      child: Obx(
        () => CommonButton(
          title: '查询',
          minHeight: 104,
          borderRadius: 52,
          fontSize: 42,
          loading: controller.isBetLoading.value,
          onTap: controller.refreshData,
        ),
      ),
    );
  }

  // Widget _buildStatusView(context) {
  //   return _buildSelectButton(context, onTap: () {
  //     FundingTypePopWidget.instance.show(
  //         context,
  //         _buildSelectList(
  //             child: _buildStatusGrid(),
  //             clickClose: () {
  //               FundingTypePopWidget.instance.hide();
  //             }),
  //         top: controller.statusWidgetHeight);
  //   }, key: controller.statusKey, showName: controller.currentStatusName);
  // }

  Widget _buildBody(context) {
    return Column(
      children: [
        // Container(
        //     color: Colors.white,
        //     width: double.infinity,
        //     height: 100.h,
        //     child: Obx(
        //       () => controller.tabList.isNotEmpty
        //           ? TabBar(
        //               indicatorColor: const Color(theme01MainColor),
        //               labelColor: const Color(theme01MainColor),
        //               onTap: (index) {
        //                 controller.changeTabIndex(index);
        //               },
        //               tabAlignment: TabAlignment.start,
        //               unselectedLabelStyle: TextStyle(
        //                   color: const Color(colorAFAFAF), fontSize: 48.sp),
        //               isScrollable: true,
        //               dividerHeight: 0,
        //               labelStyle: TextStyle(fontSize: 54.sp),
        //               controller: controller.tabController,
        //               tabs: List.generate(controller.tabList.length, (index) {
        //                 return Tab(
        //                   text: controller.tabList[index].title,
        //                 );
        //               }))
        //           : const SizedBox(),
        //     )),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(left: 33.w, right: 33.h, top: 33.h),
          child: Obx(
            () => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      // flex: 1,
                      child: _buildTimeView(context),
                    ),
                    SizedBox(width: 38.w),
                    Expanded(
                      // flex: ,
                      child: _buildPlatformView(context),
                    ),
                    SizedBox(width: 38.w),
                    Expanded(
                      // flex: 1,
                      child: _buildTypeView(context),
                    ),
                    SizedBox(width: 38.w),

                    // controller.tabList
                    // Expanded(
                    //   flex: 1,
                    //   child: _buildTimeView(context),
                    // ),
                    // _buildQueryView(),
                    // SizedBox(width: 200.w),
                    // const Expanded(child: SizedBox()),
                    // Expanded(child: _buildStatusView(context)),
                  ],
                ),
                Expanded(
                    child: RefreshIndicator(
                        onRefresh: controller.pullRefreshData,
                        child: _buildContentList(context))),
              ],
            ),
          ),
        ))
      ],
    );
  }

  Widget _buildContentList(BuildContext context) {
    if (controller.isBetLoading.value) {
      return Container(
        padding: EdgeInsets.only(top: 300.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(height: 240.h),
          Center(
            child: SizedBox(
              width: 120.w,
              height: 120.h,
              child: CircularProgressIndicator(
                strokeWidth: 8.w,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.theme.primaryColor,
                ), // 圆圈颜色
              ),
            ),
          ),
        ]),
      );
    }

    if (controller.betList.isEmpty) {
      return const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: EmptyWidget(isBetDelay: true));
    }

    return ListView.builder(
      itemCount: controller.betList.length,
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        BetItem itemData = controller.betList[index];

        if (controller.isLoadingMore.value &&
            index == controller.betList.length - 1) {
          return Column(
            children: [
              _buildChildWidget(context, itemData, index),
              Center(
                child: SizedBox(
                  width: 120.w,
                  height: 120.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 8.w,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.theme.primaryColor,
                    ), // 圆圈颜色
                  ),
                ),
              )
            ],
          );
        }

        return _buildChildWidget(context, itemData, index);
      },
      shrinkWrap: true,
    );
  }

  Widget _buildChildWidget(BuildContext context, BetItem itemData, int index) {
    String playName = '';
    if (itemData.play_cname != null && itemData.play_cname!.isNotEmpty) {
      playName = itemData.play_cname!;
    } else if (itemData.playTypeId != null && itemData.playTypeId!.isNotEmpty) {
      playName = itemData.playTypeId!;
    }
    String gameName = '';
    if (itemData.game_type_cname != null &&
        itemData.game_type_cname!.isNotEmpty) {
      gameName = itemData.game_type_cname!;
    } else if (itemData.gameTypeId != null && itemData.gameTypeId!.isNotEmpty) {
      gameName = itemData.gameTypeId!;
    }
    return Container(
      margin: EdgeInsets.only(
          top: 26.h, bottom: controller.betList.length == index + 1 ? 30.h : 0),
      padding: EdgeInsets.all(40.h),
      decoration: BoxDecoration(
          color: context.customTheme?.pageTwoBg,
          borderRadius: BorderRadius.circular(30.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$playName / $gameName',
                // controller.getReqTypeId() == 1
                //     ? ('${itemData.playTypeId}/${itemData.gameTypeId}')
                //     : controller.getBetItemName(index),
                style: TextStyle(
                    fontSize: 45.sp,
                    fontWeight: FontWeight.w400,
                    color: context.customTheme?.titleColor),
              ),
              Text(
                controller.getReqTypeId() == 6
                    ? (itemData.settle_flag == "0" ? '未结算' : '已结算')
                    : '已结算',
                style: TextStyle(
                  fontSize: 36.sp,
                  // color: const Color(colorDD9D51),
                  color: context.theme.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40.h,
          ),
          RichText(
              text: TextSpan(
                  text: "投注项：",
                  style: TextStyle(
                      fontSize: 36.sp, color: context.customTheme?.title2Color),
                  children: [
                TextSpan(
                  // text: controller.getBetItem(itemData),
                  text: '${gameName}',
                  style: TextStyle(color: context.customTheme?.titleColor),
                )
              ])),
          SizedBox(
            height: 20.h,
          ),
          Row(
            children: [
              RichText(
                  text: TextSpan(
                      text: "投注金额：",
                      style: TextStyle(
                          fontSize: 36.sp,
                          color: context.customTheme?.title2Color),
                      children: [
                    TextSpan(
                        text:
                            "￥${parseNumber((itemData.effectiveBets ?? 0) / 1000)}",
                        style:
                            TextStyle(color: context.customTheme?.titleColor))
                  ])),
              SizedBox(
                width: 150.w,
              ),
              _buildWinLossAmount(context, itemData),
            ],
          ),
          Divider(
            height: 60.h,
            color: context.customTheme?.lineColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                      // "订单号：${controller.getReqTypeId() == 1 ? itemData.platformOrderId : showOrHideAccount(index)}",
                      "订单号：${showOrHideAccount(index)}",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 33.sp,
                          color: context.customTheme?.title3Color)),
                  SizedBox(
                    width: 20.w,
                  ),
                  CommonRipple(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      ClipboardUtil.copy(itemData.platformOrderId);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                      child: SvgPicture.asset(
                        Assets.theme1.images.common.copySn,
                        width: 30.w,
                        height: 30.h,
                      ),
                    ),
                  )
                ],
              ),
              Text(
                  "交易时间：${itemData.betStartTime! is num ? DateTimeUtils.formatTimestamp(itemData.betStartTime!) : itemData.betStartTime!}",
                  style: TextStyle(
                      fontSize: 30.sp, color: context.customTheme?.title3Color))
            ],
          )
        ],
      ),
    );
  }

  RichText _buildWinLossAmount(BuildContext context, BetItem itemData) {
    var amount = (itemData.profitLoss is String
            ? (num.parse(itemData.profitLoss ?? "0"))
            : (itemData.profitLoss is num ? itemData.profitLoss : 0)) /
        1000;
    String amountText = '';
    Color amountColor = const Color(color888888);
    if (amount == 0) {
      amountText = '￥${parseNumber(amount)}';
    } else if (amount > 0) {
      amountText = '赢 ￥${parseNumber(amount)}';
      amountColor = const Color(colorD62C2C);
    } else {
      amountText = '输 ￥${parseNumber(-amount)}';
      amountColor = const Color(color2BA02E);
    }
    return RichText(
      text: TextSpan(
        text: "输赢金额：",
        style:
            TextStyle(fontSize: 36.sp, color: context.customTheme?.title2Color),
        children: [
          TextSpan(
            text: amountText,
            style: TextStyle(
              color: amountColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSelectButton(BuildContext context,
      {VoidCallback? onTap, Key? key, required RxString showName}) {
    return CommonRipple(
      onTap: onTap,
      child: Container(
        key: key,
        decoration: BoxDecoration(
            color: context.customTheme?.selectBoxColor,
            borderRadius: BorderRadius.circular(71.r),
            border: Border.all(
                color: context.customTheme?.lineColor ?? Colors.white)),
        height: 104.h,
        padding: EdgeInsets.only(left: 30.w, right: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Obx(
                () => Text(
                  showName.value,
                  style: TextStyle(
                    fontSize: 42.sp,
                    color: context.customTheme?.title3Color,
                    height: 1,
                  ),
                  maxLines: 2,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(colorBCBCBC),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildTimeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: controller.timeList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.92,
        crossAxisSpacing: 18.w,
        mainAxisSpacing: 18.w,
      ),
      itemBuilder: (context, index) {
        return CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              controller.changeTimeIndex(index);
              FundingTypePopWidget.instance.hide();
              controller.updateTime();
            },
            child: Obx(
              () => Container(
                alignment: Alignment.center,
                height: 118.h,
                decoration: BoxDecoration(
                    color: controller.currentTimeIndex.value == index
                        ? context.theme.primaryColor
                        : context.customTheme?.pageTwoBg,
                    borderRadius: BorderRadius.circular(27.r)),
                child: Text("${controller.timeList[index]["timeTitle"]}",
                    style: TextStyle(
                        fontSize: 42.sp,
                        color: controller.currentTimeIndex.value == index
                            ? context.customTheme?.msTextColor
                            : context.customTheme?.mnTextColor)),
              ),
            ));
      },
    );
  }

  _buildPlatformGrid() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: controller.tabList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.92,
        crossAxisSpacing: 18.w,
        mainAxisSpacing: 18.w,
      ),
      itemBuilder: (context, index) {
        return CommonRipple(
            onTap: () {
              if (controller.currentTabIndex != index) {
                AppManager.instance.tapVibrate();
              }
              controller.changeTabIndex(index);
              controller.currentPlatformName.value =
                  controller.tabList[index].title;
              FundingTypePopWidget.instance.hide();
            },
            child: Obx(
              () => Container(
                alignment: Alignment.center,
                height: 118.h,
                decoration: BoxDecoration(
                    color: controller.currentTabIndex == index
                        ? context.theme.primaryColor
                        : context.customTheme?.pageTwoBg,
                    borderRadius: BorderRadius.circular(27.r)),
                child: Text(
                  "${controller.tabList[index].title}",
                  style: TextStyle(
                      fontSize: 42.sp,
                      color: controller.currentTabIndex == index
                          ? context.customTheme?.msTextColor
                          : context.customTheme?.mnTextColor),
                ),
              ),
            ));
      },
    );
  }

  // _buildStatusGrid() {
  //   return GridView.builder(
  //     shrinkWrap: true,
  //     padding: EdgeInsets.zero,
  //     itemCount: controller.statusList.length,
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 3,
  //       childAspectRatio: 2.92,
  //       crossAxisSpacing: 18.w,
  //       mainAxisSpacing: 18.w,
  //     ),
  //     itemBuilder: (context, index) {
  //       return CommonRipple(
  //           onTap: () {
  //             controller.changeStatusIndex(index);
  //             FundingTypePopWidget.instance.hide();
  //             controller.updateStatus();
  //           },
  //           child: Obx(
  //             () => Container(
  //               alignment: Alignment.center,
  //               height: 118.h,
  //               decoration: BoxDecoration(
  //                   color: controller.currentStatusIndex.value == index
  //                       ? const Color(theme01MainColor)
  //                       : const Color(colorF4F4F4),
  //                   borderRadius: BorderRadius.circular(27.r)),
  //               child: Text(
  //                 "${controller.statusList[index]}",
  //                 style: TextStyle(
  //                     fontSize: 42.sp,
  //                     color: controller.currentStatusIndex.value == index
  //                         ? Colors.white
  //                         : const Color(color6D6D6D)),
  //               ),
  //             ),
  //           ));
  //     },
  //   );
  // }

  _buildTypeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: controller.platformList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.92,
        crossAxisSpacing: 18.w,
        mainAxisSpacing: 18.w,
      ),
      itemBuilder: (context, index) {
        return CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              controller.changeTypeIndex(index);
              FundingTypePopWidget.instance.hide();
              controller.updateType();
            },
            child: Container(
              alignment: Alignment.center,
              height: 118.h,
              decoration: BoxDecoration(
                  color: controller.currentTypeIndex.value == index
                      ? context.theme.primaryColor
                      : context.customTheme?.pageTwoBg,
                  borderRadius: BorderRadius.circular(27.r)),
              child: Text(
                "${controller.platformList[index].play_cname}",
                style: TextStyle(
                    fontSize: 42.sp,
                    color: controller.currentTypeIndex.value == index
                        ? context.customTheme?.msTextColor
                        : context.customTheme?.mnTextColor),
              ),
            ));
      },
    );
  }

  //构建选择弹窗的列表
  Widget _buildSelectList(BuildContext context,
      {required Widget child, VoidCallback? clickClose}) {
    return CommonRipple(
      onTap: clickClose,
      child: Container(
        width: 1.sw,
        height: 1.sh,
        alignment: Alignment.topCenter,
        color: Colors.black.withOpacity(0.4),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: context.customTheme?.selectBoxColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.r),
                        bottomRight: Radius.circular(40.r))),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
                alignment: Alignment.center,
                child: child),
            SizedBox(
              height: 40.h,
            ),
            CommonRipple(
              onTap: clickClose,
              child: SvgPicture.asset(
                Assets.theme1.images.user.iconClosePop,
                width: 68.w,
                height: 44.h,
              ),
            )
          ],
        ),
      ),
    );
  }

  //显示或者隐藏账号
  String showOrHideAccount(int index) {
    String tempStr = "";
    tempStr = controller.betList[index].platformOrderId!
        .toString()
        .replaceRange(
            6,
            controller.betList[index].platformOrderId!.toString().length - 4,
            '...');
    return tempStr;
  }

  void dismissPop() {
    if (FundingTypePopWidget.instance.isShowing()) {
      FundingTypePopWidget.instance.hide();
    }
  }
}
