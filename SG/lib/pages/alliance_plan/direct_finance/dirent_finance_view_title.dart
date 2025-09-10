import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/pages/alliance_plan/widget/custom_alliance_sort_widget.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/function.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget_cell/alliance_item_cell_widget.dart';
import '../wmodel/alliance_sort_model.dart';

class DirectFinanceTitleView extends StatelessWidget {
  DirectFinanceTitleView({super.key, this.onAnyOneSortCallback});

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
        // expanded: const [3,3,3,3,3,3],
        expanded: AllianceWidthConfig.directFinance().expends,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
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
          Center(child: AllianceItemCellWidget(S.current.back_list_player_text, isTitle: true)),
          //存款金额
          Center(
              child: CustomAllianceSortWidget(
                  sort: false,
                  label: S.current.random_text_107,
                  // subLabel: S.current.random_text_108,
                  callback: (data) {
                    if (onAnyOneSortCallback != null) {
                      sortModel.deposit = data;
                      onAnyOneSortCallback!(null, null, sortModel);
                    }
                  })),
          //取款金额
          Center(
              child: CustomAllianceSortWidget(
                  sort: false,
                  label: S.current.random_text_109,
                  // subLabel: S.current.random_text_108,
                  callback: (data) {
                    if (onAnyOneSortCallback != null) {
                      sortModel.withdraw = data;
                      onAnyOneSortCallback!(null, null, sortModel);
                    }
                  })),
          //存取款差额 改为 现金利润
          Center(
              child: CustomAllianceSortWidget(
                  sort: false,
                  label: S.current.random_text_524,
                  // subLabel: S.current.random_text_111,
                  callback: (data) {
                    if (onAnyOneSortCallback != null) {
                      sortModel.depositAndWithdrawDiff = data;
                      onAnyOneSortCallback!(null, null, sortModel);
                    }
                  })),
          Center(child: AllianceItemCellWidget(S.current.game_detail_yue, isTitle: true)),
        ],
      ),
    );
  }
}
