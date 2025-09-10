import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/pages/alliance_plan/whepler/alliance_biz_helper.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/time/time_intl_util.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget_cell/account_cell_widget.dart';
import '../widget_cell/alliance_item_cell_widget.dart';
import '../widget_cell/money_coin_cell_widget.dart';
import '../widget_cell/time_cell_widget.dart';
import 'direct_betting_api_model.dart';
import 'dirent_betting_model.dart';

class DirectBettingItemView extends StatelessWidget with MoneyCoinListItemMixin {
  DirectBettingItemView({super.key, required this.index, required this.model});

  // final DirectBettingModel model;
  final DirectBettingApiModel model;
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
        crossAxisAlignment: CrossAxisAlignment.center,
        expanded: AllianceWidthConfig.directBetting().expends,
        children: [
          // Expanded(
          //     child:
          //         CustomText("10/11/2011\n23:56:56", style: ThemeService().textTheme.labelMedium)),
          //统计
          Align(
              alignment: Alignment.center,
              child: AllianceItemCellWidget(
                  TimeIntlUtil.getTimeYMD(time: model.time, secondUnit: true))
              // TimeCellWidget(
              //   time: model.time,
              //   secondUnit: true,
              //   showHms: false,
              //   style: ThemeService().textTheme.labelLarge?.copyWith(
              //     fontWeight: FontWeight.w500,
              //   ),
              // )
              ),

          //账号
          Center(
            child: AccountCellWidget(username: model.username, vip: model.vip),
          ),

          //有效投注
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MoneyCoinCellWidget(
                  money: model.validBetAmount,
                  coinBean: getCoinBean(model.currencyId),
                ),
                // SizedBox(height: 2),
                // CustomText("${model.betCount}", style: ThemeService().textTheme.bodySmall),
              ],
            ),
          ),
          //总输赢
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MoneyCoinCellWidget(
                    money: getMoneyWithSign(model.netAmount),
                    coinBean: getCoinBean(model.currencyId),
                    color: getMoneyColor(model.netAmount)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
