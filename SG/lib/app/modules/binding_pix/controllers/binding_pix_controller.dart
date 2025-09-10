import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:get/get.dart';

import '../../../../base/getx/page_state.dart';
import '../../../../controllers/global_state_controller.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/mobile_area_code.dart';
import '../../../../model/user.dart';
import '../../../../model/wallet/BankcardBean.dart';
import '../../../../services/account_service.dart';
import '../../../../services/api/api_service.dart';
import '../../../../services/event/event_service.dart';
import '../../../../widget/button/custom_button_controller.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../../wallet/controllers/comm_ctrl.dart';
import '../../wallet/controllers/withdraw_ctrl.dart';

class BindingPixController extends GetxController with CommonCtrl {
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  // BindingPixController({
  //   this.currencyId,
  //   this.bankTree,
  // });
  final WithDrawCtrl withDrawCtrl = Get.find<WithDrawCtrl>();

  final dynamic dialogParams;

  BindingPixController({
    this.dialogParams,
  });

  final page = 1;
  final pageSize = 10;
  var openNameContr = "".obs;
  var openName = "".obs;
  var curSelectAccount = "".obs;
  var bankAccountContr = "";

  var openNameShowError = false.obs;
  var curSelectBank = "".obs;
  var curSelectBankShowError = false.obs;

  final IsCertified = false.obs;

  var openNameErrorText = "".obs;

  final curSelectBankList = [].obs;

  final countryAndBandBard = [].obs;

  final viewState = PageState.LOADING.obs;

  BuildContext? context;
  String? flag = "";
  String? currencyId = "";
  String? bankTree;
  String? id;
  var passwordContr = "";

  var bankList = <BankcardBean>[].obs;

  var bankAccountShowError = false.obs;
  var bankAccountErrorText = "".obs;

  /// CPF

  var cpfTextShowError = false.obs;
  var cpfTextErrorText = "".obs;

  // var cpfText = "";
  var bankAreaCpfContr = "";
  final bankId = "2104".obs;
  final cpfId = "2104";
  final cpfText = "".obs;

  final isDefault = false.obs;

  final countryList = <MobileAreaCodeModel>[].obs;
  final curSelectCountry = "".obs;
  final curSelectCountryId = "".obs;
  final showErrorCountry = false.obs;
  final showTextCountry = "".obs;

  final inputCity = "".obs;
  final showErrorCity = false.obs;
  final showTextCity = "".obs;

  final inputAddress = "".obs;
  final showErrorAddress = false.obs;
  final showTextAddress = "".obs;

  final inputSurname = "".obs;
  final showErrorSurname = false.obs;
  final showTextSurname = "".obs;

  final inputName = "".obs;
  final showErrorName = false.obs;
  final showTextName = "".obs;

  final pwdConfig = {}.obs; // 密码配置
  final pwdTypeBean = {}.obs;
  final inputPassWord = "".obs;
  final inputPassWordShowError = false.obs;
  final inputPassWordShowErrorText = "".obs;

  @override
  void onInit() {
    super.onInit();
    //兼容旧代码
    var arguments = Get.arguments ?? dialogParams;

    if (arguments != null) {
      if (arguments.containsKey('currencyId')) {
        currencyId = arguments['currencyId'] ?? "";
      }
      if (arguments.containsKey('bankTree')) {
        bankTree = arguments['bankTree'] ?? "";
      }
      if (arguments.containsKey('id')) {
        id = arguments['id'] ?? "";
      }
    }
    getIsGoogleVerify();
    bankcardList();
    // loadCountry();
  }

  @override
  void onReady() {
    super.onReady();

    getBankList();
  }

