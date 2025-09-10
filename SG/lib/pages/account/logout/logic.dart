import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/constant/app_event_key.dart';
import 'package:flutter_bet/pages/account/logout/view.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/services/event/event_service.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import '../../../controllers/global_state_controller.dart';

class LogoutController extends GetxController {
  final GlobalStateController globaController = Get.find<GlobalStateController>();
  Future<void> onLogout(
      BuildContext context, CustomButtonController btnCtr) async {
    btnCtr.showAnimation();
    await AccountService.sharedInstance.logoutUser();
    globaController.bindEmail.value = false;
    globaController.bindPayed.value = false;
    globaController.bindGoogle.value = false;
    btnCtr.hideAnimation();
    Future.delayed(const Duration(milliseconds: 300), () {
      CustomSafeDialog.dismiss(context: context, tag: kCustomLogoutWidget);
    });
    globaController.onArticleCollect();
  }
}
