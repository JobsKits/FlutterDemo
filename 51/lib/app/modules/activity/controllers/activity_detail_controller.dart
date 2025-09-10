import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/api/home_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_coding_model/activity_coding_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_right_model/activity_pg_list.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_winning_model/activity_winning_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/lucky_bet_model/lucky_bet_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/tips_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/model/activity_logredbag_model/activity_logredbag_model.dart';
import 'package:flutter_tiyu_app/app/modules/home/model/activity_redbag_detail_model/activity_redbag_detail_model.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';

enum ActivityTypsEnum {
  none, // 默认
  lucky, // 幸运注单
  bonus, // 注册送彩金
  coding, // 打码活动
  recharge, // 充值活动
  custom, // 充值活动
  presave, // 预存活动
}

class ActivityDetailController extends GetxController {
  RxBool isRedbag = false.obs;
  final webviewHeight = 1.0.obs;
  ActivityTypsEnum type = ActivityTypsEnum.none;
  final ActivityController actController = Get.find();
  final TabsController tabsController = Get.find();

  Rx<ActivityPgList> itemData = ActivityPgList().obs;
  late Rx<ActivityRedbagDetailModel> redbagDetailModel =
      ActivityRedbagDetailModel().obs;
  late Rx<ActivityLogredbagModel> logRedbagModel = ActivityLogredbagModel().obs;

  late Rx<LuckyBetModel> luckModel = LuckyBetModel().obs;
  late Rx<ActivityPgList> luckyItemModel = ActivityPgList().obs;

  late Rx<ActivityWinningModel> winnerModel = ActivityWinningModel().obs;
  late Rx<ActivityCodingModel> codingModel = ActivityCodingModel().obs;

  late Rx<ActivityCodingModel> customModel = ActivityCodingModel().obs;

  RxString title = '活动详情'.obs;

  RxDouble height = Get.height.obs;

  /// 彩金
  late int rechargeAmount = 0;
  late int playAmount = 0;
  RxBool reviceState = false.obs;

  /// 幸运注单
  late RxInt amount = 0.obs;
  late RxInt count = 0.obs;
  late RxInt todayReceiveTimes = 0.obs;
  late RxInt totalReceiveTimes = 0.obs;
  late RxInt lastReceiveTimes = 0.obs;

  late int receiveLogId = 0;
  late int bonusAmount = 0;
  RxBool luckyState = false.obs;

