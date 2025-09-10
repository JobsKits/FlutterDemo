import 'package:flutter/material.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import 'index.dart';

class FairnessPage extends GetView<FairnessController> {
  const FairnessPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: ThemeService().colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(controller.title,
              style: ThemeService().textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16
              ),
            ),
            SizedBox(height: 12,),
            CustomText(controller.details,textColorStyle: CustomTextColorStyle.secondary,),
            SizedBox(height: 12,),
            CustomText(controller.title1,
              style: ThemeService().textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16
              ),
            ),
            SizedBox(height: 12,),
            CustomText(controller.details,textColorStyle: CustomTextColorStyle.secondary,),
            SizedBox(height: 12,),
            CustomText(controller.title2,
              style: ThemeService().textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16
              ),
            ),
            SizedBox(height: 12,),
            CustomText(controller.details,textColorStyle: CustomTextColorStyle.secondary,),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FairnessController>(
      init: FairnessController(),
      id: "fairness",
      builder: (_) {
        return Scaffold(
          // appBar: AppBar(title: const Text("fairness")),
          body: _buildView(),
        );
      },
    );
  }
}
