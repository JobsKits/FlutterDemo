import 'dart:convert';

import 'package:captcha_plugin_flutter/captcha_plugin_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_coding_model/activity_coding_model.dart';
import 'package:flutter_tiyu_app/app/modules/login/data/contact_config_bean.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ActivityDiscountController extends GetxController {
  CaptchaPluginFlutter captchaPlugin = CaptchaPluginFlutter();
  late RxList<String> questionDatas = <String>[].obs;
  final textControllers = <TextEditingController>[].obs;
  int taskId = 0;

  bool isAiVerify = false;
  String captchaId = '845db1e18f3f409f87b0a0e1601a068c';
  String aiValidate = '';
  RxBool isRequestVerify = false.obs; // 是否登录请求
  String verification = '';
  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments as Map<String, dynamic>;
    taskId = arguments['id'];
    final data = jsonDecode(arguments['customModel']);
    final newQuestions =
        List<String>.from(data['applicationInformation'] ?? []);
    questionDatas.assignAll(newQuestions); // 替换整个列表

    textControllers.assignAll(List.generate(
        questionDatas.length, (index) => TextEditingController()));

    verification = data['verification'];
    final yidunCaptchaId = jsonDecode(TenantManager.instance.tenantBean?.sysOptions?.YIDUN_CAPTCHA_ID ?? '');

    captchaId = verification == '2'
      ? yidunCaptchaId['CAPTCHA_ID_3']
      : verification == '3'
        ? yidunCaptchaId['CAPTCHA_ID_4']
        : '';

    if (verification == '2' || verification == '3') {
      initCapt();
    }
  }

  initCapt() {
    CaptchaPluginConfig styleConfig = CaptchaPluginConfig(
        radius: 10,
        capBarTextColor: "#25D4D0",
        capBarTextSize: 18,
        capBarTextWeight: "bold",
        borderColor: "#25D4D0",
        borderRadius: 10,
        backgroundMoving: "#DC143C",
        executeBorderRadius: 10,
        executeBackground: "#DC143C",
        capBarTextAlign: "center",
        capPaddingTop: 10,
        capPaddingRight: 10,
        capPaddingBottom: 10,
        capPaddingLeft: 10,
        paddingTop: 15,
        paddingBottom: 15);

    captchaPlugin.init({
      "captcha_id": captchaId,
      'is_debug': false,
      'is_show_loading': false,
      "dimAmount": 0.8,
      "is_touch_outside_disappear": true,
      "timeout": 8000,
      "is_hide_close_button": false,
      "use_default_fallback": true,
      "failed_max_retry_count": 4,
      "language_type": "zh-CN",
      "is_close_button_bottom": true,
      "styleConfig": styleConfig.toJson(),
      "loading_text": '加载中...',
    });
  }

  requestPromotionApply(List<String> questions, List<String> answers) async {
    final res =
        await ActivityApi.reqCustomApplyPromotion(taskId, questions, answers);
    if (res.type == NetworkService.networkTypeSuccess &&
        res.data['response_code'] == '9999') {
      Get.back(result: true);
      EasyLoading.showSuccess("报名成功，请等待审核");
    }
  }

  @override
  void onClose() {
    // Dispose all controllers when not needed
    for (var controller in textControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  Map<String, String> getAllAnswers() {
    final answers = <String, String>{};
    for (int i = 0; i < questionDatas.length; i++) {
      answers[questionDatas[i]] = textControllers[i].text;
    }
    return answers;
  }

  void showCaptcha(List<String> questions, List<String> answers) {
    aiValidate = '';
    isRequestVerify.value = true;
    captchaPlugin.showCaptcha(onLoaded: () {
      print("================onLoaded==============");
    }, onSuccess: (dynamic data) {
      print('onSuccess: $data');
      bool result = data['result'] == true || data['result'] == 'true';
      if (result) {
        aiValidate = data['validate'];
        isRequestVerify.value = false;
        requestPromotionApply(questions, answers);
      }
    }, onClose: (dynamic data) {
      print('onClose: $data');
      isRequestVerify.value = false;
    }, onError: (dynamic data) {
      print('onError: $data');
      isRequestVerify.value = false;
    });
  }
}
