import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';

import 'sign_in_title_widget.dart';

class SignInRuleWidget extends StatelessWidget {
  final List<String> ruleList;
  final String ruleString;
  final bool isShow;
  const SignInRuleWidget({
    super.key,
    required this.ruleList,
    required this.ruleString,
    required this.isShow,
  });

  @override
  Widget build(BuildContext context) {
    if (isShow == false) {
      return const SizedBox();
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 50.h),
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
      child: ruleString == ''
          ? _buildDefaultRule(context)
          : _buildBackendRule(context),
    );
  }

  Widget _buildBackendRule(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SignInTitleWidget(title: '活动规则与条款'),
      SizedBox(height: 30.h),
      Container(
        constraints: BoxConstraints(
          maxHeight: 1200.h,
        ),
        child: SingleChildScrollView(
          // 添加滚动功能
          child: HtmlWidget(
            ruleString,
            textStyle: TextStyle(
              fontSize: 40.sp,
              color: context.customTheme?.title2Color, // 这里使用您的 Color
              height: 1.2,
            ),
          ),
        ),
      )
    ]);
  }

  Widget _buildDefaultRule(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SignInTitleWidget(title: '活动规则与条款'),
        ...List.generate(
          ruleList.length,
          (index) {
            String item = ruleList[index];
            return Padding(
              padding: EdgeInsets.only(top: index == 0 ? 30.h : 20.h),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 45.sp,
                  color: context.customTheme?.title2Color,
                  height: 1.5,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
