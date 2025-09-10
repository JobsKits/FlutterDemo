import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/model/wallet/BankcardBean.dart';
import 'package:flutter_bet/model/wallet/CoinBean.dart';
import 'package:flutter_bet/model/wallet/PayWayBean.dart';
import 'package:flutter_bet/pages/personal_center/vault/vault_controller.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:flutter_bet/utils/money_util.dart';
import 'package:flutter_bet/utils/time/time_utils.dart';
import 'package:flutter_bet/utils/url_launch_util.dart';
import 'package:flutter_bet/utils/vault_util.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:get/get.dart';
import '../../../constant/app_cache_key.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../generated/l10n.dart';
import '../../../model/user.dart';
import '../../../model/wallet/CurrencyBean.dart';
import '../../../model/wallet/PayChannelBean.dart';
import '../../../model/wallet/ProtocolBean.dart';
import '../../../model/wallet/WithdrawnBalanceBean.dart';
import '../../../routes/routes.dart';
import '../../../services/account_service.dart';
import '../../../services/event/event_service.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/num_util.dart';
import '../../../utils/route_util.dart';
import '../../../utils/sp_util.dart';
import '../../../utils/sp_util.dart';
import '../../../widget/button/custom_button_controller.dart';
import '../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../vault/model/coin_rate_model.dart';

const kWalletRefEvent = 'kWalletRefEvent';
const kWalletRefAddressEvent = 'kWalletRefAddressEvent';

const kWalletWithRefEvent = 'kWalletWithRefEvent';
final titleStyle = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

class WalletController extends BaseController with GetTickerProviderStateMixin, EventListener {
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  final scale = 1.0.obs;

  final position = 0.obs;

  final page = 1;

  final pageSize = 20;

  final listCardBag = [].obs;

  final amountType = 0.obs;
  final amountMix = "0".obs;
  final amountMax = "0".obs;
  final amountShowError = false.obs;
  final amountSel = "".obs;

  final coinIcDomain = '${AppValues.defaultBranch.asset_url}/currency/';
  final payIcDomain = "https://d2utx4nptvgikt.cloudfront.net/";
  final coinIcExtensionName = ".webp";

  final memo = "".obs;

  final withdrawAmountMix = "0".obs;
  final withdrawBalance = "".obs;
  final remainingBalance = "".obs;
  final fiatCurrency = "".obs;
  var tab = [
    Tab(
      child: Text(S.current.wallet_deposit, style: titleStyle),
    ),
    Tab(
      child: Text(S.current.vault_withdraw_money, style: titleStyle),
    ),
    Tab(
      child: Text(S.current.cardHolder, style: titleStyle),
    ),
    if (VaultUtil.isShowExchangeCurrency())
      Tab(
        child: Text(S.current.random_text_777, style: titleStyle),
      ),
    // Tab(
    //   child: Text("购买加密货币",style:titleStyle),
    // )
  ];
  final payTabs = <Tab>[].obs;
  final channelTabs = <Tab>[].obs;
  final virtualAmountList = [].obs;

  //用来保存本地初始化数据
  // final currTypeInitialLists = <CurrencyBean>[].obs;
  //用来搜索展示是，因为还涉及到本地的搜索，不能直接使用原数据的列表
  // var coinList = <CurrencyBean>[].obs;
  var payList = <PayWayBean>[].obs;
  var withdrawalPayTabs = <Tab>[].obs;
  var withDrawalPayList = <PayWayBean>[].obs;

  var ifHaveDrawalPayMe = true.obs; //是否有出款方式法币
  final isPayment = true.obs;
  final isChannel = true.obs;

  final thirdBankList = <BankcardBean>[].obs;
  final channelList = <PayChannelBean>[].obs;
  final channelSelectBean = PayChannelBean().obs;
  final amountList = [].obs;
  final amountFixedList = [].obs;
  late TabController tabController;
  late TabController tabControllerPayType;

  // late TabController tabControllerChannelType;

  late TabController tabControllerWithdrawalPay;
  BuildContext? context;
  var bankList = <BankcardBean>[].obs;
  var addressList = <CoinBean>[].obs;

  final ifBindCard = false.obs;
  final ifBindAddress = false.obs;

  var curSelectBank = "".obs;
  var curSelectBankId = "".obs;
  var curSelectBankAccount = "".obs;

  var curSelectAddress = "".obs;
  var curSelectAddressId = "".obs;

  var currencyDepositSelectCoin = "".obs;
  var currencyDepositSelectCoinIc = "".obs;
  var currencyDepositSelectCoinId = "".obs;
  var currencyDepSelContract = "".obs;
  var currencyDepositSelectContract = [].obs;

  var currencySymbol = "".obs;
  final paymentType = 0.obs;

  var currencyWithdrawalSelectCoinAndAmount = "".obs;
  var currencyAmount = "".obs;
  var currencyWithdrawalSelectCoin = "".obs;
  var currencyWithdrawalSelectCoinIc = "".obs;
  var currencyWdSelCoinBankTree = "".obs;
  var currencyWithdrawalSelectCoinAndAmountId = "".obs;
  var currencyWithdrawalSelContract = "".obs;
  var currencyWithdrawalSelectContract = [].obs;

  var currencySelCurrencyId = "".obs; //币种id 共用
  var currencySelContractId = "".obs; //协议id 共用

  var virtualMid = "".obs;
  var mid = "".obs;
  var cid = "".obs;
  var bankCode = "".obs; //vd 出款选择银行的的code

  var bankcardId = "".obs; // 公司入款需要携带

  var curSelectBankShowError = false.obs;
  final curSelectAddressShowError = false.obs;

  var amountChoose = "100".obs;

  var curThirdSelectBank = "".obs;
  var curThirdSelectBankShowError = false.obs;
  var curThirdSelectBankErrorText = "".obs;

  final depositPeopleName = "".obs;
  final depositPeopleNameError = false.obs;

  var errorStr = "".obs;

  //取款
  var methodId = "";
  var inputPassWord = "".obs;
  var inputAmount = "".obs;
  var inputAmountShowError = false.obs;

  var inputAmountShowErrorText = "".obs;

  var inputPassWordShowError = false.obs;

  var inputPassWordShowErrorText = "".obs;

  final isLoadingCompleted = false.obs;

  final isCertified = true.obs;

  // final rateList = <String, CoinRate>{}.obs;

  final currentCurrencyBean = CurrencyBean().obs;

  final exChangeCurrencyBean = CurrencyBean().obs;

  final exchangeRate = 0.0.obs;

  final currentCurrencyText = "".obs; //以xx支付
  final exChangeCurrencyText = "".obs; //兑换货币
  final currentCurrencyAmountShowError = false.obs;
  final currentCurrencyAmountShowErrorText = "".obs;
  TextEditingController? currentCurrencyTextController;
  TextEditingController? exChangeCurrencyTextController;
  final availableAmountList = <CurrencyBean>[].obs; //可用币
  final allAmountList = <CurrencyBean>[].obs; //全币