  RxInt codingState = 999.obs;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments as Map<String, dynamic>;
    title.value = arguments['title'];
    if (arguments['type'] == ActivityTypsEnum.lucky) {
      type = arguments['type'];
      luckModel.value = arguments['luckyBetModel'];
      luckyItemModel.value = arguments['listItemBean'];
      checkLuckyBetCanReceive();
    } else if (arguments['type'] == ActivityTypsEnum.coding) {
      type = arguments['type'];
      codingModel.value = arguments['codingModel'];
      reqReviceCodingDetail();
    } else if (arguments['type'] == ActivityTypsEnum.custom) {
      type = arguments['type'];
      customModel.value = arguments['customModel'];
      reqCustomApplyNumbers();
    } else if (arguments['type'] == ActivityTypsEnum.presave) {
      type = arguments['type'];
      codingModel.value = arguments['presaveModel'];
      if (codingModel.value.t?.status == '1') {
        reqApplyPreviewInfo();
      }
    } else {
      isRedbag.value = arguments['isRedbag'] ?? false;
      if (isRedbag.value) {
        redbagDetailModel.value = arguments['redbagDetailModel'];
        // logRedbagModel.value = arguments['logRedbagModel'];
        bool isLogin = LoginManager.instance.isLogin.value;
        if (isLogin) {
          checkUserRedbag();
        }
      } else {
        itemData.value = arguments['itemData'];
      }
    }
  }

  /// 领取红包
  Future<void> reqRedbagActivity() async {
    final response = await ActivityApi.reqRedbagActivity(
        logRedbagModel.value.receiveLogId ??
            redbagDetailModel.value.tasksId ??
            10);
    if (response.data['response_code'] == '9999') {
      Get.dialog(
        const TipsDialog(tips: '领取成功'),
        barrierDismissible: false,
      );
      reviceState.value = false;
      logRedbagModel.value.state = 0;
      final detail = await HomeApi.getRedbagDetailData(
          logRedbagModel.value.tasksId.toString());
      redbagDetailModel.value = ActivityRedbagDetailModel.fromJson(detail.data);
    }
  }

  checkUserRedbag() async {
    final res = await HomeApi.getRedbagData();
    if (res.type == NetworkService.networkTypeSuccess) {
      final logredModel = ActivityLogredbagModel.fromJson(res.data);
      logRedbagModel.value = logredModel;
      checkRedbagCanReceive(false);
    }
  }

  checkRedbagCanReceive(bool show) async {
    final res = await HomeApi.checkRedbagCanReceive(
        logRedbagModel.value.receiveLogId ??
            redbagDetailModel.value.tasksId ??
            10);
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999' && res.data['t'] != null) {
        rechargeAmount = res.data['t']['recharge_amount'];
        playAmount = res.data['t']['play_amount'];
        reviceState.value = false;
        if (show) {
          Get.dialog(
            const TipsDialog(
              tips: '抱歉，您当前不满足领取条件，无法领取',
              // desc: desc,
              comfirmText: '确定',
              contentF1Size: 42,
              contentF2Size: 35,
            ),
            barrierDismissible: false,
          );
        }
      } else {
        reviceState.value = true;
        if (show) {
          reqRedbagActivity();
        }
      }
    }
  }

  checkLuckyBetCanReceive() async {
    print({'luckModel.value ========${luckModel.value.toJson()}'});
    final res = await ActivityApi.reqLuckyBetActivityCanRevice(
        luckModel.value.fortuneId ?? 0);
    if (res.type == NetworkService.networkTypeSuccess) {
      amount.value = res.data['amount'];
      count.value = res.data['count'];
      todayReceiveTimes.value = res.data['todayReceiveTimes'];
      totalReceiveTimes.value = res.data['totalReceiveTimes'];
      lastReceiveTimes.value = res.data['lastReceiveTimes'];
    }
  }

  reqReviceCodingDetail() async {
    final res =
        await ActivityApi.reqReviceCodingDetail(codingModel.value.t?.id ?? 0);
    print({'object ========${res}'});
    if (res.type == NetworkService.networkTypeSuccess) {
      amount.value = res.data['activity_standard_amount'];
      count.value = res.data['receive_amount'];
      receiveLogId = res.data['receive_log_id'];
      // 0:已领取，1:领取，4:已过期，5:已派发
      codingState.value = res.data['state'];
    }
  }

  String codingButtonTitle() {
    if (codingState.value == 0) {
      return '已领取';
    } else if (codingState.value == 1) {
      return '领取';
    } else if (codingState.value == 4) {
      return '已过期';
    } else if (codingState.value == 5) {
      return '已派发';
    }

    return '去完成';
  }

  reqCustomApplyNumbers() async {
    final res =
        await ActivityApi.reqCustomApplyNumbers(customModel.value.t?.id ?? 0);
    if (res.type == NetworkService.networkTypeSuccess) {
      count.value = res.data;
    }
  }

  reqApplyPreviewInfo() async {
    final res =
        await ActivityApi.reqApplyPreviewInfo(codingModel.value.t?.id ?? 0);
    if (res.type == NetworkService.networkTypeSuccess) {
      amount.value = res.data;
    }
  }

  reqApplyPreview() async {
    final res = await ActivityApi.reqApplyPreview(codingModel.value.t?.id ?? 0);
    if (res.type == NetworkService.networkTypeSuccess && res.data == true) {
      reqApplyPreviewInfo();
      EasyLoading.showSuccess("申请成功");

      Get.toNamed(Routes.BOUNS_CENTER);
    }
  }

  receiveLuckyBet() async {
    final res =
        await ActivityApi.reqReviceLuckyBet(luckModel.value.fortuneId ?? 0);
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        Get.dialog(
          TipsDialog(
            tips: '领取成功',
            comfirmText: '确定',
            confirmAction: () {},
          ),
          barrierDismissible: false,
        );
        count.value = 0;
        luckModel.value.state = 0;
        luckyState.value = true;
      }
    }
  }

  Future<void> reqWinningDetail() async {
    final res = await ActivityApi.reqWinningDetail(
        luckModel.value.tailNum ?? '', luckModel.value.gameType ?? 0, luckModel.value.fortuneId ?? 0);
    if (res.type == NetworkService.networkTypeSuccess) {
      winnerModel.value = ActivityWinningModel.fromJson(res.data);
      bonusAmount = res.data['t'];
    }
  }

  Future<void> reqReviceCoding() async {
    final res = await ActivityApi.reqReviceCoding(receiveLogId);
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        Get.dialog(
          TipsDialog(
            tips: '${double.parse((count.value / 1000).truncateToFixed(2))}',
            type: 'main',
            comfirmText: '确定',
            bottomTips: '您可前往【优惠】—>【领取记录】查看记录',
            confirmAction: () {},
          ),
          barrierDismissible: false,
        );
      }
    }
  }

  displayTipsDialog(String type) {
    Get.dialog(
      TipsDialog(
        tips: type == 'android' ? '该活动仅限iOS用户参与' : '该活动仅限安卓用户参与',
        comfirmText: '确定',
        confirmAction: () {},
        type: 'custom',
      ),
      barrierDismissible: false,
    );
  }

  bool get showLuckyRow {
    if (type != ActivityTypsEnum.lucky) return false;
    try {
      final actionCfg = jsonDecode(luckyItemModel.value.actionCfg ?? '{}');
      return (actionCfg['restriction_type'] ?? 0) != 1;
    } catch (e) {
      return false;
    }
  }
}
