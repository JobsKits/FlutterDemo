import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/yulecheng/big_wins_model.dart';
import 'package:flutter_bet/model/yulecheng/casino_record_model.dart';
import 'package:flutter_bet/pages/betting/common_model/betting_common_params.dart';
import 'package:flutter_bet/pages/betting/casino_detail/custom_casino_detail_dialog.dart';
import 'package:flutter_bet/pages/betting/common_model/betting_record_api_model.dart';
import 'package:flutter_bet/pages/find/yulechengtouzhurank/view.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/yulecheng_game_service.dart';
import 'package:flutter_bet/widget/betting_list/logic.dart';
import 'package:get/get.dart';

class RankingListController extends GetxController with GetSingleTickerProviderStateMixin, GetTickerProviderStateMixin {
  RankingListController();

  final GlobalKey viewKey = GlobalKey();
  TabController? tabC;
  // 当前选中Tab类型
  late RankingTabType selType;

  // 定时刷新
  late Timer timer;

  // 数据变化滚动效果控制
  bool firstTransparent = true;

  // 加载状态标识
  bool isLoading = true;

  // 我的投注 / 所有投注 / 风云榜 列表数据
  // TODO:待删除 转为使用BettingRecordApiModel
  final List<List<BigWinsModel>> infos = [
    [],
    [],
    [],
  ];

  @override
  void onInit() {
    super.onInit();

    final GlobalStateController globalC = GlobalStateController.of();
    tabC = TabController(length: 4, vsync: this);

    // 登陆 ？ 加载我的投注 ：所有投注
    selType = globalC.isLogin.value ? RankingTabType.myBets : RankingTabType.allBets;
    tabC?.animateTo(globalC.isLogin.value ? 0 : 1);
    reqBetInfos(selType);

    // 我的投注显示在当前屏幕时，定时刷新
    timer = Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      if (checkVisibility() && selType == RankingTabType.myBets) {
        tabDidSelIndexAction(selType);
      }
    });

    // 登陆/登出 变化监听
    ever(globalC.isLogin, (bool isLogin) {
      isLoading = true;
      selType = isLogin ? RankingTabType.myBets : RankingTabType.allBets;
      tabC?.animateTo(isLogin ? 0 : 1);
      tabDidSelIndexAction(selType);
      GlobalState.destroyInstance();
    });

    // 推送更新:  所有投注 / 风云榜
    ever(globalC.mqttCasinoAllRankingObs, (updateListBr) {
      mqttUpdateInfo(RankingTabType.allBets, updateListBr);
    });
    ever(globalC.mqttCasinoStormRankingObs, (updateListBr) {
      mqttUpdateInfo(RankingTabType.highRollers, updateListBr);
    });

    update(["RankingListPage"]);
  }

  // Tab切换事件
  void tabDidSelIndexAction(RankingTabType type) {
    selType = type;
    switch (type) {
      case RankingTabType.myBets:
        reqBetInfos(type);
        break;
      case RankingTabType.allBets:
      case RankingTabType.highRollers:
        if (infos[type.index].isEmpty) {
          reqBetInfos(type);
        } else {
          isLoading = false;
          update(["RankingListPage"]);
        }
        break;
      case RankingTabType.raceLeaderboard:
        break;
      default:
        break;
    }
    update(['RankingListPage']);
  }

  // 推送更新
  void mqttUpdateInfo(RankingTabType type, List<BettingRecordApiModel> updateListBr) {
    // 初始数据为空 return
    final index = type.index;
    if (infos[index].isEmpty) return;

    // model转换
    final updateList = updateListBr.map((e) => BigWinsModel.conversionWithBrModel(e)).toList();

    // BGColor控制
    if (updateList.isNotEmpty && infos[index].isNotEmpty) {
      if (updateList.first.billNo != infos[index].first.billNo) {
        firstTransparent = !firstTransparent;
      }
    }

    // 去重/更新/保留前10
    for (var updateBigWin in updateList) {
      if (!infos[index].any((bigWin) => bigWin.billNo == updateBigWin.billNo)) {
        infos[index].insert(0, updateBigWin);
      }
    }
    infos[index] = infos[index].sublist(0, 10);

    // 风云榜再次排列奖金排行
    if (type == RankingTabType.highRollers) {
      infos[index].sort((a, b) => b.settleDouble.compareTo(a.settleDouble));
    }

    if (type == selType) {
      update(["RankingListPage"]);
    }
  }

  // 列表item点击 投注详情弹窗
  void onItemClick(BuildContext context, BigWinsModel model) {
    CustomCasinoDetailDialogWidget.showDetailDialog(
      context: context,
      recordModel: model.bettingRecordApiModel,
    );
  }

  // 索取 我的投注 / 所有投注 / 风云榜
  Future<void> reqBetInfos(RankingTabType type) async {

    switch (type) {
      case RankingTabType.myBets:
        await ApiService.instance.getCasinoRecord(
          page: 1,
          success: (data) async {
            isLoading = false;
            final listIndex = RankingTabType.myBets.index;
            infos[listIndex].clear();
            final temCasinoRecordList = data.content.take(10).toList();
            for (int i = 0; i < temCasinoRecordList.length; i++) {
              final bigWin = BigWinsModel.conversionWithCrModel(temCasinoRecordList[i]);
              infos[listIndex].add(bigWin);
            }
          },
          fail: (message) {},
        );
        break;
      case RankingTabType.allBets:
      case RankingTabType.highRollers:

      await ApiService.instance.getRankingList(
        gameClass: "",
        gameCode: "",
        type: type == RankingTabType.allBets ? "0" : "1",
        success: (data) async {
          final listIndex = type.index;
          if (data.content.isNotEmpty && infos[listIndex].isNotEmpty) {
            if (data.content.first.billNo != infos[listIndex].first.billNo) {
              firstTransparent = !firstTransparent;
            }
          }
          isLoading = false;
          infos[listIndex].clear();
          infos[listIndex].addAll(data.content);
          Future.delayed(const Duration(milliseconds: 150), () {
            update(['RankingListPage']);
          });
        },
        fail: (message) {},
      );

        break;
      case RankingTabType.raceLeaderboard:
        break;
      default:
        break;
    }
  }

  // 当前View是否在当前屏幕
  bool checkVisibility() {
    if (viewKey.currentContext != null) {
      final RenderBox renderBox = viewKey.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final screenSize = MediaQuery.of(viewKey.currentContext!).size;
      if (position.dy > 0 &&
          position.dy < screenSize.height &&
          position.dx > 0 &&
          position.dx < screenSize.width) {
        // print('Widget is visible on the screen');
        return true;
      } else {
        // print('Widget is not visible on the screen');
        return false;
      }
    }
    return false;
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
  }
}
