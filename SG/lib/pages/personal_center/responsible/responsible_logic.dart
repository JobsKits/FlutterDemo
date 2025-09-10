import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_controller.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import 'model/betting_item_state.dart';
import 'responsible_state.dart';

///负责人博彩
class ResponsibleLogic extends BaseController with GetTickerProviderStateMixin {
  final ResponsibleState state = ResponsibleState();
  static GlobalKey responsibleGlobalKey = GlobalKey();

  late TabController tabController;

  var tab = [
    Tab(
      child: Text(S.current.responsible_title_self_exclusion, style: ThemeService().theme.textTheme.bodyMedium),
    ),
    Tab(
      child: Text(S.current.responsible_tab_betting_limits, style: ThemeService().theme.textTheme.bodyMedium),
    )
  ];

  var limitTimeTypeMap = [
    // "一日", "一个星期", "一个月", "三个月", "六个月", "一年", "永久性",
    {'type': 1, 'title': S.current.random_text_365},
    {'type': 2, 'title': S.current.random_text_366},
    {'type': 3, 'title': S.current.random_text_367},
    {'type': 4, 'title': S.current.random_text_368},
    {'type': 5, 'title': S.current.random_text_369},
    {'type': 6, 'title': S.current.random_text_370},
    {'type': 7, 'title': S.current.random_text_371},
  ];

  String getLimitTimeTypeLabel(int type) {
    for (var item in limitTimeTypeMap) {
      if (item['type'] == type) {
        return item['title'] as String;
      }
    }
    return "";
  }

  var pageModels = [
    {'index': 0, 'title': S.current.responsible_gaming},//
    {'index': 1, 'title': S.current.responsible_gaming},
    {'index': 2, 'title': S.current.responsible_title_self_exclusion},
  ];

  var bettingItemStateList = [
    BettingItemState(limitMoney: 10.00, curryMoney: 2.00, limitTimeType: 1),
    BettingItemState(limitMoney: 2000.00, curryMoney: 1500.00, limitTimeType: 1),
    BettingItemState(limitMoney: 1500.00, curryMoney: 800.00, limitTimeType: 2),
    BettingItemState(limitMoney: 1000.00, curryMoney: 1000.00, limitTimeType: 3),
    BettingItemState(isBottom: true),
  ].obs;

  //0 当前对话框页面；1点击进入请求自我页面；2点击自我排除设置时间
  final indexedStack = 0.obs;
  final indexedStackTitle = S.current.responsible_gaming.obs;
  var pageStackList = [0];
  var indexedStackShow = false.obs;
  // final size =MediaQuery.of(context).size;
  // final height =size.height;
  final double windowHeightUnit = Get.height/6;
  final double windowListHeightMax = Get.height/6 * 2.5;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(initialIndex: 0, length: tab.length, vsync: this);
  }

  //自我排除，了解更多
  onClickSelfExclusionMore() {
    indexedStack.value = 1;
    settingTitle(1);
    pushStackView(1);
    log('onClickSelfExclusion...${indexedStack.value}');
  }

  //自我排除按钮，去设置时间
  onClickSelfExclusion() {
    indexedStack.value = 2;
    settingTitle(2);
    pushStackView(2);
    log('onClickSelfExclusion...${indexedStack.value}');
  }

  void onClickCloseLastAlert() {
    indexedStack.value = 3;
    settingTitle(3);
    pushStackView(3);
    log('onClickSelfExclusion...${indexedStack.value}');
  }

  //检查栈，是否整体关闭
  onClickCloseLabel() {
    if (pageStackList.isNotEmpty && pageStackList.length > 1) {
      pageStackList.removeLast();
      indexedStack.value = pageStackList.last;
      settingTitle(indexedStack.value);
    } else {
      // onClickCloseLastAlert();
      onClickGoOut();
    }
  }

  onClickGoOut() {
    Get.delete<ResponsibleLogic>();
    GlobalState.instance.isEdit = false;
    RouteUtil.popView();
  }

  settingTitle(int index) {
    indexedStackTitle.value = pageModels[index]['title'] as String;
    log('日志：pageModels...'+pageStackList.toString());
  }

  //进栈
  int pushStackView(int index) {
    pageStackList.add(index);
    return index;
  }

  //退栈
  removeStackView(int index) {
    pageStackList.remove(index);
  }
}
