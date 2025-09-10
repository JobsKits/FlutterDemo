import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/setup/index/setup_controller.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import '../../../base/getx/base_controller.dart';
import '../../../constant/app_common.dart';
import '../../../model/mobile_area_code.dart';
import '../../../services/account_service.dart';
import '../2FA/google/logic.dart';
import '../2FA/pay/logic.dart';
import '../black_list/logic.dart';
import '../contact/logic.dart';
import '../login_log/logic.dart';
import '../password/logic.dart';
import '../privacy/logic.dart';

class SetupLogic extends BaseController with GetTickerProviderStateMixin {
  AccountServiceListener? accountServiceListener;
  final isCheck = false.obs;
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  bool isKeyboardVisible = false;
  late StreamSubscription<bool> keyboardSubscription;//S.current.tab_bar_title_2fa_text,
  final list = [S.current.tab_bar_title_contact_text,S.current.tab_bar_title_change_password_text,S.current.tab_bar_title_login_log_text,].obs;
  final index = 0.obs;
  final showIndex = 100.obs;
  final showCode = false.obs;
  int areaCodeSelectIndex = -1;
  final areaCodeText = ''.obs;
  final ScrollController scrollController = ScrollController();
  final areaCodeArray = <MobileAreaCodeModel>[];
  final showArray = <MobileAreaCodeModel>[].obs;

  //默认数据
  var tabs = [
    Tab(
      child: Text(S.current.tab_bar_title_contact_text,
          style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ),
    Tab(
      child: Text(S.current.tab_bar_title_change_password_text,
          style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ),
    // Tab(
    //   child: Text(S.current.tab_bar_title_2fa_text, style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    // ),
    // Tab(
    //   child: Text(S.current.tab_bar_title_privacy_text,
    //       style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    // ),
    Tab(
      child: Text(S.current.tab_bar_title_login_log_text,
          style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ),
    // Tab(
    //   child: Text(S.current.tab_bar_title_black_list_text,
    //       style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    // ),
  ].obs;

  void onTap() {
    GlobalState.instance.myGlobalVariable = true;
    RouteUtil.popView();
  }

  void showChild(int idx) {
    index.value = idx;
    showIndex.value = idx;
    if (idx == 0) {
      Future.delayed(const Duration(milliseconds: 100),() {
        var setup = Get.find<SetupContactController>();
        setup.getUserInfo();
      });
    }
  }

  changedView(int pageIndex) {
    showChild(pageIndex);
  }

  Future<void> onSelectAreaCode(int index) async {
    final SetupContactController controller = Get.find<SetupContactController>();
    controller.onSelectAreaCode(index);
    areaCodeSelectIndex = index;
    final model = showArray[index];
    areaCodeText.value = '${model.attr} ${model.name}';
  }

  jumpTo() {
    showCode.value = true;
    Future.delayed(const Duration(milliseconds: 100),(){
      scrollController.jumpTo((areaCodeSelectIndex - 3) * 38);
    });
  }

  @override
  void onInit() {
    super.onInit();
    GlobalState.instance.index = 8;
    final keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible = visible;
    });
    if (Get.arguments != null) {
      showChild(Get.arguments?['pageIndex'] ?? 0);
    }
    accountServiceListener = AccountServiceListener(onTokenInvalid: () {
      RouteUtil.popView();
    });
    AccountService.sharedInstance.addListener(accountServiceListener!);
    _brandDetails();
  }

  @override
  void onClose() {
    GlobalState.instance.index = -1;
    super.onClose();
    keyboardSubscription.cancel();
    Get.delete<SetupController>();
    Get.delete<SetupContactController>();
    Get.delete<ModifyPasswordLogic>();
    Get.delete<SetupGoogle2FAController>();
    Get.delete<SetupPay2FAController>();
    Get.delete<SetupPrivacyLogic>();
    Get.delete<LoginLogLogic>();
    Get.delete<BlackListLogic>();
    if (accountServiceListener != null) {
      AccountService.sharedInstance.removeListener(accountServiceListener!);
    }
  }

  _brandDetails() {
    int check = globalController.getVerifyType(); //1谷歌验证 2资金密码 3全部
    isCheck.value = (check == 1 || check == 3);
    buildData();
  }

  buildData() {
    if (isCheck.value) {
      list.value = [S.current.tab_bar_title_contact_text,S.current.tab_bar_title_change_password_text,S.current.tab_bar_title_2fa_textcopy2,S.current.tab_bar_title_login_log_text,];
    } else {
      list.value = [S.current.tab_bar_title_contact_text,S.current.tab_bar_title_change_password_text,S.current.tab_bar_title_login_log_text,];
    }
  }
}
