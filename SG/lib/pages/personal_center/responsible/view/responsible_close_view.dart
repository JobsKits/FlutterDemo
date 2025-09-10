import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/custom_text.dart';
import '../responsible_logic.dart';

class ResponsibleCloseView extends StatelessWidget {
   ResponsibleCloseView({super.key});
  final ResponsibleLogic controller = Get.find<ResponsibleLogic>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      child: Column(
        children: [
          CustomText(
            S.current.random_text_fix3,
            style: ThemeService().theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400),
          ),
          SizedBox(height: AppValues.defaultPadding),
          CustomBigMainButton(
            onTap: (_) {
              // CustomSafeDialog.dismiss(context: context, tag: kDataCountPage);
              //todo
              // showCustomWalletDetailsWidget(context: context);
              controller.onClickGoOut();
            },
            title: S.current.logout_text,
          ),
        ],
      ),
    );
  }
}
