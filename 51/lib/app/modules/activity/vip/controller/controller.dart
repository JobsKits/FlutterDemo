import 'dart:ui';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/vip_home_model/vip_home_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/vip_level_model/vip_level_model.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Controller extends GetxController {
  RxInt currentIndex = 0.obs;

  List<Map<String, dynamic>> vipLevels = [
    {
      'level': 1,
      'betRequired': 1000,
      'depositRequired': 500,
      'color': const Color(0xff9FCCE7),
      'imageBg': Assets.theme1.images.activity.vip.vipLevelBg1.path,
    },
    {
      'level': 2,
      'betRequired': 2000,
      'depositRequired': 1000,
      'color': const Color(0xff4A94FF),
      'imageBg': Assets.theme1.images.activity.vip.vipLevelBg2.path,
    },
    {
      'level': 3,
      'betRequired': 3500,
      'depositRequired': 1500,
      'color': const Color(0xffD98EFF),
      'imageBg': Assets.theme1.images.activity.vip.vipLevelBg3.path,
    },
    {
      'level': 4,
      'betRequired': 5000,
      'depositRequired': 2000,
      'color': const Color(0xffFF9281),
      'imageBg': Assets.theme1.images.activity.vip.vipLevelBg4.path,
    },
    {
      'level': 5,
      'betRequired': 7000,
      'depositRequired': 3000,
      'color': const Color(0xff94ADFF),
      'imageBg': Assets.theme1.images.activity.vip.vipLevelBg5.path,
    },
    {
      'level': 6,
      'betRequired': 10000,
      'depositRequired': 5000,
      'color': const Color(0xffCF5EE0),
      'imageBg': Assets.theme1.images.activity.vip.vipLevelBg6.path,
    },
    {
      'level': 7,
      'betRequired': 15000,
      'depositRequired': 7500,
      'color': const Color(0xffFF482E),
      'imageBg': Assets.theme1.images.activity.vip.vipLevelBg7.path,
    },
    {
      'level': 8,
      'betRequired': 25000,
      'depositRequired': 10000,
      'color': const Color(0xffFF941D),
      'imageBg': Assets.theme1.images.activity.vip.vipLevelBg8.path,
    },
    {
      'level': 9,
      'betRequired': 50000,
      'depositRequired': 20000,
      'color': const Color(0xffFFCC1A),
      'imageBg': Assets.theme1.images.activity.vip.vipLevelBg9.path,
    },
    {
      'level': 10,
      'betRequired': 100000,
      'depositRequired': 50000,
      'color': const Color(0xffFB931C),
      'imageBg': Assets.theme1.images.activity.vip.vipLevelBg10.path,
    },
  ];

  late Rx<VipHomeModel> vipModel = VipHomeModel().obs;
  RxList<VipLevelModel> rebateModels = <VipLevelModel>[].obs;


  @override
  void onInit() async {
    super.onInit();

    refreshData();
  }

  Future<void> refreshData() async {
    reqVipInfoData();
    reqRebateListData();
  }

  Future<void> reqVipInfoData() async {
    final info = await UserApi().reqVipInfo();
    print({'reqVipInfoData ======= $info'});
    if (info.type == NetworkService.networkTypeSuccess) {
      vipModel.value = VipHomeModel.fromJson(info.data);
    }
  }

  Future<void> reqRebateListData() async {
    final info = await UserApi().reqRebateListData();
    print({'reqRebateListData ======= $info'});
    if (info.type == NetworkService.networkTypeSuccess) {
      rebateModels.assignAll((info.data as List)
        .map((item) => VipLevelModel.fromJson(item))
        .toList());
    }
  }

  Future<void> reqCollectionReceive(AwardItem item) async {
    final response = await ActivityApi.reqCollectionReceive(item.type);
    if (response.type == NetworkService.networkTypeSuccess && response.data['response_code'] == '9999') {
      EasyLoading.showSuccess('领取成功');
      await LoginManager.instance.reqMoney();
    } else {
      EasyLoading.showError('${response.data}');
    }
  }

  Future<void> reqVIPPrivilegePackageData(AwardItem item) async {
    final response = await UserApi().reqVIPPrivilegePackageData(item.type, vipModel.value.data?[currentIndex.value].level ?? 0);
    print({'reqVIPPrivilegePackageData ======= $response'});
    if (response.type == NetworkService.networkTypeSuccess && response.data['response_code'] == '9999') {
      EasyLoading.showSuccess('领取成功');
      await LoginManager.instance.reqMoney();
    } else {
      EasyLoading.showError('${response.data}');
    }
  }

  List<AwardItem> get currAwardData {
    // print('${activeIndex.value}, ${changeLevelRewardData.value}, activeIndex.value');
    
    final changeData = vipModel.value.data?[currentIndex.value];
    final levelData = vipModel.value.t;
    final user = LoginManager.instance.loginInfo;
    
    if (changeData == null || user == null) return [];
    
    final isCurrLevel = changeData.level == user.custLevel;
    final isBeforeLevel = changeData.level! < user.custLevel!.toInt();
    final isAfterLevel = changeData.level! > user.custLevel!.toInt();
    
    final awards = [
      AwardItem(
        key: '1',
        label: '升级礼金',
        value: bignumberDivide([changeData.levelReward ?? 0, 1000]),
        status: changeData.isLevelReward != 2,
        disabled: isAfterLevel || changeData.isLevelReward != 1,
        icon: Assets.theme1.images.activity.vip.vipUplevelSalary.path,
        show: (changeData.levelReward ?? 0) > 0,
        type: 100,
      ),
      AwardItem(
        key: '2',
        label: '日俸禄',
        value: bignumberDivide([changeData.dayReward ?? 0, 1000]),
        status: levelData?.dayRewardState != 2 || isAfterLevel,
        disabled: !isCurrLevel || levelData?.dayRewardState != 1,
        icon: Assets.theme1.images.activity.vip.vipDaySalary.path,
        show: !isBeforeLevel && (changeData.dayReward ?? 0) > 0,
        type: 121,
      ),
      AwardItem(
        key: '3',
        label: '周俸禄',
        value: bignumberDivide([changeData.weekReward ?? 0, 1000]),
        status: levelData?.weekRewardState != 2 || isAfterLevel,
        disabled: !isCurrLevel || levelData?.weekRewardState != 1,
        icon: Assets.theme1.images.activity.vip.vipWeekSalary.path,
        show: !isBeforeLevel && (changeData.weekReward ?? 0) > 0,
        type: 101,
      ),
      AwardItem(
        key: '4',
        label: '月俸禄',
        value: bignumberDivide([changeData.monthReward ?? 0, 1000]),
        status: levelData?.monthRewardState != 2 || isAfterLevel,
        disabled: !isCurrLevel || levelData?.monthRewardState != 1,
        icon: Assets.theme1.images.activity.vip.vipMonthSalary.path,
        show: !isBeforeLevel && (changeData.monthReward ?? 0) > 0,
        type: 102,
      ),
      AwardItem(
        key: '5',
        label: '生日礼金',
        value: bignumberDivide([changeData.birthdayRedPacket ?? 0, 1000]),
        status: levelData?.birthdayState != 2 || isAfterLevel,
        disabled: !isCurrLevel || levelData?.birthdayState != 1,
        icon: Assets.theme1.images.activity.vip.vipBirthdaySalary.path,
        show: !isBeforeLevel && (changeData.birthdayRedPacket ?? 0) > 0,
        type: 8,
      ),
      AwardItem(
        key: '6',
        label: 'VIP 专属红包 兑换',
        value: bignumberDivide([changeData.exclusiveRedPacket ?? 0, 1000]),
        status: changeData.isExclusiveReward != 2,
        disabled: !isCurrLevel || changeData.isExclusiveReward != 1,
        icon: Assets.theme1.images.activity.vip.vipRedbagSalary.path,
        show: !isBeforeLevel && (changeData.exclusiveRedPacket ?? 0) > 0,
        type: 132,
      ),
    ];
    
    return awards.where((item) => item.show).toList();
  }

  double bignumberDivide(List<int> args) {
    if (args.isEmpty) return 0;
    if (args.length == 1) return args[0].toDouble();
    
    return args.sublist(1).fold<double>(
      args[0].toDouble(),
      (previousValue, element) {
        if (element == 0) return previousValue;
        return previousValue / element.toDouble();
      }
    );
  }

}

class AwardItem {
  final String key;
  final String label;
  final double value;
  final bool status;
  final bool disabled;
  final String icon;
  final bool show;
  final int type;

  AwardItem({
    required this.key,
    required this.label,
    required this.value,
    required this.status,
    required this.disabled,
    required this.icon,
    required this.show,
    required this.type,
  });
}
