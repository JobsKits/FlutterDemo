import 'package:flutter/material.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/model/wallet/CurrencyBean.dart';
import 'package:get/get.dart';


class PopCurrencyLogic extends GetxController {
  PopCurrencyLogic();

  final FocusNode focusNode = FocusNode();
  var isDismis = false;


  /// 币种列表
  List<CurrencyBean> coins = [];
  List<CurrencyBean> showCoins = [];

  /// 所选币种
  late CurrencyBean selCoin;


  _initData() {

    focusNode.addListener(_onFocusChange);
    update(["popCurrencyLogic_index"]);
  }

  initCoins(List<CurrencyBean>? coins) {
    if(coins == null) {
      GlobalStateController globalController = Get.find<GlobalStateController>();
      this.coins     = globalController.currTypeLists;
    }else {
      showCoins = coins;
    }
    showCoins  = this.coins;
    selCoin    = showCoins.first;
  }

  // 输入状态变化
  void _onFocusChange() async {
    if(!focusNode.hasFocus){
      await Future.delayed(const Duration(milliseconds: 100));
    }
    await Future.delayed(const Duration(milliseconds: 300));
    update(["popCurrencyLogic_index"]);
  }

  // 搜索框文本输入变化
  void onSearchTextChanged(String text) {

    if(text.isEmpty) {
      showCoins = coins;
      update(["popCurrencyLogic_index"]);
      return;
    }

    final textLowerCase = text.toLowerCase();
    showCoins = coins.where((element)  {
      final name = element.name!.toLowerCase();
      final symbol = element.symbol!.toLowerCase();
      return (name.contains(textLowerCase) || symbol.contains(textLowerCase));
    }).toList();
    update(["popCurrencyLogic_index"]);
  }


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
    focusNode.dispose();
    super.dispose();
  }

}
