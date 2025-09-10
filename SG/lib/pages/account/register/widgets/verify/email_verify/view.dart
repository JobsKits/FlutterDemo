import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../../../constant/app_themes.dart';
import '../../../../../../constant/app_values.dart';
import '../../../../../../services/theme/theme_service.dart';
import '../../../../../../widget/button/custom_big_main_button.dart';
import '../../../../../../widget/button/custom_button_style.dart';
import '../../../../../../widget/custom_asset_icon.dart';
import '../../../../../../widget/custom_icon.dart';
import '../../../../../../widget/dialog/custom_safe_dialog.dart';
import '../../../../../../widget/input/custom_main_text_field.dart';
import 'index.dart';

class RegisterEmailVerifyPage extends GetView<RegisterEmailVerifyController> {
  const RegisterEmailVerifyPage({Key? key}) : super(key: key);

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
            height: 260,
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
      children: [
        GestureDetector(
          onTap: controller.onTap,
          child: const CustomAssetIcon(
            name: 'assets/images/ic_back.png',
            size: 14,
          ),
        ),
        const SizedBox(width: 8,),
        CustomText(S.current.random_text_1033,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
        const Spacer(),
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
        CustomText(S.current.random_text_1034,style: TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),),
        const SizedBox(height: AppValues.defaultPadding,),
        Stack(
          children: [
            CustomMainTextField(
              required: true,
              contentPadding: const EdgeInsets.only(right: 52),
              text: controller.codeText,
              // showError: controller.isAccountError.value,
              // errorText: controller.accountErrorText.value,
              inputCallBack: (value) => controller.onInputCode(value),
            ),
            Positioned(
              top: AppValues.padding_10,
              right: AppValues.defaultMargin,
              child:  Obx(() => CustomText('${controller.seconds.value}s',style: const TextStyle(fontWeight: FontWeight.w500),)),
            )
          ],
        ),
        const SizedBox(height: AppValues.defaultPadding,),
        Row(
          children: [
            CustomText(S.current.random_text_1035,style: TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),)
          ],
        ),
        const SizedBox(height: AppValues.defaultPadding,),
        Obx(() {
          return CustomBigMainButton(
            title: S.current.submit_text,
            fontWeight: FontWeight.w600,
            colorStyle: CustomButtonColorStyle.tertiary,
            isEnable: controller.isButtonEnable.value,
            onTap: (btnCtr) => controller.onSubmit(),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterEmailVerifyController>(
      init: RegisterEmailVerifyController(),
      id: "register_email_verify",
      builder: (_) {
        return Scaffold(
          // appBar: AppBar(title: const Text("email_verify")),
          backgroundColor: Colors.transparent,
          body: _buildView(),
        );
      },
    );
  }
}

Future<void> showRegisterEmailVerifyWidget<T>() async {
  await CustomSafeDialog.show<T>(
      context: Get.context!,
      tag: 'RegisterEmailVerifyWidget',
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (_) {
        return const RegisterEmailVerifyPage();
      });
}
