import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/widget/cell/custom_tooltip_cell_widget.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constant/app_values.dart';
import '../../../model/yulecheng/casino_record_model.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/custom_app_life_cycle_listen_widget.dart';
import '../../../widget/network_image/custom_network_image_placeholder.dart';
import '../../alliance_plan/widget_cell/money_coin_cell_widget.dart';
import '../common_model/betting_common_params.dart';
import '../common_model/betting_record_api_model.dart';
import 'betting_casino_mybet_list_logic.dart';
import 'betting_casino_mybet_list_view_item.dart';
import 'custom_casino_mybet_title_view.dart';

///娱乐城 的 我的投注, 针对 我的 需要添加 上下页
class BettingCasinoMyBetListView extends StatelessWidget {
  // List<CasinoRecordModel> listData;
  // final ParamSingleCallback<CasinoRecordModel> callback;
  BettingCasinoMyBetListView({
    super.key,
    required this.chooseType,
    this.fromPage,
    this.isNeverScrollable = false,
  });
  ///0：投注单 1:我的投注 3：风云榜 4:竞赛 5:所有投注
  final BettingTypeEnum chooseType;
  final BettingFromPageType? fromPage;
  final bool isNeverScrollable;
  final BettingCasinoMyBetListLogic logic =
      Get.put<BettingCasinoMyBetListLogic>(BettingCasinoMyBetListLogic());

  @override
  Widget build(BuildContext context) {
    return CustomAppLifeCycleListenWidget(
      didChangeDependencies: () {
        logic.loadCasinoRecord(isRefresh: true, isShowLoad: false);
        log("娱乐城投注...我的投注...");
      },
      child: Container(
        alignment: Alignment.topCenter,
        child: Obx(() {
          return logic.isLoading.value
              // ? _buildShimmerView()
              ? buildLoadingView()
              : (logic.isError.value ? _buildNoDataView() : _buildContent());
        }),
      ),
    );
  }

  Widget buildLoadingView() {
    return SizedBox(
      height: 180,
      child: CustomNetWorkImagePlaceholder(
        color: AppThemes.surfaceVariant.withOpacity(0),
        placeholderType: NetWorkImagePlaceholderType.loading,
        // borderRadius: borderRadius,
        // border: border,
      ),
    );
  }
  // 骨架屏效果
  Widget _buildShimmerView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 12,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: index % 2 == 0
                        ? ThemeService().theme.colorScheme.surfaceVariant
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5)),
                margin: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _childShimmerView(w: 20, radius: 90, leftMargin: 5),
                    _childShimmerView(w: 80, rightMargin: 70),
                    _childShimmerView(),
                    _childShimmerView(w: 20, radius: 90, rightMargin: 5),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildBetListItem(BuildContext context,
      int index,
      BettingRecordApiModel data) {
    return InkWell(
      onTap: () => logic.onItemClick(context, data),
      child: BettingCasinoMyBetListItemView(index: index, model: data, fromPage: fromPage),
    );
  }

  Widget _buildNoDataView() {
    return Container(
      height: Get.height -
          AppBar().preferredSize.height -
          AppValues.sportHeight_20 -
          AppValues.sportHeight_153,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(height: AppValues.sportHeight_153),
            Image.asset(
              // 'assets/images/sport/sport_nodata.webp',
              'assets/images/status/ic_status_view_empty.webp',
              height: AppValues.sportIcon_112,
              width: AppValues.sportIcon_112,
            ),
            const SizedBox(height: AppValues.sportHeight_16),
            CustomText(
              S.current.random_text_221,
              style: ThemeService().textTheme.bodyMedium?.copyWith(
                    color: Color(0xFFB1BAD3),
                  ),
            ),
            const SizedBox(height: 5),
            // GestureDetector(onTap:(){
            //   widget.logic.state.activityLoading.value=false;
            //   widget.logic.loadActivityInfo(0);
            // },child:
            InkWell(
                onTap: () {
                  logic.onClickEmptyBettingToHome(fromPage);
                },
                child: CustomText(S.current.betting_casino_begin_game)),
            const SizedBox(height: AppValues.sportHeight_16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  S.current.yulecheng_prepage,
                  textColorStyle: CustomTextColorStyle.secondary,
                ),
                const SizedBox(width: AppValues.sportHeight_16),
                CustomText(
                  S.current.yulecheng_nextpage,
                  textColorStyle: CustomTextColorStyle.secondary,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: isNeverScrollable
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              // physics:  BouncingScrollPhysics(),
              itemCount: logic.betCasinoMyBetListObs.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  // return _buildBetTitle();
                  return CustomCasinoMyBetTitleView(
                    fromPage: fromPage,
                  );
                }
                // else if (index == logic.betCasinoMyBetListObs.length + 1) {
                //   return const SizedBox(height: 30);
                // }
                else {
                  return _buildBetListItem(context, index, logic.betCasinoMyBetListObs[index - 1]);
                }
              }),
          Visibility(
            visible: fromPage == BettingFromPageType.sideMenuBettingCasinoType,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CustomText(
                //   S.current.yulecheng_prepage,
                //   textColorStyle: CustomTextColorStyle.secondary,
                // ),
                CustomButton(
                  isEnable: logic.hasPrevPage.value,
                  title: S.current.yulecheng_prepage,
                  padding: EdgeInsets.zero,
                  textStyle: ThemeService().textTheme.bodyMedium?.copyWith(
                    // color: Color(0xFFB1BAD3),
                    color: logic.hasPrevPage.value
                        ? CustomTextColorStyle.white.value
                        : CustomTextColorStyle.secondary.value,
                    fontWeight: FontWeight.w600,
                  ),
                  onTap: () => logic.onClickPreviousPage(),
                  // S.current.yulecheng_nextpage,
                  // textColorStyle: CustomTextColorStyle.white,
                  // textColorStyle: CustomTextColorStyle.secondary,
                ),
                const SizedBox(width: AppValues.sportHeight_16),
                CustomButton(
                  isEnable: logic.hasNextPage.value,
                  title: S.current.yulecheng_nextpage,
                  padding: EdgeInsets.zero,
                  textStyle: ThemeService().textTheme.bodyMedium?.copyWith(
                    // color: Color(0xFFB1BAD3),
                    color: logic.hasNextPage.value
                        ? CustomTextColorStyle.white.value
                        : CustomTextColorStyle.secondary.value,
                    fontWeight: FontWeight.w600,
                  ),
                  onTap: () => logic.onClickNextPage(),
                  // S.current.yulecheng_nextpage,
                  // textColorStyle: CustomTextColorStyle.white,
                  // textColorStyle: CustomTextColorStyle.secondary,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _childShimmerView(
      {double w = 140,
      double h = 20,
      double radius = 3,
      double leftMargin = 0,
      double rightMargin = 0}) {
    return Shimmer.fromColors(
        baseColor: AppThemes.chatRooCardColor,
        highlightColor: AppThemes.textColorLightGrey,
        child: Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
              color: AppThemes.chatRooCardColor, borderRadius: BorderRadius.circular(radius)),
          margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
        ));
  }
}
