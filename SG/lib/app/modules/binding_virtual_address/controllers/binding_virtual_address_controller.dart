import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/app/modules/wallet/controllers/comm_ctrl.dart';
import 'package:flutter_bet/app/modules/wallet/controllers/withdraw_ctrl.dart';
import 'package:flutter_bet/base/getx/page_state.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:get/get.dart';

import '../../../../controllers/global_state_controller.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/user.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../model/wallet/ValidCurrencyBean.dart';
import '../../../../services/account_service.dart';
import '../../../../services/api/api_service.dart';
import '../../../../services/event/event_service.dart';
import '../../../../widget/button/custom_button_controller.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';

class BindingVirtualAddressController extends GetxController with CommonCtrl {
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final WithDrawCtrl withDrawCtrl = Get.find<WithDrawCtrl>();

  final dynamic dialogParams;

  BindingVirtualAddressController({
    this.dialogParams,
  });

  final viewState = PageState.LOADING.obs;

  final coinList = <CurrencyBean>[].obs;
  final availableCoinList = <ValidCurrencyBean>[].obs;
  final coinSelected = CurrencyBean().obs;

  var currencyId = "";
  var id = "";
  String name = "";
  String adrId = "";

  var selContracts = "";
  var selContractIds = "";

  List<dynamic> contractType = [].obs;
  BuildContext? context;
  var selContract = "".obs;

  var address = "";
  final isDefault = false.obs;
  var selContractId = "".obs;
  var defContractId = "".obs; // 上级网络

  FocusNode focusNodeAddress = FocusNode();
  var showAddressError = false.obs;
  var addressErrorText = ''.obs;
  var addressText = ''.obs;
  var passwordContr = "";
  String? flag = "";
  final isCertified = false.obs;

  final pwdTypeBean = {}.obs;
  final inputPassWord = "".obs;
  final inputPassWordShowError = false.obs;
  final inputPassWordShowErrorText = "".obs;

  @override
  void onInit() {
    super.onInit();
    //兼容久代码，初始化数据
    var arguments = Get.arguments ?? dialogParams;
    if (arguments != null) {
      if (arguments.containsKey('id')) {
        adrId = arguments['id'] ?? "";
      }
      if (arguments.containsKey('currencyId')) {
        currencyId = arguments['currencyId'] ?? "";
        id = currencyId;
      }

      if (arguments.containsKey('contractType')) {
        contractType = arguments['contractType'];
        if (adrId.isNotEmpty) {
          for (int i = 0; i < contractType.length; i++) {
            if (i == 0) {
              contractType[0]['isSelect'] = true;
            } else {
              contractType[i]['isSelect'] = false;
            }
          }
          if (contractType.isNotEmpty) {
            selContract.value = contractType[0]['label'];
            selContractId.value = contractType[0]['id'];
          }
        }
      }

      if (arguments.containsKey('contractId')) {
        defContractId.value = arguments['contractId'];
      }

      if (arguments.containsKey('currencyName')) {
        name = arguments['currencyName'];
      }
    }
    if (adrId.isEmpty) {
      initConfigData();
      getAvailableCurr();
    }
    getWalletList();
  }

  void setPactState() {
    for (int i = 0; i < contractType.length; i++) {
      if (i == 0) {
        contractType[0]['isSelect'] = true;
      } else {
        contractType[i]['isSelect'] = false;
      }
    }
    if (contractType.isNotEmpty) {
      selContract.value = contractType[0]['label'];
      selContractId.value = contractType[0]['id'];
    }
  }

  ///初始化配置数据
  void initConfigData() async {
    //获取虚拟币
    var cryptoCoins =
        globalController.currTypeInitialLists.where((element) => element.isCryptoCoin()).toList();
    coinList.assignAll(cryptoCoins);
    // //默认选中
    // coinSelected.value = coinList.firstWhere((element) => element.cur == currencyId);
    // coinSelectedContractList(coinSelected.value);
  }

  ///当点击货币
  void onClickCoinItem(CurrencyBean coinBean) {
    coinSelectedBean(coinBean);
    getPact(coinBean);
  }

  void getPact(CurrencyBean coinBean, {bool defaultFirst = false}) {
    var cur = coinBean.cur;
    List<dynamic> curContractType = coinBean.contract_type ?? [];
    var tempContractList = <dynamic>[];
    for (var availableCoin in availableCoinList) {
      if (availableCoin.currencyId == cur) {
        for (var currCoin in curContractType) {
          for (var contractIdItem in availableCoin.contractId ?? []) {
            if (currCoin['id'] == contractIdItem.id) {
            } else {
              tempContractList.add(currCoin);
            }
          }
        }
      }
    }

    if (tempContractList.isNotEmpty) {
      contractType = tempContractList;
    } else {
      contractType = curContractType;
    }

    if (contractType.isNotEmpty && defaultFirst) {
      for (var contract in contractType) {
        if (contract['id'] == defContractId.value) {
          contract['isSelect'] = true;
          selContract.value = contract['label'];
          selContractId.value = contract['id'];
          return;
        } else {
          // contractType[0]['isSelect'] = true;
          // selContract.value = contractType[0]['label'];
          // selContractId.value = contractType[0]['id'];
        }
      }
    }
    setPactState();
  }

