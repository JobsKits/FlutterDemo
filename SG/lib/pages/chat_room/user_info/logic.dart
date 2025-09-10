import 'package:flutter_bet/services/api/extension/vip_api_service.dart';
import 'package:get/get.dart';

import '../../../model/user.dart';
import '../../../model/viplevel/viplevel_config_model.dart';
import '../../../services/account_service.dart';
import '../../../services/api/api_service.dart';
import '../../../utils/time/time_utils.dart';
import '../../front/front_state.dart';

class ChatRoomUserInfoController extends GetxController {
  final pageIndex = 0.obs;
  var username = '';

  final currentLevel = "0".obs;
  final vipLevel = "0".obs;
  final nextLevelAmount = "0".obs;
  final currentAlias = "".obs;
  final nextAlias = "".obs;
  List<VipLevelModel> dataList = [];

  late final FrontState state = FrontState();
  final completeRate = 0.00.obs;
  late User currentUser;
  AccountServiceListener? accountListener;

  @override
  void onInit() {
    super.onInit();

    // tabController = TabController(vsync: this, length: tabs.length);
    // tabController.addListener(() {
    //   if (tabController.indexIsChanging) {
    //     onTap(tabController.index);
    //   }
    // });
    if (AccountService.sharedInstance.isLogin()) {
      currentUser = AccountService.sharedInstance.currentUser!;
    }
    loadVipLevelData();
    accountListener = AccountServiceListener(
        onLoginSuccess: (model) {
          loadVipLevelData();
          print("接收到登录成功");
        },
        onLogout: () {},
        onTokenInvalid: () async {});
    AccountService.sharedInstance.addListener(accountListener!);
  }

  String getJoinTime() {
    return TimeUtils.timeStampToTimeYMD(AccountService.sharedInstance.currentUser?.createdAt ?? 0);
  }

  loadVipLevelData() async {
    if (AccountService.sharedInstance.isLogin() == false) {
      print("登录中");
      return;
    }

    // AccountService.sharedInstance.refreshUserInfo();
    currentUser = AccountService.sharedInstance.currentUser!;
    currentLevel.value = (int.parse(currentUser.vip!)).toString();
    vipLevel.value = (int.parse(currentUser.vip!) + 1).toString();

    currentAlias.value = "VIP${currentUser.vip}";
    nextAlias.value = "VIP${vipLevel.value}";
    // update(['front_view_vip']);

    await ApiService.instance.getVipLevelConfig(
      success: (data) {
        dataList.assignAll(data);
        currentLevel.value = currentUser.vip!;
        print("neco 用户当前等级 ${currentUser.vip}---分数 ${currentUser.score}");
        if (int.parse(currentUser.vip!) < 50) {
          VipLevelModel model = dataList[int.parse(currentUser.vip!) + 1];
          if (currentUser.score == "") {
            nextLevelAmount.value = model.total.toString();
          } else {
            if (double.parse(model.total.toString()) > double.parse(currentUser.score!)) {
              String currentUserScore = currentUser.score!;
              String modelScore = model.total.toString();

              double result = (double.parse(modelScore) - double.parse(currentUserScore));

              nextLevelAmount.value = "$result";
            }
          }

        } else {
          VipLevelModel model = dataList[int.parse(currentUser.vip!)];

          if (currentUser.score == "") {
            nextLevelAmount.value = model.total.toString();
            nextAlias.value = "VIP${model.level}";
          } else {
            final currentUserScore = currentUser.score ?? '0';
            final modelScore = model.total.toString();

            final result = (int.parse(modelScore) - int.parse(currentUserScore)).toString();
            nextLevelAmount.value = result;
          }
        }
        getVipProcessRate();
      },
      fail: (message) {
        print(message);
        print("登录中3");
      },
    );
  }

  void getVipProcessRate() {
    int vipLevel = int.parse(currentUser.vip!);
    double rate = 0;
    if (vipLevel == dataList.last.level.toString()) {
      rate == 1;
    } else {
      double dama0 = double.parse(dataList[vipLevel + 1].upgrade);
      rate = dama0 == 0 ? 0.0 : double.parse(currentUser.score!) / dama0;
    }
    completeRate.value = rate >= 1
        ? 1
        : rate <= 0
            ? 0
            : rate*100;
  }

  void animate() {
    // 设置位移动画
    state.xOffset.value = 30.0;
    // 延迟一段时间后恢复原位
    Future.delayed(const Duration(milliseconds: 500), () {
      state.xOffset.value = 0.0;
    });
  }
}
