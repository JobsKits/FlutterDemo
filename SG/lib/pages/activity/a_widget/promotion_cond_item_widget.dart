import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../../alliance_plan/widget_cell/money_coin_cell_widget.dart';
import '../a_model/promotion_cond_item_model.dart';

///推广界面 推广条件item
class PromotionCondItemWidget extends StatelessWidget with MoneyCoinListItemMixin {
  PromotionCondItemWidget({super.key, required this.model});

  final PromotionCondItemModel model;

  @override
  Widget build(BuildContext context) {
    //todo:[0529]后台配置有效推广人数条件有位0的数据，前台隐藏
    return Visibility(
      visible: model.isShowRow(),
      // visible: true,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppValues.halfPadding),
        padding: const EdgeInsets.only(
          left: AppValues.defaultPadding,
          right: AppValues.defaultPadding,
          top: AppValues.padding_8,
          bottom: AppValues.padding_8,
        ),
        decoration: BoxDecoration(
          color: ThemeService().colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //条件标题
            CustomText(
              model.title,
              style: ThemeService()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            //条件内容
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: model.isCoin(),
                  child: MoneyCoinCellWidget(
                    money: model.moneyOrTime,
                    marginSpace: 2,
                    showCoinName: true,
                    fontSize: 14,
                    coinSize: 13,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    style: ThemeService().textTheme.labelMedium?.copyWith(
                        fontSize: 14, fontWeight: FontWeight.w600, fontFamily: "PingFang SC"),
                    coinBean: getCoinBean(model.currencyId),
                  ),
                ),
                Visibility(
                  visible: !model.isCoin(),
                  child: CustomText(
                    "${model.moneyOrTime}${model.unit}",
                    style: ThemeService().textTheme.labelMedium?.copyWith(
                        fontSize: 14, fontWeight: FontWeight.w600, fontFamily: "PingFang SC"),
                  ),
                ),
                CustomText(
                  model.content,
                  style: ThemeService().textTheme.labelMedium?.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w600, fontFamily: "PingFang SC"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
