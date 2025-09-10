import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';

import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_icon.dart';
import '../../../../widget/custom_text.dart';

/// 统计数据  和 竞赛 列表公用item
class DataItemView extends StatelessWidget {
  final int index;

  const DataItemView({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final isOdd = index % 2 == 1;
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      decoration: BoxDecoration(
        color: isOdd ? Colors.transparent : ThemeService().colorScheme.surfaceVariant,
        // borderRadius: BorderRadius.circular(AppValues.smallRadius),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CustomText(
              "11",
              textAlign: TextAlign.left,
              textColorStyle: CustomTextColorStyle.normal,
              style: ThemeService().textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: CustomText(
              "22",
              textColorStyle: CustomTextColorStyle.normal,
              textAlign: TextAlign.center,
              style: ThemeService().textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: CustomText(
              "33",
              textColorStyle: CustomTextColorStyle.normal,
              textAlign: TextAlign.center,
              style: ThemeService().textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(
                  "444",
                  textColorStyle: CustomTextColorStyle.normal,
                  style: ThemeService().textTheme.bodySmall,
                ),
                CustomAssetIcon(size:18,name: "assets/images/coin_icon/eth_ic.png"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
