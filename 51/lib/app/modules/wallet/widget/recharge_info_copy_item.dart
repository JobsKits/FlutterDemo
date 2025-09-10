import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_list_item_widget.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/clipboard_util.dart';
import 'package:get/get.dart';
// import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';

class RechargeInfoCopyItem extends StatelessWidget {
  const RechargeInfoCopyItem(
      {super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(bottom: 20.h),
          child: Text(
            title,
            style: TextStyle(color: const Color(color2C2C2C), fontSize: 46.sp),
          ),
        ),
        Container(
          height: 118.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.sp),
              color: context.customTheme?.pageBg),
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          margin: EdgeInsets.only(bottom: 20.h),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(right: 30.w),
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: 46.sp,
                      color: context.customTheme?.rechargeSecondTypeBgColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    AppManager.instance.tapVibrate();
                    ClipboardUtil.copy(content);
                  },
                  style: ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(Size(120.w, 68.h)),
                      backgroundColor: WidgetStatePropertyAll(
                          context.customTheme?.pageTwoBg),
                      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      )),
                  child: Text(
                    '复制',
                    style: TextStyle(
                        color: context.theme.primaryColor, fontSize: 36.sp),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
