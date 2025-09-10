import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/app/modules/binding_bank_card/controllers/binding_bank_card_controller.dart';
import 'package:flutter_bet/app/modules/binding_pix/controllers/binding_pix_controller.dart';
import 'package:flutter_bet/app/modules/binding_virtual_address/controllers/binding_virtual_address_controller.dart';
import 'package:flutter_bet/pages/personal_center/wallet/wallet_controller.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../model/wallet/BankcardBean.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_error_tips_text.dart.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_tips*_text.dart.dart';
import '../../../widget/dialog/custom_safe_dialog.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/input/custom_main_text_field.dart';
// import 'binding_bank_card_controller.dart';

const kCustomPassWorldWidget = 'PassWorld';

class PassWorld extends StatefulWidget {
  final isBindBank;

  PassWorld({super.key, this.isBindBank});

  @override
  State<StatefulWidget> createState() {
    return _PassWorldState();
  }
}

class _PassWorldState extends State<PassWorld> with SingleTickerProviderStateMixin {
  var ps = "".obs;
  var psError = "".obs;
  var psShowError = false.obs;

  // late WalletController walletController = Get.find<WalletController>();

  late BindingBankCardController bankCardController = Get.find<BindingBankCardController>();
  late BindingPixController pixController = Get.find<BindingPixController>();
  late BindingVirtualAddressController addressController =
      Get.find<BindingVirtualAddressController>();

  @override
  void initState() {
    super.initState();
    // 1 卡包-绑定银行卡 binbankCONTR 2提款页绑定 3虚拟币 5pix
    if (widget.isBindBank == 1 || widget.isBindBank == 2) {
      Get.lazyPut(() => BindingBankCardController());
      bankCardController.context = context;
    } else if (widget.isBindBank == 3) {
      Get.lazyPut(() => BindingVirtualAddressController());
    } else if (widget.isBindBank == 5) {
      Get.lazyPut(() => BindingPixController());
    }
    // else {
    //   Get.lazyPut(() => WalletController());
    //   walletController.context = context;
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: ThemeService().colorScheme.background,
        ),
        child: Container(
          margin: const EdgeInsets.all(AppValues.defaultMargin),
          child: Column(
            children: [
              _topView(),
              Divider(
                indent: 0.0,
                endIndent: 0.0,
                thickness: 1,
                color: ThemeService().colorScheme.tertiary,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.5),
                child: PinCodeTextField(
                    cursorColor: ThemeService().colorScheme.tertiary,
                    autoFocus: false,
                    length: 6,
                    obscureText: true,
                    cursorWidth: 1,
                    animationType: AnimationType.fade,
                    textStyle: ThemeService().textTheme.titleLarge,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      fieldHeight: 40.w,
                      fieldWidth: 40.w,
                      selectedFillColor: ThemeService().colorScheme.surface,
                      inactiveFillColor: ThemeService().colorScheme.surface,
                      activeFillColor: Colors.transparent,
                      borderWidth: 2,
                      borderRadius: BorderRadius.circular(AppValues.smallRadius),
                      activeColor: ThemeService().colorScheme.tertiary,
                      selectedColor: ThemeService().colorScheme.tertiary,
                      inactiveColor: ThemeService().colorScheme.tertiary,
                      disabledColor: ThemeService().colorScheme.tertiary,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    //0-9
                    appContext: context,
                    onChanged: (String str) => {
                          if (widget.isBindBank == 1 || widget.isBindBank == 2)
                            {
                              bankCardController.passwordContr = str,
                            }
                          else if (widget.isBindBank == 3)
                            {
                              addressController.passwordContr = str,
                            }
                          else if (widget.isBindBank == 5)
                            {pixController.passwordContr = str},
                          ps.value = str,
                          if (str.isNotEmpty) {psShowError.value = false}
                        }),
              ),
              Obx(() {
                return Visibility(
                    visible: psShowError.value ? true : false,
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: CustomErrorTipsText(
                          text: psError.value,
                        )));
              }),
              CustomBigMainButton(
                colorStyle: CustomButtonColorStyle.tertiary,
                title: S.current.confirm,
                onTap: (customButtonController) {
                  log("neco 标识 ${widget.isBindBank}");
                  if (ps.value.isEmpty) {
                    psShowError.value = true;
                    psError.value = S.current.wallet_pleaseEnterFundPassword;
                    return;
                  }
                  if (ps.value.length < 6) {
                    psShowError.value = true;
                    psError.value = S.current.wallet_yourFundPasswordContainsDigit(6);
                    return;
                  }
                  // 1 卡包-绑定银行卡 binbankCONTR 2提款页绑定 3虚拟币 5pix
                  if (widget.isBindBank == 1 || widget.isBindBank == 2) {
                    bankCardController.onBankCardInset(context, customButtonController,
                        currencyId: bankCardController.currencyId,
                        bankAccount: bankCardController.bankAccountContr.value,
                        bankAreaCpf: bankCardController.bankAreaCpfContr.value,
                        bankName: bankCardController.curSelectBank.value.isEmpty
                            ? bankCardController.curSelectAccount.value
                            : bankCardController.curSelectBank.value,
                        openName: bankCardController.openNameContr.value);
                  } else if (widget.isBindBank == 5) {
                    pixController.onBankCardInset(context, customButtonController,
                        currencyId: pixController.currencyId,
                        bankAccount: pixController.bankAccountContr,
                        bankAreaCpf: pixController.bankAreaCpfContr,
                        bankName: pixController.curSelectBank.value.isEmpty
                            ? pixController.curSelectAccount.value
                            : bankCardController.curSelectBank.value,
                        openName: pixController.openNameContr.value);
                  } else if (widget.isBindBank == 3) {
                    addressController.walletInsert(
                        context, customButtonController, addressController.id);
                  }
                },
              ),
              const SizedBox(
                height: AppValues.margin_12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CustomIcon(
          color: AppThemes.iconColor,
          asset: "assets/images/personal_center_icon/password_clock.webp",
          size: 18,
        ),
        const SizedBox(
          width: 4,
        ),
        CustomText(
          S.current.wallet_enterFundPassword,
          style: ThemeService()
              .theme
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

Future<void> showCustomPassWorldWidget<T>({
  required BuildContext context,
  required int isBindBank, //1 卡包-绑定银行卡 binbankCONTR 2提款页绑定 3虚拟币 5pix
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomPassWorldWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
            PassWorld(isBindBank: isBindBank),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}
