import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../model/yulecheng/casino_record_model.dart';
import '../../../services/branch/branch_service.dart';
import '../../../services/lang_service.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/cell/custom_tooltip_cell_widget.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../../alliance_plan/widget_cell/money_coin_cell_widget.dart';
import '../common_model/betting_common_params.dart';
import '../common_model/betting_record_api_model.dart';

class BettingCasinoMyBetListItemView extends StatelessWidget with MoneyCoinListItemMixin {
  BettingCasinoMyBetListItemView(
      {super.key, required this.index, required this.model, this.fromPage});

  final int index;
  final BettingRecordApiModel model;

  //侧边菜单-娱乐城-我的投注列表。需要添加 "投注编号"
  final BettingFromPageType? fromPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color:
              index % 2 == 1 ? ThemeService().theme.colorScheme.surfaceVariant : Colors.transparent,
          borderRadius: BorderRadius.circular(4)),
      child: CustomRowExpandedWidget(
        expanded: BettingFromPageType.isFromMainMenu(fromPage) ? const [3, 0, 2] : const [3, 2, 2],
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomNetWorkImage(
                width: 14,
                height: 14,
                imageUrl: "${BranchService().current.asset_url}${model.icon}",
                errorWidget: const CustomAssetIcon(
                  name: 'assets/images/network_image/ic_network_image_error.webp',
                  size: 14,
                  color: AppThemes.iconColor,
                ),
              ),
              SizedBox(width: 4),
              CustomTooltipCellWidget(
                content: model.gameName,
                // content: "123456789012345678901234567",
                // content: "打开是否就开始觉得很疯狂是否",
                // todo: 这里存在 显示2格 和 3格的情况， 来自主页底部才的投注列表显示2格，其他显示3格
                maxLength: LangService().isChinese
                    ? 7
                    : (BettingFromPageType.isFromMainMenu(fromPage) ?20 : 10),
                style: ThemeService().textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          //投注编号
          Offstage(
            offstage: BettingFromPageType.isFromMainMenu(fromPage),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomTooltipCellWidget(
                content: model.billNo,
                showTip: false,
                // content: "123456789012345678901234567",
                // content: "打开是否就开始觉得很疯狂是否",
                maxLength: 7,
                style: ThemeService().textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
          ),
          //支付额
          Align(
            alignment: Alignment.centerRight,
            child: MoneyCoinCellWidget(
              money: model.settleAmount,
              // money: "123.12345678",
              padding: EdgeInsets.zero,
              maxLength: 11,
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
          ),
        ],
      ),
    );
  }
}
