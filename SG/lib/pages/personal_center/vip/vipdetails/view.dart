import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/time/time_utils.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_empty_widget.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image_placeholder.dart';
import 'package:flutter_bet/widget/row/custom_row_expanded_widget.dart';

import 'logic.dart';
import 'package:get/get.dart';

class VipLingQuRecordPage extends GetView<VipLingQuLogic> {
  final GlobalKey _widgetKey = GlobalKey(); // 创建一个GlobalKey
  final GlobalKey _widgetKey1 = GlobalKey();
  final GlobalKey _widgetKey2 = GlobalKey();

  final GlobalKey<RotatingArrowState> _rotatingArrowKey1 = GlobalKey<RotatingArrowState>();
  final GlobalKey<ScalingTextState> _scalingKey1 = GlobalKey<ScalingTextState>();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey2 = GlobalKey<RotatingArrowState>();
  final GlobalKey<ScalingTextState> _scalingKey2 = GlobalKey<ScalingTextState>();

  VipLingQuRecordPage({super.key}); // 创建一个GlobalKey
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: S.current.vip_commission_history,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VipLingQuLogic>(
      id: "vip_record",
      builder: (controller) {
        return <Widget>[
          Container(
              color: ThemeService().theme.colorScheme.background,
              child: buildTopSelectDateBar(context)),
          controller.isLoading == true
              ? buildLoding()
              : Container(
                  decoration:
                      const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: buildListBody().paddingHorizontal(AppValues.defaultPadding)),
        ].toColumn();
      },
    );
  }

  // CustomIconButton(
  // decoration: BoxDecoration(
  // borderRadius: BorderRadius.circular(20),
  // border: Border.all(width: 2, color: ThemeService().colorScheme.tertiary)),
  // backgroundColor: ThemeService().theme.colorScheme.surface,
  // name: controller.dateList[controller.currentSelectedIndex],
  // direction: Direction.right,
  // iconWidget: Image.asset(
  // "assets/images/bet_slip/ic_casino_down.webp",
  // ),
  // borderRadius: 20,
  // widgetHeight: 35,
  // widgetWidth: 80,
  // iconWidth: 20,
  // iconHeight: 20,
  // key: _widgetKey1,
  // ),
