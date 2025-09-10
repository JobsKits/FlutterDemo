import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/views/top_title_view.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_text.dart';
import '../controllers/withdraw_ctrl.dart';

class WdLimit extends GetView<WithDrawCtrl> {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              color: ThemeService().colorScheme.background,
            ),
            child: Column(
              children: [
                TopTitleView(
                  name: "assets/images/personal_center_icon/wallet/cards_warning.png",
                  title: S.current.snack_bar_normal_tips,
                ),
                _tips()
              ],
            )));
  }

  Widget _tips() {
    return Container(
      margin: const EdgeInsets.only(top: AppValues.padding_16),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/pay_method/pay_details_tips_bg.png'),
              fit: BoxFit.fill)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Obx(() {
                  return CustomText(
                    S.current.random_text_1213 +
                        "${controller.feeInfo['withdraw_setting_count']}" +
                        S.current.random_text_1214 +
                        "${controller.feeInfo['withdraw_fee_rate']}" +
                        S.current.random_text_1215,
                    textColorStyle: CustomTextColorStyle.secondary,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    softWrap: true,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
