import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';
import '../../../data/home_main_info_bean.dart';
import '../controllers/find_balance_controller.dart';

//找回余额页面
class FindBalanceView extends GetView<FindBalanceController> {
  const FindBalanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        leading: BackButton(
          color: context.customTheme?.appbarText,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "找回余额",
          style: TextStyle(color: context.customTheme?.appbarText),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24.h, left: 33.w, right: 33.w),
      child: Column(
        children: [
          _buildWalletView(context),
          SizedBox(
            height: 35.h,
          ),
          Expanded(child: _buildContent(context)),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLeftMenu(),
        SizedBox(
          width: 27.w,
        ),
        Expanded(child: _buildRightContent(context)),
      ],
    );
  }

  Widget _buildRightContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.customTheme?.pageTwoBg,
          borderRadius: BorderRadius.circular(30.r)),
      child: Obx(() => ListView.builder(
          itemCount: controller.rightListNew.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            ThirdGamesItem? item = controller.homeController.thirdGameList
                .firstWhereOrNull((item) =>
                    item.play_id == controller.rightListNew[index].playId!);
            String imgUrl = "";
            if (item == null) {
              imgUrl = GameUtils.getGitColorIcon(
                  bigType: controller.rightListNew[index].bigType,
                  playId: controller.rightListNew[index].playId!.toInt());
            } else {
              imgUrl = item?.logo3_img_url ??
                  GameUtils.getGitColorIcon(
                      bigType: controller.rightListNew[index].bigType,
                      playId: controller.rightListNew[index].playId!.toInt());
            }
            print(
                "图片地址：${imgUrl}   git:${GameUtils.getGitColorIcon(bigType: controller.rightListNew[index].bigType, playId: controller.rightListNew[index].playId!.toInt())}");
            bool isNetImg = imgUrl.contains("http");

            return CommonRipple(
              onTap: () {
                print("点击了 ：${controller.rightListNew[index].toString()} 图片地址:${GameUtils.getHomeTabDefaultColorIcon(
                    // gameType: GameUtils.determineTypeConst3(
                    gameType: GameUtils.determineTypeConst3(controller.rightListNew[index].bigType!), playId: controller.rightListNew[index].playId!.toInt())}");
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                height: 150.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: imgUrl,
                            width: 100.w,
                            height: 100.h,
                            errorWidget: (
                              BuildContext context,
                              String url,
                              Object error,
                            ) {
                              return CachedNetworkImage(
                                imageUrl: GameUtils.getGitColorIcon(
                                    bigType:
                                        controller.rightListNew[index].bigType,
                                    playId: controller
                                        .rightListNew[index].playId!
                                        .toInt()),
                                errorWidget: (
                                  BuildContext context,
                                  String url,
                                  Object error,
                                ) {
                                  return const CircleAvatar(
                                    backgroundColor: Color(colorF4F4F4),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(width: 30.w),
                          Text(
                            "${controller.rightListNew[index].playCname}",
                            // "${controller.rightList[index].playName}",
                            style: TextStyle(fontSize: 42.sp),
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                          const Spacer(),
                          Text(
                              "￥${(controller.rightListNew[index].total! / 1000).truncateToFixed(2)}")
                        ],
                      ),
                    ),
                    Divider(
                      height: 1.h,
                      thickness: 1.h,
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }

  Widget _buildLeftMenu() {
    return SizedBox(
      width: 170.w,
      height: double.infinity,
      child: Obx(() => ListView.builder(
          itemCount: controller.leftList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return CommonRipple(
              onTap: () {
                if (controller.leftMenuIndex.value != index) {
                  AppManager.instance.tapVibrate();
                }
                controller.changeLeftMenuIndex(index);
              },
              child: Obx(() {
                bool isSvg =
                    controller.leftList[index].iconPath.endsWith(".svg");
                bool isNetImg =
                    controller.leftList[index].iconPath.contains("http");
                return Container(
                  width: 170.w,
                  margin: EdgeInsets.only(bottom: 18.h),
                  height: 150.h,
                  decoration: BoxDecoration(
                      color: controller.leftMenuIndex.value == index
                          ? context.theme.primaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(30.r)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isSvg
                          ? SvgPicture.asset(
                              controller.leftList[index].iconPath,
                              width: 52.w,
                              height: 52.h,
                              colorFilter: ColorFilter.mode(
                                  controller.leftMenuIndex.value == index
                                      ? const Color(colorFFFFFF)
                                      : const Color(colorC7CBD3),
                                  BlendMode.srcIn))
                          : (isNetImg
                              ? Image.network(
                                  controller.leftList[index].iconPath,
                                  width: 52.w,
                                  height: 52.h,
                                )
                              : Image.asset(
                                  controller.leftList[index].iconPath,
                                  width: 52.w,
                                  height: 52.h,
                                )),
                      SizedBox(width: 15.h),
                      Text(
                        "${controller.leftList[index].title}",
                        style: TextStyle(
                            fontSize: 42.sp,
                            color: controller.leftMenuIndex.value == index
                                ? Colors.white
                                : Colors.black),
                      )
                    ],
                  ),
                );
              }),
            );
          })),
    );
  }

  Widget _buildWalletView(BuildContext context) {
    return Container(
      height: 200.h,
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      decoration: BoxDecoration(
          color: context.customTheme?.pageTwoBg,
          borderRadius: BorderRadius.circular(30.r)),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.theme1.images.user.iconWallet,
            width: 80.w,
            height: 80.h,
            color: context.theme.primaryColor,
          ),
          SizedBox(
            width: 34.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "账户余额",
                style: TextStyle(
                    fontSize: 39.sp, color: context.customTheme?.title2Color),
              ),
              Row(
                children: [
                  Obx(() => Text(
                        "￥${LoginManager.instance.balanceStr.value}",
                        style: TextStyle(
                            fontSize: 45.sp,
                            color: context.customTheme?.titleColor),
                      )),
                  SizedBox(
                    width: 26.w,
                  ),
                  CommonRipple(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      controller.retrieveAndCheckBalance();
                    },
                    child: SvgPicture.asset(
                      Assets.theme1.images.user.iconRefresh,
                      width: 45.w,
                      height: 45.h,
                    ),
                  )
                ],
              )
            ],
          ),
          const Spacer(),
          CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              controller.findMoney();
            },
            child: Container(
              height: 93.h,
              width: 252.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(20.r)),
              child: Text(
                "一键找回",
                style: TextStyle(fontSize: 42.sp, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
