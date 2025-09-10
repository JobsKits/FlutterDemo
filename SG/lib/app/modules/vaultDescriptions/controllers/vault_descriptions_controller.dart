import 'dart:developer';

import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:get/get.dart';

import '../../../../base/getx/page_state.dart';
import '../../../../controllers/global_state_controller.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../services/api/api_service.dart';
import '../../../../utils/sp_util.dart';

class VaultDescriptionsController extends GetxController {
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final coinName = "".obs;
  final coinIc = "".obs;
  final coinId = "".obs;
  final count = 0.obs;
  final interRestConfig = [].obs;
  final contentText = ''.obs;
  final ruleType = 0.obs;
  final coinLists = <CurrencyBean>[].obs;
  final coinIcDomain = '${AppValues.defaultBranch.asset_url}/currency/';
  final coinIcExtensionName = ".webp";
  final selCoinBean = {}.obs;
  final viewState = PageState.DEFAULT.obs;
  final isWebViewLoading = true.obs;

  final parts = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    ever(
        globalController.currTypeSelected, (callback) => {selectSaveCoin(), interestAllocations()});
  }

  @override
  void onReady() {
    super.onReady();
    selectSaveCoin();
    interestAllocations();
  }

  @override
  void onClose() {
    super.onClose();
  }

  ///获取已选中的币种
  selectSaveCoin() {
    if (SPUtil().getCurrencyBean() == null) {
      coinFun(globalController.currTypeLists[0]);
    } else {
      coinFun(globalController.currTypeSelected.value);
    }
  }

  coinFun(CurrencyBean bean, {int flag = 0}) {
    coinName.value = bean.name ?? "";
    coinIc.value = bean.coinIc ?? "";
    coinId.value = bean.cur ?? "";
    // contentText.value = '';
    // getSelCoin(bean);
  }

  //选中的的item model --
  // final currTypeSelected = CurrencyBean().obs;

  Future<void> interestAllocations() async {
    log("配置 利息 ${coinId.value}");
    if (contentText.value.isEmpty) {
      viewState.value = PageState.LOADING;
    }
    await ApiService.instance.interestAllocation<dynamic>(
        success: (data) {
          // interRestConfig.assignAll(data);
          // for (var item in data) {
          //   coinLists.add(
          //     CurrencyBean(
          //         cur: item['currency_id'].toString(),
          //         coinIc: "$coinIcDomain${item['currency_id']}$coinIcExtensionName",
          //         name: item['currency_name'],
          //         contentText: item['content_text'] ?? ''),
          //   );
          // }
          viewState.value = PageState.SUCCESS;
          var rateModel = data['rate'];
          selCoinBean['min_deposit'] = rateModel['min_deposit'] ?? "-";
          selCoinBean['interest_rate'] = rateModel['interest_rate'];
          contentText.value = data['rule']['detail'];
          parts.value = contentText.value.split('\n').map((e) => e.trim()).toList();
          ruleType.value = data['rule']['rule_type'];

          // selectSaveCoin();
          // ///如果本地选中的没有找到，再默认显示第一个
          // if(selCoinBean['interest_rate']==null){
          //   coinFun(coinLists[0]);
          // }
        },
        fail: (errorMessage) {
          viewState.value = PageState.FAILED;
          if (errorMessage != null) {
            coinLists.value = [];
          }
        },
        currencyId: coinId.value);
  }

  getSelCoin(CurrencyBean bean) {
    for (var item in interRestConfig) {
      if (item['currency_id'].toString() == bean.cur) {
        selCoinBean.value = item;
        // dynamic textObj = jsonDecode(item['content_text'] ?? {});
        // contentText.value = textObj['text'] ?? '';
        break;
      } else {
        selCoinBean['min_deposit'] = "-";
        selCoinBean['interest_rate'] = "";
      }
    }
  }

  ///获取年利率
  String getAnnualInterestRate(String rate) {
    if (rate.isEmpty) {
      return "-";
    }
    if (double.parse(rate) == 0) {
      return '0';
    } else {
      return "${removeTrailingZeros(double.parse(rate))}%";
    }
  }

  String getMinAnt(String amt) {
    if (amt.isEmpty) {
      return "-";
    }
    return amt;
  }

  ///去掉小数点后面的0
  String removeTrailingZeros(double number) {
    String result = number.toString();
    if (result.contains('.')) {
      result = result.replaceAll(RegExp(r"0*$"), "");
      result = result.replaceAll(RegExp(r"\.$"), "");
    }
    return result;
  }
}
