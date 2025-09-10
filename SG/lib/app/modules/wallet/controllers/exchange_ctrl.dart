import 'dart:developer';

import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:get/get.dart';

import '../../../../constant/app_cache_key.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../pages/personal_center/vault/model/coin_rate_model.dart';
import '../../../../services/account_service.dart';
import '../../../../services/api/api_service.dart';
import '../../../../utils/money_util.dart';
import '../../../../utils/num_util.dart';
import '../../../../utils/sp_util.dart';
import '../../../../utils/time/time_utils.dart';
import '../../../../widget/button/custom_button_controller.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';
import 'comm_ctrl.dart';

class ExchangeCtrl extends GetxController with CommonCtrl {
  final currentCurrencyAmountShowError = false.obs;
  final currentCurrencyAmountShowErrorText = "".obs;

  final availableAmountList = <CurrencyBean>[].obs; //可用币
  final allAmountList = <CurrencyBean>[].obs; //全币
  final ScrollController exchangeCurrscrollController = ScrollController(initialScrollOffset: 0.0);
  final searchAvailableAmountList = <CurrencyBean>[].obs;
  final searchAllAmountList = <CurrencyBean>[].obs;
  final currentCurrencyBean = CurrencyBean().obs;
  final exChangeCurrencyBean = CurrencyBean().obs;
  final exChangeCurrencyText = "".obs; //兑换货币
  final currentCurrencyText = "".obs; //以xx支付

  // 选中的的item model -- 存款的
  final currTypeSelected = CurrencyBean().obs;

  /// 兑换货币 数据
  final currExchangeTypeSelected = CurrencyBean().obs;

  ///支付货币
  final currPayTypeSelected = CurrencyBean().obs;

  TextEditingController? exChangeCurrencyTextController;
  TextEditingController? currentCurrencyTextController;

  final countdownTime = 0.obs;
  final expireAt = 0.obs; // 到期时间
  Timer? countdownTimer;

  final exchangeRate = 0.0.obs;
  var availability = true;

  @override
  void onInit() {
    super.onInit();
    initData();

    ever(globalController.balanceList, (callback) => {});
  }

  initData() {
    //https://jira.vgtech.org/browse/STAK-12694
    availableAmountList.value =
        globalController.currTypeLists.where((bean) => bean.currency_type == 1).toList();
    // availableAmountList.value = globalController.currTypeLists.where((bean) => double.parse(bean.amount ?? "0") > 0).toList();
    allAmountList.value =
        globalController.currTypeLists.where((p0) => p0.currency_type != 1).toList();
    // allAmountList.value = globalController.currTypeInitialLists;
    if (availableAmountList.length == 1 && availableAmountList[0].cur == "706") {
      allAmountList[0].isSelected = true;
      exchangeCurrFun(allAmountList[0]);
    } else {
      for (int i = 0; i < allAmountList.length; i++) {
        if (allAmountList[i].cur == "706") {
          allAmountList[i].isSelected = true;
          exchangeCurrFun(allAmountList[i]);
          break;
        }
      }
    }
    if (availableAmountList.isEmpty) {
      availability = false;
      availableAmountList.value = globalController.currTypeLists;
    }
    payCurrFun(globalController.currTypeSelected.value);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    if (expireAt.value > 0) {
      _saveCountdownTime();
    }
    countdownTimer?.cancel();
    currentCurrencyTextController?.dispose();
    exChangeCurrencyTextController?.dispose();
  }

  ///支付货币是否被选中
  bool isPaySelectedItem(CurrencyBean bean) {
    return bean.cur == currPayTypeSelected.value.cur;
  }

  ///兑换货币是否被选中
  bool isExchangeSelectedItem(CurrencyBean bean) {
    return bean.cur == currExchangeTypeSelected.value.cur;
  }

  ///选中支付货币
  void savePaySelected(CurrencyBean bean) {
    currPayTypeSelected.value = bean;
  }

  ///选中兑换货币
  void saveExchangeSelected(CurrencyBean bean) {
    currExchangeTypeSelected.value = bean;
  }

