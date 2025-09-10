import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/pages/find/widget/casino_tabbar.dart';
import 'package:flutter_bet/pages/front/widget/front_casino_competition_view.dart';
import 'package:flutter_bet/pages/front/widget/front_competition_view.dart';
import 'package:flutter_bet/pages/front/widget/front_sport_competition_view.dart';
import 'package:flutter_bet/pages/main/code.dart';
import 'package:flutter_bet/pages/main/logic.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image_placeholder.dart';
import 'package:flutter_bet/widget/sport/until/custom_sport_until.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../base/getx/base_view.dart';
import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../routes/routes.dart';
import '../../../services/branch/branch_service.dart';
import '../../../services/lang_service.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/odds_util.dart';
import '../../../utils/route_util.dart';
import '../../../utils/string_uril.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/button/custom_icon_button.dart';
import '../../../widget/cell/custom_tooltip_cell_widget.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_divider_widget.dart';
import '../../../widget/custom_top_appbar_view.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../../../widget/scroller/custom_adaptive_scrollbar.dart';
import '../../../widget/sport/custom_sport_expand/custom_sport_expand.dart';
import '../../../widget/sport/custom_sport_odd/custom_sport_odd_change_animation.dart';
import '../../../widget/sport/custom_sport_odd_type.dart';
import '../../../widget/sport/custom_sport_search.dart';
import '../../../widget/sport/custom_sport_tabbar.dart';
import '../common_model/sport_common_params.dart';
import '../model.dart';
import '../sport_champion_detail/view.dart';
import 'logic.dart';
import 'model.dart';
import 'package:intl/intl.dart';

class SportDetailPage extends BaseView<SportDetailLogic> {
  SportDetailPage({Key? key}) : super(key: key);

  final logic = Get.put(SportDetailLogic());
  final state = Get.find<SportDetailLogic>().state;

