import 'dart:async';
import 'dart:io';

import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class DisplayAdController extends GetxController {
  late final File adFile;
  final RxInt countdown = 5.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    adFile = arguments['adFile'];
    startCountdown();
  }

  // void startCountdown() {
  //   print("这里还有持续执行吗${countdown.value}");
  //   Future.delayed(const Duration(seconds: 1), () {
  //     if (countdown.value > 1) {
  //       countdown.value--;
  //       startCountdown();
  //     } else {
  //       skipAd();
  //     }
  //   });
  // }
  Timer? _countdownTimer;

  void startCountdown() {
    _countdownTimer = Timer(const Duration(seconds: 1), () {
      if (countdown.value > 1) {
        countdown.value--;
        startCountdown(); // 递归调用继续倒计时
      } else {
        skipAd(); // 倒计时结束时执行操作
      }
    });
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }

  void skipAd() {
    Get.offNamed(Routes.TABS);
  }
}
