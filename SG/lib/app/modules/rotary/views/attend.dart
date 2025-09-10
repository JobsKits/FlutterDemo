import 'package:flutter_bet/app/modules/rotary/views/share_view.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/services/api/extension/activity_api_service.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../controllers/global_state_controller.dart';
import '../../../../routes/routes.dart';
import '../../../../services/api/api_service.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/button/custom_small_mian_button.dart';
import '../../../../widget/custom_ovalends_progressbar.dart';
import '../../../../widget/dialog/custom_safe_dialog.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../controllers/rotary_controller.dart';

const kCustomWinsViewWidget = 'WinsView';

class AttendView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _AttendViewViewState();
  }
}

class _AttendViewViewState extends State<AttendView> with SingleTickerProviderStateMixin {
  late RotaryController controller = Get.find<RotaryController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double progress(){
      if(controller.recordData?['achieved_roll_condition'] == null || controller.recordData?['roll_condition'] == null){
        return 0;
      }else{
        return double.parse(controller.recordData?['achieved_roll_condition']??"0") / controller.recordData?['roll_condition'];
      }
    }

    String numDoneRewards(){
      if(controller.recordData?['prize_roll_times'] == null){
        return "0";
      }else{
        return controller.numDoneRewards(controller.recordData?['prize_roll_times']);
      }
    }

    String dd(){
      if(controller.recordData?['achieved_roll_condition'] == null || controller.recordData?['roll_condition'] == null){
        return "0";
      }else{
        return "${double.parse(controller.recordData?['achieved_roll_condition']??"0")/ controller.recordData?['roll_condition']  * 100}%";
      }
    }

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
                const CustomAssetIcon(name: 'assets/images/rotary/pinwheel_icon.png',size: 16,),
                const SizedBox(width: 8,),
                CustomText(controller.termTypeStr,
                  style: const TextStyle(
                    color: AppThemes.widgetColorWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
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
                CustomText(controller.termTypeDesStr,     style: const TextStyle(
                    color: AppThemes.widgetColorWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                )),
                coinIcon(),
                CustomText(controller.numRewards(controller.recordData?['roll_times']??0),     style: const TextStyle(
                    color: AppThemes.widgetColorWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                )),
              ],
            ),
            const SizedBox(height: 16,),
            Row(
              children: [
                const SizedBox(width: 16,),
                CustomText(controller.progressDesStr,
                    style: const TextStyle(
                    color: AppThemes.widgetColorWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                )),
                coinIcon(),
                const Spacer(),
                CustomText(
                    // "${double.parse(controller.recordData['achieved_roll_condition']??"0")/ controller.recordData['roll_condition']  * 100}%",
                    dd(),
                    style: const TextStyle(
                    color: AppThemes.widgetColorWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                )),
                const SizedBox(width: 16,),
              ],
            ),
            const SizedBox(height: 5,),
            Container(
              width: double.infinity,
              height: 8,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: CustomPaint(
                painter: OvalEndsProgressBar(
                    progress: progress(),
                    // double.parse(controller.recordData['achieved_roll_condition']??"0") / controller.recordData['roll_condition'],
                    bgColor:ThemeService().colorScheme.surface), // 传入进度值
              ),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  controller.completeDesStr,
                  textColorStyle: CustomTextColorStyle.normal,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                coinIcon(),
                CustomText(
                  // controller.numDoneRewards(controller.recordData['prize_roll_times']),
                  numDoneRewards(),
                  textColorStyle: CustomTextColorStyle.normal,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: 20),
              child: CustomBigMainButton(
                onTap:(btn){
                  showCustomShareWidget(context: context);
                },
                textColor: AppThemes.black,
                colorStyle: CustomButtonColorStyle.tertiary,
                fontWeight: FontWeight.w600,
                title: "分享朋友",
               ),
            ),

          ],
        ),
      ),
    );
  }

  Widget coinIcon(){
    return  Visibility(
      visible: controller.rollType== 2|| controller.rollType==3||controller.rollType== 6|| controller.rollType==7,
      child: CustomNetWorkImage(
        width: 18,
        height: 18,
        imageUrl:
        "${controller.coinIcDomain}${controller.recordData['currency_id'] ?? "701"}${controller
            .coinIcExtensionName}",
      ),
    );
  }
}

Future<void> showCustomAttendViewWidget<T>({
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
            AttendView(),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}
