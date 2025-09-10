import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/app/modules/wallet/controllers/withdraw_ctrl.dart';
import 'package:flutter_bet/base/getx/page_state.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:get/get.dart';

import '../../../../controllers/global_state_controller.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/user.dart';
import '../../../../model/wallet/BankcardBean.dart';
import '../../../../services/account_service.dart';
import '../../../../services/api/api_service.dart';
import '../../../../services/event/event_service.dart';
import '../../../../widget/button/custom_button_controller.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../../wallet/controllers/comm_ctrl.dart';

//银行
class BindingBankCardController extends GetxController with CommonCtrl {
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final WithDrawCtrl withDrawCtrl = Get.find<WithDrawCtrl>();
  final dynamic dialogParams;

  BindingBankCardController({
    this.dialogParams,
  });

  BuildContext? context;
  final page = 1;
  final pageSize = 10;
  final pwdConfig = {}.obs; // 密码配置

  String? currencyId = "";
  String? flag = "";
  String? bankTree = "";
  String? id = "";
  List<dynamic> contractType = [];
  final viewState = PageState.LOADING.obs;

  // var bankList = <BankcardBean>[].obs;

  var showBankNumberError = false.obs;
  var bankNumberErrorText = ''.obs;

  var showBankNameError = false.obs;
  var bankNameErrorText = ''.obs;

  var showBankError = false.obs;
  var bankErrorText = ''.obs;

  var openName = "".obs; // 已绑银行开户名
  var openNameContr = "".obs;
  var passwordContr = "";
  final isDefault = false.obs;
  var bankNumberText = ''.obs;
  FocusNode focusNodeBankNum = FocusNode();
  FocusNode focusNodeBankName = FocusNode();
  FocusNode focusNodeAddress = FocusNode();
  var openNameShowError = false.obs;

  var bankAccountShowError = false.obs;
  var bankAccountContr = "".obs;
  final bankId = "0".obs;

  ///开户网点
  var registerAreaShowError = false.obs;
  var registerAreaErrorText = "".obs;

  // var registerAreaText = "";
  var bankAreaCpfContr = "".obs;

  var curSelectBank = "".obs;
  var curSelectBankShowError = false.obs;
  var curSelectAccount = "".obs;

  final ScrollController scrollController = ScrollController();

  // final countryList =<MobileAreaCodeModel>[].obs;
  final curSelectBankList = [].obs;
  final curSelectWalletList = [].obs;
  final curSelectWalletBean = {}.obs;
  var curSelectWalletShowError = false.obs;

  final curSelectCountry = "".obs;
  final curSelectCountryId = "".obs;
  final showErrorCountry = false.obs;
  final showTextCountry = "".obs;

  final inputCity = "".obs;
  final showErrorCity = false.obs;
  final showTextCity = "".obs;

  final inputAddress = "".obs; //详细地址
  final showErrorAddress = false.obs;
  final showTextAddress = "".obs;

  final inputSurname = "".obs; //姓
  final showErrorSurname = false.obs;
  final showTextSurname = "".obs;

  final inputName = "".obs; //名
  final showErrorName = false.obs;
  final showTextName = "".obs;

  final optionName = "".obs;
  final showErrorOptionName = false.obs;
  final showTextOption = "".obs;

  final pwdTypeBean = {}.obs;
  final inputPassWord = "".obs;
  final inputPassWordShowError = false.obs;
  final inputPassWordShowErrorText = "".obs;

  final countryAndBandBard = [].obs;

  bool isCNY = false; //是否是 人民币
  @override
  void onInit() {
    super.onInit();
    log("neco init");

    //兼容就代码
    var arguments = Get.arguments ?? dialogParams;
    if (arguments != null) {
      if (arguments.containsKey('currencyId')) {
        currencyId = arguments['currencyId'] ?? "";
        isCNY = currencyId == "701";
      }
      if (arguments.containsKey('bankTree')) {
        bankTree = arguments['bankTree'] ?? "";
      }
      if (arguments.containsKey('id')) {
        id = arguments['id'] ?? "";
      }
    }
    bankcardList();
    getIsGoogleVerify();

    ever(
        withDrawCtrl.payoutOptionBean,
        (callback) => {
              if (withDrawCtrl.payoutOptionBean.value.type == 1)
                {getBankList()}
              else
                {
                  getBankList(typeId: "${withDrawCtrl.payoutOptionBean.value.type}"),
                }
            });
    // loadCountry();
  }

  @override
  void onReady() {
    var type = withDrawCtrl.payoutOptionBean.value.type;
    if (type == 1) {
      getBankList();
    } else {
      getBankList(typeId: "$type");
    }

    super.onReady();
  }

