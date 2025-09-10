
import 'package:get/get.dart';
import '../../../../controllers/global_state_controller.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../pages/personal_center/vault/model/coin_rate_model.dart';
import '../../../../utils/num_util.dart';

enum TypeEvent{
  redPacket,
  luckWheel
}

mixin ExchangeCurrencyMixin{
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final exchangeRate = 0.0.obs;
  final exChangeCurrencyBean = CurrencyBean().obs;
  final exChangeCurrencyText = "".obs; //兑换货币
  final searchAllAmountList = <CurrencyBean>[].obs;
  final allAmountList = <CurrencyBean>[].obs; //全币

  initExchangeData(){
    allAmountList.value = globalController.currTypeInitialLists;
  }

  String formatBalance(double balance) {
    // 保留小数点后9位
    String formattedBalance = balance.toStringAsFixed(9);
    // 去除小数点后的多余0
    formattedBalance = formattedBalance.replaceAll(RegExp(r'0*$'), '');
    // 去除末尾的小数点
    formattedBalance = formattedBalance.replaceAll(RegExp(r'\.$'), '');
    return formattedBalance;
  }

  exchangeCurrFun(CurrencyBean currencyBean, double amount) {
    exChangeCurrencyBean.value = currencyBean;
    saveExchangeSelected(currencyBean);
    exchangeRate.value =
        getSingleCurrentCurrencyExchangeRate("706", exChangeCurrencyBean.value.cur ?? "");
    convertCurrency(amount);
  }

  double getSingleCurrentCurrencyExchangeRate(String parentCurrencyKey, String currencyKey) {
    if (globalController.rateList.isNotEmpty) {
      if (parentCurrencyKey == currencyKey) {
        return 1;
      }
      CoinRate coinRate = globalController.rateList[parentCurrencyKey]!;
      return double.parse(coinRate.toJson()[currencyKey]);
    }
    return 0;
  }
  // 兑换货币 当前货币的金额
  void convertCurrency(double amount) {
    exChangeCurrencyText.value = NumUtil.keepDecimals(amount * exchangeRate.value,
        digits: exChangeCurrencyBean.value.currency_type == 2 ? 8 : 2);
  }

  void updateSearchAllAmountList(String value) {
    if (value.isNotEmpty) {
      var tempList = allAmountList
          .where((element) => element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      searchAllAmountList.assignAll(tempList);
    } else {
      searchAllAmountList.assignAll(allAmountList);
    }
    searchAllAmountList.refresh();
  }

  void resetSearchList() {
    searchAllAmountList.assignAll(allAmountList);
  }

  final currExchangeTypeSelected = CurrencyBean().obs;

  void saveExchangeSelected(CurrencyBean bean) {
    currExchangeTypeSelected.value = bean;
  }

  bool isExchangeSelectedItem(CurrencyBean bean) {
    return bean.cur == currExchangeTypeSelected.value.cur;
  }
}