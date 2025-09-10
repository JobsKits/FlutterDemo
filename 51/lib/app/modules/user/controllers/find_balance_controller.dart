import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/game_balance_bean.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:get/get.dart';

import '../../../../api/home_api.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../kernel/network/service.dart';
import '../../../../kernel/utils/game_utils.dart';
import '../../../../utils/login_manager.dart';
import '../../../../utils/sp_util.dart';
import '../../../../utils/tenant_manager.dart';
import '../../../data/home_game_tab_bean.dart';
import '../../../data/home_main_info_bean.dart';
import '../../../data/new_home_game_tab_bean.dart';
import '../../home/controllers/new_home_controller.dart';

class FindBalanceController extends GetxController {
  RxInt leftMenuIndex = 0.obs;
  RxList<NewHomeGameTabBean> leftList = <NewHomeGameTabBean>[].obs;
  RxList<GameBalanceBean> rightListNew = <GameBalanceBean>[].obs;
  List<GameBalanceBean> allRightListNew = []; //右侧列表的所有数据
  late NewHomeController homeController = Get.find();

  @override
  void onInit() async {
    super.onInit();
    reqMoney();
    await reqRightContentList();
  }

  Future<void> reqRightContentList() async {
    allRightListNew = await UserApi().reqGameBalanceList();
    await reqLeftList();
    refreshRightList(leftMenuIndex.value);
    EasyLoading.dismiss();
  }

  void changeLeftMenuIndex(int index) {
    leftMenuIndex.value = index;
    refreshRightList(index);
  }

  //刷新右侧列表
  void refreshRightList(int index) {
    rightListNew.value = [];
    if (index == 0) {
      rightListNew.value = allRightListNew;
    } else {
      rightListNew.value = allRightListNew.where((item) {
        return item.bigType == leftList[index].key;
      }).toList();
    }
  }

  Future<void> reqLeftList() async {
    EasyLoading.show(indicator: const CommonLoadingView());
    leftList.value = [
      NewHomeGameTabBean(
          title: "最近",
          iconPath: Assets.theme1.images.home.iconGameRecent,
          key: 103),
    ];
    var tempList = [
      NewHomeGameTabBean(
        title: '棋牌',
        key: 1,
        pageKey: GameUtils.getTabEName2(1),
        iconPath: homeController.homeCategoryList
                .firstWhereOrNull((item) => item.title.contains("棋牌"))
                ?.iconPath ??
            GameUtils.getTabIconPath2(1),
      ),
      NewHomeGameTabBean(
        title: '电子',
        key: 2,
        pageKey: GameUtils.getTabEName2(2),
        iconPath: homeController.homeCategoryList
                .firstWhereOrNull((item) => item.title.contains("电子"))
                ?.iconPath ??
            GameUtils.getTabIconPath2(2),
      ),
      NewHomeGameTabBean(
        title: '捕鱼',
        key: 3,
        pageKey: GameUtils.getTabEName2(3),
        iconPath: homeController.homeCategoryList
                .firstWhereOrNull((item) => item.title.contains("捕鱼"))
                ?.iconPath ??
            GameUtils.getTabIconPath2(3),
      ),
      NewHomeGameTabBean(
        title: '真人',
        key: 4,
        pageKey: GameUtils.getTabEName2(4),
        iconPath: homeController.homeCategoryList
                .firstWhereOrNull((item) => item.title.contains("真人"))
                ?.iconPath ??
            GameUtils.getTabIconPath2(4),
      ),
      NewHomeGameTabBean(
        title: '体育',
        key: 5,
        pageKey: GameUtils.getTabEName2(5),
        iconPath: homeController.homeCategoryList
                .firstWhereOrNull((item) => item.title.contains("体育"))
                ?.iconPath ??
            GameUtils.getTabIconPath2(5),
      ),
      NewHomeGameTabBean(
        title: '彩票',
        key: 7,
        pageKey: GameUtils.getTabEName2(7),
        iconPath: homeController.homeCategoryList
                .firstWhereOrNull((item) => item.title.contains("彩票"))
                ?.iconPath ??
            GameUtils.getTabIconPath2(7),
      ),
      NewHomeGameTabBean(
        title: '区块链',
        key: 10,
        pageKey: GameUtils.getTabEName2(10),
        iconPath: homeController.homeCategoryList
                .firstWhereOrNull((item) => item.title.contains("区块链"))
                ?.iconPath ??
            GameUtils.getTabIconPath2(10),
      ),
    ];
    List<int> validCategories = allRightListNew.map((e) => e.bigType!).toList();
    tempList.removeWhere((item) => !validCategories.contains(item.key));
    leftList.addAll(tempList);
    EasyLoading.dismiss();
  }

  // 获取账户余额
  Future<void> reqMoney() async {
    EasyLoading.show(indicator: const CommonLoadingView());
    if (TenantManager.instance.tenantBean != null &&
        LoginManager.instance.loginInfo != null) {
      await LoginManager.instance.reqMoney();
    }
    EasyLoading.dismiss();
  }

  // 回收余额 然后 查询余额
  Future<void> retrieveAndCheckBalance() async {
    EasyLoading.show(indicator: const CommonLoadingView());
    if (TenantManager.instance.tenantBean != null &&
        LoginManager.instance.loginInfo != null) {
      await UserApi().findMoney2('');
      await LoginManager.instance.reqMoney();
    }
    EasyLoading.dismiss();
  }

  void findMoney() async {
    EasyLoading.show(indicator: const CommonLoadingView());
    var playIds = "";
    for (var item in rightListNew) {
      if ((item.total?.toInt() ?? 0) > 0) {
        playIds += "${item.playId},";
      }
    }
    if (playIds.isEmpty) {
      Get.snackbar("找回失败", "暂无可找回余额");
      EasyLoading.dismiss();
      return;
    }

    playIds = playIds.substring(0, playIds.length - 1);
    bool isSuccess = await UserApi().findMoney2(playIds);
    if (isSuccess) {
      Get.snackbar("找回成功", "");
      reqMoney();
      reqRightContentList();
    } else {
      Get.snackbar("找回失败", "请等待游戏结算后重试！");
    }
    EasyLoading.dismiss();
  }
}
