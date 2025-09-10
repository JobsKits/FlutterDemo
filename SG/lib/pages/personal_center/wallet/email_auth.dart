import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_tips*_text.dart.dart';
import 'package:get/get.dart';

import '../../../app/modules/vaultDescriptions/views/vault_descriptions_view.dart';
import '../../../constant/app_themes.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/common_util.dart';
import '../../../utils/formatter/custom_number_formatter.dart';
import '../../../utils/keyboard_util.dart';
import '../../../utils/route_util.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/input/custom_main_text_field.dart';
import '../../account/ThirdPartyAuthorizationToController.dart';
import '../../account/bind_controller.dart';
import '../../setup/contact/logic.dart';

class EmailAuth extends GetView<FiatPaymentDetailsToController> {
  final tips;
  final bool isVault;
  final SetupContactController setupContactController = Get.put(SetupContactController());
  final bindController = Get.put(BindController());
  EmailAuth({super.key, this.tips, this.isVault = false});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<FiatPaymentDetailsToController>(
      () => FiatPaymentDetailsToController(),
    );
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppValues.defaultMargin),
          decoration: BoxDecoration(
              border: Border.all(color: ThemeService().colorScheme.tertiary, width: 1),
              borderRadius: const BorderRadius.all(
                Radius.circular(4),
              )),
          margin: const EdgeInsets.only(
              left: AppValues.margin_12, right: AppValues.margin_12, bottom: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => CustomText(
                          bindController.showPhone.value
                              ? S.current.random_text_1047
                              : S.current.random_text_1033,
                          style: ThemeService().textTheme.titleLarge,
                          textColorStyle: CustomTextColorStyle.white,
                        )),
                    const SizedBox(
                      height: AppValues.defaultMargin,
                    ),
                    Obx(() => CustomText(
                        bindController.showPhone.value ? S.current.random_text_1161 : "$tips",
                        style: ThemeService()
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: ThemeService().colorScheme.onTertiary))),
                    const SizedBox(
                      height: AppValues.defaultMargin,
                    ),
                    Container(
                      height: 1,
                      color: ThemeService().colorScheme.tertiary,
                    ),
                    const SizedBox(
                      height: AppValues.defaultMargin,
                    ),
                    Obx(() => CustomAsterisksTipsText(
                        text: bindController.showPhone.value
                            ? S.current.phone_number_text
                            : S.current.random_text_1079)),
                    const SizedBox(
                      height: 2,
                    ),
                    Stack(
                      children: [
                        Obx(() {
                          return bindController.showPhone.value
                              ? PhoneWidget()
                              : CustomMainTextField(
                                  text: setupContactController.emailText.value,
                                  hintText: S.current.random_text_1079,
                                  errorText: setupContactController.emailErrorText.value,
                                  isChecked: !setupContactController.canEditorEmail.value,
                                  showError: setupContactController.isEmailTextError.value,
                                  inputCallBack: (value) =>
                                      setupContactController.onInputEmail(value),
                                );
                        }),
                      ],
                    ),
                    const SizedBox(
                      height: AppValues.defaultMargin,
                    ),
                    Obx(() => Visibility(
                      visible: bindController.showTitle.value,
                      child: Row(
                        children: [
                          Expanded(
                            child: Obx(() => Text.rich(TextSpan(
                              children: [
                                TextSpan(
                                  text: bindController.showPhone.value
                                      ? S.current.random_text_1035
                                      : S.current.random_text_1117,
                                  style: const TextStyle(
                                      color: AppThemes.textColorSecondary,
                                      fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: bindController.showPhone.value
                                          ? S.current.random_text_1118
                                          : S.current.random_text_1119,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()..onTap =() => bindController.showPhone(!bindController.showPhone.value),
                                ),
                              ]
                            ))),
                          ),
                        ],
                      ),
                    )),
                    Obx(() => SizedBox(
                      height: bindController.showTitle.value ? AppValues.defaultMargin : 0,
                    )),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: ThemeService().colorScheme.tertiary,
              ),
              const SizedBox(
                height: AppValues.defaultMargin,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
                child: Row(
                  children: [
                    // Obx(() {
                    //   return Visibility(
                    //     visible: setupContactController.isGmail.value &&
                    //         !setupContactController.canSaveEmail.value,
                    //     child: GestureDetector(
                    //       onTap: () {
                    //         setupContactController.goToGoogleEmail();
                    //       },
                    //       child: Container(
                    //         alignment: Alignment.center,
                    //         height: 40,
                    //         padding: const EdgeInsets.only(left: 6,right: 6),
                    //         decoration: BoxDecoration(
                    //             color: ThemeService().colorScheme.primary,
                    //             borderRadius: const BorderRadius.only(
                    //                 topLeft: Radius.circular(4),
                    //                 bottomLeft: Radius.circular(4),
                    //                 topRight: Radius.circular(4),
                    //                 bottomRight: Radius.circular(4))),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             CustomText(S.current.wallet_email_open,
                    //                 style: ThemeService()
                    //                     .theme
                    //                     .textTheme
                    //                     .bodyMedium
                    //                     ?.copyWith(fontWeight: FontWeight.w600)),
                    //             const CustomAssetIcon(
                    //               name: "assets/images/personal_center_icon/gmail_ic.webp",
                    //               size: 14,
                    //               color: AppThemes.widgetColorWhite,
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   );
                    // }),
                    const Spacer(),
                    Obx(() => Visibility(
                      visible: !bindController.showPhone.value && setupContactController.isShowTime.value,
                      child: CustomText('${setupContactController.seconds.value}s',style: const TextStyle(color: AppThemes.onSurfaceColor)),
                    )),
                    Obx(() => CustomBigMainButton(
                          onTap: (btn) {
                            if (bindController.showPhone.value) {
                              controller.resend();
                              return;
                            }
                            setupContactController
                                .globalController.isOpenVerificationAndPayPassword.value = false;
                            setupContactController.onEmailCheck(context, btn);
                            setupContactController.hideKeyboard(context);
                          },
                          maxWidth: !bindController.showPhone.value ? 84 : getWidth(),
                          title:  (!bindController.showPhone.value || controller.showResend.value) ? S.current.random_text_1050 : S.current.random_text_1199,
                          colorStyle: CustomButtonColorStyle.transparent,
                          textColor: controller.showTime.value || setupContactController.isShowTime.value
                              ? AppThemes.onSurfaceColor
                              : AppThemes.textColorWhite,
                        )),
                    Obx(() {
                      //CustomBigMainButton
                      return CustomBigMainButton(
                        maxWidth: 84,
                        isEnable: setupContactController.canSaveEmail.value || (bindController.showPhone.value && controller.phoneEnable.value),
                        colorStyle: CustomButtonColorStyle.tertiary,
                        title: S.current.button_save_text,
                        onTap: (btr) {
                          if (bindController.showPhone.value) {
                            controller.onUpdatePhone(context, btr);
                            return;
                          }
                          setupContactController.onUpdateEmail(context, btr);
                          setupContactController.hideKeyboard(context);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),

        ///https://jira.vgtech.org/browse/STAK-11230
        // Container(
        //   width: double.infinity,
        //   padding: const EdgeInsets.symmetric(vertical: AppValues.defaultMargin),
        //   color: ThemeService().colorScheme.surface,
        //   child: Column(
        //     children: [
        //       Container(
        //         margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
        //         child: CustomText(S.current.vault_increase_your_account_security_with_double_verification,
        //             style: ThemeService().theme.textTheme.titleSmall?.copyWith(
        //                 fontWeight: FontWeight.w400, color: ThemeService().colorScheme.onSurface)),
        //       ),
        //       const SizedBox(
        //         height: AppValues.halfMargin,
        //       ),
        //       CustomSmallMainButton(
        //         // contentPaddingTopAndBottom: 11.0,
        //         padding: const EdgeInsets.symmetric(vertical: 11.0),
        //         onTap: () {
        //           RouteUtil.pushToView(Routes.setupPage, offLast: true, arguments: {'pageIndex': 2});
        //           final setupLogic = Get.put(SetupLogic());
        //           setupLogic.changedView(2);
        //         },
        //         title: "\t\t\t${S.current.vault_turn_on_two_step_verification}\t\t\t",
        //         backgroundColor: ThemeService().colorScheme.primary,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ],
        //   ),
        // ),
        if (isVault)
          Container(
            color: ThemeService().colorScheme.surface,
            child: CupertinoButton(
              onPressed: () {
                VaultDescriptionsView.openPage();
              },
              child: Center(
                  child: CustomText(
                S.current.random_text_598,
                textColorStyle: CustomTextColorStyle.normal,
              ))),
          )
      ],
    );
  }

  double getWidth() {
    switch (bindController.globalController.langType.value) {
      case 1:
        return 84;
      case 2:
        return 160;
      case 3:
        return 130;
      case 4:
        return 130;
      case 5:
        return 100;
      case 6:
        return 110;
      default:
    }
    return 84;
  }
}

class PhoneWidget extends GetView<FiatPaymentDetailsToController> {
  PhoneWidget({Key? key}) : super(key: key);

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final _monthGlobalKey = GlobalKey();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Column(
      children: [
        Stack(
          children: [
            Obx(() => CustomMainTextField(
                  text: controller.phoneText,
                  keyboardType: TextInputType.number,
                  inputFormatters: [CustomNumberFormatter()],
                  required: true,
                  // title: S.current.login_text_field_account_tips,
                  hintText: S.current.phone_number_text,
                  hintColor: AppThemes.hintTextColor,
                  contentPadding: const EdgeInsets.only(left: 92),
                  showError: controller.isPhoneError.value,
                  errorText: controller.phoneErrorText.value,
                  inputCallBack: (value) =>
                      {controller.phoneText = value, controller.onPhoneCheck(value, false)},
                  inputCompletionCallBack: (String value, bool isSubmitted) =>
                      controller.onPhoneCheck(value, true),
                )),
            GestureDetector(
              onTap: () async {
                controller.showArray.value = controller.areaCodeArray;
                _startAnimation(_rotatingArrowKey);

                ///有弹出键盘，先关闭键盘
                if (controller.isKeyboardVisible) {
                  KeyboardUtils.hideKeyboard(Get.context!);
                  await Future.delayed(const Duration(milliseconds: 300));
                }
                Future.delayed(const Duration(milliseconds: 100), () {
                  DialogUtils.showCustomBubbleDialog(
                      Get.context!,
                      _buildAreaList(Get.context!),
                      // bubbleWith,
                      120,
                      // arrowBasisOffset: -70,
                      bubbleLeftOffset: AppValues.defaultMargin,
                      widgetKey: _monthGlobalKey,
                      // backgroundColor: ThemeService().colorScheme.tertiary,
                      globalKey: _rotatingArrowKey
                      // globalKey: widget._rotatingArrowKey,
                      );
                  Future.delayed(const Duration(milliseconds: 20), () {
                    controller.scrollController.jumpTo((controller.areaCodeSelectIndex - 3) * 38);
                  });
                });
              },
              child: Obx(() => Container(
                    width: 80,
                    height: 40,
                    key: _monthGlobalKey,
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                width: 2,
                                color: controller.isPhoneError.value
                                    ? ThemeService().colorScheme.error
                                    : ThemeService().colorScheme.tertiary))),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        Obx(() => CustomText(
                              controller.areaCode.value,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            )),
                        const SizedBox(
                          width: 16,
                        ),
                        RotatingArrow(
                          key: _rotatingArrowKey,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
        const SizedBox(
          height: AppValues.defaultMargin,
        ),
        CustomAsterisksTipsText(text: S.current.random_text_1162),
        const SizedBox(
          height: 2,
        ),
        Stack(
          children: [
            Obx(() => CustomMainTextField(
                  required: true,
                  contentPadding: const EdgeInsets.only(left: AppValues.defaultPadding, right: 52),
                  text: controller.codeText,
                  showError: controller.isCodeError.value,
                  errorText: controller.codeErrorText.value,
                  inputCallBack: (value) => controller.onInputCode(value),
                )),
            Positioned(
                top: AppValues.padding_10,
                right: AppValues.defaultMargin,
                child: Obx(() => GestureDetector(
                    onTap: controller.resend,
                    child: CustomText(
                      controller.showTime.value ? '${controller.seconds.value}s' : '',
                      style: const TextStyle(color:AppThemes.onSurfaceColor,fontWeight: FontWeight.w500),
                    ))))
          ],
        ),
      ],
    );
  }

  Widget _buildAreaList(BuildContext context) {
    return Scrollbar(
      radius: const Radius.circular(10),
      child: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(height: AppValues.margin_10),
          // CustomText(
          //   S.current.random_text_1164,
          //   style: TextStyle(color: Color(0xffa7a7a7)),
          // ),
          Container(
              constraints: const BoxConstraints(
                maxHeight: 250,
              ),
              child: Obx(() => ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.only(bottom: 6),
                  itemCount: controller.showArray.length,
                  itemBuilder: (context, index) {
                    final code = controller.showArray[index];
                    return GestureDetector(
                      onTap: () {
                        RouteUtil.popView();
                        // for (var item in controller.list) {
                        //   item['isSelected'] = false;
                        // }
                        // month['isSelected'] = month['isSelected'] == true ? false : true;
                        // controller.list.refresh();
                        // controller.onInputMonth(month['num'] as String);
                        controller.areaCode.value = code.attr!;
                        controller.areaCodeSelectIndex = index;
                      },
                      child: Container(
                          margin: const EdgeInsets.only(top: 6, left: 6, right: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            // color: month['isSelected'] == true
                            //     ? ThemeService().colorScheme.secondary
                            //     : null,
                          ),
                          alignment: Alignment.centerLeft,
                          height: 34,
                          width: double.infinity,
                          child: Row(
                            children: [
                              Obx(() => CustomIcon(
                                    asset: 'assets/images/login/gou.png',
                                    color: controller.areaCode.value == code.attr!
                                        ? AppThemes.black
                                        : Colors.transparent,
                                    size: 16,
                                  )),
                              CustomText(
                                code.attr!,
                                style: const TextStyle(color: AppThemes.black),
                              ),
                            ],
                          )),
                    );
                  }))),
        ],
      )),
    );
  }

  _buildSearchView() {
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: AppValues.margin_10),
      child: CupertinoSearchTextField(
        prefixInsets: const EdgeInsets.only(left: 10),
        prefixIcon: const CustomAssetIcon(
          name: "assets/images/top_search_ic.png",
          size: 16,
        ),
        itemColor: AppThemes.secondaryIconColor,
        placeholder: S.current.wallet_search,
        // placeholderStyle: const TextStyle(color: AppThemes.white566771, fontWeight: FontWeight.w500),
        placeholderStyle:
            const TextStyle(color: AppThemes.tertiaryColor, fontWeight: FontWeight.w500),
        decoration: BoxDecoration(
          color: AppThemes.widgetColorWhite,
          border: Border.all(color: AppThemes.whiteD5DCEB, width: 2.0),
          // Add a border
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // 阴影颜色
              spreadRadius: 0, // 扩散半径
              blurRadius: 2, // 模糊半径
              offset: const Offset(0, 1), // 阴影偏移量
            ),
          ],
        ),
        style: const TextStyle(
            fontSize: 14, color: AppThemes.tertiaryColor, fontWeight: FontWeight.w500),
        onChanged: (String value) {
          // log('The text has changed to: $value');
          // globalController.updateSearchList(value);
          if (value.isEmpty) {
            controller.showArray.value = controller.areaCodeArray;
          } else if (CommonUtil.isNumber(value)) {
            controller.showArray.value =
                controller.areaCodeArray.where((element) => element.attr!.contains(value)).toList();
          } else {
            controller.showArray.value =
                controller.areaCodeArray.where((element) => element.name!.contains(value)).toList();
          }
        },
        onSubmitted: (String value) {
          // log('Submitted text: $value');
        },
      ),
    );
  }
}
