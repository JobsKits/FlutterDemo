import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_view.dart';
import '../../../routes/routes.dart';
import '../../../utils/route_util.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/refresh/custom_refresh_view.dart';
import '../../../widget/status/custom_load_state_view.dart';
import '../activity_promotion/activity_promotion_view.dart';
import '../single_promontions/single_promotions_view.dart';
import 'all_promotions_logic.dart';
import '../a_widget/all_single_promotions_view_item.dart';

///促销活动 查看全部【备份】
class AllPromotionsPageBackup extends BaseView<AllPromotionsLogic> {
  AllPromotionsPageBackup({Key? key}) : super(key: key);

  // final logic = Get.put(HomeAllPromotionsLogic());

  ///打开页面
  static openPage() {
    RouteUtil.pushToView(Routes.homeAllPromotions);
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(appBarTitleText: S.current.random_text_883, showLeading: true);
  }

  @override
  Widget buildBody(BuildContext context) {
    return CustomRefreshView(
      controller: logic.refreshController,
      // clipBehavior: Clip.none,
      refreshOnStart: false,
      isCanLoadMore: false,
      onRefreshAction: (refreshController) {
        logic.loadNetData(isRefresh: true, isShowLoad: false);
      },
      onLoadMoreAction: (refreshController) {
        logic.loadNetData(isRefresh: false, isShowLoad: false);
      },
      childHeader: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopView(),
          _buildCasinoView(),
          _buildSportView(),
          _buildListTitleView(),
        ],
      ),
      child: _buildListView(),
    );
  }

  _buildTopView() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 12),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/home/promotions/ic_all_promotions_bg.webp"),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: CustomText(
        S.current.promotions,
        style:
            ThemeService().textTheme.bodyLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  _buildCasinoView() {
    return CustomButton(
      padding: EdgeInsets.zero,
      onTap: () {
        log("AllPromotionsPage...娱乐城...点击了...");
        SinglePromotionsPage.openPageCasino();
      },
      child: Container(
        margin: EdgeInsets.only(left: 12, right: 12, top: 20),
        height: 96,
        decoration: BoxDecoration(
          color: ThemeService().theme.colorScheme.surfaceVariant, // 设置背景色
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: [
            const CustomAssetIcon(
                name: "assets/images/home/promotions/ic_all_promotions_casino.webp", size: 96),
            SizedBox(width: AppValues.defaultMargin),
            CustomText(
              S.current.tab_bar_ent,
              style: ThemeService()
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            const CustomAssetIcon(
                name: "assets/images/common/ic_common_arrow_right.webp", size: 10),
            SizedBox(width: AppValues.margin_40),
          ],
        ),
      ),
    );
  }

  _buildSportView() {
    return CustomButton(
      padding: EdgeInsets.zero,
      onTap: () {
        log("AllPromotionsPage...体育博彩...点击了...");
        SinglePromotionsPage.openPageSport();
      },
      child: Container(
        margin: EdgeInsets.only(left: 12, right: 12, top: 20),
        height: 96,
        decoration: BoxDecoration(
          color: ThemeService().theme.colorScheme.surfaceVariant, // 设置背景色
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: [
            const CustomAssetIcon(
                name: "assets/images/home/promotions/ic_all_promotions_sport.webp", size: 96),
            SizedBox(width: AppValues.defaultMargin),
            CustomText(
              S.current.random_text_826,
              style: ThemeService()
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            const CustomAssetIcon(
                name: "assets/images/common/ic_common_arrow_right.webp", size: 10),
            SizedBox(width: AppValues.margin_40),
          ],
        ),
      ),
    );
  }

  _buildListTitleView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: CustomText(
        S.current.random_text_827,
        style:
            ThemeService().textTheme.bodyLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  _buildListView() {
    return Container(
      child: Obx(() {
        return CustomLoadStateLayout(
          configState: logic.pageStateObs.value,
          configRetry: (pageState) =>
              logic.loadNetData(isRefresh: true, isShowLoad: true, isFirst: true),
          configSuccess: ListView.builder(
              padding: EdgeInsets.zero,
              primary: false,
              // physics: const BouncingScrollPhysics(),
              physics: const NeverScrollableScrollPhysics(),
              // controller: ScrollController(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: logic.apiModelList.length,
              itemBuilder: (context, index) {
                return AllSinglePromotionsItemView(
                  index: index,
                  model: logic.apiModelList[index],
                  onItemClick: (model) {
                    logic.onClickActivityItemMixin(model);
                  },
                );
              }),
        );
      }),
    );
  }
}
