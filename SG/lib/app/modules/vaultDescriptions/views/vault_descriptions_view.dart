import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../constant/app_values.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../routes/routes.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_back_icon_button.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/status/custom_load_state_view.dart';
import '../../../../widget/status/load_state_config.dart';
import '../controllers/vault_descriptions_controller.dart';

class VaultDescriptionsView extends GetView<VaultDescriptionsController> {
  VaultDescriptionsView({Key? key}) : super(key: key);

  static openPage() {
    RouteUtil.popView();
    RouteUtil.pushToView(Routes.vaultDescriptionsView, notRepeat: false);
  }

  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey _globalKeyCoin = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackIconButton(
          style: CustomBackIconButtonStyle.normal,
        ),
        title: Text(S.current.random_text_767,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
      body: Obx(() => rootView()),
    );
  }

  Widget rootView() {
    return CustomLoadStateLayout(
      configType: LoadStateConfigType.def,
      configState: controller.viewState.value,
      showEmptyRetry: false,
      showErrorRetry: false,
      configSuccess: SingleChildScrollView(child: contentView()),
    );
  }

  Widget contentView() {
    return Column(
      key: _globalKey,
      children: [
        const SizedBox(
          height: 20,
        ),
        CustomText(
          S.current.random_text_1207,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        const SizedBox(
          height: 20,
        ),
        _topView(),
        _bodyView(),
        Container(
          margin: EdgeInsets.only(left: 12, right: 12, top: 16, bottom: AppValues.barBottomHeight),
          // child: InAppWebView(
          //   initialFile: 'assets/html/vault_des.html',
          //   initialOptions: InAppWebViewGroupOptions(
          //     crossPlatform: InAppWebViewOptions(transparentBackground: true),
          //   ),
          // ),
          child: Obx(() {
            return controller.ruleType.value == 1
                ? descView()
                : Html(
                    data: controller.contentText.value,
                  );
          }),
        )
        // controller.isLoading.value
        //     ? _buildShimmerView()
        //     : Expanded(
        //   child: Container(
        //     margin: EdgeInsets.only(
        //         left: 12, right: 12, top: 16, bottom: AppValues.barBottomHeight),
        //     // child: InAppWebView(
        //     //   initialFile: 'assets/html/vault_des.html',
        //     //   initialOptions: InAppWebViewGroupOptions(
        //     //     crossPlatform: InAppWebViewOptions(transparentBackground: true),
        //     //   ),
        //     // ),
        //     child: Obx(() {
        //       return controller.ruleType.value == 1
        //           ? SingleChildScrollView(child: descView())
        //           : Html(
        //         data: controller.contentText.value,
        //       );
        //     }),
        //   ),
        // )
      ],
    );
  }

  Widget _topView() {
    return Row(
      children: [
        Expanded(
            flex: LangUtil().isZhCn() ? 1 : 3,
            child: Container(
              alignment: Alignment.center,
              child: CustomText(
                "\t\t\t\t${S.current.random_text_560}",
                textColorStyle: CustomTextColorStyle.normal,
                textAlign: TextAlign.center,
              ),
            )),
        Expanded(
            flex: LangUtil().isZhCn() ? 1 : 3,
            child: Container(
              alignment: Alignment.center,
              child: CustomText(
                S.current.random_text_768,
                textColorStyle: CustomTextColorStyle.normal,
                textAlign: TextAlign.center,
              ),
            )),
        Expanded(
            flex: LangUtil().isZhCn() ? 1 : 3,
            child: Container(
              alignment: Alignment.center,
              child: CustomText(
                S.current.random_text_769,
                textColorStyle: CustomTextColorStyle.normal,
                textAlign: TextAlign.center,
              ),
            )),
      ],
    );
  }

  Widget _bodyView() {
    return Container(
      height: 56,
      margin: const EdgeInsets.only(top: 19, left: 12, right: 12),
      decoration: const BoxDecoration(
          color: AppThemes.surfaceVariant,
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          )),
      child: Row(
        children: [
          // Obx(() {
          //   return Expanded(
          //       flex: LangUtil().isZhCn()?1:3,
          //       child: Container(
          //     alignment: Alignment.center,
          //     child: CustomSelectCoinWidget(
          //       globalKeyS: _globalKey,
          //       bgColor: Colors.transparent,
          //       globalKeyWidget: _globalKeyCoin,
          //       bubbleWidth: 120,
          //       ratio: 1.9,
          //       dataList: controller.coinLists.value,
          //       contentBuilder: (context, bean) {
          //         return _depositView();
          //       },
          //       itemBuilder: (context, bean) {
          //         return _coinItem(bean);
          //       },
          //     ),
          //   ));
          // }),
          Obx(() {
            return Expanded(
                flex: LangUtil().isZhCn() ? 1 : 3,
                child: Container(
                  alignment: Alignment.center,
                  child: _depositView(),
                ));
          }),

          Obx(() {
            return Expanded(
                flex: LangUtil().isZhCn() ? 1 : 3,
                child: Container(
                    alignment: Alignment.center,
                    child: CustomText(
                        controller.getMinAnt(controller.selCoinBean['min_deposit'] ?? "-"))));
          }),
          Obx(() {
            return Expanded(
                flex: LangUtil().isZhCn() ? 1 : 3,
                child: Container(
                    margin: EdgeInsets.only(left: LangUtil().isZhCn() ? 20 : 0),
                    alignment: Alignment.center,
                    // child: CustomText(
                    //     "${double.parse(controller.selCoinBean['interest_rate'] ?? "0") * 100}%"));
                    child: CustomText(controller
                        .getAnnualInterestRate(controller.selCoinBean['interest_rate'] ?? "0"))));
          }),
        ],
      ),
    );
  }

  _depositView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // const SizedBox(
        //   width: AppValues.width_12,
        // ),
        Visibility(
          visible: controller.coinIc.value.isEmpty,
          child: const CustomAssetIcon(
            name: 'assets/images/personal_center_icon/currency_default_ic.webp',
          ),
        ),
        Visibility(
          visible: controller.coinIc.value.isNotEmpty,
          child: CustomNetWorkImage(
            imageUrl: controller.coinIc.value,
            width: 14,
            height: 14,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        CustomText(controller.coinName.value,
            style:
                ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _coinItem(CurrencyBean bean) {
    return CupertinoButton(
      minSize: 32.0,
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      onPressed: () {
        controller.coinFun(bean);
        Get.back();
      },
      child: Container(
        color: Colors.transparent,
        // padding: const EdgeInsets.only(top: AppValues.margin_6, bottom: AppValues.margin_6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(
            //   width: 100 / 2 - 31,
            // ),
            CustomNetWorkImage(
              width: 18,
              height: 18,
              imageUrl: bean.coinIc ?? "",
            ),
            const SizedBox(
              width: 8,
            ),
            CustomText(
              bean.name ?? "",
              style: ThemeService()
                  .theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: ThemeService().colorScheme.tertiary),
            ),
          ],
        ),
      ),
    );
  }

  // 骨架屏效果
  Widget _buildShimmerView() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: AppValues.defaultPadding),
        itemCount: 9,
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppThemes.chatRooCardColor,
              borderRadius: BorderRadius.circular(AppValues.smallRadius),
            ),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding)
                .copyWith(bottom: AppValues.defaultPadding),
            child: Column(
              children: [
                if (index == 0 || index == 2 || index == 4)
                  Shimmer.fromColors(
                      baseColor: AppThemes.chatRooCardColor,
                      highlightColor: AppThemes.textColorLightGrey,
                      child: Container(
                        width: double.infinity,
                        height: 20,
                        decoration: BoxDecoration(
                            color: AppThemes.chatRooCardColor,
                            borderRadius: BorderRadius.circular(3)),
                        margin: const EdgeInsets.only(left: 2, right: 180, bottom: 2),
                      )),
                if (index == 0 || index == 1 || index == 2 || index == 3 || index == 4)
                  Shimmer.fromColors(
                      baseColor: AppThemes.chatRooCardColor,
                      highlightColor: AppThemes.textColorLightGrey,
                      child: Container(
                        width: double.infinity,
                        height: 20,
                        decoration: BoxDecoration(
                            color: AppThemes.chatRooCardColor,
                            borderRadius: BorderRadius.circular(3)),
                        margin: const EdgeInsets.only(left: 2, right: 80, bottom: 2),
                      )),
                Shimmer.fromColors(
                    baseColor: AppThemes.chatRooCardColor,
                    highlightColor: AppThemes.textColorLightGrey,
                    child: Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(
                          color: AppThemes.chatRooCardColor,
                          borderRadius: BorderRadius.circular(3)),
                      margin: const EdgeInsets.only(left: 2, right: 20),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget descView() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 20, color: Colors.white),
        children: controller.parts.map<TextSpan>((part) {
          final splitIndex = part.indexOf('：');
          if (splitIndex != -1) {
            return TextSpan(
              children: [
                TextSpan(
                  text: part.substring(0, splitIndex + 1).contains("：")
                      ? part.substring(0, splitIndex + 1).replaceAll("：", "")
                      : part.substring(0, splitIndex + 1),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: "\n\n${part.substring(splitIndex + 1)}",
                  style: const TextStyle(
                      color: AppThemes.onTertiaryColor, fontWeight: FontWeight.w400, fontSize: 16),
                ),
                const TextSpan(
                  text: '\n\n',
                ),
              ],
            );
          } else {
            return TextSpan(
              text: '$part\n',
            );
          }
        }).toList(),
      ),
    );
  }
}
