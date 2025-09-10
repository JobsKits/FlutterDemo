import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';

import '../../constant/app_values.dart';

/// 整体滚动， 特别是针对有TabBarView
class CustomNestedScrollView extends StatelessWidget {
  const CustomNestedScrollView({
    super.key,
    required this.headerSliverBuilder,
    required this.sliverFillView,
    this.physics,
    this.sliverFillViewMargin,
    this.sliverFillViewPadding, this.scrollController,
  });

  final NestedScrollViewHeaderSliversBuilder headerSliverBuilder; //SliverToBoxAdapter

  final Widget sliverFillView; //剩余的布局, 如果是TabBar 一定要使用原生的TabBarView
  final EdgeInsetsGeometry? sliverFillViewMargin;
  final EdgeInsetsGeometry? sliverFillViewPadding;
  final ScrollPhysics? physics;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExtendedNestedScrollView(
        controller: scrollController,
        // physics: physics ?? const BouncingScrollPhysics(),
        physics: physics ,
        headerSliverBuilder: headerSliverBuilder,
        onlyOneScrollInBody: true,
        body: Container(
          margin: sliverFillViewMargin,
          padding: sliverFillViewPadding ?? EdgeInsets.only(bottom: AppValues.barBottomHeight),
          child: sliverFillView,
        ),
      ),
    );
  }
}
