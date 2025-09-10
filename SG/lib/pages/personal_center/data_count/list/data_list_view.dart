import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bet/pages/personal_center/data_count/data_count_view.dart';

import '../../../../constant/app_images.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/bottom/custom_bottom_page_widget.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_icon.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/dialog/custom_safe_dialog.dart';
import '../data_count_logic.dart';
import '../widget/data_item_view.dart';

///数据统计 列表
class DataListView extends StatelessWidget {
  final DataCountLogic controller;

  const DataListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: true,
          child: Column(
            children: [
              _buildTitle(),
              _buildList(),
              _buildBottom(context),
            ],
          ),
        ),

        ///可显示状态空
        // _buildStatusViewEmpty("此用户未有可显示的统计数据"),
      ],
    );
  }

  _buildTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      height: 44,
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: CustomText(
                S.current.tab_bar_order,
                textAlign: TextAlign.left,
                textColorStyle: CustomTextColorStyle.normal,
              )),
          Expanded(
              flex: 2,
              child: CustomText(S.current.statistics_title_win_text,
                  textAlign: TextAlign.center, textColorStyle: CustomTextColorStyle.normal)),
          Expanded(
              flex: 2,
              child: CustomText(S.current.statistics_title_lose_text,
                  textAlign: TextAlign.center, textColorStyle: CustomTextColorStyle.normal)),
          Expanded(
              flex: 3,
              child: CustomText(S.current.statistics_title_total_text,
                  textAlign: TextAlign.right, textColorStyle: CustomTextColorStyle.normal)),
        ],
      ),
    );
  }

  _buildList() {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size.fromHeight(controller.windowListHeightMax)),
      //   constraints: BoxConstraints.tightFor(height: controller.windowMin*2),
      // log('约束信息：DataListView...controller.windowMin*2...${controller.windowMin*1.2}');
      // return Container(
      //   height: controller.windowMin*1.2,
      child: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return DataItemView(index: index);
        },
      ),
    );
  }

  _buildBottom(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppValues.defaultPadding),
      child: Column(
        children: [
          CustomBottomPageWidget(currentPage: 1),
          CustomBigMainButton(
            onTap: (_) {
              CustomSafeDialog.dismiss(context: context, tag: kDataCountPage);
              //todo
              // showCustomWalletDetailsWidget(context: context);
            },
            title: S.current.random_text_362,
          ),
          SizedBox(
            height: AppValues.height_16,
          ),
          CustomText(S.current.random_text_363),
        ],
      ),
    );
  }

  _buildStatusViewEmpty(String message) {
    return Center(
      child: Column(
        children: [
          const CustomAssetIcon(size: 200, name: AppImages.icStatusViewEmpty),
          SizedBox(height: AppValues.defaultPadding),
          CustomText(
            message,
            textColorStyle: CustomTextColorStyle.normal,
            textAlign: TextAlign.center,
            style: ThemeService().textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
