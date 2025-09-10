import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/pages/alliance_plan/alliance_plan_logic.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/time/time_intl_util.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../whepler/alliance_biz_helper.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget_cell/account_cell_widget.dart';
import '../widget_cell/alliance_item_cell_widget.dart';
import '../../../widget/cell/custom_tooltip_cell_widget.dart';
import '../widget_cell/money_coin_cell_widget.dart';
import '../widget_cell/time_cell_widget.dart';
import 'my_commission_api_model.dart';
import 'my_commission_model.dart';

///联盟计划-tab-我的佣金界面
class MyCommissionItemView extends StatelessWidget with MoneyCoinListItemMixin {
  MyCommissionItemView({super.key, required this.model, required this.index, this.onClickDetail});

  // final MyCommissionModel model;
  final MyCommissionApiModel model;
  final int index;

  final void Function(MyCommissionApiModel model)? onClickDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      color: index % 2 == 0
          ? ThemeService().colorScheme.surfaceVariant
          : ThemeService().theme.scaffoldBackgroundColor,
      height: 54,
      child: CustomRowExpandedWidget(
        // expanded: const [2, 2, 3, 2, 3, 1],
        expanded: AllianceWidthConfig.myCommission().expends,
        children: [
          //结算时间
          // Align(alignment: Alignment.center, child: TimeCellWidget(time: model.sendTime)),
          Align(
              alignment: Alignment.center,
              child: AllianceItemCellWidget(
                  TimeIntlUtil.getTimeYMD(time: model.sendTime, secondUnit: true, addHms: true))
              // AllianceItemCellWidget(
              //     AllianceBizHelper.getTimeFormatOneLines(model.sendTime, secondUnit: true)),
              ),
          //类型
          Center(
            child: AllianceItemCellWidget(getTypeName()),
            // AllianceItemCellWidget("原创游戏,捕鱼"),
            // AllianceItemCellWidget("TTrò chơi nguyên bản,Bắn cá"),//测试多语言

            // AllianceTooltipCellWidget(
            //   content: getTypeName(),
            //   // content: "体育正好体育订单",
            //   style: ThemeService().textTheme.labelLarge?.copyWith(
            //         fontSize: 14,
            //
            //         fontWeight: FontWeight.w500,
            //       ),
            // ),
          ),
          //业绩
          Center(
            child: MoneyCoinCellWidget(
              money: model.validBetAmountTotal,
              coinBean: getCoinBean(model.currencyId),
            ),
          ),
          //贡献人数
          Center(child: AllianceItemCellWidget("${model.subUserCount}")),
          //佣金
          Center(
            child: MoneyCoinCellWidget(
              money: model.commissionAmountTotal,
              coinBean: getCoinBean(model.currencyId),
              // money: "0.10",
              // coinBean: getCoinBean("708"),
            ),
          ),
          //详情
          InkWell(
            onTap: () {
              if (onClickDetail != null) {
                onClickDetail!.call(model);
              }
            },
            child: Align(
              alignment: Alignment.center,
              child: CustomText(S.current.random_text_126,
                  style: ThemeService().textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      )),
            ),
          ),
        ],
      ),
    );
  }

  ///根据网络接口的数据来获取 类型名
  ///优先读取model的modelName,   为空， 则取检索；
  String getTypeName() {
    // if (model.modelName.isNotEmpty) {
    //   return model.modelName;
    // } else {
    //   try {
    //     var typeModel = AlliancePlanLogic.of()
    //         .selectTypeListObs
    //         .firstWhereOrNull((element) => element.data == model.modelId);
    //     return typeModel?.label ?? "--";
    //   } catch (e) {
    //     return "--";
    //   }
    // }

    try {
      var typeModel = AlliancePlanLogic.of()
          .selectTypeListObs
          .firstWhereOrNull((element) => element.data == model.modelId);
      return typeModel?.label ?? "--";
    } catch (e) {
      return "--";
    }
  }
}
