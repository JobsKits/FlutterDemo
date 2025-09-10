import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';

//登录方式选择按钮
class LoginTypeButtonWidget extends StatelessWidget {
  final String title;
  final String iconPath;
  final String? type;
  final double? size;
  final VoidCallback? buttonClick;

  const LoginTypeButtonWidget(
      {super.key,
      required this.title,
      required this.iconPath,
      this.type,
      this.size,
      this.buttonClick});

  @override
  Widget build(BuildContext context) {
    return CommonRipple(
      onTap: buttonClick,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, // 渐变起始位置
              end: Alignment.bottomCenter, // 渐变结束位置
              colors: type == 'png'
                  ? [
                      context.customTheme?.pageTwoBg ?? Colors.transparent,
                      context.customTheme?.pageTwoBg ?? Colors.transparent
                    ]
                  : [
                      context.customTheme?.pageTwoBg ?? Colors.transparent,
                      context.customTheme?.pageTwoBg ?? Colors.transparent
                    ], // 渐变的颜色列表
            ),
            borderRadius: BorderRadius.circular(42.r)),
        width: size?.w ?? 200.w,
        height: size?.h ?? 200.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            type == 'png'
                ? Image.asset(
                    iconPath,
                    fit: BoxFit.contain, // 根据需要调整 fit 属性
                    height: 52.h,
                    width: 52.w,
                  )
                : SvgPicture.asset(
                    iconPath,
                    width: 66.w,
                    height: 66.h,
                    colorFilter:
                        const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
            SizedBox(
              height: 16.h,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 34.sp,
                  color:
                      type == 'png' ? Color(color8D8D8D) : Color(colorB7B7B7)),
            )
          ],
        ),
      ),
    );
  }
}
