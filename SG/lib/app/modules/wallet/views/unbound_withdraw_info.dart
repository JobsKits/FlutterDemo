import 'package:flutter_bet/app/modules/wallet/controllers/withdraw_ctrl.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../pages/personal_center/wallet/auth_widget.dart';
import '../../../../utils/vault_util.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';

class UnboundWithdrawInfo extends GetView<WithDrawCtrl> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return dataView().marginOnly(bottom: 16);
    });
  }

  Widget dataView() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppValues.padding_16),
            child: Column(
              children: [
                _tips(),
                _bind(),
              ],
            )),
        Visibility(
                visible: VaultUtil.isSecretNot() && !VaultUtil.isEmailCheckStateNotBind(),
                child: const AuthWidget())
            .marginZero
      ],
    );
  }

  Widget _tips() {
    return Container(
      margin: const EdgeInsets.only(top: AppValues.padding_16),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/personal_center_icon/wallet/cards_tips_bg.png'),
              fit: BoxFit.fill)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 22, bottom: 22),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3, right: 6, left: 4),
                child: Image.asset('assets/images/personal_center_icon/wallet/cards_warning.png',
                    width: 16),
              ),
              Flexible(
                // 使用 Flexible 包裹 Column
                child: Padding(
                  padding: const EdgeInsets.only(right: AppValues.margin_20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        S.current.random_text_655c1,
                        textColorStyle: CustomTextColorStyle.secondary,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        softWrap: true,
                      ),
                      CustomText(
                        S.current.random_text_1140,
                        textColorStyle: CustomTextColorStyle.secondary,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bind() {
    return Padding(
      padding: const EdgeInsets.only(top: AppValues.defaultMargin),
      child: CustomBigMainButton(
        fontWeight: FontWeight.w600,
        colorStyle: CustomButtonColorStyle.tertiary,
        onTap: (btnCtr) {
          controller.withdrawInfo();
        },
        title: controller.wdFiatCurrTabSel.value
            ? S.current.random_text_646
            : S.current.random_text_648,
      ),
    );
  }
}
