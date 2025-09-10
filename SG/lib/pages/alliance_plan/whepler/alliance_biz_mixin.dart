import 'package:get/get.dart';

import '../../../services/lang_service.dart';
import '../../../utils/date_util.dart';
import '../alliance_plan_logic.dart';
import '../wmodel/alliance_condition_model.dart';
import '../wmodel/alliance_sort_model.dart';

///联盟计划- 业务界别mixin
mixin AllianceBizMixin {
  ///father logic
  final AlliancePlanLogic _fLogic = AlliancePlanLogic.of();

  AlliancePlanLogic get fLogic => _fLogic;

  ///为了适配 国际化。非中文 标题过长
  ///是否是中文， 两种情况， 中文、非中文；非中文使用另一种宽度；
  // bool get isLanguageCn =>LangService().lang == LangType.zhCN;

  ///搜索条件封装model
  final conditionModelObs = AllianceConditionModel().obs;

  AllianceConditionModel get conditionModel => conditionModelObs.value;

  //排序封装model
  final AllianceSortModel sortModel = AllianceSortModel();

  // final DateTime defaultStartTime = DateTime.now().subtract(const Duration(days: 1));//获取前一天数据
  // final DateTime defaultEndTime = DateTime.now();

  // ///获取用户名
  // String getUserName() {
  //   return fLogic.apiModelObs.value.username ?? '';
  // }

  ///初始化 条件参数
  void initConditionParams() {}

  ///收集条件参数
  void collectParams(AllianceConditionModel cModel) {
    conditionModel.copyWith(cModel);
  }

  ///收集排序参数
  void collectSort(AllianceSortModel sModel) {
    sortModel.copyWith(sModel);
  }
}
