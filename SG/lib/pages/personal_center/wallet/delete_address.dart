import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/pages/personal_center/wallet/widget/custom_password_tip.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/button/custom_big_main_button.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_tips*_text.dart.dart';
import '../../../widget/dialog/custom_safe_dialog.dart';
import '../../../widget/input/custom_main_text_field.dart';
import 'binding_bank_card_controller.dart';

const kCustomBindingVirtualAddressWidget = 'DeleteAddress';

class DeleteAddress extends StatefulWidget {
  final bool fiatCurrency; //true 法币
  final subData;

  const DeleteAddress({super.key, required this.fiatCurrency, this.subData});

  @override
  State<StatefulWidget> createState() {
    return _DeleteAddressState();
  }
}

class _DeleteAddressState extends State<DeleteAddress> with SingleTickerProviderStateMixin {
  late BindingBankCardControllerOld controller = Get.find<BindingBankCardControllerOld>();

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => BindingBankCardControllerOld());
    controller.context = context;
    // controller.passwordShowError.value = false ;
    // controller.passwordShowErrorText = "";
    // controller.passwordContr = "";
  }

  @override
  void dispose() {
    controller.inputPassWordShowError.value = false;
    controller.inputPassWord.value = "";
    controller.inputPassWordShowErrorText.value = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            color: ThemeService().colorScheme.background,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppValues.defaultMargin,
              ),
              _topView(),
              // Divider(
              //   indent: 0.0,
              //   endIndent: 0.0,
              //   thickness: 1,
              //   color: ThemeService().colorScheme.tertiary,
              // ),
              Center(child: CustomText(S.current.binding_confirmDeletion)),
              CustomText(
                controller.getCoinOrBankNameTitle(widget.fiatCurrency, widget.subData),
                textColorStyle: CustomTextColorStyle.normal,
              ).marginOnly(left: AppValues.defaultMargin).marginOnly(top: AppValues.defaultMargin),
              dataView(CustomText(
                  "${controller.getCoinOrBankName(widget.subData, widget.fiatCurrency)}")),
              CustomText(controller.getOpenNameOrCurrTypeTitle(widget.fiatCurrency),
                      textColorStyle: CustomTextColorStyle.normal)
                  .marginOnly(left: AppValues.defaultMargin)
                  .marginOnly(top: AppValues.defaultMargin),
              dataView(CustomText(
                  "${controller.getOpenNameOrCurrType(widget.subData, widget.fiatCurrency)}")),
              CustomText(controller.getAddressOrBankAccountTitle(widget.fiatCurrency),
                      textColorStyle: CustomTextColorStyle.normal)
                  .marginOnly(left: AppValues.defaultMargin)
                  .marginOnly(top: AppValues.defaultMargin),
              dataView(CustomText(
                  "${controller.getAddressOrBankAccount(widget.subData, widget.fiatCurrency)}")),

              // Container(
              //   margin: const EdgeInsets.only(
              //       left: AppValues.defaultMargin, right: AppValues.defaultMargin),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       CustomText(
              //           "${controller.getCoinOrBankName(widget.subData, widget.fiatCurrency)}"),
              //       CustomText(
              //           "${controller.getOpenNameOrCurrType(widget.subData, widget.fiatCurrency)}",
              //           style: ThemeService()
              //               .theme
              //               .textTheme
              //               .bodyMedium
              //               ?.copyWith(fontWeight: FontWeight.w500, color: AppThemes.scoreTextColor)),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 12,),
              // Container(
              //   width: double.infinity,
              //   color: ThemeService().colorScheme.surface,
              //   margin: const EdgeInsets.only(
              //       left: AppValues.defaultMargin, right: AppValues.defaultMargin),
              //   padding: const EdgeInsets.only(top: 13, bottom: 13, left: 16),
              //   child: CustomText(
              //       controller.getAddressOrBankAccount(widget.subData, widget.fiatCurrency)),
              // ),
              const SizedBox(
                height: AppValues.defaultMargin,
              ),
              _passWordWidget(isAuthView: true),
              // Obx(() {
              //   return Container(
              //     margin: const EdgeInsets.only(
              //         left: AppValues.defaultMargin, right: AppValues.defaultMargin),
              //     child: CustomMainTextField(
              //       maxLength: 6,
              //       showError: controller.passwordShowError.value,
              //       errorText: controller.passwordShowErrorText,
              //       isPwd: true,
              //       height: 40,
              //       hintText: "",
              //       inputCallBack: (str) {
              //         controller.passwordContr = str;
              //         if (str.isNotEmpty) {
              //           controller.passwordShowError.value = false;
              //         }
              //       },
              //     ),
              //   );
              // }),
              const SizedBox(
                height: AppValues.defaultMargin,
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: AppValues.defaultMargin,
                    right: AppValues.defaultMargin,
                    bottom: AppValues.defaultMargin),
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomBigMainButton(
                        fontWeight: FontWeight.w600,
                        colorStyle: CustomButtonColorStyle.secondaryIcon,
                        onTap: (btr) {
                          Get.back();
                        },
                        title: S.current.wallet_cancel,
                        textColor: AppThemes.widgetColorWhite,
                      ),
                    ),
                    const SizedBox(
                      width: AppValues.defaultMargin,
                    ),
                    Expanded(
                        child: CustomBigMainButton(
                      fontWeight: FontWeight.w600,
                      colorStyle: CustomButtonColorStyle.tertiary,
                      title: S.current.wallet_confirmDelete,
                      onTap: (btnCtr) {
                        if (widget.fiatCurrency) {
                          controller.removeBankcard(
                              context, btnCtr, widget.subData['id'], widget.subData['currency_id']);
                        } else {
                          controller.removeAddress(context, btnCtr, widget.subData['id']);
                        }
                      },
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dataView(Widget childView) {
    return Container(
      margin:
          EdgeInsets.only(top: 6, left: AppValues.defaultMargin, right: AppValues.defaultMargin),
      padding: EdgeInsets.only(top: 13, bottom: 13, left: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color(0xFF2F4553),
      ),
      child: childView,
    );
  }

  Widget _topView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(
              width: AppValues.defaultMargin,
            ),
            const CustomIcon(
              color: AppThemes.iconColor,
              asset: "assets/images/personal_center_icon/delete.webp",
              size: 18,
            ),
            const SizedBox(
              width: 4,
            ),
            CustomText(
              S.current.wallet_deleteConfirmation,
              style: ThemeService()
                  .theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        CupertinoButton(
          padding: EdgeInsets.all(8),
          onPressed: () {
            CustomSafeDialog.dismiss(context: context, tag: kCustomBindingVirtualAddressWidget);
          },
          child: Container(
            alignment: Alignment.centerRight,
            child: const CustomIcon(
              color: AppThemes.iconColor,
              asset: "assets/images/normal/ic_normal_close.png",
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  //资金密码
  Widget _passWordWidget({bool isAuthView = false}) {
    return Visibility(
        visible: isAuthView,
        child: Container(
          margin: EdgeInsets.only(left: AppValues.defaultMargin, right: AppValues.defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CustomAsterisksTipsText(text: S.current.wallet_fundPassword),
              Obx(() {
                return CustomAsterisksTipsText(
                    text: controller.pwdTypeBean.isNotEmpty
                        ? controller.pwdTypeBean['typeName']
                        : "");
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
                            hintText: "${controller.pwdTypeBean["title"]}",
                            text: controller.inputPassWord.value,
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
                    width: LangUtil().isZhCn() ? 100 : 126,
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
                        log("neco  密码配置 ${controller.pwdTypeBean['title']}");
                      },
                    ),
                  )
                ],
              ),
              Obx(() {
                return errorView();
              }),
            ],
          ),
        ));
  }

  Widget errorView() {
    return controller.errView(
        controller.inputPassWordShowError.value, controller.inputPassWordShowErrorText.value);
  }
}

Future<void> showCustomDeleteAddressWidget<T>({
  required BuildContext context,
  required bool fiatCurrency,
  required var currencyId,
  required var subData,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomBindingVirtualAddressWidget,
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
            DeleteAddress(
              fiatCurrency: fiatCurrency,
              subData: subData,
            ),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}
