import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/launch/splash_controller.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  SplashController controller = Get.find();

  @override
  void initState() {
    super.initState();

    // 初始化 AnimationController，持续时间为3秒
    controller.animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // 设置 Tween 从 0.0 到 0.99，并绑定到 AnimationController
    controller.animation = Tween<double>(begin: 0.0, end: 0.9)
        .animate(controller.animationController)
      ..addListener(() {
        setState(() {
          // 每次动画更新时更新 progressValue
          controller.progressValue.value = controller.animation.value;
        });
      });
    // 启动动画
    controller.animationController.forward();
  }

  @override
  void dispose() {
    controller.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/launch_image.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Obx(() => Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 15,
                child: Text(
                  'App: ${controller.versionStr.value}',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 172, 172, 172),
                    fontSize: 35.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
          Positioned(
            bottom: 250.h,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset(
                //   'assets/launch_logo.gif',
                //   width: 390.w, //325.w,
                //   height: 94.h, //78.h,
                // ),
                // SizedBox(height: 60.h),
                // Text(
                //   '我们懂美 更懂你 千万资源免费看',
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontSize: 45.sp,
                //     fontWeight: FontWeight.w100,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                SizedBox(height: 80.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '正在检查更新...',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w100,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15.h),
                    Obx(
                      () => SizedBox(
                        width: 872.w,
                        height: 26.h,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.h),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.3), width: 1),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(13.h),
                              child: Stack(
                                children: [
                                  // 背景色
                                  Container(
                                    // height: 26.h, // 背景容器的高度
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                  // 渐变进度条
                                  FractionallySizedBox(
                                    widthFactor: controller.progressValue.value,
                                    child: Container(
                                      height: 26.h, // 进度条容器的高度，保持一致
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(Assets.theme1.images
                                              .common.splashLoading.path),
                                          fit: BoxFit.cover, // 确保图片填满进度条的容器
                                        ),
                                      ),
                                    ),
                                  ),
                                  // 跟随进度条移动的图标
                                  // Positioned(
                                  //   top: 0, // 将图标顶部与Container顶部对齐
                                  //   left: (872.w - 26.w) * controller.progressValue.value,
                                  //   child: Icon(
                                  //     Icons.circle,  // 图标样式可以根据需求更换
                                  //     // size: 26.h,
                                  //     color: Color(0xFF1391DB),
                                  //   ),
                                  // ),
                                ],
                              )),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      '正在检查... [线路1][模式1][第1次]',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35.sp,
                        fontWeight: FontWeight.w100,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
