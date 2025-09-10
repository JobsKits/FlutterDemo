import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_info.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_turntable_dialog.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class TurntableRecordsController extends GetxController {
  double timeWidgetHeight = 0; //时间组件的高度

  GlobalKey timeKey = GlobalKey(); //类型的key
  RxString currentTimeName = "全部".obs;
  RxInt currentTimeIndex = 0.obs;

  RxList<TurntableRecordItem> models = RxList();
  String id = '85';

  RxString selectDate = '全部'.obs;
  String sDate = '0';
  List<Map<String, String>> date = [
    {'value': '1', 'name': '白银'},
    {'value': '2', 'name': '黄金'},
    {'value': '3', 'name': '钻石'},
    {'value': '0', 'name': '全部'},
  ];

  final Map<String, dynamic> arguments;

  TurntableRecordsController(this.arguments);

  @override
  void onInit() {
    super.onInit();
    // final arguments = Get.arguments as Map<String, dynamic>;
    print({'object ============== ${arguments}'});
    id = arguments['id'].toString();

    reqActivityTurntableRecords();
  }

  Future<void> reqActivityTurntableRecords() async {
    print({'response ========== '});
    final response = await ActivityApi.reqActivityTurntableRecords(id, sDate);
    print({'response ========== ${response.type}'});
    print({'response ========== ${response.data}'});
    if (response.type == NetworkService.networkTypeSuccess) {
      final datas = (response.data['t'] as List?)?.map((item) {
            return TurntableRecordItem.fromJson(item as Map<String, dynamic>);
          }).toList() ??
          [];
      models.value = datas;
    }
  }

  void _calculateWidgetHeights() {
    if (timeKey.currentContext != null) {
      var timeBox = (timeKey.currentContext!.findRenderObject() as RenderBox);
      timeWidgetHeight =
          timeBox.localToGlobal(Offset.zero).dy + timeBox.size.height;
    }
  }

  selectedGame(String id, String type) {
    for (var item in date) {
      if (item['value'] == id) {
        sDate = item['value']!;
        selectDate.value = item['name']!;
        break;
      }
    }

    reqActivityTurntableRecords();
  }
}
