import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../../controllers/global_state_controller.dart';
import '../../../generated/l10n.dart';
import '../../../model/user.dart';
import '../../../model/wallet/CurrencyBean.dart';
import '../../../services/account_service.dart';
import '../../../services/api/api_service.dart';
import '../../../services/event/event_service.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/lang_util.dart';
import '../../../utils/sp_util.dart';
import '../../../widget/button/custom_button_controller.dart';
import '../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../../setup/password/logic.dart';
import 'model/coin_rate_model.dart';

const kVaultRefEvent = 'kVaultRefEvent';
final titleStyle = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

class VaultController extends BaseController with GetTickerProviderStateMixin, EventListener {
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final isDeposits = true.obs;
  BuildContext? context;
  final deposit = 1, takeout = 2;
  var selectAmount = "".obs;
  var defaultAmount = "".obs;
  var defaultOutputAmount = "".obs;
  var selectAmountCoinIc = "".obs;
  var takeoutSelectAmount = "".obs;
  var takeoutSelectAmountCoinIc = "".obs;

  // var selectCurrencyName = "".obs;
  var selectCurrencyId = 0.obs;

  // var takeoutSelectCurrencyName = "".obs;
  var takeoutSelectCurrencyId = 0.obs;
  var balanceLockerList = <CurrencyBean>[].obs;
  var isShowErrorHint = false.obs;
  var showErrorStr = "".obs;
  var takeoutInputAmount = "".obs;
  var takeoutInputPassword = "".obs;
  var takeoutAmountShowErrorHint = false.obs;
  var takeoutAmountShowErrorStr = "".obs;
  var takeoutPasswordShowErrorHint = false.obs;
  var takeoutPasswordShowErrorStr = "".obs;
  final coinIcDomain = '${AppValues.defaultBranch.asset_url}/currency/';
  final coinIcExtensionName = ".webp";
  final syl = "".obs;
  final IsCertified = true.obs;
  final _rates = <String, CoinRate>{}.obs;
  final interRestConfig = [].obs;

  // FocusNode focusNodeTakeoutAmount = FocusNode();
  // FocusNode focusNodeTakeoutPassword = FocusNode();
  late TextEditingController depositAmountController;
  late TextEditingController takeoutAmountController;
  final pwdTypeBean = {}.obs;
  final selCoinBean = {}.obs;
  final openVerificationAndPayPasswordFrequency = 0.obs;

  @override
  void onInit() {
    super.onInit();
    EventService.instance.addListener(kVaultRefEvent, this);

    ///监听设置成功了资金密码或者双重验证
    ever(globalController.isOpenVerificationAndPayPassword, (isOpenVerificationAndPayPassword) {
      if (isOpenVerificationAndPayPassword) {
        openVerificationAndPayPasswordFrequency.value++;
      }
    });

    ever(
        isDeposits,
        (callback) => {
              withdrawRateCount.value = 0.0,
              if (!isDeposits.value)
                {
                  takeoutAmountController = TextEditingController(),
                  syncRequestData(),
                  setDefaultOutputMoney(takeoutSelectAmount.value),
                  takeoutAmountShowErrorStr.value = "",
                  takeoutAmountShowErrorHint.value = false,
                  takeoutPasswordShowErrorStr.value = "",
                  takeoutPasswordShowErrorHint.value = false,
                  takeoutInputPassword.value = "",
                }
              else
                {
                  depositAmountController = TextEditingController(),
                  setDefaultMoney(selectAmount.value),
                  showErrorStr.value = "",
                  isShowErrorHint.value = false,
                }
            });
    depositAmountController = TextEditingController();
    takeoutAmountController = TextEditingController();
    // focusNodeTakeoutAmount.addListener(() {
    //   if (!focusNodeTakeoutAmount.hasFocus) {
    //     getErrorTakeoutStr(takeoutInputAmount.value);
    //   }
    // });
    // focusNodeTakeoutPassword.addListener(() {
    //   if (!focusNodeTakeoutPassword.hasFocus) {
    //     checkPasswordStr(takeoutInputPassword.value);
    //   }
    // });

    getExchangeRate();
    getIsSetupPassword();
    initData();
    syncRequestData();

    // ever(globalController.currTypeSelected, (callback) => {initData()});
  }

