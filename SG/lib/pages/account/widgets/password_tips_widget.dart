import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';

class PassWordTipsWidget extends StatelessWidget {
  final String text;
  final bool isActive;

  const PassWordTipsWidget(
      {super.key, required this.text, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        CustomIcon(
          asset: 'assets/images/login/register_right_normal.png',
          color: isActive == true ? AppThemes.greenAccentColor : null,
        ),
        const SizedBox(
          width: AppValues.smallPadding,
        ),
        Expanded(
            child: CustomText(
          text,
          overflow: TextOverflow.ellipsis,
          style: ThemeService().theme.textTheme.bodySmall?.copyWith(fontSize: 12),
        )),
      ],
    );
  }
}
