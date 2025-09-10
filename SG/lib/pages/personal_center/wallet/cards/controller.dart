import 'package:get/get.dart';
import '../../../../model/user.dart';
import '../../../../routes/routes.dart';
import '../../../../services/account_service.dart';
import '../../../../utils/route_util.dart';
import '../a_model/wallet_common_params.dart';
import '../wallet_controller.dart';
import '../widget/custom_card_banding_dialog.dart';

class CardsController extends GetxController {
  CardsController();

  final WalletController walletCtrl = Get.find<WalletController>();
  final cardsList = [].obs;
  final maxLength = 3.obs;
  var fiatCurrency = false;

  _initData() {
    update(["cards"]);
    bankcardList();
  }

  void onTap() {
    var currencyId = "";
    var bankTree = "";
    var contractType = [];
    var currencyName = "";
    var bandingType = CardBandingTypeEnum.crypto;
    //兼容就代码
    if (walletCtrl.currencyWithdrawalSelectCoinAndAmountId.value == '702') {
      bandingType = CardBandingTypeEnum.brl;
      currencyId = walletCtrl.currencyWithdrawalSelectCoinAndAmountId.value;
      bankTree = walletCtrl.currencyWdSelCoinBankTree.value;
    } else if (fiatCurrency) {
      bandingType = CardBandingTypeEnum.fiat;
      currencyId = walletCtrl.currencyWithdrawalSelectCoinAndAmountId.value;
      bankTree = walletCtrl.currencyWdSelCoinBankTree.value;
    } else {
      bandingType = CardBandingTypeEnum.crypto;
      currencyId = walletCtrl.currencyWithdrawalSelectCoinAndAmountId.value;
      contractType = walletCtrl.currencyWithdrawalSelectContract;
      currencyName = walletCtrl.currencyWithdrawalSelectCoin.value;
    }
    CustomCardBandingDialog.openDialog(
      bandingType: bandingType,
      currencyId: currencyId,
      bankTree: bankTree,
      contractType: contractType,
      currencyName: currencyName,
    );
    return;
    if (walletCtrl.currencyWithdrawalSelectCoinAndAmountId.value == '702') {
      RouteUtil.pushToView(Routes.personalPix, arguments: {
        'currencyId': walletCtrl.currencyWithdrawalSelectCoinAndAmountId.value,
        'bankTree': walletCtrl.currencyWdSelCoinBankTree.value
      });
    } else if (fiatCurrency) {
      RouteUtil.pushToView(Routes.personalBankCard, arguments: {
        'currencyId': walletCtrl.currencyWithdrawalSelectCoinAndAmountId.value,
        'bankTree': walletCtrl.currencyWdSelCoinBankTree.value
      });
    } else {
      RouteUtil.pushToView(Routes.personalAddress, arguments: {
        'currencyId': walletCtrl.currencyWithdrawalSelectCoinAndAmountId.value,
        'contractType': walletCtrl.currencyWithdrawalSelectContract,
        'currencyName': walletCtrl.currencyWithdrawalSelectCoin.value
      });
    }
  }

  void bankcardList() {
    // if (walletCtrl.currencyWithdrawalSelectCoinAndAmountId.value == '702') {
    //   maxLength.value = 2;
    // } else {
    //   maxLength.value = 3;
    // }
    cardsList.clear();
    for (var element in walletCtrl.listCardBag) {
      if (element['id'].toString() == walletCtrl.currencyWithdrawalSelectCoinAndAmountId.value) {
        fiatCurrency = element['fiatCurrency'];
        cardsList.addAll(element['subData']);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    ever(walletCtrl.currencyWithdrawalSelectCoinAndAmountId, (callback) => bankcardList());
    ever(walletCtrl.listCardBag, (callback) => bankcardList());
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
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

// @override
// void onClose() {
//   super.onClose();
// }
}
