import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';

class LuckyWheelDialog extends StatelessWidget {
  final unLoginOrPointNotEnough; //没有登录 或者 积分不足 两种情况，所以用bool类型值来判断，默认为false，表示没有登录的方式， true表示已登录，积分不足
  const LuckyWheelDialog({super.key, required this.unLoginOrPointNotEnough});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 890.w,
        height: 620.h,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 70.w, right: 70.w, top: 55.h, bottom: 50.h),
              child: Column(
                children: [
                  Text("温馨提示", style: TextStyle(fontSize: 51.sp)),
                  SizedBox(
                    height: 80.h,
                  ),
                  Text(
                    unLoginOrPointNotEnough
                        ? "您的积分不足\n请获取积分后再参与!"
                        : "您还未登录账号，无法参加活动\n请登录后再参与!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 45.sp, color: Colors.red),
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                  unLoginOrPointNotEnough
                      ? Container(
                          height: 115.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(66.r)),
                          child: Text(
                            "获取积分",
                            style:
                                TextStyle(fontSize: 54.sp, color: Colors.white),
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                                child: Container(
                              height: 115.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(66.r)),
                              child: Text(
                                "注册",
                                style: TextStyle(
                                    fontSize: 54.sp, color: Colors.white),
                              ),
                            )),
                            SizedBox(
                              width: 50.w,
                            ),
                            Expanded(
                                child: Container(
                              height: 115.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(66.r)),
                              child: Text(
                                "登录",
                                style: TextStyle(
                                    fontSize: 54.sp, color: Colors.white),
                              ),
                            )),
                          ],
                        )
                ],
              ),
            ),
            Positioned(
              right: 38.w,
              top: 38.h,
              child: CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  Get.back();
                },
                child: const Icon(Icons.close),
              ),
            )
          ],
        ),
      ),
    );
  }
}
