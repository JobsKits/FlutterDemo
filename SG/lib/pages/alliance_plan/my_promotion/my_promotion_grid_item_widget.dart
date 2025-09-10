import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/widget/custom_text.dart';

import '../../../model/wallet/CurrencyBean.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../widget_cell/money_coin_cell_widget.dart';
import 'my_promotion_view_card_model.dart';

///我的推广， 佣金、业绩、直属投注 的 gridview  item
class MyPromotionGridItemWidget extends StatelessWidget with MoneyCoinListItemMixin {
  MyPromotionGridItemWidget({super.key, required this.model, this.coinBean});

  final MyPromotionCardItemModel model;
  final CurrencyBean? coinBean;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeService().colorScheme.surface, // 设置背景色
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.only(
        // left: AppValues.defaultPadding,
        // right: AppValues.defaultPadding,
        left: AppValues.largePadding,
        right: AppValues.largePadding,
        top: AppValues.padding_16,
        bottom: AppValues.padding_16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            model.label,
            // "${model.label}${model.label}",
            style: ThemeService()
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          // SizedBox(height: AppValues.halfMargin),
          // CustomText(
          //   model.content,
          //   style: ThemeService().textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
          // ),
          Row(
            children: [
              //显示人数、金额
              Stack(
                children: [
                  Offstage(
                    offstage: model.isMoneyWithCoin(),
                    child: CustomText(model.content,
                        style: ThemeService().textTheme.labelMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: model.colorType?.color,
                            )),
                  ),
                  Offstage(
                    offstage: !model.isMoneyWithCoin(),
                    child: MoneyCoinCellWidget(
                      money: model.content,
                      // money: "-1",
                      // money: "5.0010",
                      coinBean: coinBean,
                      colorSwitch: model.colorType == ColorType.colorSwitch,
                      maxLength: 14,
                      fontSize: 14,
                      coinSize: 14,
                    ),
                  ),
                ],
              ),
              //显示233.00 /23人
              Visibility(
                visible: model.isShowContentSub(),
                child: CustomText(model.contentSub ?? "",
                    style: ThemeService().textTheme.labelMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: model.colorType?.color,
                        )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
