import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import '../../../../../constant/app_values.dart';

import 'index.dart';

class VersionNumberPage extends GetView<VersionNumberController> {
  const VersionNumberPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Container(
      margin: const EdgeInsets.only(bottom: 35),
      padding: const EdgeInsets.symmetric(vertical: 32,horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
        color: ThemeService().colorScheme.surface,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 54,
            child: CustomText('${S.current.random_text_585}${controller.currentVersion}'),
          ),
          const SizedBox(height: 24,),
          SizedBox(
            height: 54,
            child: CustomText('${S.current.random_text_586}${controller.lastestVersion}'),
          ),
          const SizedBox(height: 24,),
          GestureDetector(
            onTap: controller.onTap,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppValues.smallRadius),
                color: controller.isLatest ? Colors.transparent : ThemeService().colorScheme.primary,
              ),
              child: CustomText(controller.isLatest ? S.current.random_text_587 : S.current.random_text_588,
              textColorStyle: controller.isLatest ? CustomTextColorStyle.primary : CustomTextColorStyle.panda),
            ),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VersionNumberController>(
      init: VersionNumberController(),
      id: "version_number",
      builder: (_) {
        controller.context = context;
        return Scaffold(
          // appBar: AppBar(title: const Text("version_number")),
          body: _buildView(),
        );
      },
    );
  }
}
