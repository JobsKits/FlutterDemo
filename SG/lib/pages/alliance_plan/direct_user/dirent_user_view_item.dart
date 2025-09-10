import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../whepler/Alliance_width_config.dart';
import '../whepler/alliance_biz_helper.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../widget_cell/account_cell_widget.dart';
import '../widget_cell/alliance_item_cell_widget.dart';
import '../widget_cell/time_cell_widget.dart';
import 'direct_user_api_model.dart';
import 'dirent_user_model.dart';

class DirectUserItemView extends StatelessWidget with MoneyCoinListItemMixin {
  DirectUserItemView({super.key, required this.index, required this.model});

  // final DirectUserModel model;
  final DirectUserApiModel model;
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
        expanded: AllianceWidthConfig.directUser().expends,
        children: [
          //注册时间
          Align(
            alignment: Alignment.center,
            // child: TimeCellWidget(time: model.createdAt, secondUnit: true)),
            child: AllianceItemCellWidget(
                AllianceBizHelper.getTimeFormatOneLines(model.createdAt, secondUnit: true)),
          ),

          //账号
          Center(child: AccountCellWidget(username: model.username, vip: model.vip)),

          //是否首存
          AllianceItemCellWidget("${model.getIsFirstDeposit()}",
              // textColor:Colors.white,
              // textAlign: TextAlign.center,
              style: model.isFirstDeposit()
                  ? ThemeService().textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500)
                  : ThemeService()
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: const Color(0xFFED4163), fontWeight: FontWeight.w500)),
          //上次登陆时间
          Center(
            // child: TimeCellWidget(time: model.lastLoginAt, secondUnit: true),
            child: AllianceItemCellWidget(AllianceBizHelper.getTimeFormatOneLines(model.lastLoginAt, secondUnit: true)),
          ),

          //在线状态
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: model.isOnline() ? Color(0xFF00E701) : Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        Visibility(
                            visible: model.isOnline(),
                            child: Container(
                              height: 8,
                              width: 8,
                              child: const CustomAssetIcon(
                                name: "assets/images/alliance/ic_alliance_online.webp",
                                size: 8,
                              ),
                            )),
                      ],
                    ),
                    SizedBox(width: AppValues.margin_2),
                    CustomText("${model.getOnLineState()}",
                        style: ThemeService()
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontWeight: FontWeight.w500))
                  ],
                ),
                // SizedBox(height: AppValues.margin_2),
                // CustomText("${model.loginCount}", style: ThemeService().textTheme.bodySmall)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
