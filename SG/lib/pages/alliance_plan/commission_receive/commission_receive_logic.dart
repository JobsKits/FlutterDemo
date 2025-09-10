import 'package:flutter_bet/generated/l10n.dart';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:get/get.dart';

import '../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../widget/snack_bar/custom_snack_bar_icons.dart';
import 'commission_receive_model.dart';
import 'commission_receive_state.dart';

class CommissionReceiveLogic extends BaseController {
  final CommissionReceiveState state = CommissionReceiveState();

  final modelList = <CommissionReceiveModel>[].obs;
  final isHaveReceive = false.obs;//是否可领取

  @override
  void onReady() {
    super.onReady();
    loadListData();
  }

  ///加载列表数据
  void loadListData(){
    var tempList = <CommissionReceiveModel>[];
    List.generate(Random().nextInt(50), (index) {
      var model = CommissionReceiveModel(
        walletType: Random().nextInt(5),
        walletMoney: 99999999.00,
        exchangeRate: 2.3223232,
      );
      tempList.add(model);
    });
    modelList.addAll(tempList);
    isHaveReceive.value = true;
  }

  ///点击 确认领取
  void onClickReceive(){
    CustomSnackBar.show(
        S.current.random_text_94+"\$"+S.current.random_text_95,
        title: S.current.random_text_96,
        Get.overlayContext!,
        preIcon: CustomSnackBarIcons.commissionSuccess);

    //领取成功
    isHaveReceive.value = false;
  }
}
