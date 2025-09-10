import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/betting/common_model/betting_common_params.dart';
import 'package:flutter_bet/pages/betting/sport/bet_detail/sport_bet_mine_detail_dialog_view.dart';
import 'package:flutter_bet/services/api/extension/yulecheng_game_service.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import '../../../../constant/app_values.dart';
import '../../../../controllers/global_state_controller.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/sport/sport_bet_list_model.dart';
import '../../../../model/yulecheng/big_wins_model.dart';
import '../../../../services/api/api_service.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/betting_list/logic.dart';
import '../../../../widget/sport/custom_sport_mixin/custom_sport_bet_mixin.dart';
import '../../../betting/common_model/betting_record_api_model.dart';
import 'widgets/index.dart';


class BottomRankController extends GetxController with GetTickerProviderStateMixin, CustomSportBetMixin{
  BottomRankController();
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  
  late TabController bottomTabController;
  late RxList<Tab> bottomTabs = [
    Tab(
      child: Text(S.current.all_bet, style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      // icon: CustomIcon(
      //   asset: 'assets/images/home/ic_drake.png',
      // ),
    ),
    Tab(
      child: Text(S.current.billboard, style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      // icon: CustomIcon(
      //   asset: 'assets/images/home/ic_drake.png',
      // ),
    ),
    Tab(
      child: <Widget>[
        Text(S.current.random_text_268, style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: ThemeService().colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
        ).paddingLeft(AppValues.halfPadding),
      ].toRow(),
    ),
  ].obs;
  final List<BigWinsModel> list1      = [];
  final List<BigWinsModel> list2      = [];
  final List<CompetitionBean> list3   = [];
  // 当前选中Tab类型
  var index = 0;
  // 数据变化滚动效果控制
  bool firstTransparent = true;
  var isLoading = true.obs;
  var loadRank = true.obs;

  @override
  void onInit() {
    super.onInit();
    bottomTabController = TabController(length: bottomTabs.length, vsync: this);
    onTapBottomRankList(0);
    ever(globalController.rankSportsBets, (callback) => refreshBets());
    ever(globalController.rankSportsRank, (callback) => refreshRank());
  }

  refreshBets() {
    if (globalController.rankSportsBets.isNotEmpty) {
      firstTransparent = !firstTransparent;
    } 
    for (var dic in globalController.rankSportsBets) {
      BigWinsModel data = BigWinsModel.fromJson(dic);
      var sel = false;
      for (var element in list1) {
        if (data.gameName == element.gameName) {
          sel = true;
        }
      }
      if (!sel) {
        list1.removeLast();
        list1.insert(0, data);
      }
    }
    update(['bottom_rank']);
  }

  refreshRank() {
    if (globalController.rankSportsRank.isNotEmpty) {
      firstTransparent = !firstTransparent;
    } 
    for (var dic in globalController.rankSportsRank) {
      BigWinsModel data = BigWinsModel.fromJson(dic);
      var sel = false;
      for (var element in list2) {
        if (data.gameName == element.gameName) {
          sel = true;
        }
      }
      if (!sel) {
        list2.removeLast();
        list2.insert(0, data);
      }
    }
    update(['bottom_rank']);
  }

  _initData() {
    update(["bottom_rank"]);
  }

   onTapBottomRankList(idx) {
    index = idx;
    switch (idx) {
      case 0:
        isLoading.value = true;
        break;
      case 1:
        loadRank.value = true;
        break;
      default:
    }
    loadData(idx);
  }

  loadData(idx) {
    switch (idx) {
      case 0:
        getAllBet();
        break;
      case 1:
        getRanking();
        break;
      default:
    }
  }

  // 索取所有投注信息
  Future<void> getAllBet() async {
    await Future.delayed(const Duration(milliseconds: 250));  
    await ApiService.instance.getRankingList(
      gameClass:"4",
      gameCode:"",
      type:"0",
      success: (data) async {
        if(data.content.isNotEmpty && list1.isNotEmpty) {
          if(data.content.first.billNo != list1.first.billNo) {
            firstTransparent = !firstTransparent;
          }
        }
        list1.clear();
        list1.addAll(data.content);
        Future.delayed(const Duration(milliseconds: 150), () {
          isLoading.value = false;
          update(['bottom_rank']);
        });
      },
      fail: (message) {},
    );
  }

  // 索取风云榜
  Future<void> getRanking() async {
    await Future.delayed(const Duration(milliseconds: 250));
    await ApiService.instance.getRankingList(
      gameClass:"4",
      gameCode:"",
      type:"1",
      success: (data) async {
        if(data.content.isNotEmpty && list2.isNotEmpty) {
          if(data.content.first.billNo != list2.first.billNo) {
            firstTransparent = !firstTransparent;
          }
        }
        list2.clear();
        list2.addAll(data.content);
        Future.delayed(const Duration(milliseconds: 150), () {
          loadRank.value = false;
          update(['bottom_rank']);
        });
      },
      fail: (message) {},
    );
  }

  void onTap() {
    RouteUtil.popView();
  }

  void onItemClick(BigWinsModel model) {
    // //适配 dialog model
    // CustomSportDetailDialogWidget.showDetailDialog(
    //   context: Get.context!,
    //   model: model
    // );

    if(model.detailSportInfo != null) {
      SportBetMineDetailDialogView.showSportDetailWidget(
          context: Get.context!,
          bean: model.detailSportInfo!,
          itemType: BettingOrderItemType.unBillDetail
      );
    }

  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
