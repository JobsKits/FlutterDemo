import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

class CommonDialog extends StatelessWidget {
  final String title;
  final VoidCallback? clickOk;
  final bool? isLoading;
  final bool? isLandscape; //是否是横屏

  const CommonDialog({
    super.key,
    required this.title,
    this.clickOk,
    this.isLoading,
    this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 200.w),
      child: Container(
        height: (isLandscape ?? false) ? 720.h : 520.h,
        padding: EdgeInsets.only(top: 30.h, left: 38.w, right: 38.w),
        width: double.infinity,
        decoration: BoxDecoration(
            color: context.customTheme?.dialogBgColor,
            borderRadius: BorderRadius.circular(40.r)),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  Get.back();
                },
                child:
                    Icon(Icons.close, color: context.customTheme?.dialogXColor),
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 45.sp,
                color: context.customTheme?.titleColor,
              ),
            ),
            SizedBox(
              height: 130.h,
            ),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                  },
                  child: Container(
                    height: (isLandscape ?? false) ? 205.h : 105.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: const Color(colorF4F4F4))),
                    child: Text(
                      "取消",
                      style: TextStyle(
                          fontSize: 42.sp, color: const Color(colorCECECE)),
                    ),
                  ),
                )),
                SizedBox(
                  width: 40.w,
                ),
                Expanded(
                  child: InkWell(
                    onTap: isLoading == true ? null : clickOk,
                    child: Container(
                      height: (isLandscape ?? false) ? 205.h : 105.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: isLoading == true
                              ? context.theme.primaryColor.withOpacity(0.7)
                              : context.theme.primaryColor,
                          borderRadius: BorderRadius.circular(30.r)),
                      child: isLoading == true
                          ? SizedBox(
                              width: 48.w,
                              height: 48.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 4.w,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(colorFFFFFF)), // 圆圈颜色
                              ),
                            )
                          : Text(
                              "确定",
                              style: TextStyle(
                                  fontSize: 42.sp, color: Colors.white),
                            ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
