import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  static SettingController get to => Get.find<SettingController>();

  final cryptoStatus = false.obs;
  final theme = (ThemeService.to.currentThemeLabel.value).obs;

  updateTheme(ThemeObjMode value) {
    theme.value = value;
    ThemeService.to.handleUpdateTheme(value);
  }

  @override
  void onReady() {
    super.onReady();
  }
}