  ///选中 执行动作
  void coinSelectedBean(CurrencyBean coinBean) {
    coinSelected.value = coinBean;
    id = coinBean.cur ?? "";
  }

  //当选中货币 调用， 获取更新合约列表, 更新一次即可
  void coinSelectedContractList(CurrencyBean coinBean, {bool defaultFirst = true}) {
    if (contractType == coinBean.contract_type) {
      return;
    }
    contractType = coinBean.contract_type ?? [];
    //默认选中第一个
    if (contractType.isNotEmpty && defaultFirst) {
      for (var contract in contractType) {
        if (contract['id'] == defContractId.value) {
          contract['isSelect'] = true;
          selContract.value = contract['label'];
          selContractId.value = contract['id'];
          return;
        } else {
          contractType[0]['isSelect'] = true;
          selContract.value = contractType[0]['label'];
          selContractId.value = contractType[0]['id'];
        }
      }
    } else {
      selContract.value = "";
      selContractId.value = "";
    }
  }

  @override
  void onReady() {
    super.onReady();
    getIsGoogleVerify();
  }

  @override
  void onClose() {
    Get.delete<BindingVirtualAddressController>();
    super.onClose();
  }

  Future<void> walletInsert(BuildContext context, CustomButtonController btnCtr, String id) async {
    if (id.isEmpty) {
      return;
    }
    if (address.isEmpty) {
      return;
    }
    // if(passwordContr.isEmpty || passwordContr.length<6){
    //   return;
    // }
    btnCtr.showAnimation();
    await ApiService.instance.walletInsert(
      id: adrId,
      contractType: flag == "1" ? selContractIds : selContractId.value,
      currencyId: id,
      address: address,
      payPassword: inputPassWord.value,
      isDefault: isDefault.value ? 1 : 2,
      authType: pwdTypeBean.isNotEmpty ? pwdTypeBean['authType'] : "",
      success: (message) {
        EventService.instance.dispatchEvent(kAddressRefEvent);
        if (flag != "1") {
          Get.back();
          // Get.back();
        } else {
          Get.back();
          Get.delete<BindingVirtualAddressController>();
        }
        CustomSnackBar.show(
            title: adrId == "" ? S.current.binding_bank_card_binding : "编辑",
            adrId == "" ? "绑定成功" : "编辑成功",
            context,
            preIcon: CustomSnackBarIcons.verifySucceed);
      },
      fail: (errorMessage) {
        if (errorMessage != null) {
          CustomSnackBar.show(
              title: S.current.bind_fail,
              errorMessage!,
              context,
              preIcon: CustomSnackBarIcons.error);
        }
      },
    );
    Future.delayed(
      const Duration(seconds: 1),
      () {
        btnCtr.hideAnimation();
      },
    );
  }

  Future<void> getWalletList({String contractId = ""}) async {
    await ApiService.instance.walletList(
        success: (data) {
          viewState.value = PageState.SUCCESS;
          var content = data.content;
          for (var value in content) {
            if (value.id == adrId) {
              addressText.value = value.address;
              isDefault.value = value.isDefault == 1;
              break;
            }
          }
          isDefault.value = isDefault.value ? true : !getBindNum();
        },
        fail: (errorMessage) {
          viewState.value = PageState.FAILED;
        },
        pageSize: 1,
        page: 20,
        contractType: selContractId.value,
        currencyId: currencyId);
  }

  bool getBindNum() {
    return withDrawCtrl.wdAdrList.length >= 1;
  }

  Future<void> getAvailableCurr({String contractId = ""}) async {
    await ApiService.instance.validCurrency(
      success: (list) {
        availableCoinList.addAll(list);
        // 过滤已经绑定过的收款数据
        List<CurrencyBean> unboundCurr = [];
        for (var currency in coinList) {
          var isBound = false;
          for (var boundCurrency in availableCoinList) {
            if (currency.cur == boundCurrency.currencyId) {
              if (currency.contract_type?.length == boundCurrency.contractId?.length) {
                isBound = true;
                break;
              }
            }
          }
          if (!isBound) {
            unboundCurr.add(currency);
          }
        }
        coinList.assignAll(unboundCurr);
        //默认选中
        coinSelected.value = coinList.firstWhere((element) => element.cur == currencyId);
        getPact(coinSelected.value, defaultFirst: true);
      },
      fail: (errorMessage) {},
    );
  }

  void getIsGoogleVerify() {
    User? currentUser = AccountService.sharedInstance.currentUser;
    if (currentUser != null) {
      var googleVerify = currentUser.googleVerify;
      isCertified.value = googleVerify != 2;
    } else {
      isCertified.value = false;
    }
  }

  Future<void> checkAddress(String number) async {
    if (number.isEmpty) {
      showAddressError.value = true;
      addressErrorText.value = S.current.binding_pleaseEnterWithdrawalAddress;
    } else if (number.length > 100 || number.length < 5) {
      showAddressError.value = true;
      addressErrorText.value = S.current.binding_pleaseEnterCorrectWithdrawalAddress;
    } else {
      showAddressError.value = false;
      addressErrorText.value = '';
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

  bool getIsSetupPassword() {
    User? currentUser = AccountService.sharedInstance.currentUser;
    if (currentUser != null) {
      var payPassword = currentUser.payPassword;
      return payPassword == "1";
    } else {
      return false;
    }
  }
}
