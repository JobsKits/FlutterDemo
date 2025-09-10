import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/agent_center_api.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/Finance.const.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:get/get.dart';
import '../data/agent_center_data_bean.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';

class AgentCenterDataController extends GetxController {
  RxBool isLoading = false.obs; // loading

  Rx<DateTypeEnum> currentDateType = DateTypeEnum.today.obs; // 默认今日

  Rx<AgentCenterDataBean> agentData = AgentCenterDataBean().obs; // 代理数据

  Rx<DateTime> startTime = dateTimeBy[0].obs; // 开始时间
  Rx<DateTime> endTime = dateTimeBy[1].obs; // 结束时间

  Rx<DateTime> changeTime = dateTimeBy[0].obs; // 记录日期组件变化时的时间
  RxBool isCheckedStartTime = false.obs; // 记录是点击了哪一个

  @override
  void onInit() {
    super.onInit();

    initData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // 数据请求
  Future<void> initData() async {
    _reqAgentPromoteData();
  }

  // 修改当前日期类型
  Future<void> setCurrentDateType(DateTypeEnum type) async {
    currentDateType.value = type;

    if (type != DateTypeEnum.custom) {
      _reqAgentPromoteData();
    }
  }

  int getDayType() {
    switch (currentDateType.value) {
      case DateTypeEnum.yesterday:
        return 2;
      case DateTypeEnum.today:
        return 1;
      case DateTypeEnum.weekly:
        return 3;
      case DateTypeEnum.monthly:
        return 4;
      case DateTypeEnum.custom:
        return 0;
    }
  }

  // 获取推广数据
  Future<void> _reqAgentPromoteData() async {
    try {
      EasyLoading.show(indicator: const CommonLoadingView());

      int dayType = getDayType();

      DateTime startDate = startTime.value;
      DateTime endDate = endTime.value;

      DateTime startDateStart =
          DateTime(startDate.year, startDate.month, startDate.day, 00, 00, 00);
      DateTime endDateLast =
          DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

      Map<String, dynamic> data = {
        'start_time':
            dayType == 0 ? startDateStart.millisecondsSinceEpoch.round() : '',
        'end_time':
            dayType == 0 ? endDateLast.millisecondsSinceEpoch.round() : '',
        'day_type': dayType,
      };

      final response = await AgentCenterApi.reqAgentPromoteData(data);

      if (response.type == NetworkService.networkTypeSuccess) {
        // 推广链接以及code
        if (response.data != null) {
          AgentCenterDataBean resData =
              AgentCenterDataBean.fromJson(response.data);
          agentData.value = resData;
          print('_reqAgentPromoteData====> ${response.data}');
        }
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  // 点击重置日期按钮
  void handleResetTime() {
    startTime.value = dateTimeBy[0];
    endTime.value = dateTimeBy[1];
  }

  // 确定查询
  void handleConfirmTime() {
    // 结束时间早于开始时间
    if (endTime.value.isBefore(startTime.value)) {
      EasyLoading.showToast('开始日期需小于结束日期');
      return;
    }

    // 关闭弹窗。进行查询
    Get.back();
    _reqAgentPromoteData();
  }

  // 时间改变
  Future<void> onTimeChange(DateTime time) async {
    changeTime.value = time;
  }

  // 修改当前点击
  void setIsCheckedStartTime(bool val) {
    isCheckedStartTime.value = val;
  }

  // 确认
  void onConfrimTime() {
    // 当前是开始时间
    if (isCheckedStartTime.value) {
      startTime.value = changeTime.value;
    } else {
      endTime.value = changeTime.value;
    }
  }
}
