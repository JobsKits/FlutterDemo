import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../model/sport/sport_bet_list_model.dart';
import '../../services/theme/theme_service.dart';
import '../../widget/custom_icon.dart';
class BetListState {
  late RxList<Tab> myBetTabs;

  ///投注活跃数据
  var betListDone = <ListElement>[].obs;
  var betListActivity = <ListElement>[].obs;
  ///未结算加载中
  RxBool activityLoading = false.obs;
  ///未结算加载失败
  RxBool activityErro = false.obs;
  ///已结算加载中
  RxBool doneLoading = false.obs;
  ///已结算加载失败
  RxBool doneErro = false.obs;
  BetListState() {
    myBetTabs = [
      Tab(
        icon: const CustomIcon(
          asset: 'assets/images/bet_slip/ic_bet_sigle.webp',
        ),
        child: Text(S.current.active_bet, style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ),
      Tab(
        icon: const CustomIcon(
          asset: 'assets/images/bet_slip/ic_bet_together.webp',
        ),
        child: Text(S.current.settled_bet, style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ),
    ].obs;
  }
}
