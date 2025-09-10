import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_collection_controller.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:get/get.dart';

import '../../../../../utils/CommonRipple.dart';

class ActivityBounsDialog extends StatefulWidget {
  final Function(dynamic)? onClose;

  const ActivityBounsDialog({Key? key, this.onClose}) : super(key: key);

  @override
  State<ActivityBounsDialog> createState() => _ActivityBounsDialogState();
}

class _ActivityBounsDialogState extends State<ActivityBounsDialog>
    with TickerProviderStateMixin {
  final ActivityCollectionController controller = Get.find();

  bool show = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.transparent.withOpacity(0),
            ),
          ),
          Align(
            // 使用 Align 包裹 Positioned
            alignment: Alignment.bottomCenter, // 居中
            child: Column(
              mainAxisSize: MainAxisSize.min, // 使 Column 仅占用所需空间
              children: [
                Container(
                  width: 1.sw,
                  // height: 1000.h,
                  decoration: BoxDecoration(
                    color: context.customTheme?.dialogBgColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r)),
                  ),
                  // alignment: Alignment.center,
                  child: _buildLeaderboard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40.h),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            '类型筛选',
            style: TextStyle(
              color: context.customTheme?.titleColor,
              fontSize: 33.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.r),
                    bottomRight: Radius.circular(40.r))),
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
            alignment: Alignment.center,
            child: _buildTypeGrid()),
        SizedBox(height: 40.h),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            '状态筛选',
            style: TextStyle(
              color: context.customTheme?.titleColor,
              fontSize: 33.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.r),
                    bottomRight: Radius.circular(40.r))),
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
            alignment: Alignment.center,
            child: _buildStatusGrid()),
        SizedBox(height: 30.h),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centers the buttons in the Row
            children: [
              Container(
                height: 45, // Set height to 50
                width: MediaQuery.of(context).size.width /
                    3, // Set width to screen width / 4
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: context.theme.primaryColor,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '取消',
                    style: TextStyle(
                      color: context.theme.primaryColor,
                    ),
                  ),
                ),
              ).onTap(() {Get.back();}),
              const SizedBox(width: 10), // Add spacing between buttons
              Container(
                height: 45, // Set height to 50
                width: MediaQuery.of(context).size.width /
                    3, // Set width to screen width / 4
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  color: context.theme.primaryColor,
                ),
                child: const Center(
                  child: Text(
                    '确定',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ).onTap(() {controller.reLoadData(); Get.back();}),
            ],
          ),
        )
      ],
    );
  }

  _buildTypeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: controller.typeOptions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.92,
        crossAxisSpacing: 18.w,
        mainAxisSpacing: 18.w,
      ),
      itemBuilder: (context, index) {
        return CommonRipple(
            onTap: () {
              controller.currentTypeIndex.value = index;
            },
            child: Obx(
              () => Container(
                alignment: Alignment.center,
                height: 118.h,
                decoration: BoxDecoration(
                    color: controller.currentTypeIndex.value == index
                        ? context.theme.primaryColor
                        : context.customTheme?.selectBoxColor,
                    borderRadius: BorderRadius.circular(27.r)),
                child: Text(
                  "${controller.typeOptions[index]["text"]}",
                  style: TextStyle(
                      fontSize: 42.sp,
                      color: controller.currentTypeIndex.value == index
                          ? context.customTheme?.msTextColor
                          : context.customTheme?.mnTextColor),
                ),
              ),
            ));
      },
    );
  }

  _buildStatusGrid() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: controller.statusOptions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.92,
        crossAxisSpacing: 18.w,
        mainAxisSpacing: 18.w,
      ),
      itemBuilder: (context, index) {
        return CommonRipple(
            onTap: () {
              controller.currentStatusIndex.value = index;
            },
            child: Obx(
              () => Container(
                alignment: Alignment.center,
                height: 118.h,
                decoration: BoxDecoration(
                    color: controller.currentStatusIndex.value == index
                        ? context.theme.primaryColor
                        : context.customTheme?.selectBoxColor,
                    borderRadius: BorderRadius.circular(27.r)),
                child: Text(
                  "${controller.statusOptions[index]["text"]}",
                  style: TextStyle(
                      fontSize: 42.sp,
                      color: controller.currentStatusIndex.value == index
                          ? context.customTheme?.msTextColor
                          : context.customTheme?.mnTextColor),
                ),
              ),
            ));
      },
    );
  }
}
