import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

class SignInTitleWidget extends StatelessWidget {
  final String title;
  const SignInTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 12.w,
          height: 46.h,
          margin: EdgeInsets.only(right: 20.w, top: 10.h),
          decoration: BoxDecoration(
            color: context.theme.primaryColor,
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 52.sp,
            color: context.customTheme?.titleColor,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        )
      ],
    );
  }
}
