import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/setup/widgets/setup_tab_bar_widget.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/widget/custom_top_appbar_view.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class AboutUsPage extends BaseView<AboutUsController> {
  AboutUsPage({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      titleSpacing: 12.0,
      titleView: CustomTopAppBarView(
        isShowLogo: true,
      ),
      showLeading: false,
    );
    // return CustomAppBar(
    //   appBarTitleText: S.current.about_us,
    // );
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: ThemeService().theme.scaffoldBackgroundColor,
        ),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      margin: EdgeInsets.only(bottom: AppValues.barBottomHeight),
      child:Obx(() => SetupTabBarWidget(
        pageIndex: controller.pageIndex.value,
        tabController: controller.tabController,
        tabs: controller.tabs,
        children: const [
          // CommunityPage(),
          PrivacyPolicyPage(),
          TermsOfServicePage(),
          ResponsibleForGamblingPage(showAppBar: false,),
          // FairnessPage(),
          SportsBettingRulesPage(),
          VersionNumberPage()
        ],
      )),
    );
  }
}
