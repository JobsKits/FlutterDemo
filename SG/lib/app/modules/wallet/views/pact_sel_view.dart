import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../controllers/wallet_controller.dart';

class PactSelView extends GetView<WalletCtrl> {
  final GlobalKey _globalKeyContract = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingContractArrowKey = GlobalKey<RotatingArrowState>();
  final Function(dynamic contract) onTap;
  final GlobalKey rootViewKey = GlobalKey();

  PactSelView(this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return _protocols(context);
  }

  _protocols(BuildContext context) {
    return Container(
      //
      margin: const EdgeInsets.only(top: 16),
      height: 40,
      child: Row(
        key: rootViewKey,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomAsterisksTipsText(
            text: S.current.random_text_1136,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
          _protocolsWidget(context)
        ],
      ),
    );
  }

  Widget _protocolsWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        if (controller.currDepSelCtr.length == 1) {
          return;
        }
        //入款 支付页
        // if (controller.pwySelBean.payment_type == 2 && controller.isPaymentView) {
        //   return;
        // }

        // controller.scale.value = 0.9;
        // Future.delayed(const Duration(milliseconds: 100), () {
        //   controller.scale.value = 1.0;
        // });
        controller.startAnimation(_rotatingContractArrowKey);
        DialogUtils.showCustomBubbleDialog(
          context, _selectContractType(context), controller.bubbleWidth,
          widgetKey: _globalKeyContract,
          backgroundColor: AppThemes.widgetColorWhite,
          globalKey: _rotatingContractArrowKey,
          //     onDismissCallback: () {
          //   controller.scale.value = 0.9;
          //   Future.delayed(const Duration(milliseconds: 100), () {
          //     controller.scale.value = 1.0;
          //   });
          // }
        );
      },
      child: Row(
        key: _globalKeyContract,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: AppValues.defaultPadding, bottom: AppValues.defaultPadding),
            decoration: BoxDecoration(
                color: ThemeService().colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.bounceIn, // 使用弹性曲线
              transform: Matrix4.identity()..scale(controller.scale.value),
              child: Row(
                children: [
                  const SizedBox(
                    width: 19,
                  ),
                  Obx(() {
                    return CustomText(controller.currDepSelCtrStr.value,
                        style: ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500));
                  }),
                  const SizedBox(
                    width: 8,
                  ),
                  Obx(() {
                    return Visibility(
                      // 2 公司
                      visible:
                          // controller.isPaymentView ?
                          controller.currDepSelCtr.length != 1,
                      // &&
                      // controller.pwySelBean.payment_type != 2
                      // : controller.currDepSelCtr.length != 1,

                      child: RotatingArrow(
                        key: _rotatingContractArrowKey,
                      ),
                    );
                  }),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _selectContractType(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: getWalletHeight(0.1)),
      child: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: controller.currDepSelCtr.map((contract) {
              return InkWell(
                  // onTap: () => controller.saveSelectedPact(contract),
                  onTap: () => onTap(contract),
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      child: CustomText(
                        contract['label'],
                        style: TextStyle(
                            color: contract['isSelect'] == true
                                ? Colors.blue
                                : ThemeService().colorScheme.surface),
                      )));
            }).toList(),
          );
        }),
      ),
    );
  }

  double getWalletHeight(double ratio) {
    double? totalHeight;
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox = rootViewKey.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    totalHeight = size.height;
    return totalHeight / ratio;
  }
}
