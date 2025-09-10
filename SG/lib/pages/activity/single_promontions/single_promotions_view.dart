import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/measure/custom_measure_size_widget.dart';
import '../../../widget/refresh/custom_refresh_view.dart';
import '../../../widget/status/custom_load_state_view.dart';
import '../../home/home_logic.dart';
import '../a_widget/all_single_promotions_view_item.dart';
import '../a_model/activity_common_params.dart';
import 'single_promotions_logic.dart';

///活动单独列表， 分别包括娱乐城活动列表 、体育活动列表
class SinglePromotionsPage extends StatelessWidget {
  SinglePromotionsPage({super.key, required ActivityListTypeEnum? typeEnum})
      : logic = Get.put<SinglePromotionsLogic>(SinglePromotionsLogic(typeEnum: typeEnum),
      tag: typeEnum?.name);

  late SinglePromotionsLogic logic;

  // final SinglePromotionsLogic logic ;

  ///打开页面
  static openPageCasino() {
    RouteUtil.pushToView(Routes.homeSinglePromotions,
        arguments: {"typeEnum": ActivityListTypeEnum.casino});
  }

  ///打开页面
  static openPageSport() {
    RouteUtil.pushToView(Routes.homeSinglePromotions,
        arguments: {"typeEnum": ActivityListTypeEnum.sport});
  }

  // @override
  // PreferredSizeWidget? appBar(BuildContext context) {
  //   return CustomAppBar(appBarTitleText: S.current.alliance_activity, showLeading: true);
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: logic.refreshController.getMeasureHeight(350),
        child: CustomRefreshView(
          // physics: const ClampingScrollPhysics(),
          physics: const NeverScrollableScrollPhysics(),
          controller: logic.refreshController,
          // clipBehavior: Clip.none,
          refreshOnStart: false,
          isCanRefresh: false,
          isCanLoadMore: false,
          onRefreshAction: (refreshController) {
            logic.loadNetData(isRefresh: true, isShowLoad: false);
          },
          onLoadMoreAction: (refreshController) {
            logic.loadNetData(isRefresh: false, isShowLoad: false);
          },
          // childHeader: Column(
          //   mainAxisSize: MainAxisSize.max,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     _buildTopView(),
          //     // _buildCasinoView(),
          //     // _buildSportView(),
          //     // _buildListTitleView(),
          //   ],
          // ),
          child: _buildListView(),
        ),
      );
    });
  }

  _buildTopView() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.only(left: 12, top: 0),
      color: Color(0xFF1A3744), // 设置背景色
      // decoration:  const BoxDecoration(
      //   // color: ThemeService().theme.colorScheme.surfaceVariant, // 设置背景色
      //   color: Color(0xFF1A3744), // 设置背景色
      //   // image: DecorationImage(
      //   //   image: AssetImage("assets/images/home/promotions/ic_single_promotions_bg.webp"),
      //   //   fit: BoxFit.fitWidth,
      //   // ),
      // ),
      child: Row(
        children: [
          Obx(() {
            return CustomText(
              logic.typeTopLabelObs.value,
              style: ThemeService()
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
            );
          }),
          Spacer(),
          CustomAssetIcon(
            name: "assets/images/home/promotions/ic_single_promotions_bg2.webp",
            height: 100,
            boxFit: BoxFit.fill,
          ),
        ],
      ),
    );
  }

  _buildListView() {
    // return Container();
    return Obx(() {
      return CustomLoadStateLayout(
        configState: logic.pageStateObs.value,
        configRetry: (pageState) =>
            logic.loadNetData(isRefresh: true, isShowLoad: true, isFirst: true),
        configSuccess: CustomMeasureSizeWidget(
          onChange: (size) {
            logic.refreshController.measureHeight = size.height;
          },
          child: ListView.builder(
              padding: EdgeInsets.zero,
              primary: false,
              // physics: const BouncingScrollPhysics(),
              physics: const NeverScrollableScrollPhysics(),
              // controller: ScrollController(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: logic.apiModelList.length,
              itemBuilder: (context, index) {
                var activityTypeEnum = ActivityTypeEnum.adaptor(logic.apiModelList[index].ty);
                return AllSinglePromotionsItemView(
                  index: index,
                  model: logic.apiModelList[index],
                  typeEnum: logic.typeEnum ?? ActivityListTypeEnum.all,
                  activityTypeEnum: activityTypeEnum,
                  onItemClick: (model) {
                    if (model.ty == 1) {
                      RouteUtil.pushToView(Routes.rotary, arguments: {
                        'id': model.id,
                        'currencyId': HomeLogic
                            .of()
                            .state
                            .currencyId
                      });
                    } else {
                      logic.onClickActivityItemMixin(model);
                    }
                  },
                );
              }),
        ),
      );
    });
  }
}