  @override
  void onClose() {
    log("neco 销毁绑定银行");
    Get.delete<BindingBankCardController>();
    super.onClose();
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

  Future<void> checkBankNumber(String number) async {
    if (number.isNotEmpty && number.length < 4) {
      showBankNumberError.value = true;
      bankNumberErrorText.value = S.current.binding_pleaseEnterCorrectBankCardNumber;
    } else if (number.length > 30) {
      showBankNumberError.value = true;
      bankNumberErrorText.value = S.current.binding_pleaseEnterCorrectBankCardNumber;
    } else {
      showBankNumberError.value = false;
      bankNumberErrorText.value = S.current.binding_pleaseEnterYourBankCardNumber;
    }
  }

  Future<void> checkBankName(String number) async {
    if (number.isEmpty || number.length > 20) {
      showBankNameError.value = true;
      bankNameErrorText.value = S.current.binding_pleaseEnterCorrectName;
    } else {
      showBankNameError.value = false;
      bankNameErrorText.value = '';
    }
  }

  Future<void> checkName(String name) async {
    if (name.isEmpty) {
      showErrorName.value = true;
      showTextName.value = S.current.random_text_744;
    } else {
      showErrorName.value = false;
      showTextName.value = '';
    }
  }

  Future<void> checkSurname(String surName) async {
    if (surName.isEmpty) {
      showErrorSurname.value = true;
      showTextSurname.value = S.current.random_text_745;
    } else {
      showErrorSurname.value = false;
      showTextSurname.value = '';
    }
  }

  Future<void> checkCountry(String country) async {
    if (country.isEmpty) {
      showErrorCountry.value = true;
      showTextCountry.value = S.current.random_text_639;
    } else {
      showErrorCountry.value = false;
      showTextCountry.value = '';
    }
  }

  Future<void> checkCity(String country) async {
    if (country.isEmpty) {
      showErrorCity.value = true;
      showTextCity.value = S.current.random_text_746;
    } else {
      showErrorCity.value = false;
      showTextCity.value = '';
    }
  }

  Future<void> checkAddress(String address) async {
    if (address.isEmpty) {
      showErrorAddress.value = true;
      showTextAddress.value = S.current.random_text_747;
    } else {
      showErrorAddress.value = false;
      showTextAddress.value = '';
    }
  }

  bool assertField(String str) {
    var trim = str.trim();
    if (trim.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool checkRegisterArea() {
    if (bankAreaCpfContr.value.isEmpty) {
      registerAreaShowError.value = true;
      registerAreaErrorText.value = S.current.random_text_1128;
      return false;
    } else {
      registerAreaShowError.value = false;
      registerAreaErrorText.value = '';
      return true;
    }
  }

  bool validateBankCard() {
    var isEmpty = true;
    if (curSelectBank.value.trim().isEmpty) {
      curSelectBankShowError.value = true;
      bankErrorText.value = S.current.binding_bank_card_select_bank;
      isEmpty = false;
    }
    if (bankAccountContr.trim().isEmpty) {
      bankAccountShowError.value = true;
      isEmpty = false;
    }
    //是有是人民币 才需要验证这个
    if (isCNY && !checkRegisterArea()) {
      isEmpty = false;
    }
    return isEmpty;
  }

  bool validateAli() {
    var isEmpty = true;
    if (bankAccountContr.trim().isEmpty) {
      bankAccountShowError.value = true;
      isEmpty = false;
    }
    return isEmpty;
  }

  bool validateWallet() {
    var isEmpty = true;
    if (curSelectBank.value.trim().isEmpty) {
      curSelectBankShowError.value = true;
      bankErrorText.value = S.current.binding_bank_card_select_bank;
      isEmpty = false;
    }
    if (bankAccountContr.trim().isEmpty) {
      bankAccountShowError.value = true;
      isEmpty = false;
    }
    return isEmpty;
  }

  bool baseValidate() {
    var isEmpty = true;
    if (openNameContr.value.trim().isEmpty) {
      openNameShowError.value = true;
      isEmpty = false;
    }
    if (inputPassWord.trim().isEmpty) {
      inputPassWordShowError.value = true;
      isEmpty = false;
    }
    return isEmpty;
  }

  bool validate() {
    var isEmpty = true;

    if (curSelectBank.value.trim().isEmpty) {
      curSelectBankShowError.value = true;
      bankErrorText.value = S.current.binding_bank_card_select_bank;
      isEmpty = false;
    }
    if (bankAccountContr.trim().isEmpty) {
      bankAccountShowError.value = true;
      isEmpty = false;
    }

    if (openNameContr.value.trim().isEmpty) {
      openNameShowError.value = true;
      isEmpty = false;
    }
    if (inputPassWord.trim().isEmpty) {
      inputPassWordShowError.value = true;
      isEmpty = false;
    }
    //是有是人民币 才需要验证这个
    if (isCNY && !checkRegisterArea()) {
      isEmpty = false;
    }

    // if (curSelectCountry.value.trim().isEmpty) {
    //   showErrorCountry.value = true;
    //   isEmpty = false;
    // }
    // if (inputCity.trim().isEmpty) {
    //   showErrorCity.value = true;
    //   isEmpty = false;
    // }

    // if (inputName.trim().isEmpty) {
    //   showErrorName.value = true;
    //   isEmpty = false;
    // }
    // if (inputSurname.trim().isEmpty) {
    //   showErrorSurname.value = true;
    //   isEmpty = false;
    // }

    // if (inputAddress.trim().isEmpty) {
    //   showErrorAddress.value = true;
    //   isEmpty = false;
    // }

    return isEmpty;
  }

  getNameAndSurname(String name) {
    if (name.isNotEmpty) {
      if (name.contains(",")) {
        List<String> split = name.split(",");
        inputName.value = split[0]; //名
        inputSurname.value = split[1];
      }
    }
  }

  bool getIsSetupPassword() {
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

  Future<void> currencyTypeList() async {
    //切换币种重置数据
    openName.value = "";
    openNameContr.value = "";
    curSelectBank.value = "";
    bankAccountContr.value = "";
    bankAreaCpfContr.value = "";
    isDefault.value = false;
    await ApiService.instance.treeList<BankcardBean>(
        success: (list) {
          // bankList.assignAll(list);
        },
        fail: (errorMessage) {
          if (errorMessage != null) {}
        },
        level: bankTree ?? "",
        converter: (json) {
          return BankcardBean.fromJson(json);
        });
  }

  //
  // Future<void> loadCountry() async {
  //   await ApiService.instance.treeList<MobileAreaCodeModel>(
  //       success: (list) {
  //         countryList.addAll(list);
  //       },
  //       fail: (errorMessage) {
  //
  //       },
  //       level: "011",
  //       converter: (json) {
  //         return MobileAreaCodeModel.fromJson(json);
  //       });
  //
  // }

  Future<void> bankcardList() async {
    await ApiService.instance.bankcardList(
        success: (pageModel) {
          // openNameContr.value = pageModel.content[0].openName ?? "";
          // openName.value = pageModel.content[0].openName ?? "";
          openNameContr.value = getRealName();
          openName.value = getRealName();
          // getNameAndSurname(pageModel.content[0].openName ??"");
          viewState.value = PageState.SUCCESS;

          if (pageModel.content.isEmpty) {
            isDefault.value = !getBindNum();
            return;
          }
          for (var value in pageModel.content) {
            if (value.id == id) {
              isDefault.value = value.isDefault == 1;
              curSelectBank.value = value.bankName;
              bankAccountContr.value = value.bankAccount ?? "";
              bankAreaCpfContr.value = value.bankAreaCpf ?? "";
              bankId.value = "${value.bank_id}";
              break;
            }
          }
          isDefault.value = isDefault.value ? true : !getBindNum();
        },
        fail: (errorMessage) {
          viewState.value = PageState.FAILED;
        },
        page: page,
        pageSize: pageSize,
        currencyId: currencyId ?? "");
  }

  bool getBindNum() {
    var type = withDrawCtrl.payoutOptionBean.value.type;
    switch (type) {
      case 1:
        return withDrawCtrl.bnk.length >= 1;
      case 2:
        return withDrawCtrl.aliPay.length >= 1;
      case 3:
        return withDrawCtrl.wallet.length >= 1;
      default:
        return withDrawCtrl.bnkCurrCards.value >= 1;
    }
  }

  String getRealName() {
    User? currentUser = AccountService.sharedInstance.currentUser;
    var realNameModel = currentUser?.realname;
    switch (currencyId) {
      case "701":
        return realNameModel?.cn ?? "";
      case "704":
        return realNameModel?.vn ?? "";
      case "705":
        return realNameModel?.th ?? "";
      case "702":
        return realNameModel?.br ?? "";
      case "703":
        return realNameModel?.inKey ?? "";
      default:
        return "";
    }
  }

  onClickBindCard(BuildContext context, CustomButtonController customButtonController) {
    checkBankName(openNameContr.value);
    checkInputPassWord();
    checkBankNumber(bankAccountContr.value);
    var type = withDrawCtrl.payoutOptionBean.value.type;
    if (type == 1) {
      if (!validateBankCard()) {
        return;
      }
    } else if (type == 2) {
      if (!validateAli()) {
        return;
      }
    } else {
      if (!validateWallet()) {
        return;
      }
    }
    log("neco 出款类型$type---id:${withDrawCtrl.payoutOptionBean.value.id}");
    onBankCardInset(context, customButtonController,
        currencyId: currencyId,
        bankAccount: bankAccountContr.value,
        bankAreaCpf: bankAreaCpfContr.value,
        bankName: curSelectBank.value.isEmpty ? curSelectAccount.value : curSelectBank.value,
        openName: openNameContr.value);
  }

  Future<void> onBankCardInset(
    BuildContext context,
    CustomButtonController btnCtr, {
    required String? currencyId,
    required String openName,
    required String bankName,
    required String bankAccount,
    required String bankAreaCpf,
  }) async {
    btnCtr.showAnimation();
    await ApiService.instance.bankcardInsert(
        typeId: "${withDrawCtrl.payoutOptionBean.value.id}",
        id: id,
        currencyId: currencyId ?? "",
        openName: openNameContr.value,
        // openName: "${inputName.value},${inputSurname.value}",
        bankName: bankName,
        bankAccount: bankAccount,
        bankAreaCpf: bankAreaCpf,
        isDefault: isDefault.value ? 1 : 2,
        payPassword: inputPassWord.value,
        success: (message) {
          EventService.instance.dispatchEvent(kBnkRefEvent);
          if (flag != "1") {
            Get.back();
            // Get.back();
          } else {
            Get.back();
            Get.delete<BindingBankCardController>();
          }
          CustomSnackBar.show(
              title: id == "" ? S.current.binding_bank_card_binding : "编辑",
              id == "" ? "绑定成功" : "编辑成功",
              context,
              preIcon: CustomSnackBarIcons.verifySucceed);
        },
        fail: (message) {
          if (message?.isNotEmpty == false) return;
          CustomSnackBar.show(
              title: S.current.bind_fail, "$message", context, preIcon: CustomSnackBarIcons.error);
        },
        // country: curSelectCountryId.value,
        country: "${withDrawCtrl.payoutOptionBean.value.type}",
        city: inputCity.value,
        address: inputAddress.value,
        authType: pwdTypeBean.isNotEmpty ? pwdTypeBean['authType'] : "",
        bankId: bankId.value);
    Future.delayed(const Duration(seconds: 1), () {
      btnCtr.hideAnimation();
    });
  }

  void getIsGoogleVerify() {
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
    getPassWordConfig();
  }

  Future<void> getPassWordConfig() async {
    await ApiService.instance.getPassWordConfig(
        success: (dynamic) {
          pwdConfig.value = dynamic;
        },
        fail: (String? message) {});
  }

  Future<void> getBankList({String typeId = ""}) async {
    await ApiService.instance.getBankBardBank<String>(
        success: (data) {
          countryAndBandBard.addAll(data);
          for (int i = 0; i < countryAndBandBard.length; i++) {
            if (i == 0) {
              countryAndBandBard[i]['isSelect'] = true;
            } else {
              countryAndBandBard[i]['isSelect'] = false;
            }
          }
          curSelectCountry.value = countryAndBandBard[0]['country_name'];
          curSelectCountryId.value = countryAndBandBard[0]['country_id'];
          curSelectBankList.assignAll(data[0]['bank_list']);
          curSelectWalletList.assignAll(data[0]['bank_list']);
          // setBankData();
          // setWalletData();
        },
        fail: (errorMessage) {
          if (errorMessage != null) {}
        },
        currencyId: currencyId ?? "",
        typeId: typeId);
  }

  setBankData() {
    for (int i = 0; i < curSelectBankList.length; i++) {
      if (i == 0) {
        //https://jira.vgtech.org/browse/STAK-11345
        // curSelectBankList[i]['isSelect'] = true;
        // curSelectBank.value = curSelectBankList[i]['name'];
        // bankId.value = curSelectBankList[i]['id'];
      } else {
        curSelectBankList[i]['isSelect'] = false;
      }
    }
  }

  resetData() {
    inputPassWordShowError.value = false;
    inputPassWordShowErrorText.value = "";

    showBankNumberError.value = false;
    bankNumberErrorText.value = "";

    showBankNameError.value = false;
    bankNameErrorText.value = "";

    showErrorName.value = false;
    showTextName.value = "";

    registerAreaShowError.value = false;
    registerAreaErrorText.value = "";

    curSelectBankShowError.value = false;
    bankErrorText.value = "";

    bankAccountShowError.value = false;

    curSelectBank.value = "";
    bankAccountContr.value = "";
    bankAreaCpfContr.value = "";
    inputPassWord.value = "";
  }
}
