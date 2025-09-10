import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

class ActivityEndOverlay extends StatelessWidget {
  final String? endTime;

  const ActivityEndOverlay({
    Key? key,
    required this.endTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 判断活动是否已结束
    bool isActivityEnded =
        endTime?.isNotEmpty == true && isTimeBeforeNow(endTime!);

    if (!isActivityEnded) {
      return const SizedBox.shrink(); // 如果活动未结束，返回空 Widget
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      top: 0,
      child: _buildOverlayContent(context),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      decoration: _buildOverlayDecoration(),
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 40.w, 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if ((endTime ?? '').isNotEmpty) _buildActivityEndText(context),
        ],
      ),
    );
  }

  BoxDecoration _buildOverlayDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Colors.black54,
          Colors.black54,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(10.r),
    );
  }

  Widget _buildActivityEndText(BuildContext context) {
    return Container(
      height: 80.h,
      constraints: BoxConstraints(minWidth: 200.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.transparent,
        border: Border.all(
          color: context.theme.primaryColor,
          width: 2.w,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      alignment: Alignment.center,
      child: Text(
        '活动已结束',
        style: TextStyle(
          color: context.theme.primaryColor,
          fontSize: 38.sp,
        ),
      ),
    );
  }

  bool isTimeBeforeNow(String timeString) {
    try {
      DateTime targetTime = DateTime.parse(timeString);
      DateTime now = DateTime.now();
      return targetTime.isBefore(now);
    } catch (e) {
      print("时间格式错误：$e");
      return false; // 或者根据需求返回其他值
    }
  }
}
