import 'package:get/get.dart';

import '../../../../model/sport/sport_bet_list_model.dart';

class BettingSportMyBetState{
  ///注单明细-未结算
  var betUnBillListObs = <ListElement>[].obs;
  ///注单明细-已结算
  var betBilledListObs = <ListElement>[].obs;
  ///未结算加载中
  RxBool activityLoading = false.obs;
  ///未结算加载失败
  RxBool activityErro = false.obs;
  ///已结算加载中
  RxBool doneLoading = false.obs;
  ///已结算加载失败
  RxBool doneErro = false.obs;
}