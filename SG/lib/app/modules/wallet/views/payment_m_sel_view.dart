import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../controllers/wallet_controller.dart';

class PaymentMethodSelSelView extends GetView<WalletCtrl> {
  final GlobalKey _globalKeyContract = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingContractArrowKey = GlobalKey<RotatingArrowState>();
  final GlobalKey rootViewGlobalKey = GlobalKey();

  PaymentMethodSelSelView();

  @override
  Widget build(BuildContext context) {
    return _paymentMethod(context);
  }

  _paymentMethod(BuildContext context) {
    return Container(
      key: rootViewGlobalKey,
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          hintText(),
          _paymentMethodWidget(context),
        ],
      ),
    );
  }

  Widget hintText() {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width / 2 - 10),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: controller.getPrompt(),
              style: ThemeService().textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: ThemeService().colorScheme.onSurface),
            ),
            TextSpan(
              text: "\t*",
              style: ThemeService().textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppThemes.reverseStateColor,
                  ),
            ),
          ],
        ),
        softWrap: true, // 启用自动换行
      ),
    );
  }

  Widget _paymentMethodWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        if (controller.currSelChList.length == 1) {
          return;
        }
        controller.scale.value = 0.9;
        Future.delayed(const Duration(milliseconds: 100), () {
          controller.scale.value = 1.0;
        });
        controller.startAnimation(_rotatingContractArrowKey);
        DialogUtils.showCustomBubbleDialog(
            positionedRight: 32,
            arrowBasisOffset: 40,
            context,
            _selectPaymentType(context),
            140,
            widgetKey: _globalKeyContract,
            backgroundColor: AppThemes.widgetColorWhite,
            globalKey: _rotatingContractArrowKey, onDismissCallback: () {
          controller.scale.value = 0.9;
          Future.delayed(const Duration(milliseconds: 100), () {
            controller.scale.value = 1.0;
          });
        });
      },
      child: Row(
        key: _globalKeyContract,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: AppValues.defaultPadding, bottom: AppValues.defaultPadding),
            decoration: BoxDecoration(
                color: ThemeService().colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: Row(
              children: [
                Obx(() {
                  return Container(
                    constraints: BoxConstraints(maxWidth: Get.width / 2 - 80),
                    child: CustomText(
                      controller.chSelBean.value.name ?? "",
                      style: ThemeService()
                          .theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ).marginOnly(left: 10, right: 5),
                  );
                }),
                Obx(() {
                  return CustomNetWorkImage(
                    fit: BoxFit.fitWidth,
                    placeholder: const CustomAssetIcon(
                      name: 'assets/images/personal_center_icon/pay_default_ic.webp',
                    ),
                    errorWidget: const CustomAssetIcon(
                      name: 'assets/images/personal_center_icon/pay_default_ic.webp',
                    ),
                    width: 18,
                    height: 18,
                    imageUrl:
                        "${controller.payIcDomain}${controller.getChlIc(controller.pwySelBean.value)}${controller.chSelBean.value.alias}${controller.coinIcExtensionName}",
                  );
                }).marginOnly(right: 2),
                Visibility(
                  visible: controller.currSelChList.length != 1,
                  child: RotatingArrow(
                    key: _rotatingContractArrowKey,
                  ),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _selectPaymentType(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: getWalletHeight(0.4)),
      child: SingleChildScrollView(
        child: Column(
          children: controller.currSelChList.map((channelBean) {
            return InkWell(
                onTap: () {
                  Get.back();
                  controller.saveSelectedPaymentChannel(channelBean);
                },
                child: Container(
                    height: 33,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        CustomNetWorkImage(
                          fit: BoxFit.fitWidth,
                          placeholder: const CustomAssetIcon(
                            name: 'assets/images/personal_center_icon/pay_default_ic.webp',
                          ),
                          errorWidget: const CustomAssetIcon(
                            name: 'assets/images/personal_center_icon/pay_default_ic.webp',
                          ),
                          imageUrl:
                              "${controller.payIcDomain}${controller.getChlIc(controller.pwySelBean.value)}${channelBean.alias}${controller.coinIcExtensionName}",
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        CustomText(
                          channelBean.name ?? "",
                          style: TextStyle(
                              color: channelBean.isSelect ?? false
                                  ? Colors.blue
                                  : ThemeService().colorScheme.surface),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )));
          }).toList(),
        ),
      ),
    );
  }

  double getWalletHeight(double ratio) {
    double? totalHeight;
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox = rootViewGlobalKey.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    totalHeight = size.height;
    return totalHeight / ratio;
  }
}
