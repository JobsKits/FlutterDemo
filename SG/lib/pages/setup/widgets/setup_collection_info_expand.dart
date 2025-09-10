import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/sport/custom_sport_expand/custom_sport_expand.dart';

class SetupCollectionInfoExpand extends StatelessWidget {
  final List<Widget> children;
  final bool isInitExpanded;
  final String title;
  final Widget? titleIcon;

  const SetupCollectionInfoExpand(
      {super.key,
      required this.children,
      required this.isInitExpanded,
      required this.title,
      this.titleIcon});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomSportExpand(
      padding: const EdgeInsets.only(top: AppValues.defaultPadding),
      title: Row(
        children: [
          titleIcon != null
              ? Row(
                  children: [
                    titleIcon!,
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          CustomText(
            title,
          ),
        ],
      ),
      titleMargin:
          const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding)
              .copyWith(bottom: AppValues.defaultPadding),
      decoration: BoxDecoration(
          color: ThemeService().colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(AppValues.smallPadding)),
      trailing: const CustomIcon(
        asset: 'assets/images/setup/ic_left_arrow.png',
      ),
      isExpanded: isInitExpanded,
      childrenDecoration: BoxDecoration(
        color: ThemeService().colorScheme.surfaceVariant,
      ),
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
          child: Column(
            children: children,
          ),
        )
      ],
    );
  }
}
