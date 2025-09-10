import 'package:flutter/material.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/custom_icon.dart';
import '../../../../widget/custom_text.dart';

///体育- 我的投注- 详情对话框 头部
class SportBetMineDetailDialogTitleView extends StatelessWidget {
  const SportBetMineDetailDialogTitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 12),
        const CustomIcon(
          color: AppThemes.iconColor,
          asset: "assets/images/bet_slip/ic_casino_bet_order.webp",
          size: 18,
        ),
        const SizedBox(width: 4),
        CustomText(
          S.current.tab_bar_order,
          style: ThemeService()
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        InkWell(
          onTap: () {
            RouteUtil.popView();
          },
          child: const Padding(
            padding: EdgeInsets.all(AppValues.defaultPadding),
            child: CustomIcon(
              asset: 'assets/images/normal/ic_normal_close.png',
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
