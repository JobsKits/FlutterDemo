import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/home/nav/nav_casino_view.dart';
import 'package:flutter_bet/pages/home/widget/search_detail_view.dart';
import 'package:flutter_bet/pages/home/widget/search_function.dart';
import 'package:flutter_bet/pages/home/widget/search_title_view.dart';
import 'package:flutter_bet/pages/home/nav/nav_sport_view.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/custom_top_appbar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/global_state_controller.dart';
import 'home_logic.dart';

///首页菜单页
class HomeMenuPage extends BaseView<HomeLogic> {
  final logic = Get.find<HomeLogic>();
  final state = Get.find<HomeLogic>().state;
  final GlobalStateController globaController = Get.find<GlobalStateController>();

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      titleSpacing: 12.0,
      titleView: CustomTopAppBarView(
        onTap: () => globaController.onArticleCollect(),
        onTapLogo: () {

        },
      ),
      showLeading: false,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    ///切换语言后重新实例化本地数据，只能放在build内才会生效
    state.buildData();
    return Container(
      color: ThemeService().theme.colorScheme.surface,
      // margin: EdgeInsets.only(bottom: AppValues.barBottomHeight),
      child: Column(
        children: [
          const SizedBox(height: 16),

          ///搜索栏
          SearchTitleView(
            onChanged: (string) {
              state.searchContent.value = string;
              if (string.length > 2) {
                controller.search();
              } else {
                state.showSearchType.value = 0;
              }
            },
            onClean: () {
              controller.onClean();
            },
            textController: state.textController,
          ),

          searchBuildInfoBg(children: [
            ///搜索详情页
            SearchDetailView(
              data: state,
            ),

            ///娱乐城导航
            NavCasinoView(
              data: state,
            ),

            ///体育导航
            NavSportView(
              data: state,
            ),
          ]),
        ],
      ),
    );
  }
}