  //支付货币
  payCurrFun(CurrencyBean currencyBean) {
    if (double.parse(currencyBean.amount ?? "0") <= 0 && availability) {
      currencyBean = availableAmountList[0]; //特殊情况
      currentCurrencyBean.value = availableAmountList[0];
      savePaySelected(availableAmountList[0]);
    } else {
      currentCurrencyBean.value = currencyBean;
      savePaySelected(currencyBean);
    }
    if (currencyBean.cur == currExchangeTypeSelected.value.cur) {
      for (int i = 0; i < allAmountList.length; i++) {
        if (currencyBean.cur == allAmountList[i].cur) {
          saveExchangeSelected(allAmountList[allAmountList.length == 1
              ? i
              : i == allAmountList.length - 1
                  ? i - 1
                  : i + 1]);
          exChangeCurrencyBean.value = allAmountList[allAmountList.length == 1
              ? i
              : i == allAmountList.length - 1
                  ? i - 1
                  : i + 1];
          break;
        }
      }
    }

    currentCurrencyText.value = currentCurrencyBean.value.amount ?? "";
    exchangeRate.value = getSingleCurrentCurrencyExchangeRate(
        (currentCurrencyBean.value.cur ?? "").isEmpty
            ? globalController.currTypeSelected.value.cur ?? ""
            : currentCurrencyBean.value.cur ?? "",
        (exChangeCurrencyBean.value.cur ?? "").isEmpty
            ? globalController.currTypeSelected.value.cur ?? ""
            : exChangeCurrencyBean.value.cur ?? "");
    convertCurrency(
        double.parse(currentCurrencyText.value.isEmpty ? "0.0" : currentCurrencyText.value));
  }

  double getSingleCurrentCurrencyExchangeRate(String parentCurrencyKey, String currencyKey) {
    if (globalController.rateList.isNotEmpty) {
      if (parentCurrencyKey == currencyKey) {
        return 1;
      }
      CoinRate coinRate = globalController.rateList[parentCurrencyKey] ?? CoinRate();
      return double.parse(coinRate.toJson()[currencyKey] ?? "0");
    }
    globalController.getExchangeRate();
    return 0;
  }

  // 兑换货币方法 当前货币金额
  void convertCurrency(double amount) {
    // exChangeCurrencyText.value = "${amount * exchangeRate.value}";
    exChangeCurrencyTextController?.text = exChangeCurrencyText.value;
    exChangeCurrencyText.value = NumUtil.keepDecimals(amount * exchangeRate.value,
        digits: exChangeCurrencyBean.value.currency_type == 2 ? 8 : 2);
    // exChangeCurrencyTextController?.selection = TextSelection.fromPosition(TextPosition(offset:exChangeCurrencyText.value.length),);
  }

  // 计算金额 输入兑换后的货币数量
  void calculateAmount(double convertedAmount) {
    double amountRequired = convertedAmount / exchangeRate.value; //所需金额
    String exchangeCurrencyAmount = getExchangeCurrencyAmount(); //全部余额
    double maxCurCurrAmount =
        double.parse(exchangeCurrencyAmount.isEmpty ? "0.0" : exchangeCurrencyAmount);
    if (amountRequired > maxCurCurrAmount) {
      // currentCurrencyText.value = "${maxCurCurrAmount / exchangeRate.value}";
      convertCurrency(maxCurCurrAmount);
    } else {
      // currentCurrencyText.value = "${convertedAmount / exchangeRate.value}";
      currentCurrencyText.value = NumUtil.keepDecimals(convertedAmount / exchangeRate.value,
          digits: currentCurrencyBean.value.currency_type == 2 ? 8 : 2);
    }
  }

  //兑换货币
  exchangeCurrFun(CurrencyBean currencyBean) {
    exChangeCurrencyBean.value = currencyBean;
    if (currencyBean.cur == currPayTypeSelected.value.cur) {
      for (int i = 0; i < availableAmountList.length; i++) {
        if (currencyBean.cur == availableAmountList[i].cur) {
          log("neco 可用币种 ${availableAmountList.length}");
          savePaySelected(availableAmountList[availableAmountList.length == 1
              ? i
              : i == availableAmountList.length - 1
                  ? i - 1
                  : i + 1]);
          currentCurrencyBean.value = availableAmountList[availableAmountList.length == 1
              ? i
              : i == availableAmountList.length - 1
                  ? i - 1
                  : i + 1];
          //https://jira.vgtech.org/browse/STAK-3520
          currentCurrencyText.value = getExchangeCurrencyAmount();
          break;
        }
      }
    }
    saveExchangeSelected(currencyBean);
    exchangeRate.value = getSingleCurrentCurrencyExchangeRate(
        (currentCurrencyBean.value.cur ?? "").isEmpty
            ? globalController.currTypeSelected.value.cur ?? ""
            : currentCurrencyBean.value.cur ?? "",
        (exChangeCurrencyBean.value.cur ?? "").isEmpty
            ? globalController.currTypeSelected.value.cur ?? ""
            : exChangeCurrencyBean.value.cur ?? "");
    // calculateAmount(
    //     double.parse(exChangeCurrencyText.value.isEmpty ? "0.0" : exChangeCurrencyText.value));
    convertCurrency(
        double.parse(currentCurrencyText.value.isEmpty ? "0.0" : currentCurrencyText.value));
  }

