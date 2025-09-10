import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/pages/main/code.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_top_appbar_logo_title_view.dart';
import 'package:flutter_bet/widget/custom_top_appbar_view.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../../widget/app_bar/custom_app_bar.dart';
import 'widgets/casino_game_list.dart';
import 'index.dart';

class YulechengcategorypagePage extends BaseView<YulechengcategorypageController> {
  // 主视图
  Widget _buildView() {
    return buildFavorite();
  }

// 加载收藏夹
  Widget buildFavorite() {
    return CasinoGameList(
      name: controller.currentPageTitle.value,
      state: controller.state,
      onsortTap: controller.selectedSortType,
      onPlatTap: controller.selectedCheckBox,
      controller: controller,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder<YulechengcategorypageController>(
      init: YulechengcategorypageController(),
      id: "yulechengcategorypage",
      builder: (_) {
        return _buildView();
      },
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
        // titleView: Obx(() => Text(controller.currentPageTitle.value,
        //     style: ThemeService()
        //         .theme
        //         .appBarTheme
        //         .titleTextStyle
        //         ?.copyWith(fontWeight: FontWeight.w600))),
        titleSpacing: 12.0,
        showLeading: false,
        // onBackTap: () {
        //   RouteUtil.popToFirst(Routes.mainPage);
        //   return;
        // },
        titleView: CustomTopAppBarLogoTitleView(
          title: controller.currentPageTitle.value,
          logoTap: () {
            RouteUtil.popToFirst(Routes.mainPage);
            return;
          },
        ));
  }
}
