import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../model/sport/sport_bet_list_model.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_icon.dart';
import '../../betting/sport/betting_sport_state.dart';

class SportBetState {
  late RxList<Tab> myBetTabs;
  ///投注活跃数据
  final betListActivity = <ListElement>[].obs;
  final betListDone = <ListElement>[].obs;
  var loading = false.obs;
  SportBetState() {
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
  buildData() {
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
