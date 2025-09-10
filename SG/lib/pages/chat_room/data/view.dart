import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/statistical_data/controllers/statistical_data_controller.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import '../../../app/modules/statistical_data/views/statistical_data_view.dart';
import '../../../constant/app_themes.dart';
import '../../../model/statisical_data/StatisicalDataBean.dart';
import '../../../widget/custom_empty_widget.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../../../widget/network_image/custom_network_image_placeholder.dart';
import 'logic.dart';

class UserDataStatisticalWidget extends StatefulWidget {
  final double maxHeight;
  final String username;

  const UserDataStatisticalWidget({super.key, this.maxHeight = 330,this.username = ''});

  @override 
  UserDataStatisticalWidgetState createState() => UserDataStatisticalWidgetState();
}

class UserDataStatisticalWidgetState extends State<UserDataStatisticalWidget> {
  final controller = Get.put(StatisticalDataController());

  @override
  void dispose() {
    super.dispose();
    Get.delete<StatisticalDataController>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.maxHeight,
        child: StatisticalDataView(showAppBar: false,username:widget.username));
    // return Obx(() => controller.loadingData.value ? SizedBox(
    //   height: widget.maxHeight,
    //   child: CustomNetWorkImagePlaceholder(
    //     color: AppThemes.surfaceVariant.withOpacity(0),
    //     placeholderType: NetWorkImagePlaceholderType.loading,
    //   )
    // )
    // : _listView());
  }

  Widget _listView() {
    return SizedBox(
      height: widget.maxHeight,
      child: Obx(() => controller.statisticalData.isEmpty ? const CustomEmptyWidget()
      : Container(
        margin: const EdgeInsets.symmetric(vertical: AppValues.defaultPadding),
        padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: ThemeService().colorScheme.surface,
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.symmetric(
                horizontal: AppValues.defaultPadding,
                vertical: AppValues.largePadding,
              ),
              color: ThemeService().colorScheme.surfaceVariant,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center, width: 50,
                    child: CustomText(
                      S.current.random_text_560,
                      style: TextStyle(fontSize: 14),
                      textColorStyle: CustomTextColorStyle.normal,
                    ),
                  ),
                  Container(alignment: Alignment.center,
                      width: 80,
                      child: CustomText(S.current.random_text_561, style: TextStyle(fontSize: 14),
                        textColorStyle: CustomTextColorStyle.normal,
                      )),
                  Container(alignment: Alignment.center,
                      width: 80,
                      child: CustomText(S.current.random_text_51, style: TextStyle(fontSize: 14),
                        textColorStyle: CustomTextColorStyle.normal,)),
                  Container(alignment: Alignment.center,
                      width: 50,
                      child: CustomText(S.current.random_text_562, style: TextStyle(fontSize: 14),
                          textColorStyle: CustomTextColorStyle.normal)),
                ],
              )
            ),
            _buildList(),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    ));
  }

  _buildList() {
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          itemCount: controller.statisticalData.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return _listItem(index, controller.statisticalData[index]);
          },
        )
      );
    });
  }

  Widget _listItem(int index, StatisicalDataBean model) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.defaultPadding,
        vertical: AppValues.largePadding,
      ),
      color: index % 2 != 0
          ? ThemeService().colorScheme.surfaceVariant
          : ThemeService().theme.scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.center, width: 40,
            child: CustomNetWorkImage(
              imageUrl: "${controller.coinIcDomain}${model.currencyId}${controller
                  .coinIcExtensionName}",
              width: 18,
              height: 18,
            ),
          ),
          Container(
            alignment: Alignment.center, width: 80,
            child: CustomText(
              '\t\t${model.betCount}',
              style: const TextStyle(
                  color: AppThemes.sportBetOddColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          Container(
            alignment: Alignment.center, width: 80,
            child: CustomText(
              '${model.validBetAmount}',
              style: ThemeService().textTheme.bodyMedium,
            ),
          ),
          Container(
            alignment: Alignment.center, width: 50,
            child: CustomText(
              '${model.netAmount}',
              style: ThemeService().textTheme.bodyMedium,
              textColorStyle: (model.netAmount ?? "0").contains("-")
                  ? CustomTextColorStyle.error
                  : CustomTextColorStyle.white,
            ),
          ),
        ],
      ),
    );
  }
}
