import 'dart:developer';

import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../../widget/measure/custom_measure_size_widget.dart';
import '../../../widget/status/custom_load_state_view.dart';
import '../../../widget/tab_bar/custom_tab_bar_point_view.dart';
import '../wmodel/alliance_common_params.dart';
import 'commission_rate_logic.dart';
import 'commission_rate_view_list.dart';

///联盟计划-拥挤比例tab
class CommissionRatePage extends StatefulWidget {
  const CommissionRatePage({
    Key? key,
    this.showTypeLabel,
    this.canScroll,
    this.tabColor,
    this.titleColor,
    this.isStudy,
  }) : super(key: key);
  final bool? showTypeLabel; //默认显示
  final bool? canScroll;
  final Color? tabColor;
  final Color? titleColor;
  final bool? isStudy; //是否在我的教程中显示

  @override
  State<CommissionRatePage> createState() => _CommissionRatePageState();
}

class _CommissionRatePageState extends State<CommissionRatePage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.put(CommissionRateLogic());
  final state = Get.find<CommissionRateLogic>().state;

  //todo:0612.为了兼容类似H5的整体滑动
  final _measureHeightObs = 0.0.obs;

  double getMeasureHeight(double defaultHeight) =>
      _measureHeightObs.value > defaultHeight ? _measureHeightObs.value : defaultHeight;

  set measureHeight(double height) => _measureHeightObs.value = height;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<CommissionRateLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      height: 500,
      child: Obx(() {
        return CustomLoadStateLayout(
          // configType: ,
          configState: logic.pageStateObs.value,
          configRetry: (pageState) => logic.loadTwoNetData(),
          configSuccess: logic.pageSuccessObs.value ? _configSuccessView() : Container(),
          emptyImage: "assets/images/status/ic_status_view_empty0dp.webp",
          showErrorRetry: false,
          showEmptyRetry: false,
          showNetErrorRetry: false,
        );
      }),
    );
  }

  _configSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          //此处 在推广教程中 会被用到， 不显示label
          //另一种情况是 类型tab 为一个时，同样不显示label
          visible: widget.showTypeLabel ?? logic.showTabView(),
          child: Container(
            margin: EdgeInsets.only(bottom: 4),
            child: CustomText(
              S.current.random_text_522,
              style: ThemeService().textTheme.labelLarge?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
        _buildTabView(),
        // Container(height: 1, color: ThemeService().theme.colorScheme.tertiary),
        // SizedBox(height: AppValues.defaultMargin),
        _buildTabBarView(),
        // Spacer(),
      ],
    );
  }

  ///构建tab
  _buildTabView() {
    return Visibility(
      visible: logic.showTabView(),
      child: Container(
        // height: 56,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: widget.tabColor ?? ThemeService().theme.colorScheme.surface, // 设置背景色
          // color: widget.showTypeLabel!
          //     ? ThemeService().theme.colorScheme.surface
          //     : ThemeService().colorScheme.surfaceVariant,
          // borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: CustomTabBarPointView(
          indicatorColor: ThemeService().theme.colorScheme.secondary,
          tabController: logic.tabController,
          tabs: logic.tabList.value,
          // isScrollable: !GlobalStateController.of().isChinese() ,
          // isScrollable: logic.tabList.length > 2,
          //为什么不是3 个呢， 应为3个的话越文 会显示不下
          indicatorWidth: 10,
          labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(2), bottomRight: Radius.circular(2)),
        ),
      ),
    );

    return Container(
      height: 50,
      child: TabBar(
        // tabController: controller.tabController,
        controller: logic.tabController,
        // automaticIndicatorColorAdjustment: false,
        //   indicatorColor: Colors.transparent,
        indicatorColor: ThemeService().colorScheme.primary,
        indicatorWeight: 1.5,
        // 将TabController与TabBar关联
        tabs: logic.tabList,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        // unselectedLabelStyle: TextStyle(color: Colors.red),
        labelColor: ThemeService().colorScheme.primary,
        unselectedLabelColor: ThemeService().colorScheme.onSurfaceVariant,
        // dividerColor: Colors.red,
        // backgroundColor: ThemeService().theme.colorScheme.surface,
        // radius: 49,
        // height: 54,
        // buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
        // contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  ///构建tab bar 正文显示区域
  _buildTabBarView() {
    return Expanded(
      child: LayoutBuilder(builder: (_, constraints) {
        return Obx(() {
          // return TabBarView(
          //   controller: logic.tabController,
          //   physics: const BouncingScrollPhysics(),
          //   children: logic.modelListMapObs.entries.map((e) {
          //     return ConstrainedBox(
          //       constraints: BoxConstraints.tightFor(height: constraints.maxHeight),
          //       child: CommissionRateListView(pageTypeEnum: e.key, modelList: e.value),
          //     );
          //   }).toList(),
          // );
          return CustomAutoLayoutTabBarView(
            physics: const NeverScrollableScrollPhysics(), //禁止滑动
            // physics: const BouncingScrollPhysics(),
            controller: logic.tabController, // 将TabController与TabBarView关联
            children: logic.tabModelListObs.map((e) {
              return ConstrainedBox(
                constraints: BoxConstraints.tightFor(height: constraints.maxHeight),
                child: CommissionRateListView(
                  modelList: e.data ?? [],
                  canScroll: widget.canScroll ?? false,
                  titleColor: widget.titleColor,
                  isStudy: widget.isStudy,
                ),
              );
            }).toList(),
            // children: [
            // ConstrainedBox(
            //   constraints: BoxConstraints.tightFor(height: constraints.maxHeight),
            //   child:  CommissionRateListView(pageTypeEnum: CommissionRateTypeEnum.realPerson),
            // ),
            // ConstrainedBox(
            //   constraints: BoxConstraints.tightFor(height: constraints.maxHeight),
            //   child:  CommissionRateListView(pageTypeEnum: CommissionRateTypeEnum.fishing),
            // ),
            // ConstrainedBox(
            //   constraints: BoxConstraints.tightFor(height: constraints.maxHeight),
            //   child:  CommissionRateListView(pageTypeEnum: CommissionRateTypeEnum.electronic),
            // ),
            // ConstrainedBox(
            //   constraints: BoxConstraints.tightFor(height: constraints.maxHeight),
            //   child: CommissionRateListView(pageTypeEnum: CommissionRateTypeEnum.sport),
            // ),
            // ConstrainedBox(
            //   constraints: BoxConstraints.tightFor(height: constraints.maxHeight),
            //   child: CommissionRateListView(pageTypeEnum: CommissionRateTypeEnum.chessCard),
            // ),
            // ],
          );
        });
      }),
    );
  }
}
