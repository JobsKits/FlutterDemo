import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';

class VipClubSwiperModel {
  final String assetName;
  final String title;
  final String detail;
  const VipClubSwiperModel({
    required this.assetName,
    required this.title,
    required this.detail,
  });
}

class VipClubSwiperItemView extends StatelessWidget {
  final VipClubSwiperModel model;

  const VipClubSwiperItemView({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 30),
      elevation: 5,
      shadowColor: AppThemes.surfaceVariant,
      color: AppThemes.chatRooCardColor,

      /// 边框
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: AppThemes.chatRooCardColor,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomAssetIcon(
            name: model.assetName,
            size: 150,
          ),
          SizedBox(height: AppValues.margin_6),
          SizedBox(
            child: CustomText(
              model.title,
              style: ThemeService().textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ).paddingHorizontal(AppValues.defaultPadding * 2),
          ),
          SizedBox(height: AppValues.margin_6),
          SizedBox(
            width: 160,
            child: CustomText(
              model.detail,
              style: ThemeService()
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
