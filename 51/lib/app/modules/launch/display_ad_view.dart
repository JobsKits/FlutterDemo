import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/launch/display_ad_controller.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

class DisplayAdView extends GetView<DisplayAdController> {
  const DisplayAdView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Image.file(
              controller.adFile,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            top: 150.h,
            right: 30.w,
            child: Obx(
              () => SizedBox(
                width: 230.w,
                height: 78.h,
                child: ElevatedButton(
                  onPressed: () {
                    AppManager.instance.tapVibrate();
                    controller.skipAd();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.h),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    '跳过 (${controller.countdown.value}s)',
                    style: TextStyle(
                      fontSize: 36.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
