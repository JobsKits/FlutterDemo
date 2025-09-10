import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:flutter_bet/app/modules/wallet/views/pwd_view.dart';
import 'package:flutter_bet/model/wallet/TypeBean.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:flutter_bet/services/event/event_service.dart';
import 'package:flutter_bet/utils/num_util.dart';
import 'package:get/get.dart';

import '../../../../base/getx/page_state.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/wallet/BankcardBean.dart';
import '../../../../model/wallet/CoinBean.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../model/wallet/WithdrawnBalanceBean.dart';
import '../../../../pages/account/bind_controller.dart';
import '../../../../pages/personal_center/wallet/a_model/wallet_common_params.dart';
import '../../../../pages/personal_center/wallet/widget/custom_card_banding_dialog.dart';
import '../../../../services/api/api_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_button_controller.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../views/dialogs_view.dart';
import 'comm_ctrl.dart';

const kBnkRefEvent = 'kBnkRefEvent';
const kAddressRefEvent = 'kAddressRefEvent';

class WithDrawCtrl extends GetxController with CommonCtrl, EventListener, WidgetsBindingObserver {
  final xrp = "720";

  final eos = "721";

  final page = 1;
  final pageSize = 20;
  late WalletCtrl walletCtrl = Get.find<WalletCtrl>();
  final ifBindCard = false.obs;
  final wdBnkList = <BankcardBean>[].obs;
  RxList<Map<String, dynamic>> result = RxList<Map<String, dynamic>>([]);
  final bnkPos = 0.obs;
  final bnkNameBean = {}.obs;

  final bnkCurrCards = 0.obs;
  final bnkSelBean = BankcardBean().obs;
  final curSelBnkShowErr = false.obs;
  final curSelBnkAccountShowErr = false.obs;

  final ifBindAddress = false.obs;

  final wdAdrList = <CoinBean>[].obs;
  final wdArdSelBean = CoinBean().obs;
  final curSelAdrShowErr = false.obs;

  final double bubbleCoinWidth = 180;

  final currDepSelCtr = [].obs;
  final currDepSelCtrStr = "def".obs;
  final currSelContractId = "".obs;

  final wdMethod = false.obs;

  final inAmtShowEr = false.obs;
  final inAmt = "".obs;
  final inAmtShowErrStr = "".obs;

  final inPwShowErr = false.obs;
  var inPwd = "".obs;
  final inPwShowErrStr = "".obs;

  final wdAmtMix = "0".obs;
  final usableBal = "".obs;
  final remainingBal = "".obs;

  final pwTypeBean = {}.obs;

  late TextEditingController inAmtCtrl;

  var methodId = "";

  final memo = "".obs;
  final memoShowEr = false.obs;
  final memoShowErrStr = "".obs;

  final viewState = PageState.LOADING.obs;

  final wdFiatCurrState = false.obs;
  final wdCryptoCurrState = false.obs;

  final feeInfo = {}.obs;

  final wdAmtMixList = [].obs;

  final payoutOptions = <TypeBean>[].obs;
  final payoutOptionBean = TypeBean().obs;

  bool _showWdModal = true;

  var bnk;
  var aliPay;
  var wallet;
  double previousBottomInset = 0.0;

  @override
  void onInit() {
    super.onInit();

    ever(
        wdFiatCurrTabSel,
            (callback) =>
        {
          getFeeInfo(),
          resetData(),
          getUsableBal(),
          if (!wdFiatCurrTabSel.value)
            {
              setPact(cryptoBeanSel.value),
              getWalletList(),
            }
          else
            {bankcardList(getMergerSelId(wdFiatCurrTabSel.value))}
        });

    inAmtCtrl = TextEditingController();

    ever(globalController.balanceList, (callback) => {getFeeInfo()});

    EventService.instance.addListener(kAddressRefEvent, this);
    EventService.instance.addListener(kBnkRefEvent, this);
    var bindController = Get.put(BindController());
    bindController.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (previousBottomInset > 0.0 && bottomInset == 0.0) {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    }
    previousBottomInset = bottomInset;
  }

  @override
  void onReady() {
    super.onReady();
    // refreshData();
  }

  refreshData() {
    globalController.getContractData();
    wcAvailableLists();
    getDefaultSelCoinData(globalController.wcAvailableData);
    initData(getMergerSelCoin(wdFiatCurrTabSel.value));
    getFeeInfo();
    getBrandDetail();
  }

