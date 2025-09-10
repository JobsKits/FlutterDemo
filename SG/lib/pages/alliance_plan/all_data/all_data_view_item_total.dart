import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget_cell/alliance_item_cell_widget.dart';
import '../widget_cell/money_coin_cell_widget.dart';
import 'all_data_api_model.dart';

class AllDataTotalItemView extends StatelessWidget with MoneyCoinListItemMixin {
  AllDataTotalItemView({super.key, required this.index, required this.model});

  // final AllDataModel model;
  final AllDataApiModel model;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      color: index % 2 == 0
          ? ThemeService().colorScheme.surfaceVariant
          : ThemeService().theme.scaffoldBackgroundColor,
      height: 54,
      child: CustomRowExpandedWidget(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        expanded: AllianceWidthConfig.allData().expends,
        children: [
          //加入时间
          Align(
            alignment: Alignment.center,
            child: AllianceItemCellWidget("${model.username}",cellStyle: AllianceCellStyle.def),
            // child: MoneyCoinCellWidget(
            //   money: model.username,
            //   coinBean: getCoinBean(model.currencyId),
            // ),
          ),

          //总数
          Center(
            child: AllianceItemCellWidget("${model.totalAmount}${S.current.random_text_528}"),
            // child: MoneyCoinCellWidget(
            //   money: model.totalAmount,
            //   coinBean: getCoinBean(model.currencyId),
            // ),
          ),

          //存款
          Center(
            child: MoneyCoinCellWidget(
              money: model.depositAmount,
              coinBean: getCoinBean(model.currencyId),
            ),
          ),

          //有效投注
          Center(
            child: MoneyCoinCellWidget(
              money: model.validBetAmount,
              coinBean: getCoinBean(model.currencyId),
            ),
          ),

          //总输赢
          Center(
            // alignment: Alignment.centerRight,
            child: MoneyCoinCellWidget(
              money: getMoneyWithSign(model.netAmount),
              coinBean: getCoinBean(model.currencyId),
              color: getMoneyColor(model.netAmount),
            ),
          ),
        ],
      ),
    );
  }
}
