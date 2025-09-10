import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/pages/find/widget/casino_banner.dart';
import 'package:flutter_bet/pages/front/widget/front_banner.dart';
import 'package:flutter_bet/pages/front/widget/front_casino_competition_view.dart';
import 'package:flutter_bet/pages/front/widget/front_casino_page_view_one.dart';
import 'package:flutter_bet/pages/front/widget/front_content.dart';
import 'package:flutter_bet/pages/front/widget/front_tabbar.dart';
import 'package:flutter_bet/pages/front/widget/front_title.dart';
import 'package:flutter_bet/pages/front/widget/front_virtual_currency.dart';
import 'package:flutter_bet/widget/betting_list/custom_bet_list.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../constant/app_values.dart';
import '../../controllers/global_state_controller.dart';
import '../../generated/l10n.dart';
import '../../services/theme/theme_service.dart';
import '../../widget/app_bar/custom_app_bar.dart';
import '../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../widget/custom_marquee.dart';
import '../../widget/custom_top_appbar_view.dart';
import '../account/login/login_widget.dart';
import '../find/widget/casino_changguan_flip_list.dart';
import '../find/widget/casino_page_flip_list.dart';
import '../personal_center/wallet/custom_wallet.dart';
import 'front_logic.dart';

class FrontPage extends BaseView<FrontLogic> {
  FrontPage({super.key});

  final GlobalStateController globalController = Get.find<GlobalStateController>();

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      titleSpacing: 12.0,
      titleView: CustomTopAppBarView(
        onTap: () => () {},
      ),
      showLeading: false,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder(
        id: "front_view_vip",
        init: FrontLogic(),
        builder: (context) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    FrontTitle(),
                    SizedBox(
                      height: globalController.isLogin.value ? 0 : AppValues.margin_20,
                    ),
                    Visibility(
                        visible: !globalController.isLogin.value,
                        child: Image.asset('assets/images/home/banner_defalut.webp')),
                    // FrontBanner(data: controller.state.banners),
                    SizedBox(
                      height: globalController.isLogin.value ? 0 : AppValues.defaultMargin,
                    ),
                    buildMarqueeWidget(),
                    FrontContent(
                      callback: (name) {
                        controller.goToMain(name);
                      },
                    ),
                    const SizedBox(
                      height: AppValues.defaultMargin,
                    ),
                    // buildDaTingView(),
                    const SizedBox(
                      height: AppValues.margin_20,
                    ),
                    CustomBetList(),
                  ],
                ),
              ),
              // const SizedBox(
              //   height: AppValues.margin_12,
              // ),
            ],
          );
        });
  }

  buildDaTingView() {
    return GetBuilder(
        init: FrontLogic(),
        builder: (controller) {
          return <Widget>[
            controller.yulechengModel.items == null
                ? const SizedBox()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.yulechengModel.items?.length,
                    itemBuilder: (context, index) {
                      return CasinoPageFlipList(
                        onTap: controller.goToDetail,
                        onTitleTap: () {},
                        itemsList: controller.yulechengModel.items![index].navGames!,
                        title: controller.yulechengModel.items![index].name,
                        icon: controller.yulechengModel.items![index].icon,
                        needshowChaKanGengDuo: true,
                        currentIndex: index,
                      );
                    }),
            buildChangGuan(),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
        });
  }

  Widget buildChangGuan() {
    return controller.state.changguanDataArray.length > 0
        ? CasinoChangguanFlipList(
            onTap: controller.goToPlatDetail,
            items: controller.state.changguanDataArray,
            title: S.current.game_supplier,
            icon: 'assets/images/home/ic_game_provider.webp',
          )
        : const SizedBox();
  }

  Widget buildMarqueeWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: ShapeDecoration(
        color: ThemeService().theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Colors.white.withOpacity(0.10000000149011612),
          ),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: Row(
        children: [
          CustomIcon(asset: 'assets/images/home/ic_front_notice.webp'),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: Obx(() {
              return Marquee(
                speed: 30,
                child: CustomText(
                  controller.state.marqueeText.value,
                  style: const TextStyle(color: AppThemes.iconColor, fontSize: 14),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
