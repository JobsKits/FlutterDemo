import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/api/home_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/tips_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_recive_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/model/activity_logredbag_model/activity_logredbag_model.dart';
import 'package:flutter_tiyu_app/app/modules/home/model/activity_redbag_detail_model/activity_redbag_detail_model.dart';
import 'package:flutter_tiyu_app/app/modules/home/model/activity_redbag_model/activity_redbag_model.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ActivitysRedbagController extends GetxController {
  final wheelStatus = false.obs;
  bool isLoading = false;
  final price = 0.0.obs;
  late Rx<ActivityRedbagModel> redbagModel = ActivityRedbagModel().obs;
  late Rx<ActivityLogredbagModel> logRedbagModel = ActivityLogredbagModel().obs;
  late Rx<ActivityRedbagDetailModel> redbagDetailModel =
      ActivityRedbagDetailModel().obs;
  late int rechargeAmount = 0;
  late int playAmount = 0;

  @override
  void onInit() async {
    super.onInit();

    ever(LoginManager.instance.isLogin, (value) async {
      wheelStatus.value = false;
      if (!LoginManager.instance.isLogin.value) {
        loadNotLoginRedbag();
      } else {
        Future.delayed(const Duration(seconds: 3), () {
          if (LoginManager.instance.isLogin.value) {
            loadRedbag(); // 确保登录状态未改变时再加载
          }
        });
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  loadNotLoginRedbag() async {
    final res = await HomeApi.getNotLoginRedbagData();
    if (res.type == NetworkService.networkTypeSuccess) {
      var result =
          res.data.firstWhere((item) => item['type'] == 1, orElse: () => {});
      redbagModel.value = ActivityRedbagModel.fromJson(result);
      price.value =
          double.parse((redbagModel.value.money! / 1000).truncateToFixed(2));
      wheelStatus.value = true;
    }
  }

  loadRedbag() async {
    final res = await HomeApi.getRedbagData();
    if (res.type == NetworkService.networkTypeSuccess) {
      logRedbagModel.value = ActivityLogredbagModel.fromJson(res.data);
      if (logRedbagModel.value.state == 1) {
        price.value = double.parse(
            (logRedbagModel.value.receiveAmount! / 1000).truncateToFixed(2));
        wheelStatus.value = true;
        loadRedbagDetail(logRedbagModel.value.tasksId ?? 0);
      }
    }
  }

  loadRedbagDetail(int taskId) async {
    final res = await HomeApi.getRedbagDetailData(taskId.toString());
    if (res.type == NetworkService.networkTypeSuccess) {
      redbagDetailModel.value = ActivityRedbagDetailModel.fromJson(res.data);
      wheelStatus.value = true;
    }
  }

  checkRedbagCanReceive() async {
    final res = await HomeApi.checkRedbagCanReceive(
        logRedbagModel.value.receiveLogId ?? 0);
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999' && res.data['t'] != null) {
        rechargeAmount = res.data['t']['recharge_amount'];
        playAmount = res.data['t']['play_amount'];

        final reT = double.parse((rechargeAmount / 1000).truncateToFixed(2));
        final cdT = double.parse((playAmount / 1000).truncateToFixed(2));
        final desc = '条件：充值$reT 打码$cdT';
        Get.dialog(
          TipsDialog(
            tips: '抱歉，您当前不满足领取条件，无法领取',
            // desc: desc,
            comfirmText: '去查看',
            contentF1Size: 42,
            contentF2Size: 35,
            confirmAction: () {
              wheelStatus.value = false;
              Get.toNamed(
                Routes.ACTIVITY_DETAIL,
                arguments: {
                  "itemData": null,
                  "isRedbag": true,
                  "title": logRedbagModel.value.activityName,
                  "logRedbagModel": logRedbagModel.value,
                  "redbagDetailModel": redbagDetailModel.value
                },
              );
            },
          ),
          barrierDismissible: false,
        );
      } else {
        wheelStatus.value = false;
        reqRedbagActivity();
      }
    }
  }

  /// 领取红包
  Future<void> reqRedbagActivity() async {
    final response = await ActivityApi.reqRedbagActivity(
        logRedbagModel.value.receiveLogId ?? 0);
    if (response.data['response_code'] == '9999') {
      Get.dialog(
        ActivityReciveDialog(price: price.value),
        barrierDismissible: false,
      );
    }
  }
}
