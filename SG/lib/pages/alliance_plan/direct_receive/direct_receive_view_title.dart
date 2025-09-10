import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/widgets.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/function.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget_cell/alliance_item_cell_widget.dart';
import '../wmodel/alliance_sort_model.dart';

class DirectReceiveTitleView extends StatelessWidget {
   DirectReceiveTitleView({super.key, this.onAnyOneSortCallback});

  ///排序回调
  final ParamThreeCallback<dynamic, dynamic, AllianceSortModel>? onAnyOneSortCallback;
  final AllianceSortModel sortModel = AllianceSortModel();


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      color:ThemeService().theme.scaffoldBackgroundColor,
      height: 54,
      child: CustomRowExpandedWidget(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        expanded: AllianceWidthConfig.directReceive().expends,
        children: [
          Center(child: AllianceItemCellWidget(S.current.random_text_112, isTitle: true)),
          Center(child: AllianceItemCellWidget(S.current.random_text_53, isTitle: true)),
          Center(child: AllianceItemCellWidget(S.current.random_text_113, isTitle: true)),
          Center(child: AllianceItemCellWidget(S.current.alliance_activity, isTitle: true)),
          // Expanded(
          //     child: Center(child: AllianceItemCellWidget(S.current.random_text_114, isTitle: true))),
          Center(
              // alignment: Alignment.centerRight
              child: AllianceItemCellWidget(S.current.random_text_115, isTitle: true),
              )
        ],
      ),
    );
  }
}
