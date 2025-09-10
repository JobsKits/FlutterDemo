import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_images.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/theme/custom_text_theme.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:get/get.dart';
import 'controller.dart';


class OffersPage extends BaseView<OffersController> {
  OffersPage({Key? key}) : super(key: key);

  final colorScheme = ThemeService().colorScheme;
  final textTheme   = ThemeService().theme.textTheme;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: S.current.offers,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder<OffersController>(init: OffersController(), id: "Offers_index", builder: (_){
      return Material(
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: _buildView().paddingBottom(MediaQuery.of(Get.context!).viewInsets.bottom),
          )
      );
    });
  }


  // 主视图
  Widget _buildView() {

    final titleStyle = textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);
    final bodyStyle  = textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400,
        color: CustomTextColorStyle.grey.value);

    return <Widget>[
      // const SizedBox(height: AppValues.defaultPadding),
      // _buildTitle().marginSymmetric(horizontal: AppValues.defaultMargin),
      const SizedBox(height: AppValues.defaultPadding),
      // Divider(height: 1, color: colorScheme.tertiary),
      <Widget>[
        const SizedBox(height: AppValues.defaultPadding),
        CustomText(S.current.offers_welcome_offer, style: titleStyle),
        const SizedBox(height: AppValues.defaultPadding),
        CustomText(S.current.offers_welcome_offer_body, style: bodyStyle),
        const SizedBox(height: AppValues.defaultPadding),
        CustomText(S.current.offers_code, style: bodyStyle),
        const SizedBox(height: AppValues.smallPadding),
        CustomMainTextField(inputCallBack: controller.offerCodeChange),
        const SizedBox(height: AppValues.defaultPadding),
        CustomBigMainButton(title:S.current.submit_text, onTap: controller.offerCodeSubmit),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .marginSymmetric(horizontal: AppValues.defaultMargin),
      const SizedBox(height: AppValues.defaultPadding),

      Divider(height: 1, color: colorScheme.tertiary),
      <Widget>[
        const SizedBox(height: AppValues.defaultPadding),
        CustomText(S.current.offerrs_redeem_bonus_drop, style: titleStyle),
        const SizedBox(height: AppValues.defaultPadding),
        CustomText(S.current.offers_redeem_body, style: bodyStyle),
        const SizedBox(height: AppValues.defaultPadding),
        CustomText(S.current.offers_code, style: bodyStyle),
        const SizedBox(height: AppValues.smallPadding),
        CustomMainTextField(inputCallBack: controller.redeemBonusDropCodeChange),
        const SizedBox(height: AppValues.defaultPadding),
        CustomBigMainButton(title:S.current.submit_text, onTap:controller.redeemBonusDropCodeSubmit),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .marginSymmetric(horizontal: AppValues.defaultMargin),
      const SizedBox(height: AppValues.defaultMargin),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
        .backgroundColor(ThemeService().theme.scaffoldBackgroundColor)
        .clipRRect(all: AppValues.smallRadius);
  }

  /// 构建title
  Widget _buildTitle() {
    return <Widget>[
      const CustomIcon(asset: 'assets/images/personal_center_icon/preferential_exchange.webp'),
      const SizedBox(width: AppValues.extraSmallMargin),
      CustomText(S.current.offers, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500)),
      const Spacer(),
      const CustomIcon(asset: 'assets/images/normal/ic_normal_close.png',).onTap(() {RouteUtil.popView();})
    ].toRow();
  }
}
