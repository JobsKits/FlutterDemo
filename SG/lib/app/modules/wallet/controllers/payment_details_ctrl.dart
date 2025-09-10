import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/wallet/CoinPaymentDetailsBean.dart';
import '../../../../model/wallet/PaymentDetails.dart';
import '../../../../services/api/api_service.dart';
import '../../../../widget/button/custom_button_controller.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';

mixin PaymentDetailsCtrl {
  var applicationDep = PaymentDetails();
  var cryptoDep = CoinPaymentDetailsBean();

  Future<void> bankConfirm(BuildContext context, CustomButtonController btnCtr, String id) async {
    btnCtr.showAnimation();
    await ApiService.instance.bankConfirm(
      success: (bean) {
        Get.back();
      },
      fail: (errorMessage) {
        if (errorMessage != null) {
          CustomSnackBar.showError(errorMessage, context);
        }
        btnCtr.hideAnimation();
      },
      id: id,
    );
    Future.delayed(
      const Duration(seconds: 1),
      () {
        btnCtr.hideAnimation();
      },
    );
  }

  Future<void> bankCancel(BuildContext context, String id) async {
    await ApiService.instance.bankCancel(
      success: (bean) {
        Get.back();
      },
      fail: (errorMessage) {
        if (errorMessage != null) {
          CustomSnackBar.showError(errorMessage, context);
        }
      },
      id: id,
    );
  }

  String formatBankAccountStr(String bankAccount) {
    List<String> chunks = [];
    int length = bankAccount.length;

    for (int i = 0; i < length; i += 4) {
      int endIndex = i + 4;
      if (endIndex > length) {
        endIndex = length; // 避免超出字符串长度
      }
      chunks.add(bankAccount.substring(i, endIndex));
    }

    return chunks.join(' ');
  }

  void onClickCopy(BuildContext? context, String data, GlobalKey globalKey) {
    Clipboard.setData(ClipboardData(text: data));
    DialogUtils.showCustomBubbleCopyDialog(
      context!,
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: CustomText(
          S.current.successfullyCopi,
          textColorStyle: CustomTextColorStyle.dark,
        ),
      ),
      100,
      key: globalKey,
      backgroundColor: AppThemes.widgetColorWhite,
      bubbleArrowHeight: 6,
      bubbleArrowWidth: 8,
      arrowBasisOffset: 30.0,
    );
  }

  Future<void> coinConfirm(BuildContext context, CustomButtonController btnCtr) async {
    btnCtr.showAnimation();
    await ApiService.instance.coinConfirm(
      success: (bean) {
        Get.back();
      },
      fail: (errorMessage) {
        if (errorMessage != null) {
          CustomSnackBar.showError(errorMessage, context);
        }
        btnCtr.hideAnimation();
      },
      id: cryptoDep.id ?? "",
    );
    Future.delayed(
      const Duration(seconds: 1),
      () {
        btnCtr.hideAnimation();
      },
    );
  }

  Future<void> coinCancel(BuildContext context) async {
    await ApiService.instance.coinCancel(
      success: (bean) {
        Get.back();
      },
      fail: (errorMessage) {
        if (errorMessage != null) {
          CustomSnackBar.showError(errorMessage, context);
        }
      },
      id: cryptoDep.id ?? "",
    );
  }
}
