import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/model/user.dart';
import 'package:flutter_bet/model/viplevel/viplevel_config_model.dart';
import 'package:flutter_bet/pages/home/home_logic.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/api/extension/vip_api_service.dart';
import 'package:flutter_bet/services/api/extension/yulecheng_game_service.dart';
import 'package:get/get.dart';

import '../../constant/app_values.dart';
import '../../controllers/global_state_controller.dart';
import '../../model/yulecheng/gamelist_model.dart';
import '../../model/yulecheng/yulecheng_changguan_model.dart';
import '../../model/yulecheng/yulecheng_lobby_model.dart';
import '../../routes/routes.dart';
import '../../services/api/api_service.dart';
import '../../services/event/event_service.dart';
import '../../utils/route_util.dart';
import '../../widget/refresh/custom_pull_to_refresh_controller.dart';
import '../main/code.dart';
import 'front_state.dart';

const kChangeMainPageEvent = 'kChangeMainPageEvent';

class FrontLogic extends BaseController with GetTickerProviderStateMixin {
  late final FrontState state = FrontState();

  AccountServiceListener? accountListener;

  List<VipLevelModel> dataList = [];
  late User currentUser;
  String currentLevel = "0";
  String vipLevel = "0";
  String nextLevelAmount = "0";
  String currentAlias = "";
  String nextAlias = "";
  double completeRate = 0.00;

  late YulechengLobbyModel yulechengModel = YulechengLobbyModel();
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  final CustomPullToRefreshController pullToRefreshController =
      CustomPullToRefreshController(controlFinishRefresh: false, controlFinishLoad: true);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (AccountService.sharedInstance.isLogin()) {
      currentUser = AccountService.sharedInstance.currentUser!;
    }

    state.tabController = TabController(length: 2, vsync: this);
    state.tabControllerTwo = TabController(length: 3, vsync: this);
    getMarquee();
    ever(Get.find<HomeLogic>().currencyLocal, (callback) => loadYulechengData());

    accountListener = AccountServiceListener(
        onLoginSuccess: (model) {
          loadVipLevelData();
          print("接收到登录成功");
        },
        onLogout: () {},
        onTokenInvalid: () async {});
    AccountService.sharedInstance.addListener(accountListener!);
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();
    // loadData(state.dataArray.length ~/ AppValues.defaultPageSize + 1, 3, state.dataArray);
    // loadData(
    //     state.zhenrendataArray.length ~/ AppValues.defaultPageSize + 1, 1, state.zhenrendataArray);
    if (AccountService.sharedInstance.isLogin()) {
      currentUser = AccountService.sharedInstance.currentUser!;
    }
    loadYulechengData();
    loadVipLevelData();
  }

  Future<void> loadYulechengData() async {
    await ApiService.instance.getLobbyGame(
      success: (data) {
        yulechengModel = data;
        update();
      },
      fail: (message) {},
    );
  }

  loadVipLevelData() async {
    print("登录中0");
    if (AccountService.sharedInstance.isLogin() == false) {
      print("登录中");
      return;
    }

    // AccountService.sharedInstance.refreshUserInfo();
    currentUser = AccountService.sharedInstance.currentUser!;
    currentLevel = (int.parse(currentUser.vip!)).toString();
    vipLevel = (int.parse(currentUser.vip!) + 1).toString();

    currentAlias = "VIP" + currentUser.vip.toString();
    nextAlias = "VIP" + vipLevel;
    update(['front_view_vip']);

    await ApiService.instance.getVipLevelConfig(
      success: (data) {
        print(data);
        dataList.clear();
        dataList.addAll(data);
        VipLevelModel currentModel = dataList[int.parse(currentUser.vip!)];
        currentLevel = currentUser.vip!;
        if (int.parse(currentUser.vip!) < 10) {
          VipLevelModel model = dataList[int.parse(currentUser.vip!) + 1];
          if (currentUser.score == "") {
            nextLevelAmount = model.total.toString();
          } else {
            nextLevelAmount =
                (int.parse(model.total.toString()) - int.parse(currentUser.score.toString()))
                    .toString();
          }
          if (currentUser.score == "") {
            completeRate = 0;
          } else {
            completeRate =
                (int.parse(model.total.toString()) - int.parse(currentUser.score.toString())) /
                    int.parse(model.total.toString());
          }
        } else {
          VipLevelModel model = dataList[int.parse(currentUser.vip!)];
          if (currentUser.score == "") {
            nextLevelAmount = model.total.toString()!;
            nextAlias = "VIP" + model.level!.toString();
          } else {
            nextLevelAmount =
                (int.parse(model.total.toString()!) - int.parse(currentUser.score!)).toString();
          }
          completeRate = 1;
        }

        update(['front_view_vip']);
      },
      fail: (message) {
        print(message);
        print("登录中3");
      },
    );
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

  void animate() {
    // 设置位移动画
    state.xOffset.value = 30.0;
    // 延迟一段时间后恢复原位
    Future.delayed(Duration(milliseconds: 500), () {
      state.xOffset.value = 0.0;
    });
  }

  void goToPlatDetail(YuLeChengChangGuanModel items) {
    RouteUtil.pushToView(Routes.yulechengCategoryPage,
        arguments: {"model": items, "fromChangguanPage": 4});
  }

  void goToDetail(GameLobbyModel items, needshowall, index) {
    if (needshowall == true) {
      RouteUtil.pushToView(Routes.yulechengCategoryPage, arguments: {
        "model": yulechengModel.items![index],
        "fromChangguanPage": 5,
        "needShow2pages": true,
      });
    } else {
      RouteUtil.pushToView(Routes.yulechengDetailPage,
          arguments: {"model": items, "prePage": "lobbyPage"});
    }
  }

  void goToMain(String name) {
    Get.back();
    onArticleCollect(name);
  }

  Future<void> onArticleCollect(name) async {
    if (name == 'casino') {
      EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.GAME);
    } else {
      EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.MSG);
    }
  }

  loadData(page, gametype, dataAccept) async {
    await ApiService.instance.getAllGames(
      page: page,
      game_type: gametype,
      success: (pageModel) {
        if (pageModel.over == true) {
          pullToRefreshController.finishLoad(result: CustomIndicatorResult.noMore);
        }
        dataAccept.addAll(pageModel.content);
        // Future.delayed(Duration(seconds: 1), () {
        //   update(['yulecheng_home_page']);
        // });
      },
      fail: (message) {
        pullToRefreshController.finishLoad();

        print(message);
      },
    );
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    if (accountListener != null) {
      AccountService.sharedInstance.removeListener(accountListener!);
    }
  }
// void goToDetail(GameListModel items) {
//   RouteUtil.pushToView(Routes.yulechengDetailPage, arguments: {"model": items});
// }
}
