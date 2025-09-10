import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/personal_center/vip/widgets/vip_FanshuiList_view.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/money_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/utils/time/time_utils.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_empty_widget.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image_placeholder.dart';
import 'package:flutter_bet/widget/row/custom_row_expanded_widget.dart';

import '../../../../utils/time/time_format.dart';
import 'logic.dart';
import 'package:get/get.dart';

class VipLingQuFanshuiPage extends BaseView<VipLingQuFanshuiLogic> {
  VipLingQuFanshuiPage({super.key}); // 创建一个GlobalKey
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: S.current.vip_commission_history,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody

    return GetBuilder<VipLingQuFanshuiLogic>(
        id: "vip_fanshui_sum",
        builder: (controller) {
          return Container(
            decoration: BoxDecoration(
                color: ThemeService().theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(4)),
            child: <Widget>[
              fanshuiListView(),
              if (controller.sumDataList.isEmpty)
                const CustomEmptyWidget().paddingTop(AppValues.defaultPadding * 2),
              lingquButton(context),
            ]
                .toColumn(mainAxisAlignment: MainAxisAlignment.start)
                .paddingAll(AppValues.defaultPadding),
          );
        });
  }

  Widget fanshuiListView() {
    List titleList = [
      S.current.random_text_560,
      S.current.random_text_128,
      S.current.vault_amount,
      S.current.detailscopy2
    ];

    return ListView.builder(
            itemCount: controller.sumDataList.length + 1,
            itemBuilder: (context, index) {
              final bgColor = index % 2 == 1
                  ? ThemeService().theme.colorScheme.surfaceVariant
                  : ThemeService().theme.scaffoldBackgroundColor;
              return index == 0
                  ? Container(
                      color: bgColor,
                      child: CustomRowExpandedWidget(
                        expanded: [2, 3, 4, 3],
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
                      ).tight(height: 54),
                    )
                  : Container(
                      color: bgColor,
                      child: CustomRowExpandedWidget(
                        expanded: [2, 3, 4, 3],
                        children: [
                          Center(
                            child: Image.network(
                                    "${AppValues.defaultBranch.asset_url}/currency/${controller.sumDataList[index - 1].currencyId}.webp")
                                .tightSize(14),
                          ),
                          Center(
                            child: CustomText(
                              controller.getCategory(controller.sumDataList[index - 1].gameType),
                              style: ThemeService().textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: ThemeService().theme.colorScheme.onTertiary),
                            ),
                          ),
                          Center(
                            child: <Widget>[
                              CustomText(
                                MoneyUtil.toCoinAmountFormat(
                                        controller.sumDataList[index - 1].currencyId,
                                        controller.sumDataList[index - 1].validBetAmount) +
                                    " ",
                                style: ThemeService().textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: ThemeService().theme.colorScheme.onTertiary),
                              ),
                              Image.network(
                                      "${AppValues.defaultBranch.asset_url}/currency/${controller.sumDataList[index - 1].currencyId}.webp")
                                  .tightSize(14)
                            ].toRow(mainAxisAlignment: MainAxisAlignment.center),
                          ),
                          Center(
                            child: CustomText(
                              S.current.random_text_126,
                              style: ThemeService().textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: ThemeService().theme.colorScheme.onTertiary),
                            ).onTap(() {
                              controller.getFanshuiDetailsList(
                                  context, controller.sumDataList[index - 1]);
                            }),
                          ),
                        ],
                      ).tight(height: 54),
                    );
            })
        .tight(
            height: 54 * (controller.sumDataList.length + 1) > Get.height * 0.75
                ? Get.height * 0.75
                : 54 * (controller.sumDataList.length + 1));
  }

  lingquButton(context) {
    return CustomButton(
      backgroundColor: controller.sumDataList.isEmpty
          ? Color(0xff44883E)
          : ThemeService().theme.colorScheme.primaryContainer,
      title: S.current.random_text_939copy2,
      textStyle: ThemeService().theme.textTheme.bodyMedium!.copyWith(
          color: controller.sumDataList.isEmpty
              ? Color(0xff192A25)
              : ThemeService().colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600),
      alignment: const Alignment(0, 0),
      onTap: () {
        if (controller.sumDataList.isEmpty) {
          return;
        }
        controller.receiveFanshui(context);
      },
    )
        .clipRRect(all: AppValues.smallRadius)
        .height(44)
        .constrained(minWidth: 80)
        .paddingTop(AppValues.defaultPadding * 2);
  }
}
