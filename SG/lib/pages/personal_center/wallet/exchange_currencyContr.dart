import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../base/getx/base_controller.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../model/wallet/CurrencyBean.dart';
import '../../../utils/sp_util.dart';

class  ExchangeCurrency extends BaseController {
  // final GlobalStateController globalController = Get.find<GlobalStateController>();
  //
  // final currentCurrencyBean = CurrencyBean().obs;
  //
  // final exChangeCurrencyBean = CurrencyBean().obs;
  //
  // final exchangeRate = 0.0.obs;
  //
  // final currentCurrencyText = "".obs; //以xx货币支付
  // final exChangeCurrencyText = "".obs; //兑换货币
  // final currentCurrencyAmountShowError = false.obs;
  // final currentCurrencyAmountShowErrorText = "".obs;
  //
  // final availableAmountList = [].obs; //可用币
  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   availableAmountList.value = globalController.currTypeLists.where((bean) => double.parse(bean.amount!) > 0).toList();
  //
  // }
  // initData() {
  //   ///未写完 待周一继续
  //   for(int i=0;i<globalController.currTypeLists.length;i++){
  //     if(globalController.currTypeInitialLists[i].cur == "706"){
  //       globalController.currTypeInitialLists[i].isSelected = true ;
  //       exchangeCurrFun(globalController.currTypeInitialLists[i]);
  //     }
  //   }
  // }
  //
  // exchangeCurrFun(CurrencyBean currencyBean) {
  //   exChangeCurrencyBean.value = currencyBean;
  //
  //   exchangeRate.value = getSingleCurrentCurrencyExchangeRate(
  //       (currentCurrencyBean.value.cur ?? "").isEmpty
  //           ? currencyDepositSelectCoinId.value
  //           : currentCurrencyBean.value.cur ?? "",
  //       (exChangeCurrencyBean.value.cur ?? "").isEmpty
  //           ? currencyDepositSelectCoinId.value
  //           : exChangeCurrencyBean.value.cur ?? "");
  //
  //   calculateAmount(double.parse(exChangeCurrencyText.value.isEmpty?"0.0":exChangeCurrencyText.value));
  // }
  //
  // currentCurrFun(CurrencyBean currencyBean) {
  //   currentCurrencyBean.value = currencyBean;
  //
  //   currentCurrencyText.value = currencyBean.amount ?? "";
  //   exchangeRate.value = getSingleCurrentCurrencyExchangeRate(
  //       (currentCurrencyBean.value.cur ?? "").isEmpty
  //           ? currencyDepositSelectCoinId.value
  //           : currentCurrencyBean.value.cur ?? "",
  //       (exChangeCurrencyBean.value.cur ?? "").isEmpty
  //           ? currencyDepositSelectCoinId.value
  //           : exChangeCurrencyBean.value.cur ?? "");
  //   convertCurrency(double.parse(currentCurrencyText.value.isEmpty?"0.0":currentCurrencyText.value));
  // }
}