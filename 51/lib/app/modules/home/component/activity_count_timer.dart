import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityCountTimer extends StatefulWidget {
  final int startTime; // 开始时间戳（毫秒）
  final int endTime; // 结束时间戳（毫秒）
  final bool? timeFormat; // 时间格式化
  final double? fontSize;
  final String? lastStr; // 时间格式化
  Color? fontColor; // 结束时间戳（毫秒）

  ActivityCountTimer({
    Key? key,
    required this.startTime,
    required this.endTime,
    this.timeFormat = false,
    this.lastStr,
    this.fontSize,
    this.fontColor = const Color(0xFFFA2C47),
  }) : super(key: key);

  @override
  _ActivityCountTimerState createState() => _ActivityCountTimerState();
}

class _ActivityCountTimerState extends State<ActivityCountTimer> {
  late Duration _remainingTime; // 剩余时间
  late Timer _timer; // 定时器

  @override
  void initState() {
    super.initState();
    _initializeCountdown();
  }

  void _initializeCountdown() {
    final currentTime = widget.startTime;
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
    
    var time = '';

    if (widget.timeFormat ?? false) {
      final days = duration.inDays;
      final hours = duration.inHours % 24;
      final minutes = duration.inMinutes % 60;
      final seconds = duration.inSeconds % 60;
      time = [
        hours.toString().padLeft(2, '0'),
        minutes.toString().padLeft(2, '0'),
        if (days <= 0) 
          seconds.toString().padLeft(2, '0'),
      ].join(':');

      return days > 0 ? '${days}天 $time ${widget.lastStr}' : '$time ${widget.lastStr}';
    } else {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      final seconds = duration.inSeconds % 60;
      time = '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
    }
    return time;
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
        style: TextStyle(
            color: widget.fontColor,
            fontSize: widget.fontSize ?? 28.sp,
            fontWeight: FontWeight.normal),
      ),
    );
  }
}
