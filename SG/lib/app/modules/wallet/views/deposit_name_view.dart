import 'package:flutter_bet/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/input/custom_main_text_field.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';

class DepositNameView extends GetView<WalletCtrl> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: controller.pwySelBean.value.payment_type == 2 &&
            controller.getMergerSelCoin(controller.fiatCurrTabSel.value).currency_type != 2,
        child: _bankDepositNameWidget());
  }

  Widget _bankDepositNameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        CustomAsterisksTipsText(
            text: S.current.fiat_currency_Depositor_is_name,
            textStyle: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(
          height: 5,
        ),
        Obx(() {
          return CustomMainTextField(
            hintColor: AppThemes.walletHintColor,
            hintText: S.current.wallet_pleaseEnterNameDepositor,
            errorText: S.current.wallet_pleaseEnterNameDepositor,
            showError: controller.depNameErr.value,
            text: controller.depName.value,
            inputCallBack: (str) {
              if (str.isNotEmpty) {
                controller.depNameErr.value = false;
              } else {
                controller.depNameErr.value = true;
              }
              controller.depName.value = str;
            },
          );
        }),
      ],
    );
  }
}
