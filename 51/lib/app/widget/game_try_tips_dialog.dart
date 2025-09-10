import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../../utils/CommonRipple.dart';

//游戏试玩提示弹窗
class GameTryTipsDialog extends StatelessWidget {
  final VoidCallback? clickTry;
  final VoidCallback? clickLogin;

  const GameTryTipsDialog({
    super.key,
    this.clickTry,
    this.clickLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 200.w),
      child: Container(
        height: 520.h,
        padding: EdgeInsets.only(top: 30.h, left: 38.w, right: 38.w),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40.r)),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  Get.back();
                },
                child: const Icon(Icons.close),
              ),
            ),
            Text(
              "温馨提示",
              style: TextStyle(
                fontSize: 45.sp,
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
            Text(
              "试玩额度不能用于取款哦",
              style: TextStyle(
                fontSize: 45.sp,
              ),
            ),
            SizedBox(
              height: 90.h,
            ),
            Row(
              children: [
                Expanded(
                  child: CommonRipple(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      Get.back();
                      clickTry?.call();
                    },
                    child: Container(
                      height: 105.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(theme01MainColor),
                          borderRadius: BorderRadius.circular(30.r)),
                      child: Text(
                        "立即试玩",
                        style: TextStyle(fontSize: 42.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 40.w,
                ),
                Expanded(
                    child: CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                    clickLogin?.call();
                  },
                  child: Container(
                    height: 105.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Colors.black26)),
                    child: Text(
                      "登录",
                      style: TextStyle(fontSize: 42.sp),
                    ),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
