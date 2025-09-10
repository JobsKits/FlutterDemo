import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/pages/personal_center/wallet/widget/custom_password_tip.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/status/custom_load_state_view.dart';
import 'package:flutter_bet/widget/status/load_state_config.dart';
import 'package:get/get.dart';

import '../../../app/modules/binding_pix/controllers/binding_pix_controller.dart';
import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_check_box.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_tips*_text.dart.dart';
import '../../../widget/dialog/custom_safe_dialog.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/input/custom_main_text_field.dart';
import 'auth_widget.dart';

const double bankRatio = 1.8; //银行系数
double bubbleWidth = 114;

const kCustomBindingPixWidget = 'CustomBindingPixWidget';

class BindingPix extends StatefulWidget {
  final String? currencyId;

  final String? bankTree;

  final String? flag;

  BindingPix({super.key, this.currencyId, this.bankTree, this.flag = "1"});

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final GlobalKey _bankGlobalKey = GlobalKey();
  final GlobalKey _globalKeyInput = GlobalKey();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  @override
  State<StatefulWidget> createState() {
    return _BindingPixState();
  }
}

class _BindingPixState extends State<BindingPix> with SingleTickerProviderStateMixin {
  late BindingPixController controller = Get.find<BindingPixController>();
  final GlobalKey<RotatingArrowState> _rotatingArrowCountry = GlobalKey<RotatingArrowState>();
  final GlobalKey _globalKeyCountry = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<BindingPixController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BindingPixController());
    controller.context = context;
    if ((widget.bankTree ?? "").isNotEmpty) {
      controller.bankTree = widget.bankTree;
    }
    if ((widget.currencyId ?? "").isNotEmpty) {
      controller.currencyId = widget.currencyId;
    }
    controller.flag = widget.flag;
    // controller.currencyTypeList();
    // controller.bankcardList();
    // controller.getCountryAndBandBard();
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
      margin: const EdgeInsets.only(left: 16, right: 16, top: 2),
      width: double.infinity,
      child: Obx(() {
        return Column(
          children: [
            // Obx(() {
            //   return _userName();
            // }),
            //账户姓名
            tipsView(),
            const SizedBox(
              height: 4,
            ),
            CustomMainTextField(
              hintText: S.current.random_text_1122,
              maxLength: 200,
              errorText: controller.openNameErrorText.value,
              showError: controller.openNameShowError.value,
              text: controller.openNameContr.value,
              enabled: controller.openName.value.isEmpty ? true : false,
              textColor: controller.openName.value.isEmpty
                  ? AppThemes.textColorWhite
                  : AppThemes.hintTextColorWhite,
              // hintText: S.current.binding_bank_card_please_enter,
              inputCallBack: (str) {
                controller.openNameContr.value = str;
                controller.checkOpenName();
              },
            ),
            const SizedBox(
              height: AppValues.margin_12,
            ),
            // 国家 和 区号
            // _nationalCity(),
            // const SizedBox(
            //   height: AppValues.margin_12,
            // ),
            //需求变更 说去掉 暂时注释
            // const CustomAsterisksTipsText(
            //   text: "详细地址",
            // ),
            // const SizedBox(
            //   height: 4,
            // ),
            // CustomMainTextField(
            //   text: controller.inputAddress.value,
            //   showError: controller.showErrorAddress.value,
            //   errorText: controller.showTextAddress.value,
            //   inputCallBack: (str) {
            //     controller.checkAddress(str);
            //     controller.inputAddress.value = str;
            //   },
            // ),
            // const SizedBox(
            //   height: AppValues.margin_12,
            // ),

            /// PIX账户类型
            CustomAsterisksTipsText(
              // text: S.current.binding_pleaseSelectPIXAccountType,
                text: S.current.random_text_1171),
            const SizedBox(height: 4),
            _selectAccount(widget._rotatingArrowKey, widget._globalKeyInput, 1),
            const SizedBox(height: AppValues.margin_12),

            Visibility(
              visible: controller.bankId.value != controller.cpfId ? true : false,
              child: pixAccountView(),
            ),

            ///CPF
            const CustomAsterisksTipsText(text: "CPF"),
            const SizedBox(height: 4),
            CustomMainTextField(
              enabled: controller.cpfText.value.isEmpty ? true : false,
              textColor: controller.cpfText.value.isEmpty
                  ? AppThemes.textColorWhite
                  : AppThemes.hintTextColorWhite,
              hintText: "CPF",
              errorText: controller.cpfTextErrorText.value,
              showError: controller.cpfTextShowError.value,
              text: controller.bankAreaCpfContr,
              inputCallBack: (str) {
                controller.bankAreaCpfContr = str;
                controller.checkCpfText();
              },
            ),
            const SizedBox(height: AppValues.margin_12),

            ///资金密码
            _passWordWidget(isAuthView: true),
            const SizedBox(height: AppValues.margin_12),
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
                    Expanded(
                        child: CustomText(S.current.random_text_705,
                            textColorStyle: CustomTextColorStyle.normal)),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppValues.margin_12),
            CustomText(
              S.current.random_text_706,
              textColorStyle: CustomTextColorStyle.normal,
            ),

            const SizedBox(height: AppValues.margin_12),
            CustomBigMainButton(
              fontWeight: FontWeight.w600,
              colorStyle: CustomButtonColorStyle.tertiary,
              title: widget.flag == "1" ? S.current.submit_text : S.current.random_text_1288,
              onTap: (customButtonController) {
                // controller.checkName(controller.inputName.value);
                // controller.checkSurname(controller.inputSurname.value);
                // controller.checkAddress(controller.inputAddress.value);
                controller.checkInputPassWord();
                controller.checkOpenName();
                // controller.checkCountry(controller.curSelectCountry.value);
                // controller.checkCity(controller.inputCity.value);
                if (controller.validate() == false) {
                  return;
                }
                //需求变更 暂时注释
                // if (controller.getIsSetupPassword() == false) {
                //   showCustomPromptToPwWidget(context: context);
                //   return;
                // }
                // showCustomPassWorldWidget(context: context, isBindBank: 5);

                controller.onBankCardInset(context, customButtonController,
                    currencyId: controller.currencyId,
                    bankAccount: controller.bankId.value != controller.cpfId
                        ? controller.bankAccountContr
                        : controller.bankAreaCpfContr,
                    //特定
                    bankAreaCpf: controller.bankAreaCpfContr,
                    bankName: controller.curSelectBank.value.isEmpty
                        ? controller.curSelectAccount.value
                        : controller.curSelectBank.value,
                    openName: controller.openNameContr.value);
              },
            ),
            const SizedBox(height: AppValues.margin_12),
          ],
        );
      }),
    );
  }

  Widget pixAccountView() {
    return Column(
      children: [

        ///pix账号
        CustomAsterisksTipsText(
          // text: S.current.binding_pleaseEnterThirdPartyAccount,
          text: S.current.wallet_pixAccount,
        ),
        const SizedBox(height: 4),
        CustomMainTextField(
          hintText: S.current.wallet_pixAccount,
          errorText: controller.bankAccountErrorText.value,
          showError: controller.bankAccountShowError.value,
          text: controller.bankAccountContr,
          inputCallBack: (str) {
            controller.bankAccountContr = str;
            controller.checkBankAccount();
          },
        ),
        const SizedBox(height: AppValues.margin_12),
      ],
    );
  }

  Widget _userName() {
    return SizedBox(
      height: controller.showErrorName.value || controller.showErrorSurname.value ? 90 : 68,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              child: Column(
                children: [
                  CustomAsterisksTipsText(text: S.current.kyc_given_name_text),
                  const SizedBox(
                    height: 4,
                  ),
                  CustomMainTextField(
                    textColor: controller.openNameContr.value.isEmpty
                        ? AppThemes.textColorWhite
                        : AppThemes.hintTextColorWhite,
                    enabled: controller.openNameContr.value.isEmpty ? true : false,
                    text: controller.inputName.value,
                    showError: controller.showErrorName.value,
                    errorText: controller.showTextName.value,
                    inputCallBack: (str) {
                      controller.checkName(str);
                      controller.inputName.value = str;
                    },
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: SizedBox(
              child: Column(
                children: [
                  CustomAsterisksTipsText(text: S.current.kyc_family_name_text),
                  const SizedBox(
                    height: 4,
                  ),
                  CustomMainTextField(
                    textColor: controller.openNameContr.value.isEmpty
                        ? AppThemes.textColorWhite
                        : AppThemes.hintTextColorWhite,
                    enabled: controller.openNameContr.value.isEmpty ? true : false,
                    text: controller.inputSurname.value,
                    showError: controller.showErrorSurname.value,
                    errorText: controller.showTextSurname.value,
                    inputCallBack: (str) {
                      controller.checkSurname(str);
                      controller.inputSurname.value = str;
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 国家 和 区号
  Widget _nationalCity() {
    return SizedBox(
      height: controller.showErrorCountry.value || controller.showErrorCity.value ? 90 : 68,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                CustomAsterisksTipsText(
                  text: S.current.random_text_642,
                ),
                const SizedBox(
                  height: 4,
                ),
                _selectAccount(_rotatingArrowCountry, _globalKeyCountry, 2)
              ],
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              children: [
                CustomAsterisksTipsText(
                  text: S.current.kyc_city_text,
                ),
                const SizedBox(
                  height: 4,
                ),
                CustomMainTextField(
                  text: controller.inputCity.value,
                  showError: controller.showErrorCity.value,
                  errorText: controller.showTextCity.value,
                  inputCallBack: (str) {
                    controller.checkCity(str);
                    controller.inputCity.value = str;
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tipsView() {
    return Row(
      children: [
        CustomAsterisksTipsText(
          text: S.current.random_text_1122,
        ),
        const SizedBox(
          width: 6,
        ),
        Visibility(
          visible: widget.flag == "1",
          child: Expanded(
            child: CustomText(S.current.binding_cannotBeChangedAfterBind,
                style: ThemeService()
                    .theme
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.w500, color: AppThemes.scoreTextColor)),
          ),
        ),
      ],
    );
  }

  Widget _textRich() {
    return Column(
      children: [
        Obx(() {
          return Visibility(
              visible: controller.pwdConfig['is_secret'] != "1" && widget.flag == "1",
              child: const AuthWidget());
        }),
        Visibility(
          visible: widget.flag != "1",
          child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: S.current.binding_bank_card_all_bound_accounts,
                  style: ThemeService()
                      .theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: CustomTextColorStyle.normal.value),
                ),
                TextSpan(
                  text: S.current.binding_bank_card_names_must_match,
                  style: ThemeService()
                      .theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: CustomTextColorStyle.white.value),
                ),
                TextSpan(
                  text: S.current.binding_bank_card_hint,
                  style: ThemeService()
                      .theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: CustomTextColorStyle.normal.value),
                ),
              ])),
        ),
      ],
    );
  }

  Widget _topView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomIcon(
          asset: "assets/images/personal_center_icon/pix_ic.webp",
          size: 18,
        ),
        const SizedBox(
          width: 4,
        ),
        CustomText(
          S.current.binding_bindPIX,
          style: ThemeService()
              .theme
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _selectAccount(GlobalKey<RotatingArrowState> arrow, GlobalKey globalKey, int flag,
      {double width = 160}) {
    return Stack(
      children: [
        GestureDetector(onTap: () {
          if (controller.withDrawCtrl.previousBottomInset > 0) {
            FocusScope.of(Get.context!).requestFocus(FocusNode());
          } else {
            widget._startAnimation(arrow);
            DialogUtils.showCustomBubbleDialog(
                controller.context!,
                flag == 1 ? _selectAccountType(context) : _selectCountry(context),
                flag == 1 ? _getInputWidth() : width,
                widgetKey: globalKey,
                backgroundColor: AppThemes.widgetColorWhite,
                bubbleArrowHeight: 8,
                bubbleArrowWidth: 8,
                globalKey: arrow);
          }
        }, child: Obx(() {
          return flag == 1
              ? CustomMainTextField(
            // hintText: "PIX类型",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: controller.curSelectBank.value.isNotEmpty
                    ? AppThemes.textColorWhite
                    : AppThemes.walletHintColor),
            showError: controller.curSelectBankShowError.value,
            errorText: S.current.binding_pleaseSelectPIXAccountType,
            text: controller.curSelectAccount.value.isEmpty
                ? S.current.random_text_1171
                : "\t\t\t\t\t\t${controller.curSelectAccount.value}",
            enabled: false,
            key: globalKey,
          )
              : CustomMainTextField(
            text: controller.curSelectCountry.value,
            errorText: controller.showTextCountry.value,
            showError: controller.showErrorCountry.value,
            enabled: false,
            key: globalKey,
          );
        })),
        Obx(() {
          return Visibility(
            visible: controller.curSelectAccount.value.isEmpty || flag != 1 ? false : true,
            child: Positioned(
                left: 10,
                child: Container(
                  height: AppValues.defaultTextHeight,
                  margin: const EdgeInsets.only(right: 9),
                  child: const CustomAssetIcon(
                    name: "assets/images/personal_center_icon/pix_ic.webp",
                    size: 14,
                  ),
                )),
          );
        }),
        Positioned(
            right: 0,
            child: Container(
              height: AppValues.defaultTextHeight,
              margin: const EdgeInsets.only(right: 9),
              child: RotatingArrow(
                key: arrow,
              ),
            ))
      ],
    );
  }

  Widget _selectAccountType(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 260),
      child: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: controller.curSelectBankList.map((bank) {
              return _accountItem(bank);
            }).toList(),
          );
        }),
      ),
    );
  }

  Widget _accountItem(dynamic model) {
    return GestureDetector(
      onTap: () {
        for (int i = 0; i < controller.curSelectBankList.length; i++) {
          controller.curSelectBankList[i]['isSelect'] = false;
        }
        var isSelect = model['isSelect'] ?? false;
        model['isSelect'] = isSelect ? false : true;
        controller.curSelectBank.refresh();
        controller.bankId.value = model['id'] ?? "";
        controller.curSelectAccount.value = model['name'] ?? "";
        controller.curSelectBankShowError.value = false;
        RouteUtil.popView();
      },
      child: Container(
        color: model['isSelect'] == true ? AppThemes.textColorSecondary : Colors.transparent,
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SizedBox(
            //   width: bubbleWidth / 2 - 31,
            // ),
            const SizedBox(
              width: 10,
            ),
            const CustomAssetIcon(
              name: "assets/images/personal_center_icon/pix_ic.webp",
              size: 18,
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  model['name'] ?? "",
                  style:
                  ThemeService().theme.textTheme.bodyMedium?.copyWith(color: AppThemes.black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _selectCountry(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      child: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: controller.countryAndBandBard.map((bank) {
              return _countryItem(bank);
            }).toList(),
          );
        }),
      ),
    );
  }

  Widget _countryItem(dynamic model) {
    return GestureDetector(
      onTap: () {
        for (int i = 0; i < controller.countryAndBandBard.length; i++) {
          controller.countryAndBandBard[i]['isSelect'] = false;
        }
        var isSelect = model['isSelect'] ?? false;
        model['isSelect'] = isSelect ? false : true;
        controller.countryAndBandBard.refresh();
        controller.curSelectBankList.value = model['bank_list'];
        controller.setBankData();
        controller.curSelectCountry.value = model['country_name'] ?? "";
        controller.curSelectCountryId.value = model['country_id'] ?? "";

        controller.showErrorCountry.value =
            controller.assertField(controller.curSelectCountry.value);
        RouteUtil.popView();
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        color: model['isSelect'] == true ? AppThemes.textColorSecondary : Colors.transparent,
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: CustomText(
          model['country_name'] ?? "",
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(color: AppThemes.black),
        ),
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
                  text: controller.pwdTypeBean.isNotEmpty ? controller.pwdTypeBean['title'] : "");
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
                          decoration: controller.getBoxDecoration(
                              showErr: controller.inputPassWordShowError.value),
                          hintText: controller.pwdTypeBean.isNotEmpty
                              ? controller.pwdTypeBean['title']
                              : "",
                          isUpdatePsdOffset: true,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          showError: controller.inputPassWordShowError.value,
                          // errorText: controller.inputPassWordShowErrorText.value,
                          maxLength: 6,
                          isPwd: true,
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
        ));
  }

  Widget errorView() {
    return controller.errView(
        controller.inputPassWordShowError.value, controller.inputPassWordShowErrorText.value);
  }

  double _getInputWidth() {
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox =
    widget._globalKeyInput.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    return size.width;
  }
}

Future<void> showCustomBindingPixWidget<T>({
  required BuildContext context,
  required String bankTree,
  required String currencyId,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomBindingPixWidget,
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
            BindingPix(
              // key: _bankGlobalKey,
              // bankTree: bankTree,
              // currencyId: currencyId,
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
