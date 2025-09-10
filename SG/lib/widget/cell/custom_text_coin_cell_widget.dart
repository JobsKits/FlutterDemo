import 'package:flutter/material.dart';

import '../../constant/app_values.dart';
import '../../services/theme/theme_service.dart';
import '../custom_text.dart';
import '../network_image/custom_network_image.dart';

///最简单的金额 和 货币显示
class CustomMoneyCoinCellWidget extends StatelessWidget {
  const CustomMoneyCoinCellWidget({
    super.key,
    required this.moneyTarget,
    this.coinUrl,
    this.coinName,
    this.style,
    this.fontSize,
    this.coinSize,
    this.marginSpace,
    this.padding,
  });

  final String moneyTarget;
  final String? coinUrl;
  final String? coinName;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;
  final double? fontSize;
  final double? coinSize;
  final double? marginSpace; //金额 与 货币图标的间距
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            moneyTarget,
            style: style ??
                ThemeService()
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: fontSize),
          ),
          SizedBox(width: marginSpace ?? AppValues.margin_2),
          CustomNetWorkImage(
            width: coinSize ?? 12,
            height: coinSize ?? 12,
            imageUrl: coinUrl ?? "",
            showErrorMsg: false,
          ),
          SizedBox(width: coinName != null ? (marginSpace ?? AppValues.margin_2) : 0),
          Container(
            child: CustomText(
              coinName ?? "",
              style: style ??
                  ThemeService()
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.w500, fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
