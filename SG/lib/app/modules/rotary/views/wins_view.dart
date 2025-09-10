import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/services/api/extension/activity_api_service.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../controllers/global_state_controller.dart';
import '../../../../routes/routes.dart';
import '../../../../services/api/api_service.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_small_mian_button.dart';
import '../../../../widget/custom_ovalends_progressbar.dart';
import '../../../../widget/dialog/custom_safe_dialog.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import 'share_view.dart';

const kCustomWinsViewWidget = 'WinsView';

class WinsView extends StatefulWidget {
  const WinsView({super.key,this.bonus = 0,this.id = '256610365262037311'});
  final double? bonus;
  final String? id;

  @override
  State<StatefulWidget> createState() {
    return _WinsViewState();
  }
}

class _WinsViewState extends State<WinsView> with SingleTickerProviderStateMixin {
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  var coinIcDomain = '${AppValues.defaultBranch.asset_url}/currency/';
  var coinIcExtensionName = ".webp";
  var recordData = {};
  var symbol = '';
  String x = "";

  @override
  void initState() {
    super.initState();
    getRecord();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getRecord() async {
    await ApiService.instance.getRecord(
      success: (record) {
        setState(() {
          recordData = record;
        });
        getCurrencySymbol();
        x = getShortfallAmount();
      },
      fail: (errorMessage) {
        
      },
      pid: widget.id!);
  }
  String getShortfallAmount(){
    double amount;
    String totalPrizeStr =   recordData['total_prize'] ?? "0.0";
    double totalPrize = double.parse(totalPrizeStr);
    if (totalPrize <  widget.bonus!) {
      amount = 0;
    } else {
      amount = double.parse(recordData['total_prize'] ?? "0.0") -
          widget.bonus!;
    }
    return amount.toStringAsFixed(2);
  }

  void getCurrencySymbol() {
    for (int i = 0; i < globalController.currTypeInitialLists.length; i++) {
      if (recordData['currency_id'].toString() == globalController.currTypeInitialLists[i].cur) {
        symbol = globalController.currTypeInitialLists[i].symbol ?? "";
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: ThemeService().colorScheme.background,
        ),
        child: Column(
          children: [
            const SizedBox(height: 16,),
            Row(
              children: [
                const SizedBox(width: 16,),
                const CustomAssetIcon(name: 'assets/images/rotary/pinwheel_icon.png',size: 18,),
                const SizedBox(width: 8,),
                CustomText(S.current.random_text_839,
                  style: const TextStyle(
                    color: AppThemes.widgetColorWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  )
                ),
                const Spacer(),
                InkWell(
                  onTap: () => RouteUtil.popView(),
                  child: const CustomAssetIcon(name: 'assets/images/bet_slip/ic_close_bet.webp',size: 18,),
                ),
                const SizedBox(width: 16,),
              ],
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomNetWorkImage(imageUrl: "${coinIcDomain}${recordData['currency_id'] ?? "701"}$coinIcExtensionName",width: 18,height: 18,),
                const SizedBox(width: 5,),
                CustomText(S.current.random_text_1304)
              ],
            ),
            const SizedBox(height: 16,),
            CustomText(S.current.random_text_1305,textColorStyle: CustomTextColorStyle.normal,),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomAssetIcon(name: 'assets/images/rotary/bill_icon.png',size: 37,),
                const SizedBox(width: 10,),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: widget.bonus), // 使用起始数字
                  duration: const Duration(seconds: 2),
                  builder: (BuildContext context, double value, Widget? child) {
                    return CustomText(
                      value.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 32),
                    );
                  },
                ),
                const SizedBox(width: 10,),
                CustomNetWorkImage(imageUrl: "${coinIcDomain}${recordData['currency_id'] ?? "701"}$coinIcExtensionName",width: 32,height: 32,),
              ],
            ),

            const SizedBox(height: 5,),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: AppValues.padding_16),
                child: CustomText('${widget.bonus!}%',style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
              ),
            ),
            Container(
              width: double.infinity,
              height: 8,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: CustomPaint(
                painter: OvalEndsProgressBar(progress: widget.bonus!/100>1?1:widget.bonus!/100, bgColor:ThemeService().colorScheme.surface), // 传入进度值
              ),
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 转入至钱包仍需
                CustomText(S.current.random_text_1320+
                    '$x ',style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),textColorStyle: CustomTextColorStyle.normal,),
                CustomNetWorkImage(imageUrl: "${coinIcDomain}${recordData['currency_id'] ?? "701"}$coinIcExtensionName",width: 14,height: 14,),
              ],
            ),
            const SizedBox(height: 16,),
            CustomSmallMainButton(
              textColor:  AppThemes.black,
              padding: const EdgeInsets.only(top: 12,bottom: 12 ),
              backgroundColor: AppThemes.primaryContainer,
              maxWidth: 400,
              fontWeight: FontWeight.w600,title: "\t\t\t${S.current.random_text_854}\t\t\t",
              onTap: () {
                // RouteUtil.popView();
                // RouteUtil.pushToView(Routes.rotary,arguments: {'id': widget.id});
                showCustomShareWidget(context: context);
              },
             ),

            Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: ThemeService().colorScheme.surface,
              ),
              padding: const EdgeInsets.only(top: 22,bottom: 22),
              margin: const EdgeInsets.only(top: 16),
              child:  CustomText(S.current.random_text_841,textColorStyle: CustomTextColorStyle.normal,),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showCustomWindsWidget<T>({
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  double bonus = 0,
  String id = '',
}) async {
  await CustomSafeDialog.show<T>(
      context: Get.context!,
      tag: kCustomWinsViewWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
            WinsView(id: id,bonus: bonus,),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}
