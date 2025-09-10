import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/wallet/BankcardBean.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/dialog/dialog_utils.dart';

class DepositBankSelView extends GetView<WalletCtrl> {
  final double bankRatio = 2.5;

  @override
  Widget build(BuildContext context) {
    return _selectBankWidget(context);
  }

  final GlobalKey rootViewGlobalKey = GlobalKey();

  final GlobalKey _globalKeyBank = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingBankArrowKey = GlobalKey<RotatingArrowState>();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  Widget _selectBankWidget(BuildContext context) {
    return Visibility(
        visible: controller.pwySelBean.value.bank ?? false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          key: _globalKeyBank,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomAsterisksTipsText(
                text: S.current.wallet_bankSelection,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            _selectBank("", context)
            // LayoutBuilder(
            //   builder: (context, constraints) {
            //     double containerWidth = constraints.maxWidth; // 获取父级约束的最大宽度
            //     double halfScreenWidth = (Get.width - 32) / 2; // 屏幕宽度的一半
            //     double threshold = halfScreenWidth * 0.2; //  超过屏幕宽度的80%，则使用屏幕宽度的一半
            //     if (containerWidth > threshold) {
            //       containerWidth = halfScreenWidth;
            //     }
            //     return _selectBank("", context, containerWidth);
            //   },
            // )
          ],
        ).marginOnly(top: 16));
  }

  Widget _selectBank(String hintStr, BuildContext context) {
    return InkWell(
      onTap: () {
        _startAnimation(_rotatingBankArrowKey);
        DialogUtils.showCustomBubbleDialog(
            // arrowBasisOffset: (Get.width - 32) / 4,
            context,
            _selectBankType(),
            _getInputWidth(_globalKeyBank),
            widgetKey: _globalKeyBank,
            backgroundColor: AppThemes.widgetColorWhite,
            globalKey: _rotatingBankArrowKey);
      },
      child: Container(
        padding: const EdgeInsets.only(
            top: AppValues.defaultPadding, bottom: AppValues.defaultPadding, left: 8, right: 8),
        decoration: BoxDecoration(
            color: ThemeService().colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.bounceIn, // 使用弹性曲线
          transform: Matrix4.identity()..scale(controller.scale.value),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                return SizedBox(
                  width: Get.width - 100,
                  child: CustomText(
                    controller.thirdBnkSelBean.value.name ??
                        S.current.binding_bank_card_select_bank,
                    style: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textColorStyle: (controller.thirdBnkSelBean.value.name ?? "").isEmpty
                        ? CustomTextColorStyle.walletHintColor
                        : CustomTextColorStyle.white,
                  ),
                );
              }),
              // CustomText(S.current.random_text_1133),
              Obx(() {
                return Visibility(
                  visible: controller.thirdBnkList.length != 1,
                  child: RotatingArrow(
                    key: _rotatingBankArrowKey,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectBankType() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      child: Scrollbar(
        controller: controller.scrollAbcBankController, // Provide a ScrollController
        radius: const Radius.circular(10),
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: controller.scrollAbcBankController,
          child: Column(
            children: controller.thirdBnkList.map((bank) {
              return _bankItem(bank);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _bankItem(BankcardBean bankcardBean) {
    return GestureDetector(
      onTap: () {
        RouteUtil.popView();
        controller.saveSelectedThirdBank(bankcardBean);
      },
      child: Container(
        color: bankcardBean.isSelect == true ? AppThemes.textColorSecondary : Colors.transparent,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 8),
        child: CustomText(
          (bankcardBean.uid != null) ? (bankcardBean.bankName ?? "") : (bankcardBean.name ?? ""),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textColorStyle: CustomTextColorStyle.dark,
        ),
      ),
    );
  }

  double _getWalletHeight(double ratio) {
    double? totalHeight;
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox = rootViewGlobalKey.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    totalHeight = size.height;
    return totalHeight / ratio;
  }

  double _getInputWidth(GlobalKey globalKey) {
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    return size.width;
  }
}
