import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/time/time_intl_util.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../whepler/Alliance_width_config.dart';
import '../whepler/alliance_biz_helper.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../widget_cell/account_cell_widget.dart';
import '../widget_cell/alliance_item_cell_widget.dart';
import '../widget_cell/money_coin_cell_widget.dart';
import '../widget_cell/time_cell_widget.dart';
import 'direct_finance_api_model.dart';
import 'dirent_finance_model.dart';

class DirectFinanceItemView extends StatelessWidget with MoneyCoinListItemMixin {
  DirectFinanceItemView({super.key, required this.index, required this.model});

  // final DirectFinanceModel model;
  final DirectFinanceApiModel model;
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
        // expanded: const [3,3,3,3,3,3],
        expanded: AllianceWidthConfig.directFinance().expends,
        children: [
          Align(
              alignment: Alignment.center,
              child: AllianceItemCellWidget(
                  TimeIntlUtil.getTimeYMD(time: model.time, secondUnit: true))
              // TimeCellWidget(
              //   time: model.time,
              //   secondUnit: true,
              //   showHms: true,
              //   twoLine: false,
              //   style: ThemeService().textTheme.labelLarge?.copyWith(
              //         fontWeight: FontWeight.w500,
              //       ),
              // )
              ),

          //账号
          Center(child: AccountCellWidget(username: model.username, vip: model.vip)),

          //存款金额 and 次数
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MoneyCoinCellWidget(
                  money: model.depositAmount,
                  coinBean: getCoinBean(model.currencyId),
                ),
                // SizedBox(height: 2),
                // CustomText("${model.depositCount}", style: ThemeService().textTheme.bodySmall),
              ],
            ),
          ),

          //取款金额 and 次数
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MoneyCoinCellWidget(
                  money: model.withdrawAmount,
                  coinBean: getCoinBean(model.currencyId),
                ),
                // SizedBox(height: 2),
                // CustomText("${model.withdrawCount}", style: ThemeService().textTheme.bodySmall),
              ],
            ),
          ),

          //存取款差额 and 当前余额
          //现金例如
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MoneyCoinCellWidget(
                  money: getMoneyWithSign(model.depositWithdrawAmount),
                  coinBean: getCoinBean(model.currencyId),
                  // color: getMoneyColor(model.depositWithdrawAmount),
                ),
                // SizedBox(height: 2),
                // MoneyCoinCellWidget(
                //   money: model.depositWithdrawAmount,
                //   coinBean: getCoinBean(model.currencyId),
                //   color: getMoneyColor(model.depositWithdrawAmount),
                // ),
              ],
            ),
          ),

          //余额
          Center(
              child: MoneyCoinCellWidget(
                  money: model.balance, coinBean: getCoinBean(model.currencyId))),
        ],
      ),
    );
  }
}
