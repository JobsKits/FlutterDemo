import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/model/yulecheng/casino_record_model.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';

import '../../../../services/theme/theme_service.dart';

class FrontCasinoCompetitionView extends StatelessWidget {
  List<CasinoRecordModel> listData;

  FrontCasinoCompetitionView({super.key, required this.listData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppValues.margin_12),
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
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
  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Container(
      decoration: BoxDecoration(
          color: ThemeService().theme.colorScheme.background,
          borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(left: 13, right: 13, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(S.current.home_game),
          CustomText(S.current.random_text_220),
        ],
      ),
    ),
  );
}

Widget _buildBetListItem(int index, CasinoRecordModel data) {
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
        // CustomIcon(asset: data.icon!),
        SizedBox(
          width: 7,
        ),
        CustomText(data.gameName),
        Expanded(child: Container()),
        CustomText(
          data.netAmount,
          style: TextStyle(
              color: double.parse(data.netAmount) > 0
                  ? AppThemes.chatRoomButtonColor
                  : AppThemes.betSlipItemTextColor),
        ),
        SizedBox(
          width: 7,
        ),
        CustomNetWorkImage(
          imageUrl: '${AppValues.defaultBranch.asset_url}/currency/${data.currencyId}.webp',
          width: 14,
          height: 14,
        ),
        SizedBox(
          width: 13,
        ),
      ],
    ),
  );
}
