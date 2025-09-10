import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/widgets.dart';

import '../../../../../constant/app_values.dart';
import '../../../../../services/theme/theme_service.dart';
import '../../../../../widget/custom_asset_icon.dart';
import '../../../../../widget/custom_text.dart';
import 'sport_compete_item_model.dart';

class SportCompeteItemView extends StatelessWidget {
  final int index;
  final SportCompeteItemModel model;

  const SportCompeteItemView({super.key, required this.index, required this.model});

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child:
                CustomAssetIcon(size: 14, name: "assets/images/sport/ic_sport_betting_double.webp"),
          ),
          Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomAssetIcon(size: 15, name: "assets/images/sport/ic_sport_betting_hide.webp"),
                  SizedBox(width: 4),
                  CustomText(S.current.random_text_238,
                      style: ThemeService().textTheme.labelLarge?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                ],
              )),
          Expanded(
              flex: 3,
              child: CustomText('\$19,673,166.82',
                  textAlign: TextAlign.center,
                  style: ThemeService().textTheme.labelLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ))),
          Expanded(
            child:
                CustomAssetIcon(size: 14, name: "assets/images/sport/ic_sport_betting_double.webp"),
          )
        ],
      ),
    );
  }
}
