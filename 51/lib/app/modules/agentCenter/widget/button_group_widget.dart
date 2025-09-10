// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';

import 'package:flutter_tiyu_app/app/modules/activity/widget/common_receive_button.dart';
import 'package:get/get.dart';

class ButtonGroupWidget extends StatefulWidget {
  VoidCallback? onConfrim;
  VoidCallback? onReset;
  bool? loading;

  ButtonGroupWidget({
    super.key,
    this.onConfrim,
    this.onReset,
    this.loading,
  });

  @override
  State<ButtonGroupWidget> createState() => _ButtonGroupWidgetState();
}

class _ButtonGroupWidgetState extends State<ButtonGroupWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 440.w,
          height: 120.h,
          child: OutlinedButton(
            onPressed: widget.onReset,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: context.theme.primaryColor,
                width: 2.w,
              ), // 设置边框颜色和宽度
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r), // 设置圆角
              ),
            ),
            child: Text(
              '重置',
              style: TextStyle(
                color: context.theme.primaryColor,
                fontSize: 39.sp,
              ),
            ),
          ),
        ),
        CommonReceiveButton(
          title: '确认',
          height: 120,
          borderRadius: 20,
          fontSize: 39,
          constraints: BoxConstraints(minWidth: 440.w),
          loading: widget.loading,
          onTap: widget.onConfrim,
          boxShadow: false,
        )
      ],
    );
  }
}
