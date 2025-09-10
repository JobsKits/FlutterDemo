import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';

class RechargeCommonContainer extends StatelessWidget {
  const RechargeCommonContainer(
      {super.key, required this.child, this.isMarginTop = true});
  final Widget child;
  final bool isMarginTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: isMarginTop ? 20.h : 0),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36.r),
          color: context.customTheme?.pageTwoBg),
      padding:
          EdgeInsets.only(left: 30.w, right: 30.w, top: 45.h, bottom: 45.h),
      child: child,
    );
  }
}
