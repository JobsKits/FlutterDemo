import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/widgets.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../../alliance_plan/widget_cell/alliance_item_cell_widget.dart';
import '../a_helper/activity_width_config.dart';

//推广活动-邀请详情 title item
class ActivityInviteDetailTitleView extends StatelessWidget {
  const ActivityInviteDetailTitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.halfPadding),
      color: ThemeService().theme.scaffoldBackgroundColor,
      height: 54,
      child: CustomRowExpandedWidget(
        // expanded: const [2, 2, 3, 2, 3, 1],
        expanded: ActivityWidthConfig.invite().expends,
        children: [
          Center(child: AllianceItemCellWidget(S.current.back_list_player_text, isTitle: true)),
          Center(child: AllianceItemCellWidget(S.current.random_text_520, isTitle: true)),
          Center(child: AllianceItemCellWidget(S.current.vip_tab_turnover, isTitle: true)),
        ],
      ),
    );
  }
}
