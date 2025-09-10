import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/chat_room/data/view.dart';
import 'package:flutter_bet/pages/chat_room/widgets/tab_bar_widget.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/num_util.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart';
import '../../../services/account_service.dart';
import '../../../services/branch/branch_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_ovalends_progressbar.dart';
import 'logic.dart';

const String kCustomChatRoomUserInfoWidget = 'kCustomChatRoomUserInfoWidget';

class ChatRoomUserInfoWidget extends StatefulWidget {
  final String name;

  const ChatRoomUserInfoWidget({super.key, this.name = ''});

  @override
  State<StatefulWidget> createState() => _ChatRoomUserInfoWidget();
}

class _ChatRoomUserInfoWidget extends State<ChatRoomUserInfoWidget> {
  late ChatRoomUserInfoController controller = Get.find<ChatRoomUserInfoController>();

  @override
  void dispose() {
    super.dispose();
    Get.delete<ChatRoomUserInfoController>();
  }

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => ChatRoomUserInfoController());
    controller.username = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              child: Container(
                color: Colors.transparent,
              ),
              onTap: () =>
                  CustomSafeDialog.dismiss(context: context, tag: kCustomChatRoomUserInfoWidget),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                child: Container(
                  // margin: EdgeInsets.only(left: AppValues.defaultPadding,right: AppValues.defaultPadding),
                  // margin: const EdgeInsets.symmetric(
                  //     horizontal: AppValues.defaultPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppValues.smallRadius),
                    color: ThemeService().theme.scaffoldBackgroundColor,
                  ),
                  child: Column(
                    children: [
                      _buildTop(),
                      widget.name.isNotEmpty ? _buildName() : _buildVIP(),
                      // _buildBody(context),
                      UserDataStatisticalWidget(
                        username: controller.username,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildName() {
    return CustomText(
      widget.name,
      style: ThemeService().textTheme.bodyMedium,
      textColorStyle: CustomTextColorStyle.normal,
    );
  }

  Widget _buildVIP() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: <Widget>[
        // Image.asset(
        //     "assets/images/personal_center_icon/vip_level/svg-vip-back.webp"),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: CustomText(
                '${AccountService.sharedInstance.currentUser?.username}',
                style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                textColorStyle: CustomTextColorStyle.normal,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            CustomText(
              '${S.current.random_text_357copy2}${controller.getJoinTime()}',
              style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
              textColorStyle: CustomTextColorStyle.normal,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.animate();
                    GlobalState.instance.index = 3;
                    DialogUtils.goToPage(Routes.personalVip);
                  },
                  child: Obx(() {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      transform:
                          Matrix4.translationValues(controller.state.xOffset.value, 0.0, 0.0),
                      child: Row(
                        children: [
                          CustomText(S.current.random_text_1061,
                              style: ThemeService()
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(
                            width: 8,
                          ),
                          CustomText(
                            controller.currentAlias.value,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: AppValues.fontTileSmallSize),
                          )
                        ],
                      ),
                    );
                  }),
                ),
                Obx(() => CustomText(
                    "${S.current.random_text_886}${NumUtil.getValue(controller.completeRate.toDouble())}%",
                    style: ThemeService()
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600))),
              ],
            ),
            Container(
              width: double.infinity,
              height: 16,
              margin: const EdgeInsets.only(top: 12),
              // child: CustomVipProgressIndicator(
              //   value: controller.completeRate.value==0?0.5:0,
              // ),
              child: Obx(() {
                // log("进度 ${controller.completeRate.value}");
                return CustomPaint(
                  painter: OvalEndsProgressBar(
                      progress: controller.completeRate.value / 100 > 1
                          ? 1
                          : controller.completeRate.value / 100), // 传入进度值
                );
              }),
            ),
            // const SizedBox(
            //   height: 12,
            // ),
            // Obx(() {
            //   return Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         children: [
            //           Image.network(
            //               "${BranchService().current.asset_url}/images/vip/${controller.currentUser.vip!}.webp",
            //               width: 27,
            //               height: 24),
            //           // SvgPicture.asset("assets/svg/vip_level/viplevel_${controller.currentUser.vip!}.svg", width: 27, height: 24),
            //           const SizedBox(
            //             width: 6,
            //           ),
            //           CustomText(
            //             controller.currentAlias.value,
            //             // 'VIP${AccountService.sharedInstance.getUserInfo().vip}' ??
            //             //     S.current.vip_level,
            //             textColorStyle: CustomTextColorStyle.normal,
            //             style: const TextStyle(
            //                 fontWeight: FontWeight.w400, fontSize: AppValues.fontTileSmallSize),
            //           )
            //         ],
            //       ),
            //       Row(
            //         children: [
            //           Visibility(
            //             visible: controller.currentLevel.value == "50" ? false : true,
            //             child: Image.network(
            //                 "${BranchService().current.asset_url}/images/vip/${controller.vipLevel}.webp",
            //                 width: 27,
            //                 height: 24),
            //           ),
            //           const SizedBox(
            //             width: 6,
            //           ),
            //           Visibility(
            //             visible: controller.currentLevel.value == "50" ? false : true,
            //             child: CustomText(
            //               controller.nextAlias.value,
            //               style: const TextStyle(
            //                   fontWeight: FontWeight.w400, fontSize: AppValues.fontTileSmallSize),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   );
            // }),
            // const SizedBox(
            //   height: AppValues.margin_20,
            // ),
          ],
        ),
      ].toStack(),
    );
  }

  Widget _buildTop() {
    return Column(
      children: [
        const SizedBox(
          height: AppValues.largePadding,
        ),
        SizedBox(
          height: 28,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(left: AppValues.defaultPadding),
                  child: Row(
                    children: [
                      const CustomIcon(
                        asset: 'assets/images/personal_center_icon/count_data.webp',
                        size: 24,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      CustomText(
                        S.current.tab_bar_title_data_statistics_text,
                        style: ThemeService()
                            .theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Row(
                  children: [
                    const Expanded(child: SizedBox.shrink()),
                    GestureDetector(
                      onTap: () {
                        CustomSafeDialog.dismiss(
                            context: context, tag: kCustomChatRoomUserInfoWidget);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: AppValues.defaultPadding),
                        child: CustomIcon(
                          asset: 'assets/images/normal/ic_normal_close.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ChatRoomUserInfoTabBarWidget(
          tabs: [
            Tab(
              child: Text(S.current.sport_all, style: ThemeService().theme.textTheme.bodyMedium),
            ),
            Tab(
              child: Text(S.current.tab_bar_ent, style: ThemeService().theme.textTheme.bodyMedium),
            ),
            Tab(
              child:
                  Text(S.current.tab_bar_sports, style: ThemeService().theme.textTheme.bodyMedium),
            ),
          ],
          onTap: controller.pageIndex,
          children: const [
            UserDataStatisticalWidget(),
            UserDataStatisticalWidget(),
            UserDataStatisticalWidget(),
          ],
        ),
      ],
    );
  }
}

Future<void> showCustomChatRoomUserInfoWidget<T>({
  required BuildContext context,
  String name = '',
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  GlobalStateController.of()
      .showOverlayView(isShowTopBarView: false, isShowBottomBarView: false);
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomChatRoomUserInfoWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return ChatRoomUserInfoWidget(
          name: name,
        );
      })?.then((value) => GlobalStateController.of()
      .showOverlayView());
}
