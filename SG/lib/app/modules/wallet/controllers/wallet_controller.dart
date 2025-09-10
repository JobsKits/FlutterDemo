import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/controllers/payment_details_ctrl.dart';
import 'package:flutter_bet/app/modules/wallet/controllers/withdraw_ctrl.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:get/get.dart';

import '../../../../base/getx/page_state.dart';
import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/wallet/BankcardBean.dart';
import '../../../../model/wallet/CoinBean.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../model/wallet/DepositPrpmo.dart';
import '../../../../model/wallet/PayChannelBean.dart';
import '../../../../model/wallet/PayWayBean.dart';
import '../../../../services/api/api_service.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../utils/url_launch_util.dart';
import '../../../../widget/button/custom_button_controller.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../views/paydetails_dialog_view.dart';
import '../views/payment_view.dart';
import 'comm_ctrl.dart';
import 'exchange_ctrl.dart';

final titleStyle = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

class WalletCtrl extends GetxController
    with CommonCtrl, PaymentDetailsCtrl, GetTickerProviderStateMixin, WidgetsBindingObserver {
  final ScrollController scrollAmountChooseFiatController = ScrollController();
  final ScrollController scrollAbcBankController = ScrollController();
  final double bubbleCoinWidth = 180;

  final payIcDomain = "${AppValues.defaultBranch.asset_url}/";

  final currDepSelCtr = [].obs;
  final currDepSelCtrStr = "".obs;
  final currSelContractId = "".obs;

  final thirdBnkList = <BankcardBean>[].obs;
  final thirdBnkSelBean = BankcardBean().obs;

  final payList = <PayWayBean>[].obs;
  final cid = "".obs;
  final virtualMid = "".obs;
  final bankcardId = "".obs; // 公司入款
  final amtType = 0.obs;
  final amtMix = "0".obs;
  final amtMax = "0".obs;
  final amtList = [].obs;
  final amtFixedList = [].obs;

  final amtSel = "".obs;
  final amtShowErr = false.obs;
  final amtErrorStr = "".obs;

  final curThirdSelBnkErrStr = "".obs;
  final curThirdSelBnkShowErr = false.obs;

  final depName = "".obs;
  final depNameErr = false.obs;

  late BuildContext context;

  final pwySelBean = PayWayBean().obs;
  var currSelChList = <PayChannelBean>[];
  var currSelChIndex = -1;

  final chSelBean = PayChannelBean().obs;

  final isPaymentView = false.obs;

  final giftAmt = 0.00.obs;

  late WithDrawCtrl withDrawCtrl;
  late ExchangeCtrl exchangeCtrl;

  final viewState = PageState.DEFAULT.obs;

  final ScrollController tabScrollCtrl = ScrollController();

  final depFiatCurrState = false.obs;
  final depCryptoCurrState = false.obs;

  final giftViewWidth = 0.0.obs;

  var mState;

  VoidCallback? everPwySelBeanCallback, tabPosCallback, amtSelCallback, fiatCurrTabSelCallback;

  double _previousBottomInset = 0.0;

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => WithDrawCtrl());
    withDrawCtrl = Get.find<WithDrawCtrl>();

    Get.lazyPut(() => ExchangeCtrl());
    exchangeCtrl = Get.find<ExchangeCtrl>();

    context = Get.context!;
    fiatCurrTabSelCallback = ever(
        fiatCurrTabSel,
        (callback) => {
              if (!fiatCurrTabSel.value) {setPact(cryptoBeanSel.value)},
              if (getMergerSelId(fiatCurrTabSel.value).isNotEmpty &&
                  getMergerSelId(fiatCurrTabSel.value) != "null")
                {
                  payWayList(getMergerSelId(fiatCurrTabSel.value)),
                }
            });
    amtSelCallback = ever(amtSel, (callback) => giftAmount(amtSel.value));

    tabPosCallback = ever(tabPos, (callback) => {withDrawCtrl.resetData()});

    everPwySelBeanCallback = ever(
        pwySelBean,
        (callback) => {
              // if (isPaymentView.value) {mState(() {})}
            });

    ever(
        tabPos,
        (callback) => {
              if (tabPos.value == 0)
                {initData()}
              else if (tabPos.value == 1)
                {withDrawCtrl.refreshData()}
              else
                {exchangeCtrl.initData()}
            });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    super.onReady();
    //获取后端品牌设置，是否开启资金密码和双重验证
    globalController.getBrandBaseInfo();
    //获取用户使用双重验证和资金密码
    globalController.getPassWordConfig();
    initData();
  }

  initData() {
    globalController.getContractData();
    dcAvailableLists();
    getDefaultSelCoinData(globalController.dcAvailableData);
    var currencyType = globalController.currTypeSelected.value.currency_type;
    if (currencyType == 1) {
      payWayList(fiatCurrBeanSel.value.cur ?? "0");
    } else {
      setPact(cryptoBeanSel.value);
      payWayList(cryptoBeanSel.value.cur ?? "1");
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (_previousBottomInset > 0.0 && bottomInset == 0.0) {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    }
    _previousBottomInset = bottomInset;
  }

  @override
  void dispose() {
    super.dispose();
    tabScrollCtrl.dispose();
    scrollAmountChooseFiatController.dispose();
    scrollAbcBankController.dispose();
    everPwySelBeanCallback?.call();
    tabPosCallback?.call();
    amtSelCallback?.call();
    fiatCurrTabSelCallback?.call();
    WidgetsBinding.instance.removeObserver(this);
  }

  void saveSelectedThirdBank(BankcardBean bean) {
    for (var item in thirdBnkList) {
      item.isSelect = false;
    }
    bean.isSelect = bean.isSelect == true ? false : true;
    thirdBnkList.refresh();
    curThirdSelBnkShowErr.value = assertField(thirdBnkSelBean.value.name ?? "");
    thirdBnkSelBean.value = bean;
  }

  void saveSelectedPact(dynamic contract) {
    for (int i = 0; i < currDepSelCtr.length; i++) {
      currDepSelCtr[i]['isSelect'] = false;
    }
    var isSelect = contract["isSelect"] ?? false;
    contract["isSelect"] = isSelect ? false : true;
    currDepSelCtrStr.value = contract['label'];
    currSelContractId.value = contract['id'];
    payWayList(cryptoBeanSel.value.cur ?? "");
    Get.back();

    // for (var element in globalController.pactList) {
    //   if (bean.cur == element['currency_id']) {
    //     var contractList = element['contract_list'];
    //     for (var contract in contractList) {
    //       currDepSelCtr.add({
    //         "label": contract['label'],
    //         'id': contract['value'],
    //         'name': contract['label'],
    //         'isSelect': false
    //       });
    //     }
    //     break;
    //   }
    // }
    // if (currDepSelCtr.isNotEmpty) {
    //   currDepSelCtrStr.value = currDepSelCtr[0]['label'];
    //   currSelContractId.value = currDepSelCtr[0]['id'];
    //   for (int i = 0; i < currDepSelCtr.length; i++) {
    //     if (i == 0) {
    //       currDepSelCtr[0]['isSelect'] = true;
    //     } else {
    //       currDepSelCtr[i]['isSelect'] = false;
    //     }
    //   }
    // }
  }

  void saveSelectedPaymentMet(List<PayChannelBean>? channelList, int subIndex, PayWayBean bean,
      {bool isDef = false}) {
    currSelChList.assignAll(channelList ?? []);
    currSelChIndex = subIndex;
    pwySelBean.value = bean;
    saveSelectedPaymentChannel(channelList?[subIndex] ?? PayChannelBean());
    if (!isDef) {
      showPaymentMethodWidget(context);
    }
  }

  void saveSelectedPaymentChannel(PayChannelBean channelBean) {
    chSelBean.value = channelBean;
    getAmount(channelBean);
    resetData();
  }

  void saveSelectedCoin(CurrencyBean currencyBean) {
    payList.clear();
    updateData(currencyBean);
    if (isPaymentView.value) {
      // isPaymentView.value = false;
      RouteUtil.popView(); //当前气泡
      Get.back(); //当前UI
      return;
    }
    // withDrawCtrl.updateData(currencyBean);
    Get.back();
  }

  updateData(CurrencyBean currencyBean) {
    var currencyType = currencyBean.currency_type;
    if (currencyType == 1) {
      currSelContractId.value = "";
      fiatCurrBeanSel.value = currencyBean;
      payWayList(currencyBean.cur ?? "");
      withDrawCtrl.fiatCurrBeanSel.value = currencyBean;
    } else {
      cryptoBeanSel.value = currencyBean;
      withDrawCtrl.cryptoBeanSel.value = currencyBean;
      setPact(currencyBean);
      payWayList(currencyBean.cur ?? "");
    }
  }

  setPact(CurrencyBean bean) {
    // if (bean.currency_type == 2) {
    //   currDepSelCtr.value = bean.contract_type ?? [];
    //   if (currDepSelCtr.isNotEmpty) {
    //     currDepSelCtrStr.value = currDepSelCtr[0]['label'];
    //     currSelContractId.value = currDepSelCtr[0]['id'];
    //     for (int i = 0; i < currDepSelCtr.length; i++) {
    //       if (i == 0) {
    //         currDepSelCtr[0]['isSelect'] = true;
    //       } else {
    //         currDepSelCtr[i]['isSelect'] = false;
    //       }
    //     }
    //   }
    // } else {
    //   currDepSelCtr.value = [];
    // }
    currDepSelCtr.clear();
    for (var element in globalController.pactList) {
      if (bean.cur == element['currency_id']) {
        var contractList = element['contract_list'];
        for (var contract in contractList) {
          currDepSelCtr.add({
            "label": contract['label'],
            'id': contract['value'],
            'name': contract['label'],
            'isSelect': false
          });
        }
        break;
      }
    }
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
  }

  void resetData() {
    // isPaymentView.value = false;
    amtSel.value = "";
    amtShowErr.value = false;
    depName.value = "";
    depNameErr.value = false;
    thirdBnkSelBean.value = BankcardBean();
    curThirdSelBnkShowErr.value = false;
  }

  Future<void> payWayList(String currencyId) async {
    payList.clear();
    viewState.value = PageState.LOADING;
    await ApiService.instance.payWayListV2<PayWayBean>(
        success: (list) {
          payList.addAll(list);
          if (isPaymentView.value) {
            saveSelectedPaymentMet(payList[0].merchants, 0, payList[0], isDef: true);
          }
          viewState.value = payList.isNotEmpty ? PageState.SUCCESS : PageState.EMPTY;
          if (list.isEmpty) {
            var curList =
                globalController.getCurList(fiatCurrTabSel.value, globalController.dcAvailableData);
            if (curList.length >= 2) {
              for (int i = 0; i < curList.length; i++) {
                if (currencyId == curList[i].cur) {
                  payWayList(curList[i + 1].cur ?? "");
                  if ((curList[i].currency_type ?? 0) == 1) {
                    fiatCurrBeanSel.value = curList[i + 1];
                  } else {
                    cryptoBeanSel.value = curList[i + 1];
                  }
                }
              }
            }
          }
          for (var item in list) {
            if (item.bank == true && item.zkId != null && item.zkId!.isNotEmpty) {
              getThirdBankList(item.zkId!);
            }
          }
        },
        fail: (errorMessage) {
          viewState.value = PageState.FAILED;
          if (errorMessage != null) {}
        },
        currencyId: currencyId,
        contractId: fiatCurrTabSel.value ? "" : currSelContractId.value,
        converter: (json) {
          return PayWayBean.fromJson(json);
        }); //将 dynamic 类型数据转换为 CurrencyTypeBean 类型的对象
  }

  Future<void> getThirdBankList(String currencyId) async {
    await ApiService.instance.thirdBankcardList<BankcardBean>(
        success: (list) {
          thirdBnkList.assignAll(list);
          //https://jira.vgtech.org/browse/STAK-11696
          // saveSelectedThirdBank(thirdBnkList[0]);
        },
        fail: (errorMessage) {
          if (errorMessage != null) {}
        },
        id: currencyId,
        converter: (json) {
          return BankcardBean.fromJson(json);
        });
  }

  Future<void> dcAvailableLists() async {
    await ApiService.instance.dcAvailableList(
      success: (availableList) {
        bool isSame = globalController.areCollectionsEqual(
            globalController.dcTemAvailableData, availableList);
        if (!isSame) {
          globalController.dcAvailableData.assignAll(
              globalController.findCommonData(globalController.currTypeLists, availableList));
        }
        var fiatList = globalController.getCurList(true, globalController.dcAvailableData);
        var cryptoList = globalController.getCurList(false, globalController.dcAvailableData);
        depFiatCurrState.value = fiatList.length >= 1;
        depCryptoCurrState.value = cryptoList.length >= 1;
      },
      fail: (message) {},
      contractId: "",
      converter: (json) {
        return CoinBean.fromJson(json);
      },
    );
  }

  getAmount(PayChannelBean? bean) {
    if (bean == null) {
      return;
    }
    cid.value = bean.id ?? ""; //法币使用渠道id   虚拟币使用渠道id
    virtualMid.value = bean.methodId ?? ""; //虚拟币使用方式id
    bankcardId.value = bean.bankcardId ?? "";
    amtType.value = bean.amountType ?? 0; // 1:固定2:范围
    amtMix.value = bean.amountMin ?? "0";
    amtMax.value = bean.amountMax ?? "0";
    if (amtType.value == 1) {
      var am = bean.amountFixed ?? "";
      getAmountList(am.isEmpty ? "100,200" : am, amtFixedList);

      var often = bean.oftenAmount ?? "";
      getAmountList(often.isEmpty ? "100,200" : often, amtList);
    } else {
      var am = bean.oftenAmount ?? "";
      getAmountList(am.isEmpty ? "100,200" : am, amtList);
    }
  }

  getAmountList(String amount, var list) {
    list.clear();
    if (amount.isNotEmpty) {
      if (amount.contains(",")) {
        var split = amount.split(",");
        for (int i = 0; i < split.length; i++) {
          String amounts = split[i].trim();
          list.add({"isSelect": false, "amount": amounts});
        }
      } else {
        list.add({"isSelect": false, "amount": amount});
      }
    } else {
      list.value = [];
    }
  }

  void getAmountErrorHintStr() {
    if (amtSel.value.isNotEmpty) {
      var amount = double.parse(amtSel.value);
      var mix = double.parse(amtMix.value);
      var max = double.parse(amtMax.value);
      if (amount < mix) {
        amtShowErr.value = true;
        amtErrorStr.value = "${S.current.wallet_minimumAmountIs}${amtMix.value}";
      } else if (amount > max) {
        amtShowErr.value = true;
        amtErrorStr.value = "${S.current.wallet_maximumAmountIs}${amtMax.value}";
      } else {
        amtShowErr.value = false;
      }
    } else {
      amtShowErr.value = false;
    }
  }

  void giftAmount(String amtStr) {
    double amt = double.parse(amtStr.isNotEmpty ? amtStr : "0");
    if (pwySelBean.value.depositPromo != null) {
      for (DepositPrpmo depProm in pwySelBean.value.depositPromo!) {
        if (amt >= depProm.min) {
          //&& amt <= depProm.max
          giftAmt.value = amt * depProm.ratio;
          return;
        } else {
          giftAmt.value = 0.00;
        }
      }
    }
  }

  int showChCt(int pyCt, int chCt) {
    if (pyCt == 1) {
      return chCt >= 5 ? 5 : chCt;
    }
    if (chCt < 10) {
      return chCt > 2 ? 2 : chCt;
    }
    if (chCt >= 10) {
      return chCt > 3 ? 3 : 3;
    }
    return 0;
  }

  void confirmPayment(BuildContext context, CustomButtonController btnCtr) {
    if (pwySelBean.value.payment_type == 2) {
      applicationDeposit(context, btnCtr, cid.value, pwySelBean.value.id ?? "", amtSel.value);
    } else {
      thirdDeposit(context, btnCtr, cid.value, pwySelBean.value.id ?? "", amtSel.value,
          thirdBnkSelBean.value.id ?? "");
    }
  }

  void cryptoConfirmPayment(BuildContext context, CustomButtonController btnCtr) {
    if (pwySelBean.value.payment_type == 2) {
      coinAppDeposit(context, btnCtr, cid.value, virtualMid.value, amtSel.value);
    } else {
      thirdCoinDeposit(context, btnCtr, cid.value, virtualMid.value, amtSel.value);
    }
  }

  Future<void> thirdDeposit(BuildContext context, CustomButtonController btnCtr, String cid,
      String mid, String amount, String bankCode) async {
    if (cid.isEmpty) {
      return;
    }
    if (mid.isEmpty) {
      return;
    }
    if (amount.isEmpty) {
      setAmountShowError();
    }
    if (bankCode.isEmpty) {
      curThirdSelBnkErrStr.value = S.current.binding_bank_card_select_bank;
      curThirdSelBnkShowErr.value = true;
    }

    if (amtShowErr.value == true) {
      return;
    }
    btnCtr.showAnimation();
    await ApiService.instance.thirdDeposit(
        success: (message) {
          UrlLaunchUtil.sendPay(message);
          amtSel.value = "";
          thirdBnkSelBean.value = BankcardBean();
          for (var item in amtFixedList) {
            item['isSelect'] = false;
          }
          for (var item in amtList) {
            item['isSelect'] = false;
          }
          amtList.refresh();
          amtFixedList.refresh();
        },
        fail: (errorMessage) {
          if (errorMessage != null) {
            CustomSnackBar.showError(errorMessage, context);
          }
          btnCtr.hideAnimation();
        },
        amount: amount,
        cid: cid,
        mid: mid,
        bankCode: bankCode,
        currencyId: fiatCurrBeanSel.value.cur ?? "",
        currencyName: fiatCurrBeanSel.value.name ?? "");
    Future.delayed(
      const Duration(seconds: 1),
      () {
        btnCtr.hideAnimation();
      },
    );
  }

  Future<void> applicationDeposit(BuildContext context, CustomButtonController btnCtr, String cid,
      String mid, String amount) async {
    if (depName.isEmpty) {
      depNameErr.value = true;
    }
    if (amount.isEmpty) {
      setAmountShowError();
    }
    if (cid.isEmpty) {
      return;
    }
    if (mid.isEmpty) {
      return;
    }
    if (amtShowErr.value == true || depNameErr.value == true) {
      return;
    }
    btnCtr.showAnimation();
    await ApiService.instance.applicationDeposit(
        success: (bean) {
          depName.value = "";
          amtSel.value = "";
          for (var item in amtFixedList) {
            item['isSelect'] = false;
          }
          for (var item in amtList) {
            item['isSelect'] = false;
          }
          amtList.refresh();
          amtFixedList.refresh();
          applicationDep = bean;
          PayDetailsDialogView.openDialog(true);
        },
        fail: (errorMessage) {
          CustomSnackBar.show("$errorMessage", context,
              title: S.current.random_text_785, preIcon: CustomSnackBarIcons.error);
          btnCtr.hideAnimation();
        },
        amount: amount,
        cid: cid,
        mid: mid,
        currencyId: fiatCurrBeanSel.value.cur ?? "",
        currencyName: fiatCurrBeanSel.value.name ?? "",
        realname: depName.value,
        bankcardId: bankcardId.value);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        btnCtr.hideAnimation();
      },
    );
  }

  Future<void> thirdCoinDeposit(BuildContext context, CustomButtonController btnCtr, String cid,
      String virtualMid, String amount) async {
    if (cid.isEmpty) {
      return;
    }
    if (virtualMid.isEmpty) {
      return;
    }
    if (amount.isEmpty) {
      setAmountShowError();
    }
    if (amtShowErr.value == true) {
      return;
    }
    btnCtr.showAnimation();
    await ApiService.instance.thirdCoinDeposit(
      success: (bean) {
        depName.value = "";
        amtSel.value = "";
        for (var item in amtFixedList) {
          item['isSelect'] = false;
        }
        for (var item in amtList) {
          item['isSelect'] = false;
        }
        amtList.refresh();
        amtFixedList.refresh();
        cryptoDep = bean;
        PayDetailsDialogView.openDialog(false);
      },
      fail: (errorMessage) {
        CustomSnackBar.show("${errorMessage}", context,
            title: S.current.random_text_785, preIcon: CustomSnackBarIcons.error);
        btnCtr.hideAnimation();
      },
      amount: amount,
      cid: cid,
      mid: virtualMid,
      currencyId: cryptoBeanSel.value.cur ?? "",
      currencyName: cryptoBeanSel.value.name ?? "",
    );
    Future.delayed(
      const Duration(seconds: 1),
      () {
        btnCtr.hideAnimation();
      },
    );
  }

  Future<void> coinAppDeposit(BuildContext context, CustomButtonController btnCtr, String cid,
      String virtualMid, String amount) async {
    if (cid.isEmpty) {
      return;
    }
    if (virtualMid.isEmpty) {
      return;
    }
    if (amount.isEmpty) {
      setAmountShowError();
    }
    if (amtShowErr.value == true) {
      return;
    }
    btnCtr.showAnimation();
    await ApiService.instance.coinAppDeposit(
      success: (bean) {
        depName.value = "";
        amtSel.value = "";
        for (var item in amtFixedList) {
          item['isSelect'] = false;
        }
        for (var item in amtList) {
          item['isSelect'] = false;
        }
        amtList.refresh();
        amtFixedList.refresh();
        cryptoDep = bean;
        PayDetailsDialogView.openDialog(false);
      },
      fail: (errorMessage) {
        if (errorMessage != null) {
          CustomSnackBar.showError(errorMessage, context);
        }
        btnCtr.hideAnimation();
      },
      amount: amount,
      cid: cid,
      mid: virtualMid,
      currencyId: cryptoBeanSel.value.cur ?? "",
      currencyName: cryptoBeanSel.value.name ?? "",
      bankcardId: bankcardId.value,
    );
    Future.delayed(
      const Duration(seconds: 1),
      () {
        btnCtr.hideAnimation();
      },
    );
  }

  void setAmountShowError() {
    amtErrorStr.value = amtType.value == 1
        ? S.current.wallet_pleaseSelectAmount
        : S.current.wallet_pleaseEnterAmount;
    amtShowErr.value = true;
  }

  getChlIc(PayWayBean bean) {
    if (bean.payment_type == 2 && getMergerSelCoin(fiatCurrTabSel.value).currency_type != 2) {
      return "webp/bank/";
    } else {
      return "payment/deposit/";
    }
  }

  String getPrompt() {
    if (pwySelBean.value.payment_type == 2) {
      if (getMergerSelId(fiatCurrTabSel.value) == "702") {
        return S.current.random_text_1208;
      }
      return S.current.random_text_1209;
    } else {
      return S.current.random_text_1137;
    }
  }

  /// 1001 活动 / 1002 赠送 / 1003 热门 / 1004 推荐
  Color getMarkBg(int pType) {
    switch (pType) {
      case 1001:
        return const Color(0xff1375E1);
      case 1002:
        return AppThemes.walletRecommend;
      case 1003:
        return AppThemes.favorite;
      case 1004:
        return AppThemes.activity;
      default:
        return Colors.transparent;
    }
  }

  String getMarkValue(String pName, String promo, int pType) {
    if (promo.isEmpty) {
      promo = "0";
    }
    if (double.parse(promo) > 0 && pType == 1002) {
      return "${S.current.random_text_1306}${double.parse(promo).toStringAsFixed(2)}%";
    } else {
      return pName;
    }
  }

  void scrollToIndex(int index) {
    final double position = index * 50.0; //滚动到的位置
    if (tabScrollCtrl.hasClients) {
      tabScrollCtrl.animateTo(
        position,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
  }

  void showPaymentMethodWidget(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isPaymentView.value = true;
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                mState = setState;

                return Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        body: GestureDetector(
                            onTap: () {
                              if (WidgetsBinding.instance.window.viewInsets.bottom > 0) {
                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                              }
                            },
                            child: Center(child: PaymentView())),
                        backgroundColor: Colors.transparent,
                      )),
                );
              },
            );
          }).then((value) => {
            resetData(),
            // payWayList(getMergerSelId(fiatCurrTabSel.value)),
            Future.delayed(const Duration(milliseconds: 200))
                .then((value) => isPaymentView.value = false),
          });
    });
  }
}
