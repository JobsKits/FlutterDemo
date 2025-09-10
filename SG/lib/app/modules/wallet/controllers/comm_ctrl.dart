import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../controllers/global_state_controller.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_error_tips_text.dart.dart';
import '../../../../widget/custom_rotating_arrow.dart';

mixin CommonCtrl {
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  final cardMaxNum = 3;

  final scale = 1.0.obs;

  final double bubbleWidth = 114;

  final tabPos = 0.obs;

  final fiatCurrTabSel = true.obs;

  ///存提共用

  final wdFiatCurrTabSel = true.obs;

  /// 只用于提款tab刷新

  final fiatCurrBeanSel = CurrencyBean().obs;

  final cryptoBeanSel = CurrencyBean().obs;

  final coinIcExtensionName = ".webp";

  final defCoin = "assets/images/personal_center_icon/pay_default_ic.webp";

  assertField(String str) {
    String trim = str.trim();
    if (trim.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void getDefaultSelCoinData(List<CurrencyBean> list) {
    var value = globalController.currTypeSelected.value;
    var currencyType = value.currency_type;

    var curFiatList = globalController.getCurList(true, list);
    var curCryptoList = globalController.getCurList(false, list);

    if (currencyType == 1) {
      fiatCurrTabSel.value = true;
      wdFiatCurrTabSel.value = true;
      fiatCurrBeanSel.value = value;

      for (int i = 0; i < curFiatList.length; i++) {
        if (curFiatList[i].cur == value.cur) {
          fiatCurrBeanSel.value = value;
          break;
        } else {
          fiatCurrBeanSel.value = curFiatList[0];
        }
      }

      cryptoBeanSel.value = curCryptoList.isNotEmpty ? curCryptoList[0] : CurrencyBean();
    } else {
      fiatCurrTabSel.value = false;
      wdFiatCurrTabSel.value = false;

      cryptoBeanSel.value = value;

      for (int i = 0; i < curCryptoList.length; i++) {
        if (curCryptoList[i].cur == value.cur) {
          cryptoBeanSel.value = value;
        } else {
          cryptoBeanSel.value = curCryptoList[0];
        }
      }
      fiatCurrBeanSel.value = curFiatList.isNotEmpty ? curFiatList[0] : CurrencyBean();
    }
  }

  CurrencyBean getMergerSelCoin(bool fiatCurrTabSel) {
    return fiatCurrTabSel ? fiatCurrBeanSel.value : cryptoBeanSel.value;
  }

  String getMergerSelId(bool fiatCurrTabSel) {
    return "${fiatCurrTabSel ? fiatCurrBeanSel.value.cur : cryptoBeanSel.value.cur}";
  }

  void startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  BoxDecoration getBoxDecoration({bool showErr = false}) {
    return BoxDecoration(
      color: ThemeService().colorScheme.surface,
      // borderRadius: const BorderRadius.only(
      //   topLeft: Radius.circular(AppValues.smallRadius),
      //   bottomLeft: Radius.circular(AppValues.smallRadius),
      //   topRight: Radius.circular(AppValues.smallRadius),
      //   bottomRight: Radius.circular(AppValues.smallRadius),
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

  Widget errView(bool showErr, String errorStr) {
    return Visibility(
        visible: showErr,
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppValues.smallPadding,
          ),
          child: CustomErrorTipsText(
            text: errorStr,
          ),
        ));
  }
}
