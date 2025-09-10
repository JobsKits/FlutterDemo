import 'dart:developer';

import 'package:flutter_bet/services/api/extension/activity_api_service.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../routes/routes.dart';
import '../../../services/api/api_service.dart';
import '../../../utils/route_util.dart';
import '../../home/home_logic.dart';
import '../../main/code.dart';
import '../a_helper/activity_biz_mixin.dart';
import '../a_model/activity_common_params.dart';
import '../a_model/activity_quick_api_model.dart';
import 'custom_main_activity_dialog.dart';

///管理 首页 活动弹窗 业务逻辑
class CustomMainActivityDialogLogic extends GetxController with ActivityBizMixin {
  final activityFloatObs = true.obs; //活动快捷入口 是否显示
  final activityFloatListObs = <ActivityQuickApiModel>[].obs; //网络数据
  var showRoll = false;
  var rollId = '';

  static CustomMainActivityDialogLogic of() {
    return Get.put<CustomMainActivityDialogLogic>(CustomMainActivityDialogLogic());
  }

  @override
  void onInit() {
    super.onInit();
    initEvenListen();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void initEvenListen() {
    //监听登陆状态， 登陆 登出 都需要弹出活动
    ever(GlobalStateController.of().isLogin, (bool isLogin) async {
      // log("活动关闭窗口...${activityDialogMap.toString()}");
      if (!isLogin) {
        // onMainActivityClickClose();
        // RouteUtil.popToFirst(Routes.mainPage, code: MenuCode.MSG);
        Get.until((route) => route.settings.name == Routes.mainPage);
        log("活动关闭窗口...${activityDialogMap.toString()}");
      }
      await Future.delayed(const Duration(milliseconds: 200));
      loadMainActivityDialog();
    });

    ever(HomeLogic.of().state.getRollData, (callback) {
      if (HomeLogic.of().state.getRollData.value &&
          HomeLogic.of().state.luckyRecordState == LuckyRecordState.first) {
        showTurntableView(
            id: rollId,
            onDialogDelete: () {
              activityDialogMap.remove(ActivityTypeEnum.turntable);
            });
      }
    });
    ever(HomeLogic.of().state.getRollRecords, (callback) {
      if (HomeLogic.of().state.getRollData.value &&
          HomeLogic.of().state.luckyRecordState == LuckyRecordState.first) {
        showTurntableView(
            id: rollId,
            onDialogDelete: () {
              activityDialogMap.remove(ActivityTypeEnum.turntable);
            });
      }
    });
  }

  ///启动显示活动 对话框
  void loadMainActivityDialog() async {
    await ApiService.instance.getMainPromotions(
      success: (List<ActivityQuickApiModel> data) {
        if (data.isNotEmpty) {
          activityFloatListObs.assignAll(data);
          activityFloatObs.value = true;
          openDialog(activityFloatObs.value, activityFloatListObs.value);
        } else {
          activityFloatObs.value = false;
        }
      },
      fail: (bool isConnect, String? message, candy) {
        activityFloatObs.value = false;
      },
    );
  }

  ///活动对话框 打开 ，关闭状态
  final Map<ActivityTypeEnum, bool> activityDialogMap = <ActivityTypeEnum, bool>{};

  void openDialog(bool isShow, List<ActivityQuickApiModel> activityFloatList) {
    //轮播模式
    // CustomMainActivityDialog.showDetailDialog(
    //     context: Get.overlayContext!,
    //     dialogView: CustomMainActivityDialog(
    //       isShow: isShow && activityFloatList.isNotEmpty,
    //       // isShow:true,
    //       modelList: activityFloatList,
    //       onClickItem: (ActivityQuickApiModel model) {
    //         onMainActivityItemClick(model);
    //       },
    //       onClickClose: () {
    //         onMainActivityClickClose();
    //       },
    //     ));

    int closeDialogSize = 0;
    bool hasTurntable = false; //打开头部 和 底部 ，关闭对话，需要排除有转盘的
    //todo:[0530]单个模式
    for (var model in activityFloatList) {
      //针对 转盘特殊处理
      var typeEnum = ActivityTypeEnum.adaptor(model.ty) ?? ActivityTypeEnum.nothing;
      activityDialogMap[typeEnum] = true;
      if (typeEnum != null && typeEnum == ActivityTypeEnum.turntable) {
        // showTurntableView(model.id!);
        showRoll = true;
        rollId = model.id!;
        hasTurntable = true;
      } else {
        GlobalStateController.of()
            .showOverlayView(isShowTopBarView: false, isShowBottomBarView: false);
        CustomMainActivityDialog.showDetailDialog(
          context: Get.overlayContext!,
          dialogView: CustomMainActivityDialog(
            isShow: isShow && activityFloatList.isNotEmpty,
            // isShow:true,
            modelList: activityFloatList,
            isSwiper: false,
            model: model,
            onClickItem: (ActivityQuickApiModel model) {
              onMainActivityItemClick(model);
            },
            onClickClose: () {
              onMainActivityClickClose();
            },
          ),
          onDialogDelete: () {
            log("活动关闭窗口...");
            activityDialogMap.remove(typeEnum);
          },
        ).then((value) {
          closeDialogSize++;
          //排除有转盘的
          if (activityFloatList.length == closeDialogSize + (hasTurntable ? 1 : 0)) {
            GlobalStateController.of().showOverlayView();
          }
        });
      }
    }
  }

  String baseNetIcon = AppValues.defaultBranch.asset_url;

  ///点击处理
  void onMainActivityItemClick(ActivityQuickApiModel model) {
    log("活动快捷入口...点击了...");
    // ActivityPromotionPage.openPage(model.id);
    onQuickActivityItemClickMixin(model);
  }

  ///关闭对话框
  void onMainActivityClickClose() {
    log("活动快捷入口...点击了...关闭...");
    activityFloatObs.value = false;
    RouteUtil.popView();
  }
}
