import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/widgets.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget_cell/alliance_item_cell_widget.dart';

///联盟计划-tab-我的佣金界面-
class MyCommissionTitleView extends StatelessWidget {
  const MyCommissionTitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      color: ThemeService().theme.scaffoldBackgroundColor,
      height: 54,
      child: CustomRowExpandedWidget(
        // expanded: const [2, 2, 3, 2, 3, 1],
        expanded: AllianceWidthConfig.myCommission().expends,
        children: [
          Align(
              alignment: Alignment.center,
              child: AllianceItemCellWidget(S.current.random_text_127, isTitle: true)),
          Center(child: AllianceItemCellWidget(S.current.random_text_128, isTitle: true)),
          Center(child: AllianceItemCellWidget(S.current.random_text_129, isTitle: true)),
          Center(child: AllianceItemCellWidget(S.current.random_text_92, isTitle: true)),
          Center(child: AllianceItemCellWidget(S.current.alliance_commission, isTitle: true)),
          Align(
              alignment: Alignment.center,
              child: AllianceItemCellWidget(S.current.details, isTitle: true)),
          // SizedBox(width: AppValues.defaultPadding),
        ],
      ),
    );
  }
}
