import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/pages/alliance_plan/widget/custom_select_widget.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';

import '../../../widget/custom_icon.dart';
import '../../../widget/custom_text.dart';

class BetListBar extends StatelessWidget {
  const BetListBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(S.current.sport_tabbar_mybet, style: ThemeService().textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
