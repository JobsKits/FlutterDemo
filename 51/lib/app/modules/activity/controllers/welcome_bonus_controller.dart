import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:get/get.dart';

class WelcomeBonusController extends GetxController {
  late String aid;

  RxString activityName = ''.obs;
  RxString startTime = ''.obs;
  RxString endTime = ''.obs;
  RxString content = ''.obs;
  RxString rule = ''.obs;
  RxString isShowDetailTime = ''.obs;

  RxString bonusCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // 获取传递的参数
    final arguments = Get.arguments as Map<String, dynamic>;

    aid = arguments['aid'];

    _reqActiveDetail();
  }

  Future<void> _reqActiveDetail() async {
    final response = await ActivityApi.reqActivityDetails(aid);
    if (response.type == NetworkService.networkTypeSuccess) {
      print('====> ${response.data}');
      activityName.value = response.data['t']['activityName'];
      startTime.value = response.data['t']['showStartTime'];
      endTime.value = response.data['t']['showEndTime'];
      content.value = response.data['t']['activityContent'];
      rule.value = response.data['t']['activityRule'];
      isShowDetailTime.value = response.data['t']['isShowDetailTime'];
    }
  }
}
