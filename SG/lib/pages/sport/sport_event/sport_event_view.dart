import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/main/code.dart';
import 'package:flutter_bet/pages/main/logic.dart';
import 'package:flutter_bet/pages/sport/common_model/sport_common_params.dart';
import 'package:flutter_bet/pages/sport/sport_event/sport_event_binding.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/custom_Keep_alive_wrapper.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_view.dart';
import '../../../constant/app_values.dart';
import '../../../routes/routes.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/button/custom_icon_button.dart';
import '../../../widget/custom_top_appbar_view.dart';
import '../../../widget/tab_bar/custom_tab_bar_with_icon.dart';
import 'all/sport_all_view.dart';
import 'betting/sport_betting_view.dart';
import 'opening/sport_opening_view.dart';
import 'sport_event_logic.dart';

///体育赛事明细：包括即将开赛盘口、冠军投注、全部[足球、篮球等等]
class SportEventPage extends BaseView<SportEventLogic> {
  SportEventPage({Key? key, this.pageTag})
      : logic = Get.find<SportEventLogic>(tag: pageTag),
        // state = Get.find<SportEventLogic>(tag: pageTag).state,
        super(key: key);

  final SportEventLogic logic;

  ///本页面唯一的标签， 可以传递给页面， 来区分不同页面 的controller
  final String? pageTag;

  /// 打开本页面
  /// si 体育ID， eid 体育标题
  /// pageTag 默认不传的话表示第一个，要同时打开多个 必须传递tag, 来区分不同的controller
  /// 以及在路由调用，必须设置属性  preventDuplicates: false, //关闭防止重复
  static openPage(SportOpenPageParams params, {String? pageTag}) {
    // RouteUtil.pushToView(Routes.sport_sport_detail);
    // 使用下面的方法；不能重复除非，给设置属性  preventDuplicates: false, //防止重复
    // RouteUtil.pushToView(
    //   Routes.sport_event_detail,
    //   arguments: {'pageParams': params},
    //   notRepeat: false,
    // );
    ///以时间戳来 作为页面控制器controller 的tag
    var tag = DateTime.now().toString();
    Get.to(
      () => SportEventPage(pageTag: tag),
      binding: SportEventBinding(pageTag: tag),
      arguments: {'pageParams': params},
      preventDuplicates: false, //关闭防止重复
    );
  }

  @override
  String? get tag => pageTag;

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

