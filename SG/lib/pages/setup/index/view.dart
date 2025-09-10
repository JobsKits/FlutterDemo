import 'dart:math';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/pages/setup/index/logic.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/custom_top_appbar_view.dart';

import '../../../constant/app_themes.dart';
import '../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/setup/2FA/google/view.dart';
import 'package:flutter_bet/pages/setup/contact/view.dart';
import 'package:flutter_bet/pages/setup/login_log/view.dart';
import 'package:flutter_bet/pages/setup/password/view.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/constant/app_common.dart';

import '../../../utils/keyboard_util.dart';
import '../../../utils/route_util.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/dialog/dialog_utils.dart';

class SetupPage extends BaseView<SetupLogic> {

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final _monthGlobalKey = GlobalKey();

  SetupPage({super.key});

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }
  
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return CustomAppBar(
      titleSpacing: 12.0,
      titleView: CustomTopAppBarView(
        isShowLogo: true,
      ),
      showLeading: false,
    );
    // return CustomAppBar(
    //   appBarTitleText: S.current.setting,
    // );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: _buildView(),
      ),
    );
    // return GetBuilder<SetupLogic>(
    //   init: SetupLogic(),
    //   id: "setup",
    //   builder: (_) {
    //     return _buildView();
    //   },
    // );
  }

  // 主视图
  Widget _buildView() {
    // controller.buildData();
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppValues.padding_10,vertical: AppValues.largePadding),
            child: Obx(() => Column(
              children: [
                buildTop(),
                const SizedBox(height: AppValues.defaultMargin,),
                if (controller.showIndex.value > 9)
                _buildBody(),
                if (controller.showIndex.value < 9)
                buildBack(),
                if (controller.showIndex.value == 0)
                SetupContactPage(),
                if (controller.showIndex.value == 1)
                ModifyPasswordPage(),
                if (controller.isCheck.value && controller.showIndex.value == 2) 
                SetupGoogle2FAPage(),
                if (controller.showIndex.value == 3 || (!controller.isCheck.value && controller.showIndex.value == 2))
                LoginLogPage(),
              ],
            )),
          )
        ),
        Positioned.fill(
          child: Obx(() => controller.showCode.value ? codeWidget() : Container()) 
        )
      ],
    );
  }  

  /// title
  Widget buildTop() {
    return Row(
      children: [
        const CustomAssetIcon(
          name: 'assets/images/personal_center_icon/set_up.webp',
          size: 22,
        ),
        const SizedBox(width: 8,),
        CustomText(S.current.setting,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
        const Spacer(),
        GestureDetector(
          onTap: controller.onTap,
          child: const CustomIcon(asset: 'assets/images/normal/ic_normal_close.png',size: 20,)
        ),
      ],
    );
  }

  /// 菜单
  Widget _buildBody() {
    return Obx(() => Container(
      height: 44.0 * controller.list.length,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
        color: ThemeService().colorScheme.surface,
      ),
      child: ListView.builder(
        itemCount: controller.list.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => controller.showChild(index),
            child: Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: controller.index.value == index ? ThemeService().colorScheme.primary : Colors.transparent,width: 4))
              ),
              alignment: Alignment.centerLeft,
              child: CustomText(controller.list[index],style: const TextStyle(fontWeight: FontWeight.w600),),
            ),
          ));
        },
      ),
    ));
  }

  /// 返回主菜单
  Widget buildBack() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.defaultMargin),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => controller.showIndex(100),
            child: Container(
              width: 48,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppValues.smallRadius),
                color: ThemeService().colorScheme.surface,
              ),
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: pi/2,
                child: const CustomAssetIcon(
                  name: "assets/images/top_drop_down arrow.png",
                  size: 18,
                ),
              )
            ),
          ),
          const SizedBox(width: AppValues.halfMargin,),
          GestureDetector(
          onTap: () async {
            _startAnimation(_rotatingArrowKey);

            ///有弹出键盘，先关闭键盘
            if (controller.isKeyboardVisible) {
              KeyboardUtils.hideKeyboard(Get.context!);
              await Future.delayed(const Duration(milliseconds: 300));
            }
            Future.delayed(const Duration(milliseconds: 100), () {
              DialogUtils.showCustomBubbleDialog(
                  Get.context!,
                  _buildAreaList(Get.context!),
                  // bubbleWith,
                  controller.globalController.isChinese() ? 100 : 150,
                  // arrowBasisOffset: -70,
                  // bubbleLeftOffset: AppValues.defaultMargin,
                  widgetKey: _monthGlobalKey,
                  // backgroundColor: ThemeService().colorScheme.tertiary,
                  globalKey: _rotatingArrowKey
                // globalKey: widget._rotatingArrowKey,
              );
            });
          },
          child: Container(
            height: 40,
            key: _monthGlobalKey,
            padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppValues.smallRadius),
              color: ThemeService().colorScheme.surface,
            ),
            child: Row(
              children: [
                Obx(() =>  CustomText(controller.list[controller.index.value],style: const TextStyle(fontWeight: FontWeight.w600),)),
                RotatingArrow(key: _rotatingArrowKey),
              ],
            ),
          )
        ),
        ],
      ),
    );
  }

  Widget _buildAreaList(BuildContext context) {
    return Scrollbar(
      radius: const Radius.circular(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => Container(
              constraints: BoxConstraints(
                maxHeight: 44.0 * controller.list.length,
              ),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 6),
                itemCount: controller.list.length,
                itemBuilder: (context, index) {
                  final code = controller.list[index];
                  return GestureDetector(
                    onTap: () {
                      RouteUtil.popView();
                      controller.showChild(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 6, left: 6, right: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        // color: month['isSelected'] == true
                        //     ? ThemeService().colorScheme.secondary
                        //     : null,
                      ),
                      alignment: controller.globalController.isChinese() ? Alignment.center : Alignment.centerLeft,
                      height: 34,
                      // width: double.infinity,
                      child: (index == controller.index.value) ? CustomText(code, style: const TextStyle(color: AppThemes.skyBlue),) : CustomText(code, style: const TextStyle(color: AppThemes.black),),
                    ),
                  );
                }
              )
            )),
          ],
        )
      ),
    );
  }

  Widget codeWidget() {
    return GestureDetector(
      onTap: () => controller.showCode(false),
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppValues.smallRadius),
            child: Container(
              color: Colors.white,
              child: _buildCodeList(Get.context!),
            ),
          )
        )
      ),
    );
  }

  Widget _buildCodeList(BuildContext context) {
    return Scrollbar(
      radius: const Radius.circular(10),
      child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: AppValues.margin_10),
              CustomText(
                S.current.random_text_1164,
                style: const TextStyle(color: Color(0xffa7a7a7)),
              ),
              Container(
                  width: controller.globalController.isThai() ? 180 : 120,
                  color: Colors.white,
                  constraints: const BoxConstraints(
                    maxHeight: 500,
                  ),
                  child: Obx(() =>
                      ListView.builder(
                          controller: controller.scrollController,
                          padding: const EdgeInsets.only(bottom: 6),
                          itemCount: controller.showArray.length,
                          itemBuilder: (context, index) {
                            final code = controller.showArray[index];
                            return GestureDetector(
                              onTap: () => controller.onSelectAreaCode(index),
                              child: Container(
                                  margin: const EdgeInsets.only(top: 6, left: 6, right: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    // color: month['isSelected'] == true
                                    //     ? ThemeService().colorScheme.secondary
                                    //     : null,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  height: 34,
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Obx(() =>
                                          CustomIcon(
                                            asset: 'assets/images/login/gou.png',
                                            color: controller.areaCodeText.value.contains(
                                                code.attr!)
                                                ? AppThemes.black
                                                : Colors.transparent,
                                            size: 16,
                                          )),
                                      CustomText(
                                        code.attr!,
                                        style: const TextStyle(color: AppThemes.black),
                                      ),
                                    ],
                                  )
                                ),
                            );
                          }))),
            ],
          )),
    );
  }
}