  @override
  void onClose() {
    // TODO: implement onClose
    EventService.instance.removeListener(kVaultRefEvent, this);
    Get.delete<ModifyPasswordLogic>();
    super.onClose();
  }

  @override
  void dispose() {
    depositAmountController.dispose();
    takeoutAmountController.dispose();

    super.dispose();
  }

  checkPasswordStr(String password) {
    if (password.isEmpty) {
      takeoutPasswordShowErrorHint.value = true;
      // takeoutPasswordShowErrorStr.value = S.current.binding_bank_card_please_enter + "${pwdTypeBean["title"]}";
      //https://jira.vgtech.org/browse/STAK-12221
      takeoutPasswordShowErrorStr.value = "${S.current.random_text_1173}6";
      return;
    } else {
      if (password.isNotEmpty && password.length < 6) {
        takeoutPasswordShowErrorHint.value = true;
        takeoutPasswordShowErrorStr.value = "${pwdTypeBean["title"]}" "格式错误";
        // takeoutPasswordShowErrorStr.value = S.current.random_text_1287;
        // takeoutPasswordShowErrorStr.value = S.current.random_text_599;
      } else {
        takeoutPasswordShowErrorHint.value = false;
        takeoutPasswordShowErrorStr.value = '';
      }
    }
  }

  bool getErrorStr(String amounts) {
    log("neco 输入的金额 $amounts");
    if (amounts.isEmpty) {
      isShowErrorHint.value = true;
      showErrorStr.value = S.current.wallet_pleaseEnterAmount;
      return false;
    }
    var amount = double.parse(amounts);
    if (amount <= 0) {
      isShowErrorHint.value = true;
      showErrorStr.value = S.current.vault_minimum_amount_limit_text("0");
      return false;
    } else if (amount > double.parse(selectAmount.value)) {
      isShowErrorHint.value = true;
      showErrorStr.value = S.current.vault_amountCannotExceedMaximum;
      return false;
    } else {
      return true;
    }
  }

  bool getErrorTakeoutStr(String amounts) {
    if (amounts.isEmpty) {
      takeoutAmountShowErrorHint.value = true;
      takeoutAmountShowErrorStr.value = S.current.wallet_pleaseEnterAmount;
      return false;
    } else {
      var amount = double.parse(amounts);
      if (amount <= 0) {
        takeoutAmountShowErrorHint.value = true;
        takeoutAmountShowErrorStr.value = S.current.vault_minimum_amount_limit_text("0");
        return false;
      } else if (amount > double.parse(takeoutSelectAmount.value)) {
        takeoutAmountShowErrorHint.value = true;
        takeoutAmountShowErrorStr.value = S.current.vault_amountCannotExceedMaximum;
        return false;
      } else {
        takeoutAmountShowErrorHint.value = false;
        takeoutAmountShowErrorStr.value = "";
        return true;
      }
    }
  }

  ///获取 汇率
  Future<void> getExchangeRate() async {
    await ApiService.instance.exchangeRateList<CoinRateApiModel>(
      success: (data) {
        _rates.addAll(data.rates);
      },
      fail: (message) {},
      converter: (json) {
        return CoinRateApiModel.fromJson(json);
      },
    );
  }

  double getCurrentCurrencyExchangeRate(String currencyKey) {
    for (var entry in _rates.entries) {
      var key = entry.key;
      var value = entry.value;
      if (key == currencyKey) {
        String field706s = value.field706 ?? "";
        if (field706s.isEmpty) {
          return double.parse("1");
        }
        if (field706s.isNotEmpty) {
          return double.parse(field706s);
        }
      }
    }
    return 0.0;
  }

