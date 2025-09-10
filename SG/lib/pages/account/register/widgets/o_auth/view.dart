import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constant/app_themes.dart';
import '../../../../../constant/app_values.dart';
import '../../../../../services/theme/theme_service.dart';
import '../../../../../widget/button/custom_big_main_button.dart';
import '../../../../../widget/button/custom_button_style.dart';
import '../../../../../widget/custom_asset_icon.dart';
import '../../../../../widget/custom_icon.dart';
import '../../../../../widget/custom_text.dart';
import '../../../../../widget/dialog/custom_safe_dialog.dart';
import '../../../../../widget/input/custom_main_text_field.dart';
import 'index.dart';

class OAuthPage extends GetView<OAuthController> {
  const OAuthPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Stack(
      children: [
        GestureDetector(
          onTap: controller.onTap,
          child: Container(
            color: Colors.transparent,
          ),
        ),
		    Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
            padding: const EdgeInsets.all(AppValues.padding_16),
            width: Get.width,
            height: 304,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppValues.smallRadius),
              color: ThemeService().theme.scaffoldBackgroundColor,
            ),
            child: Column(
              children: [
                _buildTop(),
                _buildBody()
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 20,),
        CustomText(S.current.random_text_1030,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
        GestureDetector(
          onTap: controller.onTap,
          child: const CustomIcon(asset: 'assets/images/normal/ic_normal_close.png',size: 20,)
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        const SizedBox(height: AppValues.defaultPadding,),
        Container(
          alignment: Alignment.centerLeft,
          child: CustomText(S.current.random_text_1031,style: TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),),
        ),
        const SizedBox(height: AppValues.padding_4,),
        CustomMainTextField(
          required: true,
          text: controller.codeText,
          hintText: S.current.text_field_user_name_tips,
          hintColor: AppThemes.hintTextColor,
          // showError: controller.isAccountError.value,
          // errorText: controller.accountErrorText.value,
          inputCallBack: (value) => controller.onInputCode(value),
        ),
        const SizedBox(height: AppValues.defaultPadding,),
        CustomMainTextField(
          required: true,
          text: controller.passwordText,
          hintText: S.current.random_text_670,
          hintColor: AppThemes.hintTextColor,
          isPwd: true,
          // showError: controller.isAccountError.value,
          // errorText: controller.accountErrorText.value,
          inputCallBack: (value) => controller.onInputPwd(value),
        ),
        const SizedBox(height: AppValues.defaultPadding,),
        Obx(() {
          return CustomBigMainButton(
            title: S.current.start_game_text,
            fontWeight: FontWeight.w600,
            colorStyle: CustomButtonColorStyle.tertiary,
            isEnable: controller.isButtonEnable.value,
            // onTap: (btnCtr) => controller.onSubmit(context, btnCtr),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OAuthController>(
      init: OAuthController(),
      id: "o_auth",
      builder: (_) {
        return Scaffold(
          // appBar: AppBar(title: const Text("o_auth")),
          backgroundColor: Colors.transparent,
          body: _buildView(),
        );
      },
    );
  }
}

Future<void> showCustomOAutWidget<T>() async {
  await CustomSafeDialog.show<T>(
      context: Get.context!,
      tag: 'CustomOAutWidget',
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (_) {
        return const OAuthPage();
      });
}