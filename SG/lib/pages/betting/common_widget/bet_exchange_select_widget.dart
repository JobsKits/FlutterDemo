import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/alliance_plan/widget/custom_select_model.dart';
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

///投注单 是否接受 汇率 变换 下拉框
class BetExchangeSelectWidget extends StatelessWidget {
  final GlobalKey _widgetKey = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();

  ///缩放比例
  final scale = 1.0.obs;

  ///当前已选择投注单内容{BetSlipType}
  final CustomSelectModel selectModel;

  ///可选择投注类型列表
  final List<CustomSelectModel> modelList;
  final ParamSingleCallback<CustomSelectModel> onChange;

  BetExchangeSelectWidget({
    super.key,
    required this.selectModel,
    required this.modelList,
    required this.onChange,
  });

  void _startAnimation() {
    _rotatingArrowKey.currentState?.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      // height: 60,
      child: CustomButton(
          key: _widgetKey,
          // radius: 40,
          //如果这里不设置就会出现矩形的水波纹效果
          // borderRadius: BorderRadius.circular(8),
          padding: EdgeInsets.zero,
          onTap: () {
            _startAnimation();
            scale.value = 0.9;
            Future.delayed(const Duration(milliseconds: 100), () {
              scale.value = 1.0;
            });

            ///弹窗选择投注单或者我的投注
            DialogUtils.showCustomBubbleDialog(
              context,
              _viewBubbleChild(),
              LangService().isChinese ? 150 : 220,
              widgetKey: _widgetKey,
              globalKey: _rotatingArrowKey,
              // backgroundColor: ThemeService().colorScheme.tertiary,
              backgroundColor:  Colors.white,
              // backgroundColor: Colors.white,
              onDismissCallback: () {
                scale.value = 0.9;
                Future.delayed(const Duration(milliseconds: 100), () {
                  scale.value = 1.0;
                });
              },
            );
          },
          child: Obx(() => AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.bounceIn, // 使用弹性曲线
                transform: Matrix4.identity()..scale(scale.value),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      selectModel.label,
                      style: ThemeService().textTheme.labelLarge,
                      // style: ThemeService().textTheme.bodyMedium?.copyWith(
                      //       color: Colors.white,
                      //       fontSize: 16,
                      //
                      //       fontWeight: FontWeight.w500,
                      //     ),
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

  Widget _viewBubbleChild() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(modelList.length, (index) {
          return InkWell(
            onTap: () {
              if (index < modelList.length) {
                onChange(modelList[index]);
              }
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomText(
                modelList[index].label,
                // style: ThemeService().textTheme.bodySmall?.copyWith(
                //     color: betSlipTypeList[index].isEnable
                //         ? (betSlipTypeList[index].type == chooseBetSlipTypeModel.type
                //             ? AppThemes.secondaryColor
                //             : ThemeService().colorScheme.tertiary)
                //         // : AppThemes.widgetColorWhite)
                //         : AppThemes.widgetColorWhite.withOpacity(0.3),
                //     fontSize: 14,
                //     fontWeight: FontWeight.w600),
                style: ThemeService().textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    // color: selectModel == modelList[index]
                    //     ? AppThemes.secondaryColor
                    //     : AppThemes.widgetColorWhite),
                  color: selectModel == modelList[index]
                      ? AppThemes.secondaryColor
                      : ThemeService().colorScheme.surface),
              ),
            ),
          );
        }),
      ),
    );
  }
}