  final searchAvailableAmountList = <CurrencyBean>[].obs;
  final searchAllAmountList = <CurrencyBean>[].obs;

  TextEditingController? walletNumberController;

  TextEditingController? walletCoinAmountController;

  final pwdTypeBean = {}.obs;

  final ScrollController scrollAmountChooseFiatController = ScrollController();
  final ScrollController scrollAmountChooseVirtualController = ScrollController();
  final ScrollController scrollAbcBankController = ScrollController();
  final ScrollController exchangeCurrscrollController = ScrollController(initialScrollOffset: 0.0);
  final openVerificationAndPayPasswordFrequency = 0.obs;

  final ScrollController scrollWithdrawalController = ScrollController();

  var availability = true;

  final countdownTime = 0.obs;
  final expireAt = 0.obs; // 到期时间
  Timer? countdownTimer;

  @override
  void onInit() {
    super.onInit();
    log("neco 初始化");
    tabControllerPayType = TabController(vsync: this, length: payList.length);
    // tabControllerChannelType = TabController(vsync: this, length: channelList.length);

    walletNumberController = TextEditingController();
    walletCoinAmountController = TextEditingController();
    currentCurrencyTextController = TextEditingController();
    exChangeCurrencyTextController = TextEditingController();
    tabController = TabController(vsync: this, length: tab.length);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        position.value = tabController.index;
        if (position.value != 2) {
          withdrawRateCount.value = 0.0;
          withdrawal(currTypeSelected.value);
          //https://jira.vgtech.org/browse/STAK-2986
          if (availableAmountList.isEmpty) {
            availability = false;
            availableAmountList.value = globalController.currTypeLists;
          }
          payCurrFun(currTypeSelected.value);
        }
        // if (position.value == 3) {
        //   getExchangeRate();
        // }
      }
    });
    EventService.instance.addListener(kWalletRefEvent, this);
    EventService.instance.addListener(kWalletRefAddressEvent, this);
    EventService.instance.addListener(kWalletWithRefEvent, this);

    ///监听设置成功了资金密码或者双重验证
    ever(globalController.isOpenVerificationAndPayPassword, (isOpenVerificationAndPayPassword) {
      if (isOpenVerificationAndPayPassword) {
        openVerificationAndPayPasswordFrequency.value++;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    _loadCountdownTime();
    syncRequestCard();
    _getIsSetupPassword();
    dcAvailableList();
    wcAvailableList();
  }

  @override
  void onClose() {
    log("neco 退出onClose");
    EventService.instance.removeListener(kWalletRefEvent, this);
    EventService.instance.removeListener(kWalletRefAddressEvent, this);
    EventService.instance.removeListener(kWalletWithRefEvent, this);
    if (expireAt.value > 0) {
      _saveCountdownTime();
    }
    countdownTimer?.cancel();
    walletNumberController?.dispose();
    walletCoinAmountController?.dispose();
    currentCurrencyTextController?.dispose();
    exChangeCurrencyTextController?.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    log("neco 退出dispose");
    super.dispose();
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
            ? currencyDepositSelectCoinId.value
            : currentCurrencyBean.value.cur ?? "",
        (exChangeCurrencyBean.value.cur ?? "").isEmpty
            ? currencyDepositSelectCoinId.value
            : exChangeCurrencyBean.value.cur ?? "");
    // calculateAmount(
    //     double.parse(exChangeCurrencyText.value.isEmpty ? "0.0" : exChangeCurrencyText.value));
    convertCurrency(
        double.parse(currentCurrencyText.value.isEmpty ? "0.0" : currentCurrencyText.value));
  }

  //支付货币
  payCurrFun(CurrencyBean currencyBean) {
    if (double.parse(currencyBean.amount ?? "0") <= 0 && availability) {
      currencyBean =  availableAmountList[0]; //特殊情况
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
            ? currencyDepositSelectCoinId.value
            : currentCurrencyBean.value.cur ?? "",
        (exChangeCurrencyBean.value.cur ?? "").isEmpty
            ? currencyDepositSelectCoinId.value
            : exChangeCurrencyBean.value.cur ?? "");
    convertCurrency(
        double.parse(currentCurrencyText.value.isEmpty ? "0.0" : currentCurrencyText.value));
  }

  void _getIsSetupPassword() {
    // User? currentUser = AccountService.sharedInstance.currentUser;
    // if (currentUser != null) {
    //   var googleVerify = currentUser.googleVerify;
    //   if (googleVerify != 2) {
    //     isCertified.value = true;
    //   } else {
    //     isCertified.value = false;
    //   }
    // } else {
    //   isCertified.value = false;
    // }
    //获取用户信息
    AccountService.sharedInstance.refreshUserInfo();
    //获取后端品牌设置，是否开启资金密码和双重验证
    globalController.getBrandBaseInfo();
    //获取用户使用双重验证和资金密码
    globalController.getPassWordConfig();
  }

  checkInputAmount() {
    if (inputAmount.value.isEmpty) {
      inputAmountShowError.value = true;
      inputAmountShowErrorText.value = S.current.wallet_pleaseEnterAmount;
      return;
    }
    double inputAmounts = double.parse(inputAmount.value);
    double amountMix = double.parse(withdrawAmountMix.value);
    if (inputAmounts == 0) {
      inputAmountShowError.value = true;
      inputAmountShowErrorText.value = S.current.wallet_amountCannotBe("0");
    } else if (inputAmounts < amountMix) {
      inputAmountShowError.value = true;
      inputAmountShowErrorText.value =
          "${S.current.wallet_minimumAmountIs}${fiatCurrency.value == "2" ? amountMix.toStringAsFixed(8) : amountMix.toStringAsFixed(2)}";
    } else {
      inputAmountShowError.value = false;
      inputAmountShowErrorText.value = "";
    }
  }

  checkInputPassWord() {
    if (inputPassWord.value.isEmpty) {
      inputPassWordShowError.value = true;
      // inputPassWordShowErrorText.value =  S.current.wallet_pleaseEnterFundPassword;
      inputPassWordShowErrorText.value =
          S.current.binding_bank_card_please_enter + "${pwdTypeBean["title"]}";
    } else {
      if (inputPassWord.value.length < 6) {
        inputPassWordShowError.value = true;
        inputPassWordShowErrorText.value = S.current.wallet_yourFundPasswordContainsDigit("6");
      } else {
        inputPassWordShowError.value = false;
        inputPassWordShowErrorText.value = "";
      }
    }
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

  Future<void> withdraw(
    BuildContext context,
    CustomButtonController btnCtr,
  ) async {
    checkInputAmount();
    checkInputPassWord();
    if (curSelectBankId.value.isEmpty) {
      curSelectBankShowError.value = true;
    }
    if (inputAmountShowError.value == true ||
        inputPassWordShowError.value == true ||
        curSelectBankId.value.isEmpty) {
      return;
    }
    btnCtr.showAnimation();
    await ApiService.instance.withdraw<String>(
        success: (str) async {
          // Get.back();
          withdrawRateCount.value = 0.0;

          globalController.setBalance();
          hideKeyboard(context);
          inputAmount.value = "";
          inputPassWord.value = "";
          bankcardList(currencyWithdrawalSelectCoinAndAmountId.value);
          //https://jira.vgtech.org/browse/STAK-8570
          // CustomSnackBar.show(S.current.wallet_successfulApplicationForPayment, context,
          //     preIcon: CustomSnackBarIcons.verifySucceed);
          await Future.delayed(Duration(seconds: 5)); //目前接口无法实时有延迟几秒 后面接口可以实时的时候可以把这个延时删除
          getWithdrawBalance();
        },
        fail: (errorMessage) {
          btnCtr.hideAnimation();

          if (errorMessage != null) {
            CustomSnackBar.show(errorMessage, context,
                title: S.current.random_text_778, preIcon: CustomSnackBarIcons.error);
          }
        },
        currencyId: currencyWithdrawalSelectCoinAndAmountId.value,
        methodId: methodId,
        amount: inputAmount.value,
        payPassword: inputPassWord.value,
        bankcardId: curSelectBankId.value,
        authType: pwdTypeBean.isNotEmpty ? pwdTypeBean['authType'] : "");
    btnCtr.hideAnimation();
  }

  Future<void> coinWithdraw(
    BuildContext context,
    CustomButtonController btnCtr,
  ) async {
    checkInputAmount();
    checkInputPassWord();
    if (curSelectAddressId.value.isEmpty) {
      curSelectAddressShowError.value = true;
    }
    if (inputAmountShowError.value == true ||
        inputPassWordShowError.value == true ||
        curSelectAddressId.value.isEmpty) {
      return;
    }
    btnCtr.showAnimation();
    await ApiService.instance.coinWithdraw<String>(
        success: (str) async {
          // Get.back();
          withdrawRateCount.value = 0.0;
          memo.value = "";
          hideKeyboard(context);
          // curSelectAddressId.value = "";
          inputAmount.value = "";
          inputPassWord.value = "";
          getWalletList();
          //https://jira.vgtech.org/browse/STAK-8570
          // CustomSnackBar.show(S.current.wallet_successfulApplicationForPayment, context,
          //     preIcon: CustomSnackBarIcons.verifySucceed);
          await Future.delayed(Duration(seconds: 5)); //目前接口无法实时有延迟几秒 后面接口可以实时的时候可以把这个延时删除
          getWithdrawBalance();
        },
        fail: (errorMessage) {
          btnCtr.hideAnimation();
          if (errorMessage != null) {
            CustomSnackBar.show(errorMessage, context,
                title: S.current.random_text_778, preIcon: CustomSnackBarIcons.error);
          }
        },
        currencyId: currencyWithdrawalSelectCoinAndAmountId.value,
        // methodId: methodId,
        amount: inputAmount.value,
        payPassword: inputPassWord.value,
        contractId: currencySelContractId.value,
        walletId: curSelectAddressId.value,
        memo: memo.value,
        authType: pwdTypeBean.isNotEmpty ? pwdTypeBean['authType'] : "");
    btnCtr.hideAnimation();
  }

  Future<void> withdrawMethodList(String currencyId, {String contractId = ""}) async {
    await ApiService.instance.withdrawMethodList<PayWayBean>(
        success: (list) {
          withdrawalPayTabs.clear();
          for (int i = 0; i < list.length; i++) {
            if (i == 0) {
              list[i].isSelect = true;
              methodId = list[i].id ?? "";
            } else {
              list[i].isSelect = false;
            }
            withdrawalPayTabs.add(Tab(
              text: list[i].name,
              icon: const CustomAssetIcon(name: "assets/images/personal_center_icon/vip.webp"),
            ));
          }
          withDrawalPayList.assignAll(list);
          ifHaveDrawalPayMe.value = withDrawalPayList.isEmpty ? false : true;
          log("neco withDrawalPayList长度=${withDrawalPayList.length} ----ifHaveDrawalPayMe=${ifHaveDrawalPayMe.value}");
          tabControllerWithdrawalPay = TabController(vsync: this, length: withDrawalPayList.length);
          tabControllerWithdrawalPay.addListener(() {
            if (tabControllerWithdrawalPay.indexIsChanging) {
              for (var item in withDrawalPayList) {
                item.isSelect = false;
              }
              methodId = withDrawalPayList[tabControllerWithdrawalPay.index].id ?? "";
              withDrawalPayList[tabControllerWithdrawalPay.index].isSelect =
                  withDrawalPayList[tabControllerWithdrawalPay.index].isSelect == true
                      ? false
                      : true;
              withDrawalPayList.refresh();
            }
          });
        },
        fail: (errorMessage) {
          if (errorMessage != null) {}
        },
        converter: (json) {
          return PayWayBean.fromJson(json);
        },
        currencyId: currencyId,
        contractId: contractId); //将 dynamic 类型数据转换为 CurrencyTypeBean 类型的对象
  }

  Future<void> payWayList(String currencyId) async {
    await ApiService.instance
        .payWayList<PayWayBean>(
            success: (list) {
              payTabs.clear();
              for (int i = 0; i < list.length; i++) {
                if (i == 0) {
                  list[i].isSelect = true;
                  payChannelList(list[i].id ?? "");
                  paymentType.value = list[i].payment_type ?? 0;
                  if (list[i].bank == true) {
                    getThirdBankList(list[i].zkId ?? "");
                  } else {
                    thirdBankList.clear();
                  }
                } else {
                  list[i].isSelect = false;
                }
                payTabs.add(Tab(
                  text: list[i].name,
                  icon: const CustomAssetIcon(name: "assets/images/personal_center_icon/vip.webp"),
                ));
              }
              payList.assignAll(list);
              channelList.clear();
              isPayment.value = payList.isNotEmpty ? true : false;
              tabControllerPayType = TabController(vsync: this, length: payList.length);
              tabControllerPayType.addListener(() {
                if (tabControllerPayType.indexIsChanging) {
                  for (var item in payList) {
                    item.isSelect = false;
                  }
                  paymentType.value = payList[tabControllerPayType.index].payment_type ?? 0;
                  payList[tabControllerPayType.index].isSelect =
                      payList[tabControllerPayType.index].isSelect == true ? false : true;
                  payList.refresh();
                  payChannelList(payList[tabControllerPayType.index].id ?? "");
                  if (payList[tabControllerPayType.index].bank ?? false) {
                    getThirdBankList(payList[tabControllerPayType.index].zkId!);
                  } else {
                    thirdBankList.clear();
                  }
                }
              });
              isLoadingCompleted.value = true;
            },
            fail: (errorMessage) {
              isLoadingCompleted.value = true;
              isPayment.value = payList.isNotEmpty ? true : false;

              if (errorMessage != null) {}
            },
            currencyId: currencyId,
            converter: (json) {
              return PayWayBean.fromJson(json);
            })
        .then((value) => () {}); //将 dynamic 类型数据转换为 CurrencyTypeBean 类型的对象
  }

  Future<void> payChannelList(String id) async {
    log("neco 支付方式id $id");
    curThirdSelectBank.value = ""; // abc网银银行
    bankCode.value = ""; //abc网银银行code

    depositPeopleName.value = "";
    depositPeopleNameError.value = false;
    amountSel.value = "";
    errorStr.value = "";
    amountShowError.value = false;
    mid.value = id;
    await ApiService.instance.payChannelList<PayChannelBean>(
        success: (list) {
          channelTabs.clear();
          for (int i = 0; i < list.length; i++) {
            if (i == 0) {
              list[i].isSelect = true;
            } else {
              list[i].isSelect = false;
            }
            channelTabs.add(Tab(
              text: list[i].name,
              icon: const CustomAssetIcon(name: "assets/images/personal_center_icon/vip.webp"),
            ));
          }
          channelList.assignAll(list);
          isChannel.value = channelList.isNotEmpty ? true : false;
          getAmount(channelList[0]);
          //勿删
          // tabControllerChannelType = TabController(vsync: this, length: channelList.length);
          // tabControllerChannelType.addListener(() {
          //   if (tabControllerChannelType.indexIsChanging) {
          //     amountSel.value = "";
          //     errorStr.value = "";
          //     amountShowError.value = false;
          //     for (var item in channelList) {
          //       item.isSelect = false;
          //     }
          //     channelList[tabControllerChannelType.index].isSelect =
          //         channelList[tabControllerChannelType.index].isSelect == true ? false : true;
          //     channelList.refresh();
          //     getAmount(channelList[tabControllerChannelType.index]);
          //   }
          // });
        },
        fail: (errorMessage) {
          isChannel.value = channelList.isNotEmpty ? true : false;
          if (errorMessage != null) {}
        },
        id: id,
        converter: (json) {
          return PayChannelBean.fromJson(json);
        }); //将 dynamic 类型数据转换为 CurrencyTypeBean 类型的对象
  }

  Future<void> coinPayChannelList() async {
    amountSel.value = "";
    errorStr.value = "";
    amountShowError.value = false;
    //STAK-3723
    curSelectAddressShowError.value = false;
    inputAmountShowError.value = false;
    inputPassWordShowError.value = false;
    methodId = "";
    await ApiService.instance.coinPayChannelList<PayChannelBean>(
        success: (list) {
          channelTabs.clear();
          for (int i = 0; i < list.length; i++) {
            if (i == 0) {
              list[i].isSelect = true;
              paymentType.value = list[i].paymentType ?? 0;
            } else {
              list[i].isSelect = false;
            }
            channelTabs.add(Tab(
              text: list[i].name,
              icon: const CustomAssetIcon(name: "assets/images/personal_center_icon/vip.webp"),
            ));
          }
          channelList.assignAll(list);
          isChannel.value = channelList.isNotEmpty ? true : false;

          getAmount(channelList.isNotEmpty ? channelList[0] : null);
          //勿删
          // tabControllerChannelType = TabController(vsync: this, length: channelList.length);
          // tabControllerChannelType.addListener(() {
          //   if (tabControllerChannelType.indexIsChanging) {
          //     amountSel.value = "";
          //     errorStr.value = "";
          //     amountShowError.value = false;
          //     for (var item in channelList) {
          //       item.isSelect = false;
          //     }
          //     paymentType.value = list[tabControllerChannelType.index].paymentType ?? 0;
          //     channelList[tabControllerChannelType.index].isSelect =
          //         channelList[tabControllerChannelType.index].isSelect == true ? false : true;
          //     channelList.refresh();
          //     getAmount(channelList[tabControllerChannelType.index]);
          //   }
          // });
          isLoadingCompleted.value = true;
        },
        fail: (errorMessage) {
          isChannel.value = channelList.isNotEmpty ? true : false;

          if (errorMessage != null) {
            isLoadingCompleted.value = true;
          }
        },
        converter: (json) {
          return PayChannelBean.fromJson(json);
        },
        currencyId: currencySelCurrencyId.value,
        contractId: currencySelContractId.value); //将 dynamic 类型数据转换为 CurrencyTypeBean 类型的对象
  }

  Future<void> balanceTransfer(
    BuildContext context,
    CustomButtonController btnCtr,
  ) async {
    checkCurrentCurrencyTextAmount();
    btnCtr.showAnimation();
    await ApiService.instance.balanceTransfer<String>(
      success: (str) {
        hideKeyboard(context);
        CustomSnackBar.show(S.current.random_text_824, context,
            title: S.current.random_text_650, preIcon: CustomSnackBarIcons.verifySucceed);
        balanceTransferLock(context, btnCtr);
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

  Future<void> _loadCountdownTime() async {
    expireAt.value =
        SPUtil().getInt("${CacheKey.expireAt}${AccountService.sharedInstance.currentUser?.uid}") ??
            0;
    if (TimeUtils.getTimeStampTenDigits() > expireAt.value) {
      countdownTime.value = 0;
    } else {
      countdownTime.value = expireAt.value - TimeUtils.getTimeStampTenDigits();
      log("neco 倒计时 ${expireAt.value}---${TimeUtils.getTimeStampTenDigits()}---${expireAt.value - TimeUtils.getTimeStampTenDigits()}");
      _startTime();
    }
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

  getAmount(PayChannelBean? bean) {
    if (bean == null) {
      return;
    }
    channelSelectBean.value = bean!;
    log("neco 通道id ${bean.id}");
    cid.value = bean.id ?? ""; //法币使用渠道id   虚拟币使用渠道id
    virtualMid.value = bean.methodId ?? ""; //虚拟币使用方式id
    bankcardId.value = bean.bankcardId ?? "";
    amountType.value = bean.amountType ?? 0; // 1:固定2:范围
    amountMix.value = bean.amountMin ?? "0";
    amountMax.value = bean.amountMax ?? "0";
    if (amountType.value == 1) {
      var am = bean.amountFixed ?? "";
      getAmountList(am.isEmpty ? "100,200" : am, amountFixedList);

      var often = bean.oftenAmount ?? "";
      getAmountList(often.isEmpty ? "100,200" : often, amountList);
    } else {
      var am = bean.oftenAmount ?? "";
      getAmountList(am.isEmpty ? "100,200" : am, amountList);
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
      // amountSel.value = amountList[0]['amount'];
    } else {
      list.value = [];
    }
  }

  void getAmountErrorHintStr() {
    if (amountSel.value.isNotEmpty) {
      var amount = double.parse(amountSel.value);
      var mix = double.parse(amountMix.value);
      var max = double.parse(amountMax.value);
      if (amount < mix) {
        amountShowError.value = true;
        errorStr.value = "${S.current.wallet_minimumAmountIs}${amountMix.value}";
      } else if (amount > max) {
        amountShowError.value = true;
        errorStr.value = "${S.current.wallet_maximumAmountIs}${amountMax.value}";
      } else {
        amountShowError.value = false;
      }
    } else {
      amountShowError.value = false;
    }
  }

  void setAmountShowError() {
    log("neco  确认支付类型：${amountType.value}");
    errorStr.value = amountType.value == 1
        ? S.current.wallet_pleaseSelectAmount
        : S.current.wallet_pleaseEnterAmount;
    amountShowError.value = true;
  }

  Future<void> getWalletList() async {
    await ApiService.instance.walletList(
        success: (data) {
          if (data.content.isNotEmpty) {
            ifBindAddress.value = false;
          } else {
            ifBindAddress.value = true;
            // return;
          }
          withdrawMethodList(currencyWithdrawalSelectCoinAndAmountId.value,
              contractId: currencySelContractId.value);
          addressList.assignAll(data.content);
          for (int i = 0; i < addressList.length; i++) {
            var isDefault = addressList[i].isDefault;
            if (isDefault == 1 && addressList[i].state != 2) {
              curSelectAddress.value = addressList[i].address ?? "";
              curSelectAddressId.value = addressList[i].id ?? "";
              addressList[i].isSelect = true;
              break;
            } else {
              addressList[i].isSelect = false;
              curSelectAddress.value = "";
              curSelectAddressId.value = "";
            }
          }
        },
        fail: (errorMessage) {},
        pageSize: pageSize,
        page: page,
        contractType: currencySelContractId.value,
        currencyId: currencyWithdrawalSelectCoinAndAmountId.value);
  }

  Future<void> getThirdBankList(String currencyId) async {
    await ApiService.instance.thirdBankcardList<BankcardBean>(
        success: (list) {
          thirdBankList.assignAll(list);
        },
        fail: (errorMessage) {
          if (errorMessage != null) {}
        },
        id: currencyId,
        converter: (json) {
          return BankcardBean.fromJson(json);
        });
  }

  Future<void> bankcardList(String currencyId) async {
    await ApiService.instance.withdrawBankcardList(
        success: (pageModel) {
          if (pageModel.content.isNotEmpty) {
            ifBindCard.value = false;
            // withdrawMethodList(currencyWithdrawalSelectCoinAndAmountId.value);
          } else {
            ifBindCard.value = true;
          }
          withdrawMethodList(currencyWithdrawalSelectCoinAndAmountId.value);
          bankList.assignAll(pageModel.content);
          for (int i = 0; i < bankList.length; i++) {
            var isDefault = bankList[i].isDefault;
            if (isDefault == 1 && bankList[i].state != 2) {
              curSelectBank.value = (bankList[i].uid != null)
                  ? (bankList[i].bankName ?? "")
                  : (bankList[i].name ?? "");
              curSelectBankId.value = bankList[i].id ?? "";
              curSelectBankAccount.value = bankList[i].bankAccount ?? "";
              bankList[i].isSelect = true;
              break;
            } else {
              curSelectBank.value = "";
              curSelectBankId.value = "";
              curSelectBankAccount.value = "";
              bankList[i].isSelect = false;
            }
          }
        },
        fail: (errorMessage) {
          if (errorMessage != null) {}
        },
        currencyId: currencyId);
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

  Future<List<ProtocolBean>> protocol(String level) async {
    Completer<List<ProtocolBean>> completer = Completer<List<ProtocolBean>>();
    await ApiService.instance.treeList<ProtocolBean>(
        success: (list) {
          completer.complete(list);
        },
        fail: (errorMessage) {
          completer.completeError(errorMessage ?? "");
        },
        level: level,
        converter: (json) {
          return ProtocolBean.fromJson(json);
        });
    return completer.future;
  }

  initData() {
    if (SPUtil().getCurrencyBean() == null) {
      withdrawal(globalController.currTypeLists[0]);
      saveSelected(globalController.currTypeLists[0]);
    } else {
      withdrawal(globalController.currTypeSelected.value);
      saveSelected(globalController.currTypeSelected.value);
    }

    availableAmountList.value =
        globalController.currTypeLists.where((bean) => double.parse(bean.amount!) > 0).toList();
    allAmountList.value = globalController.currTypeInitialLists;

    ///未写完 待周一继续
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
  }

  String setDefaultOutputMoney(String oldMoney, int currencyType) {
    if (currencyType == 2) {
      var split = oldMoney.split('.');
      inputAmount.value = '0.';
      for (int i = 0; i < split[1].length; i++) {
        inputAmount.value += '0';
      }
    }
    return inputAmount.value;
  }

  String getTopAmount(int index) {
    var str;
    if (index == 0) {
    } else if (index == 1) {
      if (globalController.currTypeSelected.value.amount !=
          currencyWithdrawalSelectCoinAndAmount.value) {
        log("neco 哈哈哈 ${globalController.currTypeSelected.value.amount}");
        str = globalController.currTypeSelected.value.amount;
      }
    }
    return str;
  }

  deposit(CurrencyBean bean) {
    amountSel.value = "";

    currencySymbol.value = bean.symbol ?? "";
    currencyDepositSelectCoin.value = bean.name ?? "";
    currencyDepositSelectCoinIc.value = bean.coinIc ?? "";

    currencyDepositSelectCoinId.value = bean.cur ?? "";

    currencySelCurrencyId.value = bean.cur ?? "";
    if (bean.currency_type == 2) {
      currencyDepositSelectContract.value = bean.contract_type ?? [];
      if (currencyDepositSelectContract.isNotEmpty) {
        currencyDepSelContract.value = currencyDepositSelectContract[0]['label'];
        currencySelContractId.value = currencyDepositSelectContract[0]['id'];
        for (int i = 0; i < currencyDepositSelectContract.length; i++) {
          if (i == 0) {
            currencyDepositSelectContract[0]['isSelect'] = true;
          } else {
            currencyDepositSelectContract[i]['isSelect'] = false;
          }
        }
      }
      payList.clear();
    } else {
      currencyDepositSelectContract.value = [];
    }
  }

  withdrawal(CurrencyBean bean) {
    // payCurrFun(bean);
    // exchangeCurrFun(bean);

    deposit(bean);

    curSelectBankAccount.value = "";

    withdrawRateCount.value = 0.0;

    //交易失败停留取款界面选择其他币需要重置数据
    inputAmountShowError.value = false;
    inputAmountShowErrorText.value = "";
    inputPassWordShowError.value = false;
    inputPassWordShowErrorText.value = "";
    methodId = "";
    inputPassWord.value = "";
    inputAmount.value = "";
    //https://vgstake.atlassian.net/browse/STAK-540
    setDefaultOutputMoney(bean.amount ?? "0", bean.currency_type ?? 0);

    // curSelectBank.value = "";
    // curSelectBankId.value = "";
    curThirdSelectBank.value = "";
    curSelectBankShowError.value = false;
    curThirdSelectBankShowError.value = false;
    curSelectAddressShowError.value = false;

    currencyWithdrawalSelectCoin.value = bean.name ?? "";
    currencyWdSelCoinBankTree.value = bean.bank_tree ?? "";
    currencyWithdrawalSelectCoinAndAmount.value = "${bean.symbol} ${bean.amount}";
    currencyAmount.value = bean.amount ?? "0";
    currencyWithdrawalSelectCoinIc.value = bean.coinIc ?? "";
    currencyWithdrawalSelectCoinAndAmountId.value = bean.cur ?? "";
    currencySelCurrencyId.value = bean.cur ?? "";
    fiatCurrency.value = "${bean.currency_type ?? 0}";
    if (bean.currency_type == 2) {
      walletCoinAmountController ?? TextEditingController();
      currencyWithdrawalSelectContract.value = bean.contract_type ?? [];
      if (currencyWithdrawalSelectContract.isNotEmpty) {
        currencyWithdrawalSelContract.value = currencyWithdrawalSelectContract[0]['label'];
        currencySelContractId.value = currencyWithdrawalSelectContract[0]['id'];
      }
      isLoadingCompleted.value = false;
      coinPayChannelList();
      getWalletList();
    } else {
      walletNumberController ?? TextEditingController();
      isLoadingCompleted.value = false;
      payWayList(currencyWithdrawalSelectCoinAndAmountId.value);
      // withdrawMethodList(currencyWithdrawalSelectCoinAndAmountId.value);
      currencyWithdrawalSelectContract.value = [];
      log("neco 提款 选择当前币的id ${currencyWithdrawalSelectCoinAndAmountId.value}");
      bankcardList(currencyWithdrawalSelectCoinAndAmountId.value);
    }
    getWithdrawBalance();
    getBrandDetail();
  }

  Future<Map<String, List<MapEntry<String, dynamic>>>> cardBag() async {
    Completer<Map<String, List<MapEntry<String, dynamic>>>> completer =
        Completer<Map<String, List<MapEntry<String, dynamic>>>>();
    ApiService.instance.cardBagList(
      success: (cardBag) {
        completer.complete(cardBag);
      },
      fail: (errorMessage) {
        completer.completeError(errorMessage ?? "");
      },
    );
    return completer.future;
  }

  Future<void> syncRequestCard() async {
    Map<String, List<MapEntry<String, dynamic>>> cardBagBean = await cardBag();
    List<CurrencyBean> currencyConfigs = await currencyConfig();
    List<ProtocolBean> protocolConfigs = await protocol("018");
    mergeRequestCard(cardBagBean, currencyConfigs, protocolConfigs);
  }

  void mergeRequestCard(Map<String, List<MapEntry<String, dynamic>>> cardBagBean,
      List<CurrencyBean> currencyConfigs, List<ProtocolBean> protocolConfigs) {
    listCardBag.clear();
    var protocolMap = {};
    for (int i = 0; i < protocolConfigs.length; i++) {
      if (protocolConfigs[i].pid == "1800") {
        var value = [];
        for (int j = 0; j < protocolConfigs.length; j++) {
          if (protocolConfigs[i].id == protocolConfigs[j].pid) {
            value.add({
              "label": protocolConfigs[j].name,
              'id': protocolConfigs[j].id,
              'name': protocolConfigs[i].name,
              'isSelect': false
            });
          }
        }
        protocolMap[protocolConfigs[i].name] = value;
      }
    }
    var tempList = [];
    List<MapEntry<String, dynamic>> card = cardBagBean['coin']!;
    List<MapEntry<String, dynamic>> bankcard = cardBagBean['bankcard']!;
    if (card.isEmpty && bankcard.isEmpty) {
      for (int i = 0; i < currencyConfigs.length; i++) {
        tempList.add({
          "id": "${currencyConfigs[i].cur}",
          'name': currencyConfigs[i].name,
          'coinIcon': "$coinIcDomain${currencyConfigs[i].cur}$coinIcExtensionName",
          'fiatCurrency': currencyConfigs[i].currency_type == 2 ? false : true,
          'contract_type': protocolMap[currencyConfigs[i].name],
          'bank_tree': currencyConfigs[i].bank_tree,
          'subData': []
        });
      }
      listCardBag.addAll(tempList);
      return;
    }
    var list = [];
    list.addAll(card);
    list.addAll(bankcard);
    List<Map<String, dynamic>> notMatchedList = [];
    for (int i = 0; i < currencyConfigs.length; i++) {
      String cur = currencyConfigs[i].cur ?? "";
      bool matched = false; // 标记是否找到了匹配的 id

      for (int j = 0; j < list.length; j++) {
        if (cur == list[j].key) {
          List<CoinBean> value =
              (list[j].value as List).map((item) => CoinBean.fromJson(item)).toList();
          var sub = [];
          if (value.isNotEmpty) {
            for (int jj = 0; jj < value.length; jj++) {
              sub.add(currencyConfigs[i].currency_type == 2
                  ? {
                      'address': value[jj].address,
                      'cur': currencyConfigs[i].cur,
                      'contract_name': getProtocolName(
                          protocolMap[currencyConfigs[i].name], value[jj].contractType),
                      'id': value[jj].id,
                      'name': currencyConfigs[i].name,
                      'bank_tree': currencyConfigs[i].bank_tree,
                      'state': value[jj].state,
                      'coinIcon': "$coinIcDomain${currencyConfigs[i].cur}$coinIcExtensionName",
                    }
                  : {
                      'cur': currencyConfigs[i].cur,
                      'state': value[jj].state,
                      'bankAccount': value[jj].bankAccount,
                      'openName': value[jj].openName,
                      'id': value[jj].id,
                      'bankName': value[jj].bankName,
                      'bank_tree': currencyConfigs[i].bank_tree,
                    });
            }
            tempList.add({
              "id": cur,
              'name': currencyConfigs[i].name,
              'coinIcon': "$coinIcDomain${currencyConfigs[i].cur}$coinIcExtensionName",
              'fiatCurrency': currencyConfigs[i].currency_type == 2 ? false : true, //是否是法币
              // 'contract_type': currencyConfigs[i].contract_type,
              'contract_type': protocolMap[currencyConfigs[i].name],
              'bank_tree': currencyConfigs[i].bank_tree,
              'subData': sub
            });
          }
          matched = true; //已匹配
          break;
        }
      }
      // 如果没有找到匹配的id添加到 notMatchedList
      if (!matched) {
        notMatchedList.add({
          "id": cur,
          'name': currencyConfigs[i].name,
          'coinIcon': "$coinIcDomain${currencyConfigs[i].cur}$coinIcExtensionName",
          'fiatCurrency': currencyConfigs[i].currency_type == 2 ? false : true,
          // 'contract_type': currencyConfigs[i].contract_type,
          'contract_type': protocolMap[currencyConfigs[i].name],
          'bank_tree': currencyConfigs[i].bank_tree,
          'subData': []
        });
      }
    }

    tempList.sort((a, b) {
      // 获取子集长度
      int lengthA = a['subData']?.length ?? 0;
      int lengthB = b['subData']?.length ?? 0;
      // 子集长度降序排列
      return lengthB.compareTo(lengthA);
    });
    listCardBag.addAll(tempList);
    listCardBag.addAll(notMatchedList);
  }

  String getCoinIc(String coinId) {
    switch (coinId) {
      case "706":
        return "assets/images/personal_center_icon/usdt_ic.webp";
      case "707":
        return "assets/images/personal_center_icon/btc_ic.webp";
      case "708":
        return "assets/images/personal_center_icon/eth_ic.webp";
      case "709":
        return "assets/images/personal_center_icon/bnb_ic.webp";
      default:
        return "assets/images/personal_center_icon/currency_default_ic.webp";
    }
  }

  String getProtocolName(var list, var id) {
    for (int i = 0; i < list.length; i++) {
      if (list[i]['id'] == id.toString()) {
        return list[i]['label'];
      }
    }
    return "";
  }

  void confirmPayment(BuildContext context, CustomButtonController btnCtr) {
    if (paymentType.value == 2) {
      applicationDeposit(context, btnCtr, cid.value, mid.value, amountSel.value);
    } else {
      thirdDeposit(context, btnCtr, cid.value, mid.value, amountSel.value, bankCode.value);
    }
  }

  void virtualConfirmPayment(BuildContext context, CustomButtonController btnCtr) {
    log("neco 支付类型 ${paymentType.value}");
    if (paymentType.value == 2) {
      coinAppDeposit(context, btnCtr, cid.value, virtualMid.value, amountSel.value);
    } else {
      thirdCoinDeposit(context, btnCtr, cid.value, virtualMid.value, amountSel.value);
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
      curThirdSelectBankErrorText.value = S.current.binding_bank_card_select_bank;
      curThirdSelectBankShowError.value = true;
    }

    if (amountShowError.value == true) {
      return;
    }
    btnCtr.showAnimation();
    await ApiService.instance.thirdDeposit(
        success: (message) {
          // Get.back();
          UrlLaunchUtil.sendPay(message);
          amountSel.value = "";
          curThirdSelectBank.value = "";
          this.bankCode.value = "";

          for (var item in amountFixedList) {
            item['isSelect'] = false;
          }
          for (var item in amountList) {
            item['isSelect'] = false;
          }
          amountList.refresh();
          amountFixedList.refresh();
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
        currencyId: currencyDepositSelectCoinId.value,
        currencyName: currencyDepositSelectCoin.value);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        btnCtr.hideAnimation();
      },
    );
  }

  Future<void> applicationDeposit(BuildContext context, CustomButtonController btnCtr, String cid,
      String mid, String amount) async {
    if (cid.isEmpty) {
      return;
    }
    if (mid.isEmpty) {
      return;
    }
    if (depositPeopleName.isEmpty) {
      depositPeopleNameError.value = true;
    }
    if (amount.isEmpty) {
      setAmountShowError();
    }
    if (amountShowError.value == true || depositPeopleNameError.value == true) {
      return;
    }
    btnCtr.showAnimation();
    await ApiService.instance.applicationDeposit(
        success: (bean) {
          // skip details
          depositPeopleName.value = "";
          amountSel.value = "";
          for (var item in amountFixedList) {
            item['isSelect'] = false;
          }
          for (var item in amountList) {
            item['isSelect'] = false;
          }
          amountList.refresh();
          amountFixedList.refresh();
          RouteUtil.pushToView(Routes.fiatCurrencyDetails,
              arguments: {'bankBean': bean, 'symbol': currencySymbol.value});
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
        currencyId: currencyDepositSelectCoinId.value,
        currencyName: currencyDepositSelectCoin.value,
        realname: depositPeopleName.value,
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
    if (amountShowError.value == true) {
      return;
    }
    btnCtr.showAnimation();
    await ApiService.instance.thirdCoinDeposit(
      success: (bean) {
        // skip details
        depositPeopleName.value = "";
        amountSel.value = "";
        for (var item in amountFixedList) {
          item['isSelect'] = false;
        }
        for (var item in amountList) {
          item['isSelect'] = false;
        }
        amountList.refresh();
        amountFixedList.refresh();
        RouteUtil.pushToView(Routes.virtualDetails, arguments: {
          'coinBean': bean,
          "currencyIc": currencyDepositSelectCoinIc.value,
          "currencyName": currencyDepositSelectCoin.value,
          "currencyContract": currencyDepSelContract.value
        });
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
      currencyId: currencyDepositSelectCoinId.value,
      currencyName: currencyDepositSelectCoin.value,
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
    if (amountShowError.value == true) {
      return;
    }
    btnCtr.showAnimation();
    await ApiService.instance.coinAppDeposit(
      success: (bean) {
        // skip details
        amountSel.value = "";
        for (var item in amountFixedList) {
          item['isSelect'] = false;
        }
        for (var item in amountList) {
          item['isSelect'] = false;
        }
        amountList.refresh();
        amountFixedList.refresh();
        RouteUtil.pushToView(Routes.virtualDetails,
            arguments: {'coinBean': bean, "currencyIc": currencyDepositSelectCoinIc.value});
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
      currencyId: currencyDepositSelectCoinId.value,
      currencyName: currencyDepositSelectCoin.value,
      bankcardId: bankcardId.value,
    );
    Future.delayed(
      const Duration(seconds: 1),
      () {
        btnCtr.hideAnimation();
      },
    );
  }

  String exchangeStr(String data) {
    String result = "";
    String cur = exChangeCurrencyBean.value.cur ?? "0";
    if (data.isEmpty) {
      data = "0";
    }
    result = MoneyUtil.toCoinAmountFormat(cur,data);
    return result;
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

  ///输入判断
  assertField(String str) {
    var trim = str.trim();
    if (trim.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //1001  活动
  // 1002  赠送
  // 1003  热门
  // 1004  推荐
  Color getMarkBg(int pType) {
    if (pType == 1003 || pType == 1002) {
      return AppThemes.favorite;
    } else if (pType == 1004) {
      return AppThemes.walletRecommend;
    } else if (pType == 1001) {
      return AppThemes.activity;
    }
    return Colors.transparent;
  }

  String getMarkValue(String pName, String promo, int pType) {
    if (promo.isEmpty) {
      promo = "0";
    }
    if (double.parse(promo) > 0 && pType == 1002) {
      return "${S.current.random_text_780}${double.parse(promo).toStringAsFixed(0)}%";
    } else {
      return pName;
    }
  }

  ///可取款余额
  Future<void> getWithdrawBalance() async {
    await ApiService.instance.withdrawBalance<WithdrawnBalanceBean>(
      success: (data) {
        withdrawBalance.value = data.withdrawBalance ?? "";
        remainingBalance.value = data.remainingBalance ?? "";
        log("neco  可取款余额${data.withdrawBalance} ${data}");
      },
      fail: (message) {},
      converter: (json) {
        return WithdrawnBalanceBean.fromJson(json);
      },
      currencyId: currencySelCurrencyId.value,
    );
  }

  ///获取品牌app信息
  Future<void> getBrandDetail({String tag = 'base'}) async {
    await ApiService.instance.getBrandDetail(
        tag: tag,
        cur: currencySelCurrencyId.value,
        success: (dynamic) {
          withdrawAmountMix.value = dynamic['min_access']['min_withdraw'];
          log("neco最小取款额${withdrawAmountMix.value}");
        },
        fail: (String? message) {});
  }

  ///关闭软键盘
  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  Future<void> dcAvailableList() async {
    await ApiService.instance.dcAvailableList(
      success: (availableList) {
        log("neco  支付币 ${availableList.length} ---- ${globalController.dcAvailableData.length}");
        List<CoinBean> dcTemAvailableData = globalController.dcTemAvailableData;
        bool isSame = areCollectionsEqual(dcTemAvailableData, availableList);
        if (!isSame) {
          //
          log("neco有不同");
          globalController.dcAvailableData
              .assignAll(findCommonData(globalController.currTypeLists, availableList));
        }
        // //循环中使用 remove 和 insert 操作时，会导致列表的长度发生变化
        // for (int i = globalController.dcAvailableData.length - 1; i >= 0; i--) {
        //   if (globalController.isSelectedItem(globalController.dcAvailableData[i])) {
        //     var selectedItem = globalController.dcAvailableData[i];
        //     globalController.dcAvailableData.removeAt(i);
        //     globalController.dcAvailableData.insert(0, selectedItem);
        //     break;
        //   }
        // }
      },
      fail: (message) {},
      contractId: "",
      converter: (json) {
        return CoinBean.fromJson(json);
      },
    );
  }

  Future<void> wcAvailableList() async {
    await ApiService.instance.wcAvailableList(
      success: (availableList) {
        List<CoinBean> wcTemAvailableData = globalController.wcTemAvailableData;
        bool isSame = areCollectionsEqual(wcTemAvailableData, availableList);
        if (!isSame) {
          log("neco最棒");
          globalController.wcAvailableData
              .assignAll(findCommonData(globalController.currTypeLists, availableList));
        }
      },
      fail: (message) {},
      contractId: "",
      converter: (json) {
        return CoinBean.fromJson(json);
      },
    );
  }

  bool areCollectionsEqual(List<CoinBean> dcTemAvailableData, List<CoinBean> availableList) {
    // 提取每个集合中元素的指定字段，然后将其转换为 Set 进行比较
    Set<dynamic> set1 = dcTemAvailableData.map((element) => element.currencyId).toSet();
    Set<dynamic> set2 = availableList.map((element) => element.currencyId).toSet();

    // 判断两个集合是否相等
    bool currencyIdsEqual = set1.containsAll(set2) && set2.containsAll(set1);
    // 返回最终结果
    return currencyIdsEqual;
  }

  List<CurrencyBean> findCommonData(List<CurrencyBean> currencyList, List<CoinBean> availableList) {
    return currencyList
        .where((currency) =>
            availableList.any((availableCurrency) => currency.cur == availableCurrency.currencyId))
        .toList();
  }

  // =========================下拉框 货币搜索 方法=========================
  // 选中的的item model -- 存款的
  final currTypeSelected = CurrencyBean().obs;

  /// 兑换货币 数据
  final currExchangeTypeSelected = CurrencyBean().obs;

  ///支付货币
  final currPayTypeSelected = CurrencyBean().obs;

  ///临时保存选中的币种
  void saveSelected(CurrencyBean bean) {
    currTypeSelected.value = bean;
  }

  ///判断是否是选中的币种 item
  bool isSelectedItem(CurrencyBean bean) {
    return bean.cur == currTypeSelected.value.cur;
  }

  ///选中支付货币
  void savePaySelected(CurrencyBean bean) {
    currPayTypeSelected.value = bean;
  }

  ///支付货币是否被选中
  bool isPaySelectedItem(CurrencyBean bean) {
    return bean.cur == currPayTypeSelected.value.cur;
  }

  ///选中兑换货币
  void saveExchangeSelected(CurrencyBean bean) {
    currExchangeTypeSelected.value = bean;
  }

  ///兑换货币是否被选中
  bool isExchangeSelectedItem(CurrencyBean bean) {
    return bean.cur == currExchangeTypeSelected.value.cur;
  }

  @override
  void onEvent(String eventId, event) {
    if (eventId == kWalletRefEvent) {
      syncRequestCard();
      bankcardList(currencyWithdrawalSelectCoinAndAmountId.value);
    }
    if (eventId == kWalletRefAddressEvent) {
      syncRequestCard();
      getWalletList();
    }
    if (eventId == kWalletWithRefEvent) {
      refWithdrawal();
    }
  }

  refWithdrawal() {
    for (var curr in globalController.currTypeLists) {
      if (curr.name == currTypeSelected.value.name && curr.amount != currTypeSelected.value.amount) {
        withdrawal(curr);
      }

      if (curr.name == currPayTypeSelected.value.name && curr.amount != currPayTypeSelected.value.amount) {
        availableAmountList.value = globalController.currTypeLists.where((bean) => double.parse(bean.amount!) > 0).toList();
        payCurrFun(curr);
      }

    }
  }

  ///获取余额最大值的整数
  String getCurrencyAmount() {
    if (currencyAmount.value.contains('.')) {
      return currencyAmount.value.split('.')[0];
    }
    return currencyAmount.value;
  }

  ///获取兑换货币余额最大值的整数
  String getExchangeCurrencyAmount() {
    String amount = currentCurrencyBean.value.amount ?? "";
    // if (amount.contains('.')) {
    //   return amount.split('.')[0];
    // }
    return amount;
  }

//=========================下拉框 货币搜索 方法end=========================

  final withdrawRateCount = 0.0.obs; //汇率显示

  withdrawExchangeRateCount(String money) {
    if (money.isNotEmpty) {
      double inputMoney = double.parse(money);
      if (inputMoney != 0) {
        withdrawRateCount.value =
            inputMoney * getCurrentCurrencyExchangeRate(currencySelCurrencyId.value);
      } else {
        withdrawRateCount.value = 0.0;
      }
    } else {
      withdrawRateCount.value = 0.0;
    }
  }

  double getCurrentCurrencyExchangeRate(String currencyKey) {
    for (var entry in globalController.rateList.entries) {
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

  ///当关闭窗口或者 打开时，还原原来的数据源
  void resetSearchList(int flag) {
    log("neco 换元： $flag ${availableAmountList.length}  全部${allAmountList.length}");
    if (flag == 1) {
      searchAvailableAmountList.assignAll(availableAmountList);
    } else {
      searchAllAmountList.assignAll(allAmountList);
    }
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
}
