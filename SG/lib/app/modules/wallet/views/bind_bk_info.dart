import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/app/modules/wallet/views/wallet_account_widget.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../pages/personal_center/wallet/widget/custom_password_tip.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_check_box.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/input/custom_main_text_field.dart';
import '../../../../widget/status/custom_load_state_view.dart';
import '../../../../widget/status/load_state_config.dart';
import '../../binding_bank_card/controllers/binding_bank_card_controller.dart';
import '../controllers/bind_info_config.dart';
import 'bind_payout_option_widget.dart';

class BindBkInfoView extends GetView<BindingBankCardController> {
  var _context;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BindingBankCardController());
    _context = context;
    return Material(
      color: Colors.transparent,
      child: rootView(),
    );
  }

  Widget rootView() {
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
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      child: Column(
        children: [
          CustomAsterisksTipsText(
            text: S.current.random_text_1122,
          ),
          Obx(() {
            //name
            return CustomMainTextField(
              hintText: S.current.random_text_1122,
              maxLength: 200,
              showError: controller.openNameShowError.value || controller.showBankNameError.value,
              enabled: controller.openName.value.isEmpty ? true : false,
              text: controller.openNameContr.value,
              textColor: controller.openName.value.isEmpty
                  ? AppThemes.textColorWhite
                  : AppThemes.hintTextColorWhite,
              inputCallBack: (str) {
                controller.openNameContr.value = str;
                controller.openNameShowError.value = controller.assertField(str);
                controller.checkBankName(controller.openNameContr.value);
              },
              errorText: controller.bankNameErrorText.value,
              focusNode: controller.focusNodeBankName,
            ).marginOnly(top: 4, bottom: AppValues.margin_12);
          }),
          //提款方式
          controller.withDrawCtrl.payoutOptions.length >= 2
              ? BindPayoutOptionWidget(BindInfoConfig.payoutOptions)
                  .marginOnly(bottom: AppValues.margin_12)
              : const SizedBox(),
          Obx(() {
            return _getSelectView();
          }),
          _passWordWidget(isAuthView: true).marginOnly(bottom: AppValues.margin_12),
          Obx(() {
            return GestureDetector(
              onTap: () {
                controller.isDefault.value = !controller.isDefault.value;
              },
              child: Row(
                children: [
                  CustomCheckBox(
                    iconSize: 16,
                    value: controller.isDefault.value,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(child: CustomText(S.current.binding_setAsDefaultCardNumber)),
                ],
              ),
            );
          }),
          CustomText(
            S.current.random_text_704,
            textColorStyle: CustomTextColorStyle.normal,
          ).marginOnly(top: AppValues.margin_12, bottom: AppValues.margin_12),
          CustomBigMainButton(
            fontWeight: FontWeight.w600,
            colorStyle: CustomButtonColorStyle.tertiary,
            onTap: (customButtonController) {
              controller.onClickBindCard(_context, customButtonController);
            },
            title: S.current.random_text_1288,
          ).marginOnly(bottom: AppValues.margin_12),
        ],
      ),
    );
  }

  //资金密码
  Widget _passWordWidget({bool isAuthView = false}) {
    return Visibility(
        visible: isAuthView,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CustomAsterisksTipsText(text: S.current.wallet_fundPassword),
            Obx(() {
              return CustomAsterisksTipsText(
                  text:
                      controller.pwdTypeBean.isNotEmpty ? controller.pwdTypeBean['typeName'] : "");
            }),
            const SizedBox(
              height: AppValues.margin_4,
            ),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Obx(() {
                        return CustomMainTextField(
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: controller.getBoxDecoration(
                              showErr: controller.inputPassWordShowError.value),
                          isUpdatePsdOffset: true,
                          showError: controller.inputPassWordShowError.value,
                          // errorText: controller.inputPassWordShowErrorText.value,
                          maxLength: 6,
                          isPwd: true,
                          text: controller.inputPassWord.value,
                          hintText: controller.pwdTypeBean.isNotEmpty
                              ? controller.pwdTypeBean['typeName']
                              : "",
                          inputCallBack: (str) {
                            controller.inputPassWord.value = str;
                            controller.checkInputPassWord();
                          },
                        );
                      }),
                    ],
                  ),
                ),
                Container(
                  width: controller.globalController.isChinese() ? 100 : 126,
                  height: AppValues.defaultTextHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ThemeService().colorScheme.tertiaryContainer,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4), bottomRight: Radius.circular(4))),
                  child: CustomPasswordTips(
                    onPwdTypeSelected: (selectedPwdType) {
                      controller.pwdTypeBean.value = selectedPwdType;
                      controller.inputPassWordShowErrorText.value =
                          S.current.binding_bank_card_please_enter +
                              "${controller.pwdTypeBean["title"]}";
                    },
                  ),
                )
              ],
            ),
            Obx(() {
              return errorView();
            }),
          ],
        ));
  }

  Widget errorView() {
    return controller.errView(
        controller.inputPassWordShowError.value, controller.inputPassWordShowErrorText.value);
  }

  Widget _getSelectView() {
    var type = controller.withDrawCtrl.payoutOptionBean.value.type;
    switch (type) {
      case 1:
        return Column(
          children: [
            BindPayoutOptionWidget(BindInfoConfig.selectBank)
                .marginOnly(bottom: AppValues.margin_12),

            ///开户网点
            Visibility(
                visible: controller.isCNY,
                child: CustomAsterisksTipsText(text: S.current.wallet_accountOpeningOutlets)),
            Visibility(visible: controller.isCNY, child: const SizedBox(height: 4)),
            Visibility(
              visible: controller.isCNY,
              child: Obx(() {
                return CustomMainTextField(
                  hintText: S.current.wallet_accountOpeningOutlets,
                  showError: controller.registerAreaShowError.value,
                  errorText: controller.registerAreaErrorText.value,
                  text: controller.bankAreaCpfContr.value,
                  inputCallBack: (str) {
                    controller.bankAreaCpfContr.value = str;
                    controller.checkRegisterArea();
                  },
                  // hintText: S.current.binding_bank_card_please_enter,

                  // focusNode: controller.focusNodeBankNum,
                );
              }),
            ),
            Visibility(
                visible: controller.isCNY, child: const SizedBox(height: AppValues.margin_12)),

            ///银行卡号
            CustomAsterisksTipsText(text: S.current.binding_bank_card_number),
            Obx(() {
              ///银行卡输入框
              return CustomMainTextField(
                hintText: S.current.binding_bank_card_number,
                showError:
                    controller.bankAccountShowError.value || controller.showBankNumberError.value,
                text: controller.bankAccountContr.value,
                inputCallBack: (str) {
                  controller.bankAccountContr.value = str;
                  // controller.bankNumberText.value = str;
                  controller.bankAccountShowError.value = controller.assertField(str);
                },
                // hintText: S.current.binding_bank_card_please_enter,
                errorText: controller.bankNumberErrorText.value,
                focusNode: controller.focusNodeBankNum,
              ).marginOnly(top: 4, bottom: AppValues.margin_12);
            }),
          ],
        );
      case 2:
        return WalletAccountWidget(BindInfoConfig.aliAcc);
      case 3:
        return Column(
          children: [
            BindPayoutOptionWidget(BindInfoConfig.selectWallet)
                .marginOnly(bottom: AppValues.margin_12),
            WalletAccountWidget(BindInfoConfig.walletAcc)
          ],
        );
      default:
        return CustomText(S.current.random_text_1307);
    }
  }
}
