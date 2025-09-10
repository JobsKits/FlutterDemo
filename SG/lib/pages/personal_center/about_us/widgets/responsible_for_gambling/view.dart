import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../routes/routes.dart';
import '../../../../../services/theme/theme_service.dart';
import '../../../../../utils/route_util.dart';
import '../../../../../widget/app_bar/custom_app_bar.dart';
import 'package:get/get.dart';

import '../../../../../widget/app_bar/custom_app_bar_h5.dart';
import '../../../../../widget/custom_text.dart';
import '../../../../../widget/tab_bar/custom_tabbar_covered.dart';
import 'index.dart';

class ResponsibleForGamblingPage extends GetView<ResponsibleForGamblingController> {
  const ResponsibleForGamblingPage({Key? key, this.showAppBar = true}) : super(key: key);

  final bool? showAppBar;

  ///打开页面
  static openPage() {
    RouteUtil.pushToView(Routes.personalResponsible);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResponsibleForGamblingController>(
      init: ResponsibleForGamblingController(),
      id: "responsible_for_gambling",
      builder: (_) {
        return Scaffold(
          // appBar: showAppBar! ? CustomAppBar(appBarTitleText: S.current.responsible_for_gambling) : null,
          appBar: showAppBar!
              ? CustomAppBar(appBarTitleText: S.current.responsible_for_gambling)
              : null,
          body: _buildView(),
        );
      },
    );
  }

  // 主视图
  Widget _buildView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppValues.defaultMargin),
        CustomAppBarH5(
          icon: "assets/images/personal_center_icon/ic_responsible_title.webp",
          title: S.current.responsible_gaming,
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppValues.defaultPadding,
            vertical: AppValues.margin_12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(49),
            color: ThemeService().theme.colorScheme.surface, // 设置背景色
          ),
          child: Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(49),
              color: ThemeService().theme.colorScheme.tertiary,
            ),
            child: CustomText(
              S.current.random_text_1176,
              style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),

          // CustomTabBarCoveredIcon(
          //   // isLogin: true,
          //   tabController: controller.tabController,
          //   // controller: controller.tabController,
          //   // 将TabController与TabBar关联
          //   tabs: [
          //     Tab(
          //       child: CustomText(
          //         "Meibo Safe",
          //         style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
          //               color: Colors.white,
          //               fontSize: 16,
          //               fontWeight: FontWeight.w600,
          //             ),
          //       ),
          //     )
          //   ],
          //   backgroundColor: ThemeService().theme.colorScheme.tertiary,
          //   radius: 44,
          //   height: 54,
          //   buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
          //   contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          //   sideMargin: const EdgeInsets.symmetric(horizontal: 12),
          // ),
        ),
        Expanded(
          child: Container(
              margin: showAppBar!
                  ? EdgeInsets.only(
                      // top: AppValues.defaultMargin,
                      left: AppValues.defaultMargin,
                      right: AppValues.defaultMargin,
                      bottom: AppValues.barBottomHeightMargin)
                  : const EdgeInsets.only(bottom: AppValues.defaultMargin),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppValues.smallRadius),
                child: InAppWebView(
                  initialFile: controller.getFile(),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(transparentBackground: true),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
