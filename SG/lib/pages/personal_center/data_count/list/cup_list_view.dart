import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/bottom/custom_bottom_page_widget.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_icon.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../data_count_logic.dart';

///奖杯 列表
class CupListView extends StatelessWidget {
  final DataCountLogic controller;
  final double bubbleWidth = 114;

  final GlobalKey globalKeyS;

  CupListView({super.key, required this.controller, required this.globalKeyS});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        _buildList(),
        CustomBottomPageWidget(currentPage: 1),
      ],
    );
  }

  _buildTitle() {
    final GlobalKey _globalKey = GlobalKey();
    return Container(
      margin: EdgeInsets.only(top: AppValues.defaultMargin),
      child: Column(
        children: [
          _createCupTypes(_globalKey),
          _createListHeader(),
        ],
      ),
    );
  }

  _buildList() {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size.fromHeight(controller.windowListHeightMax)),
      child: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return CupItemView(
            index: index,
          );
        },
      ),
    );
  }

  Widget _createCupTypes(GlobalKey _globalKey) {
    return GestureDetector(
      onTap: () {
        DialogUtils.showCustomBubbleDialog(
            controller.context!, _selectCupsType(controller.context!, globalKeyS), bubbleWidth,
            widgetKey: _globalKey, backgroundColor: ThemeService().colorScheme.tertiary);
      },
      child: Row(
        key: _globalKey,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: AppValues.defaultPadding, bottom: AppValues.defaultPadding),
            decoration: BoxDecoration(
                color: ThemeService().colorScheme.surface,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(2), bottomLeft: Radius.circular(2))),
            child: Row(
              children: [
                const SizedBox(
                  width: AppValues.width_12,
                ),
                CustomText(S.current.random_text_360,
                    style: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(
                  width: AppValues.width_12,
                ),
                const CustomAssetIcon(
                  name: "assets/images/top_drop_down arrow.png",
                  size: 18,
                ),
                const SizedBox(
                  width: 6,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _selectCupsType(BuildContext context, GlobalKey globalKeyS) {
    return Container(
      constraints: BoxConstraints(maxHeight: _getDialogHeight(globalKeyS)),
      child: SingleChildScrollView(
        child: Column(
          children: controller.cupTypes.map((text) {
            return _cupTypeItem(text);
          }).toList(),
        ),
      ),
    );
  }

  Widget _cupTypeItem(String text) {
    return Container(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Center(
        child: CustomText(
          text,
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(color: AppThemes.ffd9d9d9),
        ),
      ),
    );
  }

  // 获取弹窗的高度
  double _getDialogHeight(GlobalKey globalKey) {
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    var localToGlobal = renderBox.localToGlobal(Offset.zero);
    log("neco  size.height =${size.height} =366   localToGlobal.dy=${localToGlobal.dy} =286");
    log("neco ${localToGlobal.dy + size.height}");
    var top = (size.height + (160)) - localToGlobal.dy;
    //实际弹窗高度
    return top;
  }

  _createListHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      height: 44,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: CustomText(S.current.home_game,
                  textAlign: TextAlign.left, textColorStyle: CustomTextColorStyle.normal)),
          Expanded(
              flex: 2,
              child: CustomText(S.current.game_supplier,
                  textAlign: TextAlign.center, textColorStyle: CustomTextColorStyle.normal)),
          Expanded(
              flex: 2,
              child: CustomText(S.current.tab_bar_title_trophy_text,
                  textAlign: TextAlign.right, textColorStyle: CustomTextColorStyle.normal)),
        ],
      ),
    );
  }
}

class CupItemView extends StatelessWidget {
  final int index;

  const CupItemView({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final isOdd = index % 2 == 1;
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      decoration: BoxDecoration(
        color: isOdd ? Colors.transparent : ThemeService().colorScheme.surfaceVariant,
        // borderRadius: BorderRadius.circular(AppValues.smallRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomIcon(
                  asset: 'assets/images/personal_center_icon/ic_cup_game_car.webp',
                  size: 18,
                ),
                CustomText(
                  "11",
                  textAlign: TextAlign.left,
                  textColorStyle: CustomTextColorStyle.normal,
                  style: ThemeService().textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: CustomText(
              "22",
              textColorStyle: CustomTextColorStyle.normal,
              textAlign: TextAlign.center,
              style: ThemeService().textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: CustomIcon(
                asset: 'assets/images/normal/ic_normal_close.png',
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
