import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/tips_dialog.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/api/activity_api.dart';

import '../data/sign_in_bean.dart';
import '../views/sign_in/sign_in_success_dialog.dart';

class ControllerSignInPage extends GetxController {
  // 条款与规则
  RxList<String> ruleList = <String>[
    '1、连续签到活动，中断后需从第一天开始继续签到，连续登陆签到礼品更丰富。',
    '2、活动时间内，每天一次签到机会。',
    '3、VIP等级更高，每日所得彩金更丰富。',
    '4、为避免对文字的理解歧义，本平台保留对活动的最终解释权。',
  ].obs;

  RxString ruleString = ''.obs; // 后端返回的规则

  RxString betAmount = ''.obs; // 当前投注
  RxString maxBetAmount = ''.obs; // 最大投注
  RxString recharge = ''.obs; // 当前充值
  RxString maxRecharge = ''.obs; // 最大充值

  final RxMap<String, dynamic> vipSignDaConfigs = RxMap<String, dynamic>();

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
  void onInit() {
    super.onInit();

    reqSignInData();

    // 监听登录
    ever(LoginManager.instance.isLogin, (isLogin) async {
      if (isLogin) {
        reqSignInData();
      } else {
        _clearData();
        showLoginDialog();
      }
    });
  }

  void _clearData() {
    ruleString.value = '';
    betAmount.value = '';
    maxBetAmount.value = '';
    recharge.value = '';
    maxRecharge.value = '';

    isSignIn.value = false;
    signInRewardList.value = [];

    signDay.value = 0; // 连续签到天数
    signDayReward.value = 0.00; // 连续签到奖励
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
        vipSignDaConfigs.value = signData.activityRuleConf!.vipSignDaConfigs!;
        print({'signData.activityRuleConf!.vipSignDaConfigs === ${signData.activityRuleConf!.vipSignDaConfigs}'});
      }
    } finally {
      if (needLoading == true) {
        EasyLoading.dismiss();
      }
    }
  }

  // 点击领取
  Future<void> handleReceive() async {
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
}
