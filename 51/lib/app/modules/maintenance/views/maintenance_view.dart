import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';

import '../../../../gen/assets.gen.dart';
import '../controllers/maintenance_controller.dart';

class MaintenanceView extends GetView<MaintenanceController> {
  const MaintenanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
      appBar: null,
      body: Center(
        child: Obx(() => _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              width: 949.w,
              margin: EdgeInsets.only(top: 190.h, bottom: 50.h),
              constraints: BoxConstraints(maxHeight: 1000.h, minHeight: 764.h),
              decoration: BoxDecoration(
                color: const Color(colorFFFFFF),
                image: DecorationImage(
                  image: AssetImage(
                      Assets.theme1.images.maintenance.maintenanceBg.path),
                  fit: BoxFit.cover, // 使用 BoxFit.cover
                ),
                borderRadius: BorderRadius.circular(60.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Column(
                children: [
                  SizedBox(height: 240.h),
                  Text(
                    controller.title.value,
                    style: TextStyle(fontSize: 62.sp, color: Colors.black),
                  ),
                  SizedBox(height: 50.h),
                  Text(
                    '系统将于${controller.startTime.value}至${controller.endTime.value}进行系统维护，维护期间将暂定网站所有服务。维护结束将恢复网站服务，给您造成不便，敬请谅解！',
                    style: TextStyle(
                      fontSize: 42.sp,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 60.h),
                  SizedBox(
                    width: 200.w,
                    height: 90.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36.r), // 设置圆角半径
                          ),
                          backgroundColor: const Color(0XFF10c8e3),
                          padding: EdgeInsets.zero),
                      onPressed: () {
                        AppManager.instance.tapVibrate();
                        exit(0);
                        // Get.offNamed(AppPages.INITIAL);
                        // Get.offNamed(Routes.TABS);
                      },
                      child: Text(
                        '退出',
                        style: TextStyle(
                          fontSize: 42.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 290.w,
              child: Image.asset(
                Assets.theme1.images.maintenance.maintenanceIcon.path,
                width: 370.w,
                height: 390.h,
              ),
            )
          ],
        )
      ],
    );
  }
}
