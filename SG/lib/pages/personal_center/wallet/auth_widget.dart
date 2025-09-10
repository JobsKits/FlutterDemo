import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/constant/app_common.dart';

import '../../../app/modules/vaultDescriptions/views/vault_descriptions_view.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../routes/routes.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/button/custom_small_mian_button.dart';
import '../../../widget/custom_text.dart';

// const double bottomViewHeight = 116;

class AuthWidget extends StatelessWidget {
  final String tips;

  const AuthWidget({super.key, this.tips = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppValues.margin_20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
        color: ThemeService().colorScheme.surface,
      ),
      // height: bottomViewHeight,
      child: Column(
        children: [
          const SizedBox(
            height: 18,
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: CustomText(
              S.current.vault_increase_your_account_security_with_double_verification,
              style: ThemeService().theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w400, color: ThemeService().colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          CustomSmallMainButton(
            // contentPaddingTopAndBottom: 11.0,
            padding: const EdgeInsets.symmetric(vertical: 11.0),
            onTap: () {
              GlobalState.instance.index = 8;
              RouteUtil.pushToView(Routes.setupPage, offLast: true, arguments: {'pageIndex': 2});
            },
            title: "\t\t\t${S.current.vault_turn_on_two_step_verification}\t\t\t",// 启用双重验证
            backgroundColor: ThemeService().colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
          Visibility(
              visible: tips.isEmpty, child: Container(margin: const EdgeInsets.only(bottom: 16))),
          Visibility(
              visible: tips.isNotEmpty,
              child: CupertinoButton(
                  onPressed: () {
                    VaultDescriptionsView.openPage();
                  },
                  child: CustomText(
                    tips,
                    textColorStyle: CustomTextColorStyle.normal,
                  ))),
        ],
      ),
    );
  }
}
