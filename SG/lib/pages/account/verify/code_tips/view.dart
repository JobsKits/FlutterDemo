import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_icon.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/dialog/custom_safe_dialog.dart';
import '../../../../widget/input/custom_main_text_field.dart';
import 'index.dart';

class CodeTipsPage extends GetView<CodeTipsController> {
  const CodeTipsPage({Key? key,required this.isPhone,required this.fromPage}) : super(key: key);

  final bool? isPhone;
  final int? fromPage;//1 来自单行  2 来自双行

  // 主视图
  Widget _buildView() {
    controller.fromPage = fromPage??0;
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
            height: 258,
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
        CustomText(S.current.random_text_1035,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
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
        CustomText(isPhone! ? S.current.random_text_1039 : S.current.random_text_1040,style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),),
        const SizedBox(height: AppValues.defaultPadding,),
        Container(
          alignment: Alignment.centerLeft,
          child: CustomText(isPhone! ? S.current.random_text_1041 : S.current.random_text_1042,style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),)
        ),
        const SizedBox(height: AppValues.padding_8,),
        Container(
          alignment: Alignment.centerLeft,
          child: CustomText(isPhone! ? S.current.random_text_1043 : S.current.random_text_1044,style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),)
        ),
        const SizedBox(height: AppValues.padding_8,),
        Container(
          alignment: Alignment.centerLeft,
          child: CustomText(S.current.random_text_1045,style: TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),)
        ),
        const SizedBox(height: AppValues.defaultPadding,),
        Obx(() {
          return CustomBigMainButton(
            title: S.current.confirm,
            fontWeight: FontWeight.w600,
            colorStyle: CustomButtonColorStyle.tertiary,
            isEnable: controller.isButtonEnable.value,
            onTap: (btnCtr) => controller.onTap(),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CodeTipsController>(
      init: CodeTipsController(),
      id: "code_tips",
      builder: (_) {
        return Scaffold(
          // appBar: AppBar(title: const Text("code_tips")),
          backgroundColor: Colors.transparent,
          body: _buildView(),
        );
      },
    );
  }
}

Future<void> showCustomCodeTipsWidget<T>({
  bool? isPhone = true,
  int? fromPage = 0
}) async {
  await CustomSafeDialog.show<T>(
      context: Get.context!,
      tag: 'CustomCodeTipsWidget',
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (_) {
        return CodeTipsPage(isPhone: isPhone,fromPage: fromPage,);
      });
}
