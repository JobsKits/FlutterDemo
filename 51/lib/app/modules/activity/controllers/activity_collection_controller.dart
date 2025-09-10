import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_detail_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_coding_model/activity_coding_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_collection_model/activity_collection_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_record_model/activity_record_model.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../views/collection/activity_deposit_dialog.dart';

class ActivityCollectionController extends GetxController {
  final ActivityController actController = Get.find();
  final NewHomeController hcController = Get.put(NewHomeController());
  Rx<ActivityCollectionModel> recordDatas = ActivityCollectionModel().obs;
  late TabsController tabsController = Get.put(TabsController());
  RxString languageIcon = "".obs;
  Rx<ActivityRecordModel> receivedDatas = ActivityRecordModel().obs;
  RxList<ActivityCollectionModel> collections = <ActivityCollectionModel>[].obs;

  List<Map<String, dynamic>> typeOptions = [
    {'text': '全部', 'value': 99999},
    {'text': 'VIP福利', 'value': 5},
    {'text': '活动优惠', 'value': 1},
    {'text': '返水福利', 'value': 3},
    {'text': '利息收益', 'value': 4},
  ];

  List<Map<String, dynamic>> statusOptions = [
    {'text': '全部', 'value': 99999},
    {'text': '已领取', 'value': 0},
    {'text': '待领取', 'value': 1},
    {'text': '已过期', 'value': 4},
    {'text': '已派发', 'value': 5},
  ];

  RxInt currentTypeIndex = 0.obs;
  RxInt currentStatusIndex = 0.obs;
  RxString typeName = ''.obs;
  RxString statusName = ''.obs;

  dynamic typeValue = 99999;
  dynamic statusValue = 99999;

  @override
  void onInit() {
    super.onInit();
    collections.value = tabsController.collections.value;

    reqActivityCollections(receiveType: 99999);
    reqReceivedList(receiveType: 99999, status: 99999);
  }

  Future<void> reqActivityCollections({int receiveType = 0}) async {
    EasyLoading.show(status: '加载中...');
    final response =
        await ActivityApi.reqCollectionList(receiveType: receiveType);
    if (response.type == NetworkService.networkTypeSuccess) {
      collections.assignAll((response.data as List)
          .map((item) => ActivityCollectionModel.fromJson(item))
          .toList());
    }
    EasyLoading.dismiss();
  }

  Future<void> reqReviceYuEbao() async {
    final response = await ActivityApi.reqReviceYuEbao();
    if (response.type == NetworkService.networkTypeSuccess) {
      await LoginManager.instance.reqMoney();
      EasyLoading.showSuccess('领取成功');
    }
  }

  Future<void> reqReceivedList(
      {dynamic receiveType = 0, dynamic status = 0}) async {
    final response = await ActivityApi.reqReceivedList(
        receiveType: receiveType, status: status);
    if (response.type == NetworkService.networkTypeSuccess) {
      var model = ActivityRecordModel.fromJson(response.data);
      // model.data?.removeWhere((item) => item.state != 0 && item.state != 5);
      receivedDatas.value = model;
    }
  }

  Future<void> reqActivityReceive(int receiveId) async {
    if (LoginManager.instance.checkIsFrozen()) {
      return;
    }
    ActivityApi.reqActivityReceive(receiveId).then((res) {
      if (res.type == NetworkService.networkTypeSuccess) {
        tabsController.reqActivityCollections();
        reqActivityCollections(receiveType: 99999);
        reqReceivedList(receiveType: 99999, status: 99999);
        EasyLoading.showSuccess("领取成功");
      }
    }).catchError((error) {
      print({'error ========== $error'});
    });
  }

