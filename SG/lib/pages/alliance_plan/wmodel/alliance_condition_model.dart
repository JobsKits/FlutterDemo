import 'package:get/get.dart';

import '../../../utils/date_util.dart';
import '../../../utils/time/time_format.dart';
import '../widget/custom_select_model.dart';
import '../widget/custom_select_time_widget.dart';

///[CustomAllianceConditionWidget] 组件 的回调 model
class AllianceConditionModel {
  //【0301需求变更】【app】联盟计划，我的佣金等页面，默认查当天的数据
  //默认前后一天
  // DateTime? defaultStartTime = DateTime.now().subtract(const Duration(days: 30)); //获取前一天数据
  // final defaultStartTimeObs = DateTime.now().subtract(const Duration(days: 30)).obs;
  // "start_time": "2024-01-21 00:00:00",
  // "end_time": "2024-01-23 23:59:59",
  DateTime? defaultStartTime =
      DateTime.parse(DateUtil.formatDate(DateTime.now(), format: TimeFormatterEnum.start.formatter)).toUtc();
  DateTime? defaultEndTime =
      DateTime.parse(DateUtil.formatDate(DateTime.now(), format: TimeFormatterEnum.end.formatter)).toUtc();

  CustomSelectModel? startTimeModel;
  CustomSelectModel? endTimeModel;

  CustomSelectModel? searchModel;

  CustomSelectModel? selectTypeModel;

  CustomSelectModel? selectCoinModel;

  void copyWith(AllianceConditionModel model) {
    startTimeModel = model.startTimeModel;
    endTimeModel = model.endTimeModel;
    searchModel = model.searchModel;
    selectTypeModel = model.selectTypeModel;
    selectCoinModel = model.selectCoinModel;
  }

  ///开始时间， 做格式处理 "2023-10-01 00:00:00"
  String getStartTime() {
    if (startTimeModel != null && startTimeModel!.data != null) {
      return DateUtil.formatDate(startTimeModel!.data, format: DateFormats.full);
    } else if (defaultStartTime != null) {
      return DateUtil.formatDate(defaultStartTime, format: DateFormats.full);
    } else {
      return "";
    }
  }

  ///开始时间， 做格式处理 "2023-10-01 00:00:00"
  String getEndTime() {
    if (endTimeModel != null && endTimeModel!.data != null) {
      return DateUtil.formatDate(endTimeModel!.data, format: DateFormats.full);
    } else if (defaultEndTime != null) {
      return DateUtil.formatDate(defaultEndTime, format: DateFormats.full);
    } else {
      return "";
    }
  }

  String getSearchWord() {
    return getModelValue(searchModel);
  }

  String getType() {
    return getModelValue(selectTypeModel);
  }

  String getCoin() {
    return getModelValue(selectCoinModel);
  }

  // ///转化成 接口请求 参数
  // void getTargetParams() {
  //   var params = {
  //     'start_time': getModelValue(startTimeModel),
  //     'end_time': getModelValue(endTimeModel),
  //     'username': getModelValue(searchModel), //下级用户名
  //     'model_id': getModelValue(selectTypeModel),
  //     'currency_id': getModelValue(selectCoinModel),
  //   };
  // }

  dynamic getModelValue(CustomSelectModel? model) {
    if (model != null && model.data.isNotEmpty) {
      return model.data;
    } else {
      return '';
    }
  }

  @override
  String toString() {
    return 'AllianceConditionModel{startTimeModel: $startTimeModel, endTimeModel: $endTimeModel, searchModel: $searchModel, selectTypeModel: $selectTypeModel, selectCoinModel: $selectCoinModel}';
  }
}

//内部组件，显示配置
class AllianceConditionConfig {
  final bool startTime;
  final bool endTime;
  final bool search;
  final bool sportType;
  final bool coinType;
  final bool showCommission; //是否显示累积佣金

  AllianceConditionConfig({
    this.startTime = false,
    this.endTime = false,
    this.search = false,
    this.sportType = false,
    this.coinType = false,
    this.showCommission = false,
  });

  AllianceConditionConfig.myshowCommission()
      : startTime = true,
        endTime = true,
        search = false,
        sportType = true,
        coinType = true,
        showCommission = true;

  AllianceConditionConfig.myPerformance()
      : startTime = true,
        endTime = true,
        search = true,
        sportType = false,
        coinType = true,
        showCommission = false;

  AllianceConditionConfig.allData()
      : startTime = true,
        endTime = true,
        search = true,
        sportType = false,
        coinType = true,
        showCommission = false;

  AllianceConditionConfig.directFinance()
      : startTime = true,
        endTime = true,
        search = true,
        sportType = false,
        coinType = true,
        showCommission = false;

  AllianceConditionConfig.directBetting()
      : startTime = true,
        endTime = true,
        search = true,
        sportType = false,
        coinType = true,
        showCommission = false;

  AllianceConditionConfig.directUser()
      : startTime = true,
        endTime = true,
        search = true,
        sportType = false,
        coinType = false,
        showCommission = false;

  AllianceConditionConfig.directReceive()
      : startTime = true,
        endTime = true,
        search = true,
        sportType = false,
        coinType = true,
        showCommission = false;
}