  @override
  Widget buildBody(BuildContext context) {
    log("SportEventPage页面...onInit...${this.hashCode}");
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: ScrollController(),
      // shrinkWrap: true,
      slivers: [
        SliverToBoxAdapter(child: _buildTopTitle()),
        SliverToBoxAdapter(child: _buildTabBarView()),
        SliverFillRemaining(child: _buildTabBarPageView()),
        // SliverToBoxAdapter(child: CustomBettingRankWidget(competitonList: logic.competitonList)),
      ],
    );
  }

  ///顶部部分：返回 、标题
  _buildTopTitle() {
    if (logic.t.value > 0) {
      return Padding(
        padding: EdgeInsets.only(
          top: AppValues.sportHeight_20.h,
          left: AppValues.sportPadding_12.w,
          right: AppValues.sportPadding_12.w,
        ),
        child: Container(
          height: AppValues.sportHeight_44.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              if (logic.t.value > 0)
                CustomButton(
                  onTap: () => logic.onClickToPage(SportOpenType.viewAll, 1),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      left: AppValues.sportPadding_8, right: AppValues.sportPadding_8),
                  constraints: BoxConstraints(
                    minHeight: AppValues.sportHeight_44.h,
                  ),
                  backgroundColor: ThemeService().colorScheme.surface,
                  borderRadius: BorderRadius.all(Radius.circular(AppValues.sportRadius_4)),
                  child: Text('   ' + (logic.model.value.list?.first.sn ?? '') + '   ',
                      textAlign: TextAlign.center,
                      style: ThemeService().theme.textTheme.bodyMedium!.copyWith(
                          color: logic.t.value == 1
                              ? Color(0xFFB1BAD3)
                              : ThemeService().colorScheme.inverseSurface,
                          fontSize: AppValues.fontBodyMediumSize,
                          fontWeight: FontWeight.w600)),
                ),
              if (logic.t.value > 1)
                Container(
                  color: ThemeService().colorScheme.surface,
                  child: Image.asset(
                    'assets/images/sport/sport_g.webp',
                    height: AppValues.sportHeight_44.h,
                    width: AppValues.sportHeight_44.h / 114 * 63,
                  ),
                ),
              if (logic.t.value > 1)
                CustomButton(
                  onTap: () => logic.onClickToPage(SportOpenType.league, 2),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      left: AppValues.sportPadding_8, right: AppValues.sportPadding_8),
                  constraints: BoxConstraints(
                    minHeight: AppValues.sportHeight_44.h,
                  ),
                  backgroundColor: ThemeService().colorScheme.surface,
                  borderRadius: BorderRadius.all(Radius.circular(AppValues.sportRadius_4)),
                  child: Text(logic.model.value.list?.first.pgn ?? '',
                      textAlign: TextAlign.center,
                      style: ThemeService().theme.textTheme.bodyMedium!.copyWith(
                          color: logic.t.value == 2
                              ? Color(0xFFB1BAD3)
                              : ThemeService().colorScheme.inverseSurface,
                          fontSize: AppValues.fontBodyMediumSize,
                          fontWeight: FontWeight.w600)),
                ),
              if (logic.t.value > 2)
                Container(
                  color: ThemeService().colorScheme.surface,
                  child: Image.asset(
                    'assets/images/sport/sport_g.webp',
                    height: AppValues.sportHeight_44.h,
                    width: AppValues.sportHeight_44.h / 114 * 63,
                  ),
                ),
              if (logic.t.value > 2)
                CustomButton(
                  onTap: () => logic.onClickToPage(SportOpenType.league, 3),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      left: AppValues.sportPadding_8, right: AppValues.sportPadding_8),
                  constraints: BoxConstraints(
                    minHeight: AppValues.sportHeight_44.h,
                  ),
                  backgroundColor: ThemeService().colorScheme.surface,
                  borderRadius: BorderRadius.all(Radius.circular(AppValues.sportRadius_4)),
                  child: Text(logic.model.value.list?.first.cn ?? '',
                      textAlign: TextAlign.center,
                      style: ThemeService().theme.textTheme.bodyMedium!.copyWith(
                          color: Color(0xFFB1BAD3),
                          fontSize: AppValues.fontBodyMediumSize,
                          fontWeight: FontWeight.w600)),
                ),
              if (logic.t.value > 3)
                Container(
                  color: ThemeService().colorScheme.surface,
                  child: Image.asset(
                    'assets/images/sport/sport_g.webp',
                    height: AppValues.sportHeight_44.h,
                    width: AppValues.sportHeight_44.h / 114 * 63,
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        // width: constraints.maxWidth,
        padding: EdgeInsets.only(
          top: AppValues.sportHeight_20.h,
          left: AppValues.sportPadding_12.w,
          right: AppValues.sportPadding_12.w,
        ),
        child: Row(
          // mainAxisSize: MainAxisSize.max,
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

            // 超出元素的父级元素采用 Expanded
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.sportPadding_28, vertical: 13),
                    constraints: BoxConstraints.loose(Size.fromWidth(300.w)),
                    // .copyWith(minHeight: AppValues.sportHeight_44.h),
                    // decoration: BoxDecoration(
                    //   color: Colors.red,
                    //   borderRadius: const BorderRadius.all(Radius.circular(AppValues.sportRadius_4)),
                    // ),
                    decoration: BoxDecoration(
                      color: ThemeService().colorScheme.surface,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(AppValues.sportRadius_4)),
                    ),

                    child: CustomText(
                      logic.sportTitle.value,
                      // "logic.sportTitle.valuelogic.sportTitle.value12312312312",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: ThemeService().textTheme.bodyMedium!.copyWith(
                          color: ThemeService().colorScheme.inverseSurface,
                          fontSize: AppValues.fontBodyMediumSize,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  // Spacer(),
                ],
              ),
            ),

            // Expanded(
            //   child: Row(
            //     children: [
            //       Container(
            //         alignment: Alignment.centerLeft,
            //         padding: const EdgeInsets.only(
            //             left: AppValues.sportPadding_28, right: AppValues.sportPadding_28),
            //         // constraints: BoxConstraints(
            //         //   minHeight: AppValues.sportHeight_44.h,
            //         //   // maxWidth: 250,
            //         // ),
            //         constraints: BoxConstraints.loose(Size.fromWidth(280.w))
            //             .copyWith(minHeight: AppValues.sportHeight_44.h),
            //         decoration: BoxDecoration(
            //           color: ThemeService().colorScheme.surface,
            //           borderRadius: const BorderRadius.all(Radius.circular(AppValues.sportRadius_4)),
            //         ),
            //         // backgroundColor: ThemeService().colorScheme.surface,
            //         // borderRadius: const BorderRadius.all(Radius.circular(AppValues.sportRadius_4)),
            //
            //         child: CustomText(
            //           logic.sportTitle.value,
            //           // "logic.sportTitle.valuelogic.sportTitle.value12312312312",
            //           maxLines: 2,
            //           overflow: TextOverflow.ellipsis,
            //           textAlign: TextAlign.left,
            //           style: ThemeService().textTheme.bodyMedium!.copyWith(
            //               color: ThemeService().colorScheme.inverseSurface,
            //               fontSize: AppValues.fontBodyMediumSize,
            //               fontWeight: FontWeight.w600),
            //         ),
            //       ),
            //       // Spacer(),
            //     ],
            //   ),
            // ),

            // ConstrainedBox(
            //   constraints: BoxConstraints.loose(Size.fromWidth(200)),
            //   child: SizedBox(width:100),
            // ),
            // Spacer(),
            // SizedBox(width: 1),
            ///收藏星星✨
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
      );
    }
  }

  ///tabbar
  _buildTabBarView() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppValues.defaultPadding,
        vertical: AppValues.defaultMargin,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(49),
        color: ThemeService().theme.colorScheme.surface, // 设置背景色
        // color: ThemeService().theme.colorScheme.tertiary,
      ),
      // child: DefaultTabController(
      //   length: logic.tabList.length,
      child: CustomTabBarWithIcon(
        tabController: logic.tabController,
        // 将TabController与TabBar关联
        tabs: logic.tabList,
        backgroundColor: ThemeService().theme.colorScheme.tertiary,
        radius: 44,
        height: 54,
        buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      // ),
    );
  }

  _buildTabBarPageView() {
    return Container(
      // color: ThemeService().colorScheme.surface, // 设置背景色
      // padding: EdgeInsets.all(AppValues.defaultMargin),
      // height: 600.h,
      // height: 200,
      padding: const EdgeInsets.only(
        left: AppValues.defaultPadding,
        right: AppValues.defaultPadding,
        // left: AppValues.sportPadding_12.w,
        // right: AppValues.sportPadding_12.w,
        bottom: AppValues.largeMargin,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        // log("TabBarView...constraints...$constraints");
        //CustomSportTabbar
        return CustomAutoLayoutTabBarView(
          physics: const NeverScrollableScrollPhysics(), //禁止滑动
          controller: logic.tabController, // 将TabController与TabBarView关联
          children: [
            //滚球盘与即将开赛盘口
            ConstrainedBox(
                constraints: constraints,
                child: CustomKeepAliveWrapper(
                    child: SportOpeningPage(
                        pageTag: this.hashCode.toString(), params: logic.pageParams))),
            //冠军投注
            ConstrainedBox(
                constraints: constraints,
                child: CustomKeepAliveWrapper(
                    child: SportBettingPage(
                        pageTag: this.hashCode.toString(), params: logic.pageParams))),
            //全部足球[篮球、网球等等]
            ConstrainedBox(
                constraints: constraints,
                child: CustomKeepAliveWrapper(
                    child:
                        SportAllPage(pageTag: this.hashCode.toString(), params: logic.pageParams))),
          ],
        );
      }),
    );
  }
}
