import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';

import '../../../../services/theme/theme_service.dart';
import '../../../utils/widget_util.dart';
import '../../../widget/betting_list/logic.dart';
import '../../betting/casino/betting_casino_state.dart';
import '../../betting/sport/betting_sport_state.dart';

class FrontCompetitionView extends StatelessWidget {
  List<CompetitionBean> listData;

  FrontCompetitionView({
    super.key,
    required this.listData,
    this.isNeverScrollable = true,
  });

  final bool isNeverScrollable;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppValues.margin_12),
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: isNeverScrollable
              ? const NeverScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          itemCount: listData.length + 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildBetTitle();
            } else if (index == listData.length + 1) {
              return const SizedBox(
                height: AppValues.margin_30,
              );
            } else {
              return _buildBetListItem(index, listData[index - 1]);
            }
          }),
    );
  }
}

Widget _buildBetTitle() {
  return Column(
    children: [
      SizedBox(height: AppValues.margin_12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: AppValues.defaultPadding,
              ),
              CustomIcon(
                asset: 'assets/images/bet_slip/ic_competition_icon_one.webp',
                size: 14,
              ),
              SizedBox(
                width: 4,
              ),
              CustomText('' + S.current.random_text_280)
            ],
          ),
          Row(
            children: [
              CustomIcon(
                asset: 'assets/images/bet_slip/ic_competition_icon_two.webp',
                size: 14,
              ),
              SizedBox(
                width: 4,
              ),
              CustomText(S.current.random_text_281),
              SizedBox(
                width: AppValues.defaultPadding,
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: AppValues.defaultMargin),
      _buiildLine(),
      SizedBox(
        height: AppValues.defaultMargin,
      ),
      Container(
        decoration: BoxDecoration(
            color: ThemeService().theme.colorScheme.background,
            borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.only(left: 13, right: 13, bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(S.current.random_text_282),
            Row(
              children: [
                CustomText(S.current.back_list_player_text),
              ],
            ),
            CustomText(S.current.statistics_title_total_text),
            CustomText(S.current.transactions_other_bonus),
          ],
        ),
      ),
    ],
  );
}

Widget _buildBetListItem(int index, CompetitionBean data) {
  return Container(
    height: 54,
    padding: EdgeInsets.only(left: 18, right: 15),
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
        color:
            index % 2 == 1 ? ThemeService().theme.colorScheme.surfaceVariant : Colors.transparent,
        borderRadius: BorderRadius.circular(5)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(children: [
          Visibility(
            visible: index < 4,
            child: Image.asset(
              data.icon!,
              height: 17,
              width: 20,
            ),
          ),
          Visibility(
            visible: index > 3,
            child: CustomText(
              '${index}th',
              style: TextStyle(color: AppThemes.betSlipItemTextColor),
            ),
          ),
        ]),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            CustomIcon(
              asset: 'assets/images/bet_slip/ic_yingshen.webp',
              size: 14,
            ),
            SizedBox(
              width: 3,
            ),
            CustomText(
              data.name!,
              style: TextStyle(color: AppThemes.betSlipItemTextColor),
            ),
          ],
        ),
        Row(
          children: [
            CustomText(
              data.money!,
              style: TextStyle(fontSize: 14, color: AppThemes.betSlipItemTextColor),
            ),
            Image.asset(
              data.moneyIcon!,
              height: 14,
              width: 14,
            ),
          ],
        ),
        CustomText(
          data.bonusMoney!,
          style: TextStyle(color: AppThemes.betSlipItemTextColor),
        ),
      ],
    ),
  );
}

Widget _buiildLine() {
  return Container(
    height: 2,
    width: double.infinity,
    color: ThemeService().theme.colorScheme.tertiary,
  );
}