  ///打开页面
  ///"si": 1, //球种Id
  // "ei": "54319137" //赛事ID
  static openPage({required int? si, required String? ci, String? ei, required bool isChampion}) {
    if (isChampion) {
      // RouteUtil.pushToView(Routes.sport_champion_detail, arguments: {'si': si, 'ci': ci});
      SportChampionDetailPage.openPage(si: si, ci: ci, ei: ei);
    } else {
      RouteUtil.pushToView(Routes.sport_detail, arguments: {'si': si, 'eid': ci, 'ei': ei});
    }
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      titleSpacing: 12.0,
      titleView: CustomTopAppBarView(
        onTapLogo: () {
          RouteUtil.popToFirst(Routes.mainPage, code: MenuCode.MSG);
          Timer(const Duration(milliseconds: 400), () {
            if (Get.isRegistered<MainLogic>()) {
              Get.find<MainLogic>().onMenuSelected(MenuCode.MSG);
            }
          });
        },
        isShowLogo: true,
      ),
      showLeading: false,
      // onBackTap: () {
      //   RouteUtil.popToFirst(Routes.mainPage, code: MenuCode.MSG);
      //   return;
      // },
    );
  }

  final ScrollController _hCtrl = ScrollController();

  @override
  Widget buildBody(BuildContext context) {
    OddStatusType statusType = OddStatusType.rolling;

    // TODO: implement buildBody
    return Obx(() {
      // ignore: invalid_use_of_protected_member
      return state.model.value.status == 3
          ? _buildNoDataView(S.current.sport_nodata)
          : (state.model.value.delta == -999
              ? Container(
                  height: 400,
                  child: Center(
                    child: SizedBox(
                        height: 150,
                        child: CustomNetWorkImagePlaceholder(
                          color: AppThemes.surfaceVariant.withOpacity(0),
                          placeholderType: NetWorkImagePlaceholderType.loading,
                          // borderRadius: borderRadius,
                          // border: border,
                        )), // 创建一个小菊花
                  ),
                )
              : Container(
                  // padding: EdgeInsets.only(
                  //   left: AppValues.sportPadding_12.w,
                  //   right: AppValues.sportPadding_12.w,
                  // ),
                  margin: EdgeInsets.only(bottom: AppValues.barBottomHeight),
                  child: CustomScrollView(
                    slivers: state.list.isNotEmpty
                        ? [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: AppValues.sportHeight_20.h,
                                  left: AppValues.sportPadding_12.w,
                                  right: AppValues.sportPadding_12.w,
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => RouteUtil.popView(),
                                      child: Container(
                                        width: 54,
                                        height: AppValues.sportHeight_44.h + 4.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(AppValues.smallRadius),
                                          color: ThemeService().colorScheme.surface,
                                        ),
                                        alignment: Alignment.center,
                                        child: Transform.rotate(
                                          angle: pi/2,
                                          child: const CustomAssetIcon(
                                            name: "assets/images/top_drop_down arrow.png",
                                            size: 24,
                                            color: AppThemes.widgetColorWhite,
                                          ),
                                        )
                                      ),
                                    ),
                                    const SizedBox(width: AppValues.defaultPadding,),
                                    Expanded(
                                      child: Container(
                                        height: AppValues.sportHeight_44.h + 4.h,
                                        child: CustomAdaptiveScrollbar(
                                          width: 10,
                                          controller: _hCtrl,
                                          sliderDefaultColor: Colors.transparent,
                                          position: ScrollbarPosition.bottom,
                                          underDecoration: const BoxDecoration(
                                              // color:  ThemeService().theme.colorScheme.surface,
                                              // color : Colors.red,
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.all(Radius.circular(10))),
                                          sliderChild: Container(
                                              decoration: BoxDecoration(
                                                // color: Color(0xFF557086),
                                                // color : Colors.red,
                                                color: ThemeService().theme.colorScheme.tertiary,
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                              ),
                                              child: const SizedBox(height: 10)),
                                          child: SingleChildScrollView(
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.horizontal,
                                            controller: _hCtrl,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              primary: false,
                                              padding: EdgeInsets.only(bottom: 2),
                                              children: [
                                                // CustomIconButton(
                                                //   borderRadius: AppValues.sportRadius_4,
                                                //   backgroundColor: ThemeService().colorScheme.surface,
                                                //   onTap: () {
                                                //     RouteUtil.popView();
                                                //   },
                                                //   widgetWidth: AppValues.sportWidth_54.w,
                                                //   widgetHeight: AppValues.sportHeight_44.h,
                                                //   iconWidget: SvgPicture.asset(
                                                //     'assets/svg/ic_normal_back.svg',
                                                //     width: 18,
                                                //     height: 18,
                                                //     color: ThemeService().colorScheme.inverseSurface,
                                                //   ),
                                                //   // iconThemeData: themeData,
                                                // ),
                                                // SizedBox(
                                                //   width: AppValues.sportPadding_12,
                                                // ),
                                                CustomButton(
                                                  onTap: () =>
                                                      logic.onClickToPage(SportOpenType.viewAll, 1),
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.only(
                                                      left: AppValues.sportPadding_8,
                                                      right: AppValues.sportPadding_8),
                                                  constraints: BoxConstraints(
                                                    minHeight: AppValues.sportHeight_44.h,
                                                  ),
                                                  backgroundColor: ThemeService().colorScheme.surface,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(AppValues.sportRadius_4)),
                                                  child: Text(state.model.value.list?.first.sn ?? '',
                                                      textAlign: TextAlign.center,
                                                      style: ThemeService()
                                                          .theme
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: ThemeService()
                                                                  .colorScheme
                                                                  .inverseSurface,
                                                              fontSize: AppValues.fontBodyMediumSize,
                                                              fontWeight: FontWeight.w600)),
                                                ),
                                                Container(
                                                  color: ThemeService().colorScheme.surface,
                                                  child: Image.asset(
                                                    'assets/images/sport/sport_g.webp',
                                                    height: AppValues.sportHeight_44.h,
                                                    width: AppValues.sportHeight_44.h / 114 * 63,
                                                  ),
                                                ),
                                                CustomButton(
                                                  onTap: () =>
                                                      logic.onClickToPage(SportOpenType.league, 2),
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.only(
                                                      left: AppValues.sportPadding_8,
                                                      right: AppValues.sportPadding_8),
                                                  constraints: BoxConstraints(
                                                    minHeight: AppValues.sportHeight_44.h,
                                                  ),
                                                  backgroundColor: ThemeService().colorScheme.surface,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(AppValues.sportRadius_4)),
                                                  child: Text(state.model.value.list?.first.pgn ?? '',
                                                      textAlign: TextAlign.center,
                                                      style: ThemeService()
                                                          .theme
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: ThemeService()
                                                                  .colorScheme
                                                                  .inverseSurface,
                                                              fontSize: AppValues.fontBodyMediumSize,
                                                              fontWeight: FontWeight.w600)),
                                                ),
                                                Container(
                                                  color: ThemeService().colorScheme.surface,
                                                  child: Image.asset(
                                                    'assets/images/sport/sport_g.webp',
                                                    height: AppValues.sportHeight_44.h,
                                                    width: AppValues.sportHeight_44.h / 114 * 63,
                                                  ),
                                                ),
                                                CustomButton(
                                                  onTap: () =>
                                                      logic.onClickToPage(SportOpenType.league, 3),
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.only(
                                                      left: AppValues.sportPadding_8,
                                                      right: AppValues.sportPadding_8),
                                                  constraints: BoxConstraints(
                                                    minHeight: AppValues.sportHeight_44.h,
                                                  ),
                                                  backgroundColor: ThemeService().colorScheme.surface,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(AppValues.sportRadius_4)),
                                                  child: Text(state.model.value.list?.first.cn ?? '',
                                                      textAlign: TextAlign.center,
                                                      style: ThemeService()
                                                          .theme
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: ThemeService()
                                                                  .colorScheme
                                                                  .inverseSurface,
                                                              fontSize: AppValues.fontBodyMediumSize,
                                                              fontWeight: FontWeight.w600)),
                                                ),
                                                Container(
                                                  color: ThemeService().colorScheme.surface,
                                                  child: Image.asset(
                                                    'assets/images/sport/sport_g.webp',
                                                    height: AppValues.sportHeight_44.h,
                                                    width: AppValues.sportHeight_44.h / 114 * 63,
                                                  ),
                                                ),
                                                CustomButton(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.only(
                                                      left: AppValues.sportPadding_8, right: 38),
                                                  constraints: BoxConstraints(
                                                    minHeight: AppValues.sportHeight_44.h,
                                                  ),
                                                  backgroundColor: ThemeService().colorScheme.surface,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(AppValues.sportRadius_4)),
                                                  child: Text(
                                                      "${StringUtil().truncateString(state.model.value.list?.first.htn ?? '', 10)} - ${StringUtil().truncateString(state.model.value.list?.first.atn ?? '', 10)}" ??
                                                          '',
                                                      textAlign: TextAlign.center,
                                                      style: ThemeService()
                                                          .theme
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Color(0xFFB1BAD3),
                                                              fontSize: AppValues.fontBodyMediumSize,
                                                              fontWeight: FontWeight.w600)),
                                                ),
                                                // CustomIconButton(
                                                //   onTap: () {},
                                                //   widgetWidth: AppValues.sportWidth_54.w,
                                                //   widgetHeight: AppValues.sportHeight_44.h,
                                                //   iconWidget: Image.asset(
                                                //     'assets/images/sport/sport_collection.webp',
                                                //     width: AppValues.sportIcon_18.w,
                                                //     height: AppValues.sportIcon_18.h,
                                                //   ),
                                                //   // iconThemeData: themeData,
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                                child: SizedBox(height: AppValues.sportPadding_20.w)),
                            SliverToBoxAdapter(
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: AppValues.sportPadding_12.w,
                                  right: AppValues.sportPadding_12.w,
                                ),
                                width: 352.w,
                                height: 174.h,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.asset(
                                        // assets/images/sport/
                                        // SportUntil().deta
                                        SportUntil().detailBackImage(state.list.first.si ?? 999),

                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,

                                      ///todo: 可以使用[CustomSportScoreWidget] 该组件
                                      child: Card(
                                        color: Colors.transparent,
                                        child: IntrinsicWidth(
                                          child: Container(
                                            height: ((state.model.value.list?.first.pol?.keys ?? [])
                                                        .contains('21') ||
                                                    (state.model.value.list?.first.pol?.keys ?? [])
                                                        .contains('22'))
                                                ? (96 + 32).h + 0.5
                                                : (96).h + 0.5,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                    child: Column(
                                                  children: [
                                                    Container(
                                                      // width: Get.width,
                                                      height: 32.h,
                                                      color:
                                                          ThemeService().theme.colorScheme.surface,
                                                    ),
                                                    Container(
                                                      // width: Get.width,
                                                      height: 32.h,
                                                      color: ThemeService()
                                                          .theme
                                                          .colorScheme
                                                          .background,
                                                    ),
                                                    // Container(
                                                    //   width:Get.width,
                                                    //   // color: Colors.white.withOpacity(0.2),
                                                    //   color: Colors.red,
                                                    //   height: 0.5,
                                                    // ),
                                                    Container(
                                                      // width: Get.width,
                                                      height: 32.h,
                                                      color: ThemeService()
                                                          .theme
                                                          .colorScheme
                                                          .background,
                                                    ),
                                                    if ((state.model.value.list?.first.pol?.keys ??
                                                                [])
                                                            .contains('21') ||
                                                        (state.model.value.list?.first.pol?.keys ??
                                                                [])
                                                            .contains('22'))
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment.centerRight,
                                                          // width: Get.width,
                                                          height: 32.h,
                                                          color: ThemeService()
                                                              .theme
                                                              .colorScheme
                                                              .background,
                                                          child: Text(S.current.random_text_679 +
                                                              '(${state.model.value.list?.first.pol?['21']}-${state.model.value.list?.first.pol?['22']})    '),
                                                        ),
                                                      ),
                                                  ],
                                                )),
                                                SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Container(
                                                      height: (96).h + 0.5,
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                  color: ThemeService()
                                                                      .theme
                                                                      .colorScheme
                                                                      .surface,
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                          width: 8.w, height: 32.h),
                                                                      CustomText(
                                                                        (state
                                                                                            .model
                                                                                            .value
                                                                                            .list
                                                                                            ?.first
                                                                                            .ed ??
                                                                                        0) *
                                                                                    1000 <
                                                                                DateTime.now()
                                                                                    .millisecondsSinceEpoch
                                                                            ? '${toS(state.model.value.list?.first.rbtt ?? '', state.model.value.list?.first.ts ?? 0, state.model.value.list?.first.si)}    ${(state.model.value.list?.first.rbtd ?? '')}'
                                                                            : DateFormat(
                                                                                    'HH:mm yyyy/MM/dd')
                                                                                .format(DateTime
                                                                                    .fromMillisecondsSinceEpoch((state
                                                                                                .model
                                                                                                .value
                                                                                                .list
                                                                                                ?.first
                                                                                                .ed ??
                                                                                            0) *
                                                                                        1000))
                                                                                .toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Color(0xFFB1BAD3)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                // color: ThemeService()
                                                                //     .theme
                                                                //     .colorScheme
                                                                //     .background,
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                        width: 8.w, height: 32.h),
                                                                    CustomNetWorkImage(
                                                                      width: 14.h,
                                                                      height: 14.h,
                                                                      imageUrl: BranchService
                                                                              .instance
                                                                              .current
                                                                              .asset_url +
                                                                          (state.model.value.list
                                                                                  ?.first?.htpic ??
                                                                              ''),
                                                                      placeholder: Image.asset(
                                                                        SportUntil()
                                                                            .tabImage(true, 999),
                                                                        width: 14.w,
                                                                        height: 14.h,
                                                                      ),
                                                                      errorWidget: Image.asset(
                                                                        SportUntil()
                                                                            .tabImage(true, 999),
                                                                        width: 14.w,
                                                                        height: 14.h,
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 8.w),
                                                                    // CustomText(state.list.first.htn
                                                                    //     .toString()),
                                                                    CustomTooltipCellWidget(
                                                                        content: state
                                                                            .list.first.htn
                                                                            .toString(),
                                                                        maxLength:
                                                                            LangService().isChinese
                                                                                ? 10
                                                                                : 20,
                                                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                                                        style: ThemeService()
                                                                            .textTheme
                                                                            .bodyMedium!
                                                                            .copyWith(
                                                                                fontSize: 14,
                                                                                fontWeight:
                                                                                    FontWeight
                                                                                        .w500)),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                color: ThemeService()
                                                                    .theme
                                                                    .colorScheme
                                                                    .background,
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                        width: 8.w, height: 32.h),
                                                                    CustomNetWorkImage(
                                                                      width: 14.h,
                                                                      height: 14.h,
                                                                      imageUrl: BranchService
                                                                              .instance
                                                                              .current
                                                                              .asset_url +
                                                                          (state.model.value.list
                                                                                  ?.first?.atpic ??
                                                                              ''),
                                                                      placeholder: Image.asset(
                                                                        SportUntil()
                                                                            .tabImage(true, 999),
                                                                        width: 14.w,
                                                                        height: 14.h,
                                                                      ),
                                                                      errorWidget: Image.asset(
                                                                        SportUntil()
                                                                            .tabImage(true, 999),
                                                                        width: 14.w,
                                                                        height: 14.h,
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 8.w),
                                                                    // CustomText(state
                                                                    //     .list.first.atn
                                                                    //     .toString()),
                                                                    CustomTooltipCellWidget(
                                                                        content: state
                                                                            .list.first.atn
                                                                            .toString(),
                                                                        maxLength:
                                                                            LangService().isChinese
                                                                                ? 10
                                                                                : 20,
                                                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                                                        style: ThemeService()
                                                                            .textTheme
                                                                            .bodyMedium!
                                                                            .copyWith(
                                                                                fontSize: 14,
                                                                                fontWeight:
                                                                                    FontWeight
                                                                                        .w500)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          // Column(),
                                                          // Expanded(child: SizedBox()),
                                                          Container(
                                                            width: (state.model.value.list?.first
                                                                                .pol?.keys.length ??
                                                                            0) ~/
                                                                        2 *
                                                                        (150 / 4) >
                                                                    150
                                                                ? 150
                                                                : (state.model.value.list?.first
                                                                                    .ed ??
                                                                                0) *
                                                                            1000 >
                                                                        DateTime.now()
                                                                            .millisecondsSinceEpoch
                                                                    ? 110
                                                                    : (state.model.value.list?.first
                                                                                .pol?.keys.length ??
                                                                            0) ~/
                                                                        2 *
                                                                        (150 / 4),
                                                            // constraints: BoxConstraints(
                                                            //   maxWidth: 150.0,
                                                            // ),
                                                            child: ListView.builder(
                                                              scrollDirection: Axis.horizontal,
                                                              itemCount: (state
                                                                          .model
                                                                          .value
                                                                          .list
                                                                          ?.first
                                                                          .pol
                                                                          ?.keys
                                                                          .length ??
                                                                      0) ~/
                                                                  2,
                                                              itemBuilder: (context, index) {
                                                                List<MapEntry<String, String>?> m =
                                                                    (state.model.value.list?.first
                                                                            .pol?.entries
                                                                            .toList() ??
                                                                        [])
                                                                      ..sort((a, b) {
                                                                        return (int.parse(
                                                                                b?.key ?? '0'))
                                                                            .compareTo(int.parse(
                                                                                a?.key ?? '0'));
                                                                      });
                                                                for (int i = 0; i < m.length; i++) {
                                                                  String key = m[0]?.key ?? '';
                                                                  if ((int.tryParse(key ?? '') ??
                                                                          0) >
                                                                      8) {
                                                                    m.add(m.removeAt(0));
                                                                  }
                                                                }

                                                                var h = ((m[index * 2]));
                                                                var a = ((m[index * 2 + 1]));

                                                                if (a?.key == 35 ||
                                                                    a?.key == 36 ||
                                                                    a?.key == 23 ||
                                                                    a?.key == 24) {
                                                                  return Container();
                                                                } else {
                                                                  if (getT(h?.key ?? '') == 'uk') {
                                                                    return Container();
                                                                  } else {
                                                                    return Column(
                                                                      children: [
                                                                        Container(
                                                                          height: 18.h,
                                                                          width: 20,
                                                                          margin:
                                                                              EdgeInsets.all(8.0),
                                                                          // color: Colors.blue,
                                                                          child: Center(
                                                                            child:
                                                                                getC(h?.key ?? ''),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          height: 18.h,
                                                                          width: 20,
                                                                          margin:
                                                                              EdgeInsets.all(8.0),
                                                                          // color: Colors.blue,
                                                                          child: Center(
                                                                            child: Text(
                                                                              h?.value ?? '',
                                                                              style: TextStyle(
                                                                                  color: Color(
                                                                                      0xFFB1BAD3),
                                                                                  fontSize: 14.sp),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          height: 18.h,
                                                                          width: 20,
                                                                          margin: const EdgeInsets
                                                                              .fromLTRB(8, 8, 8, 0),
                                                                          // color: Colors.blue,
                                                                          child: Center(
                                                                            child: Text(
                                                                              a?.value ?? '',
                                                                              style: TextStyle(
                                                                                  color: Color(
                                                                                      0xFFB1BAD3),
                                                                                  fontSize: 14.sp),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    );
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Image.asset(
                                                                    SportUntil().tabImage(true,
                                                                        state.list.first.si ?? 999),
                                                                    width: 14.w,
                                                                    height: 14.h,
                                                                    color: Colors.white,
                                                                  ),
                                                                  SizedBox(
                                                                      width: 1.w, height: 32.h),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: 32.w,
                                                                    height: 32.h,
                                                                    color: ThemeService()
                                                                        .theme
                                                                        .colorScheme
                                                                        .surfaceVariant,
                                                                    child: Center(
                                                                      child: CustomText(
                                                                          state.model.value.list
                                                                                  ?.first?.hp
                                                                                  .toString() ??
                                                                              '',
                                                                          style: ThemeService()
                                                                              .theme
                                                                              .textTheme
                                                                              .bodyMedium!
                                                                              .copyWith(
                                                                                  color: const Color(
                                                                                      0xFFFF9D00),
                                                                                  fontSize: AppValues
                                                                                      .fontBodyMediumSize
                                                                                      .sp,
                                                                                  fontWeight:
                                                                                      FontWeight
                                                                                          .w700)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: 32.w,
                                                                    height: 32.h,
                                                                    color: ThemeService()
                                                                        .theme
                                                                        .colorScheme
                                                                        .surfaceVariant,
                                                                    child: Center(
                                                                      child: CustomText(
                                                                          state.model.value.list
                                                                                  ?.first?.ap
                                                                                  .toString() ??
                                                                              '',
                                                                          style: ThemeService()
                                                                              .theme
                                                                              .textTheme
                                                                              .bodyMedium!
                                                                              .copyWith(
                                                                                  color: const Color(
                                                                                      0xFFFF9D00),
                                                                                  fontSize: AppValues
                                                                                      .fontBodyMediumSize
                                                                                      .sp,
                                                                                  fontWeight:
                                                                                      FontWeight
                                                                                          .w700)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // CustomScoreBoard(false, state.model.value),
                            // SizedBox(height: AppValues.sportHeight_8.h),
                            // CustomSportSwitch(true),
                            SliverToBoxAdapter(child: SizedBox(height: AppValues.sportHeight_16.h)),
                            if ((state.model.value.list?.first.tgl ?? []).isNotEmpty)
                              SliverToBoxAdapter(
                                child: CustomSportTabbar(
                                  state.model.value.list?.first.tgl?.map((e) {
                                        return SportTabModel.fromJson(e.toJson());
                                      }).toList() ??
                                      [],
                                  (index) => logic.changeCategoryIndex(index),
                                  state.cagetoryTabbarInitIndex,
                                  state.g.isLogin.value,
                                  false,
                                ),
                              ),
                            SliverToBoxAdapter(child: SizedBox(height: AppValues.sportHeight_16.h)),
                            SliverToBoxAdapter(
                                child: CustomSportSearch((v) {
                              if (v.isNotEmpty) {
                                state.isSearching = true;
                              } else {
                                state.isSearching = false;
                              }
                              logic.starSearching(v);
                            }, state.textController)),
                            SliverToBoxAdapter(child: SizedBox(height: AppValues.sportHeight_6.h)),
                            ...(state.isSearching ? state.searchinglist.value : state.list.value)
                                .map((element) {
                              double bWidth = (Get.width -
                                      24.w -
                                      20.w -
                                      (logic.getRowsCount(element) - 1) * 5.w) /
                                  logic.getRowsCount(element);

                              return SliverToBoxAdapter(
                                  child: CustomSportExpand(
                                titlePadding: EdgeInsets.symmetric(
                                  vertical: AppValues.sportPadding_12.w,
                                  horizontal: AppValues.sportPadding_10.w,
                                ),
                                padding: EdgeInsets.zero,
                                childrenPadding:
                                    EdgeInsets.only(bottom: AppValues.sportPadding_8.h),
                                margin: EdgeInsets.only(
                                  left: AppValues.sportPadding_12.w,
                                  right: AppValues.sportPadding_12.w,
                                  top: AppValues.sportPadding_6.w,
                                  bottom: AppValues.sportPadding_6.w,
                                ),
                                title: Text(StringUtil().truncateString(element.btn ?? '', 30),
                                    softWrap: true,
                                    style: ThemeService().theme.textTheme.bodyMedium!.copyWith(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        )),
                                decoration: BoxDecoration(
                                  color: ThemeService().theme.colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(AppValues.sportRadius_4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25), // 阴影颜色，这里使用黑色
                                      offset: Offset(3, 3), // 阴影偏移量，右下方向
                                      blurRadius: 10, // 阴影模糊程度
                                      spreadRadius: 0, // 阴影扩展程度
                                    ),
                                  ],
                                ),
                                trailing: FaIcon(
                                  FontAwesomeIcons.angleDown,
                                  size: 9.41.w,
                                ),
                                // titlePadding: EdgeInsets.only(bottom: 12.h),
                                // childrenPadding: EdgeInsets.only(bottom: 19.h),
                                // controller: expandableWidgetController2,
                                isExpanded: true,
                                children: [
                                  // CustomSportOdd(OddContestType.rolling, const [OddCountType.two], widget.section,0,
                                  //     widget.sportBetClick),
                                  // CustomSportOdd(OddContestType.rolling, const [OddCountType.three], widget.section,1,
                                  //     widget.sportBetClick),
                                  CustomDividerWidget(),
                                  SizedBox(height: 8.h),
                                  if (element.pat == 2 || element.pat == 4 || element.pat == 6)
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: (SportUntil()
                                                .splitArrayIntoGroups(
                                                    element.ms ?? [], logic.getRowsCount(element))
                                                .isNotEmpty)
                                            ? (SportUntil()
                                                .splitArrayIntoGroups(
                                                    element.ms ?? [], logic.getRowsCount(element))
                                                .first
                                                .map((e) {
                                                return Container(
                                                  width: bWidth,
                                                  child: Center(
                                                    child: Text(e.sn ?? '',
                                                        style: ThemeService()
                                                            .theme
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                              color: Color(0xFFB1BAD3),
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400,
                                                            )),
                                                  ),
                                                );
                                              }).toList())
                                            : [],
                                        // children: [
                                        //   Container(
                                        //     width: bWidth,
                                        //     child: Center(
                                        //       child: Text('大于'),
                                        //     ),
                                        //   ),
                                        //   Container(
                                        //     width: bWidth,
                                        //     child: Center(
                                        //       child: Text('大于'),
                                        //     ),
                                        //   ),
                                        //   Container(
                                        //     width: bWidth,
                                        //     child: Center(
                                        //       child: Text('大于'),
                                        //     ),
                                        //   ),
                                        // ],
                                      ),
                                    ),
                                  if (element.pat == 2 || element.pat == 4 || element.pat == 6)
                                    SizedBox(height: 8.h),
                                  ...SportUntil()
                                      .splitArrayIntoGroups(
                                          element.ms ?? [], logic.getRowsCount(element))
                                      .map((e) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                                      child:
                                          (element.pat == 2 || element.pat == 4 || element.pat == 6)
                                              ? Row(
                                                  children: e.asMap().entries.map((k) {
                                                    int index = k.key;
                                                    var value = k.value;
                                                    // print(value.mls);
                                                    // if(value.mls == 2){
                                                    //   print('');
                                                    // }
                                                    // value.mls = 2;
                                                    if (value.ov == '0' ||
                                                        value.ov == '0.0' ||
                                                        value.ov == '0.00') {
                                                      value.mls = 0;
                                                    }
                                                    String l = (value.mls == 0)
                                                        ? S.current.sport_lock
                                                        : S.current.sport_locked;

                                                    return CupertinoButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        if (value.mls == 1) {
                                                          logic.detailBetOrder(value);
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.fromLTRB(0, 4.h,
                                                            index == (e.length - 1) ? 0 : 5.w, 4.h),
                                                        width: bWidth,
                                                        height: 35.h,
                                                        decoration: BoxDecoration(
                                                          color: value.isChoose
                                                              ? ThemeService()
                                                                  .theme
                                                                  .colorScheme
                                                                  .primary
                                                              : ThemeService()
                                                                  .theme
                                                                  .colorScheme
                                                                  .onPrimaryContainer,
                                                          borderRadius: BorderRadius.circular(AppValues
                                                              .sportRadius_4), // Add rounded corners, 10.0 is the radius
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: 10.5.w),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: bWidth / 2,
                                                                child: Text(
                                                                    StringUtil().truncateString(
                                                                            (element.pat == 2 || element.pat == 4)
                                                                                ? value.hdp
                                                                                : value.sn,
                                                                            50) ??
                                                                        '',
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: value.isChoose
                                                                        ? ThemeService()
                                                                            .theme
                                                                            .textTheme
                                                                            .bodyMedium!
                                                                            .copyWith(
                                                                                color: ThemeService()
                                                                                    .theme
                                                                                    .colorScheme
                                                                                    .surface,
                                                                                fontSize: AppValues
                                                                                    .fontBodyMediumSize,
                                                                                fontWeight:
                                                                                    FontWeight.w400)
                                                                        : ThemeService()
                                                                            .theme
                                                                            .textTheme
                                                                            .bodyMedium!
                                                                            .copyWith(
                                                                                fontSize:
                                                                                    AppValues.fontBodyMediumSize,
                                                                                fontWeight: FontWeight.w400)),
                                                              ),
                                                              Expanded(child: SizedBox()),
                                                              if ((value as M).isUp! < 2)
                                                                CustomSportOddChangeAnimation(value,
                                                                    isOddsUp:
                                                                        (value as M).isUp == 1,
                                                                    isIconVisible: (statusType ==
                                                                                OddStatusType
                                                                                    .seletcted ||
                                                                            statusType ==
                                                                                OddStatusType
                                                                                    .unSeletcted)
                                                                        ? false
                                                                        : true),
                                                              value.mls == 1
                                                                  ? Text(
                                                                      OddsUtil().covertOdds(
                                                                          double.tryParse(value.ov ?? '') ??
                                                                              0),
                                                                      style: (value.isChoose ?? false)
                                                                          ? ThemeService()
                                                                              .theme
                                                                              .textTheme
                                                                              .bodyMedium!
                                                                              .copyWith(
                                                                                  fontSize: AppValues
                                                                                      .fontBodyMediumSize,
                                                                                  fontWeight:
                                                                                      FontWeight
                                                                                          .w600)
                                                                          : ThemeService()
                                                                              .theme
                                                                              .textTheme
                                                                              .bodyMedium!
                                                                              .copyWith(
                                                                                  color: ThemeService()
                                                                                      .colorScheme
                                                                                      .secondary,
                                                                                  fontSize: AppValues
                                                                                      .fontBodyMediumSize,
                                                                                  fontWeight:
                                                                                      FontWeight.w600))
                                                                  : Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.start,
                                                                      children: [
                                                                        FaIcon(
                                                                          FontAwesomeIcons.lock,
                                                                          size: 14.w,
                                                                          color: Colors.grey,
                                                                        ),

                                                                        // Text(
                                                                        //   l,
                                                                        //   overflow:
                                                                        //       TextOverflow.ellipsis,
                                                                        //   softWrap: false,
                                                                        //   style: ThemeService()
                                                                        //       .theme
                                                                        //       .textTheme
                                                                        //       .bodyMedium!
                                                                        //       .copyWith(
                                                                        //         // color: ThemeService().colorScheme.secondary,
                                                                        //         // color: AppThemes.onSurfaceColor,
                                                                        //         color: Colors.white
                                                                        //             .withOpacity(0.5),
                                                                        //         fontSize: AppValues
                                                                        //             .fontBodyMediumSize,
                                                                        //         fontWeight:
                                                                        //             FontWeight.w600,
                                                                        //       ),
                                                                        // ),
                                                                      ],
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                )
                                              : Column(
                                                  children: e.asMap().entries.map((k) {
                                                    int index = k.key;
                                                    var value = k.value;
                                                    // print(value.mls);
                                                    // if (value.mls == 2) {
                                                    //   print('');
                                                    // }
                                                    // value.mls == 1
                                                    // print('======ov====${value.ov}');
                                                    if (value.ov == '0' ||
                                                        value.ov == '0.0' ||
                                                        value.ov == '0.00') {
                                                      value.mls = 0;
                                                    }
                                                    String l = (value.mls == 0)
                                                        ? S.current.sport_lock
                                                        : S.current.sport_locked;

                                                    return CupertinoButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        if (value.mls == 1) {
                                                          logic.detailBetOrder(value);
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.fromLTRB(0, 4.h, 0, 4.h),
                                                        // width: bWidth,
                                                        height: 35.h,
                                                        decoration: BoxDecoration(
                                                          color: value.isChoose
                                                              ? ThemeService()
                                                                  .theme
                                                                  .colorScheme
                                                                  .primary
                                                              : ThemeService()
                                                                  .theme
                                                                  .colorScheme
                                                                  .onPrimaryContainer,
                                                          borderRadius: BorderRadius.circular(AppValues
                                                              .sportRadius_4), // Add rounded corners, 10.0 is the radius
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: 10.5.w),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: Get.width / 2 * 1.2,
                                                                child: Text(
                                                                    StringUtil().truncateString(
                                                                            value.sn, 50) ??
                                                                        '',
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: value.isChoose
                                                                        ? ThemeService()
                                                                            .theme
                                                                            .textTheme
                                                                            .bodyMedium!
                                                                            .copyWith(
                                                                                color:
                                                                                    ThemeService()
                                                                                        .theme
                                                                                        .colorScheme
                                                                                        .surface,
                                                                                fontSize: AppValues
                                                                                    .fontBodyMediumSize,
                                                                                fontWeight:
                                                                                    FontWeight.w400)
                                                                        : ThemeService()
                                                                            .theme
                                                                            .textTheme
                                                                            .bodyMedium!
                                                                            .copyWith(
                                                                                fontSize: AppValues
                                                                                    .fontBodyMediumSize,
                                                                                fontWeight:
                                                                                    FontWeight
                                                                                        .w400)),
                                                              ),
                                                              Expanded(child: SizedBox()),
                                                              if ((value as M).isUp! < 2)
                                                                CustomSportOddChangeAnimation(value,
                                                                    isOddsUp:
                                                                        (value as M).isUp == 1,
                                                                    isIconVisible: (statusType ==
                                                                                OddStatusType
                                                                                    .seletcted ||
                                                                            statusType ==
                                                                                OddStatusType
                                                                                    .unSeletcted)
                                                                        ? false
                                                                        : true),
                                                              value.mls == 1
                                                                  ? Text(
                                                                      OddsUtil().covertOdds(
                                                                          double.tryParse(value.ov ?? '') ??
                                                                              0),
                                                                      style: (value.isChoose ?? false)
                                                                          ? ThemeService()
                                                                              .theme
                                                                              .textTheme
                                                                              .bodyMedium!
                                                                              .copyWith(
                                                                                  fontSize: AppValues
                                                                                      .fontBodyMediumSize,
                                                                                  fontWeight:
                                                                                      FontWeight
                                                                                          .w600)
                                                                          : ThemeService()
                                                                              .theme
                                                                              .textTheme
                                                                              .bodyMedium!
                                                                              .copyWith(
                                                                                  color: ThemeService()
                                                                                      .colorScheme
                                                                                      .secondary,
                                                                                  fontSize: AppValues
                                                                                      .fontBodyMediumSize,
                                                                                  fontWeight:
                                                                                      FontWeight.w600))
                                                                  : Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.start,
                                                                      children: [
                                                                        FaIcon(
                                                                          FontAwesomeIcons.lock,
                                                                          size: 14.w,
                                                                          color: Colors.grey,
                                                                        ),

                                                                        // Text(
                                                                        //   l,
                                                                        //   overflow:
                                                                        //       TextOverflow.ellipsis,
                                                                        //   softWrap: false,
                                                                        //   style: ThemeService()
                                                                        //       .theme
                                                                        //       .textTheme
                                                                        //       .bodyMedium!
                                                                        //       .copyWith(
                                                                        //         // color: ThemeService().colorScheme.secondary,
                                                                        //         // color: AppThemes.onSurfaceColor,
                                                                        //         color: Colors.white
                                                                        //             .withOpacity(0.5),
                                                                        //         fontSize: AppValues
                                                                        //             .fontBodyMediumSize,
                                                                        //         fontWeight:
                                                                        //             FontWeight.w600,
                                                                        //       ),
                                                                        // ),
                                                                      ],
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                    );
                                  }),
                                ],
                              ));
                            }),
                            // SliverToBoxAdapter(child: buildBottomRankListTab())
                          ]
                        : [
                            SliverToBoxAdapter(
                                child: Padding(
                              padding: EdgeInsets.only(
                                top: AppValues.sportHeight_20.h,
                                left: AppValues.sportPadding_12.w,
                                right: AppValues.sportPadding_12.w,
                              ),
                              child: Row(
                                children: [
                                  CustomIconButton(
                                    borderRadius: AppValues.sportRadius_4,
                                    backgroundColor: ThemeService().colorScheme.surface,
                                    onTap: () {
                                      RouteUtil.popView();
                                    },
                                    widgetWidth: AppValues.sportWidth_54.w,
                                    widgetHeight: AppValues.sportHeight_44.h,
                                    iconWidget: SvgPicture.asset(
                                      'assets/svg/ic_normal_back.svg',
                                      width: 18,
                                      height: 18,
                                      color: ThemeService().colorScheme.inverseSurface,
                                    ),
                                    // iconThemeData: themeData,
                                  ),
                                  SizedBox(
                                    width: AppValues.sportPadding_12,
                                  ),
                                  CustomButton(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        left: AppValues.sportPadding_28,
                                        right: AppValues.sportPadding_28),
                                    constraints: BoxConstraints(
                                      minHeight: AppValues.sportHeight_44.h,
                                    ),
                                    backgroundColor: ThemeService().colorScheme.surface,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(AppValues.sportRadius_4)),
                                    child: Text(
                                        "${StringUtil().truncateString(state.model.value.list?.first.htn ?? '', 10)} - ${StringUtil().truncateString(state.model.value.list?.first.atn ?? '', 10)}" ??
                                            '',
                                        textAlign: TextAlign.center,
                                        style: ThemeService().theme.textTheme.bodyMedium!.copyWith(
                                            color: ThemeService().colorScheme.inverseSurface,
                                            fontSize: AppValues.fontBodyMediumSize,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  // CustomIconButton(
                                  //   onTap: () {},
                                  //   widgetWidth: AppValues.sportWidth_54.w,
                                  //   widgetHeight: AppValues.sportHeight_44.h,
                                  //   iconWidget: Image.asset(
                                  //     'assets/images/sport/sport_collection.webp',
                                  //     width: AppValues.sportIcon_18.w,
                                  //     height: AppValues.sportIcon_18.h,
                                  //   ),
                                  //   // iconThemeData: themeData,
                                  // ),
                                ],
                              ),
                            )),
                            SliverToBoxAdapter(
                                child: Container(
                              height: Get.height -
                                  AppBar().preferredSize.height -
                                  AppValues.sportHeight_20.h -
                                  AppValues.sportHeight_153.h,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // const SizedBox(height: AppValues.sportHeight_153),
                                    Image.asset(
                                      'assets/images/sport/sport_nodata.webp',
                                      height: AppValues.sportIcon_112.w,
                                      width: AppValues.sportIcon_112.h,
                                    ),
                                    const SizedBox(height: AppValues.sportHeight_16),
                                    Text(S.current.sport_nodata),
                                  ],
                                ),
                              ),
                            )),
                            // SliverToBoxAdapter(child: buildBottomRankListTab())
                          ],
                  ),
                ));
    });
  }

  //创建底部切换排行榜
  Widget buildBottomRankListTab() {
    return <Widget>[
      CasinoTabBar(
        tabs: state.bottomTabs,
        tabController: state.bottomTabController,
      ).paddingTop(AppValues.defaultPadding * 2),
      CustomAutoLayoutTabBarView(controller: state.bottomTabController, children: [
        FrontSportCompetitionView(
          listData: state.betSportList,
        ),
        FrontSportCompetitionView(
          listData: state.betSportList,
        ),
        FrontCompetitionView(
          listData: state.competitonList,
        ),
      ]).paddingTop(AppValues.defaultPadding)
    ].toColumn();
    // return ;
  }

  Widget _buildNoDataView(String title) {
    return Container(
      // height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: AppValues.sportHeight_153),
            Image.asset(
              'assets/images/sport/sport_nodata.webp',
              height: AppValues.sportIcon_112,
              width: AppValues.sportIcon_112,
            ),
            const SizedBox(height: AppValues.sportHeight_16),
            Text(title),
          ],
        ),
      ),
    );
  }

  String getT(String x) {
    if (x == '3' || x == '4') {
      return 'r';
    } else if (x == '5' || x == '6') {
      return 'y';
    } else if (x == '7' || x == '8') {
      return 'c';
    } else if (x == '9' || x == '10') {
      return '1st';
    } else if (x == '11' || x == '12') {
      return '2st';
    } else if (x == '13' || x == '14') {
      return '1st';
    } else if (x == '15' || x == '16') {
      return '2st';
    } else if (x == '17' || x == '18') {
      return '3st';
    } else if (x == '19' || x == '20') {
      return '4st';
    } else if (x == '21' || x == '22') {
      return 'st';
    } else if (x == '25' || x == '26') {
      return '1st';
    } else if (x == '27' || x == '28') {
      return '2st';
    } else if (x == '29' || x == '30') {
      return '3st';
    } else if (x == '31' || x == '32') {
      return '4st';
    } else if (x == '33' || x == '34') {
      return '5st';
    } else if (x == '37' || x == '38') {
      return '1st';
    } else if (x == '39' || x == '40') {
      return '2st';
    } else if (x == '41' || x == '42') {
      return '3st';
    } else if (x == '43' || x == '44') {
      return '4st';
    } else if (x == '45' || x == '46') {
      return '5st';
    }
    return 'uk';
  }

  Widget getC(String t) {
    if (t == '3' || t == '4' || t == '5' || t == '6' || t == '7' || t == '8') {
      String n = 'sport_r.webp';
      if (t == '5' || t == '6') {
        n = 'sport_y.webp';
      } else if (t == '7' || t == '8') {
        n = 'sport_c.webp';
      }
      // assets/images/sport/s_1.webp
      return Image.asset(
        "assets/images/sport/$n",
        width: 14,
        height: 14,
      );
    } else {
      if (getT(t) == 'uk') {
        return Container();
      } else {
        return Text(
          getT(t),
          // '$index',
          style: TextStyle(color: Color(0xFFB1BAD3), fontSize: 14.sp),
        );
      }
    }
  }

  String toS(String t, int st, int? si) {
    try {
      DateTime parsedTime = DateFormat("mm:ss").parse(t);

      int inputTimestamp = st;

      // 将输入的时间戳转换为DateTime对象
      DateTime inputDateTime = DateTime.fromMillisecondsSinceEpoch(inputTimestamp * 1000);

      // 获取当前时间
      DateTime currentDateTime = DateTime.now();

      Duration difference = currentDateTime.difference(inputDateTime);

      DateFormat formatter = DateFormat('mm:ss');

      if (si == 1) {
        DateTime resultDateTime = parsedTime.add(difference);
        return formatter.format(resultDateTime);
      } else {
        DateTime resultDateTime = parsedTime.subtract(difference);
        return formatter.format(resultDateTime);
      }
    } catch (e) {
      return '';
    }
  }
}
