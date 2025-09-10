import 'package:flutter/material.dart';
import 'package:flutter_bet/model/wallet/CurrencyBean.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/button/custom_small_mian_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../routes/routes.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_big_outline_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_back_icon_button.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/network_image/custom_network_image_placeholder.dart';
import '../../commission_conversion/views/commission_conversion_view.dart';
import '../controllers/commission_wallet_controller.dart';

class CommissionWalletView extends GetView<CommissionWalletController> {
  const CommissionWalletView({Key? key}) : super(key: key);

  static openPage() {
    RouteUtil.pushToView(Routes.commissionWallet);
  }

  @override
  Widget build(BuildContext context) {
    return _buildView(context);
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackIconButton(
          style: CustomBackIconButtonStyle.normal,
        ),
        title: Text(S.current.random_text_516,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
      body: _buildView(context),
    );
  }

  Widget _buildView(BuildContext context) {
    return Obx(() {
      return controller.coinData.isEmpty
          ? SizedBox(
              height: 150,
              child: CustomNetWorkImagePlaceholder(
                color: AppThemes.surfaceVariant.withOpacity(0),
                placeholderType: NetWorkImagePlaceholderType.loading,
              ))
          : _buildBodyV2(context);
    });
  }

  // Widget _buildBody() {
  //   return Column(
  //     children: [
  //       const SizedBox(height: 24,),
  //       _buildTop(),
  //       const SizedBox(height: 28,),
  //       CustomText("币种列表"),
  //       const SizedBox(height: 16,),
  //       _buildCoinList(),
  //       _buildBottom(),
  //       const SizedBox(height: 24,),
  //
  //     ],
  //   );
  // }
  Widget _buildBodyV2(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildCoinList(),
          Container(
              child: CustomBigMainButton(
                title: S.current.random_text_758,
                colorStyle: CustomButtonColorStyle.tertiary,
                onTap: (btr) {
                  controller.withdrawalCommission(context, btr);
                  },
          )),
          const SizedBox(height: 14),
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: CustomText(S.current.random_text_759,
                  textAlign: TextAlign.center,
                  textColorStyle: CustomTextColorStyle.normal,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 12),
        CustomText(S.current.random_text_760),
        // Obx(() {
        //   return CustomText(
        //     "${controller.totalAmount.value}", textColorStyle: CustomTextColorStyle.orange,);
        // }),
        SizedBox(width: 4),
        CustomAssetIcon(name: "assets/images/personal_center_icon/ic_usdt.webp", size: 14),
        Spacer(),
        Container(
            margin: EdgeInsets.only(right: 12),
            child: CustomSmallMainButton(
              onTap: () {
                CommissionConversionView.openPage();
              },
              title: S.current.random_text_761,
              // contentPaddingTopAndBottom: 5,
              padding: const EdgeInsets.symmetric(vertical: 5),
            ))
      ],
    );
  }

  _buildCoinList() {
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.coinData.length + 1,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                height: 54,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.only(right: 24),
                        alignment: Alignment.centerRight,
                        // width: 200,
                        child: CustomText(
                          S.current.random_text_200,
                          textColorStyle: CustomTextColorStyle.normal,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.only(right: 36),
                        alignment: Alignment.centerRight,
                        // width: 100,
                        child: CustomText(S.current.alliance_commission,
                            textColorStyle: CustomTextColorStyle.normal,
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    // SizedBox(width: 60,),
                    // CustomText(S.current.random_text_200,textColorStyle: CustomTextColorStyle.normal,style: TextStyle(fontWeight: FontWeight.w600),),
                    // Spacer(),
                    // CustomText(S.current.alliance_commission,textColorStyle: CustomTextColorStyle.normal,style: TextStyle(fontWeight: FontWeight.w600)),
                    // SizedBox(width: 80,),
                  ],
                ),
              );
            } else {
              return _coinListItem(index - 1, controller.coinData[index - 1]);
            }
          },
        ),
      );
    });
  }

  Widget _coinListItem(int index, CurrencyBean model) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: index % 2 == 0
            ? ThemeService().colorScheme.surfaceVariant
            : ThemeService().theme.scaffoldBackgroundColor,
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // //https://jira.vgtech.org/browse/STAK-2455
                // CustomText(
                //   '${model.symbol}',
                //   style: ThemeService().textTheme.bodyMedium,
                // ),
                CustomText(
                  '${model.uid}',
                  style: ThemeService().textTheme.labelLarge,
                ),
                const SizedBox(width: AppValues.margin_4),
                CustomNetWorkImage(imageUrl: "${model.coinIc}", width: 16, height: 16,showErrorMsg: false,),
                const SizedBox(width: 24),
                // Spacer(),
                //https://jira.vgtech.org/browse/STAK-2455
                // CustomText(
                //   '${model.symbol}',
                //   style: ThemeService().textTheme.bodyMedium,
                // ),
              ],
            ),
          ),
          Spacer(),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  '${model.amount}',
                  style: ThemeService().textTheme.labelLarge,
                ),
                const SizedBox(width: AppValues.margin_4),
                CustomNetWorkImage(imageUrl: "${model.coinIc}", width: 16, height: 16,showErrorMsg: false,),
                const SizedBox(width: 24),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildBottom() {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12),
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: CustomBigMainButton(
            title: S.current.random_text_762,
            onTap: (btr) {},
          )),
          const SizedBox(
            width: AppValues.defaultMargin,
          ),
          Expanded(
            child: CustomBigOutlineButton(
              onTap: (btr) {},
              title: S.current.vault_withdraw_money,
              lineColor: ThemeService().colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
