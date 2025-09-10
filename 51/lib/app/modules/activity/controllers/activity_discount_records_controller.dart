import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_apply_records_model/activity_apply_records_model.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ActivityDiscountRecordsController extends GetxController {
  int taskId = 0;
  int day = 0;
  double timeWidgetHeight = 0; //时间组件的高度
  GlobalKey timeKey = GlobalKey(); //时间的key
  RxString currentTimeName = "今日".obs;
  RxInt currentTimeIndex = 0.obs;
  late Rx<ActivityApplyRecordsModel> recordsModel =
      ActivityApplyRecordsModel().obs;

  List<Map<String, dynamic>> timeList = [
    {"timeTitle": "今日", "date": 0},
    {"timeTitle": "昨日", "date": 1},
    {"timeTitle": "近3日", "date": 3},
    {"timeTitle": "近7日", "date": 7},
    {"timeTitle": "近15日", "date": 15},
    {"timeTitle": "近30日", "date": 30},
  ];

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    taskId = arguments['id'];

    reqCustomApplyRecords();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 在构建完成后执行
      var timeBox = (timeKey.currentContext!.findRenderObject() as RenderBox);
      timeWidgetHeight =
          timeBox.localToGlobal(Offset.zero).dy + timeBox.size.height;
    });
  }

  reqCustomApplyRecords() async {
    final res = await ActivityApi.reqCustomApplyRecords(taskId, day);
    print({'object ======= $res'});
    if (res.type == NetworkService.networkTypeSuccess) {
      recordsModel.value = ActivityApplyRecordsModel.fromJson(res.data);
    }
  }

  void updateTime() {
    if (day == timeList[currentTimeIndex.value]["date"] &&
        currentTimeName == timeList[currentTimeIndex.value]["timeTitle"]) {
      return; //如果名字和类型都是之前的，就没必要更新
    }
    currentTimeName.value = timeList[currentTimeIndex.value]["timeTitle"];
    day = timeList[currentTimeIndex.value]["date"];
    reqCustomApplyRecords();
  }

  void changeTimeIndex(int index) {
    currentTimeIndex.value = index;
  }
}
