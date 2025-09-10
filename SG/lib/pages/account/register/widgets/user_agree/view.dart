import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../../../../widget/dialog/custom_safe_dialog.dart';

import '../../../../../constant/app_themes.dart';
import '../../../../../constant/app_values.dart';
import '../../../../../services/theme/theme_service.dart';
import '../../../../../utils/route_util.dart';
import '../../../../../widget/custom_asset_icon.dart';
import '../../../../../widget/custom_icon.dart';
import '../../../../../widget/custom_text.dart';
import 'index.dart';

class UserAgreePage extends GetView<UserAgreeController> {
  const UserAgreePage({Key? key}) : super(key: key);

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
            height: 392,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppValues.smallRadius),
              color: ThemeService().theme.scaffoldBackgroundColor,
            ),
            child: Column(
              children: [
                _buildTop(),
                const SizedBox(height: AppValues.defaultPadding,),
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
          child: Row(
            children: [
              const CustomAssetIcon(
                name: 'assets/images/ic_back.png',
                size: 14,
              ),
              const SizedBox(width: 8,),
              CustomText(S.current.random_text_1032,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
            ],
          )
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            controller.onTap();
            RouteUtil.popView();
          },
          child: const CustomIcon(asset: 'assets/images/normal/ic_normal_close.png',size: 20,)
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      height: 323,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
        color: AppThemes.surfaceVariant,
      ),
      child: InAppWebView(
        initialFile: 'assets/html/terms_of_service.html',
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(transparentBackground: true),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserAgreeController>(
      init: UserAgreeController(),
      id: "user_agree",
      builder: (_) {
        return Scaffold(
          // appBar: AppBar(title: const Text("user_agree")),
          backgroundColor: Colors.transparent,
          body: _buildView(),
        );
      },
    );
  }
}

Future<void> showUserAgreeWidget<T>() async {
  await CustomSafeDialog.show<T>(
      context: Get.context!,
      tag: 'UserAgreeWidget',
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (_) {
        return const UserAgreePage();
      });
}
