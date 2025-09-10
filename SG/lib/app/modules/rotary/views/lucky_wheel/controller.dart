import 'package:flutter_bet/constant/app_values.dart';
import 'package:get/get.dart';
import '../../../../../controllers/global_state_controller.dart';
import '../../../../../utils/route_util.dart';

class LuckyWheelController extends GetxController {
  LuckyWheelController();
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final coinIcDomain = '${AppValues.defaultBranch.asset_url}/currency/';
  final coinIcExtensionName = ".webp";

  _initData() {
    update(["lucky_wheel"]);
  }

  void onTap() {
    RouteUtil.popView();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
