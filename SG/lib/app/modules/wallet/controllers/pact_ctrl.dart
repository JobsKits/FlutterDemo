import 'package:get/get.dart';

import '../../../../controllers/global_state_controller.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';

class PactCtrl extends GetxController {
  final scale = 1.0.obs;
  final double bubbleWidth = 114;
  final ratio = 2.0;

  final currDepSelCtr = [].obs;
  final currDepSelCtrStr = "".obs;
  final currSelContractId = "".obs;

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

  void startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  setPact(CurrencyBean bean) {
    if (bean.currency_type == 2) {
      currDepSelCtr.value = bean.contract_type ?? [];
      if (currDepSelCtr.isNotEmpty) {
        currDepSelCtrStr.value = currDepSelCtr[0]['label'];
        currSelContractId.value = currDepSelCtr[0]['id'];
        for (int i = 0; i < currDepSelCtr.length; i++) {
          if (i == 0) {
            currDepSelCtr[0]['isSelect'] = true;
          } else {
            currDepSelCtr[i]['isSelect'] = false;
          }
        }
      }
    } else {
      currDepSelCtr.value = [];
    }
  }

  final GlobalStateController globalController = Get.find<GlobalStateController>();

  final GlobalKey rootViewWdlGlobalKey = GlobalKey();

  final fiatCurrTabSel = true.obs;

  final fiatCurrBeanSel = CurrencyBean().obs;

  final cryptoBeanSel = CurrencyBean().obs;

  assertField(String str) {
    String trim = str.trim();
    if (trim.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void getDefaultSelCoinData(List<CurrencyBean> list) {
    var value = globalController.currTypeSelected.value;
    var currencyType = value.currency_type;
    if (currencyType == 1) {
      fiatCurrTabSel.value = true;
      fiatCurrBeanSel.value = value;
      var curList = globalController.getCurList(false, list);
      cryptoBeanSel.value = curList.isNotEmpty ? curList[0] : CurrencyBean();
    } else {
      fiatCurrTabSel.value = false;
      cryptoBeanSel.value = value;
      var curList = globalController.getCurList(true, list);
      fiatCurrBeanSel.value = curList.isNotEmpty ? curList[0] : CurrencyBean();
    }
  }

  CurrencyBean getMergerSelCoin(bool fiatCurrTabSel) {
    return fiatCurrTabSel ? fiatCurrBeanSel.value : cryptoBeanSel.value;
  }

  String getMergerSelId(bool fiatCurrTabSel) {
    return "${fiatCurrTabSel ? fiatCurrBeanSel.value.cur : cryptoBeanSel.value.cur}";
  }
}
