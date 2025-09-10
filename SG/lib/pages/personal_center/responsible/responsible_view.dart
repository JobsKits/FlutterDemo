import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/personal_center/responsible/responsible_tab_view.dart';
import 'package:flutter_bet/pages/personal_center/responsible/view/self_exclusion_time_view.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../base/getx/base_view.dart';
import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../routes/routes.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../utils/url_launch_util.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/dialog/custom_safe_dialog.dart';
import 'reponsible_view_test.dart';
import 'responsible_logic.dart';
import 'view/responsible_close_view.dart';
import 'view/self_exclusion_detail_view.dart';

///对外显示页面方法
Future<void> showResponsibleWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kResponsiblePage,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return ResponsiblePage(key: responsibleGlobalKey);
        // return ResponsiblePageView();
      });
}

void dismissResponsibleWidget({required BuildContext context}) {
  CustomSafeDialog.dismiss(context: context, tag: kResponsiblePage);
}

///负责人博彩  Responsible
const kResponsiblePage = 'kResponsiblePage';
//提供全局唯一key, 是到时候给里面内容的选择弹框计算用
final GlobalKey responsibleGlobalKey = GlobalKey();

class ResponsiblePage extends BaseView<ResponsibleLogic> {
  ResponsiblePage({Key? key}) : super(key: key);

  final logic = Get.find<ResponsibleLogic>();
  final state = Get.find<ResponsibleLogic>().state;

  ///打开页面
  static openPage() {
    // if (isWeb != null && isWeb) {
    //   UrlLaunchUtil.launchURL(
    //     "https://www.tfdjqp.com/zh/responsible-gambling/safe",
    //     mode: LaunchMode.inAppWebView,
    //   );
    // }else{
    //   RouteUtil.pushToView(Routes.personalResponsible);
    // }

    UrlLaunchUtil.launchURL(
      "https://www.tfdjqp.com/zh/responsible-gambling/safe",
      mode: LaunchMode.inAppWebView,
    );

  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      titleView: Text(S.current.responsible_gaming),
      showLeading: true,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Column(
        children: [
          _buildTop(context),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                log('约束信息：_buildContent...$constraints');
                return _buildContent();
              },
            ),
          ),
          // _buildContent(),
        ],
      ),
    );
  }

  _buildTop(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: AppValues.largePadding,
        left: AppValues.defaultMargin,
        right: AppValues.defaultMargin,
        bottom: AppValues.defaultPadding,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomIcon(
            color: AppThemes.iconColor,
            asset: "assets/images/personal_center_icon/ic_responsible_tip.webp",
            size: 18,
          ),
          const SizedBox(
            width: 4,
          ),
          Obx(() {
            return CustomText(
              controller.indexedStackTitle.value,
              style: ThemeService()
                  .theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w500, fontSize: AppValues.fontTileSmallSize),
            );
          }),
          Expanded(child: SizedBox()),
          GestureDetector(
            onTap: () {
              // CustomSafeDialog.dismiss(context: context,tag: kResponsiblePage);
              // RouteUtil.popView();
              controller.onClickCloseLabel();
            },
            child: CustomIcon(
              asset: 'assets/images/normal/ic_normal_close.png',
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  _buildContent() {
    return Obx(() {
      return IndexedStack(
        index: controller.indexedStack.value,
        // sizing: StackFit.passthrough,
        // sizing: StackFit.loose,
        // index: 0,
        // 居中对齐，可以看上篇各种对齐方式详解
        // alignment: Alignment.center,
        children: [
          Offstage(offstage: controller.indexedStack.value != 0, child: ResponsibleTabView()),
          Offstage(offstage: controller.indexedStack.value != 1, child: SelfExclusionDetailView()),
          Offstage(offstage: controller.indexedStack.value != 2, child: SelfExclusionTimeView()),
        ],
      );
    });
  }
}
