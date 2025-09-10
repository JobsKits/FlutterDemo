import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bet/services/api/extension/yulecheng_game_service.dart';
import 'package:flutter_bet/utils/json_util.dart';
import 'package:get/get.dart';
import 'package:synchronized/synchronized.dart';

import '../../../controllers/global_state_controller.dart';
import '../../../model/page_common_model.dart';
import '../../../model/yulecheng/casino_record_model.dart';
import '../../../services/api/api_service.dart';
import '../../../services/event/event_service.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';
import '../../../widget/refresh/custom_refresh_state_mixin_helper.dart';
import '../../main/code.dart';
import '../common_model/betting_common_params.dart';
import '../common_model/betting_record_api_model.dart';
import '../common_model/casino_detail_model.dart';
import '../casino_detail/custom_casino_detail_dialog.dart';

class BettingCasinoRankListLogic extends GetxController with CustomRefreshStateMixinHelper {
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  BettingCasinoRankListLogic({required this.bettingType, this.fromPage});

  ///0：投注单 1:我的投注 3：风云榜 4:竞赛 5:所有投注
  final BettingTypeEnum bettingType;

  ///主要是看来自哪里，需不需要分页
  final BettingFromPageType? fromPage; //浏览菜单"我的投注"， 不需要分页，默认加载个10

  ///listView 上下拉控制器
  final CustomRefreshController refreshController = CustomRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ///分页数据
  final pageModelObs =
      PageCommonModel.init(curPage: 1, first: true, content: <BettingRecordApiModel>[]).obs;

  ///自定义方便取数据
  List<BettingRecordApiModel> get apiModelList => pageModelObs.value.content;

  // final apiModelListObs = <BettingRankApiModel>[].obs;
  // List<BettingRankApiModel> get apiModelListObsValue =>apiModelListObs.value;
  ///加载中
  final isLoading = false.obs;

  ///加载失败
  final isError = false.obs;

  ///我的投注数据
  final betCasinoAllBetListObs = <CasinoRecordModel>[].obs;

