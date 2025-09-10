import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/views/pact_sel_view.dart';
import 'package:flutter_bet/app/modules/wallet/views/payment_m_view.dart';
import 'package:flutter_bet/app/modules/wallet/views/tabbar_widget.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../pages/personal_center/wallet/auth_widget.dart';
import '../../../../utils/vault_util.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../../../../widget/status/custom_load_state_view.dart';
import '../../../../widget/status/load_state_config.dart';
import '../controllers/wallet_controller.dart';
import 'coin_sel_view.dart';

class DepositView extends GetView<WalletCtrl> {
  DepositView({Key? key}) : super(key: key);
  final GlobalKey rootViewGlobalKey = GlobalKey();
  final GlobalKey globalKeyCoin = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: rootViewGlobalKey,
      child: Obx(() {
        return Visibility(
          visible: !controller.isPaymentView.value,
          child: Column(
            children: [TabBarWidget(), CoinSelView().marginOnly(left: 14, right: 14), _rootView()],
          ),
        );
      }),
    );
  }

  Widget _rootView() {
    return Obx(() {
      return CustomLoadStateLayout(
        configType: LoadStateConfigType.def,
        configState: controller.viewState.value,
        showEmptyRetry: false,
        showErrorRetry: false,
        configSuccess: contentView(),
      );
    });
  }

  Widget contentView() {
    return Column(
      children: [
        Visibility(
          visible: !controller.fiatCurrTabSel.value,
          child: PactSelView((model) {
            controller.saveSelectedPact(model);
          }),
        ).marginOnly(left: 14, right: 14),
        SizedBox(
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomText(S.current.random_text_1135,
                style: const TextStyle(fontWeight: FontWeight.w600),
                textColorStyle: CustomTextColorStyle.normal),
          ),
        ).marginOnly(left: 14, right: 14, top: 16, bottom: 6),
        const PaymentMethodView().marginOnly(left: 14, right: 14, bottom: 16),
        Visibility(
            visible: VaultUtil.isSecretNot() && !VaultUtil.isEmailCheckStateNotBind(),
            child: const AuthWidget())
      ],
    );
  }
}
