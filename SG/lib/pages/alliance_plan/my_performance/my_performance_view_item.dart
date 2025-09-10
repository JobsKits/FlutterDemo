import 'package:flutter/widgets.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/pages/alliance_plan/whepler/alliance_biz_helper.dart';
import 'package:flutter_bet/pages/alliance_plan/widget_cell/alliance_item_cell_widget.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/time/time_intl_util.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget_cell/account_cell_widget.dart';
import '../widget_cell/money_coin_cell_widget.dart';
import '../widget_cell/time_cell_widget.dart';
import 'my_performance_api_model.dart';
import 'my_performance_model.dart';

///联盟计划-tab-我的业绩界面
class MyPerformanceItemView extends StatelessWidget with MoneyCoinListItemMixin {
  MyPerformanceItemView({super.key, required this.model, required this.index});

  // final MyPerformanceModel model;
  final MyPerformanceApiModel model;
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
        expanded: AllianceWidthConfig.myPerformance().expends,
        children: [
          //加入时间
          Align(
              alignment: Alignment.center,
              // child: TimeCellWidget(time: model.regTime, secondUnit: true),
              child:
              AllianceItemCellWidget(
                  TimeIntlUtil.getTimeYMD(time: model.regTime, secondUnit: true, addHms: true))
              // AllianceItemCellWidget(
              //     AllianceBizHelper.getTimeFormatOneLines(model.regTime, secondUnit: true)),
          ),

          //账号
          Center(child: AccountCellWidget(username: "${model.username}")),
          //下级人数
          Center(child: AllianceItemCellWidget("${model.subUserCount}")),
          //业绩
          Center(
            child: MoneyCoinCellWidget(
              money: model.validBetAmountTotal,
              coinBean: getCoinBean(model.currencyId),
              // maxLength: 10,
            ),
          ),
          //贡献佣金
          Align(
              alignment: Alignment.center,
              child: MoneyCoinCellWidget(
                money: model.contributionAmount,
                coinBean: getCoinBean(model.currencyId),
                // maxLength: 10,
                // color: AppThemes.scoreTextColor,
              )),
        ],
      ),
    );
  }
}