  @override
  void onClose() {
    super.onClose();
    EventService.instance.removeListener(kBnkRefEvent, this);
    EventService.instance.removeListener(kAddressRefEvent, this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  updateData(CurrencyBean currencyBean) {
    initData(currencyBean);
    getUsableBal();
  }

  initData(CurrencyBean currencyBean) {
    if (currencyBean.currency_type == 1) {
      bankcardList(currencyBean.cur ?? "");
      getUsableBal();
    } else {
      setPact(currencyBean);
      getWalletList();
    }
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

  Future<void> wcAvailableLists() async {
    await ApiService.instance.wcAvailableList(
      success: (availableList) {
        List<CoinBean> wcTemAvailableData = globalController.wcTemAvailableData;
        bool isSame = globalController.areCollectionsEqual(wcTemAvailableData, availableList);
        if (!isSame) {
          globalController.wcAvailableData.assignAll(
              globalController.findCommonData(globalController.currTypeLists, availableList));
        }

        var fiatList = globalController.getCurList(true, globalController.wcAvailableData);
        var cryptoList = globalController.getCurList(false, globalController.wcAvailableData);
        wdFiatCurrState.value = fiatList.length >= 1;
        wdCryptoCurrState.value = cryptoList.length >= 1;
      },
      fail: (message) {},
      contractId: "",
      converter: (json) {
        return CoinBean.fromJson(json);
      },
    );
  }

  void saveSelCoin(CurrencyBean currencyBean) {
    var currencyType = currencyBean.currency_type;
    if (currencyType == 1) {
      currSelContractId.value = "";
      fiatCurrBeanSel.value = currencyBean;
      walletCtrl.fiatCurrBeanSel.value = currencyBean;
      bankcardList(getMergerSelCoin(wdFiatCurrTabSel.value).cur ?? "");
    } else {
      cryptoBeanSel.value = currencyBean;
      walletCtrl.cryptoBeanSel.value = currencyBean;
      setPact(currencyBean);
      getWalletList();
    }
    resetData();
    getUsableBal();
    getWdMixAmt();
    Get.back();
    // walletCtrl.saveSelectedCoin(currencyBean);
  }

  withdrawInfo({String id = ""}) {
    var currencyId = "";
    var bankTree = "";
    var contractType = [];
    var currencyName = "";
    var bandingType = CardBandingTypeEnum.crypto;
    if (getMergerSelId(wdFiatCurrTabSel.value) == "702") {
      bandingType = CardBandingTypeEnum.brl;
      currencyId = '702';
      bankTree = getMergerSelCoin(wdFiatCurrTabSel.value).bank_tree ?? "";
    } else if (wdFiatCurrTabSel.value) {
      bandingType = CardBandingTypeEnum.fiat;
      currencyId = getMergerSelId(wdFiatCurrTabSel.value);
      bankTree = getMergerSelCoin(wdFiatCurrTabSel.value).bank_tree ?? "";
    } else {
      bandingType = CardBandingTypeEnum.crypto;
      currencyId = getMergerSelId(wdFiatCurrTabSel.value);
      contractType = getMergerSelCoin(wdFiatCurrTabSel.value).contract_type ?? [];
      currencyName = getMergerSelCoin(wdFiatCurrTabSel.value).name ?? "";
    }
    CustomCardBandingDialog.openDialog(
        bandingType: bandingType,
        currencyId: currencyId,
        bankTree: bankTree,
        contractType: contractType,
        currencyName: currencyName,
        contractId: currSelContractId.value,
        id: id);
  }

  saveWithdrawInfo({String id = ""}) {
    RouteUtil.popView();
    withdrawInfo(id: id);
  }

  Future<void> bankcardList(String currencyId) async {
    await ApiService.instance.withdrawBankcardList(
        success: (pageModel) {
          if (pageModel.content.isNotEmpty) {
            ifBindCard.value = false;
          } else {
            ifBindCard.value = true;
          }
          bnkSelBean.value = BankcardBean();
          bnkNameBean.value = {};

          var temporaryList = <BankcardBean>[];
          temporaryList.addAll(pageModel.content);
          bnkCurrCards.value = temporaryList.length;
          result.clear();
          for (var bankItem in temporaryList) {
            String bankName = bankItem.bankName;
            dynamic bankId = bankItem.bank_id;
            String bankAccount = bankItem.bankAccount ?? "";
            String country = bankItem.country ?? "";

            var existingEntryIndex = result.indexWhere(
                    (element) => element['bankName'] == bankName && element['bankId'] == bankId);

            if (existingEntryIndex != -1) {
              // 如果已存在相同银行名称的item，则将新的账号添加到该item的账号列表中
              bankItem.bankAccount = bankAccount;
              result[existingEntryIndex]['accountInfo'].add(bankItem);
            } else {
              // 否则创建一个新的item
              bankItem.bankAccount = bankAccount;
              result.add({
                'bankName': bankName,
                'bankId': bankId,
                'country': country,
                'accountInfo': <BankcardBean>[bankItem]
              });
            }
          }
          bnk = result.where((item) => item['country'] == "1").toList();
          aliPay = result.where((item) => item['country'] == "2").toList();
          wallet = result.where((item) => item['country'] == "3").toList();

          // for (var value in result) {
          //   List<BankcardBean> accountInfoList = value['accountInfo'];
          //   for (var accountInfo in accountInfoList) {
          //     var isDefault = accountInfo.isDefault;
          //     if (isDefault == 1 && accountInfo.state != 2) {
          //       bnkSelBean.value = accountInfo;
          //       accountInfo.isSelect = true;
          //       break;
          //     } else {
          //       bnkSelBean.value = BankcardBean(isSelect: false);
          //     }
          //   }
          // }

          withdrawMethodList(currencyId);
          // if (result.isNotEmpty) {
          //   saveBnkName(result[0], 0, isDef: true);
          // }
        },
        fail: (errorMessage) {
          if (errorMessage != null) {}
        },
        currencyId: currencyId);
  }

  //名称
  saveBnkName(dynamic names, int pos, List<dynamic> list, {bool isDef = false}) {
    bnkNameBean.value = names;
    bnkPos.value = pos;
    // bnkSelBean.value = BankcardBean();
    curSelBnkShowErr.value = assertField(bnkNameBean['bankName']);

    if (!isDef) {
      saveBnk(list[bnkPos.value]['accountInfo'][0], list);
    } else {
      var info = list[bnkPos.value]['accountInfo'][0];
      if (info.state != 2) {
        bnkSelBean.value = info;
      }
    }
  }

  //账号
  saveBnk(BankcardBean bean, List<dynamic> list) {
    if (bean.state == 2) {
      bnkSelBean.value = BankcardBean(bank_id: bean.bank_id);
      return;
    }
    for (int i = 0; i < list.length; i++) {
      var accountInfo = list[i]['accountInfo'];
      for (var info in accountInfo) {
        info.isSelect = false;
      }
    }
    var isSelect = bean.isSelect ?? false;
    bean.isSelect = isSelect ? false : true;
    bnkSelBean.value = bean;
    result.refresh();
    curSelBnkAccountShowErr.value = assertField(bean.bankAccount ?? "");
  }

  void saveSelPact(dynamic contract) {
    for (int i = 0; i < currDepSelCtr.length; i++) {
      currDepSelCtr[i]['isSelect'] = false;
    }
    var isSelect = contract["isSelect"] ?? false;
    contract["isSelect"] = isSelect ? false : true;
    currDepSelCtrStr.value = contract['label'];
    currSelContractId.value = contract['id'];
    getWalletList();
    Get.back();
  }

  saveAdr(CoinBean coinBean) {
    if (coinBean.state == 2) {
      return;
    }
    for (int i = 0; i < wdAdrList.length; i++) {
      wdAdrList[i].isSelect = false;
    }
    var isSelect = coinBean.isSelect ?? false;
    coinBean.isSelect = isSelect ? false : true;
    wdAdrList.refresh();
    wdArdSelBean.value = coinBean;
    curSelAdrShowErr.value = assertField(coinBean.address ?? "");
    RouteUtil.popView();
  }

  savePayoutOption(TypeBean typeBean) {
    for (int i = 0; i < payoutOptions.length; i++) {
      payoutOptions[i].isSelect = false;
    }
    typeBean.isSelect = !typeBean.isSelect;
    payoutOptions.refresh();
    payoutOptionBean.value = typeBean;
  }

  Future<void> getWalletList({String contractId = ""}) async {
    await ApiService.instance.walletList(
        success: (data) {
          viewState.value = PageState.SUCCESS;

          if (data.content.isNotEmpty) {
            ifBindAddress.value = false;
          } else {
            ifBindAddress.value = true;
          }
          viewState.value = PageState.SUCCESS;
          wdArdSelBean.value = CoinBean();
          wdAdrList.assignAll(data.content);
          var position = 0;
          for (int i = 0; i < wdAdrList.length; i++) {
            var isDefault = wdAdrList[i].isDefault;
            if (isDefault == 1 && wdAdrList[i].state != 2) {
              position = i;
              wdAdrList[i].isSelect = true;
              wdArdSelBean.value = wdAdrList[i];
              break;
            }
          }

          //https://jira.vgtech.org/browse/STAK-12042
          if (wdArdSelBean.value.id.isEmpty) {
            if (position + 1 < wdAdrList.length) {
              wdArdSelBean.value = wdAdrList[position + 1];
            } else if (position - 1 >= 0) {
              wdArdSelBean.value = wdAdrList[position - 1];
            } else {
              wdArdSelBean.value = CoinBean(isSelect: false);
            }
          }

          // withdrawMethodList(cryptoBeanSel.value.cur ?? "", contractId: contractId.isEmpty ? currSelContractId.value : contractId);
        },
        fail: (errorMessage) {
          viewState.value = PageState.FAILED;
        },
        pageSize: pageSize,
        page: page,
        contractType: contractId.isEmpty ? currSelContractId.value : contractId,
        currencyId: cryptoBeanSel.value.cur ?? "");
  }

  Future<void> withdrawMethodList(String currencyId, {String contractId = ""}) async {
    //
    // await ApiService.instance.withdrawMethodList<PayWayBean>(
    //     success: (list) {
    //       for (int i = 0; i < list.length; i++) {
    //         if (i == 0) {
    //           methodId = list[i].id ?? "";
    //         }
    //       }
    //       wdMethod.value = list.isEmpty ? false : true;
    //       viewState.value = PageState.SUCCESS;
    //     },
    //     fail: (errorMessage) {
    //       viewState.value = PageState.FAILED;
    //       if (errorMessage != null) {}
    //     },
    //     converter: (json) {
    //       return PayWayBean.fromJson(json);
    //     },
    //     currencyId: currencyId,
    //     contractId: contractId);

    withdrawTypeList(currencyId);
  }

  Future<void> withdrawTypeList(String currencyId) async {
    await ApiService.instance.withdrawTypeList<TypeBean>(
      success: (list) {
        viewState.value = PageState.SUCCESS;
        if (list.isNotEmpty) {
          list[0].isSelect = true;
          payoutOptionBean.value = list[0];
          payoutOptions.assignAll(list);
        }
      },
      fail: (errorMessage) {
        viewState.value = PageState.FAILED;
        if (errorMessage != null) {}
      },
      converter: (json) {
        return TypeBean.fromJson(json);
      },
      currencyId: currencyId,
    );
  }

  Future<void> getUsableBal() async {
    var mergerSelId = getMergerSelId(wdFiatCurrTabSel.value);
    if (mergerSelId.isEmpty || mergerSelId == "null") {
      return;
    }
    await ApiService.instance.withdrawBalance<WithdrawnBalanceBean>(
      success: (data) {
        usableBal.value = data.withdrawBalance ?? "0.0";
        remainingBal.value = data.remainingBalance ?? "0.0";
      },
      fail: (message) {},
      converter: (json) {
        return WithdrawnBalanceBean.fromJson(json);
      },
      currencyId: mergerSelId,
    );
  }

  Future<void> getBrandDetail({String tag = 'base,amount'}) async {
    await ApiService.instance.getBrandDetail(
        tag: tag,
        cur: getMergerSelId(wdFiatCurrTabSel.value),
        success: (dynamic) {
          var s = dynamic['base']['commission_withdraw_min'] ?? "0";
          var amtMap = dynamic['amount'];
          wdAmtMixList.value = amtMap.entries.map((entry) {
            var id = entry.key.toString();
            return {
              'id': id.contains("c") ? id.replaceAll("c", "") : id,
              'd': entry.value['d'],
              'w': entry.value['w'],
            };
          }).toList();
          getWdMixAmt();
        },
        fail: (String? message) {});
  }

  getWdMixAmt() {
    var curId = getMergerSelId(wdFiatCurrTabSel.value);
    for (var value in wdAmtMixList) {
      if (value['id'] == curId) {
        wdAmtMix.value = value['d'];
        break;
      }
    }
  }

  checkInputAmount() {
    if (inAmt.value.isEmpty) {
      inAmtShowEr.value = true;
      inAmtShowErrStr.value = S.current.wallet_pleaseEnterAmount;
      return;
    }
    double inputAmounts = double.parse(inAmt.value);
    double amountMix = double.parse(wdAmtMix.value);
    if (inputAmounts == 0) {
      inAmtShowEr.value = true;
      inAmtShowErrStr.value = S.current.wallet_amountCannotBe("0");
    } else if (inputAmounts < amountMix) {
      NumUtil.getValue(amountMix);
      log(S.current.wallet_minimumAmountIs + "$amountMix" + "---${wdAmtMix}");
      inAmtShowEr.value = true;
      inAmtShowErrStr.value = "${S.current.wallet_minimumAmountIs}"
      // "${formatDouble(MoneyUtil.toCoinAmountFormat(
      // getMergerSelCoin(wdFiatCurrTabSel.value).name, amountMix.toString()), 8)}";
          "${formatDouble(amountMix, 8)}";
    } else {
      inAmtShowEr.value = false;
      inAmtShowErrStr.value = "";
    }
  }

  checkInputPassWord() {
    if (inPwd.value.isEmpty) {
      inPwShowErr.value = true;
      inPwShowErrStr.value = S.current.binding_bank_card_please_enter + "${pwTypeBean["title"]}";
    } else {
      if (inPwd.value.length < 6) {
        inPwShowErr.value = true;
        inPwShowErrStr.value = S.current.wallet_yourFundPasswordContainsDigit("6");
      } else {
        inPwShowErr.value = false;
        inPwShowErrStr.value = "";
      }
    }
  }

  //isInput true 输入回调
  checkMemo({bool isInput = false}) {
    if (memo.value.isEmpty && !isInput) {
      memoShowEr.value = true;
      memoShowErrStr.value = "请输入标签";
    } else {
      memoShowEr.value = false;
      memoShowErrStr.value = "";
    }
  }

  mergeWd(bool fiatCurr, BuildContext context, CustomButtonController buttonCtr) {
    checkInputPassWord();
    if (inPwShowErr.value) {
      return;
    }
    if (fiatCurr) {
      withdraw(context, buttonCtr);
    } else {
      coinWithdraw(context, buttonCtr);
    }
  }

  wdInfoCheck() {
    checkInputAmount();
    if (bnkNameBean['bankName'].isEmpty) {
      curSelBnkShowErr.value = true;
    }
    if ((bnkSelBean.value.bankAccount ?? "").isEmpty) {
      curSelBnkAccountShowErr.value = true;
    }
    // if (inAmtShowEr.value == true || inPwShowErr.value == true || bnkSelBean.value.id.isEmpty) {
    //   return;
    // }
  }

  wdInfoCoinCheck() {
    checkInputAmount();
    if (getMergerSelId(wdFiatCurrTabSel.value) == xrp) {
      checkMemo();
    }
    if (wdArdSelBean.value.id.isEmpty) {
      curSelAdrShowErr.value = true;
    }
    // if (inAmtShowEr.value == true || inPwShowErr.value == true || wdArdSelBean.value.id.isEmpty) {
    //   return;
    // }
  }

  onClickWd(BuildContext context) {
    if (wdFiatCurrTabSel.value) {
      wdInfoCheck();
      if (inAmtShowEr.value == true || bnkSelBean.value.id.isEmpty) {
        return;
      }
    } else {
      wdInfoCoinCheck();
      if (inAmtShowEr.value == true || wdArdSelBean.value.id.isEmpty) {
        return;
      }
      if (getMergerSelId(wdFiatCurrTabSel.value) == xrp) {
        if (memoShowEr.value) {
          return;
        }
      }
    }

    var ct = feeInfo['withdraw_count'];
    var wsc = feeInfo['withdraw_setting_count'];
    if (_showWdModal) {
      if (ct > wsc) {
        showWdLimitWidget(context: context).then((value) => {_showWdModal = false});
      } else {
        _showWdModal = false;
      }
    }

    if (!_showWdModal) {
      showCustomPassWorldWidget(context: context)
          .then((value) => {inPwShowErr.value = false, inPwd.value = ""});
    }
  }

  Future<void> withdraw(BuildContext context,
      CustomButtonController btnCtr,) async {
    btnCtr.showAnimation();
    await ApiService.instance.withdraw<String>(
        success: (str) async {
          _showWdModal = true;
          // globalController.setBalance();
          hideKeyboard(context);
          inAmt.value = "";
          inPwd.value = "";
          bankcardList(getMergerSelCoin(wdFiatCurrTabSel.value).cur ?? "");
          RouteUtil.popView();
          await Future.delayed(const Duration(seconds: 5));
          getUsableBal();
        },
        fail: (errorMessage) {
          btnCtr.hideAnimation();

          if (errorMessage != null) {
            CustomSnackBar.show(errorMessage, context,
                title: S.current.random_text_778, preIcon: CustomSnackBarIcons.error);
          }
        },
        currencyId: getMergerSelId(wdFiatCurrTabSel.value),
        methodId: methodId,
        amount: inAmt.value,
        payPassword: inPwd.value,
        bankcardId: bnkSelBean.value.id,
        authType: pwTypeBean.isNotEmpty ? pwTypeBean['authType'] : "");
    btnCtr.hideAnimation();
  }

  Future<void> coinWithdraw(BuildContext context,
      CustomButtonController btnCtr,) async {
    btnCtr.showAnimation();
    await ApiService.instance.coinWithdraw<String>(
        success: (str) async {
          _showWdModal = true;
          memo.value = "";
          hideKeyboard(context);
          inAmt.value = "";
          inPwd.value = "";
          getWalletList();
          RouteUtil.popView();
          await Future.delayed(const Duration(seconds: 5));
          getUsableBal();
        },
        fail: (errorMessage) {
          btnCtr.hideAnimation();
          if (errorMessage != null) {
            CustomSnackBar.show(errorMessage, context,
                title: S.current.random_text_778, preIcon: CustomSnackBarIcons.error);
          }
        },
        currencyId: getMergerSelId(wdFiatCurrTabSel.value),
        amount: inAmt.value,
        payPassword: inPwd.value,
        contractId: currSelContractId.value,
        walletId: wdArdSelBean.value.id,
        memo: memo.value,
        authType: pwTypeBean.isNotEmpty ? pwTypeBean['authType'] : "");
    btnCtr.hideAnimation();
  }

  Future<void> getFeeInfo() async {
    var mergerSelId = getMergerSelId(wdFiatCurrTabSel.value);
    if (mergerSelId.isEmpty || mergerSelId == "null") {
      return;
    }
    await ApiService.instance.wdFeeInfo(
      success: (data) {
        feeInfo.assignAll(data);
      },
      fail: (message) {},
      curId: mergerSelId,
    );
  }

  resetData() {
    memoShowEr.value = false;
    memo.value = "";
    memoShowErrStr.value = "";

    inAmtShowEr.value = false;
    inAmt.value = "";
    inAmtShowErrStr.value = "";

    inPwShowErr.value = false;
    inPwd.value = "";
    inPwShowErrStr.value = "";

    curSelBnkShowErr.value = false;
    curSelBnkAccountShowErr.value = false;
    curSelAdrShowErr.value = false;
  }

  @override
  void onEvent(String eventId, event) {
    switch (eventId) {
      case kAddressRefEvent:
        getWalletList();
        break;
      case kBnkRefEvent:
        bankcardList(getMergerSelId(wdFiatCurrTabSel.value));
        break;
      default:
        break;
    }
  }

  String formatDouble(double number, int decimalPlaces) {
    if (number == 0) {
      return number.toStringAsFixed(decimalPlaces);
    }
    String str = number.toStringAsFixed(decimalPlaces);
    str = str.replaceAll(RegExp(r'0*$'), '');

    // 如果是最后一个字符，则删除小数点
    if (str.endsWith('.')) {
      str = str.substring(0, str.length - 1);
    }

    return str;
  }
}
