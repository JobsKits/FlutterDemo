import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_icon.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/dialog/custom_safe_dialog.dart';
import '../../../../widget/input/custom_main_text_field.dart';
import 'index.dart';

class VerifyCodePage extends GetView<VerifyCodeController> {
  const VerifyCodePage({Key? key,required this.number}) : super(key: key);

  final String number;

  // 主视图
  Widget _buildView() {
    controller.initial(number);
    return Stack(
      children: [
        GestureDetector(
          onTap: controller.onTap,
          child: Container(
            color: Colors.transparent,
          ),
        ),
		    Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
              padding: const EdgeInsets.all(AppValues.padding_16),
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppValues.smallRadius),
                color: ThemeService().theme.scaffoldBackgroundColor,
              ),
              child: Column(
                children: [
                  _buildTop(),
                  Obx(() => controller.hidden.value ? Container() : _buildBody())
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTop() {
    return Row(
      children: [
        GestureDetector(
          onTap: controller.onTap,
          child: const CustomAssetIcon(
            name: 'assets/images/ic_back.png',
            size: 14,
          ),
        ),
        const SizedBox(width: 8,),
        Obx(() => CustomText(controller.isPhone.value ? S.current.random_text_1047 : S.current.random_text_1033,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)),
        const Spacer(),
        GestureDetector(
          onTap: () {
            RouteUtil.popView();
            RouteUtil.popView();
          },
          child: const CustomIcon(asset: 'assets/images/normal/ic_normal_close.png',size: 20,)
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        const SizedBox(height: AppValues.defaultPadding,),
        CustomText('${S.current.random_text_1048}${number}${S.current.random_text_1052}',style: TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),),
        const SizedBox(height: AppValues.defaultPadding,),
        Stack(
          children: [
            Obx(() => CustomMainTextField(
              required: true,
              contentPadding: const EdgeInsets.only(left: AppValues.defaultPadding,right: 52),
              text: controller.codeText.value,
              keyboardType: TextInputType.number,
              maxLength: 6,
              showError: controller.isCodeError.value,
              errorText: controller.codeErrorText.value,
              inputCallBack: (value) => controller.onInputCode(value),
              inputCompletionCallBack: (value, isSubmitted) => controller.onCheckCode(value),
            )),
            Positioned(
              top: AppValues.padding_10,
              right: AppValues.defaultMargin,
              child: Obx(() => GestureDetector(
                onTap: controller.resend,
                child: CustomText(controller.showTime.value ? '${controller.seconds.value}s' : S.current.random_text_1050,style: const TextStyle(fontWeight: FontWeight.w500),)
              ))
            )
          ],
        ),
        const SizedBox(height: AppValues.defaultPadding,),
        Obx(() => CustomMainTextField(
          required: true,
          text: controller.passwordText,
          hintText: S.current.new_password_text,
          hintColor: AppThemes.hintTextColor,
          isPwd: true,
          showError: controller.isPasswordError.value,
          errorText: controller.passwordErrorText.value,
          inputCallBack: (value) => controller.onInputPwd(value),
        )),
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
        const SizedBox(height: AppValues.defaultPadding,),
        Row(
          children: [
            GestureDetector(
              onTap: controller.onTapTips,
              child: CustomText(S.current.random_text_1035,style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),),
            )
          ],
        ),
        const SizedBox(height: AppValues.defaultPadding,),
        Obx(() {
          return CustomBigMainButton(
            title: S.current.submit_text,
            fontWeight: FontWeight.w600,
            colorStyle: CustomButtonColorStyle.tertiary,
            isEnable: controller.isButtonEnable.value,
            onTap: (btnCtr) => controller.onSubmit(btnCtr),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyCodeController>(
      init: VerifyCodeController(),
      id: "verify_code",
      builder: (_) {
        controller.context = context;
        return Scaffold(
          // appBar: AppBar(title: const Text("phone_verify")),
          backgroundColor: Colors.transparent,
          body: _buildView(),
        );
      },
    );
  }
}

Future<void> showCustomVerifyCodeWidget<T>({required String number}) async {
  await CustomSafeDialog.show<T>(
      context: Get.context!,
      tag: 'CustomVerifyCodeWidget',
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (_) {
        return VerifyCodePage(number: number,);
      });
}
