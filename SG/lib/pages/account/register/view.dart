import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/account/login/login_widget.dart';
import 'package:flutter_bet/pages/account/register_protocol/view.dart';
import 'package:flutter_bet/pages/account/widgets/account_policy_widget.dart';
import 'package:flutter_bet/pages/account/widgets/password_tips_widget.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/formatter/custom_length_formatter.dart';
import 'package:flutter_bet/utils/formatter/custom_number_formatter.dart';
import 'package:flutter_bet/utils/keyboard_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_button_style.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_check_box.dart';
import 'package:flutter_bet/widget/custom_error_tips_text.dart.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_tips*_text.dart.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import '../../../base/getx/base_view.dart';
import '../../../constant/app_themes.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../widgets/third_party_authorization_widget.dart';
import 'logic.dart';
import '../../../routes/routes.dart';
import 'register_widget.dart';
import 'widgets/widget.dart';

final _monthGlobalKey = GlobalKey();

class RegisterPage extends BaseView<RegisterLogic> {

  final controller = Get.find<RegisterLogic>();

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final GlobalKey<RotatingArrowState> _codeArrowKey = GlobalKey<RotatingArrowState>();

  //打开页面
  static void openPage() {
    ///注册弹窗
    RouteUtil.pushToView(Routes.registerPage);
  }

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  void _resetAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.resetAnimation();
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return CustomAppBar(
      // appBarTitleText: S.current.top_register,
      appBarTitleText: S.current.create_account_title_text,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    controller.context = context;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: ThemeService().theme.scaffoldBackgroundColor,
        ),
        child: _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      margin:
      const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      child: Column(
        children: [
          const SizedBox(height: AppValues.extraLargePadding,),
          Obx(() => controller.showTitle.value ? const SwitchWidget() : Container()),
          // CustomText(
          //   // "${S.current.random_text_8}${S.current.create_account_title}",
          //   "${S.current.create_account_title}",
          //   textColorStyle: CustomTextColorStyle.normal,
          //   style: ThemeService()
          //       .textTheme
          //       .titleSmall
          //       ?.copyWith(fontWeight: FontWeight.w500),
          // ),
          const SizedBox(height: AppValues.defaultPadding,),
          Obx(() {
            return Column(
              children: [
                Obx(() => controller.isPhone.value ? PhoneWidget() 
                : CustomMainTextField(
                    // title: S.current.email_address_text,
                    hintText: S.current.random_text_1022,
                    hintColor: AppThemes.hintTextColor,
                    required: true,
                    text: controller.emailText,
                    showError: controller.isEmailError.value,
                    errorText: controller.emailErrorText.value,
                    keyboardType: TextInputType.emailAddress,
                    inputCompletionCallBack:
                        (String value, bool isSubmitted) =>
                        controller.onEmailCheck(context, value),
                    inputCallBack: (value) =>
                        controller.onInputEmail(value))),
                const SizedBox(
                  height: AppValues.defaultPadding,
                ),
                Obx(() {
                  return CustomMainTextField(
                      // title: S.current.text_field_user_name_tips,
                      text: controller.userNameText,
                      hintText: S.current.random_text_1023,
                      hintColor: AppThemes.hintTextColor,
                      required: true,
                      showError: controller.isUserNameError.value,
                      errorText: controller.userNameErrorText.value,
                      inputCompletionCallBack:
                          (String value, bool isSubmitted) =>
                          controller.onUserNameCheck(context, value),
                      inputCallBack: (value) =>
                          controller.onInputUerName(value));
                }),
                // Obx(() {
                //   return Visibility(
                //     visible: controller.isUserNameError.value== true? false :true,
                //     child: Container(margin: const EdgeInsets.only(top: 4),
                //         alignment: Alignment.centerLeft,
                //         child: CustomText(S.current.random_text_512,
                //           textColorStyle: CustomTextColorStyle.normal, style: const TextStyle(
                //               fontSize: 12),)),
                //   );
                // }),
                const SizedBox(
                  height: AppValues.defaultPadding,
                ),
                CustomMainTextField(
                  // title: S.current.login_text_field_password_tips,
                  text: controller.passwordText,
                  hintText: S.current.random_text_670,
                  hintColor: AppThemes.hintTextColor,
                  required: true,
                  showError: controller.isPasswordError.value,
                  errorText: controller.passwordErrorText.value,
                  isPwd: true,
                  inputCallBack: (value) =>
                      controller.oninputCompletionPassword(value),
                  // getFocusNodeCallBack: () => controller.clickPasswordField(),
                  inputCompletionCallBack: (value, isSubmit) =>
                      controller.oninputCompletionPassword(value),
                ),
                Obx(() => Visibility(
                  visible: controller.isEditPassword.value,
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppValues.defaultPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child:Container(
                            height: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              color: controller.passwordCount.value == 3 ? ThemeService().colorScheme.primaryContainer : controller.passwordCount.value == 2 ? Colors.amber : ThemeService().colorScheme.error,
                            ),
                          )
                        ),
                        const SizedBox(width: 5,),
                        Expanded(
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              color: controller.passwordCount.value == 3 ? ThemeService().colorScheme.primaryContainer : controller.passwordCount.value == 2 ? Colors.amber : ThemeService().colorScheme.tertiary,
                            ),
                          )
                        ),
                        const SizedBox(width: 5,),
                        Expanded(
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              color: controller.passwordCount.value == 3 ? ThemeService().colorScheme.primaryContainer : ThemeService().colorScheme.tertiary,
                            ),
                          )
                        ),
                        const SizedBox(width: 10,),
                        Obx(() => CustomText(
                          controller.passwordCount.value == 3 ? S.current.random_text_1112 : controller.passwordCount.value == 2 ? S.current.random_text_1113 : S.current.random_text_1114,
                          style: TextStyle(color: controller.passwordCount.value == 3 ? ThemeService().colorScheme.primaryContainer 
                            : controller.passwordCount.value == 2 ? Colors.amber : ThemeService().colorScheme.error,
                            fontSize: 12,fontWeight: FontWeight.w500),
                        ))
                      ],
                    ),
                  )
                )),

                // Obx(() {
                //   return Visibility(
                //     visible: controller.isEditPassword.value,
                //     child: Padding(
                //       padding: const EdgeInsets.only(
                //         top: AppValues.smallPadding,
                //       ),
                //       child: Column(
                //         children: [
                //           PassWordTipsWidget(
                //             text: S.current.contains_alphabet_text,
                //             isActive: controller.isContainsAlphabet.value,
                //           ),
                //           const SizedBox(
                //             height: AppValues.smallPadding,
                //           ),
                //           PassWordTipsWidget(
                //             text: S.current.contains_one_more_number_text,
                //             isActive: controller.isContainsNumber.value,
                //           ),
                //           const SizedBox(
                //             height: AppValues.smallPadding,
                //           ),
                //           PassWordTipsWidget(
                //             text: S.current.least_character_text(8),
                //             isActive: controller.isEightPassword.value,
                //           ),
                //         ],
                //       ),
                //     ),
                //   );
                // }),
                const SizedBox(
                  height: AppValues.defaultPadding,
                ),
                Obx(() => Visibility(
                  visible: controller.showBirthday.value,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppValues.defaultPadding),
                    child: _buildBirthday(context),
                  )
                )),
                // _buildBirthday(context),
                // const SizedBox(
                //   height: AppValues.defaultPadding,
                // ),
                _buildInputCode(),
                const SizedBox(
                  height: AppValues.defaultPadding,
                ),

                // Obx(() {
                //   return CustomBigMainButton(
                //     title: S.current.top_register,
                //     isEnable: controller.isButtonEnable.value,
                //     colorStyle: CustomButtonColorStyle.tertiary,
                //     onTap: (buttonCtr) =>
                //         controller.onContinueButton(context, buttonCtr),
                //   );
                // }),
                CustomBigMainButton(
                  // title: S.current.reg_next,
                  title: S.current.top_register,
                  colorStyle: CustomButtonColorStyle.tertiary,
                  onTap: (buttonCtr) =>
                      controller.onContinueButton(context, buttonCtr),
                  // showCustomRegisterProtocolWidget(context: context)
                ),
                // _buildProtocol( context),
                const SizedBox(
                  height: AppValues.defaultPadding,
                ),
                Row(
                  children: [
                    CustomText(S.current.already_have_an_account_text, style: TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w500),),
                    GestureDetector(
                      onTap: () {
                        // RouteUtil.pushToView(Routes.loginPage, offLast: true);
                        showCustomLoginWidget();
                      },
                      child: CustomText(S.current.top_login, style: TextStyle(fontWeight: FontWeight.w600),),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppValues.defaultPadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: ThemeService().theme.colorScheme.tertiary,
                      width: 64,
                      height: 2,
                    ),
                    const SizedBox(
                      width: AppValues.defaultPadding,
                    ),
                    CustomText(
                      S.current.random_text_1021,
                      textColorStyle: CustomTextColorStyle.normal,
                    ),
                    const SizedBox(
                      width: AppValues.defaultPadding,
                    ),
                    Container(
                      color: ThemeService().theme.colorScheme.tertiary,
                      width: 64,
                      height: 2,
                    ),
                  ],
                )
              ],
            );
          }),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          const ThirdPartyAuthorizationWidget(),
          // const SizedBox(
          //   height: AppValues.defaultPadding,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     CustomText(
          //       S.current.already_have_an_account_text,
          //       textColorStyle: CustomTextColorStyle.normal,
          //     ),
          //     GestureDetector(
          //       onTap: () {
          //         // CustomSafeDialog.dismiss(
          //         //     context: context, tag: kCustomRegisterWidget);
          //         // showCustomLoginWidget(context: context);
          //         RouteUtil.pushToView(Routes.loginPage, offLast: true);
          //       },
          //       child: CustomText(
          //         S.current.top_login,
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(
          //   height: AppValues.defaultPadding,
          // ),
          // const AccountPolicyWidget(),
          // const SizedBox(
          //   height: AppValues.largePadding,
          // ),
        ],
      ),
    );
  }

  Widget _buildInputCode() {
    return Column(
      children: [
        Row(
          children: [
            // GestureDetector(onTap: () {
            //   controller.isCheckCode.value = !controller.isCheckCode.value;
            // }, child: Obx(() {
            //   return CustomCheckBox(
            //     value: controller.isCheckCode.value,
            //   );
            // })),
            // const SizedBox(
            //   width: 8,
            // ),
            GestureDetector(
              onTap: () {
                controller.isCheckCode.value = !controller.isCheckCode.value;
                if (controller.isCheckCode.value) {
                  _startAnimation(_codeArrowKey);
                } else {
                  _resetAnimation(_codeArrowKey);
                }
              },
              child: CustomText(
                S.current.random_text_1024,
                textColorStyle: CustomTextColorStyle.normal,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            RotatingArrow(key: _codeArrowKey,),
          ],
        ),
        Obx(() {
          return Visibility(
            visible: controller.isCheckCode.value,
            child: Padding(
              padding: const EdgeInsets.only(top: AppValues.smallPadding),
              child: CustomMainTextField(
                text: controller.codeText,
                hintText: S.current.redeem_code_text,
                inputCallBack: (value) {
                  controller.codeText = value;
                },
              ),
            ),
          );
        }),
        const SizedBox(height: AppValues.defaultPadding,),
        Row(
          children: [
            GestureDetector(onTap: () {
              controller.agreeUser.value = !controller.agreeUser.value;
              controller.isAgreeError.value = !controller.agreeUser.value;
            }, child: Obx(() {
              return CustomCheckBox(
                value: controller.agreeUser.value,
                iconSize: 20,
              );
            })),
            const SizedBox(
              width: 4,
            ),
            GestureDetector(
              onTap: () {
                controller.agreeUser.value = !controller.agreeUser.value;
                controller.isAgreeError.value = !controller.agreeUser.value;
              },
              child: Row(
                children: [
                  CustomText(
                    S.current.random_text_1025,
                    textColorStyle: CustomTextColorStyle.normal,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () => controller.pushAgree(),
                    child: CustomText(
                      S.current.random_text_1026,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  CustomText(
                    S.current.random_text_1027,
                    textColorStyle: CustomTextColorStyle.normal,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        Obx(() => Visibility(
          visible: controller.isAgreeError.value,
          child: Padding(
            padding: EdgeInsets.only(top: AppValues.smallPadding),
            child: CustomErrorTipsText(
              text: S.current.random_text_1028,
            ),
          )
        )),
        const SizedBox(height: AppValues.defaultPadding,),
        Row(
          children: [
            GestureDetector(onTap: () {
              controller.agreeInfo.value = !controller.agreeInfo.value;
            }, child: Obx(() {
              return CustomCheckBox(
                value: controller.agreeInfo.value,
                iconSize: 20,
              );
            })),
            const SizedBox(
              width: 4,
            ),
            GestureDetector(
              onTap: () {
                controller.agreeInfo.value = !controller.agreeInfo.value;
              },
              child: Row(
                children: [
                  CustomText(
                    S.current.random_text_1029,
                    textColorStyle: CustomTextColorStyle.normal,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProtocol(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Row(
          children: [
            GestureDetector(
                onTap: () => controller.onCheckProtocol(),
                child: Obx(() {
                  return CustomCheckBox(
                    value: controller.isCheckProtocol.value,
                  );
                })),
            const SizedBox(
              width: 8,
            ),
            GestureDetector(
              onTap: () => controller.onCheckProtocol(),
              child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: S.current.random_text_6,
                      style: ThemeService()
                          .theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: CustomTextColorStyle.normal.value),
                    ),
                    TextSpan(
                      text: S.current.register_protocol_title,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // CustomSafeDialog.dismiss(context: context,tag: kCustomRegisterWidget);
                          showCustomRegisterProtocolWidget(context: context);
                        },
                      style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                          color: CustomTextColorStyle.primary.value,
                          decoration: TextDecoration.underline,
                          decorationColor: CustomTextColorStyle.primary.value,
                          decorationThickness: 1,
                          decorationStyle: TextDecorationStyle.solid),
                    ),
                  ])),
            ),
          ],
        ),
        Obx(() {
          return Visibility(
            visible: controller.isCheckCode.value,
            child: Padding(
              padding: const EdgeInsets.only(top: AppValues.smallPadding),
              child: CustomMainTextField(
                inputCallBack: (value) {
                  controller.codeText = value;
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBirthday(BuildContext context) {
    return Column(
      children: [
        // Row(
        //   children: [
        //     CustomAsterisksTipsText(
        //       text: S.current.text_field_birthday_tips,
        //       // textColorStyle: CustomTextColorStyle.normal,
        //     ),
        //     const Expanded(child: SizedBox.shrink()),
        //   ],
        // ),
        const SizedBox(
          height: AppValues.smallPadding,
        ),
        Obx(() {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      return CustomMainTextField(
                        text: controller.dayText.value,
                        showError: controller.isDayError.value,
                        hintText: S.current.random_text_1175,
                        hintColor: AppThemes.hintTextColor,
                        inputCallBack: (value) => controller.onInputDay(value),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CustomLengthTextInputFormatter(2),
                          CustomNumberFormatter()
                        ],
                      );
                    }),
                  ),
                  const SizedBox(
                    width: AppValues.defaultPadding,
                  ),
                  GestureDetector(
                    onTap: () async {
                      _startAnimation(_rotatingArrowKey);

                      ///有弹出键盘，先关闭键盘
                      if (controller.isKeyboardVisible) {
                        KeyboardUtils.hideKeyboard(context);
                        await Future.delayed(const Duration(milliseconds: 300));
                      }
                      Future.delayed(const Duration(milliseconds: 100), () {
                        DialogUtils.showCustomBubbleDialog(
                            Get.context!,
                            _buildAreaList(Get.context!),
                            // bubbleWith,
                            100,
                            widgetKey: _monthGlobalKey,
                            // backgroundColor: ThemeService().colorScheme.tertiary,
                            globalKey: _rotatingArrowKey
                          // globalKey: widget._rotatingArrowKey,
                        );
                      });
                    },
                    child: Stack(
                      children: [ SizedBox(
                        width: 102,
                        child: Obx(() {
                          return CustomMainTextField(
                            showError: controller.isMonthError.value,
                            text: controller.monthText.value,
                            key: _monthGlobalKey,
                            hintText: S.current.monthly_text,
                            hintColor: AppThemes.hintTextColor,
                            enabled: false,
                          );
                        }),
                      )
                        ,
                        Positioned(
                            right: 0,
                            child: Container(
                              height: AppValues.defaultTextHeight,
                              margin: const EdgeInsets.only(right: 9),
                              child: RotatingArrow(
                                key: _rotatingArrowKey,
                              ),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: AppValues.defaultPadding,
                  ),
                  Expanded(
                    child: Obx(() {
                      return CustomMainTextField(
                        text: controller.yearText.value,
                        hintText: 'YYYY',
                        hintColor: AppThemes.hintTextColor,
                        showError: controller.isYearError.value,
                        inputCallBack: (value) => controller.onInputYear(value),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CustomLengthTextInputFormatter(4),
                          CustomNumberFormatter()
                        ],
                      );
                    }),
                  ),
                ],
              ),
              Visibility(
                visible: controller.isDayError.value ||
                    controller.isMonthError.value ||
                    controller.isYearError.value ||
                    controller.birthdayErrorText.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppValues.smallPadding),
                  child: CustomErrorTipsText(
                    text: controller.birthdayErrorText.value,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildAreaList(BuildContext context) {
    return Scrollbar(
      controller: controller.scrollController, // Provide a ScrollController
      radius: const Radius.circular(10),
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: controller.scrollController, // Use the same ScrollController
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 220,
          ),
          child: Obx(() {
            return ListView.builder(
                padding: const EdgeInsets.only(bottom: 6),
                itemCount: controller.list.length,
                itemBuilder: (context, index) {
                  final month = controller.list[index];
                  return GestureDetector(
                    onTap: () {
                      RouteUtil.popView();
                      for (var item in controller.list) {
                        item['isSelected'] = false;
                      }
                      month['isSelected'] = month['isSelected'] == true ? false : true;
                      controller.list.refresh();
                      controller.onInputMonth(month['num'] as String);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 6, left: 6, right: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: month['isSelected'] == true
                            ? ThemeService().colorScheme.secondary
                            : null,
                      ),
                      alignment: Alignment.center,
                      height: 34,
                      width: double.infinity,
                      child: CustomText(month['month'] as String,style: const TextStyle(color: AppThemes.black),),
                    ),
                  );
                });
          }),
        ),
      ),
    );
  }
}