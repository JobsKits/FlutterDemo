import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/sport/custom_sport_expand/custom_sport_expand.dart';

class SetupKYCExpand extends StatelessWidget {
  final List<Widget> children;
  final bool isInitExpanded;
  final String title;

  const SetupKYCExpand(
      {super.key,
      required this.children,
      required this.isInitExpanded,
      required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomSportExpand(
      padding: const EdgeInsets.only(top: AppValues.defaultPadding),
      title: Row(
        children:  [
          CustomText(
            title,
            textColorStyle: CustomTextColorStyle.normal,
          ),
        ],
      ),
      titleMargin:
          const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding)
              .copyWith(bottom: AppValues.defaultPadding),
      decoration: BoxDecoration(
          color: ThemeService().colorScheme.tertiary,
          borderRadius: BorderRadius.circular(AppValues.smallPadding)),
      trailing: const CustomIcon(
        asset: 'assets/images/setup/ic_left_arrow.png',
      ),
      isExpanded: isInitExpanded,
      childrenDecoration: BoxDecoration(
        color: ThemeService().colorScheme.surfaceVariant,
      ),
      children: children,
    );
  }
}
