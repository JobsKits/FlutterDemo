import 'package:flutter/material.dart';
import 'package:flutter_bet/model/wallet/TypeBean.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../services/theme/theme_service.dart';
import '../controllers/withdraw_ctrl.dart';

class PayoutOptionsView extends GetView<WithDrawCtrl> {
  PayoutOptionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Visibility(
        visible: controller.payoutOptions.length >= 2,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: ThemeService().colorScheme.surface),
          height: 40,
          child: Obx(() {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: controller.payoutOptions.length,
              itemBuilder: (context, index) {
                return _optionItem(controller.payoutOptions[index], index);
              },
            );
          }),
        ),
      );
    });
  }

  _optionItem(TypeBean typeBean, int index) {
    return InkWell(
      onTap: () => controller.savePayoutOption(typeBean),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
        padding: const EdgeInsets.only(left: 30, right: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: typeBean.isSelect ? ThemeService().colorScheme.tertiary : Colors.transparent),
        child: CustomText(
          typeBean.name,
          style: const TextStyle(
              fontSize: 14, color: AppThemes.textColorWhite, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
