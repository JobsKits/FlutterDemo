import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../../../utils/common_color.dart';
import '../../controllers/vip_detail_controller.dart';

class VipDetailView extends GetView<VipDetailController> {
  const VipDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(color2D3349),
      appBar: AppBar(
        backgroundColor: Color(color2D3349),
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        title: Text("VIP详情", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(Assets.theme1.images.user.vip.vipDetailBg.path),
          _buildVipLevel(),
          _buildBanner(),
          _buildBannerContent(),
          Container(
            margin: EdgeInsets.only(
                left: 120.w, right: 120.w, bottom: 60.h, top: 90.h),
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
                  "VIP${controller.vipController.currentVipLevel}福利",
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
          _buildBottomView(),
        ],
      ),
    );
  }

  Widget _buildBottomView() {
    return Obx(() => controller.htmlStr.isNotEmpty
        ? HtmlWidget(
            controller.htmlStr.value,
            textStyle: const TextStyle(color: Colors.white),
          )
        : SizedBox());
  }

  Widget _buildRedPackage(
      {required String iconPath, required String money, required String desc}) {
    return Container(
      width: 310.w,
      height: 390.h,
      padding: EdgeInsets.only(top: 35.h),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 100.w,
                backgroundColor: Color(colorD9D9D9),
              ),
              Image.asset(iconPath, width: 200.w, height: 200.h),
            ],
          ),
          Text(
            money,
            style: TextStyle(fontSize: 48.sp),
          ),
          Text(desc,
              style: TextStyle(fontSize: 39.sp, color: Color(color888888))),
        ],
      ),
    );
  }

  Widget _buildVipLevel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 70.w),
      child: GridView.builder(
          itemCount: controller.vipController.bannerList.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3.66,
              crossAxisSpacing: 44.w,
              mainAxisSpacing: 44.w),
          itemBuilder: (context, index) {
            return Container(
              height: 82.h,
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(67.r)),
              child: Row(
                children: [
                  Image.asset(
                    controller.vipController.getVipBannerIcon(index),
                    width: 70.w,
                    height: 63.h,
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  Text("VIP ${index + 1}")
                ],
              ),
            );
          }),
    );
  }

  ///构建Banner
  Widget _buildBanner() {
    return Container(
      height: 360.h,
      margin: EdgeInsets.only(top: 50.h),
      child: Obx(() => CarouselSlider(
          carouselController: controller.vipController.buttonCarouselController,
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
                controller.vipController.changeBannerIndex(index);
              }),
          items: List.generate(controller.vipController.bannerList.length,
              (index) {
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
                  controller.vipController.getVipBannerBgFirstColor(index),
                  controller.vipController.getVipBannerBgSecondColor(index)
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
                  "VIP ${index + 1}",
                  style: TextStyle(
                      fontSize: 64.sp,
                      fontWeight: FontWeight.bold,
                      color: controller.vipController
                          .getVipBannerTextColor(index)),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 56.w, top: 50.h),
                  child: Text(
                    "保级投注 250,000，充值250,000",
                    style: TextStyle(
                        fontSize: 30.sp,
                        color: controller.vipController
                            .getVipBannerTextColor(index)),
                  )),
              Spacer(),
              Container(
                height: 70.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color:
                        controller.vipController.getVipBannerTextColor(index),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.r),
                        bottomRight: Radius.circular(30.r))),
                child: Text(
                  "升级VIP6所需：充值199,650  投注1,195,050",
                  style: TextStyle(
                      fontSize: 25.sp,
                      color: controller.vipController
                          .getVipBannerTextColor2(index)),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: -20.h,
          right: 30.w,
          child: Image.asset(
            controller.vipController.getVipBannerIcon(index),
            width: 160.w,
            height: 160.h,
          ),
        ),
      ],
    );
  }

  Widget _buildBannerContent() {
    return Padding(
      padding: EdgeInsets.only(left: 50.w, right: 50.w, top: 40.h),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRedPackage(
                  iconPath: Assets.theme1.images.user.vip.iconRedPackaget1.path,
                  money:
                      "${(controller.vipController.itemBean.value.levelReward ?? 0) / 1000}",
                  desc: "升级礼金"),
              _buildRedPackage(
                  iconPath: Assets.theme1.images.user.vip.iconRedPackaget4.path,
                  money:
                      "${(controller.vipController.itemBean.value.weekReward ?? 0) / 1000}",
                  desc: "周俸禄"),
              _buildRedPackage(
                  iconPath: Assets.theme1.images.user.vip.iconRedPackaget3.path,
                  money:
                      "${(controller.vipController.itemBean.value.monthReward ?? 0) / 1000}",
                  desc: "月俸禄"),
            ],
          )),
    );
  }
}
