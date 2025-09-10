import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/sport/sport_bet/widget/sport_my_bet_activity.dart';
import 'package:flutter_bet/pages/sport/sport_bet/widget/sport_my_bet_done.dart';
import 'package:get/get.dart';
import '../../../constant/app_themes.dart';
import '../../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../../widget/custom_Keep_alive_wrapper.dart';
import '../../../widget/network_image/custom_network_image_placeholder.dart';
import '../../../widget/sport/custom_sport_odd_type.dart';
import '../../../widget/sport/custom_sport_section.dart';
import '../../betting/sport/widget/sport_bet_slip_tabbar.dart';
import 'logic.dart';
import '../../../base/getx/base_view.dart';
import 'widget/sport_my_bet_params.dart';

class SportBetWidget extends StatefulWidget {
  SportBetWidget({Key? key, this.index}) : super(key: key);

  final int? index;

  @override
  State<SportBetWidget> createState() => _SportBetWidgetState();
}

class _SportBetWidgetState extends State<SportBetWidget> {
  // final logic = Get.put(SportBetLogic());
  final controller = Get.put(SportBetLogic());

  final state = Get.find<SportBetLogic>().state;

  @override
  void initState() {
    super.initState();
    ever(controller.state.betListActivity, (callback) {
      log("我的投注界面...tab...betListActivity 数据变化");
      // setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    log("我的投注...build...");
    controller.state.buildData();
    return Obx(() => controller.state.loading.value ? SizedBox(
      height: 150,
      child: CustomNetWorkImagePlaceholder(
        color: AppThemes.surfaceVariant.withOpacity(0),
        placeholderType: NetWorkImagePlaceholderType.loading,
        // borderRadius: borderRadius,
        // border: border,
      ))
      : Obx(() {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: AppValues.defaultMargin),
              alignment: Alignment.centerLeft,
              child: SportBetSlipTabbar(
                tabController: controller.myBetTabController,
                tabs: controller.state.myBetTabs,
              ),
            ),
            // _buildLine(),
            // buildTabBarView(),
            // CustomAutoLayoutTabBarView(
            //   controller: controller.myBetTabController.value,
            //   children: [
            //     SportMyBetActivity(),
            //     SportMyBetDone(),
            //   ],
            // ),
            Offstage(
              offstage: controller.selectTabIndex.value!=0,
              child: SportMyBetActivity(fromPage:SportMyBetFromPage.fromSportHome),
            ),
            Offstage(
              offstage: controller.selectTabIndex.value!=1,
              child: SportMyBetDone(fromPage:SportMyBetFromPage.fromSportHome),
            ),
          ],
        );
      })
    );
  }

  // Widget buildTabBarView() {
  //   if (controller.selectTabIndex.value == 0) {
  //     // return CustomKeepAliveWrapper(child: SportMyBetActivity());
  //     return SportMyBetActivity();
  //   }
  //   if (controller.selectTabIndex.value == 1) {
  //     // return CustomKeepAliveWrapper(child: SportMyBetDone());
  //     return SportMyBetDone();
  //   } else {
  //     return Container();
  //   }
  // }

  @override
  void didChangeDependencies() {
    controller.loadActivityInfo(0);
    super.didChangeDependencies();
  }
}
