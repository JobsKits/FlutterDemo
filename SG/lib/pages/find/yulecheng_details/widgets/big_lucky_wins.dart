import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/model/wallet/CurrencyBean.dart';
import 'package:flutter_bet/model/yulecheng/big_wins_model.dart';
import 'package:flutter_bet/pages/personal_center/transactions/detail/widgets/text.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/state.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

/// 大赢家/幸运赢家

class BigLuckyWins extends StatelessWidget {
  BigLuckyWins({super.key, required this.bigWinsInfos});

  final List<BigWinsModel> bigWinsInfos;

  final double height = 53;
  final List<double> widths = [64, LangUtil().isZhCn() ? 98 : 120, 152, 129, 92, 145];

  final textStyle = ThemeService()
      .theme
      .textTheme
      .bodyMedium
      ?.copyWith(color: CustomTextColorStyle.secondary.value, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    final maxLength = bigWinsInfos.length > 3 ? 3 : bigWinsInfos.length;
    return RawScrollbar(
      thumbVisibility: false,
      thickness: 6.0,
      radius: const Radius.circular(3.0),
      thumbColor: const Color(0xFF2F4552),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: <Widget>[
          <Widget>[
            for (int index = 0; index < widths.length; index++)
              _buildTitle(index).visibility(maxLength != 0)
          ].toRow(),
          for (int index = 0; index < maxLength; index++) _buildContentRow(index, bigWinsInfos[index])
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      ),
    );
  }

  Widget _buildTitle(int index) {
    // final titles = ['Rank', 'User', 'Date', 'Bet', 'Multiplier', 'Payout'];
    final titles = [
      S.current.random_text_282,
      S.current.back_list_player_text,
      S.current.random_text_358,
      S.current.tab_bar_order,
      S.current.random_text_224,
      S.current.random_text_220
    ];
    final titleWidget = CustomText(titles[index], style: textStyle)
        .center()
        .constrained(width: widths[index], height: height);

    if (index == 0) {
      return CustomText(titles[index], style: textStyle)
          .alignLeft()
          .paddingOnly(left: AppValues.defaultMargin)
          .constrained(width: widths[index], height: height);
    }
    if (index == titles.length - 1) {
      return CustomText(titles[index], style: textStyle)
          .alignRight()
          .paddingOnly(right: AppValues.defaultMargin)
          .constrained(width: widths[index], height: height);
    }
    return titleWidget;
  }

  Widget _buildContentRow(index, BigWinsModel info) {
    final textStyleWhite = ThemeService()
        .theme
        .textTheme
        .bodyMedium
        ?.copyWith(color: CustomTextColorStyle.white.value, fontWeight: FontWeight.w500);
    final rankIcon = [
      'assets/images/bet_slip/ic_no_one.webp',
      'assets/images/bet_slip/ic_no_two.webp',
      'assets/images/bet_slip/ic_no_three.webp',
    ];

    // final bgColor = index % 2 > 0 ? Colors.transparent : ThemeService().colorScheme.tertiary;
    final bgColor = index % 2 > 0 ? Colors.transparent : const Color(0xFF233744);
    return <Widget>[
      // Rnak
      CustomAssetIcon(
        name: rankIcon[index],
        size: AppValues.iconDefaultSize,
      ).alignLeft().paddingOnly(left: AppValues.defaultMargin).width(widths[0]),

      // User
      <Widget>[
        const CustomAssetIcon(
          name: 'assets/images/bet_slip/ic_yingshen.webp',
          size: AppValues.iconSmallSize,
        ),
        const SizedBox(width: 2),
        CustomText(S.current.random_text_238,
            style: textStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.center)
          .marginAll(16)
          .width(widths[1])
          .visibility(info.isHidden),
      CustomText(info.username, style: textStyleWhite, maxLines: 1, overflow: TextOverflow.ellipsis)
          .center()
          .width(widths[1])
          .visibility(!info.isHidden),

      // Date
      CustomText(info.timeTitle, style: textStyle).center().width(widths[2]),

      // Bet
      <Widget>[
        CustomText(info.betAmountTitle, style: textStyle, maxLines: 1, overflow: TextOverflow.clip)
            .constrained(maxWidth: 80),
        const SizedBox(width: 2),
        CustomNetWorkImage(
          imageUrl: info.coinImgUrl,
          width: AppValues.iconSmallSize,
          height: AppValues.iconSmallSize,
        )
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.center)
          .marginAll(16)
          .constrained(width: widths[3]),

      // Multipller
      CustomText(info.multipller, style: textStyle).center().width(widths[4]),

      // Payout
      <Widget>[
        CustomText(info.payout, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(width: 2),
        CustomNetWorkImage(
          imageUrl: info.coinImgUrl,
          width: AppValues.iconSmallSize,
          height: AppValues.iconSmallSize,
        ),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.end)
          .marginOnly(right: AppValues.defaultMargin)
          .width(widths[5])
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.start)
        .height(height)
        .backgroundColor(bgColor)
        .clipRRect(all: 5);
  }
}
