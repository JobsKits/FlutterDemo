import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_sign_in_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/sign_in/sign_in_condition_widget.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/sign_in/sign_in_day_widget.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/sign_in/sign_in_rule_widget.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_receive_button.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:get/get.dart';

class TurntableReceiveDialog extends StatefulWidget {
  final int id;
  final VoidCallback? onPress;
  final VoidCallback? requestBag;
  final VoidCallback? onClose;

  const TurntableReceiveDialog({
    super.key,
    this.id = 0,
    this.onPress,
    this.requestBag,
    this.onClose,
  });

  @override
  _TurntableReceiveDialogState createState() => _TurntableReceiveDialogState();
}

class _TurntableReceiveDialogState extends State<TurntableReceiveDialog>
    with SingleTickerProviderStateMixin {
  final ControllerSignInPage controller = Get.put(ControllerSignInPage());

  RxBool isToday = false.obs;
  RxBool isNotDisplay = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void isTodayDisplay(bool? isCheck) {
    isToday.value = isCheck ?? !isToday.value;
    saveToday("signInToday", isToday.value);
  }

  void iseveryNotDisplay(bool? isCheck) {
    isNotDisplay.value = isCheck ?? !isNotDisplay.value;
    saveInfo("signInNaver", isNotDisplay.value);
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Container(
        width: 0.9.sw, // Dialog width as a percentage of screen width
        height: 0.8.sh, // Dialog height as a percentage of screen height
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.5),
        ),
        child: Column(
          children: [
            _buildTitle(), // Title fixed at the top
            Expanded(
              child: SingleChildScrollView(
                // Only the body scrolls
                child: _buildBody(),
              ),
            ),
            _buildBottom(), // Bottom fixed at the bottom
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Color(0XFFA5EEF8).withOpacity(0.5),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Center(
              child: Text(
                '每日签到',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 30,
                height: 30,
                child: const Icon(
                  Icons.close_sharp,
                  color: Color(0xFFCECECE),
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => _buildHeader()),
        // Sign-in conditions
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
        // Activity rules and terms
        Obx(
          () => SignInRuleWidget(
            ruleList: controller.ruleList,
            ruleString: controller.ruleString.value,
            isShow: controller.signInRewardList.isNotEmpty,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    bool visible = controller.signInRewardList.isNotEmpty;
    return Container(
      padding: EdgeInsets.fromLTRB(32.w, 30.h, 32.w, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.2, -1.0), // Gradient start
          end: const Alignment(-0.2, 0.7), // Gradient end
          colors: [
            const Color(0XFFA5EEF8).withOpacity(0.5), // Start color
            const Color(colorFFFFFF), // End color
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color(0xFFA6C8CB),
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
                      color: const Color(0xFF6DA2AD),
                    ),
                    children: [
                      TextSpan(
                        text: parseNumber(controller.signDay.value),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 60.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '天',
                        style: TextStyle(
                          color: Colors.black,
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
                      color: const Color(0xFF6DA2AD),
                    ),
                    children: [
                      TextSpan(
                        text: controller.signDayReward.value.truncateToFixed(2),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 45.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '元',
                        style: TextStyle(
                          color: Colors.black,
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
                children: List.generate(
                  controller.signInRewardList.length,
                  (index) {
                    return SignInDayWidget(
                      day: 1 + index,
                      isReceived: index < controller.signDay.value,
                      reward: controller.signInRewardList[index].toString(),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 50.h),
          Visibility(
            visible: visible,
            child: CommonReceiveButton(
              title: controller.isSignIn.value && controller.signDay.value > 0
                  ? '已签到'
                  : '立即签到',
              loading: controller.isLoading.value,
              disabled: controller.isSignIn.value,
              onTap: controller.handleReceive,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
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
              InkWell(
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
              InkWell(
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
