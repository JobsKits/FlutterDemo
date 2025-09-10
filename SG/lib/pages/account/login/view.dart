

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/pages/account/login/logic.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/utils/formatter/custom_number_formatter.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/account/widgets/account_policy_widget.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/button/custom_button_style.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/pages/account/forget_password/forget_password_widget.dart';
import 'package:flutter_bet/pages/account/register/register_widget.dart';
import '../../../constant/app_themes.dart';
import '../../../utils/keyboard_util.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../widgets/third_party_authorization_widget.dart';
import '../../../routes/routes.dart';

class LoginPage extends BaseView<LoginLogic> {
  final controller = Get.find<LoginLogic>();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final _monthGlobalKey = GlobalKey();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }
  
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    controller.context = context;
    return CustomAppBar(
      appBarTitleText: S.current.top_login,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
     return SingleChildScrollView(
       child: Container(
         // margin: const EdgeInsets.symmetric(
         //     horizontal: AppValues.defaultMargin),
           decoration: BoxDecoration(
             // borderRadius: BorderRadius.circular(AppValues.smallRadius),
             color: ThemeService().theme.scaffoldBackgroundColor,
             //   color: Colors.red
           ),
           child: _buildBody(context)
       ),
     );
  }

  _buildBody(BuildContext context) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
        child: Column(
          children: [
            const SizedBox(height: AppValues.extraLargePadding,),
            Column(
              children: [
                Obx(() => controller.isPhone.value ? phoneWidget() 
                : CustomMainTextField(
                  text: controller.accountText,
                  required: true,
                  // title: S.current.login_text_field_account_tips,
                  hintText: S.current.random_text_1016,
                  hintColor: AppThemes.hintTextColor,
                  showError: controller.isAccountError.value,
                  errorText: controller.accountErrorText.value,
                  inputCallBack: (value) => {
                    controller.accountText = value,
                    controller.onInputAccount(value,false)
                  },
                  inputCompletionCallBack: (String value, bool isSubmitted) => controller.onInputAccount(value,true),
                )),
                const SizedBox(
                  height: AppValues.defaultPadding,
                ),
                CustomMainTextField(
                  text: controller.passwordText,
                  required: true,
                  // title: S.current.login_text_field_password_tips,
                  hintText: S.current.random_text_670,
                  hintColor: AppThemes.hintTextColor,
                  showError: controller.isPasswordError.value,
                  errorText: controller.passwordErrorText.value,
                  isPwd: true,
                  inputCallBack: (value) => {
                    controller.passwordText = value,
                    controller.onInputPassword(value,false)
                  },
                  inputCompletionCallBack: (String value, bool isSubmitted) => controller.onInputPassword(value,true),
                ),
                const SizedBox(
                  height: AppValues.defaultPadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => controller.switchUI(),
                      child: Obx(() => CustomText(controller.isPhone.value ? S.current.random_text_1016 : S.current.random_text_1017,style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),)),
                    ),
                    GestureDetector(
                      onTap: () => showCustomForgetPasswordWidget(context: context),
                      child: CustomText(S.current.random_text_1018,style: TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppValues.defaultPadding,
                ),
                CustomBigMainButton(
                  title: S.current.top_login,
                  colorStyle: CustomButtonColorStyle.tertiary,
                  onTap: (btnCtr) => controller.onLogin(context, btnCtr),
                ),
                const SizedBox(
                  height: AppValues.defaultPadding,
                ),
                Row(
                  children: [
                    CustomText(S.current.random_text_1019,style: TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w500),),
                    GestureDetector(
                      onTap: () => showCustomRegisterWidget(context: context),
                      child: CustomText(S.current.random_text_1020,style: TextStyle(fontWeight: FontWeight.w600),),
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
                      color: ThemeService().colorScheme.tertiary,
                      width: 64,
                      height: 2,
                    ),
                    const SizedBox(
                      width: AppValues.defaultPadding,
                    ),
                    CustomText(
                      S.current.random_text_1021,
                      style: TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: AppValues.defaultPadding,
                    ),
                    Container(
                      color: ThemeService().colorScheme.tertiary,
                      width: 64,
                      height: 2,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            const ThirdPartyAuthorizationWidget(),
            // const SizedBox(
            //   height: AppValues.defaultPadding,
            // ),
            // GestureDetector(
            //     onTap: () {
            //       // CustomSafeDialog.dismiss(
            //       //     context: context, tag: kCustomLoginWidget);
            //       showCustomForgetPasswordWidget(context: context);
            //       // RouteUtil.pushToView(Routes.registerpage);
            //     },
            //     child: CustomText(S.current.forget_password_text)),
            // const SizedBox(
            //   height: AppValues.defaultPadding,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     CustomText(
            //       S.current.no_account_tips_text,
            //       textColorStyle: CustomTextColorStyle.normal,
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         // RouteUtil.popView();
            //         RouteUtil.pushToView(Routes.registerPage, offLast: true);
            //       },
            //       child: CustomText(
            //         S.current.register_an_account,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: AppValues.defaultPadding,
            // ),
            //https://jira.vgtech.org/browse/STAK-1225
            // const AccountPolicyWidget(),
            // const SizedBox(
            //   height: AppValues.largePadding,
            // ),
          ],
        ),
      );
    });
  }

  Widget phoneWidget() {
    return Stack(
      children: [
        CustomMainTextField(
          text: controller.phoneText,
          keyboardType: TextInputType.number,
          inputFormatters: [CustomNumberFormatter()],
          required: true,
          // title: S.current.login_text_field_account_tips,
          hintText: S.current.phone_number_text,
          hintColor: AppThemes.hintTextColor,
          contentPadding: const EdgeInsets.only(left: 80),
          showError: controller.isPhoneError.value,
          errorText: controller.phoneErrorText.value,
          inputCallBack: (value) => {
            controller.phoneText = value,
            controller.onInputPhone(value,false)
          },
          inputCompletionCallBack: (String value, bool isSubmitted) => controller.onInputPhone(value,true),
        ),
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
            });
          },
          child: Obx(() => Container(
            width: 68,
            height: 40,
            key: _monthGlobalKey,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(width: 2,color: controller.isPhoneError.value ? ThemeService().colorScheme.error : ThemeService().colorScheme.tertiary))
            ),
            child: Row(
              children: [
                const SizedBox(width: 12,),
                Obx(() =>  CustomText(controller.areaCode.value,style: const TextStyle(fontWeight: FontWeight.w600),)),
                RotatingArrow(key: _rotatingArrowKey,color: Colors.white,),
              ],
            ),
          ))
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
            _buildSearchView(),
            Container(
              constraints: const BoxConstraints(
                maxHeight: 400,
              ),
              child: Obx(() => ListView.builder(
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
                      child: CustomText(code.attr!,style: const TextStyle(color: AppThemes.black),),
                    ),
                  );
                }
              ))
            ),
          ],
        )
      ),
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
            controller.showArray.value = controller.areaCodeArray.where((element) => element.attr!.contains(value)).toList();
          } else {
            controller.showArray.value = controller.areaCodeArray.where((element) => element.name!.contains(value)).toList();
          }
          
        },
        onSubmitted: (String value) {
          // log('Submitted text: $value');
        },
      ),
    );
  }
}