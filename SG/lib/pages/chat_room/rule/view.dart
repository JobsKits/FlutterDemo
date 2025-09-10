import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:get/get.dart';
import '../../../constant/app_themes.dart';
import '../../../controllers/global_state_controller.dart';

class ChatRoomRuleWidget extends StatelessWidget {
  final double maxHeight;
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  ChatRoomRuleWidget({super.key, this.maxHeight = 400});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              child: Container(
                color: Colors.transparent,
              ),
              onTap: () => RouteUtil.popView(),
            ),
            Center(
              child: SingleChildScrollView(
                child: (Get.height > 850 && Get.width > 390 && globalController.isChinese()) ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
                  decoration: BoxDecoration(
                    color: ThemeService().theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(AppValues.smallRadius),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [_buildTop(), _buildBody(context)],
                    ),
                  ),
                ) : Container(
                  height: (Get.height > 850 && Get.width > 390 && !globalController.isChinese()) ? 620 : 480,
                  margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
                  decoration: BoxDecoration(
                    color: ThemeService().theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(AppValues.smallRadius),
                  ),
                  child: Column(
                    children: [
                      _buildTop(), 
                      Expanded(
                        child: SingleChildScrollView(child: _buildBody(context)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          const SizedBox(
            width: AppValues.defaultMargin,
          ),
          CustomAssetIcon(
            name: 'assets/images/chat_room/ic_rule_top.png',
            color: CustomTextColorStyle.panda.value,
          ),
          const SizedBox(
            width: 6,
          ),
          CustomText(
            S.current.random_text_257,
            textColorStyle: CustomTextColorStyle.panda,
            style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.w600),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  RouteUtil.popView();
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: AppValues.defaultMargin),
                  child: CustomIcon(
                    asset: 'assets/images/normal/ic_normal_close.png',
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var ruleList = [S.current.random_text_564,
                    S.current.random_text_565,
                    S.current.random_text_566,
                    S.current.random_text_567,
                    S.current.random_text_568,
                    S.current.random_text_569,
                    S.current.random_text_570,
                    S.current.random_text_571,
                    S.current.random_text_572,
                    S.current.random_text_573,
                    S.current.random_text_574,
                    S.current.random_text_575,];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ruleList.map((e) => Container(
               margin: const EdgeInsets.only(bottom: AppValues.halfMargin),
               child: CustomText(e,textColorStyle: CustomTextColorStyle.normal,style:const TextStyle(height: 1.5))
            )).toList(),
          ),
          const SizedBox(height: AppValues.defaultPadding,),
          RichText(
            text: TextSpan(
              text: S.current.random_text_576,
              style: const TextStyle(color: AppThemes.textColorSecondary),
              children: [
                WidgetSpan(
                  child: CustomText(S.current.home_forum,style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13
                    ))
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppValues.halfMargin),
                    child: Image.asset('assets/images/chat_room/ic_rule_link.png',height: 12,),
                  )
                ),
                WidgetSpan(
                  child: CustomText(
                    S.current.random_text_577,
                    textColorStyle: CustomTextColorStyle.normal,
                    style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontSize: 13)
                  )
                ),
              ]
            ),
          ),
          const SizedBox(height: AppValues.defaultMargin,),
        ],
      ),
    );
  }
}

Future<void> showCustomChatRoomRuleWidgetWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  // String errorText = '',
  Function(BuildContext context)? onBuild,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return ChatRoomRuleWidget();
      });
}
