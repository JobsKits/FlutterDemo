import 'package:get/get.dart';

typedef ActivityConfigurationInt = Map<String, int>;
typedef ActivityConfigurationString = Map<String, String>;

//活动信息管理类
class ActivityManager {
  ActivityConfigurationInt _activeConfiguration = {};
  ActivityConfigurationString _activeConfigurationDesc = {};
  ActivityConfigurationString _activeConfigurationDescDetail = {};

  RxMap<String, int> activeConfigurationObs = <String, int>{}.obs; // 监听

  ActivityManager._privateConstructor();
  static final ActivityManager instance = ActivityManager._privateConstructor();

  ActivityConfigurationInt get activeConfiguration => _activeConfiguration;
  ActivityConfigurationString get activeConfigurationDesc =>
      _activeConfigurationDesc;
  ActivityConfigurationString get activeConfigurationDescDetail =>
      _activeConfigurationDescDetail;

  void setActivityBean({
    required ActivityConfigurationInt activeConfiguration,
    required ActivityConfigurationString activeConfigurationDesc,
    required ActivityConfigurationString activeConfigurationDescDetail,
  }) {
    _activeConfiguration = activeConfiguration;
    activeConfigurationObs.value = activeConfiguration;
    _activeConfigurationDesc = activeConfigurationDesc;
    _activeConfigurationDescDetail = activeConfigurationDescDetail;
  }
}
