import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_record_model/activity_record_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_record_model/datum.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ActivityRecordController extends GetxController {
  Rx<ActivityRecordModel> recordDatas = ActivityRecordModel().obs;
  final ActivityController actController = Get.find();

  double typeWidgetHeight = 0; //类型组件的高度
  double timeWidgetHeight = 0; //时间组件的高度

  GlobalKey timeKey = GlobalKey(); //类型的key
  GlobalKey typeKey = GlobalKey(); //类型的key
  RxString currentTimeName = "今日".obs;
  RxString currentTypeName = "全部".obs;
  RxInt currentTypeIndex = 0.obs;
  RxInt currentTimeIndex = 0.obs;

  /// 游戏Id
  final gameId = ''.obs;

  /// 游戏名称
  late var gameName = "";

  RxString selectDate = '今天'.obs;
  String sDate = '0';
  RxString selectStatus = '全部'.obs;
  String sStatus = 'null';
  List<Map<String, String>> date = [
    {'value': '0', 'name': '今天'},
    {'value': '1', 'name': '昨天'},
    {'value': '3', 'name': '近3天'},
    {'value': '7', 'name': '近7天'},
    {'value': '15', 'name': '近15天'},
    {'value': '30', 'name': '近30天'}
  ];
  List<Map<String, String>> status = [
    {'value': 'null', 'name': '全部'},
    {'value': '0', 'name': '已领取'},
    {'value': '5', 'name': '已派发'}
  ];

  @override
  void onInit() {
    super.onInit();
    requestActivityRecordData();

    ever(actController.currentTabIndex, (index) async {
      if (index == 6) {
        if (LoginManager.instance.isLogin.value) {
          requestActivityRecordData();
        }
      }
    });
  }

  void requestActivityRecordData() {
    recordDatas.value.data = [];
    ActivityApi.reqActivityRecorrdList(int.parse(sDate), sStatus).then((res) {
      if (res.type == NetworkService.networkTypeSuccess) {
        var model = ActivityRecordModel.fromJson(res.data);
        model.data?.removeWhere((item) => item.state != 0 && item.state != 5);
        recordDatas.value = model;
      }
    }).catchError((error) {
      print({'error ========== $error'});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateWidgetHeights();
    });
  }

  void _calculateWidgetHeights() {
    if (typeKey.currentContext != null) {
      // 在构建完成后执行
      var typeBox = (typeKey.currentContext!.findRenderObject() as RenderBox);
      typeWidgetHeight =
          typeBox.localToGlobal(Offset.zero).dy + typeBox.size.height;
    }

    if (timeKey.currentContext != null) {
      var timeBox = (timeKey.currentContext!.findRenderObject() as RenderBox);
      timeWidgetHeight =
          timeBox.localToGlobal(Offset.zero).dy + timeBox.size.height;
    }
  }

  void reqActivityReceive(int receiveLogId) {
    ActivityApi.reqActivityReceive(receiveLogId).then((res) {
      if (res.type == NetworkService.networkTypeSuccess) {
        requestActivityRecordData();
        EasyLoading.showSuccess("领取成功");
      }
    }).catchError((error) {
      print({'error ========== $error'});
    });
  }

  selectedGame(String id, String type) {
    if (type == 'date') {
      for (var item in date) {
        if (item['value'] == id) {
          sDate = item['value']!;
          selectDate.value = item['name']!;
          break;
        }
      }
    } else {
      for (var item in status) {
        if (item['value'] == id) {
          sStatus = item['value']!;
          selectStatus.value = item['name']!;
          break;
        }
      }
    }
    requestActivityRecordData();
  }
}
