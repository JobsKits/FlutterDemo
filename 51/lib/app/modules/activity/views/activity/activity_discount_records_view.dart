import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_discount_records_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_discount_records_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/funding_type_pop_widget.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

///活动页面
class ActivityDiscountRecordsView
    extends GetView<ActivityDiscountRecordsController> {
  const ActivityDiscountRecordsView({super.key});

  @override
  build(BuildContext context) {
    if (!Get.isRegistered<ActivityDiscountRecordsController>()) {
      Get.put(ActivityDiscountRecordsController());
    }
    return Scaffold(
      backgroundColor: const Color(colorF4F4F4),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            dismissPop();
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          '申请记录',
          style: TextStyle(
            fontSize: 57.sp,
            color: const Color(0xFF2D2D2D),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    return Container(
      margin: EdgeInsets.only(top: 38.h, right: 33.w, left: 33.w),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    dismissPop();
                    FundingTypePopWidget.instance.show(
                        context, _buildTimeList(),
                        top: controller.timeWidgetHeight);
                  },
                  child: Container(
                    key: controller.timeKey,
                    decoration: BoxDecoration(
                        color: const Color(colorF8F8F8),
                        borderRadius: BorderRadius.circular(71.r),
                        border: Border.all(color: Colors.white)),
                    height: 104.h,
                    width: 330.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(() => Text("${controller.currentTimeName.value}")),
                        const Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                  )),
            ],
          ),
          Expanded(child: _buildMergedList()),
        ],
      ),
    );
  }

  Widget _buildMergedList() {
    return Obx(() {
      if (controller.recordsModel.value.data == null ||
          controller.recordsModel.value.data!.isEmpty) {
        return emptyWidget();
      }

      return ListView.builder(
        itemCount: controller.recordsModel.value.data?.length ?? 0,
        itemBuilder: (context, index) {
          var item = controller.recordsModel.value.data?[index];
          print({'ceshi331 ========= $item'});
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(top: 28.h),
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
                        item?.activityName ?? '',
                        style: TextStyle(
                          fontSize: 48.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateTimeUtils.formatTimestamp(item?.applyTime ?? 0,
                            temp: 'yyyy-MM-dd hh:ss:mm'),
                        style: TextStyle(
                          fontSize: 36.sp,
                          color: const Color(colorA0A0A0),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item?.status == '0' || item?.status == '3'
                      ? '审核中'
                      : item?.status == '1'
                          ? '已通过'
                          : '已拒绝',
                  style: TextStyle(
                    color: item?.status == '0' ||
                            item?.status == '1' ||
                            item?.status == '3'
                        ? const Color(theme01MainColor)
                        : Colors.red,
                    fontSize: 48.sp,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 50.w,
                ),
              ],
            ),
          ).onTap(() {
                Get.dialog(
                  ActivityDiscountRecordsDialog(
                    item: item,
                  ),
                  barrierDismissible: false,
                );
              });
        },
      );
    });
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

  Widget _buildTimeList() {
    return InkWell(
      onTap: () {
        AppManager.instance.tapVibrate();
        FundingTypePopWidget.instance.hide();
      },
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
              child: GridView.builder(
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
                  return InkWell(
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
                                  ? const Color(theme01MainColor)
                                  : const Color(colorF4F4F4),
                              borderRadius: BorderRadius.circular(27.r)),
                          child: Text(
                            "${controller.timeList[index]["timeTitle"]}",
                            style: TextStyle(
                                fontSize: 42.sp,
                                color:
                                    controller.currentTimeIndex.value == index
                                        ? Colors.white
                                        : const Color(color6D6D6D)),
                          ),
                        ),
                      ));
                },
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            InkWell(
              onTap: () {
                AppManager.instance.tapVibrate();
                FundingTypePopWidget.instance.hide();
              },
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

  void dismissPop() {
    if (FundingTypePopWidget.instance.isShowing()) {
      FundingTypePopWidget.instance.hide();
    }
  }
}
