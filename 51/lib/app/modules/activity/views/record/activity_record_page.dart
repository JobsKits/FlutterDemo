import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_record_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/funding_type_pop_widget.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:get/get.dart';

import '../../../../../utils/CommonRipple.dart';

/// VIP页面
class ActivityRecordPage extends StatefulWidget {
  const ActivityRecordPage({super.key});

  @override
  State<ActivityRecordPage> createState() => _ActivityRecordPageState();
}

class _ActivityRecordPageState extends State<ActivityRecordPage> {
  final ActivityRecordController controller =
      Get.put(ActivityRecordController());

  @override
  void dispose() {
    Get.delete<ActivityRecordController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildTimeView(context)),
                const SizedBox(width: 10),
                Expanded(child: _buildTypeView(context)),
                const Spacer(),
                const Text(
                  "奖金: ",
                  style: const TextStyle(fontSize: 12),
                ),
                Obx(() => Text(
                      controller.recordDatas.value.t == null
                          ? '0.00'
                          : (controller.recordDatas.value.t!.toDouble() /
                                  1000.00)
                              .truncateToFixed(2),
                      style: TextStyle(
                          fontSize: 12, color: context.theme.primaryColor),
                    ))
              ],
            )),
        Expanded(
          child: _buildList(),
        ),
      ],
    );
  }

  Widget _buildTimeView(context) {
    return _buildSelectButton(context, onTap: () {
      AppManager.instance.tapVibrate();
      dismissPop();
      FundingTypePopWidget.instance.show(
          context,
          _buildSelectList(
              child: _buildTimeGrid(),
              clickClose: () {
                AppManager.instance.tapVibrate();
                FundingTypePopWidget.instance.hide();
              }),
          top: controller.timeWidgetHeight);
    }, key: controller.timeKey, showName: controller.selectDate);
  }

  _buildTimeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: controller.date.length,
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
              controller.currentTimeIndex.value = index;
              FundingTypePopWidget.instance.hide();
              dynamic item = controller.date[index];
              controller.selectedGame(item['value'], 'date');
            },
            child: Obx(
              () => Container(
                alignment: Alignment.center,
                height: 118.h,
                decoration: BoxDecoration(
                    color: controller.currentTimeIndex.value == index
                        ? context.theme.primaryColor
                        : const Color(colorF4F4F4),
                    borderRadius: BorderRadius.circular(27.r)),
                child: Text(
                  "${controller.date[index]["name"]}",
                  style: TextStyle(
                      fontSize: 42.sp,
                      color: controller.currentTimeIndex.value == index
                          ? Colors.white
                          : const Color(color6D6D6D)),
                ),
              ),
            ));
      },
    );
  }

  Widget _buildTypeView(context) {
    return _buildSelectButton(context, onTap: () {
      AppManager.instance.tapVibrate();
      dismissPop();
      FundingTypePopWidget.instance.show(
          context,
          _buildSelectList(
              child: _buildTypeGrid(),
              clickClose: () {
                AppManager.instance.tapVibrate();
                FundingTypePopWidget.instance.hide();
              }),
          top: controller.typeWidgetHeight);
    }, key: controller.typeKey, showName: controller.selectStatus);
  }

  _buildTypeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: controller.status.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.92,
        crossAxisSpacing: 18.w,
        mainAxisSpacing: 18.w,
      ),
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              AppManager.instance.tapVibrate();
              controller.currentTypeIndex.value = index;
              FundingTypePopWidget.instance.hide();
              dynamic item = controller.status[index];
              controller.selectedGame(item['value'], 'status');
            },
            child: Obx(
              () => Container(
                alignment: Alignment.center,
                height: 118.h,
                decoration: BoxDecoration(
                    color: controller.currentTypeIndex.value == index
                        ? context.theme.primaryColor
                        : const Color(colorF4F4F4),
                    borderRadius: BorderRadius.circular(27.r)),
                child: Text(
                  "${controller.status[index]["name"]}",
                  style: TextStyle(
                      fontSize: 42.sp,
                      color: controller.currentTypeIndex.value == index
                          ? Colors.white
                          : const Color(color6D6D6D)),
                ),
              ),
            ));
      },
    );
  }

  Widget _buildSelectButton(context,
      {VoidCallback? onTap, Key? key, required RxString showName}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        key: key,
        decoration: BoxDecoration(
            color: const Color(colorF8F8F8),
            borderRadius: BorderRadius.circular(71.r),
            border: Border.all(color: Colors.white)),
        height: 104.h,
        padding: EdgeInsets.only(left: 30.w, right: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Obx(
                () => Text(
                  textAlign: TextAlign.center,
                  showName.value,
                  style: TextStyle(
                    fontSize: 38.sp,
                    color: const Color(color6B6B6B),
                    height: 1,
                  ),
                  maxLines: 2,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color(colorBCBCBC),
            )
          ],
        ),
      ),
    );
  }

  //构建选择弹窗的列表
  Widget _buildSelectList({required Widget child, VoidCallback? clickClose}) {
    return InkWell(
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
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.r),
                        bottomRight: Radius.circular(40.r))),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
                alignment: Alignment.center,
                child: child),
            SizedBox(
              height: 40.h,
            ),
            InkWell(
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

  Widget _buildList() {
    return Obx(() => controller.recordDatas.value.data != null
        ? ListView.builder(
            itemCount: controller.recordDatas.value.data?.length,
            itemBuilder: (context, index) {
              var item = controller.recordDatas.value.data?[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  color: Colors.white,
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
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            // "¥${(item?.receiveAmount ?? 0.00).toString()}",
                            '¥${(item!.receiveAmount! / 1000).truncateToFixed(2)}',
                            style: TextStyle(
                                fontSize: 48.sp,
                                color: context.theme.primaryColor),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "领取时间：${DateTimeUtils.formatTimestamp(item.createTime ?? 0)}",
                            style: TextStyle(
                                fontSize: 36.sp,
                                color: const Color(colorA0A0A0)),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        AppManager.instance.tapVibrate();
                        // Button action
                        if (item.state == 1) {
                          controller.reqActivityReceive(item.receiveLogId ?? 0);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item.state == 1
                            ? context.theme.primaryColor
                            : const Color(colorD4D4D4),
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        minimumSize: Size(0, 80.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Text(
                        backStateWithName(item.state ?? 0),
                        style: TextStyle(
                          color: item.state == 1
                              ? Colors.white
                              : const Color(color888888),
                          fontSize: 35.sp,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          )
        : emptyWidget());
  }

  String backStateWithName(int state) {
    switch (state) {
      case 0:
        return '已领取';
      case 1:
        return '未领取';
      case 5:
        return '已派发';
    }
    return '已领取';
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
