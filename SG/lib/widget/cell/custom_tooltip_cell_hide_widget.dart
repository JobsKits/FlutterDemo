import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../../services/theme/theme_service.dart';
import '../custom_icon.dart';
import '../custom_text.dart';
import 'custom_tooltip_hint_widget.dart';

///玩家隐藏 显示组件
class CustomTooltipCellHideWidget extends StatelessWidget {
  const CustomTooltipCellHideWidget({
    super.key,
    required this.content,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    return CustomTooltipHintWidget(
      tipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      contentWidget: Row(
        children: [
          const CustomIcon(asset: 'assets/images/bet_slip/ic_yingshen.webp', size: 14),
          const SizedBox(width: 4),
          CustomText(
            content,
            style: ThemeService().textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
          )
        ],
      ),
      contentTip: S.current.random_text_1196,
      fontSize: 12,
    );
  }
}
