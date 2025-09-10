import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountdownTimer extends StatefulWidget {
  final int startTime; // 开始时间戳（毫秒）
  final int endTime; // 结束时间戳（毫秒）

  const CountdownTimer({
    Key? key,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _remainingTime; // 剩余时间
  late Timer _timer; // 定时器

  @override
  void initState() {
    super.initState();
    _initializeCountdown();
  }

  void _initializeCountdown() {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final int diff = widget.endTime - currentTime;

    if (diff <= 0) {
      _remainingTime = Duration.zero; // 倒计时结束
    } else {
      _remainingTime = Duration(milliseconds: diff);
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= const Duration(seconds: 1);
        } else {
          _timer.cancel(); // 倒计时结束时停止定时器
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return '${days}天'
          '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // 页面销毁时取消定时器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _formatDuration(_remainingTime),
        style: const TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal),
      ),
    );
  }
}
