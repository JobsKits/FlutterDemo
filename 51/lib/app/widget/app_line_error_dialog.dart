import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../../utils/app_manager.dart';

//app 线路异常提示弹窗
class AppLineErrorDialog extends StatelessWidget {
  final VoidCallback? changeLine;
  const AppLineErrorDialog({super.key, this.changeLine});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Container(
          width: 0.9.sw,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "温馨提示",
                    style:
                        TextStyle(fontSize: 60.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Image.asset(
                    Assets.theme1.images.home.iconLineError.path,
                    width: 372.w,
                    height: 372.h,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "抱歉!当前大厅访问异常,\n请尝试切换至备用线路以继续访问。",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40.sp, color: Color(0xff6A6A6A)),
                  ),
                  InkWell(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      changeLine?.call();
                      Get.back();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 50.h, bottom: 80.h),
                      height: 120.h,
                      width: 560.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(theme01MainColor),
                          borderRadius: BorderRadius.circular(66.r)),
                      child: Text(
                        "切换线路",
                        style: TextStyle(fontSize: 54.sp, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                  right: 20.w,
                  top: 20.h,
                  child: InkWell(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      Get.back();
                    },
                    child: Icon(
                      Icons.close,
                      size: 70.w,
                      color: Color(0xff6A6A6A),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
