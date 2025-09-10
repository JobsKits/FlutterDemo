import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/dialog/custom_safe_dialog.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../responsible_logic.dart';

///自我排除,设置时间
class SelfExclusionTimeView extends StatelessWidget {
  SelfExclusionTimeView({super.key});

  //主要是给选择下拉组件 一个挂载锚地key, 通过它可以获取组件对象， 并计算获取size 大小，width 和 height
  final GlobalKey selfExclusionTimeGlobalKey = GlobalKey();
  final bubbleWith = 200.0; //框度，动态计算
  final double heightOfWidget = 5; //倍数
  final RxInt limitTimeTypeTemp = RxInt(1); //初始值

  final ResponsibleLogic controller = Get.find<ResponsibleLogic>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,boxConstraint) {
        log('约束信息：SelfExclusionTimeView...$boxConstraint');
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppValues.halfMargin),
              height: 1,
              color: ThemeService().colorScheme.tertiary,
            ),
            Container(
              // padding: const EdgeInsets.all(AppValues.defaultPadding),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.largePadding, vertical: AppValues.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    S.current.random_text_381,
                    style: ThemeService()
                        .theme
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  _buildSelectTimeWidget(),
                  _buildBottom(context),
                ],
              ),
            ),
          ],
        );
      }
    );
  }

  _buildBottom(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(AppValues.defaultPadding),
      margin: EdgeInsets.symmetric(vertical: AppValues.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomBigMainButton(
            title: S.current.submit_text,
            colorStyle: CustomButtonColorStyle.tertiary,
            onTap: (_) {
              //todo
              // CustomSafeDialog.dismiss(context: context, tag: kDataCountPage);
              CustomSnackBar.show(
                  title:S.current.random_text_383, S.current.random_text_384, context,
                  preIcon: CustomSnackBarIcons.responsible);
              controller.onClickCloseLabel();
            },

          ),
          SizedBox(
            height: AppValues.height_16,
          ),
          CustomText(
            S.current.random_text_385,
            style: ThemeService().theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }

  //选择时间
  Widget _buildSelectTimeWidget() {
    return GestureDetector(
      onTap: () {
        // widget._startAnimation(widget._rotatingArrowKey);
        DialogUtils.showCustomBubbleDialog(
          Get.context!,
          _createSelectTimeTypeContent(Get.context!),
          // bubbleWith,
          _getTimeWidth(0.98),
          widgetKey: selfExclusionTimeGlobalKey,
          backgroundColor: ThemeService().colorScheme.tertiary,
          // globalKey: widget._rotatingArrowKey,
        );
      },
      child: Container(
        key: selfExclusionTimeGlobalKey,
        height: 40,
        margin: EdgeInsets.only(top: AppValues.defaultPadding),

        padding: const EdgeInsets.only(
            left: AppValues.halfPadding,
            right: AppValues.halfPadding,
            top: AppValues.smallPadding,
            bottom: AppValues.smallPadding),
        // decoration: BoxDecoration(
        //     color: ThemeService().colorScheme.surface,
        //     borderRadius: const BorderRadius.all(Radius.circular(AppValues.smallRadius))),
        decoration: BoxDecoration(
          color: ThemeService().colorScheme.surface,
          border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(() {
                return CustomText(
                    "${controller.getLimitTimeTypeLabel(_getCurrentSelectTimeType())}",
                    style: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w400));
              }),
            ),
            const SizedBox(
              width: AppValues.margin_4,
            ),
            const CustomAssetIcon(
              name: "assets/images/top_drop_down arrow.png",
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  ///创建 下拉 正文部分
  Widget _createSelectTimeTypeContent(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: _getTimeHeight(heightOfWidget)),
      child: SingleChildScrollView(
        child: Column(
          children: controller.limitTimeTypeMap.map((itemModel) {
            return _createSelectTimeItem(itemModel);
          }).toList(),
        ),
      ),
    );
  }

  ///创建 下拉item view
  Widget _createSelectTimeItem(itemModel) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        limitTimeTypeTemp.value = itemModel['type'];
        log('timeTypeTemp...type:' + limitTimeTypeTemp.toString());
        RouteUtil.popView();
      },
      child: Obx(() {
        return Container(
          padding: const EdgeInsets.only(top: 6, bottom: 6),
          color: itemModel['type'] == _getCurrentSelectTimeType()
              ? ThemeService().colorScheme.primary
              : null,
          alignment: Alignment.center,
          width: double.infinity,
          child: CustomText(
            itemModel['title'],
            style: ThemeService().theme.textTheme.bodyMedium?.copyWith(color: AppThemes.ffd9d9d9),
          ),
        );
      }),
    );
  }

  ///获取当前索引
  int _getCurrentSelectTimeType() {
    return limitTimeTypeTemp.value;
  }

  double _getTimeHeight(double ratio) {
    double? totalHeight;
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox =
        selfExclusionTimeGlobalKey.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    totalHeight = size.height;
    return totalHeight * ratio;
  }

  double _getTimeWidth(double ratio) {
    double? totalWidth;
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox =
        selfExclusionTimeGlobalKey.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    totalWidth = size.width;
    return totalWidth * ratio;
  }
}
