import 'package:flutter/material.dart';

import '../../constant/app_values.dart';
import 'custom_nested_scroll_view.dart';

///在[CustomNestedScrollView] 基础上 添加 tabbarView
class CustomNestedScrollTabView extends StatelessWidget {
  const CustomNestedScrollTabView({
    super.key,
    required this.tabController,
    required this.headerViews,
    required this.tabChildViews,
    this.tabViewMargin,
    this.tabViewPadding,
    this.physics,
    this.tabPhysics,
    this.scrollController,
  });

  final List<Widget> headerViews;
  final List<Widget> tabChildViews;

  final TabController tabController;
  final EdgeInsetsGeometry? tabViewMargin;
  final EdgeInsetsGeometry? tabViewPadding;
  final ScrollPhysics? physics;
  final ScrollPhysics? tabPhysics;
  final ScrollController? scrollController;

  // headerSliverBuilder: (context, value) {
  //   return [
  //     SliverToBoxAdapter(child: _buildTopView()),
  //     SliverToBoxAdapter(child: _buildTabBarView()),
  //   ];
  // },
  @override
  Widget build(BuildContext context) {
    return CustomNestedScrollView(
      scrollController: scrollController,
      physics: physics,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        //需要添加 SliverToBoxAdapter
        return headerViews.map((view) => SliverToBoxAdapter(child: view)).toList();
      },
      sliverFillView: TabBarView(
        // physics: tabPhysics ?? const ClampingScrollPhysics(),
        physics: tabPhysics ,
        controller: tabController,
        children: tabChildViews,
      ),
      sliverFillViewMargin: tabViewMargin,
      sliverFillViewPadding: tabViewPadding,
    );
  }
}
