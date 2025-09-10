import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/api/home_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_bean.dart';
import 'package:flutter_tiyu_app/app/modules/home/model/activity_redbag_model/activity_redbag_model.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ActivitysWheelController extends GetxController {
  final wheelStatus = true.obs;
  late RxList<ActivityBaseBean> wheelDatas = <ActivityBaseBean>[].obs;
  late Rx<ActivityRedbagModel> redbagModel = ActivityRedbagModel().obs;

  @override
  void onInit() async {
    super.onInit();

    loadData();
    requestActivityDetail();
  }

  @override
  void onClose() {
    super.onClose();
  }

  loadData() async {
    final res = await ActivityApi.reqActivityDetail('电子活动');
    if (res.type == NetworkService.networkTypeSuccess) {
      List<ActivityListItemBean> result =
          ActivityListBean.fromJson(res.data).data!;
      List<ActivityListItemBean> filteredResult =
          result.where((item) => item.activeType == 83).toList();
      for (var item in filteredResult) {
        if (item.activeType == 83 && item.subject == '助力轮盘') {
          wheelDatas.add(item as ActivityBaseBean);
        }
      }
    }
  }

  requestActivityDetail() async {
    // ActivityBaseBean wheelData = wheelDatas.first;
    // final res = await ActivityApi.reqWheelData('电子活动');
  }
}
