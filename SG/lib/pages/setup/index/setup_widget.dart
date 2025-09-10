import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/setup/2FA/google/logic.dart';
import 'package:flutter_bet/pages/setup/2FA/google/view.dart';
import 'package:flutter_bet/pages/setup/2FA/pay/logic.dart';
import 'package:flutter_bet/pages/setup/2FA/pay/view.dart';
import 'package:flutter_bet/pages/setup/black_list/logic.dart';
import 'package:flutter_bet/pages/setup/black_list/view.dart';
import 'package:flutter_bet/pages/setup/collection/logic.dart';
import 'package:flutter_bet/pages/setup/collection/view.dart';
import 'package:flutter_bet/pages/setup/contact/logic.dart';
import 'package:flutter_bet/pages/setup/contact/view.dart';
import 'package:flutter_bet/pages/setup/exchange/view.dart';
import 'package:flutter_bet/pages/setup/index/setup_controller.dart';
import 'package:flutter_bet/pages/setup/kyc/view.dart';
import 'package:flutter_bet/pages/setup/login_log/logic.dart';
import 'package:flutter_bet/pages/setup/login_log/view.dart';
import 'package:flutter_bet/pages/setup/password/logic.dart';
import 'package:flutter_bet/pages/setup/password/view.dart';
import 'package:flutter_bet/pages/setup/privacy/logic.dart';
import 'package:flutter_bet/pages/setup/privacy/view.dart';
import 'package:flutter_bet/pages/setup/widgets/setup_tab_bar_widget.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_back_icon_button.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:get/get.dart';

const kCustomSetupWidget = 'kCustomSetupWidget';

class SetupWidget extends StatefulWidget {
  const SetupWidget({super.key});

  @override
  State<StatefulWidget> createState() => _SetupWidget();
}

class _SetupWidget extends State<SetupWidget> {
  late SetupController controller = Get.find<SetupController>();
  AccountServiceListener? accountServiceListener;

  @override
  void dispose() {
    super.dispose();
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

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => SetupController());
    accountServiceListener = AccountServiceListener(
      onTokenInvalid: (){
        CustomSafeDialog.dismiss(context: context,tag: kCustomSetupWidget);
      }
    );
    AccountService.sharedInstance.addListener(accountServiceListener!);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            child: Container(
              color: Colors.transparent,
            ),
            onTap: () => RouteUtil.popView(),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: AppValues.defaultMargin),
                decoration: BoxDecoration(
                  color: ThemeService().theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(AppValues.smallRadius),
                ),
                child: Column(
                  children: [_buildTop(), _buildBody()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildTop() {
  return Padding(
    padding: const EdgeInsets.only(left: AppValues.defaultMargin),
    child: Column(
      children: [
        const SizedBox(
          height: AppValues.largePadding,
        ),
        SizedBox(
          height: 25,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Row(
                  children: [
                    const CustomIcon(
                      asset: 'assets/images/normal/ic_setup.png',
                      size: 20,
                    ),
                    const SizedBox(
                      width: AppValues.smallPadding,
                    ),
                    CustomText(
                      S.current.setting,
                      style: ThemeService()
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Row(
                  children: const [
                    Expanded(child: SizedBox.shrink()),
                    CustomBackIconButton(style: CustomBackIconButtonStyle.close,),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
      ],
    ),
  );
}

Widget _buildBody() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SetupTabBarWidget(
          tabs: [
            Tab(
              child: Text(S.current.tab_bar_title_contact_text,
                  style: ThemeService().textTheme.bodyMedium),
            ),
            // Tab(
            //   child: Text(S.current.tab_bar_title_withdrawal_info_text,
            //       style: ThemeService().textTheme.bodyMedium),
            // ),
            Tab(
              child: Text(S.current.tab_bar_title_change_password_text,
                  style: ThemeService().textTheme.bodyMedium),
            ),


            Tab(
              child: Text(S.current.tab_bar_title_2fa_text,
                  style: ThemeService().textTheme.bodyMedium),
            ),
            Tab(
              child: Text(S.current.wallet_fundPassword,
                  style: ThemeService().textTheme.bodyMedium),
            ),
            Tab(
              child: Text(S.current.tab_bar_title_privacy_text,
                  style: ThemeService().textTheme.bodyMedium),
            ),
            Tab(
              child: Text(S.current.tab_bar_title_login_log_text,
                  style: ThemeService().textTheme.bodyMedium),
            ),
            Tab(
              child: Text(S.current.tab_bar_title_black_list_text,
                  style: ThemeService().textTheme.bodyMedium),
            ),
            // Tab(
            //   child: Text(S.current.tab_bar_kyc_text,
            //       style: ThemeService().textTheme.bodyMedium),
            // ),
            // Tab(
            //   child: Text(S.current.tab_bar_exchange_text,
            //       style: ThemeService().textTheme.bodyMedium),
            // ),
          ],
          children: [
            SetupContactPage(),
            // SetupCollectionInfoPage(),
            ModifyPasswordPage(),
            SetupGoogle2FAPage(),
            SetupPay2FAPage(),

            SetupPrivacyPage(),
            LoginLogPage(),
            BlackListPage(),
            // SetupKYCPage(),
            // SetupExchangePage(),
          ],
        ),
      ],
    ),
  );
}

Future<void> showCustomSetupWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomSetupWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) => const SetupWidget());
}
