import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/wallet/CurrencyBean.dart';
import 'package:flutter_bet/pages/notifs/children/feedback_bonus/widgets/coin_list.dart';
import 'package:flutter_bet/pages/personal_center/vault/deposit_view.dart';
import 'package:flutter_bet/pages/personal_center/vip/logic.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/utils/string_uril.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

/// 领取奖金弹窗
class VipLingQuRecord extends GetView<VipHomeLogic> {
  VipLingQuRecord(this.feedId, this.bonus, this.originalContext, {super.key});
  final BuildContext originalContext;
  final String feedId;
  final String bonus;
  List jiangJinType = [
    // S.current.sport_all,
    // S.current.random_text_603,
    // S.current.random_text_604,
    // S.current.random_text_605
  ];
  bool dailyVisible = false;
  final GlobalKey globalKey = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();

  final GlobalKey<ScalingTextState> _scalingKey = GlobalKey<ScalingTextState>();

  final GlobalKey globalKey1 = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey1 = GlobalKey<RotatingArrowState>();

  final GlobalKey<ScalingTextState> _scalingKey1 = GlobalKey<ScalingTextState>();

  final textStyle =
      ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);
  final amountColor = const Color(0xFFFF9800);

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  Widget _buildBody(context) {
    dailyVisible = controller.shouldDayilyBonusVisibility("819");

    jiangJinType = dailyVisible == true
        ? [
            S.current.sport_all,
            S.current.random_text_603,
            S.current.random_text_604,
            S.current.random_text_605
          ]
        : [S.current.sport_all, S.current.random_text_604, S.current.random_text_605];

    return <Widget>[
      _buildTransactionsTitle(),
      // const SizedBox(height: AppValues.defaultMargin),
      // CustomText("${bonus}USDT", style: ThemeService().theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
      _buildRichText(),
      const SizedBox(height: AppValues.defaultMargin),
      // _buildExchangeRate(),
      // const SizedBox(height: AppValues.defaultMargin),
      _buildBtn(context),
      const SizedBox(height: AppValues.defaultMargin),
      // CustomText(
      //   S.current.random_text_1078,
      //   style: ThemeService()
      //       .textTheme
      //       .bodySmall!
      //       .copyWith(color: Color(0xffb1bad3), fontWeight: FontWeight.w600),
      // ),
      const SizedBox(height: AppValues.halfMargin),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min)
        .marginSymmetric(horizontal: AppValues.defaultMargin)
        .backgroundColor(ThemeService().theme.scaffoldBackgroundColor)
        .clipRRect(all: AppValues.smallRadius);
  }

  /// 构建title
  Widget _buildTransactionsTitle() {
    return <Widget>[
      SvgPicture.asset("assets/svg/vip_lingqu_icon.svg").tightSize(AppValues.iconSize_18),
      const SizedBox(width: AppValues.extraSmallMargin),
      CustomText(feedId.length > 0 ? S.current.vip_tab_bouns : S.current.random_text_1120,
          style: ThemeService()
              .theme
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: AppValues.fontTileSmallSize, fontWeight: FontWeight.w600)),
      const Spacer(),
      const CustomIcon(
              asset: 'assets/images/normal/ic_normal_close.png', size: AppValues.iconSize_18)
          .marginOnly(left: AppValues.defaultMargin)
          .center()
          .onTap(() {
        controller.globalController
            .showOverlayView(isShowTopBarView: true, isShowBottomBarView: true);
        RouteUtil.popView();
      })
    ].toRow().height(36).paddingTop(AppValues.defaultPadding);
  }

  Widget _buildRichText() {
    if (feedId.length > 0) {
      if (controller.selJiangJinStringIndex == 0) {
        controller.textEditingController.text = controller.getAllAvailiableAmount();
      } else {
        controller.textEditingController.text = controller.inputJieSuanString;
      }
    } else {
      if (controller.selJiangJinStringIndex == 0) {
        controller.textEditingController.text = controller.getFengLuTotalAmount();
      } else {
        controller.textEditingController.text = controller.inputJieSuanString;
      }
    }
    return <Widget>[
      CustomText(S.current.random_text_635,
              style: ThemeService()
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: const Color(0xffb1bad3), fontWeight: FontWeight.w500))
          .tight(height: 20),
      <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              border: Border.all(
                color: const Color(0xFF2f4553), // 边框颜色
                width: 2.0, // 边框宽度
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4.0),
                bottomLeft: Radius.circular(4.0),
              )),
          child: Align(
              alignment: const Alignment(-0.9, 0),
              child: feedId.length > 0 && controller.selJiangJinStringIndex == 0
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
                      child: CustomText(controller.getAllAvailiableAmount()),
                    )
                  : Container(
                      color: Colors.black.withOpacity(0.3),
                      child: CustomText(controller.selJiangJinStringIndex == 0
                          ? globalController.currTypeSelected.value.name == "ETH" ||
                                  globalController.currTypeSelected.value.name == "BTC"
                              ? controller.removeTrailingZeros(controller.getFengLuTotalAmount())
                              : controller.getFengLuTotalAmount()
                          : controller.inputJieSuanString),
                    ) /*CupertinoSearchTextField(
                    prefixInsets: const EdgeInsets.only(left: 10),
                    // prefixIcon: const CustomAssetIcon(
                    //   name: "assets/images/top_search_ic.png",
                    //   size: 16,
                    // ),
                    suffixIcon: feedId.length > 0 && controller.selJiangJinStringIndex == 0
                        ? Icon(
                            CupertinoIcons.xmark_circle_fill,
                            color: Colors.transparent,
                          )
                        : Icon(CupertinoIcons.xmark_circle_fill),
                    prefixIcon: SizedBox(),
                    controller: controller.textEditingController,
                    // itemColor: AppThemes.secondaryIconColor,
                    placeholder: "", //feedId.length > 0 ? bonus : amount,
                    // placeholderStyle: const TextStyle(color: AppThemes.white566771, fontWeight: FontWeight.w500),
                    // placeholderStyle:
                    //     TextStyle(color: Color(0xFF2f4553), fontWeight: FontWeight.w600),
                    keyboardType: TextInputType.number,
                    decoration: BoxDecoration(
                      // color: AppThemes.widgetColorWhite,
                      // border: Border.all(color: AppThemes.whiteD5DCEB, width: 2.0),
                      // Add a border
                      borderRadius: BorderRadius.circular(4),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.3), // 阴影颜色
                      //     spreadRadius: 0, // 扩散半径
                      //     blurRadius: 2, // 模糊半径
                      //     offset: const Offset(0, 1), // 阴影偏移量
                      //   ),
                      // ],
                    ),
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppThemes.widgetColorWhite,
                        fontWeight: FontWeight.w600),
                    onChanged: (String value) {
                      controller.updateJieSuanAmount(value);
                    },
                    onSubmitted: (String value) {},
                  ),*/ /*CustomText(
              feedId.length > 0 ? bonus : amount,
            ),*/
              ),
        ).height(40).expanded(),
        if (feedId.length == 0) fengluChangeWidget().constrained(minWidth: 120),
        if (feedId.length != 0) jinJiJiangJinChangeWidget().constrained(minWidth: 106),
      ].toRow(),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  Widget _currencyWidget() {
    final selCoin = controller.selCoin;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF304554),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _startAnimation(_rotatingArrowKey);
              _startScaleAnimation(_scalingKey);
              DialogUtils.showCustomBubbleDialog(Get.context!, coinWithSearch(), 120,
                  widgetKey: globalKey, globalKey: _rotatingArrowKey, globalKeyScaling: _scalingKey,
                  // backgroundColor: ThemeService().colorScheme.tertiary,
                  onDismissCallback: () {
                controller.selectedCeachCoinString = "";
              });
            },
            child: Container(
              key: globalKey,
              decoration: BoxDecoration(
                  color: ThemeService().colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(2), bottomLeft: Radius.circular(2))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: AppValues.defaultPadding,
                  ),
                  CustomNetWorkImage(
                    imageUrl: selCoinImgUrl,
                    width: AppValues.iconSmallSize,
                    height: AppValues.iconSmallSize,
                  ),
                  const SizedBox(
                    width: AppValues.halfMargin,
                  ),
                  ScalingText(
                    key: _scalingKey,
                    text: selCoin.name ?? "...",
                    textStyle: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    width: AppValues.largeMargin,
                  ),
                  RotatingArrow(
                    key: _rotatingArrowKey,
                  ),
                ],
              ).height(40).backgroundColor(const Color(0xFF304554)),
            ),
          )
        ],
      ),
    );
  }

  Widget coinWithSearch() {
    double height = controller.coinInfos.length > 5 ? 200 : (controller.coinInfos.length + 1) * 30;

    return GetBuilder<VipHomeLogic>(
        init: VipHomeLogic(),
        id: "coin_show",
        builder: (_) {
          List<CurrencyBean> filteredList = controller.coinInfos
              .where((item) =>
                  item.name!.contains(controller.selectedCeachCoinString) ||
                  item.name!.contains(controller.selectedCeachCoinString.toUpperCase()))
              .toList();
          if (controller.selectedCeachCoinString == "") {
            filteredList = controller.coinInfos;
          }

          return <Widget>[
            _buildSearchView().paddingTop(AppValues.defaultPadding),
            BubbleCoinList(
              coinList: filteredList,
              callback: controller.changeCoinType,
              textColor: const Color(0xff2f4553),
              fontWeight: FontWeight.w500,
            ).tight(height: height).paddingLeft(AppValues.defaultPadding * 2),
          ].toColumn();
        });
  }

  Widget fengluChangeWidget() {
    final textStyle =
        ThemeService().theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w400);
    // 获取文本宽度
    double selTextWidth =
        StringUtil.textWidth(jiangJinType[controller.selJiangJinStringIndex], textStyle);
    // 弹窗文本最长宽度
    double maxTextWidth = 0;
    for (var text in jiangJinType) {
      final textWidth = StringUtil.textWidth(text, textStyle);
      if (textWidth > maxTextWidth) {
        maxTextWidth = textWidth;
      }
    }

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF304554),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(4.0),
          bottomRight: Radius.circular(4.0),
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _startAnimation(_rotatingArrowKey1);
              _startScaleAnimation(_scalingKey1);
              DialogUtils.showCustomBubbleDialog(
                Get.context!,
                _viewBubbleChild1(),
                maxTextWidth + 40,
                widgetKey: globalKey1,
                globalKey: _rotatingArrowKey1,
                globalKeyScaling: _scalingKey1,
                backgroundColor: Colors.white,
              );
            },
            child: Container(
              key: globalKey1,
              decoration: BoxDecoration(
                  color: ThemeService().colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(2), bottomLeft: Radius.circular(2))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: AppValues.defaultPadding,
                  ),
                  const SizedBox(
                    width: AppValues.halfMargin,
                  ),
                  Image.network(controller.globalController.coinUrl)
                      .tight(width: 14, height: 14)
                      .paddingRight(AppValues.halfPadding),
                  ScalingText(
                    key: _scalingKey1,
                    text: jiangJinType[controller.selJiangJinStringIndex],
                    textStyle: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: AppValues.largeMargin,
                  ),
                  RotatingArrow(
                    key: _rotatingArrowKey1,
                  ),
                ],
              ).height(40).backgroundColor(const Color(0xFF304554)),
            ),
          )
        ],
      ),
    ).width(selTextWidth + 85);
  }

  void _startScaleAnimation(GlobalKey<ScalingTextState> key) {
    key.currentState?.startAnimation();
  }

  Widget jinJiJiangJinChangeWidget() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF304554),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(4.0),
          bottomRight: Radius.circular(4.0),
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // _startAnimation(_rotatingArrowKey1);
              // _startScaleAnimation(_scalingKey1);
              // DialogUtils.showCustomBubbleDialog(
              //   Get.context!,
              //   _viewBubbleChild0(),
              //   120,
              //   widgetKey: globalKey1,
              //   globalKey: _rotatingArrowKey1,
              //   globalKeyScaling: _scalingKey1,
              //   backgroundColor: Colors.white,
              // );
            },
            child: Container(
              key: globalKey1,
              decoration: BoxDecoration(
                  color: ThemeService().colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(2), bottomLeft: Radius.circular(2))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: AppValues.defaultPadding,
                  ),
                  // const SizedBox(
                  //   width: AppValues.halfMargin,
                  // ),
                  Image.network(controller.globalController.coinUrl)
                      .tight(width: 14, height: 14)
                      .paddingRight(AppValues.halfPadding),
                  ScalingText(
                    key: _scalingKey1,
                    text: S.current.vip_tab_bouns,
                    textStyle: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: AppValues.defaultPadding,
                  ),
                  // RotatingArrow(
                  //   key: _rotatingArrowKey1,
                  // ),
                ],
              ).height(40).backgroundColor(const Color(0xFF304554)),
            ),
          )
        ],
      ),
    );
  }

