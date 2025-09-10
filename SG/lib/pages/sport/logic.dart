import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/main/code.dart';
import 'package:flutter_bet/pages/sport/sport_detail/model.dart';
import 'package:flutter_bet/pages/sport/state.dart';
import 'package:flutter_bet/pages/sport/tabmodel.dart';
import 'package:flutter_bet/pages/betting/casino/betting_casino_state.dart';
import 'package:flutter_bet/pages/betting/sport/betting_sport_state.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/sport_api_service.dart';
import 'package:flutter_bet/services/api/extension/yulecheng_game_service.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/widget/betting_list/logic.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/sport/custom_sport_mixin/custom_sport_bet_mixin.dart';
import 'package:flutter_bet/widget/sport/custom_sport_odd_type.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/pages/sport/sportbannermodel.dart';

class MessageLogic extends BaseController with GetTickerProviderStateMixin, CustomSportBetMixin {
  final MessageState state = MessageState();

  static MessageLogic of(){
   return Get.find<MessageLogic>();
  }
  
  @override
  void onInit() {
    super.onInit();
    initState();
    initConfig();
    initBottomData();
    getMarquee();
    getBanner();
    // getTopHot();
    getTabs().then((value) {
      if (state.tabsAll.isNotEmpty) {
        refreshRolling(0, S.current.sport_tabbar_rolling);
        getChampionData(1, 1, state.rollingCount).then((value) {
          state.isShimmerView.value = false;
          if (value.isNotEmpty) {
            state.oldChampionMatchList.value = state.championMatchList;
            state.championMatchList.value = value;
            filterBet(state.championMatchList, state.oldChampionMatchList, false);
          } else {
            state.championMatchList.value = [];
          }
          state.championMatchList.refresh();
        });
      }
    });
    ever(state.globalController.langType, (callback) {
      getBanner();
      // getTopHot();
      initConfig();
      refreshRolling(state.cagetoryTabbarInitIndex.value == 5 ? state.commingSit : state.sit,
            S.current.sport_tabbar_rolling);
    });
    if (state.globalController.isLogin.value) {
      loginState();
    }
    ever(state.globalController.isLogin, (callback) {
      if (state.globalController.isLogin.value) loginState();
    });
    ever(state.globalController.currTypeSelected, (callback) => loginState());
  }

  void loginState() async {
    await ApiService.instance.login(
      cur: state.globalController.currTypeSelected.value.cur??'706',
      success: (res) {

      }, fail: (e) {
        if (state.loginStateTimes <= 0) {
          CustomSnackBar.showError(e.toString(), state.context);
          Future.delayed(const Duration(seconds: 10),(){
            state.loginStateTimes = 3;
          });
        } else {
          state.loginStateTimes --;
          Future.delayed(const Duration(seconds: 1),(){
            loginState();
          });
        }
      }
    ); 
  }

  void initState() async {
    await ApiService.instance.getSportState(success: (res) {
      List list = res['d'];
      if (list.isNotEmpty) {
        var dic = list.first;
        if (dic['maintained'] == '2') maintained(startTime: dic['maintained_st'],endTime: dic['maintained_et']);
      } else {
        maintained();
      }
    }, fail: (e) {
      maintained();
    });  
  }

  void maintained({startTime,endTime}) {
    state.globalController.isNormal.value = false;
    state.isNormal.value = false;
    if (startTime != null && startTime > 999999999) {
      // state.maintainedStartTime = DateTime.fromMillisecondsSinceEpoch(startTime * 1000).toString().substring(0,16);
      state.maintainedStartTime = CommonUtil.getLocalTimeTitle(startTime);
    }
    if (endTime != null && endTime > 999999999) {
      // state.maintainedEndTime = DateTime.fromMillisecondsSinceEpoch(endTime * 1000).toString().substring(0,16);
      state.maintainedEndTime = CommonUtil.getLocalTimeTitle(endTime);
    }
    if (state.maintainedStartTime == '0') state.maintainedStartTime = '-';
    if (state.maintainedEndTime == '0') state.maintainedEndTime = '-';
  }

