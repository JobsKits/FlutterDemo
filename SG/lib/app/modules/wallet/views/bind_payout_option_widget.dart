import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/binding_bank_card/controllers/binding_bank_card_controller.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/wallet/TypeBean.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/input/custom_main_text_field.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../controllers/bind_info_config.dart';

class BindPayoutOptionWidget extends GetView<BindingBankCardController> {
  final BindInfoConfig flag;

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final GlobalKey _globalKeyInput = GlobalKey();

  BindPayoutOptionWidget(this.flag, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAsterisksTipsText(
          text: _getTitle(),
        ),
        SizedBox(width: double.infinity, child: _selectOptions(context, _rotatingArrowKey))
            .marginOnly(top: 4),
      ],
    );
  }

  Widget _selectOptions(
    BuildContext context,
    GlobalKey<RotatingArrowState> arrow,
  ) {
    return Stack(
      children: [
        GestureDetector(onTap: () {
          _startAnimation(arrow);
          DialogUtils.showCustomBubbleDialog(context, Obx(() {
            return _options(context);
          }), _getInputWidth(),
              widgetKey: _globalKeyInput,
              backgroundColor: AppThemes.widgetColorWhite,
              bubbleArrowHeight: 8,
              bubbleArrowWidth: 8,
              globalKey: arrow);
        }, child: Obx(() {
          return _showText();
        })),
        Positioned(
            right: 0,
            child: Container(
              height: AppValues.defaultTextHeight,
              margin: const EdgeInsets.only(right: 9),
              child: RotatingArrow(
                key: arrow,
              ),
            ))
      ],
    );
  }

  Widget _options(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      child: Scrollbar(
        controller: controller.scrollController, // Provide a ScrollController
        radius: const Radius.circular(10),
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            children: _getData().map((bean) {
              return _getItem(bean);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _optionsItem(TypeBean model) {
    return GestureDetector(
      onTap: () {
        controller.withDrawCtrl.savePayoutOption(model);
        controller.resetData();
        RouteUtil.popView();
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        // color: model.isSelect ? AppThemes.textColorSecondary : Colors.transparent,
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            CustomNetWorkImage(
              fit: BoxFit.fitWidth,
              placeholder: const CustomAssetIcon(
                name: 'assets/images/personal_center_icon/pay_default_ic.webp',
              ),
              errorWidget: const CustomAssetIcon(
                name: 'assets/images/personal_center_icon/bank.webp',
              ),
              width: 14,
              height: 14,
              imageUrl: "${AppValues.defaultBranch.asset_url}/payment/deposit/${model.alias}.webp",
            ),
            const SizedBox(
              width: 6,
            ),
            CustomText(
              model.name,
              style: ThemeService().theme.textTheme.bodyMedium?.copyWith(color: AppThemes.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bankItem(dynamic model) {
    return GestureDetector(
      onTap: () {
        for (int i = 0; i < controller.curSelectBankList.length; i++) {
          controller.curSelectBankList[i]['isSelect'] = false;
        }
        var isSelect = model['isSelect'] ?? false;
        model['isSelect'] = isSelect ? false : true;
        controller.curSelectBankList.refresh();
        controller.curSelectBank.value = model['name'] ?? "";
        controller.bankId.value = model['id'] ?? "";
        controller.curSelectBankShowError.value =
            controller.assertField(controller.curSelectBank.value);

        RouteUtil.popView();
      },
      child: Container(
        color: model['isSelect'] == true ? AppThemes.textColorSecondary : Colors.transparent,
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 10,
            ),
            CustomNetWorkImage(
              fit: BoxFit.fitWidth,
              placeholder: const CustomAssetIcon(
                name: 'assets/images/personal_center_icon/pay_default_ic.webp',
              ),
              errorWidget: const CustomAssetIcon(
                name: 'assets/images/personal_center_icon/bank.webp',
              ),
              width: 24,
              height: 24,
              imageUrl: "${controller.globalController.bnkDomain}${model['id']}.webp",
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "${model['name'] ?? ""}",
                  style:
                      ThemeService().theme.textTheme.bodyMedium?.copyWith(color: AppThemes.black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _walletItem(dynamic model) {
    return GestureDetector(
      onTap: () {
        for (int i = 0; i < controller.curSelectWalletList.length; i++) {
          controller.curSelectWalletList[i]['isSelect'] = false;
        }
        model['isSelect'] = !model['isSelect'];
        controller.curSelectWalletList.refresh();
        controller.curSelectBank.value = model['name'] ?? "";
        controller.bankId.value = model['id'] ?? "";
        controller.curSelectBankShowError.value =
            controller.assertField(controller.curSelectBank.value);
        RouteUtil.popView();
      },
      child: Container(
        color: model['isSelect'] == true ? AppThemes.textColorSecondary : Colors.transparent,
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SizedBox(
            //   width: bubbleWidth / 2 - 31,
            // ),
            const SizedBox(
              width: 10,
            ),
            // const CustomAssetIcon(
            //   // color: Colors.black,
            //   name: "assets/images/personal_center_icon/bank.webp",
            //   size: 18,
            // ),
            // CustomNetWorkImage(
            //   fit: BoxFit.fitWidth,
            //   placeholder: const CustomAssetIcon(
            //     name: 'assets/images/personal_center_icon/pay_default_ic.webp',
            //   ),
            //   errorWidget: const CustomAssetIcon(
            //     name: 'assets/images/personal_center_icon/bank.webp',
            //   ),
            //   width: 24,
            //   height: 24,
            //   imageUrl: "${controller.globalController.bnkDomain}${model['id']}.webp",
            // ),
            const SizedBox(
              width: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "${model['name'] ?? ""}",
                  style:
                      ThemeService().theme.textTheme.bodyMedium?.copyWith(color: AppThemes.black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    switch (flag) {
      case BindInfoConfig.payoutOptions:
        return S.current.withdraw_money_type;
      case BindInfoConfig.selectBank:
        return S.current.wallet_bankSelection;
      case BindInfoConfig.selectWallet:
        return S.current.random_text_1308;
      default:
        return S.current.random_text_1309;
    }
  }

  List<dynamic> _getData() {
    switch (flag) {
      case BindInfoConfig.payoutOptions:
        return controller.withDrawCtrl.payoutOptions;
      case BindInfoConfig.selectBank:
        return controller.curSelectBankList;
      case BindInfoConfig.selectWallet:
        return controller.curSelectWalletList;
      default:
        return [];
    }
  }

  Widget _getItem(dynamic bean) {
    switch (flag) {
      case BindInfoConfig.payoutOptions:
        return _optionsItem(bean);
      case BindInfoConfig.selectBank:
        return _bankItem(bean);
      case BindInfoConfig.selectWallet:
        return _walletItem(bean);
      default:
        return const SizedBox();
    }
  }

  Widget _showText() {
    switch (flag) {
      case BindInfoConfig.payoutOptions:
        return CustomMainTextField(
          text: controller.withDrawCtrl.payoutOptionBean.value.name,
          errorText: controller.showTextOption.value,
          showError: controller.showErrorOptionName.value,
          enabled: false,
          key: _globalKeyInput,
        );
      case BindInfoConfig.selectBank:
        return Stack(
          children: [
            CustomMainTextField(
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: controller.curSelectBank.value.isNotEmpty
                      ? AppThemes.textColorWhite
                      : AppThemes.walletHintColor),
              errorText: controller.bankErrorText.value,
              showError: controller.curSelectBankShowError.value,
              text:
                  "${controller.curSelectBank.value.isEmpty ? S.current.wallet_bankSelection : "\t\t\t\t\t\t${controller.curSelectBank.value}"}",
              enabled: false,
              key: _globalKeyInput,
            ),
            Visibility(
              visible: controller.curSelectBank.value.isEmpty ? false : true,
              child: Positioned(
                  left: 10,
                  child: Container(
                    height: AppValues.defaultTextHeight,
                    margin: const EdgeInsets.only(right: 9),
                    child: Visibility(
                      child: CustomNetWorkImage(
                        fit: BoxFit.fitWidth,
                        placeholder: const CustomAssetIcon(
                          name: 'assets/images/personal_center_icon/pay_default_ic.webp',
                        ),
                        errorWidget: const CustomAssetIcon(
                          name: 'assets/images/personal_center_icon/bank.webp',
                        ),
                        width: 14,
                        height: 14,
                        imageUrl:
                            "${AppValues.defaultBranch.asset_url}/webp/bank/${controller.bankId.value}.webp",
                      ),
                    ),
                  )),
            )
          ],
        );
      case BindInfoConfig.selectWallet:
        return CustomMainTextField(
          textColor: controller.curSelectBank.value.isNotEmpty
              ? AppThemes.textColorWhite
              : AppThemes.hintTextColorWhite,
          errorText: S.current.random_text_1310,
          showError: controller.curSelectBankShowError.value,
          text:
              controller.curSelectBank.value.isEmpty ? S.current.random_text_1308 : controller.curSelectBank.value,
          enabled: false,
          key: _globalKeyInput,
        );
      default:
        return const SizedBox();
    }
  }

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  double _getInputWidth() {
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox = _globalKeyInput.currentContext?.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    return size.width;
  }
}
