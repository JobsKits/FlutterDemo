import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';

import '../../../../../constant/app_values.dart';
import '../../../../../services/theme/theme_service.dart';
import 'sport_betting_item_model.dart';

class SportBettingItemView extends StatelessWidget {
  final int index;
  final SportBettingItemModel model;

  const SportBettingItemView({super.key, required this.index, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: index % 2 == 0
          ? ThemeService().colorScheme.surfaceVariant
          : ThemeService().theme.scaffoldBackgroundColor,
      alignment: Alignment.center,
      height: 54,
      padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomAssetIcon(size: 14, name: "assets/images/sport/ic_sport_betting_double.webp"),
          const SizedBox(width: 8),
          CustomText('${model.title}-$index'),
          Spacer(),
          Expanded(
              flex: 2,
              child: CustomText(
                '${model.money}1231233131',
                overflow: TextOverflow.ellipsis,
                style: ThemeService().textTheme.labelLarge,
              )),
          const SizedBox(width: AppValues.margin_8),
          CustomAssetIcon(size: 14, name: "assets/images/coin_icon/ic_eth.png"),
        ],
      ),
    );
  }
}