  Future<void> balanceLocker(int flag, String amounts, CustomButtonController btnController,
      {String passWord = "", String selectAmountCoinIc = '', bool isDeposit = true}) async {
    if (flag == takeout) {
      checkPasswordStr(passWord);
      var errorTakeoutStr = getErrorTakeoutStr(amounts);
      if (errorTakeoutStr != true) {
        return;
      }
      if (passWord.isEmpty) {
        return;
      }
    } else {
      var errorStr = getErrorStr(amounts);
      if (errorStr != true) {
        return;
      }
      String min_deposit = selCoinBean['min_deposit'];
      String minDeposit = min_deposit.isEmpty ? "0" : min_deposit;
      if (double.parse(defaultAmount.value.isEmpty ? "0" : defaultAmount.value) <
          double.parse(minDeposit)) {
        CustomSnackBar.show(S.current.random_text_1286 + min_deposit, Get.context!,
            preIcon: CustomSnackBarIcons.error,
            title: S.current.vault_vaultDeposits,
            subTitleContent: CustomNetWorkImage(
              placeholder: const CustomAssetIcon(
                name: 'assets/images/personal_center_icon/currency_default_ic.webp',
              ),
              errorWidget: const CustomAssetIcon(
                name: 'assets/images/personal_center_icon/currency_default_ic.webp',
              ),
              width: 18,
              height: 18,
              imageUrl: this.selectAmountCoinIc.value,
            ));
        return;
      }
    }
    btnController.showAnimation();
    await ApiService.instance.balanceLocker<String>(
        success: (message) {
          withdrawRateCount.value = 0.0;
          defaultAmount.value = "";
          takeoutInputPassword.value = "";
          globalController.inquireBalance(flag: globalController.vault);
          syncRequestData();
          CustomSnackBar.show(
              subContent: Container(
                constraints: const BoxConstraints(minWidth: 120, maxWidth: 180),
                child: isDeposit
                    ? depositView(amounts, selectAmountCoinIc)
                    : takeoutView(amounts, selectAmountCoinIc),
              ),
              message,
              context!,
              title: flag == takeout ? S.current.vault_takeout : S.current.vault_vaultDeposits,
              preIcon: CustomSnackBarIcons.commissionSuccess);
        },
        fail: (message) {
          btnController.hideAnimation();
          CustomSnackBar.show("接口异常", context!,
              title: S.current.error_title_text, preIcon: CustomSnackBarIcons.error);
        },
        flag: flag,
        currencyId: flag == takeout ? takeoutSelectCurrencyId.value : selectCurrencyId.value,
        amount: amounts,
        password: passWord,
        authType: pwdTypeBean.isNotEmpty ? pwdTypeBean['authType'] : "");
    btnController.hideAnimation();
  }

