import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/pages/find/logic.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../widget/refresh/custom_pull_to_refresh.dart';

///导航栏导航背景
Widget casinoBuildMainBg({required List<Widget> children, required FindLogic controller}) {
  return CustomPullToRefresh(
    onRefresh: controller.onrefresh,
    onLoadMore: controller.onLoadMore,
    controller: controller.pullToRefreshController,
    scrollController: controller.scrollcontroller,
    child: CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      slivers: children,
    ),
  );
}
