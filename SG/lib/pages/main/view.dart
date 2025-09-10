import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/chat_room/index/view.dart';
import 'package:flutter_bet/pages/find/view.dart';
import 'package:flutter_bet/pages/home/home_view.dart';
import 'package:flutter_bet/pages/main/widget/main_page_bottom_bar_widget.dart';
import 'package:flutter_bet/pages/sport/view.dart';
import 'package:flutter_bet/pages/betting/betting_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/global_state_controller.dart';
import '../activity/a_model/activity_quick_api_model.dart';
import '../activity/a_widget/custom_floating_action_widget.dart';
import 'logic.dart';
import 'code.dart';
import 'widget/custom_floating_action_button_location.dart';

class MainPage extends BaseView<MainLogic> {
  MainPage({Key? key}) : super(key: key);
  final GlobalStateController appController = Get.find<GlobalStateController>();
  var offset = 0.0;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget buildBody(BuildContext context) {
    controller.context = context;
    return Container(
      key: UniqueKey(),
      child: Obx(() => getPageOnSelectedMenu(controller.selectedMenuCode)),
    );
    // return Scaffold(
    //   body: Obx(() => PageTransitionSwitcher(
    //     transitionBuilder: (child, primaryAnimation, secondaryAnimation) => SlideTransition(
    //       position: primaryAnimation.drive(
    //         Tween<Offset>(
    //           begin: const Offset(0.0, 1.0), // Start from bottom
    //           end: Offset.zero, // End at the top
    //         ).chain(CurveTween(curve: Curves.easeInOut)),
    //       ),
    //       child: child,
    //     ),
    //     child: getPageOnSelectedMenu(controller.currentIndex),
    //   )),
    // );
  }

  @override
  FloatingActionButtonLocation? floatingActionButtonLocation() {
    return CustomFloatingActionButtonLocation(
      location: FloatingActionButtonLocation.endFloat,
      offsetX: 4,
      offsetY: -60,
    );
  }

  @override
  Widget? floatingActionButton() {
    return _buildFloatingActionView();
  }

  Widget _buildFloatingActionView() {
    return Obx(() {
      return CustomFloatingActionWidget(
        // isShowActivityQuick()
        isShow: logic.isShowActivityQuick(),
        // isShow:true,
        modelList: logic.activityFloatListObs,
        onClickItem: (ActivityQuickApiModel model) {
          logic.onQuickActivityItemClick(model);
        },
        onClickClose: () {
          logic.onQuickActivityClickClose();
        },
      );
    });
  }

  ///bottom navigation bar
  @override
  Widget? bottomNavigationBar() {
    return Container(
      height: AppValues.barBottomHeight,
      child: MainPageBottomBarWidget(
        onMenuTap: (int code) {
          controller.onMenuSelected(MenuCode.values[code]);
          bool isShow = (code == 0 || code == 1 || code == 3);
          appController.showOverlayView(isShowTopBarView: isShow);
          if (code == 3) {
            Future.delayed(const Duration(milliseconds: 20), () {
              msgView.controller.state.sc.jumpTo(offset);
            });
          } else {
            if (msgView.controller.state.sc.hasClients) {
              offset = msgView.controller.state.sc.offset;
            }
          }
        },
        initSelectdIndex: 1,
        controller: controller.bottomBarController,
      ),
    );
  }

  final homeMenuView = HomeMenuPage();
  final gameView = GamePage();
  final bettingView = BettingPage();
  final msgView = MessagePage();

  // final mineView = MinePage();
  // final casinoBetView = BettingCasinoPage();
  // final sportBetView = BettingSportPage();
  final chatRoomView = ChatRoomPage();

  // final frontView = FrontPage();

  // final testView = HomeMenuPage();

  Widget getPageOnSelectedMenu(MenuCode menuCode) {
    switch (menuCode) {
      case MenuCode.HOME_MENU:
        return homeMenuView;
      case MenuCode.GAME:
        return gameView;
      case MenuCode.BETTING:
        return bettingView;
      case MenuCode.MSG:
        return msgView;
      case MenuCode.MINE:
        return chatRoomView;
      // case MenuCode.FRONT:
      //   return frontView;
      default:
        return gameView;
    }
  }
}
