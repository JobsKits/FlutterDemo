import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../../alliance_plan/whepler/alliance_biz_helper.dart';
import '../../alliance_plan/widget_cell/account_cell_widget.dart';
import '../../alliance_plan/widget_cell/alliance_item_cell_widget.dart';
import '../a_helper/activity_width_config.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../a_model/activity_common_params.dart';
import '../a_model/activity_invite_api_model.dart';

///推广活动-邀请详情item
class ActivityInviteDetailItemView extends StatelessWidget with MoneyCoinListItemMixin {
  ActivityInviteDetailItemView({super.key, required this.index, required this.model});

  final int index;
  final ActivityInviteApiModel model;

  // final void Function(ActivityInviteApiModel model)? onClickDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.halfPadding),
      color: index % 2 == 0
          ? ThemeService().colorScheme.surfaceVariant
          : ThemeService().theme.scaffoldBackgroundColor,
      height: 54,
      child: CustomRowExpandedWidget(
        // expanded: const [2, 2, 3, 2, 3, 1],
        expanded: ActivityWidthConfig.invite().expends,
        children: [
          //玩家
          Center(child: AccountCellWidget(username: model.username, showVip: false, maxLength: 9)),
          //时间
          Center(
              child: AllianceItemCellWidget(
                  AllianceBizHelper.getTimeFormatOneLines(model.registeredAt, secondUnit: true))),

          //状态
          Center(
              child: AllianceItemCellWidget(model.getStateLabel(),
                  style: ActivityInviteState.isEfficient(model.state)
                      ? const TextStyle(
                          color: AppThemes.primaryContainer,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        )
                      : const TextStyle(
                          color: Color(0xFFB1BAD3),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ))),
        ],
      ),
    );
  }

  ///根据网络接口的数据来获取 类型名
  ///优先读取model的modelName,   为空， 则取检索；
// String getTypeName() {
//   if (model.modelName.isNotEmpty) {
//     return model.modelName;
//   } else {
//     try {
//       var typeModel = AlliancePlanLogic.of()
//           .selectTypeListObs
//           .firstWhereOrNull((element) => element.data == model.modelId);
//       return typeModel?.label ?? "--";
//     } catch (e) {
//       return "--";
//     }
//   }
// }
}
