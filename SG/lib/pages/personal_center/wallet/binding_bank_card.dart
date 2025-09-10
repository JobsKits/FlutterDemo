import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/pages/personal_center/wallet/widget/custom_password_tip.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../../app/modules/binding_bank_card/controllers/binding_bank_card_controller.dart';
import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_check_box.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_tips*_text.dart.dart';
import '../../../widget/dialog/custom_safe_dialog.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/input/custom_main_text_field.dart';
import 'auth_widget.dart';

const double bankRatio = 1; //银行系数
double bubbleWidth = 114;

const kCustomBindingBankCardWidget = 'CustomBindingBankWidget';

class BindingBankCard extends StatefulWidget {
  final String? currencyId;

  final String? bankTree;

  final String? flag; // 是否为提款页 1是  2否
  const BindingBankCard({super.key, this.currencyId, this.bankTree, this.flag = "1"});

  @override
  State<StatefulWidget> createState() {
    return _BindingBankCardState();
  }
}

class _BindingBankCardState extends State<BindingBankCard> with SingleTickerProviderStateMixin {
  final GlobalKey _globalKeyInput = GlobalKey();

  final GlobalKey _globalKeyCountry = GlobalKey();
  late BindingBankCardController controller = Get.find<BindingBankCardController>();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final GlobalKey<RotatingArrowState> _rotatingArrowCountry = GlobalKey<RotatingArrowState>();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<BindingBankCardController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BindingBankCardController());
    controller.context = context;
    if ((widget.bankTree ?? "").isNotEmpty) {
      controller.bankTree = widget.bankTree;
    }

    if ((widget.currencyId ?? "").isNotEmpty) {
      controller.currencyId = widget.currencyId;
    }

    controller.flag = widget.flag;
    controller.focusNodeBankNum.addListener(() {
      if (!controller.focusNodeBankNum.hasFocus) {
        controller.checkBankNumber(controller.bankNumberText.value);
      }
    });
    // controller.focusNodeBankName.addListener(() {
    //   if (!controller.focusNodeBankName.hasFocus) {
    //     controller.checkBankName(controller.openNameContr.value);
    //   }
    // });

    if (widget.flag == "1") {
      controller.openNameShowError.value = false;
      controller.showBankNameError.value = false;
      controller.bankNameErrorText.value = "";

      controller.curSelectBankShowError.value = false;
      controller.bankErrorText.value = "";

      controller.bankAccountShowError.value = false;
      controller.bankNumberErrorText.value = "";
    }

    log("neco 绑定页面。。。。 bankTree\t\t\t${widget.bankTree}  currencyId\t\t\t${widget.currencyId}");
    // controller.currencyTypeList();
    // controller.bankcardList();
    // controller.getCountryAndBandBard();
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),

        width: double.infinity,
        // margin: const EdgeInsets.symmetric(horizontal: 16),
        // decoration: BoxDecoration(
        //   borderRadius: const BorderRadius.all(Radius.circular(4)),
        //   color: ThemeService().colorScheme.background,
        // ),
        // decoration: BoxDecoration(
        //     border: Border.all(color: ThemeService().colorScheme.tertiary, width: 1),
        //     borderRadius: BorderRadius.all(
        //       Radius.circular(4),
        //     )),
        child: Container(
          // margin: const EdgeInsets.all(AppValues.defaultMargin),
          child: Column(
            children: [
              //提款方式暂时不需要
              // CustomAsterisksTipsText(
              //   text: S.current.withdraw_money_type,
              // ),
              // paymentType(),
              // CustomAsterisksTipsText(
              //   text: S.current.binding_bank_card_account_name,
              // ),
              //需求变更 又合并了
              // Obx(() {
              //   return _userName();
              // }),
              // SizedBox(height: 10,),
              //勿删
              tipsView(),
              const SizedBox(height: 4),
              Obx(() {
                ///用户名输入框
                return CustomMainTextField(
                  hintText: S.current.random_text_1122,
                  maxLength: 200,
                  showError:
                  controller.openNameShowError.value || controller.showBankNameError.value,
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
                );
              }),
              const SizedBox(height: AppValues.margin_12),

              /// 国家
              // Obx(() {
              //   return _nationalCity();
              // }),
              // const SizedBox(height: AppValues.margin_12),
              //需求变更 说去掉 暂时注释
              // const CustomAsterisksTipsText(
              //   text: "详细地址",
              // ),
              // const SizedBox(
              //   height: 4,
              // ),
              // Obx(() {
              //   return CustomMainTextField(
              //     showError: controller.showErrorAddress.value,
              //     errorText: controller.showTextAddress.value,
              //     text: controller.inputAddress.value,
              //     inputCallBack: (str) {
              //       controller.checkAddress(str);
              //       controller.inputAddress.value = str;
              //     },
              //   );
              // }),
              // const SizedBox(
              //   height: AppValues.margin_12,
              // ),
              CustomAsterisksTipsText(
                // text: S.current.binding_bank_card_select_bank,
                text: S.current.wallet_bankSelection,
              ),
              const SizedBox(
                height: 4,
              ),
              SizedBox(
                  width: double.infinity,
                  child: _selectBank(context, _rotatingArrowKey, _globalKeyInput, 1)),
              const SizedBox(height: AppValues.margin_12),

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
              const SizedBox(height: 4),
              Obx(() {
                ///银行卡输入框
                return CustomMainTextField(
                  hintText: S.current.binding_bank_card_number,
                  showError:
                  controller.bankAccountShowError.value || controller.showBankNumberError.value,
                  text: controller.bankAccountContr.value,
                  inputCallBack: (str) {
                    controller.bankAccountContr.value = str;
                    controller.bankNumberText.value = str;
                    controller.bankAccountShowError.value = controller.assertField(str);
                  },
                  // hintText: S.current.binding_bank_card_please_enter,
                  errorText: controller.bankNumberErrorText.value,
                  focusNode: controller.focusNodeBankNum,
                );
              }),
              const SizedBox(height: AppValues.margin_12),

              //删除开户地址
              // const SizedBox(
              //   height: AppValues.margin_12,
              // ),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: CustomText(
              //     S.current.binding_bank_card_account_opening_branch,
              //     textColorStyle: CustomTextColorStyle.normal,
              //   ),
              // ),
              // const SizedBox(
              //   height: 4,
              // ),
              // Obx(() {
              //   return CustomMainTextField(
              //     text: controller.bankAreaCpfContr.value,
              //     inputCallBack: (str) {
              //       controller.bankAreaCpfContr.value = str;
              //     },
              //     // hintText: S.current.binding_bank_card_please_enter,
              //   );
              // }),

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
                      Expanded(child: CustomText(S.current.binding_setAsDefaultCardNumber)),
                    ],
                  ),
                );
              }),
              const SizedBox(
                height: AppValues.margin_12,
              ),
              CustomText(
                S.current.random_text_704,
                textColorStyle: CustomTextColorStyle.normal,
              ),

              const SizedBox(
                height: AppValues.margin_12,
              ),
              CustomBigMainButton(
                fontWeight: FontWeight.w600,
                colorStyle: CustomButtonColorStyle.tertiary,
                onTap: (customButtonController) {
                  controller.checkBankName(controller.openNameContr.value);
                  controller.checkBankNumber(controller.bankNumberText.value);
                  // controller.checkCountry(controller.curSelectCountry.value);
                  // controller.checkCity(controller.inputCity.value);
                  // controller.checkName(controller.inputName.value);
                  // controller.checkSurname(controller.inputSurname.value);
                  // controller.checkAddress(controller.inputAddress.value);
                  controller.checkInputPassWord();
                  // controller.checkSelectBank(controller.curSelectBank.value);
                  if (controller.validate() != true ||
                      controller.showBankNumberError.value ||
                      controller.showBankNameError.value) {
                    return;
                  }
                  //需求变更 暂时注释
                  // if (controller.getIsSetupPassword() == false) {
                  //   showCustomPromptToPwWidget(context: context);
                  //   return;
                  // }
                  // showCustomPassWorldWidget(context: context, isBindBank: 1);

                  controller.onBankCardInset(context, customButtonController,
                      currencyId: controller.currencyId,
                      bankAccount: controller.bankAccountContr.value,
                      bankAreaCpf: controller.bankAreaCpfContr.value,
                      bankName: controller.curSelectBank.value.isEmpty
                          ? controller.curSelectAccount.value
                          : controller.curSelectBank.value,
                      openName: controller.openNameContr.value);
                },
                title: widget.flag == "1" ? S.current.submit_text : S.current.random_text_1288,
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
                  SizedBox(
                    height: 4,
                  ),
                  CustomMainTextField(
                    textColor: controller.openNameContr.value.isEmpty
                        ? AppThemes.textColorWhite
                        : AppThemes.hintTextColorWhite,
                    enabled: controller.openNameContr.value.isEmpty ? true : false,
                    showError: controller.showErrorName.value,
                    errorText: controller.showTextName.value,
                    text: controller.inputName.value,
                    inputCallBack: (str) {
                      controller.checkName(str);
                      controller.inputName.value = str;
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: SizedBox(
              child: Column(
                children: [
                  CustomAsterisksTipsText(text: S.current.kyc_family_name_text),
                  SizedBox(
                    height: 4,
                  ),
                  CustomMainTextField(
                    textColor: controller.openNameContr.value.isEmpty
                        ? AppThemes.textColorWhite
                        : AppThemes.hintTextColorWhite,
                    enabled: controller.openNameContr.value.isEmpty ? true : false,
                    showError: controller.showErrorSurname.value,
                    errorText: controller.showTextSurname.value,
                    text: controller.inputSurname.value,
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

  Widget tipsView() {
    return Row(
      children: [
        CustomAsterisksTipsText(
          // text: S.current.random_text_830,
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
          child: Container(
            margin: const EdgeInsets.all(AppValues.defaultMargin),
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
        ),
      ],
    );
  }

  Widget _selectBank(BuildContext context, GlobalKey<RotatingArrowState> arrow, GlobalKey globalKey,
      int flag,
      {double width = 160}) {
    return Stack(
      children: [
        GestureDetector(onTap: () {
          if (flag == 3) return;
          if (controller.withDrawCtrl.previousBottomInset > 0) {
            FocusScope.of(Get.context!).requestFocus(FocusNode());
          } else {
            _startAnimation(arrow);
            DialogUtils.showCustomBubbleDialog(
                context,
                flag == 1 ? _selectBankType(context) : _selectCountry(context),
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
            textColor: controller.curSelectBank.value.isNotEmpty
                ? AppThemes.textColorWhite
                : AppThemes.hintTextColorWhite,
            errorText: controller.bankErrorText.value,
            showError: controller.curSelectBankShowError.value,
            text:
            "${controller.curSelectBank.value.isEmpty
                ? S.current.wallet_bankSelection
                : "\t\t\t\t\t\t${controller.curSelectBank.value}"}",
            enabled: false,
            key: _globalKeyInput,
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
            visible: controller.curSelectBank.value.isEmpty ? false : true,
            child: Positioned(
                left: 10,
                child: Container(
                  height: AppValues.defaultTextHeight,
                  margin: const EdgeInsets.only(right: 9),
                  child: Visibility(
                    visible: flag == 2 ? false : true,
                    child: CustomNetWorkImage(
                      fit: BoxFit.fitWidth,
                      placeholder: const CustomAssetIcon(
                        name: 'assets/images/personal_center_icon/pay_default_ic.webp',
                      ),
                      errorWidget: const CustomAssetIcon(
                        name: 'assets/images/personal_center_icon/bank.webp',
                      ),
                      width: 14,
                      height: 14,
                      imageUrl:
                      "${AppValues.defaultBranch.asset_url}/webp/bank/${controller.bankId
                          .value}.webp",
                    ),
                  ),
                )),
          );
        }),
        Visibility(
          visible: flag == 1 || flag == 2,
          child: Positioned(
              right: 0,
              child: Container(
                height: AppValues.defaultTextHeight,
                margin: const EdgeInsets.only(right: 9),
                child: RotatingArrow(
                  key: arrow,
                ),
              )),
        )
      ],
    );
  }

  Widget _selectBankType(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      child: Scrollbar(
        controller: controller.scrollController, // Provide a ScrollController
        radius: const Radius.circular(10),
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: controller.scrollController, // Use the same ScrollController
          child: Obx(() {
            return Column(
              children: controller.curSelectBankList.map((bank) {
                return _bankItem(bank);
              }).toList(),
            );
          }),
        ),
      ),
    );
  }

  Widget _bankItem(dynamic model) {
    return GestureDetector(
      onTap: () {
        for (int i = 0; i < controller.curSelectBankList.length; i++) {
          controller.curSelectBankList[i]['isSelect'] = false;
        }
        var isSelect = model['isSelect'] ?? false;
        model['isSelect'] = isSelect ? false : true;
        controller.curSelectBankList.refresh();
        controller.curSelectBank.value = model['name'] ?? "";
        controller.bankId.value = model['id'] ?? "";
        controller.curSelectBankShowError.value =
            controller.assertField(controller.curSelectBank.value);

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
            // const CustomAssetIcon(
            //   // color: Colors.black,
            //   name: "assets/images/personal_center_icon/bank.webp",
            //   size: 18,
            // ),
            CustomNetWorkImage(
              fit: BoxFit.fitWidth,
              placeholder: const CustomAssetIcon(
                name: 'assets/images/personal_center_icon/pay_default_ic.webp',
              ),
              errorWidget: const CustomAssetIcon(
                name: 'assets/images/personal_center_icon/bank.webp',
              ),
              width: 24,
              height: 24,
              imageUrl: "${controller.globalController.bnkDomain}${model['id']}.webp",
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
      child: Scrollbar(
        controller: controller.scrollController, // Provide a ScrollController
        radius: const Radius.circular(10),
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: controller.scrollController, // Use the same ScrollController
          child: Obx(() {
            log("neco 银行列表 ${controller.countryAndBandBard.length}");
            return Column(
              children: controller.countryAndBandBard.map((bank) {
                return _countryItem(bank);
              }).toList(),
            );
          }),
        ),
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
                SizedBox(
                  height: 4,
                ),
                _selectBank(context, _rotatingArrowCountry, _globalKeyCountry, 2)
              ],
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              children: [
                CustomAsterisksTipsText(
                  text: S.current.kyc_city_text,
                ),
                SizedBox(
                  height: 4,
                ),
                CustomMainTextField(
                  showError: controller.showErrorCity.value,
                  errorText: controller.showTextCity.value,
                  text: controller.inputCity.value,
                  inputCallBack: (str) {
                    controller.inputCity.value = str;
                    controller.checkCity(str);
                  },
                )
              ],
            ),
          ),
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
    final RenderBox renderBox = _globalKeyInput.currentContext?.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    return size.width;
  }
}

Future<void> showCustomBindingBankWidget<T>({
  required BuildContext context,
  required String currencyId,
  required String bankTree,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomBindingBankCardWidget,
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
            BindingBankCard(
              // key: _bankGlobalKey,
              // currencyId: currencyId,
              // bankTree: bankTree,
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
