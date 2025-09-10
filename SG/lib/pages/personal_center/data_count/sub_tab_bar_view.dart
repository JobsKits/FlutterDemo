import 'package:flutter/widgets.dart';
import 'package:flutter_bet/pages/personal_center/data_count/data_count_logic.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/tab_bar/custom_tabbar_covered.dart';
import 'list/activity_list_view.dart';
import 'list/cup_list_view.dart';
import 'list/data_list_view.dart';
import 'list/race_list_view.dart';

/// tab he content
class SubTabBarView extends StatefulWidget {
  const SubTabBarView({super.key});

  @override
  State<SubTabBarView> createState() => _SubTabBarViewState();
}

class _SubTabBarViewState extends State<SubTabBarView> with SingleTickerProviderStateMixin {
  final DataCountLogic controller = Get.find<DataCountLogic>();
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller.context = context;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: _globalKey,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: AppValues.defaultPadding),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(49),
            color: ThemeService().theme.colorScheme.surface, // 设置背景色
          ),
          child: CustomTabBarCoveredIcon(
            tabController: controller.tabController,
            // 将TabController与TabBar关联
            tabs: controller.tab,
            backgroundColor: ThemeService().theme.colorScheme.tertiary,
            radius: 49,
            height: 54,
            buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
            contentPadding:const EdgeInsets.symmetric(horizontal: 6),
            sideMargin:const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        Container(
          // margin: const EdgeInsets.all(AppValues.defaultMargin),
          margin: const EdgeInsets.only(bottom:  AppValues.defaultMargin),
          child: CustomAutoLayoutTabBarView(
            physics: const NeverScrollableScrollPhysics(), //禁止滑动
            controller: controller.tabController, // 将TabController与TabBarView关联
            children: [
              DataListView(controller: controller),
              CupListView(controller: controller, globalKeyS: _globalKey),
              RaceListView(controller: controller),
              ActivityListView(controller: controller),
            ],
          ),
        ),
      ],
    );
  }
}
