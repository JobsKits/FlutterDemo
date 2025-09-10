import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_collection_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_collection_model/activity_collection_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_countdown_timer.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CountdownButton extends StatefulWidget {
  final ActivityCollectionModel? model; // 将 model 声明为参数
  final VoidCallback? onTap;

  const CountdownButton({Key? key, this.model, this.onTap}) : super(key: key);

  @override
  _CountdownButtonState createState() => _CountdownButtonState();
}

class _CountdownButtonState extends State<CountdownButton> {
  final ActivityCollectionController controller =
      Get.put(ActivityCollectionController());
  late Duration _remainingTime; // 倒计时时间
  late Timer _timer; // 定时器
  String _buttonText = "待领取"; // 按钮初始文本

  @override
  void initState() {
    super.initState();
    _startCountdown(); // 开始倒计时
  }

  void _startCountdown() {
    final int endTime = (widget.model?.receiveEndTime != null
        ? widget.model!.receiveEndTime! ~/ 1000
        : 0); // 将结束时间转换为秒

    final int currentTime =
        DateTime.now().millisecondsSinceEpoch ~/ 1000; // 当前时间（秒）

    // 计算倒计时剩余时间
    _remainingTime = Duration(seconds: endTime - currentTime);

    // 启动定时器
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= const Duration(seconds: 1); // 每次减少一秒
        } else {
          _timer.cancel(); // 停止定时器
          _buttonText = "领取"; // 修改文本
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer.cancel(); // 页面销毁时停止定时器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.onTap?.call();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: context.theme.primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        minimumSize: Size(120.w, 80.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 内容居中
        children: [
          // 主文本
          Text(
            _buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          // 倒计时
          if (_remainingTime.inSeconds > 0) // 如果倒计时未结束才显示倒计时
            CountdownTimer(
              startTime: (widget.model?.receiveStartTime != null
                      ? widget.model!.receiveStartTime! / 1000
                      : 0)
                  .toInt(),
              endTime: widget.model?.receiveEndTime ?? 0, // 1分钟倒计时
            )
        ],
      ),
    );
  }
}
