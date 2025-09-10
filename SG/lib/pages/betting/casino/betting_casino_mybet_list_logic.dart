import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/services/api/extension/yulecheng_game_service.dart';
import 'package:flutter_bet/widget/refresh/custom_refresh_state_mixin_helper.dart';
import 'package:get/get.dart';

import '../../../controllers/global_state_controller.dart';
import '../../../model/page_common_model.dart';
import '../../../model/yulecheng/big_wins_model.dart';
import '../../../model/yulecheng/casino_record_model.dart';
import '../../../services/api/api_service.dart';
import '../../../services/event/event_service.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';
import '../../main/code.dart';
import '../common_model/betting_common_params.dart';
import '../common_model/betting_record_api_model.dart';
import 'betting_casino_logic.dart';
import '../casino_detail/custom_casino_detail_dialog.dart';

class BettingCasinoMyBetListLogic extends BaseController with CustomRefreshStateMixinHelper {
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  ///加载中
  final isLoading = false.obs;

  ///加载失败
  final isError = false.obs;

  ///我的投注数据
  final betCasinoMyBetListObs = <BettingRecordApiModel>[].obs;

  // final betCasinoAllBetListObs = <CasinoRecordModel>[].obs;

  ///分页数据
  final pageModelObs =
      PageCommonModel.init(curPage: 1, first: true, content: <BettingRecordApiModel>[]).obs;

  ///自定义方便取数据
  List<BettingRecordApiModel> get apiModelList => pageModelObs.value.content;

  ///listView 上下拉控制器
  final CustomRefreshController refreshController = CustomRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void onInit() {
    super.onInit();
    ever(betCasinoMyBetListObs, (listData) {
      ///需求：投注-有数据的情况下有“我的投注”，反之隐藏这个菜单【登录状态下】
      try {
        final BettingCasinoLogic fatherLogic = Get.find<BettingCasinoLogic>();
        if (fatherLogic != null && fatherLogic.initialized) {
          fatherLogic.myBetLength.value = listData.length;
          fatherLogic.initSelectStatusWithShow(listData.isNotEmpty);
        }
      } catch (e) {}
    });

    //监听语言
    ever(
      GlobalStateController.of().langType,
      (callback) {
        loadCasinoRecord(isRefresh: true, isShowLoad: false);
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
    isLoading.value = true;
    loadCasinoRecord(isRefresh: true, isShowLoad: false);
  }

  ///娱乐城 索取注信息
  // Future<void> getCasinoRecord() async {
  //   await ApiService.instance.getCasinoRecord(
  //     page: 1,
  //     success: (data) async {
  //       // betCasinoMyBetListObs.clear();
  //       // betCasinoMyBetListObs.assignAll(data.content);
  //       betCasinoMyBetListObs.value = data.content;
  //       isLoading.value = false;
  //       if (betCasinoMyBetListObs.isNotEmpty) {
  //         isError.value = false;
  //       } else {
  //         isError.value = true;
  //       }
  //     },
  //     fail: (message) {
  //       isLoading.value = false;
  //       isError.value = true;
  //     },
  //   );
  // }

  final hasPrevPage = false.obs; //是否还有上一页
  final hasNextPage = false.obs; //是否还有下一页

  ///加载我的投注 网络数据
  ///isRefresh 可以充当是否是 上一页
  Future<void> loadCasinoRecord({
    required bool isRefresh,
    bool isShowLoad = true,
    bool isFirst = false,
    bool preload = false,
  }) async {
    await ApiService.instance.getCasinoRecordV2(
      page: pageModelObs.value.getPnPageIndex(isRefresh),
      page_size: PageCommonModel.pageSize10,
      success: (apiModel) async {
        pageModelObs.value.updatePnCurPage(isRefresh);
        hasPrevPage.value = apiModel.hasPrevPage();
        hasNextPage.value = apiModel.hasNextPage2();
        betCasinoMyBetListObs.value = apiModel.content;

        //显示loading 最短时间
        await Future.delayed(const Duration(milliseconds: 500));
        isLoading.value = false;

        if (betCasinoMyBetListObs.isNotEmpty) {
          isError.value = false;
        } else {
          isError.value = true;
        }
      },
      fail: (bool isConnect, String? message, candy) {
        isLoading.value = false;
        isError.value = true;
      },
    );
  }

  ///item 点击处理
  void onItemClick(BuildContext context, BettingRecordApiModel gameName) {
    CustomCasinoDetailDialogWidget.showDetailDialog(
      context: context,
      recordModel: gameName,
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
      case BettingFromPageType.mainMenuBettingCasinoType:
        EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.GAME);
        globalController.buttonSelectIndex.value = 1;
        break;

      case BettingFromPageType.browseMenuBettingCasinoType:
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

  ///点击上一页
  void onClickPreviousPage() {
    loadCasinoRecord(isRefresh: true, isShowLoad: false);
  }

  ///点击下一页
  void onClickNextPage() {
    loadCasinoRecord(isRefresh: false, isShowLoad: false);
  }
}
