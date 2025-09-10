import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_controller.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import 'data_count_state.dart';

class DataCountLogic extends BaseController with GetTickerProviderStateMixin {
  final DataCountState state = DataCountState();
  late TabController tabController;
  final double windowHeightUnit = Get.height/6;
  final double windowListHeightMax = Get.height/6 * 2;
  BuildContext? context;
  var tab = [
    Tab(
      child: Text(S.current.data_count_data, style: ThemeService().theme.textTheme.bodyMedium),
    ),
    Tab(
      child: Text(S.current.tab_bar_title_trophy_text, style: ThemeService().theme.textTheme.bodyMedium),
    ),
    Tab(
      child: Text(S.current.data_count_race, style: ThemeService().theme.textTheme.bodyMedium),
    ),
    Tab(
      child: Text(S.current.data_count_activity, style: ThemeService().theme.textTheme.bodyMedium),
    )
  ];

  var cupTypes = [
    S.current.random_text_353,
    S.current.random_text_354,
    S.current.random_text_355,
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: tab.length);
  }
}
