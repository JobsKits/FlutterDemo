import 'dart:developer';

import 'package:flutter_bet/generated/l10n.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/betting/casino/betting_casino_state.dart';
import 'package:flutter_bet/pages/betting/sport/betting_sport_state.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/sport_api_service.dart';
import 'package:flutter_bet/utils/json_util.dart';
import 'package:flutter_bet/widget/betting_list/logic.dart';
import 'package:flutter_bet/widget/sport/custom_sport_mixin/custom_sport_bet_mixin.dart';
import 'package:get/get.dart';
import '../../../base/getx/base_controller.dart';
import '../../../routes/routes.dart';
import '../common_model/sport_common_params.dart';
import 'model.dart';
import 'state.dart';

class SportDetailLogic extends BaseController
    with GetTickerProviderStateMixin, CustomSportBetMixin {
  final SportDetailState state = SportDetailState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initBottomData();
    state.si.value = Get.arguments['si'];
    state.eid.value = Get.arguments['eid'];
    state.tabController = TabController(length: state.tabbarCategoryJson.length, vsync: this);
    state.textController = TextEditingController();
    state.bottomTabController = TabController(length: state.bottomTabs.length, vsync: this);
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();

    getContestDetailData();

    state.myTimer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      getContestDetailData();
    });
    state.timer1 = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      state.model.refresh();
    });

    listenM();
  }

  listenM() {
    ever(state.g.sportData, (callback) {
      state.lock.synchronized(() {
        try {
          String ei = callback['ei'].toString();
          int ac = callback['ac'];

          if (state.list.first.ei == ei) {
            if (ac == 0) {
              var tl = (json.decode(callback['v']) as List)
                  .map((e) => SportMatchModel.fromJson(e))
                  .toList();
              state.list.forEach((n) {
                var o = tl.first.ml?.firstWhere((element) => element.mlid == n.mlid);
                if (o != null) {
                  n.ms?.forEach((e) {
                    var k = o.ms?.firstWhere((element) => e.wid == element.wid);
                    if (k != null) {
                      e.oov = e.ov;
                      e.ov = k?.ov;
                      double ov = double.parse(e.ov ?? '');
                      double oov = double.parse(e.oov ?? '');
                      if (ov > oov) {
                        e.isUp = 1;
                      } else if (oov < ov) {
                        e.isUp = 0;
                      } else {
                        e.isUp = 2;
                      }
                    }
                  });
                }
              });
              state.list.refresh();
            }
          }
        } catch (e) {
          // print('');
        }
      });
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    state.myTimer?.cancel();
    state.timer1?.cancel();
  }

  changeCategoryIndex(int index) async {
    // print('===========${index}');
    state.cagetoryTabbarInitIndex = index;
    state.isSearching = false;
    state.textController.clear();

    try {
      state.chooseCid = (state.model.value?.list?.first.tgl == null
          ? -1
          : state.model.value?.list?.first.tgl?[index].tgi ?? -1);
    } catch (e) {
      return;
    }

    var model = state.model.value.list?.first;
    var tgn = model?.tgl?[index];
    if (tgn?.tgi != null) {
      state.list?.value =
          (model?.ml?.where((element) => element.tgis?.contains(tgn?.tgi) ?? false) ?? []).toList();
      state.list?.refresh();
    }
  }

  Future<void> getContestDetailData() async {
    await ApiService.instance.getContestDetail(
        si: state.si.value,
        ei: state.eid.value,
        success: (res) {
          if (state.isSearching) {
            return;
          }

          if (res.data['list'] == null) {
            res.data['list'] = [];
          }
          SportDetailModel model = SportDetailModel.fromJson(res.data);

          try {
            model.list?.first.tgl?.sort((a, b) => (a.tgi ?? -1).compareTo(b.tgi ?? -1));

            SportMatchModel? m = model.list?.first;

            Map<String, Ml> mlMap = {};

            for (var ml in (m?.ml ?? [])) {
              String btn = ml.btn ?? '';

              if (mlMap.containsKey(btn)) {
                // 如果 mlMap 中已经存在相同 btn 的 Ml，将 ms 合并到第一个 Ml 中
                mlMap[btn]!.ms?.addAll(ml.ms ?? []);
              } else {
                // 如果 mlMap 中不存在相同 btn 的 Ml，直接添加到 mlMap
                mlMap[btn] = ml;
              }
            }

            m?.ml = mlMap.values.toList();
            filterBet(model.list, state.model.value.list, false);
          } catch (e) {
            // print('报错了================');
          }

          state.model.value = model;

          if (state.si.value == 1) {
            if (model.list?.isNotEmpty ?? false) {
              if (!(model.list?.first.pol?.keys ?? []).contains('3')) {
                (model.list?.first.pol ?? {})['3'] = '-';
                (model.list?.first.pol ?? {})['4'] = '-';
              }
              if (!(model.list?.first.pol?.keys ?? []).contains('5')) {
                (model.list?.first.pol ?? {})['5'] = '-';
                (model.list?.first.pol ?? {})['6'] = '-';
              }
              if (!(model.list?.first.pol?.keys ?? []).contains('7')) {
                (model.list?.first.pol ?? {})['7'] = '-';
                (model.list?.first.pol ?? {})['8'] = '-';
              }
            }
          }

          state.model.refresh();

          if (state.chooseCid == -1) {
            state.cagetoryTabbarInitIndex = 0;
          } else {
            int? newIndex = state.model.value.list?.first.tgl
                ?.indexWhere((element) => element.tgi == state.chooseCid);
            if (newIndex != null) {
              state.cagetoryTabbarInitIndex = newIndex;
            } else {
              state.cagetoryTabbarInitIndex = 0;
            }
          }

          changeCategoryIndex(state.cagetoryTabbarInitIndex);
        },
        fail: (e) {});
  }

  int getRowsCount(Ml e) {
    switch (e.pat) {
      case 1:
        return 2;
      case 2:
        return 2;
      case 3:
        return 3;
      default:
        return 3;
    }
  }


  void detailBetOrder( M bet) {
    betOrder(bet);
    state.list?.refresh();
  }

  starSearching(String searchWord) {
    state.searchinglist.value =
        state.list.value.where((element) => element.btn!.contains(searchWord)).toList();
    state.searchinglist.refresh();
    state.list.refresh();
  }

  initBottomData() {
    state.bottomTabController = TabController(length: state.bottomTabs.length, vsync: this);
    state.betSlipList = [
      BetSlipData(
          name: 'Blackjack',
          icon: 'assets/images/bet_slip/ic_bet_list_icon.webp',
          money: '4423.42114....',
          moneyIcon: 'assets/images/bet_slip/ic_eth_bet_icon.webp'),
    ].obs;
    for (int i = 0; i < 20; i++) {
      state.betSlipList.add(BetSlipData(
          name: 'Blackjack',
          icon: 'assets/images/bet_slip/ic_bet_list_icon.webp',
          money: '4423.42114....',
          moneyIcon: 'assets/images/bet_slip/ic_eth_bet_icon.webp'));
    }
    state.betSportList = [
      SportBetBean(
        betTitle: S.current.random_text_272,
        money: '-4423.42114....',
      ),
    ].obs;
    state.competitonList = [
      CompetitionBean(
          name: S.current.random_text_238,
          icon: 'assets/images/bet_slip/ic_no_one.webp',
          money: '\$19,782,2390',
          moneyIcon: 'assets/images/bet_slip/ic_eth_bet_icon.webp',
          bonusMoney: '35%'),
    ].obs;
    for (int i = 0; i < 20; i++) {
      state.betSportList.add(SportBetBean(
        betTitle: S.current.random_text_272,
        money: '-4423.42114....',
      ));
    }
    for (int i = 0; i < 20; i++) {
      state.competitonList.add(CompetitionBean(
          name: S.current.random_text_238,
          icon: 'assets/images/bet_slip/ic_no_two.webp',
          money: '\$19,782,2390',
          moneyIcon: 'assets/images/bet_slip/ic_eth_bet_icon.webp',
          bonusMoney: '35%'));
    }
  }

  onClickToPage(SportOpenType type, int t) {
    SportOpenPageParams pageParams = SportOpenPageParams(
      sportOpenType: type,
      title: state.model.value.list?.first.cn ?? '',
      ci: state.model.value.list?.first.ci ?? '',
      pgid: state.model.value.list?.first.pgid ?? '',
      t: t,
      si: state.si.value,
      eid: state.eid.value,
    );

    Get.offAndToNamed(
      Routes.sport_event_detail,
      arguments: {'pageParams': pageParams},
    )?.then((value) {
      print('object');
    });
  }
}
