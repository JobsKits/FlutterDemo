import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';

import '../../../../services/theme/theme_service.dart';
import '../../../utils/widget_util.dart';
import '../../betting/casino/betting_casino_state.dart';
import '../../betting/sport/betting_sport_state.dart';

class FrontSportCompetitionView extends StatelessWidget {
  List<SportBetBean> listData;

  FrontSportCompetitionView({super.key, required this.listData, this.isNeverScrollable = true});

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
  return Container(
    height: 54,
    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
    decoration: BoxDecoration(
        color: ThemeService().theme.colorScheme.background,
        borderRadius: BorderRadius.circular(20)),
    // margin: const EdgeInsets.only(left: 13, right: 13, bottom: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(S.current.random_text_286),
        CustomText(S.current.random_text_220),
      ],
    ),
  );
}

Widget _buildBetListItem(int index, SportBetBean data) {
  return Container(
    height: 54,
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
        color:
            index % 2 == 1 ? ThemeService().theme.colorScheme.surfaceVariant : Colors.transparent,
        borderRadius: BorderRadius.circular(5)),
    child: Row(
      children: [
        SizedBox(
          width: 13,
        ),
        CustomIcon(asset: 'assets/images/bet_slip/ic_bet_list_icon.webp'),
        SizedBox(
          width: 7,
        ),
        CustomText(data.betTitle!),
        Expanded(child: Container()),
        CustomText(
          data.money!,
          style: TextStyle(color: AppThemes.betSlipItemTextColor),
        ),
        Image.asset(
          'assets/images/bet_slip/ic_eth_bet_icon.webp',
          height: 18,
          width: 18,
        ),
        SizedBox(
          width: 13,
        ),
      ],
    ),
  );
}