  void initConfig() async {
    await ApiService.instance.getSportConfig(success: (res) {
      state.filterModel = res;
    }, fail: (e) {

    }); 
  }

  ///手动跳转顶部tab
  void jumpTopTabPage(int index) {
    state.tabController.animateTo(index);
    changeCategoryIndex(index);
    // state.sportCategotyType.value = SportCategotyType.sport_hall;
  }

  void backHome() {
    state.logic.onMenuSelected(MenuCode.GAME);
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    state.tabController = TabController(length: state.topTabs.length, vsync: this);
    state.bottomTabController = TabController(length: state.bottomTabs.length, vsync: this);
    timerF();
    timerB();
    listenM();
    listenB();
  }

  timerF() {
    state.myTimer = Timer.periodic(const Duration(seconds: 20), (Timer timer) {
      state.lock.synchronized(() {
        refreshRolling(state.cagetoryTabbarInitIndex.value == 5 ? state.commingSit : state.sit,
            S.current.sport_tabbar_rolling);
      });
    });
  }

  timerB() {
    state.t = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      state.rollingMatchList.refresh();
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
          // print('');
        }
      });
    });
  }

  listenB() {
    ever(state.globalController.bets, (callback) {
      state.lock.synchronized(() {
        if (state.cagetoryTabbarInitIndex.value == 5) {
          filterBet(state.comingMatchList.value, state.comingMatchList.value, false);
          state.comingMatchList.refresh();
        } else if (state.cagetoryTabbarInitIndex.value == 4) {
          filterBet(state.rollingMatchList.value, state.rollingMatchList.value, false);
          state.rollingMatchList.refresh();
        } else if (state.cagetoryTabbarInitIndex.value == 3) {
          filterBet(state.favHotList.value, state.favHotList.value, false);
          state.favHotList.refresh();
        } else if (state.cagetoryTabbarInitIndex.value == 0) {
          filterBet(state.hotMatchList.value, state.hotMatchList.value, false);
          filterBet(state.rollingMatchList.value, state.rollingMatchList.value, false);
          state.hotMatchList.refresh();
          state.rollingMatchList.refresh();
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
    state.t?.cancel();
  }

  changeCategoryIndex(int index) async {

    state.hall_hall_index.value = 0;
    state.hall_vr_index.value = 0;
    state.hall_hot_index.value = 0;
    state.fav_hot_index.value = 0;
    state.fav_comming_index.value = 0;
    state.rolling_index.value = 0;
    state.comming_index.value = 0;
    // state.indexMain = 0;

    int sec = 1000;
    // if (index == 2 && state.favHotList.value.length == 0) {
    //   sec = 2500;
    // }
    state.sportCategotyType.value = SportCategotyType.sport_loading;

    state.cagetoryTabbarInitIndex.value = index;
    state.sit = 0;
    state.commingSit = 0;
    state.favHotSit = 0;
    state.favComminghSit = 0;
    state.commingSit = 0;
    refreshRolling(0, '');

    if (index != 2) await Future.delayed(Duration(milliseconds: sec));
    state.sportCategotyType.value = SportCategotyType.values[index];
  }

  getBanner() async {
    state.bannnerList.clear();
    await ApiService.instance.getBanner(success: (res) {
      state.bannnerList.value = res.map((e) => SportBannerModel.fromJson(e)).toList();
      state.bannnerList.refresh();
    }, fail: (e) {
      print('');
    });
  }

  getTopHot() async {
    state.bannnerList.clear();
    await ApiService.instance.getTopHot(success: (res) {
      List list = res['d'];
      if (list.isNotEmpty) {
        state.topHotList.value = list.map((e) => SportMatchModel.fromJson(e)).toList();
        state.topHotList.refresh();
      }
    }, fail: (e) {
      print('');
    });
  }

  Future<void> getTabs() async {
    await ApiService.instance.getAllSportCount(
        ic: 0,
        success: (res) {
          try {
            List l = res['list'];

            state.favTabs.value = l.map((e) => SportHallCountModel.fromJson(e)).toList();
            state.tabsAll.value = l.map((e) => SportHallCountModel.fromJson(e)).toList();
            // if(!state.tabs.value.isNotEmpty){
            //   print('object');
            // }
            state.commingTabs.value = [
              SportHallCountModel(
                nc: l
                    .map((e) => SportHallCountModel.fromJson(e))
                    .toList()
                    .map((model) => model.nc ?? 0)
                    .reduce((a, b) => a + b),
                sn: S.current.sport_all,
                si: 0,
              ),
              // 将 SportHallCountModel 添加到列表开头
              ...(l
                  .map((e) => SportHallCountModel.fromJson(e))
                  .toList()
                  .where((element) => (element.nc ?? 0) > 0)
                  .toList()),
              // 展开原始列表，注意处理空列表的情况
            ];
            state.tabsAll.refresh();
            return;
          } catch (e) {}
        },
        fail: (e) {
          CustomSnackBar.showError(e.toString(), state.context);
        });
  }

  showTabsData() {
    if (state.cagetoryTabbarInitIndex.value == 0) {
      var model = state.filterModel.listFilter![state.indexMain];
      switch (model.lfid) {
        case 1:
          state.tabs.value = state.tabsAll.where((element) => element.tc! > 0).toList();
          break;
        case 2:
          state.tabs.value = state.tabsAll.where((element) => element.lc! > 0).toList();
          break;
        case 3:
          state.tabs.value = state.tabsAll.where((element) => element.ec! > 0).toList();
          break;
        case 4:
          state.tabs.value = state.tabsAll.where((element) => element.cc! > 0).toList();
          break;
        case 5:
          state.tabs.value = state.tabsAll.where((element) => element.oc! > 0).toList();
          break;
        default:
          state.tabs.value = state.tabsAll.where((element) => element.lc! > 0).toList();
      }
    } else if (state.cagetoryTabbarInitIndex.value == 1) {
      state.tabs.value = state.tabsAll.where((element) => element.vsc! > 0).toList();
    }
  }

  Future<List<SportMatchModel>> getListData(
      int si, int m, List ci, int hot, int page, int page_size,{int ic = 0,int ivs = 2}) async {
    Completer<List<SportMatchModel>> completer = Completer<List<SportMatchModel>>();

    try {
      await ApiService.instance.getSportList(
        si: si,
        m: m,
        ci: ci,
        hot: hot,
        ic:ic,
        ivs: ivs,
        page: page,
        page_size: page_size,
        success: (Map<dynamic, dynamic> data) {
          List l = data['d'] ?? [];
          int t = data['t'] ?? 0;

          print('请数据:$si======$m======$ci=====$hot=====$page=====$page_size');
          // print('列表数据:$l');

          List<SportMatchModel> sportList = l.map((e) {
            var model = SportMatchModel.fromJson(e);
            if (state.favedList.contains(model.ei)) {
              model.isFav = true;
            }
            for (var k in model.ml!) {
              k.isFav = model.isFav;
            }
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
          showTabsData();
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

  Future<List<SportMatchModel>> getChampionData(int si,int page, int page_size,) async {
    Completer<List<SportMatchModel>> completer = Completer<List<SportMatchModel>>();

    try {
      await ApiService.instance.getChampionList(
        si: si,
        page: page,
        page_size: page_size,
        success: (data) {
          List l = data['d'] ?? [];
            int t = data['t'] ?? 0;

            print('请数据:$si=====$page=====$page_size');
            // print('列表数据:$l');

            List<SportMatchModel> sportList = l.map((e) {
              var model = SportMatchModel.fromJson(e);
              if (state.favedList.contains(model.ei)) {
                model.isFav = true;
              }
              model.ml?.map((k) {
                k.isFav = model.isFav;
              });
              return model;
            }).toList();

            state.commingShowMore = sportList.length != t;
            if (sportList.isEmpty) sportList.add(SportMatchModel(ml: [Ml(bt: 0)]));
            completer.complete(sportList);
        },
        fail: (message) {
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
        sis: state.tabs.map((e) => e.si).toList(),
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

          state.oldFavHotList.value = state.favHotList;
          state.oldFavCommingList.value = state.favHotList;

          state.favHotList.value = sportList;

          filterBet(state.favHotList.value, state.oldFavHotList.value, false);

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
    // print('${si} -- ${eis}');

    SportMatchModel? m;
    if (title == S.current.sport_tabbar_rolling) {
      m = filterFav(state.rollingMatchList.value, eis.first);
    } else if (title == S.current.sport_bet_hot) {
      m = filterFav(state.hotMatchList.value, eis.first);
    } else if (title == S.current.random_text_680) {
      m = filterFav(state.rollingMatchList.value, eis.first);
    } else if (title == S.current.sport_fav_hot_rolling) {
      m = filterFav(state.favHotList.value, eis.first);
    } else if (title == S.current.sport_fav_comming_rolling) {
      m = filterFav(state.favCommingList.value, eis.first);
    } else {
      m = filterFav(state.comingMatchList.value, eis.first);
    }

    if (m == null) {
      return;
    }

    if (m.isFav == true) {
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

          try {
            state.favHotList.removeWhere((element) => element.ei == eis.first);
            // ignore: unrelated_type_equality_checks
            if (state.cagetoryTabbarInitIndex == 3) {
              state.favHotList.refresh();
            }
          } catch (e) {}
        },
        fail: (String? message) {
          CustomSnackBar.showError(message ?? '', state.context);
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
          CustomSnackBar.showError(message ?? '', state.context);
        },
      );
    }
  }

  SportMatchModel? filterFav(List<SportMatchModel> list, String ei) {
    SportMatchModel? m;

    var k = list.firstWhere((element) => element.ei == ei, orElse: () {
      return SportMatchModel(ei: '-1');
    });

    if (k.ei != '-1') {
      m = k;
    }

    return m;
  }

  refreshRolling(int index, String title) async {
    var sitChange = false;

    int? si = 0;

    try {
      if (state.cagetoryTabbarInitIndex.value == 5) {
        sitChange = (state.commingSit == index) ? false : true;
        state.commingSit = index;
        si = state.commingTabs[index].si;
      } else {
        si = 1;
        sitChange = (state.sit == index) ? false : true;
        state.sit = index;
        showTabsData();
        si = state.tabs[index].si;
      }
    } catch (e) {}

    getTabs();

    if (!state.tabsAll.isNotEmpty) {
      return;
    }

    // print('fav 开始请求: ${DateTime.now()}');

    // if (state.cagetoryTabbarInitIndex.value == 2)
    refreshFav(state.favHotSit, 2);

    // print('fav 结束请求: ${DateTime.now()}');

    if (state.cagetoryTabbarInitIndex.value == 0) {
      var model = state.filterModel.listFilter![state.indexMain];
      if (model.type == 1) {
        getListData(si ?? 1, model.m!, [], 0, 1, state.rollingCount,ic: model.ic!).then((value) {
          state.isShimmerView.value = false;
          if (value.isNotEmpty) {
            state.oldRollingMatchList.value = sitChange ? [] : state.rollingMatchList;
            state.rollingMatchList.value = value;
            // if (state.oldRollingMatchList.value.isNotEmpty) {
            filterBet(state.rollingMatchList.value, state.oldRollingMatchList.value, false);
            // }
          } else {
            state.rollingMatchList.value = [];
          }
          state.rollingMatchList.refresh();
        });
      } else {
        getChampionData(si ?? 1, 1, state.rollingCount).then((value) {
          state.isShimmerView.value = false;
          if (value.isNotEmpty) {
            state.oldChampionMatchList.value = sitChange ? [] : state.championMatchList;
            state.championMatchList.value = value;
            // if (state.oldRollingMatchList.value.isNotEmpty) {
            filterBet(state.championMatchList, state.oldChampionMatchList, false);
            // }
          } else {
            state.championMatchList.value = [];
          }
          state.championMatchList.refresh();
        });
      }
      getListData(0, 0, [], 1, 1, state.hotCount).then((value) {
        state.isShimmerView.value = false;
        if (value.isNotEmpty) {
          state.oldHotMatchList.value = sitChange ? [] : state.hotMatchList;
          state.hotMatchList.value = value;
          if (state.oldHotMatchList.isNotEmpty) {
            filterBet(state.hotMatchList.value, state.oldHotMatchList.value, false);
          }
        } else {
          state.hotMatchList.value = [];
        }
        state.hotMatchList.refresh();
      });
    }

    if (state.cagetoryTabbarInitIndex.value == 1) {
      getListData(si ?? 1, 0, [], 0, 1, state.rollingCount,ivs: 1).then((value) {
        state.isShimmerView.value = false;
        if (value.isNotEmpty) {
          state.oldRollingMatchList.value = sitChange ? [] : state.rollingMatchList;
          state.rollingMatchList.value = value;
          // if (state.oldRollingMatchList.value.isNotEmpty) {
          filterBet(state.rollingMatchList.value, state.oldRollingMatchList.value, false);
          // }
        } else {
          state.rollingMatchList.value = [];
        }
        state.rollingMatchList.refresh();
      });
    }

    if (state.cagetoryTabbarInitIndex.value == 4) {
      getListData(si ?? 1, 3, [], 0, 1, state.rollingCount).then((value) {
        state.isShimmerView.value = false;
        if (value.isNotEmpty) {
          state.oldRollingMatchList.value = sitChange ? [] : state.rollingMatchList;
          state.rollingMatchList.value = value;
          // if (state.oldRollingMatchList.value.isNotEmpty) {
          filterBet(state.rollingMatchList.value, state.oldRollingMatchList.value, false);
          // }
        } else {
          state.rollingMatchList.value = [];
        }
        state.rollingMatchList.refresh();
      });
    }
      

    // si ?? 1
    // print('=======sisisis:${si}');

    if (state.cagetoryTabbarInitIndex.value == 5) {
      getListData(state.commingTabs[index].si ?? 1, 4, [], 0, 1, state.commingCount)
          .then((value) {
        state.isShimmerView.value = false;
        if (value.isNotEmpty) {
          state.oldComingMatchList.value = sitChange ? [] : state.comingMatchList;
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
    }
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
      // state.favTabs.value = state.tabs.value;
      state.favHotList.refresh();
      state.favCommingList.refresh();

      // print('fav 数据回来了: ${DateTime.now()}');
    });
  }

  List<SportMatchModel> filterFavSi(List<SportMatchModel> l, int index) {
    // print('========请求: ${DateTime.now()}');

    if (state.favTabs.isNotEmpty) {
      // if (state.favTabs.value.length >= index) {
      //   index = 0;
      // }
      var s = <SportMatchModel>[];
      try {
        s = l
            .where((element) => element.si.toString().contains(state.favTabs
                .where((element) {
                  return state.favHotList.map((e) => e.si).toList().contains(element.si);
                })
                .toList()[index]
                .si
                .toString()))
            .toList();
      } catch (e) {
        return s;
      }

      return s;
    } else {
      return [];
    }

    print('========结束: ${DateTime.now()}');
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

  Future<void> getMarquee() async {
    await ApiService.instance.getGameMarquee(
      success: (data) {
        String marquee = '';
        for (var item in data.marquee!) {
          marquee = '$marquee${item.title}  ${item.content}  ';
        }
        state.marqueeText.value = marquee;
      },
      fail: (message) {},
    );
  }

  top(){
    state.sc.animateTo(
      0.0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
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
