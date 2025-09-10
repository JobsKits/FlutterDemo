import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../../utils/CommonRipple.dart';
import '../../../../../utils/common_color.dart';
import '../../controllers/vip_controller.dart';

class VipView extends StatefulWidget {
  final bool isShowTitle;
  const VipView({super.key, this.isShowTitle = true});

  @override
  State<VipView> createState() => _VipViewState();
}

class _VipViewState extends State<VipView> {
  late VipController controller = Get.put(VipController());
  @override
  void dispose() {
    Get.delete<VipController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(VipController());
    return Scaffold(
      backgroundColor: Color(color2D3349),
      appBar: widget.isShowTitle
          ? AppBar(
              backgroundColor: Color(color2D3349),
              leading: BackButton(
                onPressed: () {
                  Get.back();
                },
              ),
              title: Text(
                "VIP",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            )
          : null,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 40.h),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    top: -70.h,
                    child: Image.asset(
                      Assets.theme1.images.user.vip.vipBg.path,
                      height: 480.h,
                    )),
                _buildHeader()
              ],
            ),
            _buildBanner(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      margin: EdgeInsets.only(top: 90.h),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 120.w, right: 120.w, bottom: 60.h),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                        height: 4.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(colorB9A9FF).withOpacity(0.0),
                              Color(colorB9A9FF)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ))),
                SizedBox(
                  width: 28.w,
                ),
                Text(
                  "VIP${controller.currentVipLevel.value}福利",
                  style: TextStyle(fontSize: 48.sp, color: Colors.white),
                ),
                SizedBox(
                  width: 28.w,
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(colorB9A9FF),
                        Color(colorB9A9FF).withOpacity(0.0)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  height: 4.h,
                )),
              ],
            ),
          ),
          Obx(() => _buildRedPackage(
              iconPath: Assets.theme1.images.user.vip.iconRedPackaget1.path,
              money: "${(controller.itemBean.value.levelReward ?? 0) / 1000}",
              desc: "升级礼金",
              btnText: controller.upButtonText.value,
              btnEnable: controller.upButtonEnable.value)),
          Obx(() => _buildRedPackage(
              iconPath: Assets.theme1.images.user.vip.iconRedPackaget2.path,
              money: "${(controller.itemBean.value.weekReward ?? 0) / 1000}",
              desc: "每周俸禄",
              btnText: controller.weekButtonText.value,
              btnEnable: controller.weekButtonEnable.value)),
          Obx(() => _buildRedPackage(
              iconPath: Assets.theme1.images.user.vip.iconRedPackaget3.path,
              money: "${(controller.itemBean.value.monthReward ?? 0) / 1000}",
              desc: "每月俸禄",
              btnText: controller.monthButtonText.value,
              btnEnable: controller.monthButtonEnable.value)),
        ],
      ),
    );
  }

  Widget _buildRedPackage(
      {required String iconPath,
      required String money,
      required String desc,
      VoidCallback? onTap,
      required String btnText,
      required bool btnEnable}) {
    return Container(
      height: 236.h,
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      margin: EdgeInsets.only(bottom: 30.h, left: 33.w, right: 33.w),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 220.w,
          ),
          SizedBox(
            width: 90.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                money,
                style: TextStyle(fontSize: 48.sp),
              ),
              Text(desc,
                  style: TextStyle(fontSize: 39.sp, color: Color(color888888))),
            ],
          ),
          Spacer(),
          CommonRipple(
            onTap: btnEnable ? onTap : null,
            child: Container(
              width: 306.w,
              height: 115.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(66.r),
                  color: Color(btnEnable ? colorDEFBFF : colorF4F4F4)),
              child: Text(
                btnText,
                style: TextStyle(
                    fontSize: 48.sp,
                    color: btnEnable
                        ? context.theme.primaryColor
                        : Color(color888888)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(left: 33.w, bottom: 30.h),
      margin: EdgeInsets.symmetric(horizontal: 60.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.r),
      ),
      width: double.infinity,
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                  child: Container(
                width: double.infinity,
                height: 64.h,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 50.w),
                decoration: BoxDecoration(
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r))),
                child: Obx(() => Text(
                      "VIP${controller.currentVipLevel.value}->VIP${controller.nextVipLevel.value}",
                      style: TextStyle(fontSize: 33.w, color: Colors.white),
                    )),
              )),
              Positioned(
                  left: -33,
                  right: 280.w,
                  child: Container(
                    height: 65.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.r),
                            topRight: Radius.circular(40.r))),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Obx(() => CircleAvatar(
                        radius: 100.w,
                        backgroundImage: controller.userHead.value.isNotEmpty
                            ? NetworkImage(
                                controller.userHead.value,
                              )
                            : null,
                      )),
                  SizedBox(
                    width: 38.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            controller.userName.value,
                            style: TextStyle(
                                fontSize: 42.sp, fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        height: 16.h,
                      ),
                      Obx(() => Text(
                            "VIP ${controller.currentVipLevel.value}",
                            style: TextStyle(
                                fontSize: 40.sp,
                                color: context.theme.primaryColor),
                          )),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Image.asset(
                        controller.getVipBannerIcon(
                            controller.currentVipLevel.value - 1),
                        width: 160.w,
                        height: 160.h,
                      )),
                  SizedBox(
                    width: 120.w,
                  ),
                  CommonRipple(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      Get.toNamed(Routes.VIP_DETAIL);
                    },
                    child: Text(
                      "VIP详情",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 36.sp,
                          color: Color((color888888))),
                    ),
                  ),
                  SizedBox(
                    width: 33.w,
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 50.h,
          ),
          Obx(() => Row(
                children: [
                  Text(
                    "充值",
                    style: TextStyle(fontSize: 36.sp),
                  ),
                  SizedBox(
                    width: 50.w,
                  ),
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                            height: 30.h,
                            child: LinearProgressIndicator(
                              color: context.theme.primaryColor,
                              value: controller.rechargeProgress.value,
                              borderRadius: BorderRadius.circular(20.r),
                            )),
                        Text(
                          "${controller.rechargeProgressTxt.value}",
                          style: TextStyle(
                              fontSize: 30.sp, color: Color(color888888)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50.w,
                  ),
                ],
              )),
          Obx(() => Row(
                children: [
                  Text("投注", style: TextStyle(fontSize: 36.sp)),
                  SizedBox(
                    width: 50.w,
                  ),
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                            height: 30.h,
                            child: LinearProgressIndicator(
                              color: context.theme.primaryColor,
                              value: controller.betProgress.value,
                              borderRadius: BorderRadius.circular(20.r),
                            )),
                        Text(
                          "${controller.betProgressTxt.value}",
                          style: TextStyle(
                              fontSize: 30.sp, color: Color(color888888)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50.w,
                  ),
                ],
              ))
        ],
      ),
    );
  }

  ///构建Banner
  Widget _buildBanner() {
    return Container(
      height: 360.h,
      margin: EdgeInsets.only(top: 50.h),
      child: Obx(() => CarouselSlider(
          carouselController: controller.buttonCarouselController,
          options: CarouselOptions(
              height: 330.h,
              viewportFraction: 0.6,
              initialPage: 0,
              enableInfiniteScroll: false,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 300),
              autoPlayCurve: Curves.linear,
              enlargeCenterPage: true,
              enlargeFactor: 0,
              scrollDirection: Axis.horizontal,
              onPageChanged: (int index, CarouselPageChangedReason reason) {
                controller.changeBannerIndex(index);
              }),
          items: List.generate(controller.bannerList.length, (index) {
            return _buildBannerItemView(index);
          }))),
    );
  }

  Widget _buildBannerItemView(int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  controller.getVipBannerBgFirstColor(index),
                  controller.getVipBannerBgSecondColor(index)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(40.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.h, left: 56.w),
                child: Text(
                  "VIP ${controller.bannerList[index].level}",
                  style: TextStyle(
                      fontSize: 64.sp,
                      fontWeight: FontWeight.bold,
                      color: controller.getVipBannerTextColor(index)),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 56.w, top: 50.h),
                  child: Text(
                    "保级投注 250,000，充值250,000",
                    style: TextStyle(
                        fontSize: 30.sp,
                        color: controller.getVipBannerTextColor(index)),
                  )),
              Spacer(),
              Container(
                height: 70.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: controller.getVipBannerTextColor(index),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.r),
                        bottomRight: Radius.circular(30.r))),
                child: Text(
                  "升级VIP6所需：充值199,650  投注1,195,050",
                  style: TextStyle(
                      fontSize: 25.sp,
                      color: controller.getVipBannerTextColor2(index)),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: -20.h,
          right: 30.w,
          child: Image.asset(
            controller.getVipBannerIcon(index),
            width: 160.w,
            height: 160.h,
          ),
        ),
      ],
    );
  }
}
