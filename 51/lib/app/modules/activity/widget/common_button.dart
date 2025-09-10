// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';

import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:get/get.dart';

enum CommonButtonTypeEnum {
  Primary, // 默认
  Outline, // 外边框线的
  LinearGradient, // 线性渐变
}

class CommonButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final EdgeInsetsGeometry? margin;
  final bool? disabled;
  final bool? loading;
  final CommonButtonTypeEnum? type;
  final bool? loadingAnimation;
  final Color? color;
  final Color? bgColor;
  final Color? disabledBgColor;
  final Color? disabledColor;
  final double? borderRadius;
  final int? fontSize;
  final int? minHeight;
  const CommonButton({
    super.key,
    required this.title,
    this.onTap,
    this.margin,
    this.disabled = false,
    this.loading = false,
    this.loadingAnimation = true,
    this.type = CommonButtonTypeEnum.Primary,
    this.color = Colors.white,
    this.bgColor,
    this.disabledBgColor = const Color(colorF4F4F4),
    this.disabledColor = const Color(colorAFAFAF),
    this.borderRadius = 42,
    this.fontSize = 38,
    this.minHeight = 84,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          AppManager.instance.tapVibrate();
          if (disabled != true && loading != true && onTap != null) {
            DebounceThrottle.debounce(() => onTap!())();
          }
        },
        borderRadius: BorderRadius.circular(borderRadius!.r),
        highlightColor: Colors.white.withOpacity(0.2),
        splashColor: Colors.white.withOpacity(0.3),
        child: _buildChild(context),
      ),
    );
  }

  Decoration? _buildDecoration(BuildContext context) {
    // 外边框
    if (type == CommonButtonTypeEnum.Outline) {
      return BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color:
              Get.context?.theme.primaryColor ?? Colors.transparent, // 设置边框颜色
          width: 2.w, // 设置边框宽度
        ),
        borderRadius: BorderRadius.circular(borderRadius!.r),
      );
    }

    // 默认
    if (type == CommonButtonTypeEnum.Primary) {
      Color color = loading == true
          ? (bgColor ?? Get.context?.theme.primaryColor)!.withOpacity(0.4)
          : (bgColor ?? Get.context?.theme.primaryColor)!;
      return BoxDecoration(
        color: disabled == true ? disabledBgColor : color,
        borderRadius: BorderRadius.circular(borderRadius!.r),
      );
    }

    // 线型渐变背景
    if (type == CommonButtonTypeEnum.LinearGradient) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius!.r),
        gradient: LinearGradient(
          colors: loading == true || disabled == true
              ? [
                  context.theme.primaryColor.withOpacity(0.2),
                  context.theme.primaryColor.withOpacity(0.5)
                ]
              : [context.theme.primaryColor, context.theme.primaryColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      );
    }

    return null;
  }

  Widget _buildChild(BuildContext context) {
    return Container(
      margin: margin,
      alignment: Alignment.center,
      decoration: _buildDecoration(context),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      constraints: BoxConstraints(minWidth: 200.w, minHeight: minHeight!.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loading == true && loadingAnimation == true
              ? SizedBox(
                  width: 48.w,
                  height: 48.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 4.w,
                    valueColor: AlwaysStoppedAnimation<Color>(type ==
                            CommonButtonTypeEnum.Primary
                        ? Get.context?.theme.primaryColor ?? Colors.transparent
                        : const Color(colorFFFFFF)), // 圆圈颜色
                  ),
                )
              : Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: type == CommonButtonTypeEnum.Primary
                            ? (disabled == true ? disabledColor : color)
                            : (type == CommonButtonTypeEnum.LinearGradient
                                ? const Color(colorFFFFFF)
                                : Get.context?.theme.primaryColor),
                        height: 1,
                        fontSize: fontSize!.sp),
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
        ],
      ),
    );
  }
}
