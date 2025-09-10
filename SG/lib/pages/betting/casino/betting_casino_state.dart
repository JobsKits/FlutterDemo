import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../generated/l10n.dart';
import '../../../model/yulecheng/casino_record_model.dart';
import '../betting_state.dart';

class BettingCasinoState {


  ///我的投注临时数据
  late RxList<CasinoRecordModel> betSlipList=<CasinoRecordModel>[].obs;
  // ///加载中
  // RxBool isLoading = false.obs;
  // ///加载失败
  // RxBool isError = false.obs;

  BettingCasinoState() {}
  buildData(){

  }
}

class BetSlipData {
  int? betId; //0：投注单 1:我的投注 3：风云榜 4:竞赛 5:所有投注
  String? icon;
  String name;
  String? money;
  String? moneyIcon;
  bool isHide;//是否隐藏

  BetSlipData({
    required this.name,
    this.icon,
    this.money,
    this.betId,
    this.moneyIcon,
    this.isHide = false,
  });
}
