import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_coding_model/activity_coding_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_ranklist_model/activity_ranklist_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_ranklist_model/datum.dart';
import 'package:flutter_tiyu_app/kernel/network/helper.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/app/modules/activity/widget/tips_dialog.dart';
import 'package:intl/intl.dart';

import 'activity_controller.dart';

class LeaderboardRewardController extends GetxController {
  late String title;
  late String aid;
  RxString myOrderNo = ''.obs; // 我目前的排名
  RxDouble myRankAmount = 0.0.obs; // 可获得奖金
  RxString myAwardAmount = '0.0'.obs; // 可获得奖金

  RxString myOrderNoLastTime = ''.obs; // 上期排名
  RxDouble myAwardAmountLastTime = 0.0.obs; // 上期奖金
  final ActivityController actController = Get.find();
  RxList<Datum> rankingData = <Datum>[].obs;
  Rx<ActivityRanklistModel> rankModel = ActivityRanklistModel().obs;
  Rx<ActivityCodingModel> detailModel = ActivityCodingModel().obs;

  // late String content;
  // late String rule;
  // late num startTime;
  // late num endTime;

  RxString activityName = ''.obs;
  RxString startTime = ''.obs;
  RxString endTime = ''.obs;
  RxString content = ''.obs;
  RxString rule = ''.obs;
  RxString status = ''.obs;
  RxString isShowAvatar = ''.obs;
  RxString showAvatar = ''.obs;
  RxInt rankway = 0.obs;

  RxBool loading = false.obs; // loading

  @override
  Future<void> onInit() async {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    // title = arguments['title'] ?? '活动详情';
    aid = arguments['aid'];
    // content = arguments['content'];
    // rule = arguments['rule'];
    // startTime = arguments['startTime'];
    // endTime = arguments['endTime'];
    // _getRankList(90);

    await _reqActiveDetail();
    _getRankList(aid);
    // _reqParticipateRewardActivity();
  }

  Future<void> _reqActiveDetail() async {
    final response = await ActivityApi.reqActivityDetails(aid);
    if (response.type == NetworkService.networkTypeSuccess && response.data['response_code'] != "0") {
      detailModel.value = ActivityCodingModel.fromJson(response.data);
      activityName.value = response.data['t']['activityName'];
      startTime.value = response.data['t']['showStartTime'];
      endTime.value = response.data['t']['showEndTime'];
      content.value = response.data['t']['activityContent'];
      rule.value = response.data['t']['activityRule'];
      status.value = response.data['t']['status'];
      showAvatar.value = response.data['t']['showAvatar'] ?? '';
      isShowAvatar.value = response.data['t']['isShowAvatar'] ?? '';
    }
  }

  Future<void> _getRankList(String aid) async {
    print({'RankList === '});
    final res = await ActivityApi.getRankList(aid);
    print({'RankList res === $res'});
    if (res.type == NetworkService.networkTypeSuccess) {
      rankModel.value = ActivityRanklistModel.fromJson(res.data);
      myOrderNo.value = rankModel.value.t?.myOrderNo ?? '';
      myRankAmount.value = double.parse(rankModel.value.t!.myRankAmount.toString());
      rankway.value = rankModel.value.t?.rankWay ?? 0;
      myOrderNoLastTime.value = rankModel.value.t?.myOrderNoLastTime ?? '';
      myAwardAmountLastTime.value = double.parse(rankModel.value.t!.myAwardAmountLastTime.toString());
      rankingData.value = rankModel.value.data ?? [];
      if (rankModel.value.t?.myAwardAmount != null || rankModel.value.t?.myAwardAmount != '') {
        if (rankModel.value.t!.myAwardAmount!.contains('-')) {
          final parts = rankModel.value.t?.myAwardAmount!.split('-');
          if (parts?.length == 2) {
            final startValue = double.tryParse(parts![0]) ?? 0;
            final endValue = double.tryParse(parts[1]) ?? 0;

            final formattedStart = NumberFormat("#,##0.00").format(startValue / 1000);
            final formattedEnd = NumberFormat("#,##0.00").format(endValue / 1000);

            myAwardAmount.value = '$formattedStart-$formattedEnd';
          }
        } else {
          final amount = NumberFormat("#,##0.00").format(double.parse(rankModel.value.t!.myAwardAmount.toString()) / 1000);
          myAwardAmount.value = amount;
        }
      }
    }
  }

  Future<void> _reqParticipateRewardActivity() async {
    final response =
        await ActivityApi.reqParticipateRewardActivity(aid, status.value);
    if (response.type == NetworkService.networkTypeSuccess) {}
  }

  Future<void> reqRankReward() async {
    try {
      loading.value = true;

      final response = await ActivityApi.reqRankReward(aid);

      // 本账号的用户名
      // String userName = LoginManager.instance.loginInfo?.custName ?? '';

      // print('====> ${response.type} ${response.data}');
      if (response.type == NetworkService.networkTypeSuccess) {
        // 成功
        if (response.data['response_code'] == '9999') {
          // 需要判断用户是否在前10的排行榜以内， 因为数据只获取了10条
          // int index =
          //     rankingData.indexWhere((item) => item['account'] == userName);

          // 不再排行榜之中
          if (myOrderNo.value == '暂未上榜') {
            Get.dialog(
              const TipsDialog(tips: '领取成功'),
              barrierDismissible: false,
            );
          } else {
            // 再排行中
            Get.dialog(
              TipsDialog(
                  tips:
                      '恭喜您本期排行榜排名第${myOrderNo.value}名，\n并获得${parseNumber(myRankAmount.value)}彩金！'),
              barrierDismissible: false,
            );
          }

          // 失败
        } else {
          if (response.data['msg'] != null) {
            EasyLoading.showError(response.data['msg']);
          }
        }
      }
    } finally {
      loading.value = false;
    }
  }
}
