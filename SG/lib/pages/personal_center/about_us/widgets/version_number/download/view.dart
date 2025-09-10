import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:get/get.dart';
import '../../../../../../constant/app_values.dart';
import '../../../../../../services/theme/theme_service.dart';
import '../../../../../../widget/custom_icon.dart';
import '../../../../../../widget/custom_text.dart';
import '../../../../../../widget/dialog/custom_safe_dialog.dart';
import 'index.dart';

const String kDownloadWidget = 'kDownloadWidget';

class DownloadPage extends GetView<DownloadController> {
  const DownloadPage({Key? key}) : super(key: key);

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
            height: 176,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppValues.smallRadius),
              color: ThemeService().theme.scaffoldBackgroundColor,
            ),
            child: Column(
              children: [
                _buildTop(),
                _buildBody(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTop() {
    return Column(
      children: [
        Row(
          children: [
            const CustomIcon(
              asset: 'assets/images/personal_center_icon/about_us/download.png',
              size: 18,
            ),
            const SizedBox(width: AppValues.padding_8,),
            CustomText(
              S.current.random_text_582,
              style: ThemeService().textTheme.bodyLarge?.copyWith(fontSize: 16,fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            InkWell(
              onTap: controller.onTap,
              child: const CustomIcon(
                asset: 'assets/images/normal/ic_normal_close.png',
                size: 18,
              ),
            )
          ],
        ),
        const SizedBox(height: AppValues.defaultPadding,),
        Container(
          height: 2,
          color: ThemeService().colorScheme.tertiary,
        )
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        const SizedBox(height: AppValues.defaultPadding,),
        CustomText(
          S.current.random_text_583,
          style: ThemeService().textTheme.bodyLarge?.copyWith(fontSize: 16,fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: AppValues.padding_16,),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ThemeService().colorScheme.surface,
          ),
          child: Obx(() => Container(
            padding: const EdgeInsets.only(right: 5),
            width: (Get.width -32) * controller.value.value/100,
            height: 20,
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ThemeService().colorScheme.primary,
            ),
            child: controller.value.value > 7 
            ? CustomText('${controller.value.value}%',style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)
            : Container(),
          )),
        ),
        const SizedBox(height: AppValues.padding_16,),
        CustomText(S.current.random_text_584,style: TextStyle(fontSize: 12,color: AppThemes.onSurfaceVariant),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadController>(
      init: DownloadController(),
      id: "download",
      builder: (_) {
        return Scaffold(
          // appBar: AppBar(title: const Text("download")),
          backgroundColor: Colors.transparent,
          body: _buildView(),
        );
      },
    );
  }
}

Future<void> showDownloadWidget<T>({
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: Get.context!,
      tag: kDownloadWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return const DownloadPage();
      });
}