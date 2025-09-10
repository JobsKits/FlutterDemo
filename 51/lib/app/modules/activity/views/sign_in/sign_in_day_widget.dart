import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:get/get.dart';

import '../../widget/dashed_line_widget.dart';

class SignInDayWidget extends StatefulWidget {
  final int day;
  final bool isReceived;
  final String reward;
  final String? pic;
  const SignInDayWidget({
    super.key,
    required this.day,
    required this.isReceived,
    required this.reward,
    this.pic,
  });

  @override
  State<SignInDayWidget> createState() => _SignInDayWidgetState();
}

class _SignInDayWidgetState extends State<SignInDayWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.day == 7 ? 519.w : 249.w,
      height: 281.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        color: context.customTheme?.pageTwoBg, // 背景颜色
        gradient: LinearGradient(
          colors: [
            context.customTheme?.pageTwoBg ?? Colors.white,
            context.customTheme?.pageTwoBg ?? Colors.white
          ],
          begin: Alignment.topCenter, // 渐变开始位置
          end: Alignment.bottomCenter, // 渐变结束位置
        ),
        border:
            Border.all(color: context.customTheme?.lineColor ?? Colors.white),
        boxShadow: [
          BoxShadow(
            color: context.theme.primaryColor.withOpacity(0.3), // 颜色
            blurRadius: 6, // 阴影的模糊半径
            spreadRadius: 1, // 阴影的扩散半径
            offset: Offset(0, -2.h), // x, y 偏移
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: _buildCenterReward(context),
              ),
              const DashedLineWidget(),
              _buildBottomText(),
            ],
          ),
          Visibility(
            visible: widget.isReceived,
            child: Positioned(
              top: 36.h,
              left: 0.w,
              child: Transform.rotate(
                angle: -30 * pi / 180,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: const Color(0xFFe57989),
                  )),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  child: Text(
                    '已签到',
                    style: TextStyle(
                      fontSize: 30.sp,
                      color: const Color(0xFFe57989),
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCenterReward(BuildContext context) {
    if (widget.day == 7) {
      return Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.pic?.isEmpty ?? false) ... [
              Image.asset(
                Assets.theme1.images.activity.signIn.signInBox.path,
                width: 200.w,
                height: 143.h,
              ),
            ] else ... [
              Image.network(
                widget.pic ?? '',
                width: 200.w,
                height: 143.h,
              ),
            ],
            SizedBox(width: 20.w),
            Expanded(
              child: Text(
                '+${widget.reward}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 42.sp,
                  color: widget.isReceived
                      ? context.theme.primaryColor.withOpacity(0.2)
                      : context.theme.primaryColor,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
                maxLines: 2,
              ),
            )
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image.asset(
        //   widget.isReceived
        //       ? Assets.theme1.images.activity.signIn.signInChecked.path
        //       : Assets.theme1.images.activity.signIn.signInUncheck.path,
        //   width: 92.w,
        //   height: 97.h,
        // ),
        if (widget.pic?.isEmpty ?? false) ... [
          Image.asset(
            widget.isReceived
                ? Assets.theme1.images.activity.signIn.signInChecked.path
                : Assets.theme1.images.activity.signIn.signInUncheck.path,
            width: 92.w,
            height: 97.h,
          ),
        ] else ... [
          Image.network(
            widget.pic ?? '',
            width: 92.w,
            height: 97.h,
          ),
        ],
        SizedBox(height: 10.h),
        Text(
          '+${widget.reward}',
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 42.sp,
            color: widget.isReceived
                ? context.theme.primaryColor.withOpacity(0.2)
                : context.theme.primaryColor,
            fontWeight: FontWeight.w600,
            height: 1,
          ),
        )
      ],
    );
  }

  // 构建底部文本
  Widget _buildBottomText() {
    return SizedBox(
      height: 60.h,
      child: Center(
        child: Text(
          '第${widget.day}天',
          style: TextStyle(
            fontSize: 36.sp,
            color: widget.isReceived
                ? context.theme.primaryColor.withOpacity(0.1)
                : context.customTheme?.titleColor,
          ),
        ),
      ),
    );
  }
}
