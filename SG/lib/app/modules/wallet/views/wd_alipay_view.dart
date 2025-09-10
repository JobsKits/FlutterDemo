import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/controllers/withdraw_ctrl.dart';
import 'package:flutter_bet/app/modules/wallet/views/unbound_withdraw_info.dart';
import 'package:flutter_bet/app/modules/wallet/views/wd_fiatcurr_amt.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../pages/personal_center/wallet/auth_widget.dart';
import '../../../../utils/route_util.dart';
import '../../../../utils/vault_util.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/input/custom_main_text_field.dart';

class WdAliPayView extends GetView<WithDrawCtrl> {
  @override
  Widget build(BuildContext context) {
    return _rootView(context);
  }

  var _context;
  var list;

  final GlobalKey _globalKeyInput = GlobalKey();

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  Widget _rootView(BuildContext context) {
    _context = context;
    list = controller.aliPay;
    if (list.isNotEmpty) {
      controller.bnkNameBean.value = list[0];
      controller.saveBnk(list[controller.bnkPos.value]['accountInfo'][0], list);
    }

    return list.isEmpty ? UnboundWithdrawInfo() : fiat(context);
  }

  Widget fiat(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            CustomAsterisksTipsText(
              text: S.current.random_text_447,
              textStyle: TextStyle(fontWeight: FontWeight.w600),
            ).marginOnly(top: 16),
            Obx(() {
              return _selectAli(S.current.fiat_currency_select_the_payment_bank, context);
            }).marginOnly(top: 5),
            // PayoutOptionsView(),
            // _payoutView(),
            // WdBnkView(),
            WdFiatCurrAmt(),
            // PassWordView(),
            CustomBigMainButton(
              colorStyle: CustomButtonColorStyle.tertiary,
              onTap: (buttonCtr) {
                controller.onClickWd(context);
              },
              title: S.current.random_text_1316,
              fontWeight: FontWeight.w600,
            ).marginOnly(top: 16, bottom: 16),
          ],
        ).marginOnly(left: 16, right: 16),
        Visibility(
            visible: VaultUtil.isSecretNot() && !VaultUtil.isEmailCheckStateNotBind(),
            child: const AuthWidget())
      ],
    );
  }

  Widget _selectAli(String hintStr, BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (controller.previousBottomInset > 0) {
              FocusScope.of(Get.context!).requestFocus(FocusNode());
            } else {
              _startAnimation(_rotatingArrowKey);
              DialogUtils.showCustomBubbleDialog(
                context, _selectAliType(), _getInputWidth(),
                widgetKey: _globalKeyInput,
                backgroundColor: AppThemes.widgetColorWhite,
                bubbleArrowHeight: 6,
                bubbleArrowWidth: 10,
                globalKey: _rotatingArrowKey,
                // arrowBasisOffset: -120.0
              );
            }
          },
          child: Column(
            children: [
              CustomMainTextField(
                errorText: controller.getMergerSelId(controller.fiatCurrTabSel.value) == "702"
                    ? S.current.random_text_1188
                    : S.current.random_text_1189,
                showError: controller.curSelBnkShowErr.value,
                text: "\t\t\t\t\t${controller.bnkNameBean['bankName'] ?? ""}",
                enabled: false,
                key: _globalKeyInput,
              ),
            ],
          ),
        ),
        Positioned(
            left: 10,
            child: SizedBox(
              height: AppValues.defaultTextHeight,
              child: CustomNetWorkImage(
                  fit: BoxFit.fitWidth,
                  placeholder: CustomAssetIcon(
                    name: controller.defCoin,
                  ),
                  errorWidget: CustomAssetIcon(
                    name: controller.defCoin,
                  ),
                  width: 18,
                  height: 18,
                  imageUrl:
                  "${controller.globalController.bnkDomain}${controller.bnkSelBean.value
                      .bank_id}${controller.coinIcExtensionName}"),
            )),
        Positioned(
            right: 0,
            child: Container(
              height: AppValues.defaultTextHeight,
              margin: const EdgeInsets.only(right: 9),
              child: RotatingArrow(
                key: _rotatingArrowKey,
              ),
            ))
      ],
    );
  }

  Widget _selectAliType() {
    return Column(
      children: [
        if (list.isNotEmpty)
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _aliItem(list[index], index),
              );
            },
          )
        else
          SizedBox(
            height: 60,
            child: Center(
              child: CustomText(
                S.current.random_text_1317,
                textColorStyle: CustomTextColorStyle.dark,
              ),
            ),
          ),
      ],
    );
  }

  Widget _aliItem(dynamic bankcardBean, int pos) {
    return GestureDetector(
      onTap: () {
        RouteUtil.popView();
        controller.saveBnkName(bankcardBean, pos, list);
      },
      child: Opacity(
        opacity: 1,
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              CustomNetWorkImage(
                  fit: BoxFit.fitWidth,
                  placeholder: CustomAssetIcon(
                    name: controller.defCoin,
                  ),
                  errorWidget: CustomAssetIcon(
                    name: controller.defCoin,
                  ),
                  width: 18,
                  height: 18,
                  imageUrl:
                  "${controller.globalController.bnkDomain}${bankcardBean['bankId']}${controller
                      .coinIcExtensionName}"),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                bankcardBean['bankName'],
                textColorStyle: CustomTextColorStyle.dark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getInputWidth() {
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox = _globalKeyInput.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    return size.width;
  }
}
