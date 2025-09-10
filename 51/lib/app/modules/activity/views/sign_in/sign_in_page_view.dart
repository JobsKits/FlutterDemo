import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import '../../controllers/controller_sign_in_page.dart';

import 'sign_in_rule_widget.dart';
import 'sign_in_condition_widget.dart';
import 'sign_in_day_widget.dart';
import '../../widget/common_receive_button.dart';

class SignInPageView extends GetView<ControllerSignInPage> {
  const SignInPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.navbarBg,
      appBar: null,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.reqSignInData(); // 调用刷新数据的方法
        },
        child: SingleChildScrollView(
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => _buildHeader(context)),
        // 签到条件
        Obx(
          () => SignInConditionWidget(
            betAmount: controller.betAmount.value,
            maxBetAmount: controller.maxBetAmount.value,
            recharge: controller.recharge.value,
            maxRecharge: controller.maxRecharge.value,
            limitType: controller.limitType.value,
            startTime:
                controller.signInData.value?.activityRuleConf?.start_time,
            endTime: controller.signInData.value?.activityRuleConf?.end_time,
            isShow: controller.signInRewardList.isNotEmpty,
          ),
        ),
        // 活动规则与条款
        Obx(
          () => SignInRuleWidget(
            ruleList: controller.ruleList,
            ruleString: controller.ruleString.value,
            isShow: controller.signInRewardList.isNotEmpty,
          ),
        )
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    bool visible = controller.signInRewardList.isNotEmpty;
    return Container(
      constraints: BoxConstraints(minHeight: 1200.h),
      padding: EdgeInsets.fromLTRB(32.w, 30.h, 32.w, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.2, -1.0), // 渐变起始点
          end: const Alignment(-0.2, 0.7), // 渐变结束点
          colors: [
            context.theme.primaryColor.withOpacity(0.5), // 渐变的开始颜色
            context.customTheme?.pageBg ?? Colors.transparent, // 渐变的结束颜色
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '签到领彩金',
                      style: TextStyle(
                          fontSize: 72.sp, color: context.theme.primaryColor),
                    ),
                    Text(
                      '每日签到即可免费领彩金',
                      style: TextStyle(
                          fontSize: 40.sp, color: context.theme.primaryColor),
                    ),
                    SizedBox(height: 60.h),
                    RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        text: '已连续签到: ',
                        style: TextStyle(
                          fontSize: 36.sp,
                          color: context.theme.primaryColor.withOpacity(0.3),
                        ),
                        children: [
                          TextSpan(
                            text: parseNumber(controller.signDay.value),
                            style: TextStyle(
                              color: context.customTheme?.titleColor,
                              fontSize: 60.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: '天',
                            style: TextStyle(
                              color: context.customTheme?.titleColor,
                              fontSize: 33.sp,
                            ),
                          )
                        ],
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: '已领取: ',
                        style: TextStyle(
                          fontSize: 36.sp,
                          color: context.theme.primaryColor.withOpacity(0.3),
                        ),
                        children: [
                          TextSpan(
                            text: controller.signDayReward.value
                                .truncateToFixed(2),
                            style: TextStyle(
                              color: context.customTheme?.titleColor,
                              fontSize: 45.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(
                              color: context.customTheme?.titleColor,
                              fontSize: 33.sp,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Image.asset(
                  Assets.theme1.images.activity.signIn.signInBg.path,
                  width: 350.w,
                  height: 392.h,
                )
              ],
            ),
          ),
          SizedBox(height: 80.h),
          Visibility(
            visible: visible,
            child: Wrap(
              spacing: 20.h,
              runSpacing: 20.w,
              children: List.generate(
                controller.signInData.value?.activityRuleConf?.reward_method == 2
                  ? controller.vipSignDaConfigs.values.first.length
                  : controller.vipSignDaConfigs['${LoginManager.instance.vipLevel.value}'].length,
                (index) {
                  final rewardList = controller.signInData.value?.activityRuleConf?.reward_method == 2
                    ? controller.vipSignDaConfigs.values.first[index]
                    : controller.vipSignDaConfigs['${LoginManager.instance.vipLevel.value}'][index];
                  return SignInDayWidget(
                    day: 1 + index,
                    isReceived: index < controller.signDay.value,
                    reward: rewardList['rewardType'] == 1 ? (rewardList['singleAmount'] / 1000).toString() : '${(rewardList['minAmount'] / 1000).toString()} ~ ${(rewardList['maxAmount'] / 1000).toString()}',
                    pic: rewardList['pic']
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          Visibility(
            visible: visible,
            child: CommonReceiveButton(
              title: controller.isSignIn.value && controller.signDay.value > 0
                  ? '已签到'
                  : '立即签到',
              loading: controller.isLoading.value,
              disabled: controller.isSignIn.value,
              onTap: () {
                controller.handleReceive();
              },
            ),
          ),
        ],
      ),
    );
  }
}
