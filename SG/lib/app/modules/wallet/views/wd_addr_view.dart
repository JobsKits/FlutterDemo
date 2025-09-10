import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/controllers/withdraw_ctrl.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/wallet/CoinBean.dart';
import '../../../../pages/personal_center/wallet/delete_address.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/input/custom_main_text_field.dart';

class WdAdrView extends GetView<WithDrawCtrl> {
  var _context;

  @override
  Widget build(BuildContext context) {
    return _rootView(context);
  }

  final GlobalKey _globalKeyInput = GlobalKey();

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  Widget _rootView(BuildContext context) {
    _context = context;
    return Column(
      children: [
        CustomAsterisksTipsText(
          text: S.current.random_text_1141,
          textStyle: TextStyle(fontWeight: FontWeight.w600),
        ),
        _selectAddress(S.current.fiat_currency_select_the_payment_bank, context).marginOnly(top: 5)
      ],
    );
  }

  Widget _selectAddress(String hintStr, BuildContext context) {
    return Stack(
      children: [
        GestureDetector(onTap: () {
          if (controller.previousBottomInset > 0) {
            FocusScope.of(Get.context!).requestFocus(FocusNode());
          } else {
            _startAnimation(_rotatingArrowKey);
            DialogUtils.showCustomBubbleDialog(
              context, _selectAddressType(), _getInputWidth(),
              widgetKey: _globalKeyInput,
              backgroundColor: AppThemes.widgetColorWhite,
              bubbleArrowHeight: 6,
              bubbleArrowWidth: 10,
              globalKey: _rotatingArrowKey,
              // arrowBasisOffset: -120.0
            );
          }
        }, child: Obx(() {
          return Column(
            children: [
              CustomMainTextField(
                contentPadding: const EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                  left: AppValues.defaultPadding,
                  right: 30,
                ),
                errorText: S.current.vault_this_field_is_required,
                showError: controller.curSelAdrShowErr.value,
                text:
                    // "\t\t\t\t\t${controller.wdArdSelBean.value.address}",
                    controller.wdArdSelBean.value.address,
                enabled: false,
                key: _globalKeyInput,
              ),
              // Visibility(
              //     visible: controller.curSelAdrShowErr.value,
              //     child: Container(
              //         margin: const EdgeInsets.only(top: 4),
              //         child: CustomErrorTipsText(
              //           textStyle: ThemeService().textTheme.bodyMedium?.copyWith(
              //               fontWeight: FontWeight.w500, color: ThemeService().colorScheme.error),
              //           text: S.current.vault_this_field_is_required,
              //         ))),
            ],
          );
        })),
        // Obx(() {
        //   return Visibility(
        //     visible: controller.wdArdSelBean.value.address.isNotEmpty,
        //     child: Positioned(
        //         left: 10,
        //         child: Container(
        //           height: AppValues.defaultTextHeight,
        //           margin: const EdgeInsets.only(right: 9),
        //           padding: const EdgeInsets.only(top: 10, bottom: 10),
        //           child: CustomNetWorkImage(
        //             imageUrl: controller.cryptoBeanSel.value.coinImgUrl??"",
        //             width: 20,
        //           ),
        //         )),
        //   );
        // }),
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

  Widget _selectAddressType() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (controller.wdAdrList.isNotEmpty)
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.wdAdrList.length + 1,
                itemBuilder: (context, index) {
                  if (index < controller.wdAdrList.length) {
                    return _addressItem(controller.wdAdrList[index]);
                  } else {
                    return InkWell(
                      onTap: () => controller.saveWithdrawInfo(),
                      child: controller.wdAdrList.length >= controller.cardMaxNum
                          ? const SizedBox().marginOnly(bottom: 16)
                          : CustomText(
                              S.current.random_text_1315,
                              textColorStyle: CustomTextColorStyle.blue,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ).marginOnly(top: 16, bottom: 16),
                    );
                  }
                },
              )
            else
              SizedBox(
                height: 60,
                child: Center(
                    // child: CustomText(
                    //   S.current.random_text_657,
                    //   textColorStyle: CustomTextColorStyle.dark,
                    // ),
                    ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _addressItem(CoinBean coinBean) {
    return GestureDetector(
      onTap: () {
        controller.saveAdr(coinBean);
      },
      child: Container(
        // color: coinBean.isSelect == true ? ThemeService().colorScheme.primary : Colors.transparent,
        color: Colors.transparent,
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Row(
          mainAxisAlignment:
              (coinBean.uid ?? "").isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 10,
            ),
            // CustomNetWorkImage(
            //   width: 18,
            //   height: 18,
            //   // color: AppThemes.widgetColorWhite.withOpacity( coinBean.state==2?0.5:1),
            //   imageUrl:controller.cryptoBeanSel.value.coinImgUrl??"",
            // ),
            // SizedBox(
            //   width: (coinBean.uid ?? "").isNotEmpty ? 12 : 0,
            // ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Opacity(
                    opacity: coinBean.state == 2 ? 0.5 : 1,
                    child: CustomText(
                      textColorStyle: coinBean.isSelect ?? false
                          ? CustomTextColorStyle.blue
                          : CustomTextColorStyle.dark,
                      coinBean.address ?? "",
                      // style: ThemeService().theme.textTheme.bodyMedium?.copyWith(color: AppThemes.widgetColorWhite.withOpacity(coinBean.state == 2 ? 0.5 : 1)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomText(
                    coinBean.state == 2 ? "停用" : "",
                    style: const TextStyle(color: AppThemes.reverseStateColor, fontSize: 12),
                  ),
                ],
              ),
            ),

            const Spacer(),
            InkWell(
              onTap: () {
                if (coinBean.state == 2) {
                  return;
                }
                controller.saveWithdrawInfo(id: coinBean.id);
              },
              child: Opacity(
                opacity: coinBean.state == 2 ? 0.5 : 1,
                child: const CustomAssetIcon(
                  name: "assets/images/edit.png",
                ),
              ),
            ),
            const SizedBox(
              width: 18,
            ),
            InkWell(
              onTap: () {
                RouteUtil.popView();
                coinBean.name = controller.getMergerSelCoin(controller.wdFiatCurrTabSel.value).name;
                showCustomDeleteAddressWidget(
                    context: _context,
                    fiatCurrency: controller.wdFiatCurrTabSel.value,
                    currencyId: controller.getMergerSelId(controller.wdFiatCurrTabSel.value),
                    subData: coinBean.toJson());
              },
              child: const CustomAssetIcon(
                name: "assets/images/deletev2.png",
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     CustomText(
            //       textColorStyle: coinBean.isSelect == true ?CustomTextColorStyle.blue: CustomTextColorStyle.dark,
            //       coinBean.address ?? "",
            //       // style: ThemeService().theme.textTheme.bodyMedium?.copyWith(color: AppThemes.widgetColorWhite.withOpacity(coinBean.state == 2 ? 0.5 : 1)),
            //     ),
            //   ],
            // )
          ],
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
