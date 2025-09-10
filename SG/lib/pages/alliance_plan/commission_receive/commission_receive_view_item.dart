import 'package:flutter/widgets.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_text.dart';
import 'commission_receive_model.dart';

class CommissionReceiveItemView extends StatelessWidget {
  CommissionReceiveItemView({super.key, required this.index, required this.model});

  final CommissionReceiveModel model;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12,right: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.defaultPadding,
        vertical: AppValues.largePadding,
      ),
      color: index % 2 == 0
          ? ThemeService().colorScheme.surfaceVariant
          : ThemeService().theme.scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomAssetIcon(
            name: "assets/images/coin_icon/eth_ic.png",
            size: 18,
          ),
          SizedBox(width: AppValues.margin_8),
          CustomText(
            'ETH',
            style: ThemeService().textTheme.bodyMedium,
          ),
          SizedBox(width: AppValues.margin_8),
          CustomText(
            '${model.walletMoney}',
            style: ThemeService().textTheme.bodyMedium,
          ),
          Spacer(),
          CustomText(
            '${model.exchangeRate}',
            style: ThemeService().textTheme.bodyMedium,
          ), SizedBox(width: AppValues.margin_20),
        ],
      ),
    );
  }
}
