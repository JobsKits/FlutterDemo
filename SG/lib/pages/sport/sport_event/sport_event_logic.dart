import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/sport/common_model/sport_common_params.dart';
import 'package:flutter_bet/pages/sport/tabmodel.dart';
import 'package:flutter_bet/services/api/extension/sport_api_service.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_controller.dart';
import '../../../generated/l10n.dart';
import '../../../routes/routes.dart';
import '../../../services/api/api_service.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/betting_list/logic.dart';
import '../../alliance_plan/widget/custom_select_model.dart';
import '../common_model/sport_handicap_select_model.dart';
import '../common_model/sport_outrihgt_api_model.dart';
import '../sport_detail/model.dart';
import 'sport_event_state.dart';

class SportEventLogic extends BaseController with GetTickerProviderStateMixin {
  //GetTickerProviderStateMixin
  //GetSingleTickerProviderStateMixin 以前使用这个
  final SportEventState state = SportEventState();

  // final  tabController =  Rxn<TabController>();
  late TabController tabController;
  final PageController pageController = PageController();

  late List<Tab> tabList;

  var expand = false.obs;

  String sn = "";
  var sportId = 0.obs;
  var sportTitle = ''.obs;

  var t = 0.obs;
  int si = 1;
  String eid = '1';
  var model = SportDetailModel().obs;

  RxList<SportHallCountModel> games = <SportHallCountModel>[].obs;

  //冠军
  RxList<SportOutRightModel> championList = <SportOutRightModel>[].obs;

  final competitonList = [
    CompetitionBean(
        name: S.current.random_text_238,
        icon: 'assets/images/bet_slip/ic_no_one.webp',
        money: '\$19,782,2390',
        moneyIcon: 'assets/images/bet_slip/ic_eth_bet_icon.webp',
        bonusMoney: '35%'),
  ].obs;

  late SportOpenPageParams pageParams; //打开页面参数
  late var tabbarCategoryJson = [
    {
      "icon": 'assets/images/sport/sport_hall.webp',
      "name": S.current.sport_rolling_coming,
      "tgn": S.current.sport_rolling_coming,
      "tgi": 0,
    },
    {
      "icon": 'assets/images/sport/sport_bet.webp',
      "name": S.current.sport_champion,
      "tgn": S.current.sport_champion,
      "tgi": 0,
    },
    {
      "icon": 'assets/images/sport/sport_collection.webp',
      "name": S.current.sport_all,
      "tgn": S.current.sport_all,
      "tgi": 0,
    },
  ];

  // ///游戏类型选择范围
  // List<CustomSelectModel> selectTypeList = <CustomSelectModel>[
  //   CustomSelectModel('总分盘'),
  //   CustomSelectModel('让分盘'),
  //   CustomSelectModel('获胜盘'),
  // ];

  @override
  void onInit() {
    log("页面周期方法...onInit...");
    super.onInit();

    ///获取页面参数
    pageParams = Get.arguments['pageParams'];
    if (pageParams != null) {
      sportId.value = pageParams.si;
      sportTitle.value = pageParams.title;
      t.value = pageParams.t ?? 0;
      eid = pageParams.eid ?? '1';
      log("页面参数...$pageParams");
    }

    ///初始化tab
    initTabList();

    if (t > 0) {
      getContestDetailData();
    }
  }

  @override
  void onReady() {
    log("页面周期方法...onReady...");
    super.onReady();
  }

  @override
  void onClose() {
    // tabController.value?.dispose();
    tabController.dispose();
    super.onClose();
  }

  ///设置tabview
  initTabList() {
    //显示 比如 "全部 足球"
    var lastItem = tabbarCategoryJson.last;
    tabList = tabbarCategoryJson
        .map<Tab>((item) => Tab(
                child: Text(
              item != lastItem
                  ? item['name'] as String
                  : "${item['name'] as String} ${pageParams.categoryTitle}",
              style: ThemeService().theme.textTheme.bodyMedium,
            )))
        .toList();

    ///判断侧边栏是live or rolling 进来，还是Outright
    var index = 0;
    if (pageParams.isOutRightTab()) {
      index = 1;
    } else if (pageParams.isViewAllTab()) {
      index = 2;
    }

    tabController =
        TabController(initialIndex: index, length: tabbarCategoryJson.length, vsync: this);
    tabController.animateTo(index);
  }

  Future<void> getContestDetailData() async {
    await ApiService.instance.getContestDetail(
        si: si,
        ei: eid,
        success: (res) {
          if (res.data['list'] == null) {
            res.data['list'] = [];
          }
          model.value = SportDetailModel.fromJson(res.data);
        },
        fail: (e) {});
  }

  onClickToPage(SportOpenType type, int tt) {
    SportOpenPageParams pageParams = SportOpenPageParams(
      sportOpenType: type,
      si: sportId.value,
      title: sportTitle.value,
      // ci: state.model.value.list?.first.ci ?? '',
      // pgid: state.model.value.list?.first.pgid ?? '',
      t: tt,
      eid: eid,
    );

    t.value = tt;
    Get.offAndToNamed(
      Routes.sport_event_detail,
      arguments: {'pageParams': pageParams},
    )?.then((value) {
      print('object');
    });
  }
}
