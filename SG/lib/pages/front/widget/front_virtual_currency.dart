import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/services/theme/extension/button_theme_data_extension.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';

import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/function.dart';

class FrontVirtualCurrency extends StatelessWidget {
  final ParamVoidCallback? onTap;

  const FrontVirtualCurrency({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      padding: EdgeInsets.all(AppValues.defaultPadding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: ThemeService().theme.colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            S.current.no_crypto,
            style: ThemeService().textTheme.bodyMedium,
          ),
          SizedBox(
            height: AppValues.defaultPadding,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/bet_slip/ic_pay_one.webp',
                width: 56,
                height: 28,
              ),
              Image.asset(
                'assets/images/bet_slip/ic_pay_two.webp',
                width: 56,
                height: 28,
              ),
              Image.asset(
                'assets/images/bet_slip/ic_pay_three.webp',
                width: 56,
                height: 28,
              ),
              Image.asset(
                'assets/images/bet_slip/ic_pay_four.webp',
                width: 56,
                height: 28,
              ),
            ],
          ),
          SizedBox(
            height: AppValues.defaultPadding,
          ),
          CustomButton(
            title: S.current.buy_crypto,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            backgroundColor: ThemeService().theme.colorScheme.tertiary,
            textStyle: ThemeService().textTheme.bodyMedium,
            borderRadius: ThemeService().theme.buttonTheme.borderRadius,
            onTap: onTap,
          )
        ],
      ),
    );
  }
}
