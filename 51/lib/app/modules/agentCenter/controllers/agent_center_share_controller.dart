import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/agent_center_api.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

class AgentCenterShareController extends GetxController {
  RxString promotionUrl = ''.obs; // 推广链接
  RxString promotionCode = ''.obs; // 推广Code
  RxString ruleImageUrl = ''.obs; // 代理规则图片
  RxString popularizeTutorial = ''.obs; // 代理反水规则及说明
  RxString bonus = '0'.obs; // 可领取奖励

  RxBool isLoading = false.obs; // loading

  @override
  void onInit() {
    super.onInit();

    initData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // 数据请求
  Future<void> initData() async {
    _reqMyShare();
    // _reqMyShareRebate();
    _reqBalance();
  }

  // 获取代理未发放佣金金额
  Future<void> _reqBalance() async {
    final response = await AgentCenterApi.reqBalance();

    if (response.type == NetworkService.networkTypeSuccess) {
      if (response.data != null) {
        bonus.value =
            parseNumber(double.parse('${(response.data ?? 0) / 1000}'));
      }
    }
  }

  // 获取分享信息
  Future<void> _reqMyShare() async {
    final response = await AgentCenterApi.reqMyShare();

    if (response.type == NetworkService.networkTypeSuccess) {
      // 推广链接以及code
      if (response.data != null) {
        promotionUrl.value = response.data['link_addr'];
        promotionCode.value = response.data['promote_code'];
        ruleImageUrl.value =
            response.data['agent_rule_image_url'] ?? ''; // 代理规则图片
        popularizeTutorial.value =
            response.data['popularize_tutorial'] ?? ''; // 代理反水规则及说明
      }
    }
  }

  // 获取分享奖励
  // Future<void> _reqMyShareRebate() async {
  //   final response = await AgentCenterApi.reqMyShareRebate();
  //
  //   if (response.type == NetworkService.networkTypeSuccess) {
  //     // print('_reqMyShareRebate====> ${response.data}');
  //     if (response.data != null) {
  //       bonus.value = parseNumber(
  //           double.parse('${(response.data['receive_rebate'] ?? 0) / 1000}'));
  //     }
  //   }
  // }

  //  代理 手动领取佣金数量 领取
  Future<void> reqGetYongJin() async {
    if (double.parse(bonus.value) <= 0) {
      EasyLoading.showToast('暂无可领取金额');
      return;
    }
    try {
      isLoading.value = true;
      final response = await AgentCenterApi.reqGetYongJin();

      // 成功
      if (response.type == NetworkService.networkTypeSuccess) {
        if (response.data['response_code'] == '9999') {
          EasyLoading.showSuccess('领取成功');

          await _reqBalance();
        } else {
          EasyLoading.showSuccess('领取失败');
        }
      }
    } finally {
      isLoading.value = false;
    }
  }
}
