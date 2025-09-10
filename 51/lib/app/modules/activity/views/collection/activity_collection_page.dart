import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_collection_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/collection/activity_bouns_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_count_timer.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/funding_type_pop_widget.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:get/get.dart';

/// VIP页面
class ActivityCollectionPage extends StatefulWidget {
  const ActivityCollectionPage({super.key});

  @override
  State<ActivityCollectionPage> createState() => _ActivityCollectionPageState();
}

class _ActivityCollectionPageState extends State<ActivityCollectionPage> {
  final ActivityCollectionController controller =
      Get.put(ActivityCollectionController());

  @override
  void dispose() {
    Get.delete<ActivityCollectionController>();
    super.dispose();
  }

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
              "福利中心",
              style: TextStyle(color: context.customTheme?.appbarText),
            ),
            centerTitle: true,
          ),
          body: _buildBody(context),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft, // 设置为居左对齐
          child: _buildFilter(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Align(
            alignment: Alignment.centerLeft, // 设置为居左对齐
            child: _buildBalance(context),
          ),
        ),
        Expanded(child: _buildMergedList()),
      ],
    );
  }

  Widget _buildFilter(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 40,
          color: context.customTheme?.navbarBg,
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  // color: const Color(theme01MainColor),
                  border: Border.all(
                    color: context.theme.primaryColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  '全部',
                  style: TextStyle(
                    color: context.theme.primaryColor,
                  ),
                ),
              ).onTap(() {controller.resetData();}),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: 1, // Thickness of the vertical line
                    height: 25, // Height of the vertical line
                    color: context.theme.primaryColor,
                  )),
              if (controller.typeName.value.isNotEmpty) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: context.customTheme?.pageTwoBg,
                  ),
                  child: Row(
                    children: [
                      Text(
                        controller.typeName.value,
                        style: TextStyle(
                          color: context.customTheme?.titleColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.close_sharp,
                        color: context.customTheme?.titleColor,
                        size: 20,
                      ).onTap(() {controller.resetData(idx: 1);})
                    ],
                  ),
                )
              ],
              const SizedBox(width: 15),
              if (controller.statusName.value.isNotEmpty) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: context.customTheme?.pageTwoBg,
                  ),
                  child: Row(
                    children: [
                      Text(
                        controller.statusName.value,
                        style: TextStyle(
                          color: context.customTheme?.titleColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.close_sharp,
                        color: context.customTheme?.titleColor,
                        size: 20,
                      ).onTap(() {controller.resetData(idx: 2);})
                    ],
                  ),
                ),
              ],
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  color: context.customTheme?.selectBoxColor,
                ),
                child: Row(
                  children: [
                    Text(
                      '筛选',
                      style: TextStyle(
                        color: context.customTheme?.titleColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.expand_more,
                      color: context.customTheme?.titleColor,
                      size: 20,
                    )
                  ],
                ),
              ).onTap(() => Get.dialog(
                    const ActivityBounsDialog(),
                    barrierDismissible: false,
                  )),
            ],
          ),
        ));
  }

  Widget _buildBalance(BuildContext context) {
    return Obx(() => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft, // Start from left
              end: Alignment.centerRight, // End at right
              colors: [
                context.theme.primaryColor
                    .withOpacity(0.3), // Right side (lighter)
                context.theme.primaryColor, // Left side (stronger)
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 80.h, horizontal: 40.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '笔数：${controller.collections.length}    ${calculateTotalReward() / 1000} CNY',
                      style: TextStyle(
                          fontSize: 48.sp,
                          color: context.customTheme?.titleColor,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Image.asset(
                          Assets.theme1.images.activity.vip.iconPromotion.path,
                          width: 44.w,
                          height: 44.h,
                          color: context.theme.primaryColor,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "您有${controller.collections.length}个待领取奖励",
                          style: TextStyle(
                              fontSize: 36.sp,
                              color: context.customTheme?.title3Color),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: 110,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60.r),
                  gradient: LinearGradient(
                    colors: controller.collections.isNotEmpty
                        ? [
                            context.theme.primaryColor,
                            context.theme.primaryColor
                          ]
                        : [const Color(colorD4D4D4), const Color(colorD4D4D4)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: controller.collections.isNotEmpty
                          ? context.theme.primaryColor.withOpacity(0.5)
                          : const Color(colorD4D4D4).withOpacity(0.5),
                      offset: Offset(0, 10.w), // Increased vertical offset
                      blurRadius: 20.w, // Increased blur radius
                      spreadRadius: 2
                          .w, // Added spread radius to make shadow more visible
                    ),
                    // Optional: Add a subtle inner shadow for depth
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 4.w),
                      blurRadius: 4.w,
                      spreadRadius: 3.w,
                    ),
                  ],
                ),
                height: 100.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.collections.isNotEmpty) {
                      controller.reqReceivedAllBouns();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.r),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: double.infinity,
                    child: Text(
                      '一键领取',
                      style: TextStyle(
                        fontSize: 38.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  double calculateTotalReward() {
    return controller.collections.fold(0.0, (sum, item) {
      // 将每个 item 的 reward 相加
      return sum + (item.reward ?? 0.0);
    });
  }

  Widget _buildMergedList() {
    return Obx(() {
      // 检查两个数据源是否都为空
      if (controller.collections.isEmpty &&
          (controller.receivedDatas.value.data == null ||
              controller.receivedDatas.value.data!.isEmpty)) {
        return emptyWidget(); // 展示空状态组件
      }

      return ListView.builder(
        itemCount: (controller.collections.length +
            (controller.receivedDatas.value.data?.length ?? 0)),
        itemBuilder: (context, index) {
          // 如果 index 在 collections 范围内，渲染 collections 数据
          if (index < controller.collections.length) {
            var item = controller.collections[index];
            Map<String, dynamic> decoded = json.decode(item.receiveType ?? '');

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: context.customTheme?.pageTwoBg,
              ),
              margin: EdgeInsets.only(top: 28.h, left: 45.w, right: 45.w),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          item.receiveName ?? '',
                          style: TextStyle(
                            fontSize: 48.sp,
                            color: context.customTheme?.titleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '¥${(item.reward! / 1000).truncateToFixed(2)}',
                          style: TextStyle(
                            fontSize: 48.sp,
                            color: context.theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${DateTimeUtils.formatTimestamp(item.receiveStartTime ?? 0, temp: 'yyyy-MM-dd hh:ss:mm')}",
                          style: TextStyle(
                            fontSize: 36.sp,
                            color: context.customTheme?.title3Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (item.receiveEndTime != null) ... [
                        ActivityCountTimer(
                          startTime: DateTime.now().millisecondsSinceEpoch,
                          endTime: item.receiveEndTime,
                          timeFormat: true,
                          lastStr: '过期',
                          fontColor: Colors.black)
                      ],
                      ElevatedButton(
                        onPressed: () {
                          if (decoded['type'] == 5) {
                            Get.back();
                            controller.hcController.pushToActivity('VIP');
                          } else {
                            controller.reqCollectionReceive(decoded['type'], item);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(theme01MainColor),
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          minimumSize: Size(0, 80.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          backStateWithName(decoded['type']),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35.sp,
                          ),
                        ),
                      ),
                  ])
                ],
              ),
            );
          }
          // 否则，渲染 receivedDatas 数据
          else {
            var item = controller.receivedDatas.value
                .data?[index - controller.collections.length];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: context.customTheme?.pageTwoBg,
              ),
              margin: EdgeInsets.only(top: 28.h, left: 33.w, right: 33.w),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          item?.tasksName ?? item?.activityName ?? '',
                          style: TextStyle(
                            fontSize: 48.sp,
                            color: context.customTheme?.titleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          formatAmount(item?.receiveAmount ?? 0),
                          style: TextStyle(
                            fontSize: 48.sp,
                            color: context.theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${DateTimeUtils.formatTimestamp(item?.createTime ?? 0)}",
                          style: TextStyle(
                            fontSize: 36.sp,
                            color: context.customTheme?.title3Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (item?.state == 1) {
                        controller.reqActivityReceive(item?.receiveLogId ?? 0);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item?.state == 1
                          ? context.theme.primaryColor
                          : context.theme.primaryColor.withOpacity(0.5),
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      minimumSize: Size(0, 80.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    child: Text(
                      reviceStateWithName(item?.state ?? 0),
                      style: TextStyle(
                        color: item?.state == 1
                            ? Colors.white
                            : context.customTheme?.titleColor,
                        fontSize: 35.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      );
    });
  }

  String formatAmount(int receiveAmount) {
    double amount = receiveAmount / 1000;
    // 将数字转换为字符串，并截取前两位小数
    double amountString = (amount * 100).truncateToDouble() / 100;
    return '¥${amountString.truncateToFixed(2)}';
  }

  String reviceStateWithName(int state) {
    switch (state) {
      case 0:
        return '已领取';
      case 1:
        return '未领取';
      case 4:
        return '已过期';
      case 5:
        return '已派发';
    }
    return '已领取';
  }

  String backStateWithName(int state) {
    switch (state) {
      case 5:
        return '领取';
    }
    return '领取';
  }

  Widget emptyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 300.h,
        ),
        Image.asset(
          Assets.theme1.images.user.noFundingDataBg.path,
          width: 480.w,
          height: 339.h,
        ),
        SizedBox(
          height: 76.h,
        ),
        Text(
          "暂无任何数据",
          style: TextStyle(fontSize: 36.sp, color: const Color(colorAAAFBB)),
        )
      ],
    );
  }

  void dismissPop() {
    if (FundingTypePopWidget.instance.isShowing()) {
      FundingTypePopWidget.instance.hide();
    }
  }
}
