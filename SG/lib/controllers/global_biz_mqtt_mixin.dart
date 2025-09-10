import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/app_values.dart';
import '../pages/activity/a_helper/activity_snackbar_hepler.dart';
import '../pages/activity/a_model/activity_common_params.dart';
import '../pages/alliance_plan/widget_cell/money_coin_cell_widget.dart';
import '../pages/betting/common_model/betting_race_api_model.dart';
import '../pages/betting/common_model/betting_record_api_model.dart';
import '../services/mqtt/mqtt_service.dart';
import '../services/theme/theme_service.dart';
import '../utils/deposit_withdrawal_notification_util.dart';
import '../utils/json_util.dart';
import '../widget/custom_text.dart';
import '../widget/snack_bar/custom_snack_bar.dart';
import 'global_biz_base_mixin.dart';
import 'global_state_controller.dart';
import 'model/mqtt_message_notify_api_model.dart';
import 'model/mqtt_message_param_model.dart';
import 'model/mqtt_message_promo_api_model.dart';

///消息处理
mixin GlobalBizMqttMixin {
  ///娱乐城所有投注
  final mqttCasinoAllRankingObs = <BettingRecordApiModel>[].obs;

  ///娱乐城风云榜
  final mqttCasinoStormRankingObs = <BettingRecordApiModel>[].obs;

  ///娱乐城竞赛排行榜
  final mqttCasinoRaceRankingObs = <BettingRaceApiModel>[].obs;

  ///处理娱乐城 所有投注
  void dealMqttCasinoAllRanking(MqttMessageEvent event) {
    //{qos: 1, retain: false, topic: dev/member/bet/zh/casino/all, payload: null, clientid: 291425234604195393}
    // var payload = json.decode(event.message);
    var payload = event.message;
    if (payload != null) {
      // log("所有投注Mqtt："+event.message);
      var modelList = JsonUtil.getObjectList<BettingRecordApiModel>(
        payload,
        (v) => BettingRecordApiModel.fromJson(v),
      );
      // log('接收获取娱乐城 所有投注有数据更新=${JsonUtil.encodeObj(modelList)}');
      mqttCasinoAllRankingObs.assignAll(modelList ?? []);
    }
  }

  ///处理娱乐城风云榜
  void dealMqttCasinoStormRanking(MqttMessageEvent event) {
    //{qos: 1, retain: false, topic: dev/member/bet/zh/casino/all, payload: null, clientid: 291425234604195393}
    // var payload = json.decode(event.message);
    var payload = event.message;
    if (payload != null) {
      var modelList = JsonUtil.getObjectList<BettingRecordApiModel>(
        payload,
        (v) => BettingRecordApiModel.fromJson(v),
      );
      // log('接收获取娱乐城 风云榜有数据更新=${JsonUtil.encodeObj(modelList)}');
      mqttCasinoStormRankingObs.assignAll(modelList ?? []);
    }
  }

  ///处理娱乐城竞赛排行榜
  void dealMqttCasinoRaceRanking(MqttMessageEvent event) {
    //{qos: 1, retain: false, topic: dev/member/bet/zh/casino/all, payload: null, clientid: 291425234604195393}
    // var payload = json.decode(event.message);
    var payload = event.message;
    if (payload != null) {
      var modelList = JsonUtil.getObjectList<BettingRaceApiModel>(
        payload,
        (v) => BettingRaceApiModel.fromJson(v),
      );
      log('接收获取娱乐城 竞赛排行榜有数据更新=${JsonUtil.encodeObj(modelList)}');
      mqttCasinoRaceRankingObs.assignAll(modelList ?? []);
    }
  }

  /*================================= 消息通知 =================================*/
  final newNotice = false.obs;
  final newNoticeUpdate = 0.obs;

  ///处理 消息通知
  void dealMqttMessageNotify(MqttMessageEvent event) async {
    log('收到第三方通知消息=${event.message}');
    newNotice.value = true;
    newNoticeUpdate.value = DateTime.now().millisecondsSinceEpoch;
    await Future.delayed(const Duration(milliseconds: 100));
    var apiModel = MqttMessageNotifyApiModel.fromJson(event.message);
    //类型甄别
    var typeEnum = MqttMessageNotifyTypeEnum.adaptor(apiModel.type);
    switch (typeEnum) {
      //推广活动 领取状态
      case MqttMessageNotifyTypeEnum.promo:
        MqttMessagePromoApiModel? promoApiModel = JsonUtil.getObj<MqttMessagePromoApiModel>(
          apiModel.payload,
          (v) => MqttMessagePromoApiModel.fromJson(v),
        );
        adaptorActivity(apiModel, promoApiModel);
        break;
      default:
        DepositWithdrawalNotifUtils.showNotificationPop(event.message);
    }
  }

  final notiApiModel = MqttMessageNotifyApiModel().obs;
  final notiPromoApiModel = MqttMessagePromoApiModel().obs;

  ///针对 "type": "promo", 活动通知  进行 分发处理
  void adaptorActivity(
      MqttMessageNotifyApiModel apiModel, MqttMessagePromoApiModel? promoApiModel) {
    if (promoApiModel == null) {
      return;
    }
    int? activityType = int.tryParse(promoApiModel.promoType ?? "");
    ActivityTypeEnum? activityTypeEnum = ActivityTypeEnum.adaptor(activityType);
    switch (activityTypeEnum) {
      case ActivityTypeEnum.promotion:
        dealActivityPromoReceive(promoApiModel);
        break;
      case ActivityTypeEnum.negativeProfit:
        notiApiModel.value = apiModel;
        notiPromoApiModel.value = promoApiModel;
        break;

      default:
        break;
    }
  }

  /*============================= 推广活动 通知逻辑 =============================*/
   final mqttActivityReceiveState = ActivityReceiveState.nothing.obs;
  ///处理 推广活动 领取状态通知
  void dealActivityPromoReceive(MqttMessagePromoApiModel? promoApiModel) {
    if (promoApiModel == null) {
      return;
    }
    //解析 领取 状态
    int stateInt = int.parse(promoApiModel.type ?? "");
    var receiveState = ActivityReceiveState.adaptorMqtt(stateInt);
    mqttActivityReceiveState.value = receiveState;
    var currentCoin = GlobalStateController.of().adaptorLocalCoin(promoApiModel.currencyId);
    ActivitySnackBarHelper.showReceiveSnackBar(
      receiveState: receiveState,
      bonusAmount: promoApiModel.bonusAmount,
      coinBean: currentCoin,
    );

  }
}
