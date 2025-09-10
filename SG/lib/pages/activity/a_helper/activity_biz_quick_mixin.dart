import 'dart:developer';

import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/services/api/extension/activity_api_service.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../services/api/api_service.dart';
import '../../main/code.dart';
import '../a_model/activity_quick_api_model.dart';
import 'activity_biz_mixin.dart';

///首页 快捷入口 业务处理
mixin ActivityBizQuickMixin on ActivityBizMixin {
  final activityFloatObs = true.obs; //[总开关]活动快捷入口 是否显示
  final activityFloatLowObs = true.obs; //[小开关]活动快捷入口 是否显示
  final activityFloatListObs = <ActivityQuickApiModel>[].obs; //网络数据
  String baseNetIcon = AppValues.defaultBranch.asset_url;

  ///监听底部菜单切换,需要手动调用
  void initActivityBizQuickMixin() {
    //监听菜单，是否显示
    ever(GlobalStateController.of().buttonSelectIndex, (index) {
      // bool isShow = (index == MenuCode.GAME.index) || (index == MenuCode.MSG.index);
      // bool isShow = (index == MenuCode.GAME.index) || (index == MenuCode.MSG.index);
      //todo:[0610老板需求]新需求：体育界面不显示这个活动的浮窗，只在娱乐城上面显示。我们界面改版了，投注选项在右边会挡住。
      activityFloatLowObs.value = (index == MenuCode.GAME.index);
    });
  }

  ///是否显示
  bool isShowActivityQuick() {
    return activityFloatObs.value && activityFloatLowObs.value && activityFloatListObs.isNotEmpty;
  }

  ///首页活动快捷入口
  void loadQuickActivity() async {
    await ApiService.instance.getQuickPromotions(
      success: (List<ActivityQuickApiModel> data) {
        if (data.isNotEmpty) {
          activityFloatListObs.assignAll(data);
          activityFloatObs.value = true;
        } else {
          activityFloatObs.value = false;
        }
      },
      fail: (bool isConnect, String? message, candy) {
        activityFloatObs.value = false;
      },
    );
  }

  ///获取活动快捷入口 image url
  String getQuickActivityImageUrl(int index) {
    var url = activityFloatListObs[index].iconList?.first;
    if (url != null && url.isNotEmpty) {
      return "$baseNetIcon/$url";
    }
    return "";
  }

  ///活动快捷入口 点击处理
  void onQuickActivityItemClick(ActivityQuickApiModel model) {
    log("活动快捷入口...点击了...");
    // ActivityPromotionPage.openPage(model.id);
    onQuickActivityItemClickMixin(model);
  }

  ///活动快捷入口 点击关闭
  void onQuickActivityClickClose() {
    log("活动快捷入口...点击了...关闭...");
    activityFloatObs.value = false;
  }
}