  // final betCasinoAllBetListObs = <CasinoRecordModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    //监听语言
    ever(
      GlobalStateController.of().langType,
      (callback) {
        loadNetData(isRefresh: true, isShowLoad: true, isFirst: true, preload: true);
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
    isLoading.value = true;
    // getCasinoRecord();
    log("BettingCasinoRankListLogic...onReady()...");
    loadNetData(isRefresh: true, isShowLoad: true, isFirst: true, preload: true);
    initListenPush();
  }

  //监听推送消息
  void initListenPush() {
    //不分页, 且是所有投注 或者 风云榜
    var cond = bettingType == BettingTypeEnum.allBet || bettingType == BettingTypeEnum.stormRanking;
    //都需要刷新数据
    //cond && BettingFromPageType.isFromBrowseMenu(fromPage)
    if (cond) {
      ever(
          bettingType == BettingTypeEnum.allBet
              ? GlobalStateController.of().mqttCasinoAllRankingObs
              : GlobalStateController.of().mqttCasinoStormRankingObs, (mqttData) async {
        listenPushDataChange(mqttData, fromPage);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  final Lock lock = Lock();

  //线程安全 获取数据
  Future<List<BettingRecordApiModel>> lockData() async {
    List<BettingRecordApiModel> data =
        await lock.synchronized<List<BettingRecordApiModel>>(() async {
      // 执行受保护的代码块
      return pageModelObs.value.content;
    });
    return data;
  }

  ///监听推送的数据变换
  void listenPushDataChange(
      List<BettingRecordApiModel> newDataList, BettingFromPageType? fromPage) async {
    //线程安全
    await lock.synchronized(() {
      //限制10个,来自main 底部主菜单,不限制
      bool isFromMainMenu = BettingFromPageType.isFromMainMenu(fromPage);
      //去重 并 合并
      //最多显示10条数据
      var mqttData = newDataList;
      var showData = apiModelList;

      ///获取不相同的id
      var diffData = mqttData.where((mqtt) {
        //every 判断List中是所有元素是否符合条件，即是新数据
        return showData.every((show) => mqtt.billNo != show.billNo);
      }).toList();
      if (diffData.isNotEmpty) {
        showData.insertAll(0, diffData);
        var showLength = isFromMainMenu ? 10 : 10;
        if (showLength > showData.length) {
          showLength = showData.length;
        }
        var newData = showData.sublist(0, showLength);
        apiModelList.assignAll(newData);
        pageModelObs.refresh();
      }
      // log("合并数据...$bettingType...${JsonUtil.encodeObj(apiModelList)}");
    });
  }

  ///娱乐城 索取注信息
  Future<void> getCasinoRecord() async {
    await ApiService.instance.getCasinoRecord(
      page: 1,
      success: (data) async {
        // betCasinoMyBetListObs.clear();
        // betCasinoMyBetListObs.assignAll(data.content);
        betCasinoAllBetListObs.value = data.content;
        isLoading.value = false;
        if (betCasinoAllBetListObs.isNotEmpty) {
          isError.value = false;
        } else {
          isError.value = true;
        }
      },
      fail: (message) {
        isLoading.value = false;
        isError.value = true;
      },
    );
  }

  ///item 点击处理
  void onItemClick(BuildContext context, BettingRecordApiModel model) {
    //适配 dialog model
    CustomCasinoDetailDialogWidget.showDetailDialog(
      context: context,
      recordModel: model,
    );
  }

  void onChickGotoBetting() {
    EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.GAME);
  }

  @override
  void onClose() {
    super.onClose();
  }

  ///我的投注页面中， 没有投注的情况下， 点击"立即开始下注" 跳转到首页的对应的 娱乐城 或者 体育见面
  Future<void> onClickEmptyBettingToHome(BettingFromPageType? type) async {
    if (type == null) {
      return;
    }
    switch (type) {
      ///娱乐城
      case BettingFromPageType.browseMenuBettingCasinoType:
        EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.GAME);
        globalController.buttonSelectIndex.value = 1;
        break;

      case BettingFromPageType.sideMenuBettingCasinoType:
        Get.back();
        EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.GAME);
        globalController.buttonSelectIndex.value = 1;
        break;

      ///体育
      case BettingFromPageType.sideMenuBettingSportType:
        Get.back();
        EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.MSG);
        globalController.buttonSelectIndex.value = 3;
        break;

      default:
        Get.back();
        break;
    }
  }

  ///请求网络数据
  ///isRefresh 是否是刷新， isFirst是否是第一次刷新，为了状态布局, isShow 是否显示loading
  void loadNetData({
    required bool isRefresh,
    bool isShowLoad = true,
    bool isFirst = false,
    bool preload = false,
  }) async {
    showLoading(isShowLoad, isFirst, preload);
    // await Future.delayed(Duration(seconds: 3), () => null);
    // successFinish(isRefresh, pageModelObs.value, refreshController);
    // return;
    await ApiService.instance.getRankingList_v2(
      //为为什么要这么多呢？就是为了请求失败的话还保留旧数据
      page: pageModelObs.value.pageIndex(isRefresh),
      page_size: BettingFromPageType.isFromBrowseMenu(fromPage)
          ? pageModelObs.value.curPageSize
          : PageCommonModel.pageSize10,
      gameClass: '',
      gameCode: '',
      type: getLoadNetType(bettingType),
      success: (PageCommonModel<BettingRecordApiModel> resultData) {
        pageModelObs.value.copyWith(resultData, isRefresh);
        pageModelObs.refresh();
        log("娱乐城投注排行榜api...上层...${pageModelObs.toString()}");
        successFinish(isRefresh, pageModelObs.value, refreshController);
      },
      fail: (bool isConnect, String? message, candy) {
        failFinish(isConnect, isRefresh, isFirst, refreshController);
      },
    );
  }

  ///请求网络 类型
  String getLoadNetType(BettingTypeEnum chooseType) {
    var type = "";
    switch (chooseType) {
      case BettingTypeEnum.allBet:
        type = BettingCasinoRankTypeEnum.allBetting.type;
        break;
      case BettingTypeEnum.stormRanking:
        type = BettingCasinoRankTypeEnum.stormRanking.type;
        break;
      default:
        break;
    }
    return type;
  }
}
