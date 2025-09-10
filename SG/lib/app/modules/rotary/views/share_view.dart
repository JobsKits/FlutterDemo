import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import '../../../../constant/app_values.dart';
import '../../../../widget/share/custom_share_widget_item.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_button.dart';
import '../../../../widget/dialog/custom_safe_dialog.dart';
import '../controllers/rotary_controller.dart';

const kCustomShareViewWidget = 'ShareView';
final GlobalKey _globalKeyCustomAssetIcon = GlobalKey();
class ShareView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShareState();
  }
}

class _ShareState extends State<ShareView> with SingleTickerProviderStateMixin {
  late RotaryController controller;

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
    if (Get.isRegistered<RotaryController>()) {
      controller = Get.find<RotaryController>();
    }else{
      controller = Get.put(RotaryController());
    }
    controller.getPhoneList();
    return Material(
      color: Colors.transparent,
      child: AnimatedPadding(
        padding: MediaQuery
            .of(context)
            .viewInsets,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: ThemeService().colorScheme.background,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  CustomText(S.current.random_text_834,/// 邀请好友帮忙提款
                      style: const TextStyle(
                          color: AppThemes.widgetColorWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  const Spacer(),
                  InkWell(
                    onTap: () => RouteUtil.popView(),
                    child: const CustomAssetIcon(
                      name: 'assets/images/bet_slip/ic_close_bet.webp',
                      size: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  // maxCrossAxisExtent: 54,
                  crossAxisCount: 5,
                  childAspectRatio: 1.0, //宽高比为2
                  mainAxisSpacing: 6, //主轴方向的间距
                  crossAxisSpacing: 6, //横轴方向子元素的间距
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: controller.shareModelList
                    .map((model) =>
                    CustomShareItemWidget(
                        model: model,
                        onItemClick: (model) =>
                            controller.onClickShareLaunchLink(context, model.typeEnum)))
                    .toList(),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                padding: const EdgeInsets.only(
                    left: AppValues.defaultMargin,
                    top: AppValues.halfMargin,
                    bottom: AppValues.halfMargin),
                // color: ThemeService().colorScheme.tertiary,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2, // 阴影模糊程度
                        offset: const Offset(0, 3), // 阴影偏移量
                      ),
                    ],
                    color: ThemeService().colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        return CustomText(
                          controller.getLink(),
                          // '123',
                          style: ThemeService().textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                    ),
                    // CustomAssetIcon(name: "assets/images/alliance/ic_alliance_copy.webp", size: 14),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppValues.defaultMargin, vertical: AppValues.halfMargin),
                        child: CustomAssetIcon(
                          key: _globalKeyCustomAssetIcon,
                          color: AppThemes.widgetColorWhite,
                          name: "assets/images/alliance/ic_alliance_copy.webp",
                          size: 12,
                        ),
                      ),
                      onTap: () => controller.onClickCopyLink(context,_globalKeyCustomAssetIcon),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              randomPlayer()
            ],
          ),
        ),
      ),
    );
  }

  Widget randomPlayer() {
    return Obx(() {
      return Visibility(
        visible: controller.phoneList.isNotEmpty ,
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 16),
                child: CustomText(S.current.random_text_1009,
                    style: const TextStyle(
                        color: AppThemes.onTertiaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500))),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.all(7),
              margin: const EdgeInsets.only(left: 16, right: 16),
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: ThemeService().colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(4)),
              child: phoneNumber(),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              height: 42,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: ThemeService().colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CustomAssetIcon(
                              name: "assets/images/rotary/whats_app_icon.png", size: 28),
                          const SizedBox(
                            width: 12,
                          ),
                          CustomButton(
                            fontWeight: FontWeight.w600,
                            textColor: AppThemes.oddBackColor,
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            title: "WhatsApp",
                            onTap: () {
                              controller.launchWhatsAppCall(
                                  controller.phoneList.isEmpty ? "8613683926820" : controller
                                      .phoneList[0]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: AppValues.defaultMargin,
                  ),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: ThemeService().colorScheme.primary,
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CustomAssetIcon(
                              name: "assets/images/rotary/sms_icon.png",
                              size: 28,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            CustomButton(
                              onTap: () {
                                log("neco 发送短信");
                                controller.sendMsg(
                                    controller.getLink(),
                                    controller.phoneList.isEmpty ?
                                    ['+639193945192'] : controller.phoneList,
                                    context);
                              },
                              textColor: AppThemes.widgetColorWhite,
                              fontWeight: FontWeight.w600,
                              padding: const EdgeInsets.only(top: 12, bottom: 12),
                              title: S.current.random_text_1010,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget phoneNumber() {
    return Obx(() {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount
          (mainAxisSpacing: 5, crossAxisSpacing: 5, childAspectRatio: 5, crossAxisCount: 3),
        itemCount: controller.phoneList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: CustomText(
              controller.phoneList[index],
              style: const TextStyle(fontSize: 12),
            ),
          );
        },
      );
    });
  }
}

Future<void> showCustomShareWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomShareViewWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return ShareDialog();
        //   Column(
        //   mainAxisSize: MainAxisSize.min,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Expanded(child: GestureDetector(
        //       onTap: () {
        //         print("AAAAAQ");
        //         RouteUtil.popView();
        //       },
        //     )),
        //     ShareView(),
        //     Expanded(child: GestureDetector(
        //       onTap: () {
        //         print("AAAAAQ");
        //         RouteUtil.popView();
        //       },
        //     )),
        //   ],
        // );
      });
}

class ShareDialog extends StatefulWidget {
  @override
  _ShareDialogState createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CommonUtil.buildLoadingView()
        : Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              print("AAAAAQ");
              RouteUtil.popView();
            },
          ),
        ),
        ShareView(),
        Expanded(
          child: GestureDetector(
            onTap: () {
              print("AAAAAQ");
              RouteUtil.popView();
            },
          ),
        ),
      ],
    );
  }
}
