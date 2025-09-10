import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_detail_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/tips_dialog.dart';
import 'package:flutter_tiyu_app/kernel/network/helper.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';

class ReliefFundController extends GetxController {
  final ActivityController actController = Get.find();
  ActivityTypsEnum type = ActivityTypsEnum.none;

  late String aid;
  RxString activityName = ''.obs;
  RxString startTime = ''.obs;
  RxString endTime = ''.obs;
  RxString content = ''.obs;
  RxString rule = ''.obs;
  RxString isShowDetailTime = ''.obs;
  RxString isShowAvatar = ''.obs;
  RxString showAvatar = ''.obs;
  RxString rewardType = ''.obs;
  RxList allLossRewards = [].obs;
  int receiveLogId = 0;
  RxInt receiveAmount = 0.obs; // 救援金
  RxInt standardAmount = 0.obs; // 亏损金额
  RxInt state = 99.obs; // 0 已领取、1：等待领取、2：等待激活(书签或APP登录进来激活)、4：作废、 5:已派发(系统派发)

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    activityName.value = arguments['title'] ?? '活动详情';
    aid = arguments['aid'];
    type = arguments['type'];

    _reqActiveDetail();
    if (type == ActivityTypsEnum.recharge) {
      _reqRechargRewards();
    } else {
      _reqReliefRewards();
    }
  }

  Future<void> _reqActiveDetail() async {
    final res = await ActivityApi.reqActivityDetails(aid);
    if (res.type == NetworkService.networkTypeSuccess) {
      // activityName.value = res.data['t']['activityName'] ?? '';
      startTime.value = res.data['t']['showStartTime'] ?? '';
      endTime.value = res.data['t']['showEndTime'] ?? '';
      content.value = res.data['t']['activityContent'] ?? '';
      rule.value = res.data['t']['activityRule'] ?? '';
      showAvatar.value = res.data['t']['showAvatar'] ?? '';
      isShowAvatar.value = res.data['t']['isShowAvatar'] ?? '';
      isShowDetailTime.value =
          res.data['t']['isShowDetailTime'] ?? res.data['isShowDetailTime'];
      String actionCfg = res.data['t']['actionCfg'];
      final config = jsonDecode(actionCfg);
      if (type == ActivityTypsEnum.recharge) {
        rewardType.value = config['bonusMethod'].toString();
        if (config['rewardSetting'] is List) {
          allLossRewards.value = config['rewardSetting'];
          print('allLossRewards: ${allLossRewards}');
        }
      } else {
        rewardType.value = config['rewardType'];
        if (config['rewardSettingList'] is List) {
          List setttingList = config['rewardSettingList'];
          allLossRewards.value = setttingList;
          print('allLossRewards: ${allLossRewards}');
        }
      }
    }
  }

  Future<void> _reqReliefRewards() async {
    final res = await ActivityApi.reqReliefRewards(aid);
    // print('_reqReliefRewards ${res}');
    if (res.type == NetworkService.networkTypeSuccess) {
      // print("data:${jsonEncode(res.data)}");
      receiveLogId = res.data['receive_log_id'] ?? 0;
      receiveAmount.value = res.data['receive_amount'] ?? 0;
      standardAmount.value = res.data['activity_standard_amount'] ?? 0;
      state.value = res.data['state'] ?? 99;
      // print('state: ${state.value}');
    }
  }

  Future<void> _reqRechargRewards() async {
    final res = await ActivityApi.reqRechargRewards(aid);
    if (res.type == NetworkService.networkTypeSuccess) {
      // print("data:${jsonEncode(res.data)}");
      receiveLogId = res.data['receive_log_id'] ?? 0;
      receiveAmount.value = res.data['receive_amount'] ?? 0;
      standardAmount.value = res.data['activity_standard_amount'] ?? 0;
      state.value = res.data['state'] ?? 0;
      print('state: ${state.value}');
    }
  }

  Future<void> getReliefRewards() async {
    if (state.value == 1 && receiveAmount.value > 0) {
      final res = await ActivityApi.getReliefRewards(receiveLogId);
      if (res.type == NetworkService.networkTypeSuccess) {
        if (res.data['response_code'] == '9999') {
          if (type == ActivityTypsEnum.recharge) {
            Get.dialog(
              TipsDialog(
                tips: '领取成功',
                comfirmText: '确定',
                confirmAction: () {},
              ),
              barrierDismissible: false,
            );
          } else {
            // 领取成功
            Get.dialog(
              _getRewardsWidget(),
              barrierDismissible: false,
            );
            _reqReliefRewards();
          }
        }
      }
    } else {
      Get.dialog(
        _noRewardsWidget(),
        barrierDismissible: false,
      );
    }
  }

  Widget _getRewardsWidget() {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 70.w),
      child: Container(
        height: 700.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40.r)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '温馨提示',
                  style: TextStyle(
                    fontSize: 57.sp,
                    color: const Color(0xFF3B3B3B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${receiveAmount.value / 1000}',
                        style: TextStyle(
                          fontSize: 120.sp,
                          color: const Color(0xFF10C8E3),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: ' 元',
                        style: TextStyle(
                          fontSize: 51.sp,
                          color: const Color(0xFF10C8E3),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '恭喜您获得救援金',
                  style: TextStyle(
                    fontSize: 51.sp,
                    color: const Color(0xFF3B3B3B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 210.w,
                    right: 210.w,
                    bottom: 30.w,
                  ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10C8E3), Color(0xFF00F5FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x8000DEFF),
                        offset: Offset(0, 6.w),
                        blurRadius: 10.w,
                      ),
                    ],
                  ),
                  height: 120.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      AppManager.instance.tapVibrate();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: double.infinity,
                      child: Text(
                        '确认',
                        style: TextStyle(
                          fontSize: 48.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 38.h,
              right: 46.w,
              child: InkWell(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                  },
                  child: Icon(
                    Icons.clear,
                    size: 72.w,
                    color: Colors.black26,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _noRewardsWidget() {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 70.w),
      child: Container(
        height: 700.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40.r)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '温馨提示',
                  style: TextStyle(
                    fontSize: 57.sp,
                    color: const Color(0xFF3B3B3B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '您暂时未满足条件\n无法领取',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 51.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 210.w,
                    right: 210.w,
                    bottom: 30.w,
                  ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10C8E3), Color(0xFF00F5FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x8000DEFF),
                        offset: Offset(0, 6.w),
                        blurRadius: 10.w,
                      ),
                    ],
                  ),
                  height: 120.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      AppManager.instance.tapVibrate();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: double.infinity,
                      child: Text(
                        '确认',
                        style: TextStyle(
                          fontSize: 48.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 38.h,
              right: 46.w,
              child: InkWell(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                  },
                  child: Icon(
                    Icons.clear,
                    size: 72.w,
                    color: Colors.black26,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
