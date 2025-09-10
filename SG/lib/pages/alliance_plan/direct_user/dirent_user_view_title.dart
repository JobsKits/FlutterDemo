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

class DirectUserTitleView extends StatelessWidget {
  DirectUserTitleView({super.key, this.onAnyOneSortCallback});

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
        expanded: AllianceWidthConfig.directUser().expends,
        children: [
          //统计时间
          Align(
              alignment: Alignment.center,
              child: CustomAllianceSortWidget(
                sort: false,
                label: S.current.random_text_525,
                callback: (data) {
                  if (onAnyOneSortCallback != null) {
                    sortModel.countTime = data;
                    onAnyOneSortCallback!(null, null, sortModel);
                  }
                },
              )),
          Center(
              child: AllianceItemCellWidget(S.current.random_text_53, isTitle: true)),
          //是否首存
          Center(
              child: CustomAllianceSortWidget(
                sort: false,
            label: S.current.random_text_121,
            callback: (data) {
          if (onAnyOneSortCallback != null) {
            sortModel.isFirstDeposit = data;
            onAnyOneSortCallback!(null, null, sortModel);
          }
            },
          )),
          //上次登陆
          Center(
              child: CustomAllianceSortWidget(
                sort: false,
            label: S.current.random_text_122,
            callback: (data) {
          if (onAnyOneSortCallback != null) {
            sortModel.lastLogin = data;
            onAnyOneSortCallback!(null, null, sortModel);
          }
            },
          )),

          //在线状态
          Center(
              child: CustomAllianceSortWidget(
                sort: false,
            label: S.current.random_text_123,
            // subLabel: S.current.random_text_124,
            callback: (data) {
          if (onAnyOneSortCallback != null) {
            sortModel.onLine = data;
            onAnyOneSortCallback!(null, null, sortModel);
          }
            },
          )),
        ],
      ),
    );
  }
}