  /// 点击一键领取
  Future<void> reqCollectionReceive(
      int type, ActivityCollectionModel model) async {
    if (LoginManager.instance.checkIsFrozen()) {
      return;
    }
    EasyLoading.show(status: '加载中...');
    final response = await ActivityApi.reqCollectionReceive(type, model: model);
    if (response.type == NetworkService.networkTypeSuccess) {
      if (response.data['response_code'] == '0') {
        final data =
            jsonDecode(model.elotActivityPgForSysConfig?.actionCfg ?? '');
        final frequency =
            await ActivityApi.reqActivityRechrgeFrequency(model.receiveId ?? 0);
        final payList = await ActivityApi.reqActivityPaymentType();

        Get.dialog(
          ActivityDepositDialog(
            title: '领取条件',
            tips:
                '使用以下任意钱包充值 ${frequency.data} 次且金额为 ${(int.parse(data['receiveRechargeAmount'].toString()) / 1000).toStringAsFixed(0)}+，即可领取钱包充值福利奖励',
            data: payList.data,
            display: data['receiveRechargeType'],
            comfirmText: '去充值',
            cancelText: '查看详情',
            confirmAction: () {
              Get.back();
              var isOpenVideo =
                  TenantManager.instance.tenantBean?.isOpenVideo == 'true';
              tabsController.jumpToPage(isOpenVideo ? 2 : 1);
            },
            cancelAction: () async {
              final res = await ActivityApi.reqActivityDetails(
                  model.elotActivityPgForSysConfig!.id.toString());
              if (res.type == NetworkService.networkTypeSuccess) {
                final data = ActivityCodingModel.fromJson(res.data);
                Get.toNamed(
                  Routes.ACTIVITY_DETAIL,
                  arguments: {
                    "title": model.elotActivityPgForSysConfig?.activityName,
                    "type": ActivityTypsEnum.presave,
                    "presaveModel": data,
                  },
                );
              }
            },
          ),
          barrierDismissible: false,
        );
      } else if (response.data['response_code'] == '9999') {
        tabsController.reqActivityCollections();
        reqActivityCollections(receiveType: 99999);
        reqReceivedList(receiveType: 99999, status: 99999);
        EasyLoading.showSuccess('领取成功');
        await LoginManager.instance.reqMoney();
      }
    } else if (response.type == NetworkService.networkTypeError) {
      if (response.data.toString().contains("请完成短信验证之后再参与") ||
          response.data.toString().contains("请绑定手机号")) {
        Future.delayed(Duration(milliseconds: 250), () {
          EasyLoading.showError(response.data.toString());
        });
        Get.toNamed(Routes.USER_INFO,
            arguments: {"isShowSendCode": true, "isShowBindPhoneDialog": true});
      }
    }
    EasyLoading.dismiss();
  }

  Future<void> reqReceivedAllBouns() async {
    if (LoginManager.instance.checkIsFrozen()) {
      return;
    }
    final response = await ActivityApi.reqReceivedAllBouns();
    if (response.type == NetworkService.networkTypeSuccess &&
        response.data['response_code'] == '9999') {
      tabsController.reqActivityCollections();
      reqActivityCollections(receiveType: 99999);
      reqReceivedList(receiveType: 99999, status: 99999);
    }
  }

  reLoadData() {
    typeValue = typeOptions[currentTypeIndex.value]['value'];
    statusValue = statusOptions[currentStatusIndex.value]['value'];
    typeName.value = typeOptions[currentTypeIndex.value]['text'];
    statusName.value = statusOptions[currentStatusIndex.value]['text'];

    tabsController.reqActivityCollections(receiveType: typeValue);
    reqReceivedList(receiveType: typeValue, status: statusValue);
  }

  resetData({int idx = 0}) {
    if (idx == 1) {
      typeName.value = '';
      tabsController.reqActivityCollections(receiveType: 99999);
    } else if (idx == 2) {
      statusName.value = '';
      reqReceivedList(receiveType: 99999, status: 99999);
    } else {
      typeName.value = '';
      statusName.value = '';
      tabsController.reqActivityCollections(receiveType: 99999);
      reqReceivedList(receiveType: 99999, status: 99999);
    }
  }
}
