import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/pages/personal_center/wallet/auth_widget.dart';
import 'package:flutter_bet/utils/vault_util.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import '../../../../constant/app_values.dart';
import '../../../../routes/routes.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../delete_address.dart';
import 'index.dart';

class CardsPage extends GetView<CardsController> {
  const CardsPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() => controller.cardsList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
                  child: Column(
                    children: [
                      Column(
                          children:
                              controller.cardsList.map((element) => _cards(element)).toList()),
                      Obx(() => controller.cardsList.length < controller.maxLength.value
                          ? _button()
                          : Container()),
                      _tipsText(),
                    ],
                  ))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
                  child: Column(
                    children: [
                      _tips(),
                      _button(),
                    ],
                  ))),
          Visibility(
              visible: VaultUtil.isSecretNot() && !VaultUtil.isEmailCheckStateNotBind(),
              child: const AuthWidget())
        ],
      ),
    );
  }

  Widget _tips() {
    return Container(
      margin: const EdgeInsets.only(top: AppValues.defaultMargin),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/personal_center_icon/wallet/cards_tips_bg.png'),
              fit: BoxFit.fill)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 25,bottom: 25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3, right: 6,left: 4),
                child: Image.asset('assets/images/personal_center_icon/wallet/cards_warning.png', width: 16),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: AppValues.margin_12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(S.current.random_text_645c1,textColorStyle: CustomTextColorStyle.secondary,style: const TextStyle(fontWeight: FontWeight.w500),),
                      CustomText(S.current.random_text_645c2,textColorStyle: CustomTextColorStyle.secondary,style: const TextStyle(fontWeight: FontWeight.w500),),
                      CustomText(S.current.random_text_645c3,textColorStyle: CustomTextColorStyle.secondary,style: const TextStyle(fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 2,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _button() {
    return Padding(
      padding: const EdgeInsets.only(top: AppValues.margin_14),
      child: Obx(() => CustomBigMainButton(
            colorStyle: CustomButtonColorStyle.tertiary,
            onTap: (btnCtr) {
              if (  VaultUtil.isPayPasswordNotSetting() &&
                  (!VaultUtil.isPayPassword() && VaultUtil.isSecretNot())) {
                GlobalState.instance.index = 8;
                RouteUtil.pushToView(Routes.setupPage, offLast: true, arguments: {'pageIndex': 1});
                return;
              }
              controller.onTap();
            },
            title: controller.walletCtrl.currencyWithdrawalSelectCoinAndAmountId.value == '702'
                ? S.current.random_text_646
                : controller.fiatCurrency
                    ? S.current.random_text_647
                    : S.current.random_text_648,
          )),
    );
  }

  Widget _cards(model) {
    return Opacity(
      opacity: model['state'] == 2 ? 0.5 : 1,
      child: Container(
        margin: const EdgeInsets.only(top: AppValues.margin_14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                color: AppThemes.surfaceVariant,
                alignment: Alignment.center,
                child: controller.fiatCurrency
                    ? CustomAssetIcon(
                        name: model['cur'] == '702'
                            ? "assets/images/personal_center_icon/pix_ic.webp"
                            : "assets/images/personal_center_icon/bank.webp",
                        size: 18,
                      )
                    : CustomNetWorkImage(
                        imageUrl: controller.walletCtrl.currencyWithdrawalSelectCoinIc.value,
                        width: 18,
                        height: 18,
                      ),
              ),
              Expanded(
                  child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: AppValues.margin_14),
                color: ThemeService().colorScheme.tertiary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.fiatCurrency
                          ? [
                              CustomText(
                                model['bankName'],
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              CustomText(
                                model['bankAccount'],
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              )
                            ]
                          : [
                              CustomText(
                                model['contract_name'],
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              CustomText(
                                model['address'],
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              )
                            ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // 删除银行卡地址
                        showCustomDeleteAddressWidget(
                            context: Get.context!,
                            subData: model,
                            fiatCurrency: controller.fiatCurrency,
                            currencyId: model['id']);
                      },
                      child: Image.asset(
                        'assets/images/personal_center_icon/wallet/cards_delete.png',
                        height: 20,
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _tipsText() {
    return Container(
      margin: const EdgeInsets.only(top: AppValues.margin_14),
      child: CustomText(
        S.current.random_text_649,
        textColorStyle: CustomTextColorStyle.secondary,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardsController>(
      init: CardsController(),
      id: "cards",
      builder: (_) {
        return Scaffold(
          body: _buildView(),
        );
      },
    );
  }
}
