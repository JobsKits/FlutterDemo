import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:get/get.dart';

import 'sign_in_title_widget.dart';

class SignInConditionWidget extends StatelessWidget {
  final String recharge; // 当前充值
  final String maxRecharge; // 最大充值
  final String betAmount; // 当前投注
  final String maxBetAmount; // 最大投注
  final int limitType; // 充值/打码限制类型
  final num? startTime; // 开始时间
  final num? endTime; // 结束时间
  final bool isShow;
  const SignInConditionWidget({
    super.key,
    required this.betAmount,
    required this.maxBetAmount,
    required this.recharge,
    required this.maxRecharge,
    required this.limitType,
    this.startTime,
    this.endTime,
    required this.isShow,
  });

  @override
  Widget build(BuildContext context) {
    if (!isShow || limitType == 1) {
      return const SizedBox();
    }

    if (limitType == 3 && startTime == null && endTime == null) {
      return const SizedBox();
    }

    return Container(
      margin: EdgeInsets.fromLTRB(30.h, 50.h, 30.h, 0),
      padding:
          EdgeInsetsDirectional.symmetric(horizontal: 60.w, vertical: 50.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.sp),
        color: context.customTheme?.pageTwoBg, // 背景颜色
        boxShadow: [
          BoxShadow(
            color: const Color(color8D8D8D).withOpacity(0.15), // 颜色
            blurRadius: 6, // 阴影的模糊半径
            spreadRadius: 1, // 阴影的扩散半径
            offset: Offset(0, -2.h), // x, y 偏移
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SignInTitleWidget(title: '签到条件'),
          Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: RichText(
              text: TextSpan(
                text: _buildRechargeTitle(),
                style: TextStyle(
                  fontSize: 45.sp,
                  color: context.customTheme?.title2Color,
                ),
                children: [
                  TextSpan(
                    text: recharge,
                    style: TextStyle(color: context.theme.primaryColor),
                  ),
                  TextSpan(
                    text: '/${maxRecharge}',
                    style: TextStyle(
                      color: context.customTheme?.title2Color,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: RichText(
              text: TextSpan(
                text: _buildBettingTitle(),
                style: TextStyle(
                  fontSize: 45.sp,
                  color: context.customTheme?.title2Color,
                ),
                children: [
                  TextSpan(
                    text: betAmount,
                    style: TextStyle(
                      color: context.theme.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: '/${maxBetAmount}',
                    style: TextStyle(
                      color: context.customTheme?.title2Color,
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: limitType == 3,
            child: Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: RichText(
                text: TextSpan(
                  text: '时间: ',
                  style: TextStyle(
                    fontSize: 45.sp,
                    color: context.customTheme?.title2Color,
                  ),
                  children: [
                    TextSpan(
                      text:
                          '${DateTimeUtils.formatTimestamp(int.parse('${startTime ?? 0}'))} ~ ${DateTimeUtils.formatTimestamp(int.parse('${endTime ?? 0}'))}',
                      style: TextStyle(
                        color: context.customTheme?.title2Color,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String _buildRechargeTitle() {
    if (limitType == 2) {
      return '累计充值: ';
    } else if (limitType == 3) {
      return '一定时间内充值: ';
    } else if (limitType == 4) {
      return '每日充值: ';
    }
    return '';
  }

  String _buildBettingTitle() {
    if (limitType == 2) {
      return '累计投注: ';
    } else if (limitType == 3) {
      return '一定时间内投注: ';
    } else if (limitType == 4) {
      return '每日投注: ';
    }
    return '';
  }
}
