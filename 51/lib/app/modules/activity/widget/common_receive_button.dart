import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

class CommonReceiveButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final EdgeInsetsGeometry? margin;
  final bool? disabled;
  final bool? loading;
  final int? btnColor;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final BoxConstraints? constraints;
  final bool? boxShadow;
  const CommonReceiveButton({
    super.key,
    required this.title,
    this.onTap,
    this.margin,
    this.disabled = false,
    this.loading = false,
    this.boxShadow = true,
    this.btnColor,
    this.constraints,
    this.height = 126,
    this.borderRadius = 66,
    this.fontSize = 54,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: loading == true || disabled == true
              ? [const Color(colorF4F4F4), const Color(colorF4F4F4)]
              : [context.theme.primaryColor, context.theme.primaryColor],
        ),
        boxShadow: boxShadow == true
            ? [
                BoxShadow(
                  color: loading == true || disabled == true
                      ? const Color(colorF4F4F4).withOpacity(0.3)
                      : context.theme.primaryColor.withOpacity(0.7), // 颜色
                  blurRadius: 2, // 阴影的模糊半径
                  spreadRadius: 1, // 阴影的扩散半径
                  offset: Offset(0, 2.h), // x, y 偏移
                ),
              ]
            : [],
        borderRadius: BorderRadius.circular(borderRadius!.r),
      ),
      padding: EdgeInsets.zero,
      height: height!.h,
      constraints: constraints,
      child: ElevatedButton(
        onPressed: disabled == true || loading == true
            ? null
            : () {
                AppManager.instance.tapVibrate();
                if (onTap != null) {
                  DebounceThrottle.debounce(() => onTap!())();
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!.r),
          ),
          overlayColor: Colors.white, // 设置水波纹颜色 不算明显
          padding: EdgeInsets.zero, // 确保没有内边距
          fixedSize: Size(double.infinity, 126.h), // 固定高度
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loading == true
                ? SizedBox(
                    width: 50.w,
                    height: 50.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 4.w,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize!.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.1,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
