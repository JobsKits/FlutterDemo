import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_button.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

class RebateViewReceiveBtnWidget extends StatefulWidget {
  final num amount;
  final bool displayTomorr;
  final num tomorrAmount;
  final bool showReceive;
  final VoidCallback? onTabReceive; // 点击一键领取
  final VoidCallback? onTabRecord; // 点击领取记录
  final bool loading;
  final bool historyLoading;
  const RebateViewReceiveBtnWidget({
    super.key,
    required this.amount,
    required this.displayTomorr,
    required this.tomorrAmount,
    required this.showReceive,
    this.onTabReceive,
    this.onTabRecord,
    required this.loading,
    required this.historyLoading,
  });

  @override
  State<RebateViewReceiveBtnWidget> createState() =>
      _RebateViewReceiveBtnWidgetState();
}

class _RebateViewReceiveBtnWidgetState
    extends State<RebateViewReceiveBtnWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176.h,
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.h, bottom: 40.h),
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: context.customTheme?.pageTwoBg,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: '今日可领取：',
                  style: TextStyle(
                    fontSize: 40.sp,
                    color: context.theme.primaryColor,
                  ),
                  children: [
                    TextSpan(
                      text: widget.amount == 0
                          ? '0.00'
                          : parseNumber(double.parse(
                              (widget.amount / 1000).truncateToFixed(3))),
                      style: TextStyle(
                        color: context.customTheme?.titleColor,
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.displayTomorr == true) ...[
                RichText(
                  text: TextSpan(
                    text: '明日可领取：',
                    style: TextStyle(
                      fontSize: 36.sp,
                      color: context.theme.primaryColor,
                    ),
                    children: [
                      TextSpan(
                        text: widget.tomorrAmount == 0
                            ? '0.00'
                            : parseNumber(double.parse(
                                (widget.tomorrAmount / 1000)
                                    .truncateToFixed(3))),
                        style: TextStyle(
                          color: const Color(color2C2C2C),
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
          Visibility(
            visible: widget.showReceive,
            child: SizedBox(
              width: 250.w,
              child: CommonButton(
                title: '一键领取',
                type: CommonButtonTypeEnum.LinearGradient,
                disabled: widget.amount <= 0,
                disabledBgColor: const Color(colorB6B9C1),
                disabledColor: const Color(colorFFFFFF),
                onTap: widget.onTabReceive,
                loading: widget.loading,
              ),
            ),
          )
        ],
      ),
    );
  }
}
