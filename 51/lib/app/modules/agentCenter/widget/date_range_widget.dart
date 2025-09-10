// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:get/get.dart';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:intl/intl.dart';

import '../../../../utils/CommonRipple.dart';

typedef DateTimeCallback = void Function(DateTime date);

class DateRangeWidget extends StatefulWidget {
  DateTime initialDateTime;
  DateTime startTime;
  DateTime endTime;
  AsyncCallback? onTapStartTime;
  AsyncCallback? onTapEndTime;
  VoidCallback? onConfrimTime;
  DateTimeCallback? onTimeChange;

  DateRangeWidget({
    super.key,
    required this.initialDateTime,
    required this.startTime,
    required this.endTime,
    this.onTapStartTime,
    this.onTapEndTime,
    this.onConfrimTime,
    this.onTimeChange,
  });

  @override
  State<DateRangeWidget> createState() => _DateRangeWidgetState();
}

class _DateRangeWidgetState extends State<DateRangeWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateTimeWidget(
          isStartTime: true,
          onTap: () async {
            AppManager.instance.tapVibrate();
            if (widget.onTapStartTime != null) {
              await widget.onTapStartTime!();
            }

            // 延迟100ms，等数据更新
            await Future.delayed(const Duration(milliseconds: 100));
            _openRangeTimePicker(Get.context!);
          },
        ),
        Container(
          height: 4.h,
          width: 20.w,
          color: const Color(color99999),
        ),
        _buildDateTimeWidget(
          isStartTime: false,
          onTap: () async {
            AppManager.instance.tapVibrate();
            if (widget.onTapEndTime != null) {
              await widget.onTapEndTime!();
            }

            // 延迟100ms，等数据更新
            await Future.delayed(const Duration(milliseconds: 100));
            _openRangeTimePicker(Get.context!);
          },
        ),
      ],
    );
  }

  Widget _buildDateTimeWidget(
      {required bool isStartTime, VoidCallback? onTap}) {
    // 使用 intl 包中的 DateFormat
    final DateFormat formatter = DateFormat('yyyy/MM/dd');

    return CommonRipple(
      onTap: onTap,
      child: Container(
        height: 120.h,
        width: 440.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: context.customTheme?.inputBgColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isStartTime
                  ? formatter.format(widget.startTime)
                  : formatter.format(widget.endTime),
              style: TextStyle(
                fontSize: 42.sp,
                color: context.customTheme?.titleColor,
              ),
            ),
            SvgPicture.asset(
              Assets.theme1.images.agentCenter.iconDate,
              width: 45.w,
              height: 45.h,
              color: context.theme.primaryColor,
            )
          ],
        ),
      ),
    );
  }

  void _openRangeTimePicker(BuildContext context) {
    BottomPicker.date(
      backgroundColor: context.customTheme?.dialogBgColor ?? Colors.white,
      pickerTitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              Get.back();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Text(
                '取消',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.sp,
                  color: context.customTheme?.title2Color,
                ),
              ),
            ),
          ),
          Text(
            '选择时间',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 46.sp,
              color: context.customTheme?.titleColor,
            ),
          ),
          CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              if (widget.onConfrimTime != null) {
                widget.onConfrimTime!();
              }
              Get.back();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Text(
                '确定',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.sp,
                  color: context.theme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      titleAlignment: Alignment.center,
      dateOrder: DatePickerDateOrder.ymd,
      initialDateTime: widget.initialDateTime,
      maxDateTime: DateTime(DateTime.now().year, 12, 31),
      minDateTime: DateTime(2022),
      pickerTextStyle: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 39.sp,
      ),
      onChange: (date) {
        if (widget.onTimeChange != null) {
          widget.onTimeChange!(date);
        }
      },
      displaySubmitButton: false,
      displayCloseIcon: false,
      bottomPickerTheme: BottomPickerTheme.plumPlate,
    ).show(context);
  }
}
