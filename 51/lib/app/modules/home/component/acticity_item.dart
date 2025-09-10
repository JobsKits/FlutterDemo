import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_count_timer.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/models/redbag_rain_detail_model/redbag_rain_detail_model.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../utils/CommonRipple.dart';

class ActivityItem extends StatefulWidget {
  final String logo;
  final bool show;
  final RedbagRainDetailModel? model;
  final double positionX;
  final double positionY;
  final VoidCallback onPressed;
  final VoidCallback onClose;

  const ActivityItem({
    super.key,
    required this.onPressed,
    required this.onClose,
    required this.positionX,
    required this.positionY,
    required this.logo,
    this.show = true,
    this.model,
  });

  @override
  State<ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  final ActivityController controller = Get.put(ActivityController());
  late Offset _position = Offset(20, 20);
  bool _isDrag = false;

  int endTime = 0;
  String dispatchTime = "";

  @override
  void initState() {
    _position = Offset(widget.positionX, widget.positionY);
    super.initState();

    String? jsonString = widget.model?.actionCfg;
    // 解析 JSON 字符串
    Map<String, dynamic> jsonData = json.decode(jsonString ?? '');

    dispatchTime = getMatchingEndTime(jsonData['dispatchTime']) ?? '';
    endTime = dispatchTime != '' ? getCustomEndTimestamp(dispatchTime) : 0;
  }

  String? getMatchingEndTime(List datas) {
    // 获取当前时间
    final now = DateTime.now();
    final currentTime = DateFormat.Hm().format(now);

    for (var range in datas) {
      final startTime = range['startTime']!;
      final endTime = range['endTime']!;

      // 比较时间
      if (currentTime.compareTo(startTime) >= 0 &&
          currentTime.compareTo(endTime) <= 0) {
        return endTime;
      }
    }

    return ''; // 如果没有匹配到，返回 null
  }

  int getCustomEndTimestamp(String timeString) {
    final now = DateTime.now();
    final timeParts = timeString.split(':');

    if (timeParts.length > 1) {
      final hours = int.parse(timeParts[0]);
      final minutes = int.parse(timeParts[1]);

      final endOfDay =
          DateTime(now.year, now.month, now.day, hours, minutes, 59, 999);
      return endOfDay.millisecondsSinceEpoch;
    } else {
      throw FormatException(
          'Invalid time format. Expected format is "HH:mm:ss".');
    }
  }

  @override
  void didUpdateWidget(covariant ActivityItem oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.show
        ? Positioned(
            top: _position.dy,
            left: _position.dx,
            child: getItemWidget(),
          )
        : const SizedBox();
    /*
    return widget.show
        ? Positioned(
            top: _position.dy,
            left: _position.dx,
            child: Draggable(
              onDragStarted: () => setState(() => _isDrag = true),
              onDragEnd: (details) {
                double x = 0;
                double y = details.offset.dy;
                if (details.offset.dx > Get.width / 2) {
                  x = Get.width - 220.w;
                } else {
                  x = 10.w;
                }
                if (details.offset.dy < 80.h) {
                  y = 80.h;
                } else if (details.offset.dy > Get.height - 500.h) {
                  y = Get.height - 500.h;
                }
                setState(() {
                  _isDrag = false;
                  _position = Offset(
                    x,
                    y,
                  );
                });
              },
              feedback: getItemWidget(),
              child: !_isDrag ? getItemWidget() : const SizedBox(),
            ),
          )
        : const SizedBox();
    */
  }

  Widget getItemWidget() {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              widget.onPressed();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // 确保内容水平居中对齐
              children: [
                Image.asset(
                  widget.logo,
                  width: 200.w,
                  fit: BoxFit.cover,
                ),
                if (endTime != 0) ...[
                  ActivityCountTimer(
                      startTime: DateTime.now().millisecondsSinceEpoch,
                      endTime: endTime)
                ] else if (dispatchTime == '进行中') ...[
                  Text(
                    dispatchTime,
                    style: const TextStyle(
                        color: Color(0xFFFA2C47),
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  )
                ]
              ],
            )),
        InkWell(
          onTap: () {
            AppManager.instance.tapVibrate();
            widget.onClose.call();
          },
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Icon(
              Icons.close,
              size: 20.w,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
