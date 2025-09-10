import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/transactions/wallet.dart';
import 'package:flutter_bet/model/wallet/CurrencyBean.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/logic.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/state.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:flutter_bet/utils/url_launch_util.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/refresh/widget/cupertino/easy_refresh_path.dart';
import 'package:get/get.dart';

class TrWalletDetailsController extends GetxController {
  TrWalletDetailsController();

  late BuildContext ctx;
  final GlobalKey globalKeyCopy = GlobalKey();
  bool copyTipVisibility = false;
  List<CurrencyBean>coinInfos = [];

  _initData() {
    update(["transaction_details"]);
  }

  /// 联系客服
  Future<void> customerService() async {
    GlobalStateController globalStateController = Get.find<GlobalStateController>();
    if(globalStateController.csUrl.isEmpty){
      await globalStateController.brandCS();
    }
    UrlLaunchUtil.jumpCs();
  }

  /// copy
  void copyAction(text) {
    Clipboard.setData(ClipboardData(text: text));
    if(copyTipVisibility == false) {
      copyTipVisibility = true;
      update(["transaction_details"]);
      Future.delayed(const Duration(seconds: 2), () {
        copyTipVisibility = false;
        update(["transaction_details"]);
      });
    }
    // DialogUtils.showCustomBubbleCopyDialog(
    //   ctx,
    //   Padding(
    //     padding: const EdgeInsets.all(3.0),
    //     child: CustomText(
    //       S.current.successfullyCopi,
    //       textColorStyle: CustomTextColorStyle.dark,
    //     ),
    //   ),
    //   S.current.successfullyCopi.length * 8,
    //   key: globalKeyCopy,
    //   backgroundColor: AppThemes.widgetColorWhite,
    //   bubbleArrowHeight: 6,
    //   bubbleArrowWidth: 8,
    //   arrowBasisOffset: 20.0,
    // );
  }
  /// 跳转链接
  void launchUrl(url) {
    UrlLaunchUtil.launchURL(url);
  }
  /// 获取币种信息
  Future<String?> reqGetCoinTypeInfos({String? current_id}) async {
    Completer<String?> completer = Completer();
    await ApiService.instance.currencyConfig<CurrencyBean>(
      success: (list) {
        coinInfos = list;
        update(["transaction_details"]);
        if (current_id != null) {
          for (CurrencyBean bean in coinInfos) {
            if (bean.cur == current_id) {
              print(bean.symbol);
              completer.complete(bean.symbol);
              return;
            }
          }
        }
        completer.complete(null);
      },
      fail: (errorMessage) {
        completer.complete(null);
      },
    );return completer.future;
  }
  /// 获取法币货币符号
  String getCoinSymbol(TrWalletModel model) {
    for (var element in coinInfos) {
      if(element.cur == model.currencyId) {
        return element.symbol ?? model.currencyName;
      }
    }
    return model.currencyName;
  }

  @override
  void onInit() {
    super.onInit();
    reqGetCoinTypeInfos();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

}
