import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/task/task_page_101.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class WithdrawalPwdPintWidget extends StatefulWidget {
  final bool pwdIsShow;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<bool>? fucChange; //焦点变化
  final double? itemWidth;

  WithdrawalPwdPintWidget(
      {super.key,
      required this.pwdIsShow,
      this.onChanged,
      this.fucChange,
      this.itemWidth = 146,
      this.onCompleted});

  @override
  State<WithdrawalPwdPintWidget> createState() =>
      _WithdrawalPwdPintWidgetState();
}

class _WithdrawalPwdPintWidgetState extends State<WithdrawalPwdPintWidget> {
  FocusNode pwdFuc = FocusNode();
  bool isSelect = false;
  double? itemWidth;
  @override
  void initState() {
    super.initState();
    itemWidth = widget.itemWidth;
    if (Platform.isIOS && 1.sw == 375 && itemWidth == 132) {
      itemWidth = 124;
    }
    pwdFuc.addListener(() {
      widget?.fucChange?.call(pwdFuc.hasFocus);
      setState(() {
        isSelect = pwdFuc.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    // oldPwdFuc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("屏幕宽高:${1.sw}  ${1.sh}");
    return Container(
        key: widget.key,
        height: 124.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: const Color(0xffE7E7E7),
            border: Border.all(
                color:
                    isSelect ? context.theme.primaryColor : Colors.transparent)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30.r),
            child: PinCodeTextField(
              focusNode: pwdFuc,
              appContext: context,
              length: 6,
              obscureText: widget.pwdIsShow,
              animationType: AnimationType.fade,
              textStyle:
                  TextStyle(fontSize: 50.sp, fontWeight: FontWeight.normal),
              pinTheme: PinTheme(
                  inactiveColor: Colors.transparent,
                  activeColor: Colors.transparent,
                  inactiveFillColor: Color(0xffF4F4F4),
                  selectedFillColor: Color(0xffF4F4F4),
                  selectedColor: Colors.transparent,
                  shape: PinCodeFieldShape.box,
                  // fieldWidth: 126.w,
                  fieldWidth: itemWidth?.w,
                  fieldHeight: 124.h,
                  activeFillColor: Color(0xffF4F4F4),
                  fieldOuterPadding: EdgeInsets.zero),
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                widget?.onChanged?.call(value);
                // controller.setOldPwd(value);
              },
              onCompleted: (value) {
                widget?.onCompleted?.call(value);
                // controller.setOldPwd(value);
              },
            )));
  }
}
