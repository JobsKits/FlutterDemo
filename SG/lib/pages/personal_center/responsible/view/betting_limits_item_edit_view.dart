import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/num_util.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_button.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_icon.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/input/custom_text_field.dart';
import '../model/betting_item_state.dart';
import '../responsible_logic.dart';
import '../responsible_view.dart';
import 'betting_limits_progress_indicator.dart';

// typedef VoidCallback = void Function();
//item 编辑
class BettingLimitsItemEditView extends StatelessWidget {
  BettingLimitsItemEditView({super.key, required this.state, this.onClickCancel, this.onClickSave});

  //主要是给选择下拉组件 一个挂载锚地key, 通过它可以获取组件对象， 并计算获取size 大小，width 和 height
  final GlobalKey bettingItemGlobalKey = GlobalKey();
  final bubbleWith = 80.0; //框度
  final double heightOfWidget = 5; //倍数

  final ResponsibleLogic controller = Get.find<ResponsibleLogic>();
  final BettingItemState state;
  final GestureTapCallback? onClickCancel;
  final void Function(BettingItemState state)? onClickSave;

  late double limitMoneyTemp = 0.0;
  final RxInt limitTimeTypeTemp = RxInt(-1); //初始值
  // final   limitTimeTypeTemp = -1.obs;//初始值

  // final CustomInputCallBack? inputCallBack;
  // final CustomInputCompletionCallBack? inputCompletionCallBack;
  // VoidCallback?

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///标题部分
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: ThemeService().colorScheme.tertiary,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppValues.smallRadius),
                  topRight: Radius.circular(AppValues.smallRadius))),
          child: Row(
            children: [
              CustomText(
                S.current.responsible_label_loss_limits,
                style: ThemeService().textTheme.labelLarge,
              ),
              const Expanded(child: SizedBox()),
              CustomText(
                S.current.responsible_btn_clear_limit,
                style: ThemeService().textTheme.labelLarge,
              ),
              SizedBox(width: AppValues.defaultPadding),
              CustomButton(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: ShapeDecoration(
                  color: Color(0xFF00E701),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                onTap: onClickCancel,
                child: CustomText(
                  S.current.wallet_cancel,
                  style: ThemeService().textTheme.labelMedium!.copyWith(color: Colors.black),
                ),
              ),
              SizedBox(width: AppValues.defaultPadding),
              CustomButton(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: ShapeDecoration(
                  color: Color(0xFF1475E1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                onTap: () {
                  onClickSaveButton();
                },
                child: CustomText(
                  S.current.button_save_text,
                  style: ThemeService().textTheme.labelMedium!.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),

        ///正文部分
        Container(
          padding: EdgeInsets.all(AppValues.defaultPadding),
          decoration: BoxDecoration(
            color: ThemeService().colorScheme.surfaceVariant,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 26,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      color: ThemeService().colorScheme.surface,
                      child: Row(
                        children: [
                          CustomText(
                            "R\$",
                            style: ThemeService().textTheme.bodyMedium,
                          ),
                          SizedBox(width: AppValues.smallMargin),
                          Expanded(
                            child: CustomTextField(
                              text: "${state.limitMoney}",
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              inputCompletionCallBack: (value, isSubmitted) {
                                log("inputCompletionCallBack...value:" + value.toString());
                              },
                              inputCallBack: (value) {
                                log("inputCallBack...value:" + value.toString());
                                var inputMoney = NumUtil.getDoubleByValueStr(value);
                                log("inputCallBack...inputMoney:" + inputMoney.toString());
                                if (inputMoney != null && inputMoney >= state.curryMoney) {
                                  limitMoneyTemp = inputMoney;
                                  log("inputCallBack...true:");
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: AppValues.smallMargin),
                  CustomAssetIcon(size: 18, name: "assets/images/coin_icon/eth_ic.png"),
                  // Expanded(child: SizedBox()),
                  SizedBox(width: AppValues.largeMargin),
                  _buildSelectTimeWidget(),
                ],
              ),
              SizedBox(height: AppValues.defaultPadding),
              Row(
                children: [
                  CustomText(
                    "R\$ ${state.curryMoney}",
                    style: ThemeService().textTheme.labelMedium,
                  ),
                  Expanded(child: SizedBox()),
                  CustomText(
                    "R\$ ${state.limitMoney}",
                    style: ThemeService().textTheme.labelMedium,
                  ),
                ],
              ),
              SizedBox(height: AppValues.halfPadding),
              BettingLimitsProgressIndicator(value: state.getLimitProcess(), minHeight: 6),
              SizedBox(height: AppValues.halfPadding),
            ],
          ),
        ),
        SizedBox(
          height: AppValues.defaultMargin,
        )
      ],
    );
  }

  //下拉选择选择时间 区域
  Widget _buildSelectTimeWidget() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        // widget._startAnimation(widget._rotatingArrowKey);
        DialogUtils.showCustomBubbleDialog(
          Get.context!, _createSelectTimeTypeContent(Get.context!), bubbleWith,
          widgetKey: bettingItemGlobalKey,
          backgroundColor: ThemeService().colorScheme.tertiary,
          // globalKey: widget._rotatingArrowKey,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            key: bettingItemGlobalKey,
            height: 26,
            padding: const EdgeInsets.only(
                left: AppValues.defaultPadding,
                right: AppValues.defaultPadding,
                top: AppValues.smallPadding,
                bottom: AppValues.smallPadding),
            decoration: BoxDecoration(
                color: ThemeService().colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(AppValues.smallRadius))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  return CustomText(
                      "${controller.getLimitTimeTypeLabel(_getCurrentSelectTimeType())}",
                      style: ThemeService()
                          .theme
                          .textTheme
                          .labelMedium
                          ?.copyWith(fontWeight: FontWeight.w400));
                }),
                const SizedBox(
                  width: AppValues.margin_4,
                ),
                const CustomAssetIcon(
                  name: "assets/images/top_drop_down arrow.png",
                  size: 18,
                ),
              ],
            ),
          )
        ],
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

  double _getTimeHeight(double ratio) {
    double? totalHeight;
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox =
        bettingItemGlobalKey.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    totalHeight = size.height;
    return totalHeight * ratio;
  }

  ///创建 下拉item view
  Widget _createSelectTimeItem(itemModel) {
    return GestureDetector(
      onTap: () {
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
    //不是初始值 且 有变化
    if (limitTimeTypeTemp.value != -1 && limitTimeTypeTemp.value != state.limitTimeType) {
      return limitTimeTypeTemp.value;
    } else {
      return state.limitTimeType;
    }
  }

  void onClickSaveButton() {
    if (limitMoneyTemp > state.curryMoney) {
      state.limitMoney = limitMoneyTemp;
    }
    state.limitTimeType = _getCurrentSelectTimeType();

    onClickSave!(state);
  }
}
