import 'package:flutter_bet/constant/app_values.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import '../../../model/statisical_data/StatisicalDataBean.dart';
import '../../../services/api/api_service.dart';
import '../user_info/logic.dart';

class UserDataStatisticalController extends GetxController {

  late ChatRoomUserInfoController controller = Get.find<ChatRoomUserInfoController>();
  final coinIcDomain = '${AppValues.defaultBranch.asset_url}/currency/';
  final coinIcExtensionName = ".webp";
  final pageIndex = 0.obs;
  final statisticalData = [].obs ;
  final loadingData = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(controller.pageIndex, (callback) {
      betReport(controller.pageIndex);
    });
    betReport(controller.pageIndex);
  }

  betReport(gameClass) async {
    loadingData.value = true;
    await ApiService.instance.betReport<StatisicalDataBean>(
      gameClass: gameClass == 0 ? '' : gameClass.toString(),
      username: controller.username,
      success: (bean) {
        loadingData.value = false;
        statisticalData.clear();
        statisticalData.addAll(bean);
      },
      fail: (message) {
        loadingData.value = false;
      },
      converter: (json) {
        return StatisicalDataBean.fromJson(json);
      });
  }
}