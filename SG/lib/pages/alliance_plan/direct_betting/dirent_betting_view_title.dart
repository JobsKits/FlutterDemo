import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/pages/alliance_plan/widget/custom_alliance_sort_widget.dart';
import 'package:flutter_bet/widget/row/custom_row_expanded_widget.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/function.dart';
import '../../../widget/custom_text.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget_cell/alliance_item_cell_widget.dart';
import '../wmodel/alliance_sort_model.dart';

class DirectBettingTitleView extends StatelessWidget {
  DirectBettingTitleView({super.key, this.onAnyOneSortCallback});

  ///排序回调
  final ParamThreeCallback<dynamic, dynamic, AllianceSortModel>? onAnyOneSortCallback;
  final AllianceSortModel sortModel = AllianceSortModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      color: ThemeService().theme.scaffoldBackgroundColor,
      height: 50,
      child: CustomRowExpandedWidget(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        expanded: AllianceWidthConfig.directBetting().expends,
        children: [
          //统计时间
          Align(
              alignment: Alignment.center,
              child: CustomAllianceSortWidget(
                sort: false,
                label: S.current.random_text_520,
                callback: (data) {
                  if (onAnyOneSortCallback != null) {
                    sortModel.countTime = data;
                    onAnyOneSortCallback!(null, null, sortModel);
                  }
                },
              )),
          //玩家
          Center(
              child: AllianceItemCellWidget(S.current.back_list_player_text, isTitle: true)),
          //有效投注
          Center(
              child: CustomAllianceSortWidget(
                  sort: false,
                  label: S.current.random_text_51copy2,
                  // subLabel: S.current.random_text_106,
                  callback: (data) {
                    if (onAnyOneSortCallback != null) {
                      sortModel.validBet = data;
                      onAnyOneSortCallback!(null, null, sortModel);
                    }
                  })),
          //总输赢
          Center(
              child: CustomAllianceSortWidget(
                  sort: false,
                  label: S.current.random_text_523,
                  callback: (data) {
                    if (onAnyOneSortCallback != null) {
                      sortModel.totalWinOrLoss = data;
                      onAnyOneSortCallback!(null, null, sortModel);
                    }
                  })),
        ],
      ),
    );
  }
}
