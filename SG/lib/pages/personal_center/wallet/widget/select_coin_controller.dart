import 'package:flutter_bet/model/wallet/CurrencyBean.dart';
import 'package:get/get.dart';

class SelectCoinController extends GetxController {
  //TODO: Implement StartController

  final count = 0.obs;
  //用来搜索展示是，因为还涉及到本地的搜索，不能直接使用原数据的列表
  final coinList = <CurrencyBean>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
