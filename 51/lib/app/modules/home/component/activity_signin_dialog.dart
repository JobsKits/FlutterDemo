import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/sign_in_bean.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/sign_in/sign_in_condition_widget.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/sign_in/sign_in_day_widget.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/sign_in/sign_in_rule_widget.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/sign_in/sign_in_success_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_receive_button.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/tips_dialog.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:get/get.dart';
import '../../../../utils/CommonRipple.dart';

class ActivitySigninDialog extends StatefulWidget {
  final SignInBean? model;
  final VoidCallback? onPress;
  final VoidCallback? requestBag;
  final VoidCallback? onClose;

  const ActivitySigninDialog({
    super.key,
    this.model,
    this.onPress,
    this.requestBag,
    this.onClose,
  });

  @override
  _ActivitySigninDialogState createState() => _ActivitySigninDialogState();
}

class _ActivitySigninDialogState extends State<ActivitySigninDialog>
    with SingleTickerProviderStateMixin {
  RxBool isToday = false.obs;
  RxBool isNotDisplay = false.obs;

  // 条款与规则
  RxList<String> ruleList = <String>[].obs;

  RxString ruleString = ''.obs; // 后端返回的规则

  RxString betAmount = ''.obs; // 当前投注
  RxString maxBetAmount = ''.obs; // 最大投注
  RxString recharge = ''.obs; // 当前充值
  RxString maxRecharge = ''.obs; // 最大充值

  // 如果返回1，不显示签到条件；
  // 如果返回2，显示 充值 打码 前面加上累计；
  // 如果返回3，显示 充值 打码 一定时间内 显示开始跟结束时间；
  // 如果返回4，显示 充值 打码
  RxInt limitType = 1.obs; // 充值/打码限制类型

  RxBool isSignIn = false.obs; // 是否已签到

  /// 签到活动数据
  Rx<SignInBean?> signInData = SignInBean().obs;
  RxList<num> signInRewardList = <num>[].obs; // 签到奖励列表

  RxInt signDay = 0.obs; // 连续签到天数
  RxDouble signDayReward = 0.00.obs; // 连续签到奖励

  RxBool isLoading = false.obs; // loading

  @override
  void initState() {
    super.initState();
    signInData.value = widget.model;
    signInRewardList.value = [
      (widget.model?.monday ?? 0) / 1000,
      (widget.model?.tuesday ?? 0) / 1000,
      (widget.model?.wednesday ?? 0) / 1000,
      (widget.model?.thursday ?? 0) / 1000,
      (widget.model?.friday ?? 0) / 1000,
      (widget.model?.saturday ?? 0) / 1000,
      (widget.model?.sunday ?? 0) / 1000,
    ];

    isSignIn.value = widget.model?.day_type == 1;

    // 连续签到天数
    signDay.value = widget.model?.sign_day ?? 0;

    double signReward = 0.00;
    for (int i = 0; i < signInRewardList.length; i++) {
      if ((widget.model!.sign_day ?? 0) > i) {
        signReward += signInRewardList[i];
      }
    }
    // 连续签到奖励
    signDayReward.value = signReward;

    // 每日投注限制
    maxBetAmount.value =
        ((widget.model?.activityRuleConf?.marking_quantity ?? 0) / 1000)
            .truncateToFixed(2);
    betAmount.value =
        ((widget.model?.activityRuleConf?.current_marking_quantity ?? 0) / 1000)
            .truncateToFixed(2);
    // 每日充值限制
    maxRecharge.value = ((widget.model?.activityRuleConf?.amount ?? 0) / 1000)
        .truncateToFixed(2);
    recharge.value =
        ((widget.model?.activityRuleConf?.current_amount ?? 0) / 1000)
            .truncateToFixed(2);

    limitType.value = widget.model?.activityRuleConf?.limit_type ?? 0;

    ruleString.value = widget.model?.activityRuleConf?.sign_rules ?? '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  void isTodayDisplay(bool? isCheck) {
    isToday.value = isCheck ?? !isToday.value;
    if (LoginManager.instance.isLogin.value) {
      saveToday("${'local'}signInLoginToday", isToday.value);
    } else {
      saveToday("${'local'}signInToday", isToday.value);
    }
  }

  void iseveryNotDisplay(bool? isCheck) {
    isNotDisplay.value = isCheck ?? !isNotDisplay.value;
    if (LoginManager.instance.isLogin.value) {
      saveInfo("${'local'}signInLoginNaver", isNotDisplay.value);
    } else {
      saveInfo("${'local'}signInNaver", isNotDisplay.value);
    }
  }

  void saveToday(String saveName, bool value) async {
    if (value) {
      int timestampSeconds = DateTime.now().millisecondsSinceEpoch;
      await SpUtil.saveInt(saveName, timestampSeconds);
    } else {
      await SpUtil.saveInt(saveName, 0);
    }
  }

  //保存用户信息，内存、本地各一份
  void saveInfo(String saveName, bool value) async {
    await SpUtil.saveBool(saveName, value);
  }

  // 点击领取
  Future<void> handleReceive() async {
    if (!LoginManager.instance.isLogin.value) {
      Get.back();
      showLoginDialog();
    }
    // 不可领取
    if (signInData.value?.isLevelReward == 2) {
      EasyLoading.showToast('不能领取，请联系客服');
      return;
    }

    num amount = signInRewardList[signDay.value] ?? 0;
    // 无奖励金额
    if (amount <= 0) {
      EasyLoading.showToast('无奖励金额');
      return;
    }

    try {
      isLoading.value = true;

      final res = await ActivityApi.reqCheckSignInStatus();

      if (res.type == NetworkService.networkTypeSuccess) {
        if (res.data['response_code'] == '9999') {
          // 签到
          final signInRes = await ActivityApi.reqSignIn();

          // 成功
          if (signInRes.type == NetworkService.networkTypeSuccess) {
            Get.dialog(
              SignInSuccessDialog(
                amount: amount.truncateToFixed(2),
              ),
              barrierDismissible: false,
            );
            // 刷新数据
            await reqSignInData(needLoading: false);
            await LoginManager.instance.reqMoney();
            // EasyLoading.showSuccess('签到成功');
          } else if (signInRes.type == NetworkService.networkTypeError) {
            displayTips('${signInRes.data}');
          }

          // 刷新余额
          await LoginApi.reqBalance();
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void displayTips(String tips) {
    Get.dialog(
      TipsDialog(
        tips: tips,
        cancelText: '关闭',
        comfirmText: tips.contains('真实姓名') || tips.contains('短信验证') ||
          tips.contains('邮箱') || tips.contains('生日设置')? '去完成' : tips.contains('登录IP') ? '' :  '去绑定',
        contentF1Size: 42,
        contentF2Size: 35,
        confirmAction: () {
          if (tips.contains('真实姓名')) {
            Get.toNamed(Routes.USER_INFO, arguments: {"isShowSendCode": true});
          } else if (tips.contains('短信验证')) {
            Get.toNamed(Routes.USER_INFO, arguments: {"isShowSendCode": true});
          } else if (tips.contains('邮箱')) {
            Get.toNamed(Routes.USER_INFO, arguments: {"isShowSendCode": true});
          } else if (tips.contains('生日设置')) {
            Get.toNamed(Routes.USER_INFO, arguments: {"isShowSendCode": true});
          } else if (tips.contains('绑定银行卡')) {
            Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT);
          } else if (tips.contains('虚拟货币')) {
            Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT);
          } else if (tips.contains('收款方式')) {
            Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT);
          }
        },
      ),
      barrierDismissible: false,
    );
  }

  // 获取签到数据
  Future<void> reqSignInData({bool? needLoading = true}) async {
    if (!LoginManager.instance.isLogin.value) {
      return;
    }
    try {
      if (needLoading == true) {
        EasyLoading.show(status: '加载中...');
      }

      final response = await ActivityApi.reqSignInData();

      if (response.type == NetworkService.networkTypeSuccess) {
        var signData = SignInBean.fromJson(response.data);
        signInData.value = signData;
        signInRewardList.value = [
          signData.monday! / 1000,
          signData.tuesday! / 1000,
          signData.wednesday! / 1000,
          signData.thursday! / 1000,
          signData.friday! / 1000,
          signData.saturday! / 1000,
          signData.sunday! / 1000,
        ];

        isSignIn.value = signData.day_type == 1;

        // 连续签到天数
        signDay.value = signData.sign_day!;

        double signReward = 0.00;
        for (int i = 0; i < signInRewardList.length; i++) {
          if (signData.sign_day! > i) {
            signReward += signInRewardList[i];
          }
        }
        // 连续签到奖励
        signDayReward.value = signReward;

        // 每日投注限制
        maxBetAmount.value =
            ((signData.activityRuleConf?.marking_quantity ?? 0) / 1000)
                .truncateToFixed(2);
        betAmount.value =
            ((signData.activityRuleConf?.current_marking_quantity ?? 0) / 1000)
                .truncateToFixed(2);
        // 每日充值限制
        maxRecharge.value = ((signData.activityRuleConf?.amount ?? 0) / 1000)
            .truncateToFixed(2);
        recharge.value =
            ((signData.activityRuleConf?.current_amount ?? 0) / 1000)
                .truncateToFixed(2);

        limitType.value = signData.activityRuleConf!.limit_type!;

        ruleString.value = signData.activityRuleConf?.sign_rules ?? '';
      }
    } finally {
      if (needLoading == true) {
        EasyLoading.dismiss();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.transparent.withOpacity(0),
            ),
          ),
          Align(
            // 使用 Align 包裹 Positioned
            alignment: Alignment.center, // 居中
            child: Column(
              mainAxisSize: MainAxisSize.min, // 使 Column 仅占用所需空间
              children: [
                Container(
                  width: 0.9.sw, // Dialog width as a percentage of screen width
                  height: 0.625.sh, // Dialog height as a percentage of screen height
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.5),
                  ),
                  child: Column(
                    children: [
                      _buildTitle(context), // Title fixed at the top
                      Expanded(
                        child: SingleChildScrollView(
                          // Only the body scrolls
                          child: _buildBody(context),
                        ),
                      ),
                      _buildBottom(), // Bottom fixed at the bottom
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: context.theme.cardColor.withOpacity(.9),
                    borderRadius: BorderRadius.circular(12.5),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.close_sharp,
                    color: Colors.red,
                    size: 15,
                  ),
                ).onTap(() {
                  Get.back();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: context.theme.primaryColor.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                '每日签到',
                style: TextStyle(
                  color: context.customTheme?.titleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: CommonRipple(
          //     onTap: () {
          //       Get.back();
          //     },
          //     child: Container(
          //       width: 30,
          //       height: 30,
          //       child: const Icon(
          //         Icons.close_sharp,
          //         color: Color(0xFFCECECE),
          //         size: 25,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => _buildHeader(context)),
        // Sign-in conditions
        Obx(
          () => SignInConditionWidget(
            betAmount: betAmount.value,
            maxBetAmount: maxBetAmount.value,
            recharge: recharge.value,
            maxRecharge: maxRecharge.value,
            limitType: limitType.value,
            startTime: signInData.value?.activityRuleConf?.start_time,
            endTime: signInData.value?.activityRuleConf?.end_time,
            isShow: signInRewardList.isNotEmpty,
          ),
        ),
        // Activity rules and terms
        Obx(
          () => SignInRuleWidget(
            ruleList: ruleList,
            ruleString: ruleString.value,
            isShow: signInRewardList.isNotEmpty,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    bool visible = signInRewardList.isNotEmpty;
    return Container(
      padding: EdgeInsets.fromLTRB(32.w, 30.h, 32.w, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.2, -1.0), // Gradient start
          end: const Alignment(-0.2, 0.7), // Gradient end
          colors: [
            context.theme.primaryColor.withOpacity(0.5), // Start color
            context.customTheme?.dialogBgColor ?? Colors.white, // End color
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.customTheme?.inputBgColor,
              border: Border.all(
                color: context.theme.primaryColor.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: '已连续签到: ',
                    style: TextStyle(
                      fontSize: 36.sp,
                      color: context.theme.primaryColor.withOpacity(0.8),
                    ),
                    children: [
                      TextSpan(
                        text: parseNumber(signDay.value),
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
                      ),
                    ],
                  ),
                ),
                Spacer(),
                RichText(
                  textAlign: TextAlign.end,
                  text: TextSpan(
                    text: '已领取: ',
                    style: TextStyle(
                      fontSize: 36.sp,
                      color: context.theme.primaryColor.withOpacity(0.8),
                    ),
                    children: [
                      TextSpan(
                        text: signDayReward.value.truncateToFixed(2),
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 80.h),
          Visibility(
            visible: visible,
            child: Center(
              child: Wrap(
                spacing: 40.h,
                runSpacing: 40.w,
                children: _buildSignInDaysWidgets(),
              ),
            ),
          ),
          // Visibility(
          //   visible: visible,
          //   child: Center(
          //     child: Wrap(
          //       spacing: 40.h,
          //       runSpacing: 40.w,
          //       children: List.generate(
          //         widget.model?.activityRuleConf?.vipSignDaConfigs?['${LoginManager.instance.vipLevel.value}']?.length ?? 0,
          //         (index) {
          //           final rewardList = widget.model!.activityRuleConf?.vipSignDaConfigs?['${LoginManager.instance.vipLevel.value}'][index];
          //           return SignInDayWidget(
          //             day: 1 + index,
          //             isReceived: index < signDay.value,
          //             reward: rewardList['rewardType'] == 1 ? (rewardList['singleAmount'] / 1000).toString() : '${(rewardList['minAmount'] / 1000).toString()} ~ ${(rewardList['maxAmount'] / 1000).toString()}',
          //             pic: rewardList['pic']
          //           );
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(height: 50.h),
          Visibility(
            visible: visible,
            child: CommonReceiveButton(
              title: isSignIn.value && signDay.value > 0 ? '已签到' :  !LoginManager.instance.isLogin.value ? '立即登录' : '立即签到',
              loading: isLoading.value,
              disabled: isSignIn.value,
              onTap: handleReceive,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSignInDaysWidgets() {
  // Safely get the configurations for current VIP level
    final vipLevel = LoginManager.instance.vipLevel.value.toString();
    final configList = widget.model?.activityRuleConf?.reward_method == 2
      ? widget.model?.activityRuleConf?.vipSignDaConfigs?.values.first
      : widget.model?.activityRuleConf?.vipSignDaConfigs?[vipLevel];

    print({'o = ${widget.model?.activityRuleConf?.vipSignDaConfigs}'});
    print({'hasVipConfig = ${widget.model?.hasVipConfig}'});
    print({'vipLevel == ${vipLevel}'});
    print({'configList == ${configList}'});

    // Return empty list if no configurations found
    if (configList == null || configList.isEmpty) {
      return [];
    }

    return List.generate(
      configList.length,
      (index) {
        final rewardList = configList[index];
        return SignInDayWidget(
          day: 1 + index,
          isReceived: index < signDay.value,
          reward: rewardList['rewardType'] == 1
            ? (rewardList['singleAmount'] / 1000).toString()
            : '${(rewardList['minAmount'] / 1000).toString()} ~ ${(rewardList['maxAmount'] / 1000).toString()}',
          pic: rewardList['pic'] ?? '',
        );
      },
    );
  }

  Widget _buildBottom() {
    return Container(
      decoration: BoxDecoration(
        color: context.customTheme?.dialogBgColor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 48.w,
                height: 48.h,
                child: Transform.scale(
                  scale: 0.8,
                  child: Obx(() => Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        value: isToday.value,
                        onChanged: (bool? value) {
                          isTodayDisplay(value);
                        },
                        activeColor: context.theme.primaryColor,
                        checkColor: Colors.white,
                        side: const BorderSide(color: Colors.grey),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )),
                ),
              ),
              SizedBox(width: 20.w),
              CommonRipple(
                onTap: () {},
                child: Text(
                  '今天不再提示',
                  style: TextStyle(
                      fontSize: 38.sp, color: const Color(color99999)),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              SizedBox(
                width: 48.w,
                height: 48.h,
                child: Transform.scale(
                  scale: 0.8,
                  child: Obx(() => Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        value: isNotDisplay.value,
                        onChanged: (bool? value) {
                          iseveryNotDisplay(value);
                        },
                        activeColor: context.theme.primaryColor,
                        checkColor: Colors.white,
                        side: const BorderSide(color: Colors.grey),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )),
                ),
              ),
              SizedBox(width: 20.w),
              CommonRipple(
                onTap: () {},
                child: Text(
                  '永不提示',
                  style: TextStyle(
                      fontSize: 38.sp, color: const Color(color99999)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
