
import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/vip_home_model/vip_home_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/vip_level_model/vip_level_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class VipDetailController extends GetxController {

  late Rx<VipHomeModel> vipModel = VipHomeModel().obs;
  RxList<VipLevelModel> rebateModels = <VipLevelModel>[].obs;

  final List<String> columnKeys = ['level', '104', '103', '101', '100', '102', '106', '107', '109'];
  final Map<String, String> gamesTypeMap = {
    'level': 'VIP等级',
    '104': '体育',
    '103': '真人',
    '101': '电子',
    '100': '棋牌',
    '102': '捕鱼',
    '106': '彩票',
    '107': '区块链',
    '109': '原创',
  };

  final List<String> ruleKeys = ['1', '2', '3', '4', '5', '6', '7'];
  final Map<String, String> ruleTypeMap = {
    '1': '等级',
    '2': '流水要求',
    '3': '晋级礼金',
    '4': '生日红包',
    '5': '日俸禄',
    '6': '周俸禄',
    '7': '月俸禄',
  };

  RxString ruler = ''.obs; // vip规则

  @override
  void onInit() async {
    super.onInit();

    final arguments = Get.arguments as Map<String, dynamic>;
    if (arguments['models'] != null) {
      rebateModels.value = arguments['models'];
      vipModel.value = arguments['data'];
    }

    await _reqVipRuler();
  }

  // 获取vip晋级模式列表信息
  Future<void> _reqVipRuler() async {
    String? resData = await UserApi().reqVipRule();
    if (resData != null) {
      ruler.value = resData;
    }
  }
}
