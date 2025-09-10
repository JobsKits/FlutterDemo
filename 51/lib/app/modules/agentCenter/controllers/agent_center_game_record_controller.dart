import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/agent_center_api.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/Finance.const.dart';
import 'package:flutter_tiyu_app/app/modules/home/new_home_const.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/kernel/utils/bet_history_config.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';
import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import '../../home/controllers/new_home_controller.dart';
import '../widget/cascader/ym_cascader_data_bean.dart';

class AgentCenterGameRecordController extends GetxController
    with WidgetsBindingObserver {
  RxBool isLoading = false.obs; // loading

  late NewHomeController homeController = Get.find();

  // ------------------------------
  RxBool isInit = false.obs;

  RxList<List<YmPickerDataBean>> gameListData =
      <List<YmPickerDataBean>>[[], []].obs; //数据
  RxMap<int, List<YmPickerDataBean>> gameListMap =
      <int, List<YmPickerDataBean>>{}.obs; // map 数据

  RxList<int> gameIndex = <int>[0, 0].obs; // 显示的索引
  RxList<int> nextGameIndex = <int>[0, 0].obs; // 最近一次保存的索引

  RxString gameName = ''.obs; // 选中的游戏名称

  // ------------------------------ 查询条件
  RxString username = ''.obs; // 会员账号
  RxString defaultUsername = ''.obs; // 会员账号

  // ------------------------------返回数据
  RxList<dynamic> dataList = <dynamic>[].obs; // 数据

  // ------------------------------
  Rx<DateTime> endTime = dateTimeBy[0].obs; // 结束时间（现在时间）
  Rx<DateTime> startTime = dateTimeBy[1].obs; // 开始时间
  Rx<DateTime> changeTime = dateTimeBy[0].obs; // 记录日期组件变化时的时间
  RxBool isCheckedStartTime = false.obs; // 记录是点击了哪一个

  // ------------------------------
  int page = 1; // 当前页
  int pageSize = 10; // 当前
  RxBool isRequest = false.obs; // 正在请求

  RxBool isNeedReset = false.obs; // 是否需要重置

  bool hasMore = false; //是否还有必要加载更多
  late ScrollController scrollController;
  ScrollController mainScrollController = ScrollController();

  RxList<dynamic> subList = <dynamic>[].obs; // 下级列表
  RxString selectAcctId = ''.obs; // 选中数据
  RxString custId = ''.obs;

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isRequest.value) {
        loadMoreData(null);
      }
    });

    initData();
  }

  @override
  void onClose() {
    super.onClose();

    mainScrollController.dispose();
    scrollController.dispose();
  }

  // 数据请求
  Future<void> initData() async {
    isInit.value = false;
    await initGameVenues();

    if (gameListData[0].isNotEmpty) {
      Map<int, List<YmPickerDataBean>> newGameListMap = {};

      for (int i = 0; i < gameListData[0].length; i++) {
        var data = await initGamePlatform(idx: i, useMap: true);
        newGameListMap[i] = data;
      }

      gameListMap.value = newGameListMap;
    }

    _calcGameName(gameIndex[0], gameIndex[1]);
    isInit.value = true;
    // reqDataList(null, 1, 10);
    // _reqLowMemberList();
  }

  // 下级列表
  Future<void> _reqLowMemberList() async {
    final response = await AgentCenterApi.reqLowMemberList();

    if (response.type == NetworkService.networkTypeSuccess) {
      if (response.data is List) {
        subList.value = response.data;
      } else {
        subList.value = [];
      }
    }
  }

  Map<String, int> getBigTypeAndId() {
    int index = nextGameIndex[0];
    int type = gameListData[0][index].value;
    // 1: 棋牌，2: 彩票， 3: 电子, 4: 捕鱼， 5: 真人， 6: 体育， 7: 红包 8: 区块 9: 电竞
    switch (type) {
      case 1:
        return {"big_type": 2, "type_id": 2};
      case 2:
        return {"big_type": 7, "type_id": 1};
      case 3:
        return {"big_type": 3, "type_id": 4};
      case 4:
        return {"big_type": 4, "type_id": 5};
      case 5:
        return {"big_type": 5, "type_id": 3};
      case 6:
        return {"big_type": 6, "type_id": 6};
      case 39:
        return {"big_type": 10, "type_id": 10};
      default: // 105
        return {"big_type": 10, "type_id": 10};
    }
  }

  int getPlatformId() {
    int index1 = nextGameIndex[0];
    int index2 = nextGameIndex[1];

    List<YmPickerDataBean> platformList = gameListMap[index1] ?? [];

    return platformList[index2].value;
  }

  // 初始化场馆
  Future<void> initGameVenues() async {
    List<VersionTypeItem> versionType = TenantManager.instance.versionType;
    versionType.removeWhere((item) => item.sort_v == 0);
    versionType.sort((a, b) => b.sort_v!.compareTo(a.sort_v!));
    // 1: 棋牌， 2: 彩票, 3: 电子，4：捕鱼 5: 真人 6: 体育

    versionType = versionType
        .where((item) => HomeGameCategory.supportList.contains(item.type))
        .toList();
    // 场馆
    List<YmPickerDataBean> venuesList = [];
    for (var category in versionType) {
      List<List<YmPickerDataBean>> newGameListData = [];

      venuesList.add(YmPickerDataBean(
        label: category.play_name!,
        value: category.type!,
      ));

      newGameListData.add(venuesList);

      gameListData.value = newGameListData;
    }
  }

  // 初始化平台
  Future<List<YmPickerDataBean>> initGamePlatform(
      {required int idx, bool? useMap}) async {
    bool isMap = useMap == true;
    // 1: 棋牌， 2: 彩票, 3: 电子，4：捕鱼 5: 真人 6: 体育
    int index = isMap ? idx : gameIndex[0];

    // 所有场馆数据
    List<YmPickerDataBean> venuesList = gameListData[0];
    // 当前选中的场馆类型
    int type = venuesList[index].value;

    // 平台列表数据
    List<YmPickerDataBean> platformList = [
      YmPickerDataBean(label: '全部平台', value: 0),
    ];

    List<YmPickerDataBean> newPlatformList = [];
    switch (type) {
      case 1: //棋牌
        newPlatformList = homeController.gameChess
            .map((ele) => YmPickerDataBean(
                label: ele.play_cname!, value: int.parse('${ele.play_id}')))
            .toList();
        break;
      case 2: //彩票
        newPlatformList = [];
        break;
      case 3: //电子
        newPlatformList = homeController.gameElectronic
            .map((ele) => YmPickerDataBean(
                label: ele.play_cname!, value: int.parse('${ele.play_id}')))
            .toList();
        break;
      case 4: //捕鱼
        newPlatformList = homeController.gameFishing
            .map((ele) => YmPickerDataBean(
                label: ele.play_cname!, value: int.parse('${ele.play_id}')))
            .toList();
        break;
      case 5: //真人
        newPlatformList = homeController.gameLive
            .map((ele) => YmPickerDataBean(
                label: ele.play_cname!, value: int.parse('${ele.play_id}')))
            .toList();
        break;
      case 6: //体育
        newPlatformList = homeController.gameSports
            .map((ele) => YmPickerDataBean(
                label: ele.play_cname!, value: int.parse('${ele.play_id}')))
            .toList();
        break;
      case 39: //体育
        newPlatformList = homeController.gameBlockchain
            .map((ele) => YmPickerDataBean(
                label: ele.play_cname!, value: int.parse('${ele.play_id}')))
            .toList();
        break;
    }

    if (newPlatformList.isNotEmpty) {
      platformList = [
        ...platformList,
        ...newPlatformList,
      ];
    }

    if (gameListData.length == 1) {
      gameListData.add(platformList);
    } else if (gameListData.length == 2) {
      gameListData[1] = platformList;
    }
    return platformList;
  }

  // 修改值 空
  changeGame(position, index, value) {
    //
  }

  confirmGame(List<int> list) {
    _calcGameName(list[0], list[1]);
    // 保存改变选中的索引
    nextGameIndex.value = [list[0], list[1]];
  }

  // 计算游戏名
  _calcGameName(int firstIndex, int secondIndex) {
    // 场馆名称
    String venuesName = gameListData[0][firstIndex].label;

    // 平台
    List<YmPickerDataBean> platformList = gameListMap[firstIndex]!;
    String platformName = platformList[secondIndex].label;
    gameName.value = '${venuesName} / ${platformName}';
  }

  setUsername(String str) {
    username.value = str;
  }

  // 加载更多
  void loadMoreData(RecordQuery? data) async {
    if (hasMore) {
      // 去最底部
      if (mainScrollController.hasClients) {
        mainScrollController
            .jumpTo(mainScrollController.position.maxScrollExtent);
      }

      page += 1;
      try {
        isRequest.value = true;
        await reqDataList(data, page, 10);
      } finally {
        isRequest.value = false;
      }
    }
  }

  // 获取游戏数据
  Future<List<BetHistoryRecord>> reqDataList(
    RecordQuery? d,
    int page,
    int size,
  ) async {
    try {
      EasyLoading.show(indicator: const CommonLoadingView());
      isRequest.value = true;
      isNeedReset.value = false;

      final start = DateTime(startTime.value.year, startTime.value.month,
          startTime.value.day, 0, 0, 0);
      final end = DateTime(endTime.value.year, endTime.value.month,
          endTime.value.day, 23, 59, 59);

      final data = {
        'start_time': start.millisecondsSinceEpoch,
        'end_time': end.millisecondsSinceEpoch,
        'api_type': 2,
        'num_per_page': size,
        'partner_name': LoginManager.instance.loginInfo?.partner?.partner_name,
        'partner_id': LoginManager.instance.loginInfo!.partner!.partner_id,
        'page_start': page, // ✅ 使用传入的 page
        'cust_id': d?.memberId ?? "",
        'type_id': 3,
        'tid': 3,
        'platform': getPlatformId(),
      };

      final resp = await AgentCenterApi.reqBetHistoryList(data);
      if (resp.type == NetworkService.networkTypeSuccess &&
          resp.data != null &&
          (resp.data['count'] ?? 0) > 0) {
        final rawList = (resp.data['data'] ?? []) as List;

        return rawList.map((item) {
          final Map<String, dynamic>? play =
              GameUtils.getPlayInfo('${item['play_type_id']}');
          final playTypeId =
              play != null ? play['play_cname'] : item['play_type_id'];

          // bet_time 兜底解析
          DateTime? betTime;
          final bt = item['bet_time'];
          if (bt is String) {
            betTime = DateTime.tryParse(bt);
          } else if (bt is int) {
            betTime = DateTime.fromMillisecondsSinceEpoch(bt);
          }

          final historyData = BetHistoryConfig.formatValue(
            playTypeId: playTypeId,
            item: item,
          );
          return BetHistoryRecord(
            gameName: (item['play_cname'] ?? '')
                .append(item['game_type_cname'] ?? '')
                .trim(),
            amount: item['amount'] ?? 0,
            memberId: item['member_id'] ?? '',
            orderNo: item['order_no'] ?? '',
            betTime: betTime ?? DateTime.now(), // ✅ 兜底
            status: BetStatus.success, // TODO: 按接口映射
            result: GameResult.win, // TODO: 按接口映射
            playTypeId: playTypeId,
            gameTypeId: historyData['gameTypeId'] ?? '',
          );
        }).toList();
      }
      return [];
    } finally {
      EasyLoading.dismiss();
      isRequest.value = false;
    }
  }

  // 点击重置数据
  Future<void> handleResetData() async {
    startTime.value = dateTimeBy[0];
    endTime.value = dateTimeBy[1];

    // 修改重置到的值
    confirmGame([0, 0]);
    isNeedReset.value = true;

    // 用户名特殊处理
    defaultUsername.value = username.value;

    // 延迟100ms，等数据更新
    await Future.delayed(const Duration(milliseconds: 100));
    username.value = ''; // 清空会员账号
    defaultUsername.value = '';
  }

  // 确定查询
  Future<void> handleConfirmQuery(RecordQuery? data) async {
    if (endTime.value.isBefore(startTime.value)) {
      EasyLoading.showToast('开始日期需小于结束日期');
      return;
    }
    // 只保存查询条件、重置分页标记，真正的请求交给 _rl.refresh()
    try {
      page = 1;
      isNeedReset.value = true; // 如果你内部会用到
      // ❌ 不要在这里调用 reqDataList
    } finally {
      // no-op
    }
  }

  // 时间改变
  Future<void> onTimeChange(DateTime time) async {
    changeTime.value = time;
  }

  // 修改当前点击
  void setIsCheckedStartTime(bool val) {
    isCheckedStartTime.value = val;
  }

  // 确认
  void onConfrimTime() {
    // 当前是开始时间
    if (isCheckedStartTime.value) {
      startTime.value = changeTime.value;
    } else {
      endTime.value = changeTime.value;
    }
  }

  Future<void> setSelectAcctId(String id) async {
    selectAcctId.value = id;

    List findList = subList
        .where((item) => '${item['acct_id']}' == selectAcctId.value)
        .toList();

    if (findList.isNotEmpty) {
      username.value = findList[0]['partner_name'];
      custId.value = '${findList[0]['partner_id']}';
    } else {
      username.value = '';
      custId.value = '';
    }
  }
}
