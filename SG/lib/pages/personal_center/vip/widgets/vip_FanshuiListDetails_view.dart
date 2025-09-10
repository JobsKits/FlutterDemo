import 'package:flutter/foundation.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/model/viplevel/vip_fanshui_detail_list.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/money_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/row/custom_row_expanded_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';

class VipFanshuiListDetail extends StatelessWidget {
  VipFanshuiListDetail({super.key, required this.callBack, required this.detailsList});
  final Function callBack;
  final List<VipFanshuiDetailListModel> detailsList;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ThemeService().theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(4)),
      child: <Widget>[
        <Widget>[
          const SizedBox(width: AppValues.extraSmallMargin), //

          SvgPicture.asset("assets/svg/vip_fanshui_details_all.svg").tightSize(16),
          const SizedBox(width: AppValues.extraSmallMargin), //
          CustomText(S.current.detailscopy2,
              style:
                  ThemeService().theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
          const Spacer(),
          const CustomIcon(
                  asset: 'assets/images/normal/ic_normal_close.png', size: AppValues.iconSize_20)
              .marginOnly(left: AppValues.defaultMargin)
              .center()
              .onTap(() {
            RouteUtil.popView();
          })
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
        fanshuiListView(),
        fanhuiButton(),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.start).paddingAll(AppValues.defaultPadding),
    );
  }

  Widget fanshuiListView() {
    List titleList = [S.current.random_text_358, S.current.random_text_979, S.current.tab_bar_order, S.current.random_text_942, S.current.vault_amount];

    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ListView.builder(
                itemCount: detailsList.length + 1,
                itemBuilder: (context, index) {
                  final bgColor = index % 2 == 1
                      ? ThemeService().theme.colorScheme.surfaceVariant
                      : ThemeService().theme.scaffoldBackgroundColor;
                  return index == 0
                      ? Container(
                          color: bgColor,
                          child: CustomRowExpandedWidget(
                            expanded: [3, 5, 5, 2, 5],
                            children: [
                              for (int i = 0; i < titleList.length; i++)
                                Center(
                                  child: CustomText(
                                    titleList[i],
                                    style: ThemeService().textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: ThemeService().theme.colorScheme.onTertiary),
                                  ),
                                ),
                            ],
                          ),
                        ).tight(height: 54)
                      : Container(
                          color: bgColor,
                          child: CustomRowExpandedWidget(
                            expanded: [3, 5, 5, 2, 5],
                            children: [
                              Center(
                                child: CustomText(
                                  detailsList[index - 1].date,
                                  style: ThemeService().textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: ThemeService().theme.colorScheme.onTertiary),
                                ),
                              ),
                              Center(
                                child: CustomText(
                                  detailsList[index - 1].platformName,
                                  style: ThemeService().textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: ThemeService().theme.colorScheme.onTertiary),
                                ),
                              ),
                              Center(
                                  child: <Widget>[
                                CustomText(
                                  MoneyUtil.toCoinAmountFormat(detailsList[index - 1].currencyId,
                                          detailsList[index - 1].validBetAmount) +
                                      " ",
                                  style: ThemeService().textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: ThemeService().theme.colorScheme.onTertiary),
                                ),
                                Image.network(
                                        "${AppValues.defaultBranch.asset_url}/currency/${detailsList[index - 1].currencyId}.webp")
                                    .tightSize(14),
                              ].toRow(mainAxisAlignment: MainAxisAlignment.center)),
                              Center(
                                child: CustomText(
                                  "${detailsList[index - 1].rate}%",
                                  style: ThemeService().textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: ThemeService().theme.colorScheme.onTertiary),
                                ),
                              ),
                              Center(
                                  child: <Widget>[
                                CustomText(
                                  MoneyUtil.toCoinAmountFormat(detailsList[index - 1].currencyId,
                                          detailsList[index - 1].rebateAmount) +
                                      " ",
                                  style: ThemeService().textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: ThemeService().theme.colorScheme.onTertiary),
                                ),
                                Image.network(
                                        "${AppValues.defaultBranch.asset_url}/currency/${detailsList[index - 1].currencyId}.webp")
                                    .tightSize(14),
                              ].toRow(mainAxisAlignment: MainAxisAlignment.center)),
                            ],
                          ).tight(height: 54),
                        );
                })
            .tight(
                width: Get.width * 1.4,
                height: 54 * (detailsList.length + 1) > Get.height * 0.6
                    ? Get.height * 0.6
                    : 54 * (detailsList.length + 1)),
      ),
    );
  }

  fanhuiButton() {
    return CustomButton(
      backgroundColor: ThemeService().theme.colorScheme.primaryContainer,
      title: S.current.random_text_766,
      textStyle: ThemeService().theme.textTheme.bodyMedium!.copyWith(
          color: ThemeService().colorScheme.onPrimaryContainer, fontWeight: FontWeight.w600),
      alignment: const Alignment(0, 0),
      onTap: () {
        RouteUtil.popView();
      },
    )
        .clipRRect(all: AppValues.smallRadius)
        .height(44)
        .constrained(minWidth: 80)
        .paddingTop(AppValues.defaultPadding);
  }
}
