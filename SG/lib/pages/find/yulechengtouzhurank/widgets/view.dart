import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/betting/casino_rank/betting_casino_race_list_view.dart';
import 'package:flutter_bet/pages/betting/common_model/betting_common_params.dart';
import 'package:flutter_bet/pages/betting/common_model/betting_race_api_model.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/string_uril.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/cell/custom_tooltip_hint_widget.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_empty_widget.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/row/custom_row_expanded_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../widget/cell/custom_tooltip_cell_widget.dart';
import '../../../alliance_plan/widget_cell/money_coin_cell_widget.dart';
import '../../../../widget/list/money_coin_list_item_mixin.dart';
import 'logic.dart';
import 'package:get/get.dart';

final GlobalKey globalKey = GlobalKey();

// TODO:待删除
class RankListCompetitionPage extends GetView<RankListCompetitionLogic>
    with MoneyCoinListItemMixin {
  RankListCompetitionPage({super.key}); // 创建一个GlobalKey
  bool firstTransparent = true;

  // 宽度数据
  List<int> rowExpandedList = [];

  final defaultStyle = ThemeService().textTheme.labelLarge
      ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500);


  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RankListCompetitionLogic>(
      id: "Rank_list_competition",
      init: RankListCompetitionLogic(),
      builder: (controller) {
        return controller.list4.isEmpty && controller.isLoading == false
            ? const CustomEmptyWidget().paddingTop(AppValues.largePadding * 5)
            : buildBody(context);
      },
    );
  }

  Widget buildBody(context) {
    final titleW1 = StringUtil.textWidth(S.current.random_text_282, defaultStyle!);
    final titleW2 = StringUtil.textWidth(S.current.back_list_player_text, defaultStyle!);
    final titleW3 = StringUtil.textWidth(S.current.statistics_title_total_text, defaultStyle!);
    final titleW4 = StringUtil.textWidth(S.current.transactions_other_bonus, defaultStyle!);

    rowExpandedList = [
      (titleW1 * 100).toInt() - 1 * 100,
      (titleW2 * 100).toInt() + 15 * 100,
      (titleW3 * 100).toInt() + 15 * 100,
      (titleW4 * 100).toInt(),
    ];

    if(LangService().isTh) {
      rowExpandedList = [
        (titleW1 * 100).toInt() - 10 * 100,
        (titleW2 * 100).toInt() + 15 * 100,
        (titleW3 * 100).toInt() - 30 * 100,
        (titleW4 * 100).toInt(),
      ];
    }

    if(LangService().isHi) {
      rowExpandedList = [
        (titleW1 * 100).toInt(),
        (titleW2 * 100).toInt() - 20 * 100,
        (titleW3 * 100).toInt() + 20 * 100,
        (titleW4 * 100).toInt(),
      ];
    }

    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.isLoading ? 10 : controller.list4.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _buildBetTitle(controller, context);
          } else if (index == controller.list4.length + 1) {
            return const SizedBox(
              height: AppValues.margin_30,
            );
          } else {
            return controller.isLoading
                ? _buildLoadingItem(index)
                : _buildBetListItem(index, controller.list4[index - 1]);
          }
        }).paddingHorizontal(AppValues.margin_12);
  }

  Widget _buildBetTitle(controller, context) {
    return Column(
      children: [
        const SizedBox(height: AppValues.margin_12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomIcon(
                  asset: 'assets/images/bet_slip/ic_competition_icon_one.webp',
                  size: 14,
                ),
                const SizedBox(
                  width: AppValues.padding_10,
                ),
                CustomText(S.current.random_text_280, maxLines: 2)
                    .constrained(maxWidth: Get.width / 2 - 30)
              ],
            ),
            const Spacer(),
            Row(
              children: [
                const CustomIcon(
                  asset: 'assets/images/bet_slip/ic_competition_icon_two.webp',
                  size: 14,
                ),
                const SizedBox(
                  width: AppValues.padding_10,
                ),
                Obx(() => CustomText(
                    "${S.current.random_text_579} ${controller.diffShowObs.value}",
                    maxLines: 2)
                    .constrained(maxWidth: Get.width / 2 - 30)
                ),
                const SizedBox(
                  width: AppValues.defaultPadding,
                ),
              ],
            ),
          ],
        ).paddingLeft(AppValues.smallPadding),
        const SizedBox(height: AppValues.defaultMargin),
        _buiildLine(),
        const SizedBox(
          height: AppValues.defaultMargin,
        ),
        Container(
          decoration: BoxDecoration(
              color: ThemeService().theme.colorScheme.background,
              borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.only(left: 5, bottom: 15),
          child: CustomRowExpandedWidget(
            expanded: rowExpandedList,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(S.current.random_text_282, style: defaultStyle),
              Center(
                child: CustomText(S.current.back_list_player_text, style: defaultStyle),
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        DialogUtils.showCustomBubbleDialog(
                          context,
                          _viewBubbleChild(),
                          LangService().isChinese||LangService().isHi
                              ? 280
                              : LangService().isTh
                                  ? 275
                                  : 325,
                          height: LangService().isChinese ? 40 : 60,
                          widgetKey: globalKey,
                        );
                      },
                      child: CustomAssetIcon(
                          key: globalKey,
                          name: "assets/images/common/ic_common_sigh_gray.webp",
                          size: 14),
                    ),
                    const SizedBox(width: AppValues.margin_4),
                    CustomText(S.current.statistics_title_total_text, style: defaultStyle),
                  ],
                ),
              ),
              Center(child: CustomText(S.current.transactions_other_bonus, style: defaultStyle)),
            ],
          ),
        ),
      ],
    );
  }

  _viewBubbleChild() {
    return Padding(
      padding: const EdgeInsets.only(left: AppValues.defaultPadding / 2),
      child: Center(
        child: CustomText(
          S.current.random_text_889,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

// Loading item
  Widget _buildLoadingItem(index) {
    final box = Container(height: AppValues.iconDefaultSize, color: const Color(0xFF8998B0));
    return <Widget>[
      const SizedBox(width: AppValues.defaultPadding),
      // 游戏类型icon
      box.width(AppValues.iconDefaultSize).clipRRect(all: AppValues.iconDefaultSize / 2.0),
      const SizedBox(width: AppValues.halfPadding),
      // 游戏名
      box.width(Get.width * 0.2 * Random().nextDouble() + Get.width * 0.1).clipRRect(all: 3),
      const Spacer(),
      // 金额
      box.width(Get.width * 0.15).clipRRect(all: 3),
      const SizedBox(width: AppValues.halfPadding),
      // 货币icon
      box.width(AppValues.iconDefaultSize).clipRRect(all: AppValues.iconDefaultSize / 2.0),
      const SizedBox(width: AppValues.defaultPadding),
    ]
        .toRow(crossAxisAlignment: CrossAxisAlignment.center)
        .height(54)
        .backgroundColor(index % 2 == (firstTransparent ? 0 : 1)
            ? Colors.transparent
            : ThemeService().colorScheme.tertiary)
        .clipRRect(all: 5);
  }

  Widget _buildBetListItem(int index, BettingRaceApiModel data) {
    double width = (Get.width - AppValues.defaultPadding * 2) / 4;

    return Container(
      height: 54,
      padding: const EdgeInsets.only(left: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color:
              index % 2 == 1 ? ThemeService().theme.colorScheme.surfaceVariant : Colors.transparent,
          borderRadius: BorderRadius.circular(5)),
      child: CustomRowExpandedWidget(
        expanded: rowExpandedList,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(children: [
            Visibility(
              visible: index < 4,
              child: SvgPicture.asset(
                "assets/svg/yulecheng_ic_no_$index.svg",
                height: index == 1 ? 17 : 21,
                width: 20,
              ),
            ),
            Visibility(
              visible: index > 3,
              child: CustomText(
                '${index}th',
                style: const TextStyle(color: AppThemes.betSlipItemTextColor),
              ),
            ),
          ]),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Visibility(
          //         visible: data.state == "2",
          //         child:
          //             const CustomIcon(asset: 'assets/images/bet_slip/ic_yingshen.webp', size: 14)),
          //     CustomTooltipCellWidget(
          //       content: data.state == "2" ? S.current.random_text_238 : data.username,
          //       maxLength: 8,
          //       fontSize: 14,
          //     ),
          //   ],
          // ).tight(width: width),

          // 玩家
          data.isHideName()
              ? CustomTooltipHintWidget(
            tipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            contentWidget: Row(
              children: [
                const CustomIcon(
                    asset: 'assets/images/bet_slip/ic_yingshen.webp', size: 14),
                const SizedBox(width: 4),
                CustomText(
                  getShowName(data),
                  style: ThemeService().textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                )
              ],
            ),
            contentTip: S.current.random_text_1196,
            fontSize: 12,
          ).width(width)
              : CustomTooltipCellWidget(
            content: getShowName(data),
            maxLength: 10,
            // fontSize: 14,
            tipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            style: ThemeService().textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ).width(width),


          //投注总额
          Center(
            child: MoneyCoinCellWidget(
              money: data.betAmount,
              maxLength: 16,
              colorSwitch: false,
              coinSize: 14,
              coinBean: getCoinBean(data.currencyId),
            ),
          ),
          //奖金 ,
          // Center(
          //   child: MoneyCoinCellWidget(
          //     money: double.parse(data.percent!).toStringAsFixed(2),
          //     maxLength: 6,
          //     colorSwitch: false,
          //     coinSize: 14,
          //     coinBean: getCoinBean(data.currencyId),
          //   ),
          // ),
          Center(
              child: CustomText("${double.parse(data.percent!).toStringAsFixed(2)}%",
                  style: defaultStyle, maxLines: 1)),
        ],
      ),
    );
  }

  String getShowName(BettingRaceApiModel model) {
    if (model.isHideName()) {
      return S.current.random_text_238;
    } else {
      return model.username ?? "--";
    }
  }

  getRate(betAmount, netAmount) {
    return (double.parse(betAmount) / double.parse(netAmount)).toStringAsFixed(2);
  }

  String getSlipString(String original) {
    String newString = "";
    if (original.length > 5) {
      newString = original.substring(0, 5);
      return "$newString...";
    }
    return original;
  }

  Widget _buiildLine() {
    return Container(
      height: 2,
      width: double.infinity,
      color: ThemeService().theme.colorScheme.tertiary,
    );
  }
}