  void updateSearchAvailableAmountList(String value) {
    if (value.isNotEmpty) {
      var tempList = availableAmountList
          .where((element) => element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      searchAvailableAmountList.assignAll(tempList);
    } else {
      searchAvailableAmountList.assignAll(availableAmountList);
    }
    searchAvailableAmountList.refresh();
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

  ///当关闭窗口或者 打开时，还原原来的数据源
  void resetSearchList(int flag) {
    log("neco 换元： $flag -- ${availableAmountList.length}  ---  全部${allAmountList.length}");
    if (flag == 1) {
      // final temp = <CurrencyBean>[].obs;
      // for (var all in allAmountList) {
      //   for (var value in availableAmountList) {
      //     if (value.cur == all.cur) {
      //       value.amount = all.amount;
      //       temp.add(value);
      //     }
      //   }
      // }
      // searchAvailableAmountList.addAll(temp);
      searchAvailableAmountList.assignAll(availableAmountList);
      // searchAvailableAmountList.assignAll(availableAmountList);
    } else {
      searchAllAmountList.assignAll(allAmountList);
    }
  }

  String exchangeStr(String data) {
    String result = "";
    String cur = exChangeCurrencyBean.value.cur ?? "0.0";
    double amt = double.parse(data);

    if (data.isEmpty || amt <= 0) {
      return result = "0.00";
    }
    result = "${MoneyUtil.toCoinAmountFormat(cur, data)}";
    return result;
  }

  ///获取兑换货币余额最大值的整数
  String getExchangeCurrencyAmount() {
    String amount = currentCurrencyBean.value.amount ?? "";
    // if (amount.contains('.')) {
    //   return amount.split('.')[0];
    // }
    return amount;
  }

  checkCurrentCurrencyTextAmount() {
    if (currentCurrencyText.value.isEmpty) {
      currentCurrencyAmountShowError.value = true;
      currentCurrencyAmountShowErrorText.value = S.current.wallet_pleaseEnterAmount;
      return;
    }
    double inputAmounts = double.parse(currentCurrencyText.value);
    if (inputAmounts <= 0) {
      currentCurrencyAmountShowError.value = true;
      currentCurrencyAmountShowErrorText.value = S.current.wallet_amountCannotBe("0");
    } else {
      currentCurrencyAmountShowError.value = false;
      currentCurrencyAmountShowErrorText.value = "";
    }
  }

  Future<void> balanceTransfer(
    BuildContext context,
    CustomButtonController btnCtr,
  ) async {
    checkCurrentCurrencyTextAmount();
    btnCtr.showAnimation();
    await ApiService.instance.balanceTransfer<String>(
      success: (str) async {
        hideKeyboard(context);

        CustomSnackBar.show(S.current.random_text_824, context,
            title: S.current.random_text_650, preIcon: CustomSnackBarIcons.verifySucceed);
        balanceTransferLock(context, btnCtr);
        //https://jira.vgtech.org/browse/STAK-11591
        await Future.delayed(const Duration(seconds: 1));
        initData();
      },
      fail: (errorMessage) {
        btnCtr.hideAnimation();
        if (errorMessage != null) {
          CustomSnackBar.show(errorMessage, context,
              title: S.current.random_text_650, preIcon: CustomSnackBarIcons.error);
        }
      },
      currencyOut: currentCurrencyBean.value.cur ?? "",
      amount: currentCurrencyText.value,
      currencyIn: exChangeCurrencyBean.value.cur ?? "",
    );
    btnCtr.hideAnimation();
  }

  Future<void> balanceTransferLock(
    BuildContext context,
    CustomButtonController btnCtr,
  ) async {
    checkCurrentCurrencyTextAmount();
    await ApiService.instance.balanceTransferLock<int>(
      success: (expireTime) {
        countdownTime.value = (int.parse(expireTime) - TimeUtils.getTimeStampTenDigits()) - 1;
        _startTime();
        expireAt.value = int.parse(expireTime);
      },
      fail: (errorMessage) {
        btnCtr.hideAnimation();
        if (errorMessage != null) {
          CustomSnackBar.show(errorMessage, context, preIcon: CustomSnackBarIcons.error);
        }
      },
    );
  }

  Future<void> _saveCountdownTime() async {
    SPUtil().setInt(
        "${CacheKey.expireAt}${AccountService.sharedInstance.currentUser?.uid}", expireAt.value);
  }

  Future<void> _startTime() async {
    if (countdownTime.value == 0) {
      return;
    }
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (countdownTime.value == 0) {
        timer.cancel();
      } else {
        countdownTime.value--;
      }
    });
  }

  String formatBalance(double balance) {
    log("neco 汇率换算$balance");
    // 保留小数点后9位
    String formattedBalance = balance.toStringAsFixed(9);

    // 去除小数点后的多余0
    formattedBalance = formattedBalance.replaceAll(RegExp(r'0*$'), '');

    // 去除末尾的小数点
    formattedBalance = formattedBalance.replaceAll(RegExp(r'\.$'), '');

    return formattedBalance;
  }
}
