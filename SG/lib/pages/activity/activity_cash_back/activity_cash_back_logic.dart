import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/services/api/extension/activity_api_service.dart';
import 'package:flutter_bet/utils/num_util.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import '../../../constant/app_values.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../services/api/api_service.dart';
import '../../../utils/url_launch_util.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_toast.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../../../widget/sport/custom_sport_banner.dart';
import '../a_model/activity_cash_back.dart';

class ActivityCashBackLogic extends BaseController {

  final GlobalStateController globalController = Get.find<GlobalStateController>();
  BuildContext? context;
  final coinIcDomain = '${AppValues.defaultBranch.asset_url}/currency/';
  final coinIcExtensionName = ".webp";
  var pid = '';
  final cur = ''.obs;
  final model = ConfigModel().obs;
  final imageUrl = ''.obs;
  final loading = true.obs;
  final rules = [].obs;
  final levelData = {}.obs;
  final levelNext = ProfitPrizeConfig().obs;
  final days = 0.obs;
  final percent = 0.0.obs;
  final needPay = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if(arguments != null){
      if(arguments.containsKey('pid')){
        pid =   arguments['pid'] ?? "";
      }
    }
    cur.value = globalController.currTypeSelected.value.cur??'701';
    loadData();
    ever(globalController.currTypeSelected, (callback) {
      cur.value = globalController.currTypeSelected.value.cur!;
      loadData();
    });
    ever(globalController.notiPromoApiModel, (callback) => showTips());
  }

  void loadData() async {
    await ApiService.instance.cashbackConfig(
      pid: pid,
      cur: cur.value,
      success: (data) {
        model.value = ConfigModel.fromJson(data);
        imageUrl.value = getImage();
        getRules();
        getDay();
        loadLevel();
      },
      fail: (message) {
        loading.value = false;
      },
    );
  }

  void loadLevel() async {
    await ApiService.instance.getLevel(
      pid: pid,
      cur: cur.value,
      success: (data) {
        if (data['level'] == '') {
          data['level']  = '1';
        }
        levelData.value = data;
        getLevelBet();
        loading.value = false;
      },
      fail: (message) {
        loading.value = false;
      },
    );
  }

  getLevelBet() {
    for (var element in model.value.prizeConfig!.profitPrizeConfig!) {
      if (int.parse(element.level!) == int.parse(levelData['level']) + 1) {
        levelNext.value = element;
      }
    }
    if (levelData['valid_bet_amount'] == null || levelData['valid_bet_amount'] == '') {
      levelData['valid_bet_amount'] = '0';
    }
    percent.value = double.parse(levelData['valid_bet_amount']) / double.parse(levelNext.value.validBetAmount!);
    needPay.value = double.parse(levelNext.value.validBetAmount!) - double.parse(levelData['valid_bet_amount']);
  }

  void getBonus() async {
    await ApiService.instance.getBonus(
      pid: pid,
      cur: globalController.currTypeSelected.value.cur,
      success: (data) {
        if (data.containsKey('data')) return;
        levelData['receive'] = false;
        if (data['withdraw_type'] == 1) {
          CustomSnackBar.show(
            subContent: tipsWidget(S.current.random_text_1190+
                '${data['bonus_amount']}'),
            "message",
            Get.overlayContext!,
            title: S.current.random_text_96,
            preIcon: CustomSnackBarIcons.activitySuccess
          );
        } else {
          CustomSnackBar.show(title: S.current.random_text_1058,S.current.random_text_1059, context!, preIcon: CustomSnackBarIcons.activityApplying);
        }
      },
      fail: (message) {
        if (message != null) {
          CustomSnackBar.showError(message.toString(), context);
        }  else {
          CustomSnackBar.showError(S.current.random_text_1060, context);
        }
      },
    );
  }

  showTips() {
    var amount = NumUtil.keepDecimals(double.parse(globalController.notiPromoApiModel.value.bonusAmount??'0'),digits: globalController.selectedCoin.currency_type == 2 ? 8 : 2);
    if (globalController.notiPromoApiModel.value.type == '0') {// 0 成功  1 拒绝
      CustomSnackBar.show(
            subContent: tipsWidget(S.current.random_text_1190+
                '${amount}'),
            "message",
            Get.overlayContext!,
            title: S.current.random_text_96,
            preIcon: CustomSnackBarIcons.activitySuccess
          );
    } else {
      CustomSnackBar.show(
            subContent: tipsWidget(S.current.random_text_1190+
                '${amount}'),
            "message",
            Get.overlayContext!,
            title: S.current.random_text_1055,
            preIcon: CustomSnackBarIcons.error
          );
    }
  }

  Widget tipsWidget(String message) {
    return SizedBox(
      width: Get.width - 160,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Row(
                children: [
                  CustomText(message,textColorStyle: CustomTextColorStyle.normal,),
                  const SizedBox(
                    width: 4,
                  ),
                  CustomNetWorkImage(
                    placeholder: const CustomAssetIcon(
                      name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                    ),
                    errorWidget: const CustomAssetIcon(
                      name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                    ),
                    imageUrl: "$coinIcDomain$cur$coinIcExtensionName",
                    width: 14,
                    height: 14,
                  ),
                ],
              )
            )
          ]
        )
      ),
    );
  }

  getImage() {
    var data = json.decode(model.value.images!);
    Content mdl = Content.fromJson(data);
    if (globalController.langType.value == 1) {
      return mdl.contentZhCn;
    } else if (globalController.langType.value == 2) {
      return mdl.enUs;
    } else if (globalController.langType.value == 3) {
      return mdl.ptBr;
    } else if (globalController.langType.value == 4) {
      return mdl.viVn;
    } else if (globalController.langType.value == 5) {
      return mdl.thTh;
    } else {
      return mdl.contentZhCn ?? '';
    }
  }

  getRules() {
    var str = model.value.detail!.replaceAll('<p>', '');
    var string = str.replaceAll('</p>', '');
    rules.value = string.split('\n   ');
    rules.removeAt(0);
  }

  getDay() {
    var x = ((model.value.applyPeriod??0) / 86400).round();
    int y = (model.value.applyPeriod??0) % 86400;
    if (y != 0) {
      x++;
    }
    days.value = x;
  }

  onTap() {
    // var url= model.value.buttonRedirect!;
    // if (url.isNotEmpty && !url.contains('http')) {
    //   url = '${AppValues.defaultBranch.api_url}/${globalController.getLangString().substring(0, 2)}/$url';
    // }
    // UrlLaunchUtil.launchURL(url).then((message) {
    //   if (message.isNotEmpty) {
    //     CustomToast.show(message, Get.context!);
    //   }
    // });
    CustomSportBannerState().customSportBanner_onTap(model.value.buttonType!, model.value.buttonRedirect!,true);
  }
}
