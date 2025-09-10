import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:get/get.dart';

import '../../../../controllers/global_state_controller.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../pages/personal_center/vault/model/coin_rate_model.dart';
import '../../../../services/api/api_service.dart';
import '../../../../utils/sp_util.dart';
import '../../../../widget/button/custom_button_controller.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';

class CommissionConversionController extends GetxController {

  final GlobalStateController globalController = Get.find<GlobalStateController>();

  final modelList = <CurrencyBean>[].obs;
  final coinIcDomain = '${AppValues.defaultBranch.asset_url}/currency/';
  final coinIcExtensionName = ".webp";
  final _rates = <String, CoinRate>{}.obs;

  final coinName="".obs;
  final coinIc="".obs;
  final coinId="".obs;
  final totalAmount = 0.0.obs;
  final rateData = <CoinRate>{}.obs;
  @override
  void onInit() {
    super.onInit();
    initData();
  }

  @override
  void onReady() {
    super.onReady();
    syncRequestData();
  }

  @override
  void onClose() {
    super.onClose();
  }
  initData() {
    if (SPUtil().getCurrencyBean() == null) {
      coinFun(globalController.currTypeLists[0]);
      saveSelected(globalController.currTypeLists[0]);
    } else {
      coinFun(globalController.currTypeSelected.value);
      saveSelected(globalController.currTypeSelected.value);
    }
  }
  coinFun(CurrencyBean bean,{int flag = 0}) {
    coinName.value = bean.name ?? "";
    coinIc.value = bean.coinIc ?? "";
    coinId.value = bean.cur ?? "";
    if(flag==1){
      getCurrentCurrencyExchangeRate(coinId.value);
      getSingleCurrentCurrencyExchangeRate(coinId.value);
    }
  }

  //选中的的item model --
  final currTypeSelected = CurrencyBean().obs;

  ///临时保存选中的币种
  void saveSelected(CurrencyBean bean) {
    currTypeSelected.value = bean;
  }

  ///判断是否是选中的币种 item
  bool isSelectedItem(CurrencyBean bean) {
    return bean.cur == currTypeSelected.value.cur;
  }

  ///获取 汇率
  Future<CoinRateApiModel> getExchangeRate() async {
    Completer<CoinRateApiModel> completer = Completer<CoinRateApiModel>();

    await ApiService.instance.exchangeRateList<CoinRateApiModel>(
      success: (data) {
        _rates.addAll(data.rates);
        completer.complete(data);
      },
      fail: (message) {},
      converter: (json) {
        return CoinRateApiModel.fromJson(json);
      },
    );
    return completer.future;
  }

  Future<void> agencyExchange(CustomButtonController btnCtr,BuildContext context) async {
    btnCtr.showAnimation();
    await ApiService.instance.agencyExchange(success: (msg) {
      CustomSnackBar.show(msg, context, preIcon: CustomSnackBarIcons.verifySucceed);

    }, fail: (errorMessage) {
      if (errorMessage != null) {
        CustomSnackBar.showError(errorMessage, context);

      }
    }, curId: coinId.value);
    btnCtr.hideAnimation();

  }

  Future<List<CurrencyBean>> balanceAgency() async {
    Completer<List<CurrencyBean>> completer = Completer<List<CurrencyBean>>();

    await ApiService.instance.balanceAgency(success: (list) {
      completer.complete(list);
    }, fail: (errorMessage) {
      if (errorMessage != null) {
        completer.completeError(errorMessage ?? "");
      }
    });
    return completer.future;
  }
  //货币信息
  Future<List<CurrencyBean>> currencyConfig() {
    Completer<List<CurrencyBean>> completer = Completer<List<CurrencyBean>>();
    ApiService.instance.currencyConfig<CurrencyBean>(
        success: (list) {
          completer.complete(list);
        },
        fail: (errorMessage) {
          completer.completeError(errorMessage ?? "");
        },);
    return completer.future;
  }

  Future<void> syncRequestData() async {
    List<CurrencyBean> balanceData = await balanceAgency();
    List<CurrencyBean> currencyConfigs = await currencyConfig();
    CoinRateApiModel coinRateApiModel = await getExchangeRate();
    mergeData(balanceData, currencyConfigs, coinRateApiModel);
  }

  void mergeData(List<CurrencyBean> balanceData, List<CurrencyBean> currencyConfigs,
      CoinRateApiModel coinRateApiModel) {
    var list = <CurrencyBean>[];
    for (int i = 0; i < balanceData.length; i++) {
      totalAmount.value+=double.parse(balanceData[i].amount??"0");
      for (int j = 0; j < currencyConfigs.length; j++) {
        if (balanceData[i].name == currencyConfigs[j].name) {
          list.add(CurrencyBean(
              coinIc: "$coinIcDomain${currencyConfigs[j].cur}$coinIcExtensionName",
              name: balanceData[i].name,
              amount: (balanceData[i].amount ?? "").isEmpty ? "0.00" : balanceData[i].amount,
              cur: currencyConfigs[j].cur,
              symbol: currencyConfigs[j].symbol,));
        }
      }
    }
    modelList.addAll(list);
    getCurrentCurrencyExchangeRate(coinId.value);
    getSingleCurrentCurrencyExchangeRate(coinId.value);
  }


  getCurrentCurrencyExchangeRate(String currencyKey) {
    // Map中的值转换为指定数据格式
    List<Map<String, dynamic>> resultList = [];
    for (var entry in _rates.entries) {
      var key = entry.key;
      if (key == currencyKey) {
        if(key == "706"){
          rateData.add(entry.value);
        }
        CoinRate coinRate = entry.value;
        // 转换为json
        String coinRateJson = json.encode(coinRate.toJson());
        // 解析json字符串为map
        Map<String, dynamic>? valuesMap = json.decode(coinRateJson);
        // 是否解析成功
        if (valuesMap != null) {
          valuesMap.forEach((key, value) {
            value ??= '1';
            resultList.add({'cur': key, 'rate': value});
          });
        }
      }
    }
    for(int i =0 ;i<modelList.length;i++){
      for(int j=0;j<resultList.length;j++){
          String cur = modelList[i].cur??"";
          String resultCur = resultList[j]['cur'];
          if(cur == resultCur){
            modelList[i].uid = resultList[j]['rate']; //这里uid字段角色为汇率 仅次一处
          }
      }
    }
    modelList.refresh();
  }


  double getSingleCurrentCurrencyExchangeRate(String currencyKey) {
    CoinRate coinRate = _rates["706"]!;
    return currencyKey=="706"?1:double.parse(coinRate.toJson()[currencyKey]);
  }
}
