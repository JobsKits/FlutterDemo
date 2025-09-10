import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/modules/video/controllers/video_black_detail_controller.dart';
import 'package:flutter_tiyu_app/app/modules/video/controllers/video_detail_controller.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';

///自定义的视频播放控制器视图
class CustomVideoControllerWidget extends StatefulWidget {
  final bool isBlack;
  const CustomVideoControllerWidget({super.key, this.isBlack = false});

  @override
  State<CustomVideoControllerWidget> createState() =>
      _CustomVideoControllerWidgetState();
}

class _CustomVideoControllerWidgetState
    extends State<CustomVideoControllerWidget> {
  late var controller;
  @override
  void initState() {
    super.initState();
    if (widget.isBlack) {
      controller = Get.find<VideoBlackDetailController>();
    } else {
      controller = Get.find<VideoDetailController>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
        visible: controller.isShowController.value,
        child: CommonRipple(
          onTap: () {
            AppManager.instance.tapVibrate();
            controller.showOrHideController();
          },
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() => Container(
                width: double.infinity,
                height: controller.isFullScreen.value ? 260.h : 220.h,
                padding: EdgeInsets.only(left: 35.w, right: 35.w, top: 50.h),
                color: Colors.black26,
                child: Column(
                  children: [
                    // Stack(//暂时屏蔽缓冲进度条
                    //   children: [
                    // SizedBox(
                    //     height: 11.h,
                    //     child: Obx(() => LinearProgressIndicator(
                    //           value: controller.mBuffered.value,
                    //           valueColor: AlwaysStoppedAnimation<Color>(
                    //               Colors.blue), // 进度条颜色
                    //           backgroundColor: Colors.transparent, // 背景颜色
                    //         ))),
                    SizedBox(
                        height: 20.h,
                        child: Obx(() => SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 20.h,
                              // thumbShape: const RoundSliderThumbShape(
                              //     enabledThumbRadius: 0), //设置滑块半径为0
                              valueIndicatorShape:
                                  RoundSliderOverlayShape(overlayRadius: 100.r),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 0), //移出滑块的阴影
                            ),
                            child: Slider(
                              activeColor: Colors.white,
                              inactiveColor: Colors.white.withOpacity(0.36),
                              value: controller.progress.value,
                              onChanged: (position) {
                                controller.isTouch = true;
                                controller.changePlayProgress(position);
                              },
                              onChangeEnd: (position) {
                                controller.isTouch = false;
                                controller.seekTo(position);
                              },
                            )))),
                    SizedBox(
                      height: 40.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CommonRipple(
                              onTap: () {
                                AppManager.instance.tapVibrate();
                                controller.playOrPause();
                              },
                              child: Obx(() => controller.isPlay.value
                                  ? const Icon(
                                      Icons.pause,
                                      color: Colors.white,
                                    )
                                  : const Icon(Icons.play_arrow,
                                      color: Colors.white)),
                            ),
                            SizedBox(width: 20.w),
                            Obx(() => Text(
                                  "${controller.currentTime} / ${controller.totalTime}",
                                  style: TextStyle(
                                      fontSize: 36.sp, color: Colors.white),
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              Assets.theme1.images.video.detail.iconSmallWindow,
                              width: 64.w,
                              height: 64.h,
                            ),
                            SizedBox(
                              width: 64.w,
                            ),
                            CommonRipple(
                              onTap: () {
                                AppManager.instance.tapVibrate();
                                controller.fullScreen();
                              },
                              child: SvgPicture.asset(
                                  Assets.theme1.images.video.detail
                                      .iconFullWindow,
                                  width: 64.w,
                                  height: 64.h),
                            ),
                            SizedBox(
                              width: 64.w,
                            ),
                            SvgPicture.asset(
                                Assets.theme1.images.video.detail.iconMore,
                                width: 64.w,
                                height: 64.h),
                          ],
                        )
                      ],
                    )
                  ],
                  //   )
                  // ],
                ))),
          ),
        )));
  }
}
