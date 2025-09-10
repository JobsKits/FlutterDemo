import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/views/pact_wd_sel_view.dart';
import 'package:flutter_bet/app/modules/wallet/views/payout_options_view.dart';
import 'package:flutter_bet/app/modules/wallet/views/tabbar_withdraw_widget.dart';
import 'package:flutter_bet/app/modules/wallet/views/unbound_withdraw_info.dart';
import 'package:flutter_bet/app/modules/wallet/views/wd_addr_view.dart';
import 'package:flutter_bet/app/modules/wallet/views/wd_alipay_view.dart';
import 'package:flutter_bet/app/modules/wallet/views/wd_fiatcurr_amt.dart';
import 'package:flutter_bet/app/modules/wallet/views/wd_wallet_view.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../pages/account/ThirdPartyAuthorizationToController.dart';
import '../../../../pages/account/bind_controller.dart';
import '../../../../pages/personal_center/wallet/auth_widget.dart';
import '../../../../pages/personal_center/wallet/email_auth.dart';
import '../../../../pages/personal_center/wallet/set_fund_password.dart';
import '../../../../pages/personal_center/wallet/set_google_auth.dart';
import '../../../../pages/setup/index/logic.dart';
import '../../../../pages/setup/password/logic.dart';
import '../../../../utils/vault_util.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/status/custom_load_state_view.dart';
import '../../../../widget/status/load_state_config.dart';
import '../controllers/withdraw_ctrl.dart';
import 'coin_wd_sel_view.dart';
import 'memo_view.dart';
import 'wd_bnk_view.dart';

class WithdrawView extends GetView<WithDrawCtrl> {
  WithdrawView({Key? key}) : super(key: key);
  final GlobalKey rootViewWdlGlobalKey = GlobalKey();

