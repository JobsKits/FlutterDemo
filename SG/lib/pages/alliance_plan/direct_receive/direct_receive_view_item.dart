import 'package:flutter/widgets.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget_cell/account_cell_widget.dart';
import '../widget_cell/money_coin_cell_widget.dart';
import '../widget_cell/time_cell_widget.dart';
import 'dicrect_receive_api_model.dart';

class DirectReceiveItemView extends StatelessWidget with MoneyCoinListItemMixin {
  DirectReceiveItemView({super.key, required this.model, required this.index});

  // final ReceiveDirectlyModel model;
  final DirectReceiveApiModel model;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      color: index % 2 == 0
          ? ThemeService().colorScheme.surfaceVariant
          : ThemeService().theme.scaffoldBackgroundColor,
      height: 54,
      child: CustomRowExpandedWidget(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        expanded: AllianceWidthConfig.directReceive().expends,
        children: [
          //统计时间
          Align(
              alignment: Alignment.center,
              child: TimeCellWidget(
                time: model.time,
                secondUnit: true,
                showHms: false,
                style: ThemeService().textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              )),

          //账号
          Center(child: AccountCellWidget(username: model.username, vip: model.vip)),

          //总领取
          Center(
            child: MoneyCoinCellWidget(
              money: model.totalReceive,
              coinBean: getCoinBean(model.currencyId),
            ),
          ),
          //活动
          Center(
            child: MoneyCoinCellWidget(
              money: model.giftAmount,
              coinBean: getCoinBean(model.currencyId),
            ),
          ),

          // //反水
          // Expanded(
          //   child: Center(
          //     child: MoneyCoinCellWidget(
          //       money: model.giftAmount,
          //       coinBean: getCoinBean(model.currencyId),
          //     ),
          //   ),
          // ),

          //代理佣金
          // Expanded(
          //     child: Align(
          //         child: CustomText("${model.commissionAmount}",
          //             style: ThemeService().textTheme.labelMedium),
          //         alignment: Alignment.centerRight)),
          Center(
            // alignment: Alignment.centerRight,
            child: MoneyCoinCellWidget(
              money: model.commissionAmount,
              coinBean: getCoinBean(model.currencyId),
            ),
          ),
        ],
      ),
    );
  }

// String getTimeFormat(int? time) {
//   return "${DateUtil.formatDateMs(time ?? 0, format: 'dd/MM/yyyy')}\n${DateUtil.formatDateMs(time ?? 0, format: 'HH:mm:ss')}";
// }
}