// 加载中
  Widget buildLoding() {
    return Container(
      alignment: Alignment.topCenter,
      height: 150,
      child: CustomNetWorkImagePlaceholder(
        color: AppThemes.surfaceVariant.withOpacity(0),
        placeholderType: NetWorkImagePlaceholderType.loading,
      ).center(),
    );
  }

  // 日期
  Widget buildTopSelectDateBar(context) {
    double number = double.parse(controller.totalAmount);
    String formattedNumber = number.toStringAsFixed(2);
    return <Widget>[
      Container(
              key: _widgetKey1,
              padding: const EdgeInsets.symmetric(horizontal: AppValues.padding_10, vertical: 9.0),
              decoration: BoxDecoration(
                color: ThemeService().theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
              ),
              child: <Widget>[
                ScalingText(
                  key: _scalingKey1,
                  text: controller.dateList[controller.currentSelectedIndex],
                  textStyle: ThemeService()
                      .theme
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                RotatingArrow(
                  key: _rotatingArrowKey1,
                ),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween))
          .onTap(() {
        _resetAnimation(_rotatingArrowKey1);
        _resetScaleAnimation(_scalingKey1);
        _startAnimation(_rotatingArrowKey1);
        _startScaleAnimation(_scalingKey1);
        DialogUtils.showCustomBubbleDialog(
            context, _viewBubbleDateList(), LangUtil().isZhCn() ? 113 : 140,
            widgetKey: _widgetKey1, globalKey: _rotatingArrowKey1, dxWidth: 5);
      }).constrained(minWidth: Get.width / 2 - AppValues.defaultPadding * 2),
      Container(
        key: _widgetKey2,
        padding: const EdgeInsets.symmetric(horizontal: AppValues.padding_10, vertical: 9.0),
        decoration: BoxDecoration(
          color: ThemeService().theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: <Widget>[
          ScalingText(
            key: _scalingKey2,
            text: controller.typeList[controller.currentTypeSelectedIndex],
            textStyle:
                ThemeService().theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
          ),
          RotatingArrow(
            key: _rotatingArrowKey2,
          ),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
      ).onTap(() {
        _resetAnimation(_rotatingArrowKey2);
        _resetScaleAnimation(_scalingKey2);
        _startAnimation(_rotatingArrowKey2);
        _startScaleAnimation(_scalingKey2);
        DialogUtils.showCustomBubbleDialog(
            context,
            _viewBubbleTypeList(),
            LangUtil().isEnIn() || LangUtil().isTh() || LangUtil().isViVn()
                ? 160
                : LangUtil().isPtBr()
                    ? 160
                    : 103,
            widgetKey: _widgetKey2,
            globalKey: _rotatingArrowKey2,
            dxWidth: LangUtil().isZhCn() ? 20 : -10);
      }).constrained(minWidth: Get.width / 2 - AppValues.defaultPadding * 2),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .paddingTop(AppValues.defaultPadding)
        .paddingHorizontal(AppValues.defaultPadding);
  }

  void _resetAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.resetAnimation();
  }

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  void _startScaleAnimation(GlobalKey<ScalingTextState> key) {
    key.currentState?.startAnimation();
  }

  void _resetScaleAnimation(GlobalKey<ScalingTextState> key) {
    key.currentState?.resetAnimation();
  }

  // 弹窗出来的平台选择-日期
  _viewBubbleDateList() {
    return <Widget>[
      const SizedBox(height: AppValues.halfPadding),
      <Widget>[
        for (int i = 0; i < controller.dateList.length; i++)
          InkWell(
            onTap: () {
              Get.back();
              controller.changeTimeType(i);
            },
            child: Text(controller.dateList[i],
                textAlign: TextAlign.left,
                style: ThemeService().theme.textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: i == controller.currentSelectedIndex
                          ? ThemeService().colorScheme.primary
                          : AppThemes.textColorDark,
                    )).paddingVertical(AppValues.halfPadding),
          )
      ].toColumn(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start),
      const SizedBox(height: AppValues.halfPadding),
    ].toColumn(mainAxisSize: MainAxisSize.min);
  }

// 弹窗出来的平台选择-类型
  _viewBubbleTypeList() {
    return <Widget>[
      const SizedBox(height: AppValues.halfPadding),
      <Widget>[
        for (int i = 0; i < controller.typeList.length; i++)
          InkWell(
            onTap: () {
              Get.back();
              controller.changeTypeType(i);
            },
            child: Text(controller.typeList[i],
                textAlign: TextAlign.left,
                style: ThemeService().theme.textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: i == controller.currentTypeSelectedIndex
                          ? ThemeService().colorScheme.primary
                          : AppThemes.textColorDark,
                    )).paddingVertical(AppValues.halfPadding),
          )
      ].toColumn(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start),
      const SizedBox(height: AppValues.halfPadding),
    ].toColumn(mainAxisSize: MainAxisSize.min);
  }

  Widget buildListBody() {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.isLoading
                    ? 1
                    : controller.dataList.length == 0
                        ? 2
                        : controller.dataList.length + 1,
                itemBuilder: (context, index) {
                  final bgColor = index % 2 == 0
                      ? ThemeService().theme.colorScheme.background
                      : ThemeService().colorScheme.tertiary;

                  if (index == 0) {
                    return Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                      decoration: ShapeDecoration(
                          color: bgColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                      child: CustomRowExpandedWidget(
                          expanded: LangUtil().isZhCn() ? const [3, 3, 3] : const [3, 3, 3],
                          children: [
                            CustomText(S.current.random_text_520,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600, color: Color(0xffb1bad3)))
                                .tight(width: 100),
                            CustomText(S.current.random_text_128,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600, color: Color(0xffb1bad3)))
                                .tight(width: 100),
                            CustomText(S.current.vault_amount,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600, color: Color(0xffb1bad3)))
                                .tight(width: 120)
                          ]).tight(height: 55),
                    );
                  }

                  return controller.dataList.length == 0
                      ? const CustomEmptyWidget(
                          width: 96 * 1.4,
                          height: 96 * 1.4,
                          imgPath: "assets/images/data_empty_1.png",
                        )
                          .paddingTop(AppValues.largePadding * 5)
                          .paddingBottom(AppValues.largePadding * 5)
                      :
                      // // double number = double.parse(controller.dataList[index - 1].amount.toString());
                      // // String formattedNumber = number.toStringAsFixed(2);
                      // return /*controller.isLoading
                      //     ? _buildLoadingItem(index)
                      //     : */
                      Container(
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                          decoration: ShapeDecoration(
                              color: bgColor,
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                          child: CustomRowExpandedWidget(
                            expanded: LangUtil().isZhCn() ? const [3, 3, 3] : const [3, 3, 3],
                            children: [
                              CustomText(getTimeFormat(controller.dataList[index - 1].updatedAt),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: AppValues.fontBodyMediumSize,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffb1bad3)))
                                  .tight(width: 100),
                              CustomText(
                                      controller.dataList[index - 1].cashType.toString() == "818" ||
                                              controller.dataList[index - 1].cashType.toString() ==
                                                  "814"
                                          ? "VIP${controller.dataList[index - 1].vip} ${getLingQuString(controller.dataList[index - 1].cashType.toString())}"
                                          : getLingQuString(
                                              controller.dataList[index - 1].cashType.toString()),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: AppValues.fontBodyMediumSize,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffb1bad3)))
                                  .tight(width: 100),
                              CustomIconButton(
                                      name: controller.dataList[index - 1].receiveAmount,
                                      // textAlign: TextAlign.center,
                                      iconWidget: Image.network(
                                          "${AppValues.defaultBranch.asset_url}/currency/${controller.dataList[index - 1].receiveCurrencyId}.webp"),
                                      iconHeight: 14,
                                      iconWidth: 14,
                                      direction: Direction.right,
                                      style: const TextStyle(
                                          fontSize: AppValues.fontBodyMediumSize,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffb1bad3)))
                                  .tight(width: 120)
                            ],
                          ).tight(height: 55));
                })
            .paddingTop(AppValues.defaultPadding)
            .tight(
                width: Get.width - AppValues.defaultPadding * 4 > 342
                    ? Get.width - AppValues.defaultPadding * 4
                    : 342),
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
        .backgroundColor(index % 2 == 0 ? Colors.transparent : ThemeService().colorScheme.tertiary)
        .clipRRect(all: 5);
  }

  getTimeFormat(int? time) {
    // print(time);
    // var dataTime =  DateTime.fromMicrosecondsSinceEpoch(time??0);
    // var dataTime = DateTime.fromMillisecondsSinceEpoch(time != null ? time * 1000 : 0);
    return TimeUtils.timeStampToTimeYMD(time != null ? time : 0);
  }

  String getLingQuString(cashType) {
    switch (cashType) {
      case "814":
        return S.current.random_text_403;
      case "818":
        return S.current.random_text_1121;
      case "819":
        return S.current.random_text_603;
      case "820":
        return S.current.random_text_604;
      case "821":
        return S.current.random_text_605;
      default:
        return cashType;
    }
  }
}