  @override
  void onClose() {
    Get.delete<BindingPixController>();

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

  checkName(String name) {
    if (name.isEmpty) {
      showErrorName.value = true;
      showTextName.value = S.current.random_text_744;
    } else {
      showErrorName.value = false;
      showTextName.value = '';
    }
  }

  checkSurname(String surName) {
    if (surName.isEmpty) {
      showErrorSurname.value = true;
      showTextSurname.value = S.current.random_text_745;
    } else {
      showErrorSurname.value = false;
      showTextSurname.value = '';
    }
  }

  checkOpenName() {
    if (openNameContr.isEmpty) {
      openNameShowError.value = true;
      openNameErrorText.value = S.current.binding_pleaseEnterCorrectName;
    } else {
      openNameShowError.value = false;
      openNameErrorText.value = '';
    }
  }

  checkCountry(String country) {
    if (country.isEmpty) {
      showErrorCountry.value = true;
      showTextCountry.value = S.current.random_text_639;
    } else {
      showErrorCountry.value = false;
      showTextCountry.value = '';
    }
  }

  checkCity(String city) {
    if (city.isEmpty) {
      showErrorCity.value = true;
      showTextCity.value = S.current.random_text_746;
    } else {
      showErrorCity.value = false;
      showTextCity.value = '';
    }
  }

  checkAddress(String address) {
    if (address.isEmpty) {
      showErrorAddress.value = true;
      showTextAddress.value = S.current.random_text_747;
    } else {
      showErrorAddress.value = false;
      showTextAddress.value = '';
    }
  }

  ///三方账户
  checkBankAccount() {
    if (bankAccountContr.isNotEmpty) {
      if (bankAccountContr.length < 4 || bankAccountContr.length > 30) {
        bankAccountShowError.value = true;
        // bankAccountErrorText.value = S.current.binding_pleaseEnterCorrect430DigitBankCardNumber("4","30");
        //https://jira.vgtech.org/browse/STAK-3267
        // bankAccountErrorText.value ="请输入 4 - 30 位数字组成的正确PIX账户";
        bankAccountErrorText.value = S.current.random_text_748;
      } else {
        bankAccountShowError.value = false;
        bankAccountErrorText.value = "";
      }
    } else {
      bankAccountShowError.value = false;
      bankAccountErrorText.value = "";
    }
  }

  ///检查CPF
  bool checkCpfText() {
    if (bankAreaCpfContr.isNotEmpty) {
      if (bankAreaCpfContr.length < 4 || bankAreaCpfContr.length > 30) {
        cpfTextShowError.value = true;
        // bankAccountErrorText.value = S.current.binding_pleaseEnterCorrect430DigitBankCardNumber("4","30");
        //https://jira.vgtech.org/browse/STAK-3267
        // bankAccountErrorText.value ="请输入 4 - 30 位数字组成的正确PIX账户";
        cpfTextErrorText.value = S.current.random_text_1129;
        return false;
      } else {
        cpfTextShowError.value = false;
        cpfTextErrorText.value = "";
        return true;
      }
    } else {
      cpfTextShowError.value = true;
      cpfTextErrorText.value = S.current.random_text_1129;
      return false;
    }
  }

  Future<void> bankcardList() async {
    await ApiService.instance.bankcardList(
        success: (pageModel) {
          // openNameContr.value = pageModel.content[0].openName ?? "";
          // openName.value = pageModel.content[0].openName ?? "";
          // bankAreaCpfContr = pageModel.content[0].bankAreaCpf ?? "";
          // cpfText.value = pageModel.content[0].bankAreaCpf ?? "";
          // getNameAndSurname(pageModel.content[0].openName ??"");

          openNameContr.value = getRealName();
          openName.value = getRealName();
          bankAreaCpfContr = getCpf();
          cpfText.value = getCpf();
          viewState.value = PageState.SUCCESS;
          if (pageModel.content.isEmpty) {
            isDefault.value = !getBindNum();
            return;
          }
          for (var value in pageModel.content) {
            if (value.id == id) {
              bankId.value = "${value.bank_id}"; //因为 bank_id int
              curSelectAccount.value = value.bankName;
              bankAccountContr = value.bankAccount ?? "";
              bankAreaCpfContr = value.bankAreaCpf ?? "";
              isDefault.value = value.isDefault == 1;
              break;
            }
          }
          isDefault.value = isDefault.value ? true : !getBindNum();
        },
        fail: (errorMessage) {
          viewState.value = PageState.FAILED;
          if (errorMessage != null) {}
        },
        page: page,
        pageSize: pageSize,
        currencyId: currencyId ?? "");
  }

  bool getBindNum() {
    return withDrawCtrl.bnkCurrCards.value >= 1;
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

  String getCpf() {
    User? currentUser = AccountService.sharedInstance.currentUser;
    var mextModel = currentUser?.mext;
    return mextModel?.cpf ?? "";
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

  assertField(String str) {
    var trim = str.trim();
    if (trim.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool validate() {
    var isEmpty = true;
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
    if (curSelectAccount.value.trim().isEmpty) {
      curSelectBankShowError.value = true;
      isEmpty = false;
    }
    if (inputPassWord.value.trim().isEmpty) {
      inputPassWordShowError.value = true;
      isEmpty = false;
    }

    if (bankId.value != cpfId) {
      if (bankAccountContr.trim().isEmpty) {
        bankAccountShowError.value = true;
        // bankAccountErrorText.value = S.current.binding_pleaseEnterThirdPartyAccount;
        bankAccountErrorText.value = S.current.random_text_1293;
        isEmpty = false;
      } else {
        if (bankAccountContr.length < 4 || bankAccountContr.length > 30) {
          bankAccountShowError.value = true;
          bankAccountErrorText.value =
              S.current.binding_pleaseEnterCorrect430DigitBankCardNumber("4", "30");
          isEmpty = false;
        }
      }
    }
    //检查cpf
    if (!checkCpfText()) {
      isEmpty = false;
    }
    if (openNameContr.value.trim().isEmpty) {
      openNameShowError.value = true;
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

    return isEmpty;
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
    openName.value = "";
    openNameContr.value = "";
    bankAccountContr = "";
    curSelectAccount.value = "";
    await ApiService.instance.treeList<BankcardBean>(
        success: (list) {
          bankList.assignAll(list);
        },
        fail: (errorMessage) {
          if (errorMessage != null) {}
        },
        level: bankTree ?? "002",
        converter: (json) {
          return BankcardBean.fromJson(json);
        });
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
    // if (passwordContr.isEmpty || passwordContr.length<6) {
    //   return;
    // }
    btnCtr.showAnimation();
    await ApiService.instance.bankcardInsert(
      id: id,
      currencyId: currencyId ?? "",
      openName: openNameContr.value,
      // openName: "${inputName.value},${inputSurname.value}",
      bankName: bankName,
      bankAccount: bankAccount,
      bankAreaCpf: bankAreaCpf,
      isDefault: isDefault.value ? 1 : 2,
      payPassword: inputPassWord.value,
      // country: curSelectCountryId.value,
      // city: inputCity.value,
      // address: inputAddress.value,
      country: "",
      city: "",
      address: "",
      authType: pwdTypeBean.isNotEmpty ? pwdTypeBean['authType'] : "",
      success: (message) {
        EventService.instance.dispatchEvent(kBnkRefEvent);
        if (flag != "1") {
          Get.back();
          // Get.back();
        } else {
          Get.back();
          Get.delete<BindingPixController>();
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
            title: S.current.bind_fail, message!, context, preIcon: CustomSnackBarIcons.error);
      },
      bankId: bankId.value,
    );
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

  Future<void> getBankList() async {
    await ApiService.instance.getBankBardBank<String>(
        success: (data) {
          countryAndBandBard.assignAll(data);
          for (int i = 0; i < countryAndBandBard.length; i++) {
            if (i == 0) {
              countryAndBandBard[i]['isSelect'] = true;
            } else {
              countryAndBandBard[i]['isSelect'] = false;
            }
          }
          curSelectCountry.value = countryAndBandBard[0]['country_name'];
          curSelectCountryId.value = countryAndBandBard[0]['country_id'];

          curSelectBankList.value = countryAndBandBard[0]['bank_list'];
          setBankData();
        },
        fail: (errorMessage) {
          if (errorMessage != null) {}
        },
        currencyId: currencyId ?? "");
  }

  setBankData() {
    for (int i = 0; i < curSelectBankList.length; i++) {
      if (i == 0) {
        //https://jira.vgtech.org/browse/STAK-11850
        // curSelectBankList[i]['isSelect'] = true;
        // curSelectAccount.value = curSelectBankList[i]['name'];
        // bankId.value = curSelectBankList[i]['id'];
      } else {
        curSelectBankList[i]['isSelect'] = false;
      }
    }
  }
}
