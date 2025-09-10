import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

class VipTitleWidget extends StatelessWidget {
  final String title;
  const VipTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 30.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8.w,
            height: 40.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: context.theme.primaryColor),
          ),
          SizedBox(width: 14.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 45.sp,
              color: const Color(color333033),
            ),
          )
        ],
      ),
    );
  }
}
