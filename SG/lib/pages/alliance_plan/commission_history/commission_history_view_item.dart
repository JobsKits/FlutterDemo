import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/pages/alliance_plan/whepler/alliance_biz_helper.dart';

import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/cell/custom_tooltip_hint_widget.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../../../widget/cell/custom_tooltip_cell_widget.dart';
import '../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget_cell/money_coin_cell_widget.dart';
import '../widget_cell/time_cell_widget.dart';
import 'commission_history_api_model.dart';

class CommissionHistoryItemView extends StatelessWidget with MoneyCoinListItemMixin {
  CommissionHistoryItemView({super.key, required this.index, required this.model});

  // final CommissionHistoryModel model;
  final CommissionHistoryApiModel model;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        // horizontal: AppValues.halfPadding,
        vertical: AppValues.defaultPadding,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: index % 2 == 0
            ? ThemeService().colorScheme.surfaceVariant
            : ThemeService().theme.scaffoldBackgroundColor,
      ),
      child: CustomRowExpandedWidget(
        // mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        expanded: AllianceWidthConfig.history().expends,
        children: [
          //类型
          Center(
            child: CustomText(
              model.cashTypeName ?? "",
              style: ThemeService().textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          //金额
          Center(
            child: MoneyCoinCellWidget(
              money: model.amount,
              // money: "123456781234.12",
              coinBean: getCoinBean(model.currencyId),
              maxLength: 15,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   mainAxisSize: MainAxisSize.max,
            //   children: [
            //     CustomText(
            //       model.amount ?? "",
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       style:
            //       ThemeService().textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            //     ),
            //     SizedBox(width: AppValues.margin_2),
            //     CustomAssetIcon(
            //       name: "assets/images/coin_icon/eth_ic.png",
            //       size: 15,
            //     ),
            //   ],
            // ),
          ),

          //时间
          Center(
            child: TimeCellWidget(
              time: model.applyAt,
              style: ThemeService().textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: "Proxima Nova",
                  ),
            ),
          ),
          // Expanded(
          //   child: Center(
          //     // alignment: Alignment.centerLeft,
          //     child: Column(
          //       mainAxisSize: MainAxisSize.max,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         CustomText(AllianceBizHelper.getTimeFormatTwoLines(model.applyAt, true),
          //             style: ThemeService().textTheme.bodySmall),
          //         CustomText(AllianceBizHelper.getTimeFormatTwoLines(model.applyAt, false),
          //             style: ThemeService().textTheme.bodySmall),
          //       ],
          //     ),
          //   ),
          // ),
          //订单
          Container(
            // padding: EdgeInsets.symmetric(vertical: AppValues.defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTooltipCellWidget(
                  content: model.billNo ?? "",
                  maxLength: 30,
                  fontSize: 14,
                  padding: EdgeInsets.symmetric(vertical: AppValues.halfPadding),
                  style: ThemeService().textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: "Proxima Nova",
                      ),
                ),
                CustomTooltipHintWidget(
                  contentTip: S.current.random_text_1221,
                  contentBack: model.billNo,
                  tipPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  style: ThemeService().textTheme.labelMedium?.copyWith(
                        // color: const Color(0xFF13212D).withOpacity(0.5),
                        color: ThemeService().colorScheme.tertiary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                  onTriggered: (data) {
                    Clipboard.setData(ClipboardData(text: data));
                  },
                  contentWidget: const Padding(
                    // padding: EdgeInsets.all(AppValues.smallPadding),
                    padding: EdgeInsets.all(0),
                    child: CustomAssetIcon(
                        name: "assets/images/alliance/ic_alliance_copy.webp", size: 12),
                  ),
                ),
                // InkWell(
                //   onTap: () => onClickCopy(model.billNo),
                //   child: const Padding(
                //     padding: EdgeInsets.all(AppValues.smallPadding),
                //     child: CustomAssetIcon(
                //         name: "assets/images/alliance/ic_alliance_copy.webp", size: 12),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
