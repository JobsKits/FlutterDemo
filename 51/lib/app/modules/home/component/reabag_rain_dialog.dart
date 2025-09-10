import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/tips_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/models/RedBagData.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/redbag_rain_controller.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/CommonRipple.dart';

class RedBagRainStartModal extends StatefulWidget {
  final int id;
  final VoidCallback? onPress;
  final VoidCallback? requestBag;
  final VoidCallback? onClose;

  const RedBagRainStartModal({
    super.key,
    this.id = 0,
    this.onPress,
    this.requestBag,
    this.onClose,
  });

  @override
  _RedBagRainStartModalState createState() => _RedBagRainStartModalState();
}

class _RedBagRainStartModalState extends State<RedBagRainStartModal>
    with SingleTickerProviderStateMixin {
  final RedbagRainController controller = Get.put(RedbagRainController());
  late AnimationController _animationController;
  static const int numberOfRedBags = 50;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    startPreGameCountdown();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Timer? _timer;
  Timer? _timer2;
  void startPreGameCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (controller.preGameCountdown.value >= 1) {
        controller.preGameCountdown.value--;
      } else {
        startRedBagsAnimation();
        controller.gameStarted.value = true;
        timer.cancel();
        startGameCountdown();
      }
    });
  }

  void startGameCountdown() {
    _timer2 = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (controller.countdown.value > 0) {
        controller.countdown.value--;
      } else {
        controller.gameStarted.value = false;
        timer.cancel();
        if (mounted) {
          _animationController.reset();
        }
        controller.redBags.clear();

        controller.countdown.value = 10;
        controller.showRewardModal.value = false;
        controller.redBagStart.value = false;

        if (controller.isPushed.value) {
          controller.isPushed.value = false;
        } else {
          widget.onClose?.call();
          widget.onClose?.call();
        }
      }
    });
  }

  void startRedBagsAnimation() {
    // 重置动画控制器，并设置总时长为10秒
    _animationController.reset();
    _animationController.duration = const Duration(seconds: 13);
    _animationController.forward();

    final random = Random();
    controller.redBags.clear();

    for (int i = 0; i < numberOfRedBags; i++) {
      final initialRotation = random.nextDouble() * 360;
      final startTime =
          i * (10.0 / numberOfRedBags) + random.nextDouble() * 0.5;
      final duration = random.nextDouble() * 3.0 + 2.0;

      final normalizedStartTime = (startTime / 10.0).clamp(0.0, 1.0);
      final normalizedEndTime = ((startTime + duration) / 10.0).clamp(0.0, 1.0);

      final translateX =
          random.nextDouble() * MediaQuery.of(context).size.width - 40;

      final translateY = Tween<double>(
        begin: -120,
        end: MediaQuery.of(context).size.height + 50,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          normalizedStartTime,
          normalizedEndTime,
          curve: Curves.linear,
        ),
      ));

      controller.redBags.add(RedBagData(
        key: i.toString(),
        translateY: translateY,
        translateX: Tween<double>(begin: translateX, end: translateX)
            .animate(_animationController),
        rotation: initialRotation,
        isClicked: false,
      ));
    }

    setState(() {});
  }

  void openRedBag(String? redBagKey, Function(bool) callback) {
    controller.redBags.value = controller.redBags.map((redBag) {
      if (redBag.key == redBagKey) {
        controller.isClick.value = true;
        controller.reqRedbagRainActivity(widget.id, (success) {
          callback(success);
        });
        return redBag.copyWith(isClicked: true);
      }
      return redBag;
    }).toList();
  }

  //再玩一次
  // Future restartGame() async {
  //   controller.redBagStart.value = true;
  //   _animationController.reset();
  //   controller.redBags.clear();
  //   // await controller.getRequestBag(isTryAgan: controller.isCanTryAgan);
  //   startPreGameCountdown();
  // }

  @override
  Widget build(BuildContext context) {
    return CommonRipple(
      // onTap: widget.onPress,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2), // 背景半透明
            ),
          ),
          Obx(() => (!controller.gameStarted.value &&
                  controller.preGameCountdown.value != 0)
              ? Center(
                  child: Obx(() => Text(
                        '${controller.preGameCountdown.value}',
                        style: TextStyle(
                          fontSize: 80.sp,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.yellow.withOpacity(0.8),
                              blurRadius: 10.0,
                              offset: const Offset(0, 0),
                            ),
                            Shadow(
                              color: Colors.yellow.withOpacity(0.5),
                              blurRadius: 20.0,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      )),
                )
              : const SizedBox()),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Obx(() => Stack(
                    children: controller.redBags
                        .map((redBag) => Positioned(
                              left: redBag.translateX.value,
                              top: redBag.translateY.value,
                              child: Transform.rotate(
                                angle: redBag.rotation,
                                child: CommonRipple(
                                    onTap: () {
                                      AppManager.instance.tapVibrate();
                                      openRedBag(redBag.key, (success) {
                                        if (!success) {
                                          widget.onClose?.call();
                                          controller.countdown.value = 10;
                                          controller.showRewardModal.value =
                                              false;
                                          controller.redBagStart.value = false;
                                          _timer?.cancel();
                                          _timer2?.cancel();
                                        }
                                      });
                                    },
                                    child: redBag.isClicked
                                        ? SizedBox()
                                        : Image.asset(
                                            Assets.theme1.images.home
                                                .redbagrainWinningPack.path,
                                            width: 200.w,
                                            height: 200.h,
                                          )),
                              ),
                            ))
                        .toList(),
                  ));
            },
          ),
          Obx(() => (controller.preGameCountdown.value <= 1)
              ? Positioned(
                  top: MediaQuery.of(context).padding.top + 15,
                  right: 15,
                  child: Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.white, // White background
                      shape: BoxShape.circle, // Circular shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 4), // Shadow position
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.black, size: 40.sp),
                      onPressed: () {
                        Get.dialog(
                          TipsDialog(
                            title: '重要提醒',
                            tips: '关闭后，本轮红包不再主动弹出。\n可前往首页活动悬浮图，点击红包雨活动主动弹出',
                            // desc: desc,
                            comfirmText: '确定',
                            contentF1Size: 95.sp,
                            type: 'redbag',
                            confirmAction: () {
                              AppManager.instance.tapVibrate();
                              controller.countdown.value = 10;
                              controller.showRewardModal.value = false;
                              controller.redBagStart.value = false;
                              _timer?.cancel();
                              _timer2?.cancel();
                              widget.onClose?.call();

                              controller.saveRainIds(
                                  'redRain${LoginManager.instance.loginInfo?.custId}',
                                  widget.id);
                            },
                          ),
                          barrierDismissible: false,
                        );
                      },
                    ),
                  ),
                )
              : const SizedBox()),
          // Obx(() => (controller.showRewardModal.value &&
          //         controller.countdown.value <= 0)
          //     ? Positioned.fill(
          //         child: CommonRipple(
          //           // onTap: widget.onPress,
          //           child: Stack(
          //             children: [
          //               Positioned(
          //                 bottom: 280.w,
          //                 left: 150.w,
          //                 child: Text(
          //                   '恭喜您！您抢到${controller.rewardAmount}元!',
          //                   style: TextStyle(
          //                     fontSize: 28.sp,
          //                     color: const Color(0xFF890000),
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       )
          //     : const SizedBox()),
        ],
      ),
    );
  }
}
