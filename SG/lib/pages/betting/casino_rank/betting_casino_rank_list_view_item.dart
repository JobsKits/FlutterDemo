import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../model/yulecheng/big_wins_model.dart';
import '../../../services/branch/branch_service.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../../../widget/cell/custom_tooltip_cell_widget.dart';
import '../../alliance_plan/widget_cell/money_coin_cell_widget.dart';
import '../common_model/betting_record_api_model.dart';

///娱乐城列表item。 我的投注、所有投注、风云榜
class BettingCasinoListItemView extends StatelessWidget with MoneyCoinListItemMixin {
  BettingCasinoListItemView({super.key, required this.index, required this.model});

  final int index;
  final BettingRecordApiModel model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => logic.onItemClick(context, data),
      child: Container(
        height: 54,
        padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: index % 2 == 0
                ? ThemeService().theme.colorScheme.surfaceVariant
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: [
            // CustomAssetIcon(
            //   name: "assets/images/bet_slip/ic_betting_casino_game.webp",
            //   size: 14,
            // ),
            CustomNetWorkImage(
              width: 13,
              height: 13,
              imageUrl: "${BranchService().current.asset_url}${model.icon}",
              errorWidget: const CustomAssetIcon(
                name: 'assets/images/network_image/ic_network_image_error.webp',
                size: 13,
                color: AppThemes.iconColor,
              ),
            ),
            SizedBox(width: 4),
            CustomTooltipCellWidget(
                content: model.gameName ?? "",
                // content: "时代峰峻阿奎罗肌肤垃集发减啡得到的",
                // content: "12345678901234567890",
                maxLength: 10,
                tipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                style: ThemeService().textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )),
            Spacer(),
            //支付额
            MoneyCoinCellWidget(
              money: model.payAmount,
              // money: "-123456.12345678",
              maxLength: 15,
              colorSwitch: true,
              colorSwitchValues: const [
                MoneyCoinCellWidget.green,
                MoneyCoinCellWidget.gray,
                MoneyCoinCellWidget.gray
              ],
              fontSize: 14,
              coinSize: 14,
              marginSpace: AppValues.margin_6,
              coinBean: getCoinBean(model.currencyId),
            ),
          ],
        ),
      ),
    );
  }
}