  Widget depositView(String amounts, String selectAmountCoinIc) {
    return SizedBox(
      height: 40,
      //https://jira.vgtech.org/browse/STAK-11867
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CustomText(
            '${S.current.vault_successfullyStor}\t\t$amounts',
            style: ThemeService()
                .theme
                .textTheme
                .bodyMedium
                ?.copyWith(color: ThemeService().theme.colorScheme.onTertiary),
          ),
          const SizedBox(width: 6), // 用于增加文字和图片之间的间距
          CustomNetWorkImage(
            placeholder: const CustomAssetIcon(
              name: 'assets/images/personal_center_icon/currency_default_ic.webp',
            ),
            errorWidget: const CustomAssetIcon(
              name: 'assets/images/personal_center_icon/currency_default_ic.webp',
            ),
            imageUrl: selectAmountCoinIc,
            width: 14,
            height: 14,
          ),
          const SizedBox(width: 6),
          CustomText(
            S.current.vault_enteringVault,
            style: ThemeService()
                .theme
                .textTheme
                .bodyMedium
                ?.copyWith(color: ThemeService().theme.colorScheme.onTertiary),
          ),
        ],
      ),
    );
  }

  //https://jira.vgtech.org/browse/STAK-11867
  Widget takeoutView(String amounts, String selectAmountCoinIc) {
    return LangUtil().isViVn()
        ? _vivnLanguage(amounts, selectAmountCoinIc)
        : Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CustomText(
                S.current.vault_confirmedExtractionFromVault +
                    S.current.vault_confirmedExtractionFromVaultcopy2,
                style: ThemeService()
                    .theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: ThemeService().theme.colorScheme.onTertiary),
              ),
              CustomText(
                amounts,
                style: ThemeService()
                    .theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: ThemeService().theme.colorScheme.onTertiary),
              ),
              const SizedBox(width: 6), // 用于增加文字和图片之间的间距
              CustomNetWorkImage(
                placeholder: const CustomAssetIcon(
                  name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                ),
                errorWidget: const CustomAssetIcon(
                  name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                ),
                imageUrl: selectAmountCoinIc,
                width: 14,
                height: 14,
              ),
            ],
          );
  }

  static Widget _vivnLanguage(String amount, String selectAmountCoinIc) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: "Đã xác nhận rút",
          style: TextStyle(color: ThemeService().theme.colorScheme.onTertiary)),
      const WidgetSpan(
          child: SizedBox(
        width: 2,
      )),
      TextSpan(text: amount, style: TextStyle(color: ThemeService().theme.colorScheme.onTertiary)),
      const WidgetSpan(
          child: SizedBox(
        width: 2,
      )),
      WidgetSpan(
        child: Padding(
          padding: const EdgeInsets.all(0), // Adjust spacing as needed
          child: CustomNetWorkImage(
            placeholder: const CustomAssetIcon(
              name: 'assets/images/personal_center_icon/currency_default_ic.webp',
            ),
            errorWidget: const CustomAssetIcon(
              name: 'assets/images/personal_center_icon/currency_default_ic.webp',
            ),
            imageUrl: selectAmountCoinIc,
            width: 14,
            height: 14,
          ),
        ),
      ),
      const WidgetSpan(
          child: SizedBox(
        width: 2,
      )),
      TextSpan(
          text: "từ kho", style: TextStyle(color: ThemeService().theme.colorScheme.onTertiary)),
    ]));
  }

  Future<void> getInterestAllocations() async {
    //待优化
    await ApiService.instance.interestAllocation<dynamic>(
        success: (data) {
          log("neco 包下 ${selectCurrencyId.value}");
          // interRestConfig.assignAll(data);
          // log("neco  年利率 ${data.length}");
          // var list = json.decode(data['config']);
          //     for(var item in list){
          //       int currencyId = item['currency_id'];
          //       if(selectCurrencyId.value == currencyId){
          //         interRestConfig.value = item;
          //         break;
          //       }
          //     }
          var rateModel = data['rate'];
          selCoinBean['min_deposit'] = rateModel['min_deposit'];
          getSelCoin(rateModel['interest_rate']);
        },
        fail: (errorMessage) {
          if (errorMessage != null) {
            interRestConfig.value = [];
          }
        },
        currencyId: "${selectCurrencyId.value}");
  }

  getSelCoin(String intersetRate) {
    selCoinBean['interest_rate'] = intersetRate;
    // bool isSettingCoin = false;
    // for (var item in interRestConfig) {
    //   if (item['currency_id'] == cur) {
    //     isSettingCoin = true;
    //     selCoinBean.value = item;
    //     log("neco 利率 ${selCoinBean['interest_rate'] ?? "0"}");
    //     return;
    //   }
    // }
    // if (!isSettingCoin) {
    //   selCoinBean.value = {};
    // }
  }

  Future<List<CurrencyBean>> balanceLockerShow() async {
    Completer<List<CurrencyBean>> completer = Completer();
    await ApiService.instance.balanceLockerShow<String>(success: (list) {
      completer.complete(list);
    }, fail: (errorMessage) {
      if (errorMessage != null) {
        completer.completeError(errorMessage);
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
      },
    );
    return completer.future;
  }

  Future<void> syncRequestData() async {
    List<CurrencyBean> balanceData = await balanceLockerShow();
    List<CurrencyBean> currencyConfigs = await currencyConfig();
    mergeData(balanceData, currencyConfigs);
  }

  void mergeData(List<CurrencyBean> balanceData, List<CurrencyBean> currencyConfigs) {
    balanceLockerList.clear();
    var list = <CurrencyBean>[];
    for (var balance in balanceData) {
      for (var currencyCon in currencyConfigs) {
        if (balance.name == currencyCon.name) {
          list.add(CurrencyBean(
              coinIc: "$coinIcDomain${currencyCon.cur}$coinIcExtensionName",
              name: balance.name,
              amount: (balance.amount ?? "").isEmpty ? "0.00" : balance.amount,
              cur: currencyCon.cur,
              symbol: currencyCon.symbol));
        }
      }
    }

    var cur = currTypeSelecteds.value.cur;
    log("neco 哈哈哈$cur");
    for (var item in list) {
      if (item.cur == cur) {
        balanceLockerList.insert(0, item);
      } else {
        balanceLockerList.add(item);
      }
    }

    if (!isDeposits.value) {
      if (balanceLockerList.isNotEmpty) {
        takeoutFun(balanceLockerList[0]);
      }
    }
  }

  //初始化
  initData() {
    if (SPUtil().getCurrencyBean() == null) {
      depositFun(globalController.currTypeLists[0]);
      saveSelected(globalController.currTypeLists[0]);
    } else {
      depositFun(globalController.currTypeSelected.value);
      saveSelected(globalController.currTypeSelected.value);
    }
  }

  depositFun(CurrencyBean bean) {
    selectAmount.value = bean.amount ?? "";
    setDefaultMoney(selectAmount.value);
    selectAmountCoinIc.value = bean.coinIc ?? "";
    // selectCurrencyName.value = bean.name ?? "";
    selectCurrencyId.value = int.parse(bean.cur ?? "0");
    syl.value = bean.symbol ?? "";
    withdrawRateCount.value = 0.0;
    showErrorStr.value = "";
    isShowErrorHint.value = false;
    // getSelCoin(selectCurrencyId.value);
    getInterestAllocations();
  }

  takeoutFun(CurrencyBean bean) {
    takeoutSelectAmount.value = bean.amount ?? "";
    setDefaultOutputMoney(takeoutSelectAmount.value);
    takeoutSelectAmountCoinIc.value = bean.coinIc ?? "";
    // takeoutInputAmount.value = bean.amount ?? "";
    // takeoutSelectCurrencyName.value = bean.name ?? "";
    takeoutSelectCurrencyId.value = int.parse(bean.cur ?? "0");
    syl.value = bean.symbol ?? "";
    withdrawRateCount.value = 0.0;
    takeoutAmountShowErrorHint.value = false;
  }

  String truncateText(String str, int maxLength) {
    if (str.isEmpty) {
      return "";
    }
    if (str.length > maxLength) {
      return '${str.substring(0, maxLength)}...';
    }
    return str;
  }

  String setDefaultMoney(String oldMoney) {
    var split = oldMoney.split('.');
    defaultAmount.value = '0.';
    if (split.length == 2) {
      for (int i = 0; i < split[1].length; i++) {
        defaultAmount.value += '0';
      }
    } else {
      // 处理 split 不包含两个元素的情况，可能是没有小数部分
      defaultAmount.value = oldMoney;
    }
    return defaultAmount.value;
  }

  String setDefaultOutputMoney(String oldMoney) {
    var split = oldMoney.split('.');
    defaultOutputAmount.value = '0.';
    if (split.length == 2) {
      for (int i = 0; i < split[1].length; i++) {
        defaultOutputAmount.value += '0';
      }
    } else {
      // 处理 split 不包含两个元素的情况，可能是没有小数部分
      // 在这里你可以根据需要进行处理，比如直接结束或设置默认值等
      defaultOutputAmount.value = oldMoney;
    }

    return defaultOutputAmount.value;
  }

  void getIsSetupPassword() {
    // User? currentUser = AccountService.sharedInstance.currentUser;
    // if (currentUser != null) {
    //   var googleVerify = currentUser.googleVerify;
    //   if (googleVerify != 2) {
    //     IsCertified.value = true;
    //   } else {
    //     IsCertified.value = false;
    //   }
    // } else {
    //   IsCertified.value = false;
    // }

    //获取用户信息
    AccountService.sharedInstance.refreshUserInfo();
    //获取后端品牌设置，是否开启资金密码和双重验证
    globalController.getBrandBaseInfo();
    //获取用户使用双重验证和资金密码
    globalController.getPassWordConfig();
  }

  bool setFundPassword() {
    User? currentUser = AccountService.sharedInstance.currentUser;
    if (currentUser != null) {
      var payPassword = currentUser.payPassword;
      if (payPassword == "1") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  ref() {
    var currTypeLists = globalController.currTypeLists;
    for (int i = 0; i < currTypeLists.length; i++) {
      if (currTypeLists[i].name == currTypeSelecteds.value.name) {
        if (currTypeLists[i].amount != currTypeSelecteds.value.amount) {
          log("neco 当前币种额度${currTypeLists[i].amount}");
          depositFun(currTypeLists[i]);
          // takeoutFun(null);
          saveSelected(currTypeLists[i]);
        }
        break;
      }
    }
  }

  //=========================汇率换算 方法=========================
  final withdrawRateCount = 0.0.obs; //存款汇率显示
  ///保险库-提款-汇率计算 flag =1 存 flag =2 取
  withdrawExchangeRateCount(String money, int flag) {
    if (money.isNotEmpty) {
      double inputMoney = double.parse(money);
      if (inputMoney != 0) {
        withdrawRateCount.value = inputMoney *
            getCurrentCurrencyExchangeRate(flag == 1
                ? selectCurrencyId.value.toString()
                : takeoutSelectCurrencyId.value.toString());
      } else {
        withdrawRateCount.value = 0.0;
      }
    } else {
      withdrawRateCount.value = 0.0;
    }
  }

  //=========================下拉框 货币搜索 方法=========================
  //选中的的item model -- 存款的
  final currTypeSelecteds = CurrencyBean().obs;

  ///临时保存选中的币种
  void saveSelected(CurrencyBean bean) {
    currTypeSelecteds.value = bean;
    // globalController.currTypeSelected.value = bean;
    // SPUtil().saveCurrencyBean(bean);
  }

  ///判断是否是选中的币种 item
  bool isSelectedItem(CurrencyBean bean) {
    return bean.cur == currTypeSelecteds.value.cur;
  }

  // ///判断是否是选中密码验证类型
  // int selectedPawTypse() {
  //   return int.parse(pwdTypeBean['authType']??'2');
  // }

  ///获取年利率
  String getAnnualInterestRate(double rate) {
    if (rate == 0) {
      return '0';
    } else {
      return removeTrailingZeros(rate);
    }
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

  @override
  void onEvent(String eventId, event) {
    if (eventId == kVaultRefEvent) {
      ref();
    }
  }

  BoxDecoration getBoxDecoration(bool showErr) {
    return BoxDecoration(
      color: ThemeService().colorScheme.surface,
      // borderRadius: const BorderRadius.only(
      //   topLeft: Radius.circular(AppValues.smallRadius),
      //   bottomLeft: Radius.circular(AppValues.smallRadius),
      // ),
      border: Border(
        left: BorderSide(
          width: 2, //宽度
          color: showErr
              ? ThemeService().colorScheme.error
              : ThemeService().colorScheme.tertiary, //边框颜色
        ),
        right: BorderSide(
          width: 2, //宽度
          color: showErr ? ThemeService().colorScheme.error : Colors.transparent, //边框颜色
        ),
        top: BorderSide(
          width: 2, //宽度
          color: showErr
              ? ThemeService().colorScheme.error
              : ThemeService().colorScheme.tertiary, //边框颜色
        ),
        bottom: BorderSide(
          width: 2, //宽度
          color: showErr
              ? ThemeService().colorScheme.error
              : ThemeService().colorScheme.tertiary, //边框颜色
        ),
      ),
    );
  }
}
