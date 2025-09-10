import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/pages/find/widget/casino_main_view.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../controllers/global_state_controller.dart';
import '../../widget/custom_app_life_cycle_listen_widget.dart';
import '../../widget/custom_top_appbar_view.dart';
import 'logic.dart';

///娱乐城页面
class GamePage extends BaseView<FindLogic> {
  final GlobalStateController globaController = Get.find<GlobalStateController>();

  GamePage({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      titleSpacing: 12.0,
      titleView: CustomTopAppBarView(
        onTap: () => globaController.onArticleCollect(),
        onTapLogo: () {
          controller.scrollcontroller
              .animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
      ),
      showLeading: false,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return CustomAppLifeCycleListenWidget(

        ///切换投注单页面为娱乐城投注
        didChangeDependencies: () {
          globaController.betSlipType.value = 0;
          globaController.menuSelectType.value = 0;
          globaController.showMenuImage.value = false;
        },
        child: VisibilityDetector(
          key: const Key('GamePage'),
          onVisibilityChanged: (visibilityInfo) {
            var visiblePercentage = visibilityInfo.visibleFraction * 100;
            globaController.isInRecreationView.value = visiblePercentage > 99;
          },
          child: Stack(
            children: [
              GetBuilder<FindLogic>(
                  id: 'yulecheng_home_page',
                  builder: (context1) {
                    return CasinoMainView(
                      data: controller.state,
                    );
                  }),
            ],
          ),
        ));
  }
}
