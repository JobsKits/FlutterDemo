import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/personal_center/vault/takeout_view.dart';
import 'package:flutter_bet/pages/personal_center/vault/vault_controller.dart';
import 'package:get/get.dart';

import '../../../generated/l10n.dart';
import '../../account/ThirdPartyAuthorizationToController.dart';
import '../../account/bind_controller.dart';
import '../../setup/index/logic.dart';
import '../../setup/password/logic.dart';
import '../wallet/email_auth.dart';
import '../wallet/set_fund_password.dart';
import '../wallet/set_google_auth.dart';
import 'deposit_view.dart';
import 'tabbar_vault.dart';

double bubbleWidthWith = 210;
const ratio = 1.0;

class VaultTabBar extends StatefulWidget {
  const VaultTabBar({super.key});

  @override
  State<VaultTabBar> createState() {
    return _VaultTabBarState();
  }
}

class _VaultTabBarState extends State<VaultTabBar> with SingleTickerProviderStateMixin {
  late VaultController controller = Get.find<VaultController>();
  final FiatPaymentDetailsToController regController = Get.put(FiatPaymentDetailsToController());
  final logic = Get.put(ModifyPasswordLogic());
  final bindController = Get.put(BindController());

  @override
  void initState() {
    super.initState();
    bindController.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SetupLogic());

    controller.context = context;
    return Column(
      children: [
        TabBarWidget(),
        Obx(() {
          return getView();
        }),
      ],
    );
  }

  Widget getStateView() {
    return getShowView(TakeoutView(controller: controller));
  }

  Widget getShowView(Widget view) {
    return Obx(() => bindController.showIndex.value == 5
        ? view
        : bindController.showIndex.value == 4
            ? GoogleAuth()
            : bindController.showIndex.value == 3
                ? FundPassword(isVault: true)
                : EmailAuth(tips: S.current.wallet_email_hint_auth, isVault: true));
    // if (VaultUtil.isPayPasswordNotSetting()) {
    //   if (VaultUtil.isSecret()) {
    //     return view;
    //   } else {
    //     return Obx(() => (regController.bindIndex.value == 0 && !logic.isBindEmail.value) || (regController.bindIndex.value == 1 && !logic.isBindPhone.value) || (regController.bindIndex.value == 2 && (!logic.isBindEmail.value || !logic.isBindPhone.value))
    //       ? EmailAuth(
    //         tips: S.current.wallet_email_hint_auth,
    //         isVault: true,
    //       ) : FundPassword(isVault: true));
    //   }
    // } else {
    //   if (!VaultUtil.isPayPassword() && VaultUtil.isSecretNot()) {
    //     return GoogleAuth();
    //   } else {
    //     return Obx(() => (regController.bindIndex.value == 0 && !logic.isBindEmail.value) || (regController.bindIndex.value == 1 && !logic.isBindPhone.value) || (regController.bindIndex.value == 2 && (!logic.isBindEmail.value || !logic.isBindPhone.value))
    //       ? EmailAuth(
    //             tips: S.current.wallet_email_hint_auth,
    //           )
    //         : view);
    //   }
    // }

    // if (VaultUtil.isEmailCheckStateNotBind()) {
    //   return Obx(() => logic.bindIndex.value != 3 ? EmailAuth(
    //     tips: S.current.wallet_email_hint_auth,
    //     isVault: true,
    //   ) : FundPassword(isVault: true));
    // } else {
    //   if (VaultUtil.isPayPasswordNotSetting()) {
    //     if (VaultUtil.isSecret()) {
    //       return view;
    //     } else {
    //       return FundPassword(isVault: true);
    //     }
    //   } else {
    //     if (!VaultUtil.isPayPassword() && VaultUtil.isSecretNot()) {
    //       return GoogleAuth();
    //     } else {
    //       return view;
    //     }
    //   }
    // }
  }

  Widget getView() {
    return controller.isDeposits.value
        ? DepositView(controller: controller)
        : Visibility(
            visible: controller.openVerificationAndPayPasswordFrequency.value < 10000,
            child: getStateView());
  }
}