  final FiatPaymentDetailsToController regController = Get.put(FiatPaymentDetailsToController());
  final logic = Get.put(ModifyPasswordLogic());
  final bindController = Get.put(BindController());

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SetupLogic());
    Get.lazyPut(() => WithDrawCtrl());
    Get.lazyPut(() => BindController());
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: Colors.transparent,
        key: rootViewWdlGlobalKey,
        child: rootView(context),
      ),
    );
  }

  @Deprecated("abandon")
  Widget fiat(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              // PayoutOptionsView(),
              // _payoutView(),
              // WdBnkView(),
              WdFiatCurrAmt(),
              // PassWordView(),
              CustomBigMainButton(
                colorStyle: CustomButtonColorStyle.tertiary,
                onTap: (buttonCtr) {
                  controller.onClickWd(context);
                },
                title: S.current.random_text_1316,
                fontWeight: FontWeight.w600,
              ).marginOnly(top: 16, bottom: 16),
            ],
          ),
        ),
        Visibility(
            visible: VaultUtil.isSecretNot() && !VaultUtil.isEmailCheckStateNotBind(),
            child: const AuthWidget())
      ],
    );
  }

  Widget crypto(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              WdAdrView().marginOnly(top: 16),
              MemoView(),
              WdFiatCurrAmt(),
              // PassWordView(),
              CustomBigMainButton(
                colorStyle: CustomButtonColorStyle.tertiary,
                onTap: (buttonCtr) {
                  controller.onClickWd(context);
                },
                fontWeight: FontWeight.w600,
                title: S.current.random_text_1316,
              ).marginOnly(top: 16, bottom: 16),
            ],
          ),
        ),
        Visibility(
            visible: VaultUtil.isSecretNot() && !VaultUtil.isEmailCheckStateNotBind(),
            child: const AuthWidget())
      ],
    );
  }

  Widget rootView(BuildContext context) {
    return Obx(() {
      return CustomLoadStateLayout(
        configType: LoadStateConfigType.def,
        configState: controller.viewState.value,
        showEmptyRetry: false,
        showErrorRetry: false,
        configSuccess: getShowView(contentView(context)),
      );
    });
  }

  Widget contentView(BuildContext context) {
    return Column(
      children: [
        TabBarWithdrawWidget().marginOnly(left: 16, right: 16),
        Visibility(
            visible: controller.globalController
                    .getCurList(controller.wdFiatCurrTabSel.value,
                        controller.globalController.wcAvailableData.value)
                    .length !=
                1,
            child: CoinWdSelView(rootViewWdlGlobalKey).marginOnly(left: 16, right: 16)),
        Visibility(
          visible: !controller.wdFiatCurrTabSel.value,
          child: PactWdSelView(rootViewWdlGlobalKey, (model) {
            controller.saveSelPact(model);
          }),
        ).marginOnly(left: 16, right: 16),
        //无币种渠道/方式 测试讲不需要了 勿删
        // Obx(() {
        //   return Visibility(
        //     visible: !controller.wdMethod.value,
        //     child: DepositEmptyView(tips: S.current.random_text_795),
        //   );
        // }),
        Obx(() {
          return getContentView(context);
        }),
      ],
    );
  }

  Widget getContentView(BuildContext context) {
    if (!controller.wdFiatCurrTabSel.value) {
      if (controller.ifBindAddress.value) {
        return UnboundWithdrawInfo();
      }
      return crypto(context);
    }
    return Column(
      children: [
        PayoutOptionsView().marginOnly(top: 16, left: 16, right: 16),
        _payoutView(),
      ],
    );
  }

  Widget getShowView(Widget view) {
    return Obx(() => bindController.showIndex.value == 5
        ? view
        : bindController.showIndex.value == 4
            ? GoogleAuth()
            : bindController.showIndex.value == 3
                ? FundPassword()
                : EmailAuth(tips: S.current.wallet_email_hint_auth));
    // if (VaultUtil.isPayPasswordNotSetting()) {
    //   if (VaultUtil.isSecret()) {
    //     return view;
    //   } else {
    //     return Obx(() => (regController.bindIndex.value == 0 && !logic.isBindEmail.value) || (regController.bindIndex.value == 1 && !logic.isBindPhone.value) || (regController.bindIndex.value == 2 && (!logic.isBindEmail.value || !logic.isBindPhone.value))
    //       ? EmailAuth(
    //           tips: S.current.wallet_email_hint_auth,
    //         )
    //       : FundPassword());
    //   }
    // } else {
    //   if (!VaultUtil.isPayPassword() && VaultUtil.isSecretNot()) {
    //     return GoogleAuth();
    //   } else {
    //     return Obx(() => (regController.bindIndex.value == 0 && !logic.isBindEmail.value) || (regController.bindIndex.value == 1 && !logic.isBindPhone.value) || (regController.bindIndex.value == 2 && (!logic.isBindEmail.value || !logic.isBindPhone.value))
    //     ? EmailAuth(
    //           tips: S.current.wallet_email_hint_auth,
    //         )
    //       : view);
    //   }
    // }

    // if (VaultUtil.isEmailCheckStateNotBind()) {
    //   return Obx(() => logic.bindIndex.value != 3
    //       ? EmailAuth(
    //           tips: S.current.wallet_email_hint_auth,
    //         )
    //       : FundPassword());
    // } else {
    //   if (VaultUtil.isPayPasswordNotSetting()) {
    //     if (VaultUtil.isSecret()) {
    //       return view;
    //     } else {
    //       return FundPassword();
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

  Widget _payoutView() {
    if (controller.wdFiatCurrTabSel.value && controller.ifBindCard.value) {
      return UnboundWithdrawInfo();
    }
    var type = controller.payoutOptionBean.value.type;
    switch (type) {
      case 1:
        return WdBnkView();
      case 2:
        return WdAliPayView();
      case 3:
        return WdWalletView();
      default:
        return CustomText(S.current.random_text_1307).marginAll(16);
    }
  }
}
