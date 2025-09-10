import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/betting/betting_logic.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constant/app_themes.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/function.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../common_model/bet_slip_type_model.dart';

///投注单页bar
class BetSlipBar extends GetView<BettingLogic> {
  final GlobalKey _widgetKey = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();

  ///当前显示模式0:娱乐城 1:体育
  ///该参数会影响弹窗内容，及点击弹窗item后的回调
  final int modelType;
  static int modelType_sprot = 1;
  static int modelType_casino = 2;

  ///当前已选择投注单内容{BetSlipType}
  final BetSlipTypeModel chooseBetSlipTypeModel;

  ///可选择投注类型列表
  final List<BetSlipTypeModel> betSlipTypeList;
  final ParamSingleCallback<BetSlipTypeModel> onChange;
  final int myBetCount;
  final int betSlipCount;

  BetSlipBar(
      {super.key,
      required this.modelType,
      required this.chooseBetSlipTypeModel,
      required this.betSlipTypeList,
      required this.onChange,
      required this.myBetCount,
      required this.betSlipCount});

  void _startAnimation() {
    _rotatingArrowKey.currentState?.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BettingLogic());
    return Container(
      alignment: Alignment.centerLeft,
      height: 60,
      child: CustomButton(
          key: _widgetKey,
          // radius: 40,
          //如果这里不设置就会出现矩形的水波纹效果
          // borderRadius: BorderRadius.circular(8),
          padding: EdgeInsets.zero,
          onTap: () {
            _startAnimation();
            controller.state.scale.value = 0.9;
            Future.delayed(const Duration(milliseconds: 100), () {
              controller.state.scale.value = 1.0;
            });

            ///弹窗选择投注单或者我的投注
            DialogUtils.showCustomBubbleDialog(
              context,
              _viewBubbleChild(),
              LangService().isChinese ? 100 : 150, //适配国际化
              widgetKey: _widgetKey,
              globalKey: _rotatingArrowKey,
              // backgroundColor: ThemeService().colorScheme.tertiary,
              backgroundColor: Colors.white,
              onDismissCallback: () {
                controller.state.scale.value = 0.9;
                Future.delayed(const Duration(milliseconds: 100), () {
                  controller.state.scale.value = 1.0;
                });
              },
            );
          },
          child: Obx(() => AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.bounceIn, // 使用弹性曲线
                transform: Matrix4.identity()..scale(controller.state.scale.value),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomAssetIcon(name: chooseBetSlipTypeModel.icon ?? "", size: 16),
                    const SizedBox(width: 6),
                    CustomText(
                      chooseBetSlipTypeModel.title,
                      style: ThemeService().textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Visibility(
                      visible: isShowBadges(),
                      child: Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                            color: ThemeService().colorScheme.secondary,
                            borderRadius: BorderRadius.circular(25)),
                        child: CustomText(
                          chooseBetSlipTypeModel.type.isBetBill() ? '$betSlipCount' : '$myBetCount',
                          style: const TextStyle(color: AppThemes.textColorDark, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    RotatingArrow(
                      key: _rotatingArrowKey,
                    ),
                  ],
                ),
              ))),
    );
  }

  ///是否显示，角标
  bool isShowBadges() {
    return modelType == 1 &&
        ((chooseBetSlipTypeModel.type.isBetBill() && betSlipCount > 0) ||
            (!chooseBetSlipTypeModel.type.isBetBill() && myBetCount > 0));
  }

  Widget _viewBubbleChild() {
    return Column(
      children: List.generate(betSlipTypeList.length, (index) {
        return Offstage(
          offstage: betSlipTypeList[index].isHide,
          child: Column(
            children: [
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  if (betSlipTypeList[index].isEnable) {
                    onChange(betSlipTypeList[index]);
                  }
                  Get.back();
                  // controller.state.chooseType.value= betSlipTypeList[index];
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const SizedBox(width: 10),
                    // CustomIcon(asset: betSlipTypeList[index].icon!),
                    // const SizedBox(width: 6),
                    Text(
                      betSlipTypeList[index].title,
                      style: ThemeService().textTheme.bodySmall?.copyWith(
                          color: betSlipTypeList[index].isEnable
                              ? (betSlipTypeList[index].type == chooseBetSlipTypeModel.type
                                  ? AppThemes.secondaryColor
                                  : ThemeService().colorScheme.tertiary)
                              // : AppThemes.widgetColorWhite)
                              : AppThemes.widgetColorWhite.withOpacity(0.3),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      }),
    );
  }
}
