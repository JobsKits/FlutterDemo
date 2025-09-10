import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/sport/sport_detail/model.dart';
import 'package:flutter_bet/pages/sport/sport_side/state.dart';
import 'package:flutter_bet/pages/sport/state.dart';
import 'package:flutter_bet/pages/sport/tabmodel.dart';
import 'package:flutter_bet/pages/betting/casino/betting_casino_state.dart';
import 'package:flutter_bet/pages/betting/sport/betting_sport_state.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/sport_api_service.dart';
import 'package:flutter_bet/widget/betting_list/logic.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/sport/custom_sport_mixin/custom_sport_bet_mixin.dart';
import 'package:flutter_bet/widget/sport/custom_sport_odd_type.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';

class SportSideLogic extends BaseController with GetTickerProviderStateMixin, CustomSportBetMixin {
  final SportSideState state = SportSideState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    try{
      state.m = int.tryParse(Get.arguments['m']) ?? 3;
    }catch(e){}

    initBottomData();
    getBanner();
    getTabs().then((value) {
      if (state.tabs.isNotEmpty) {
        refreshRolling(0, S.current.sport_tabbar_rolling);
      }
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    state.tabController = TabController(length: state.tabbarCategoryJson.length, vsync: this);
    state.bottomTabController = TabController(length: state.bottomTabs.length, vsync: this);
    timerF();
    listenM();
  }

  timerF() {
    state.myTimer = Timer.periodic(const Duration(seconds: 20), (Timer timer) {
      state.lock.synchronized(() {
        refreshRolling(state.m == 4 ? state.commingSit : state.sit,
            S.current.sport_tabbar_rolling);
      });
    });
  }

  listenM() {
    ever(state.globalController.sportData, (callback) {
      // print('=================数据回来了');
      // print(callback);

      state.lock.synchronized(() {
        try {
          String ei = callback['ei'].toString();
          int ac = callback['ac'];

          if (state.sit == 0) {
            filter(ac, ei, json.decode(callback['v']) as List, state.rollingMatchList);
            filter(ac, ei, json.decode(callback['v']) as List, state.hotMatchList);
          } else if (state.sit == 2) {
            filter(ac, ei, json.decode(callback['v']) as List, state.favHotList);
            filter(ac, ei, json.decode(callback['v']) as List, state.favCommingList);
          } else if (state.sit == 3) {
            filter(ac, ei, json.decode(callback['v']) as List, state.rollingMatchList);
          } else if (state.sit == 4) {
            filter(ac, ei, json.decode(callback['v']) as List, state.comingMatchList);
          }
        } catch (e) {
          print('');
        }
      });
    });
  }

  filter(int ac, String ei, List rl, RxList<SportMatchModel> r) {
    if (ac == 1) {
      filterReduceBet(r.value, ei);
    } else {
      state.updateList.value = rl.map((e) => SportMatchModel.fromJson(e)).toList();
      // for (var element in state.updateList.value) {
      //   var x = r.firstWhere((x) => x.ei == element.ei);
      //   if(x == null){
      //     if(r.value.isNotEmpty){
      //       if(r.first.si == element.si && r.first.){
      //         r.value.add(element);
      //       }
      //     }
      //   }
      // }
      filterBet(r.value, state.updateList.value, true);
      r.refresh();
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    state.myTimer?.cancel();
  }

  changeCategoryIndex(int index) async {
    state.sportCategotyType.value = SportCategotyType.sport_loading;
    await Future.delayed(Duration(seconds: 1));
    state.sportCategotyType.value = SportCategotyType.values[index];
    state.cagetoryTabbarInitIndex.value = index;
    state.sit = 0;
    state.commingSit = 0;
    state.favHotSit = 0;
    state.favComminghSit = 0;
    state.commingSit = 0;
    refreshRolling(0, '');
  }

  getBanner() async {
    await ApiService.instance.getBanner(success: (res) {
      print(res);
    }, fail: (e) {
      print('object');
    });
  }

  Future<void> getTabs() async {
    await ApiService.instance.getAllSportCount(
        ic: 0,
        success: (res) {
          try {
            List l = res['list'];
            state.tabs.value = l.map((e) => SportHallCountModel.fromJson(e)).toList();
            state.commingTabs.value = [
              SportHallCountModel(
                nc: state.tabs.value.map((model) => model.nc ?? 0).reduce((a, b) => a + b),
                sn: S.current.sport_all,
                si: 0,
              ),
              // 将 SportHallCountModel 添加到列表开头
              ...(state.tabs.value ?? []),
              // 展开原始列表，注意处理空列表的情况
            ];
            state.tabs.value = state.tabs.where((element) => element.lc! > 0).toList();
            state.tabs.refresh();
            return;
          } catch (e) {}
        },
        fail: (e) {});
  }

  Future<List<SportMatchModel>> getListData(
      int si, int m, List ci, int hot, int page, int page_size) async {
    Completer<List<SportMatchModel>> completer = Completer<List<SportMatchModel>>();

    try {
      await ApiService.instance.getSportList(
        si: si,
        m: m,
        ci: ci,
        hot: hot,
        page: page,
        page_size: page_size,
        success: (Map<dynamic, dynamic> data) {
          List l = data['d'] ?? [];
          int t = data['t'] ?? 0;

          print('请数据:$si======$m======$ci=====$hot=====$page=====$page_size');
          print('列表数据:$l');

          List<SportMatchModel> sportList = l.map((e) {
            var model = SportMatchModel.fromJson(e);
            if (state.favedList.value.contains(model.ei)) {
              model.isFav = true;
            }
            model.ml?.map((k) {
              k.isFav = model.isFav;
            });
            return model;
          }).toList();

          if (sportList.length == t) {
            if (hot == 1) {
              state.hotShowMore = false;
            } else {
              if (m == 3) {
                state.rollingShowMore = false;
              } else {
                state.commingShowMore = false;
              }
            }
          } else {
            if (hot == 1) {
              state.hotShowMore = true;
            } else {
              if (m == 3) {
                state.rollingShowMore = true;
              } else {
                state.commingShowMore = true;
              }
            }
          }

          completer.complete(sportList);
        },
        fail: (String? message) {
          completer.complete([]);
        },
      );
    } catch (e) {
      completer.complete([]);
    }

    return completer.future;
  }

  Future<List<SportMatchModel>> getFavListData() async {
    Completer<List<SportMatchModel>> completer = Completer<List<SportMatchModel>>();

    try {
      await ApiService.instance.getSportFavList(
        sis: state.tabs.value.map((e) => e.si).toList(),
        cur: '701',
        success: (Map<dynamic, dynamic> data) {
          List l = data['d'];
          List<SportMatchModel> sportList = l.map((e) {
            return SportMatchModel.fromJson(e);
          }).toList();
          sportList.forEach((element) {
            element.isFav = true;
            element.ml?.forEach((e) {
              e.isFav = element.isFav;
            });
          });

          state.oldFavHotList.value = state.favHotList.value;
          state.oldFavCommingList.value = state.favHotList.value;

          state.favHotList.value = sportList.where((e) => e.m == 3).toList();
          state.favCommingList.value = sportList.where((e) => e.m != 3).toList();

          filterBet(state.favHotList.value, state.oldFavHotList.value, false);
          filterBet(state.favCommingList.value, state.oldFavCommingList.value, false);

          state.favedList.value = sportList.map((e) => e.ei ?? '').toList();
          completer.complete(sportList);
        },
        fail: (String? message) {
          completer.complete([]);
        },
      );
    } catch (e) {
      completer.complete([]);
    }

    return completer.future;
  }

  getSportAddFav(int si, List<String> eis, String cur, String title) async {
    print('${si} -- ${eis}');

    SportMatchModel? m;
    if (title == S.current.sport_tabbar_rolling) {
      m = filterFav(state.rollingMatchList.value, eis.first ?? '');
    } else if (title == S.current.sport_bet_hot) {
      m = filterFav(state.hotMatchList.value, eis.first ?? '');
    } else if (title == S.current.sport_fav_hot_rolling) {
      m = filterFav(state.favHotList.value, eis.first ?? '');
    } else if (title == S.current.sport_fav_comming_rolling) {
      m = filterFav(state.favCommingList.value, eis.first ?? '');
    } else {
      m = filterFav(state.comingMatchList.value, eis.first ?? '');
    }

    if (m == null) {
      return;
    }

    if (m?.isFav == true) {
      await ApiService.instance.getSportDetelFav(
        si: si,
        eis: eis,
        cur: cur,
        success: (Map<dynamic, dynamic> data) {
          m?.isFav = false;
          m?.ml?.forEach((e) {
            e.isFav = m?.isFav;
          });
          if (title == S.current.sport_tabbar_rolling) {
            state.rollingMatchList.refresh();
          } else if (title == S.current.sport_bet_hot) {
            state.hotMatchList.refresh();
          } else if (title == S.current.sport_fav_hot_rolling) {
            state.favHotList.refresh();
          } else if (title == S.current.sport_fav_comming_rolling) {
            state.favCommingList.refresh();
          } else {
            state.comingMatchList.refresh();
          }
        },
        fail: (String? message) {
          CustomSnackBar.showError(message ?? '', Get.context!);
        },
      );
    } else {
      await ApiService.instance.getSportAddFav(
        si: si,
        eis: eis,
        cur: cur,
        success: (Map<dynamic, dynamic> data) {
          m?.isFav = true;
          m?.ml?.forEach((e) {
            e.isFav = m?.isFav;
          });
          if (title == S.current.sport_tabbar_rolling) {
            state.rollingMatchList.refresh();
          } else if (title == S.current.sport_bet_hot) {
            state.hotMatchList.refresh();
          } else if (title == S.current.sport_fav_hot_rolling) {
            state.favHotList.refresh();
          } else if (title == S.current.sport_fav_comming_rolling) {
            state.favCommingList.refresh();
          } else {
            state.comingMatchList.refresh();
          }
        },
        fail: (String? message) {
          CustomSnackBar.showError(message ?? '', Get.context!);
        },
      );
    }
  }

  SportMatchModel? filterFav(List<SportMatchModel> list, String ei) {
    SportMatchModel? m;

    var k = list.firstWhere((element) => element.ei == ei, orElse: () {
      return SportMatchModel(ei: '-1');
    });

    if (k?.ei != '-1') {
      m = k;
    }

    return m;
  }

  refreshRolling(int index, String title) async {
    var sitChange = false;

    int? si = 0;

    if (state.m == 4) {
      sitChange = (state.commingSit == index) ? false : true;
      state.commingSit = index;
      si = state.commingTabs.value[index].si;
    } else {
      sitChange = (state.sit == index) ? false : true;
      state.sit = index;
      si = state.tabs.value[index].si;
    }

    if (!state.tabs.value.isNotEmpty) {
      return;
    }

    print('fav 开始请求: ${DateTime.now()}');

    // if (state.cagetoryTabbarInitIndex.value == 2)
    refreshFav(state.favHotSit, 2);

    print('fav 结束请求: ${DateTime.now()}');

    if (state.m == 3)
      getListData(si ?? 1, 3, [], 0, 1, state.rollingCount).then((value) {
        state.isShimmerView.value = false;
        if (value.isNotEmpty) {
          state.oldRollingMatchList.value = sitChange ? [] : state.rollingMatchList.value;
          state.rollingMatchList.value = value;
          // if (state.oldRollingMatchList.value.isNotEmpty) {
          filterBet(state.rollingMatchList.value, state.oldRollingMatchList.value, false);
          // }
        } else {
          state.rollingMatchList.value = [];
        }
        state.rollingMatchList.refresh();
      });

    // if (state.cagetoryTabbarInitIndex.value == 0)
    //   getListData(si ?? 1, 3, [], 1, 1, state.hotCount).then((value) {
    //     if (value.isNotEmpty) {
    //       state.oldHotMatchList.value = sitChange ? [] : state.hotMatchList.value;
    //       state.hotMatchList.value = value;
    //       if (state.oldHotMatchList.value.isNotEmpty) {
    //         filterBet(state.hotMatchList.value, state.oldHotMatchList.value, false);
    //       }
    //     } else {
    //       state.hotMatchList.value = [];
    //     }
    //     state.hotMatchList.refresh();
    //   });
    //
    // // si ?? 1
    // print('=======sisisis:${si}');

    if (state.m == 4)
      getListData(state.commingTabs.value[index].si ?? 1, 4, [], 0, 1, state.commingCount).then((value) {
        state.isShimmerView.value = false;
        if (value.isNotEmpty) {
          state.oldComingMatchList.value = sitChange ? [] : state.comingMatchList.value;
          state.comingMatchList.value = value;
          // if (state.oldComingMatchList.value.isNotEmpty) {
          filterBet(state.comingMatchList.value, state.oldComingMatchList.value, false);
          // }
        } else {
          // if (sitChange) {
          state.comingMatchList.value = [];
          // }else{
          //   print('object');
          // }
        }
        state.comingMatchList.refresh();
      });

    getTabs();
  }

  refreshFav(int index, int sitType) async {
    if (sitType == 0) {
      state.favHotSit = index;
    } else if (sitType == 1) {
      state.favComminghSit = index;
    } else {}

    state.favHotList.refresh();
    state.favCommingList.refresh();

    await getFavListData().then((value) {
      state.favTabs.value = state.tabs.value;
      state.favHotList.refresh();
      state.favCommingList.refresh();

      print('fav 数据回来了: ${DateTime.now()}');
    });
  }

  List<SportMatchModel> filterFavSi(List<SportMatchModel> l, int index) {
    print('========请求: ${DateTime.now()}');

    var s = l
        .where(
            (element) => element.si.toString().contains(state.favTabs.value[index].si.toString()))
        .toList();

    print('========结束: ${DateTime.now()}');

    return s;
  }

  more(String t) {
    var sit = state.sit;
    if (t == S.current.sport_tabbar_rolling) {
      state.rollingShowMore = false;
      if (state.rollingCount < 100) {
        state.rollingCount = state.rollingCount + 10;
      }
    } else if (t == S.current.sport_tabbar_coming) {
      state.commingShowMore = false;
      if (state.commingCount < 100) {
        state.commingCount = state.commingCount + 10;
      }
      sit = state.commingSit;
    } else if (t == S.current.sport_bet_hot) {
      state.hotShowMore = false;
      if (state.hotCount < 100) {
        state.hotCount = state.hotCount + 10;
      }
    }

    refreshRolling(sit, t);
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
}
