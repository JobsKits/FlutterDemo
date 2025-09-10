import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../services/api/api_service.dart';
import '../../../../widget/button/custom_button_controller.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';

class CommissionWalletController extends GetxController {
  //TODO: Implement CommissionWalletController
  final coinIcDomain = '${AppValues.defaultBranch.asset_url}/currency/';
  final coinIcExtensionName = ".webp";
  final count = 0.obs;

  final coinData = [].obs ;
  // final totalAmount = 0.0.obs;
  @override
  void onInit() {
    super.onInit();
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

  Future<List<CurrencyBean>> balance() async {
    Completer<List<CurrencyBean>> completer = Completer<List<CurrencyBean>>();
    await ApiService.instance.getBalance(
        success: (balanceBean) {
          var json = balanceBean.toJson();
          List<CurrencyBean> list = [];
          List<MapEntry<String, dynamic>> keyValuePairs = json.entries.toList();
          for (int i = 0; i < keyValuePairs.length; i++) {
            var key = keyValuePairs[i].key;
            String value = keyValuePairs[i].value ?? "";
            if (!key.contains("uid")) {
              if(value.isNotEmpty){
                list.add(CurrencyBean(name: keyValuePairs[i].key, amount: keyValuePairs[i].value));
              }
            }
          }
          completer.complete(list);
        },
        fail: (errorMessage) {
          if (errorMessage != null) {
            completer.completeError(errorMessage ?? "");

          }
        });
    return completer.future;
  }


  Future<List<CurrencyBean>> balanceAgency() async {
    Completer<List<CurrencyBean>> completer = Completer<List<CurrencyBean>>();
    await ApiService.instance.balanceAgency(
        success: (list) {
          completer.complete(list);
        },
        fail: (errorMessage) {
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
    log("neco syncRequestData ");
    List<CurrencyBean> userBalanceList = await balance();
    List<CurrencyBean> balanceData = await balanceAgency();
    List<CurrencyBean> currencyConfigs = await currencyConfig();
    mergeData(userBalanceList,balanceData, currencyConfigs);
  }

  void mergeData(List<CurrencyBean> userBalanceList,List<CurrencyBean> balanceData, List<CurrencyBean> currencyConfigs) {
    var list = <CurrencyBean>[];
    for (var balance in balanceData) {
      for (var config in currencyConfigs) {
        for (var userBalance in userBalanceList) {
          if (balance.name == config.name && userBalance.name == balance.name) {
            list.add(CurrencyBean(
                uid: userBalance.amount,  // uid 作为用户金额使用
                coinIc: "$coinIcDomain${config.cur}$coinIcExtensionName",
                name: balance.name,
                amount: (balance.amount ?? "").isEmpty ? "0.00" : balance.amount,
                cur: config.cur,
                symbol: config.symbol,
                currency_type: config.currency_type,
            ));
          }
        }
      }
    }
    //todo:0117.法币显示在前面，虚拟货币显示在后面
    //排序处理：currency_type 1:法币， 2：加密货币
    list.sort((a, b) => a.currency_type!.compareTo(b.currency_type!));
    coinData.assignAll(list);
  }

  Future<void> withdrawalCommission(
      BuildContext context,
      CustomButtonController btnCtr,) async {
    btnCtr.showAnimation();
    ApiService.instance.withdrawalCommission<CurrencyBean>(
        success: (list) {
          CustomSnackBar.show(
              S.current.random_text_756,
              context,
              title: S.current.random_text_757,
              preIcon: CustomSnackBarIcons.commissionSuccess);
          syncRequestData();
        },
        fail: (errorMessage) {
          if (errorMessage != null) {
            CustomSnackBar.show(errorMessage, context, preIcon: CustomSnackBarIcons.error);
          }
          btnCtr.hideAnimation();
        },
        context: context);
    btnCtr.hideAnimation();
  }
}
