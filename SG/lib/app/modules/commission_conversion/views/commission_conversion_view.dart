import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';

import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../pages/personal_center/wallet/widget/custom_select_coin_widget.dart';
import '../../../../routes/routes.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_back_icon_button.dart';
import '../../../../widget/network_image/custom_network_image_placeholder.dart';
import '../controllers/commission_conversion_controller.dart';

class CommissionConversionView extends GetView<CommissionConversionController> {
  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey _globalKeyCoin = GlobalKey();

  CommissionConversionView({Key? key}) : super(key: key);

  static openPage() {
    RouteUtil.pushToView(Routes.commissionConversionView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackIconButton(
          style: CustomBackIconButtonStyle.normal,
        ),
        title: Text(S.current.random_text_749,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
      body: _buildView(context),
    );
  }

  Widget _buildView(BuildContext context) {
    return Obx(() {
      return controller.modelList.isEmpty
          ? SizedBox(
              height: 150,
              child: CustomNetWorkImagePlaceholder(
                color: AppThemes.surfaceVariant.withOpacity(0),
                placeholderType: NetWorkImagePlaceholderType.loading,
              ))
          : _buildBody(context);
    });
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildTop(),
        const SizedBox(
          height: 12,
        ),
        const Divider(
          indent: 0,
          endIndent: 0,
          height: 2,
        ),
        const SizedBox(
          height: 16,
        ),
        _buildTopViewDown(),
        const SizedBox(
          height: 15,
        ),
        _buildBalanceAvailable(),
        _buildListTitle(),
        _buildListView(),
        _buildBottomView(context),
        SizedBox(height: 70),
      ],
    );
  }

  Widget _buildTop() {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 24,
          ),
          CustomText(S.current.random_text_750),
          Row(
            children: [
              Obx(() {
                return CustomText(
                  "${controller.totalAmount.value}",
                  textColorStyle: CustomTextColorStyle.orange,
                );
              }),
              SizedBox(
                width: 4,
              ),
              CustomAssetIcon(
                name: "assets/images/personal_center_icon/ic_usdt.webp",
                size: 14,
              ),
              SizedBox(
                width: 4,
              ),
              CustomText(S.current.random_text_751),
            ],
          )
        ],
      ),
    );
  }

  _buildTopViewDown() {
    return Row(
      key: _globalKey,
      children: [
        SizedBox(
          width: 12,
        ),
        CustomText(S.current.random_text_752),
        SizedBox(
          width: 8,
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: ThemeService().colorScheme.tertiary, width: 1),
              borderRadius: BorderRadius.all(
                Radius.circular(2),
              )),
          child: CustomSelectCoinWidget(
            globalKeyS: _globalKey,
            globalKeyWidget: _globalKeyCoin,
            bubbleWidth: 100,
            ratio: 0.15,
            dataList: controller.globalController.currTypeLists,
            contentBuilder: (context, bean) {
              return _depositView();
            },
            itemBuilder: (context, bean) {
              return _coinItem(bean);
            },
          ),
        ),
      ],
    );
  }

  _buildBalanceAvailable() {
    return Row(
      children: [
        SizedBox(
          width: 12,
        ),
        Container(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: S.current.random_text_753,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                TextSpan(
                  text: " ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                TextSpan(
                  text:
                      '${controller.totalAmount * controller.getSingleCurrentCurrencyExchangeRate(controller.coinId.value)}',
                  style: TextStyle(
                    color: Color(0xFFFF9800),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: AppValues.margin_2),
        CustomNetWorkImage(
          imageUrl: controller.coinIc.value,
          width: 14,
          height: 14,
        ),
      ],
    );
  }

  _buildListTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: AppValues.largePadding,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            S.current.random_text_102,
            style: ThemeService().textTheme.bodyMedium,
          ),
          const SizedBox(width: 40),
          CustomText(
            S.current.random_text_103,
            style: ThemeService().textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  _buildListView() {
    return Expanded(
      child: Container(
        child: Obx(() {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.modelList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return _item(index, controller.modelList[index]);
            },
          );
        }),
      ),
    );
  }

  Widget _item(int index, CurrencyBean model) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.defaultPadding,
        vertical: AppValues.largePadding,
      ),
      color: index % 2 == 0
          ? ThemeService().colorScheme.surfaceVariant
          : ThemeService().theme.scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomNetWorkImage(
            width: 18,
            height: 18,
            imageUrl: model.coinIc ?? "",
          ),
          SizedBox(width: AppValues.margin_8),
          CustomText(
            '${model.name}',
            style: ThemeService().textTheme.bodyMedium,
          ),
          SizedBox(width: AppValues.margin_8),
          CustomText(
            '${model.amount}',
            style: ThemeService().textTheme.bodyMedium,
          ),
          Spacer(),
          CustomText(
            '${model.uid}',
            style: ThemeService().textTheme.bodyMedium,
          ),
          SizedBox(width: AppValues.margin_20),
        ],
      ),
    );
  }

  _buildBottomView(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      child: CustomBigMainButton(
        title: S.current.random_text_754,
        isEnable: true,
        onTap: (btnController) {
          controller.agencyExchange(btnController, context);
        },
      ),
    );
  }

  _depositView() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: AppValues.width_12,
          ),
          // CustomNetWorkImage(
          //   imageUrl: controller.coinIc.value,
          //   width: 18,
          //   height: 18,
          // ),
          CustomText(controller.coinName.value,
              style:
                  ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(
            width: AppValues.margin_4,
          ),
        ],
      ),
    );
  }

  Widget _coinItem(CurrencyBean bean) {
    return GestureDetector(
      onTap: () {
        Get.back();
        controller.coinFun(bean, flag: 1);
        controller.saveSelected(bean);
      },
      child: Container(
        // color: controller.isSelectedItem(bean)
        //     ? ThemeService().colorScheme.primary
        //     : Colors.transparent,
        color: Colors.transparent,
        padding: const EdgeInsets.only(top: AppValues.margin_6, bottom: AppValues.margin_6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 100 / 2 - 31,
            ),
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
}
