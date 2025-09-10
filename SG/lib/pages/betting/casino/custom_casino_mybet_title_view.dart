import 'package:flutter/widgets.dart';

import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../common_model/betting_common_params.dart';

/// 娱乐城， 我的投注 所有投注 公用的title
class CustomCasinoMyBetTitleView extends StatelessWidget {
  const CustomCasinoMyBetTitleView({super.key, this.fromPage});

  //侧边菜单-娱乐城-我的投注列表。需要添加 S.current.random_text_1168
  final BettingFromPageType? fromPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
          color: ThemeService().theme.colorScheme.background,
          borderRadius: BorderRadius.circular(20)),
      // margin: const EdgeInsets.only(top: 5, left: 13, right: 13),
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: CustomRowExpandedWidget(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        expanded: BettingFromPageType.isFromMainMenu(fromPage)? const [3,0,2]: const [3,2,2],
        children: [
          CustomText(
            S.current.home_game,
            style: ThemeService().textTheme.labelLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Offstage(
            offstage: BettingFromPageType.isFromMainMenu(fromPage),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                S.current.random_text_1168,
                style: ThemeService().textTheme.labelLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: CustomText(
              S.current.random_text_220copy,
              // "输赢",
              style: ThemeService().textTheme.labelLarge?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
