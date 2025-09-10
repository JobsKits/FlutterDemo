import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/app/modules/binding_bank_card/controllers/binding_bank_card_controller.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/input/custom_main_text_field.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../controllers/bind_info_config.dart';

class WalletAccountWidget extends GetView<BindingBankCardController> {
  final BindInfoConfig flag;

  WalletAccountWidget(this.flag);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAsterisksTipsText(
          text: _getTitle(),
        ),
        Obx(() {
          return CustomMainTextField(
            hintText: _getTitle(),
            maxLength: 200,
            showError: controller.bankAccountShowError.value,
            text: controller.bankAccountContr.value,
            textColor: controller.bankAccountContr.value.isEmpty
                ? AppThemes.hintTextColorWhite
                : AppThemes.textColorWhite,
            inputCallBack: (str) {
              controller.bankAccountContr.value = str;

              controller.bankAccountShowError.value = controller.assertField(str);
            },
            errorText: _getErrorStr(),
          ).marginOnly(top: 4, bottom: AppValues.margin_12);
        }),
      ],
    );
  }

  String _getTitle() {
    if (flag == BindInfoConfig.walletAcc) {
      return S.current.random_text_1312;
    } else {
      return S.current.random_text_447;
    }
  }

  String _getErrorStr() {
    if (flag == BindInfoConfig.walletAcc) {
      return S.current.random_text_1313;
    } else {
      return S.current.random_text_1314;
    }
  }
}