// 弹窗出来的币种选择

// 弹窗出来的vip等级选择
  _viewBubbleChild0() {
    return Container(
      height: controller.availiableList.length > 5 ? 170 : 38,
      child: <Widget>[
        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const SizedBox(
                    height: 0,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                      controller.onJiangJinTypeChanged(
                          index,
                          feedId.length > 0
                              ? "jinji"
                              : "jiangjin"); // controller.state.chooseType.value= betSlipTypeList[index];
                    },
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.network(controller.globalController.coinUrl)
                            .tight(width: 14, height: 14)
                            .paddingRight(AppValues.defaultPadding),
                        CustomText(S.current.vip_tab_bouns,
                            style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500, color: const Color(0xff2f4553))),
                      ],
                    ),
                  ).height(33),
                  const SizedBox(
                    height: 0,
                  ),
                ],
              );
            }).height(controller.availiableList.length > 5 ? 170 : 33 + 5)
      ].toColumn(),
    );
  }

// 弹窗出来的币种选择
  _viewBubbleChild1() {
    return Container(
      height: dailyVisible == true ? 155 : 120,
      child: <Widget>[
        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: jiangJinType.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                      controller.onJiangJinTypeChanged(
                          index,
                          feedId.length > 0
                              ? "jinji"
                              : "jiangjin"); // controller.state.chooseType.value= betSlipTypeList[index];
                    },
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.network(controller.globalController.coinUrl)
                            .tight(width: 14, height: 14)
                            .paddingRight(AppValues.halfPadding),
                        CustomText(jiangJinType[index],
                            style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: index == controller.selJiangJinStringIndex
                                    ? ThemeService().colorScheme.secondaryContainer
                                    : const Color(0xff2f4553))),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }).height(dailyVisible == true ? 155 : 120)
      ].toColumn(),
    );
  }

  Widget _buildExchangeRate() {
    return GetBuilder<VipHomeLogic>(
        init: VipHomeLogic(),
        id: "jiesuan_amount",
        builder: (_) {
          final selCoin = controller.globalController.currTypeSelected.value;
          double number = double.parse(controller.selCoinRate.toString());
          String formattedNumber = number.toStringAsFixed(8);

          List<String> keyString = [S.current.sport_all, 'daily', 'weekly', "monthly"];
          String amount = "";
          String finalAmount = "";
          if (feedId.length > 0) {
            finalAmount = controller.inputJieSuanString == ""
                ? "0.00"
                : (double.parse(controller.inputJieSuanString) * number)
                    .toStringAsFixed(controller.isFaBi(selCoin) ? 2 : 8);
          } else {
            if (controller.selJiangJinStringIndex == 0) {
              amount = controller.getFengLuTotalAmount();
            } else {
              amount = controller
                          .availiableMap[keyString[controller.selJiangJinStringIndex - 1]]![0]
                          .state ==
                      2
                  ? "0.00"
                  : controller
                      .availiableMap[keyString[controller.selJiangJinStringIndex - 1]]![0].amount;
              finalAmount = controller.inputJieSuanString == ""
                  ? "0.00"
                  : (double.parse(controller.inputJieSuanString) * number)
                      .toStringAsFixed(controller.isFaBi(selCoin) ? 2 : 8);
            }
          }
          return <Widget>[
            <Widget>[
              CustomText(controller.GetDuiHuanText(selCoin),
                  style: ThemeService()
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: const Color(0xffb1bad3), fontWeight: FontWeight.w600)),
              CustomText("${S.current.random_text_652} $formattedNumber",
                      style: ThemeService()
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: const Color(0xffb1bad3), fontWeight: FontWeight.w600))
                  .paddingRight(AppValues.defaultPadding),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    border: Border.all(
                      color: const Color(0xFF2f4553), // 边框颜色
                      width: 2.0, // 边框宽度
                    ),
                    borderRadius: BorderRadius.circular(4)),
                child: Align(
                  alignment: const Alignment(-0.9, 0),
                  child: CustomText(
                    finalAmount,
                    style:
                        ThemeService().textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ).height(40).expanded(),
              _currencyWidget().width(120),
            ].toRow().paddingTop(AppValues.halfPadding),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
        });
  }

  Widget _buildSearchView() {
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: AppValues.margin_10),
      child: CupertinoSearchTextField(
        prefixInsets: const EdgeInsets.only(left: 10),
        prefixIcon: const CustomAssetIcon(
          name: "assets/images/top_search_ic.png",
          size: 16,
        ),
        itemColor: AppThemes.secondaryIconColor,
        placeholder: S.current.wallet_search,
        // placeholderStyle: const TextStyle(color: AppThemes.white566771, fontWeight: FontWeight.w500),
        placeholderStyle:
            const TextStyle(color: AppThemes.tertiaryColor, fontWeight: FontWeight.w500),
        decoration: BoxDecoration(
          color: AppThemes.widgetColorWhite,
          border: Border.all(color: AppThemes.whiteD5DCEB, width: 2.0),
          // Add a border
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // 阴影颜色
              spreadRadius: 0, // 扩散半径
              blurRadius: 2, // 模糊半径
              offset: const Offset(0, 1), // 阴影偏移量
            ),
          ],
        ),
        style: const TextStyle(
            fontSize: 14, color: AppThemes.tertiaryColor, fontWeight: FontWeight.w500),
        onChanged: (String value) {
          controller.updateSearchList(value);
        },
        onSubmitted: (String value) {},
      ),
    );
  }

  Widget _buildBtn(context) {
    return <Widget>[
      CustomText(S.current.receive,
              style: ThemeService()
                  .theme
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: const Color(0xff05080A), fontWeight: FontWeight.w600))
          .center()
          .tight(height: 44)
          .backgroundColor(const Color(0xFF00e701))
          .clipRRect(all: 4)
          .onTap(() {
        controller.globalController
            .showOverlayView(isShowTopBarView: true, isShowBottomBarView: true);
        RouteUtil.popView();

        final selCoin = controller.globalController.currTypeSelected.value;
        double number = double.parse(controller.selCoinRate.toString());

        List<String> keyString = ['daily', 'weekly', "monthly"];
        List<String> valueString = [
          S.current.random_text_603,
          S.current.random_text_604,
          S.current.random_text_605
        ];

        String finalAmount = "";

        if (feedId.length == 0) {
          //   String amount =
          //       controller.availiableMap[keyString[controller.selJiangJinStringIndex]]![0].amount;
          //   finalAmount = (double.parse(amount) * number).toStringAsFixed(2);

          if (controller.selJiangJinStringIndex == 0) {
            controller.lingquQuabBuJiangJin(originalContext, selCoin.cur, "jifen");

            return;
          }

          if (controller
                  .availiableMap[keyString[controller.selJiangJinStringIndex - 1]]![0].state ==
              2) {
            finalAmount = "0.00";
          } else {
            finalAmount = controller
                .availiableMap[keyString[controller.selJiangJinStringIndex - 1]]![0].amount;
          }
        } else {
          if (controller.selJiangJinStringIndex == 0) {
            controller.lingquQuabBuJiangJin(originalContext, selCoin.cur, "upgrade");

            return;
          }
        }

        controller.reqReceiveAction(
            originalContext,
            feedId.length > 0
                ? controller.availiableList[controller.selJiangJinStringIndex - 1].id
                : controller.availiableMap[keyString[controller.selJiangJinStringIndex]]![0].id,
            selCoin.cur,
            controller.inputJieSuanString,
            feedId.length == 0
                ? valueString[controller.selJiangJinStringIndex]
                : S.current.vip_tab_bouns);

        controller.textEditingController.text = "";
      }).expanded()
    ].toRow();
  }

  String get selCoinImgUrl {
    return "${AppValues.defaultBranch.asset_url}/currency/${controller.selCoin.cur}.webp";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VipHomeLogic>(
        init: VipHomeLogic(),
        id: "vip_lingqu_record",
        builder: (_) {
          return _buildBody(context);
        });
  }
}
