import 'package:flutter_tiyu_app/api/tenant_api.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:get/get.dart';

class MaintenanceController extends GetxController {
  RxString title = '系统维护升级中'.obs;

  RxString startTime = ''.obs;
  RxString endTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _reqRepairData();
  }

  _setLocalData() async {
    // 获取当前时间
    DateTime beforeTime = DateTime.now();
    // 将当前时间取整为整小时（去除分钟和秒）
    DateTime roundedBeforeTime = DateTime(
        beforeTime.year, beforeTime.month, beforeTime.day, beforeTime.hour);
    // 获取两个小时后的时间
    DateTime afterTime = roundedBeforeTime.add(const Duration(hours: 2));
    // 格式化时间为 "MM/dd HH:mm"
    startTime.value = DateTimeUtils.formatTimestamp(
      roundedBeforeTime.millisecondsSinceEpoch,
      temp: 'MM/dd HH:mm',
    );
    endTime.value = DateTimeUtils.formatTimestamp(
      afterTime.millisecondsSinceEpoch,
      temp: 'MM/dd HH:mm',
    );
  }

  _reqRepairData() async {
    final response = await TenantApi.reqRepairData();

    if (response.type == NetworkService.networkTypeSuccess) {
      print('=====> ${response.data}');
      if (response.data['update_start'] != null) {
        startTime.value = DateTimeUtils.formatDateTime(
            response.data['update_start'],
            temp: 'MM/dd HH:mm');
      }

      if (response.data['update_end'] != null) {
        endTime.value = DateTimeUtils.formatDateTime(
            response.data['update_end'],
            temp: 'MM/dd HH:mm');
      }

      if (startTime.value.isEmpty && endTime.value.isEmpty) {
        _setLocalData();
      }
    } else {
      _setLocalData();
    }
  }
}
