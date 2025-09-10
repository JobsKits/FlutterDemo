import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/alliance_plan/widget_cell/money_coin_cell_widget.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/row/custom_row_expanded_widget.dart';

import '../../../constant/app_themes.dart';
import '../../../services/lang_service.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/betting_list/logic.dart';
import '../../../widget/cell/custom_tooltip_hint_widget.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/cell/custom_tooltip_widget.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../../../widget/cell/custom_tooltip_cell_widget.dart';
import '../common_helper/betting_width_config.dart';
import '../common_model/betting_race_api_model.dart';

///娱乐城投注，竞赛列表
class BettingCasinoRaceListItemView extends StatelessWidget with MoneyCoinListItemMixin {
  BettingCasinoRaceListItemView({super.key, required this.index, required this.model});

  final int index;

  // final CompetitionBean model;
  final BettingRaceApiModel model;

  @override
  Widget build(BuildContext context) {
    return _buildItemView();
  }

  Widget _buildItemView() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: AppValues.halfPadding),
      // padding: const EdgeInsets.only(left: AppValues.defaultPadding),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color:
              index % 2 == 0 ? ThemeService().theme.colorScheme.surfaceVariant : Colors.transparent,
          borderRadius: BorderRadius.circular(4)),
      child: CustomRowExpandedWidget(
        expanded: BettingWidthConfig.race().expends,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Offstage(
                  offstage: index >= 3,
                  child: CustomAssetIcon(name: getRaceAsset(index), size: 20),
                ),
                Visibility(
                  visible: index >= 3,
                  child: CustomText(
                    '${index + 1}th',
                    style: ThemeService().textTheme.labelMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Visibility(
              //     visible: model.isHideName(),
              //     child: CustomIcon(asset: 'assets/images/bet_slip/ic_yingshen.webp', size: 14)),
              // Visibility(
              //   visible: model.isHideName(),
              //   child: SizedBox(width: 1),
              // ),
              // CustomTooltipCellWidget(
              //   content: getShowName(),
              //   maxLength: 10,
              //   fontSize: 14,
              // ),
              model.isHideName()
                  ? CustomTooltipHintWidget(
                      tipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      contentWidget: Row(
                        children: [
                          const CustomIcon(
                              asset: 'assets/images/bet_slip/ic_yingshen.webp', size: 14),
                          const SizedBox(width: 4),
                          CustomText(
                            getShowName(),
                            style: ThemeService().textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                          )
                        ],
                      ),
                      contentTip: S.current.random_text_1196,
                      fontSize: 12,
                    )
                  : CustomTooltipCellWidget(
                      content: getShowName(),
                      maxLength: 10,
                      // fontSize: 14,
                      tipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      style: ThemeService().textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                    ),
            ],
          ),
          //投注总额
          Center(
            child: MoneyCoinCellWidget(
              money: model.betAmount,
              // money: "0.12345678",
              maxLength: 15,
              colorSwitch: false,
              coinSize: 14,
              coinBean: getCoinBean(model.currencyId),//model.currencyId
            ),
          ),
          //奖金
          Center(
            child: CustomTooltipCellWidget(
              content: "${model.percent}%",
              maxLength: 7,
              fontSize: 14,
            ),
            // child: MoneyCoinCellWidget(
            //   money: model.netAmount,
            //   maxLength: 6,
            //   colorSwitch: false,
            //   coinSize: 14,
            //   coinBean: getCoinBean(model.currencyId),
            // ),
          ),
          // Center(
          //   child: CustomText(model.netAmount!,
          //       style: const TextStyle(color: AppThemes.betSlipItemTextColor)),
          // ),
        ],
      ),
    );
  }

  String getRaceAsset(int index) {
    //0\1\2
    if (index < 3) {
      return "assets/images/bet_slip/casino/ic_casino_race_${index + 1}.webp";
    } else {
      return "";
    }
  }

  String getShowName() {
    if (model.isHideName()) {
      return S.current.random_text_238;
    } else {
      return model.username ?? "--";
    }
  }
}
