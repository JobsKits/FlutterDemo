import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../api/user_api.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/login_manager.dart';
import '../../../../utils/tenant_manager.dart';
import '../data/vip_info_bean.dart';

class VipController extends GetxController {
  late CarouselSliderController buttonCarouselController =
      CarouselSliderController(); //banner和指示器的Controller

  late VipInfoBean? vipInfoBean;
  RxList<VipLevelItemBean> bannerList = <VipLevelItemBean>[].obs;
  Rx<VipLevelItemBean> itemBean = VipLevelItemBean().obs;
  Rx<VipLevelItemBean> userCurrentItemBean =
      VipLevelItemBean().obs; //用户当前vip等级的信息
  RxString upButtonText = "".obs; //升级按钮文字
  RxString weekButtonText = "".obs; //每周按钮文字
  RxString monthButtonText = "".obs; //每月按钮文字
  RxBool upButtonEnable = false.obs;
  RxBool weekButtonEnable = false.obs;
  RxBool monthButtonEnable = false.obs;
  RxDouble rechargeProgress = 0.0.obs;
  RxDouble betProgress = 0.0.obs;
  RxString rechargeProgressTxt = "".obs;
  RxString betProgressTxt = "".obs;
  RxInt currentVipLevel = 0.obs;
  RxInt nextVipLevel = 0.obs;
  late int userCurrentVipLevelPosition;
  RxString userHead = "".obs;
  RxString userName = "".obs;
  @override
  void onInit() async {
    super.onInit();
    vipInfoBean = await UserApi().reqVipInfo();
    currentVipLevel.value = LoginManager.instance.loginInfo?.custLevel ?? 0;
    String imgDomain = await TenantManager.instance.getCurrentImgDomain();
    userHead.value = "$imgDomain${LoginManager.instance.loginInfo?.head}";
    userName.value = LoginManager.instance.loginInfo?.nickname ?? "";
    if (vipInfoBean != null) {
      bannerList.value = vipInfoBean?.data ?? [];
      setCurrentSelectVipInfo(0);

      setCurrentUserVipInfo();
    }
  }

  void setCurrentUserVipInfo() {
    userCurrentItemBean.value =
        bannerList.firstWhere((item) => item.level == currentVipLevel.value);

    userCurrentVipLevelPosition = bannerList.indexOf(userCurrentItemBean.value);

    //如果当前vip等级小于集合最后一个的等级，那么下一级就应该是集合索引+1位置的数据
    var nexItem =
        currentVipLevel.value < bannerList[bannerList.length - 1].level!
            ? bannerList[userCurrentVipLevelPosition + 1]
            : bannerList[bannerList.length - 1];
    nextVipLevel.value = nexItem.level!;
    var temp = (nexItem.balanceLower! / 1000 -
        userCurrentItemBean.value.balanceDifferAmount! / 1000);
    double rechargeCurrent = temp < 0 ? 0 : temp;
    print(
        "输出一下：${nexItem.balanceLower! / 1000}   ${userCurrentItemBean.value.balanceDifferAmount! / 1000}");
    double rechargeNext = nexItem.balanceLower! / 1000;

    rechargeProgressTxt.value = "${rechargeCurrent}/${rechargeNext}";
    rechargeProgress.value = rechargeCurrent / rechargeNext;

    double betCurrent = nexItem.valueLower! / 1000 -
        userCurrentItemBean.value.differAmount! / 1000;
    double betNext = nexItem.valueLower! / 1000;
    betProgressTxt.value = "${betCurrent}/${betNext}";
    betProgress.value = betCurrent / betNext;
  }

  //设置当前选中的vip信息
  void setCurrentSelectVipInfo(int index) {
    itemBean.value = bannerList[index];
    var tempItem = itemBean.value;
    //升级奖励判断
    if (tempItem.isLevelReward == 0 ||
        tempItem.levelReward == 0 ||
        currentVipLevel.value < tempItem.level!) {
      upButtonText.value = "暂不可领取";
      upButtonEnable.value = false;
    }
    if (tempItem.isLevelReward == 1 &&
        tempItem.levelReward! > 0 &&
        currentVipLevel.value >= tempItem.level!) {
      upButtonText.value = "可以领取";
      upButtonEnable.value = true;
    }
    if (tempItem.isLevelReward == 2 && tempItem.levelReward! > 0) {
      upButtonText.value = "已领取";
      upButtonEnable.value = false;
    }
    //周奖励判断
    if (tempItem.isWeekReward == 0 ||
        tempItem.weekReward == 0 ||
        currentVipLevel.value < tempItem.level!) {
      weekButtonText.value = "暂不可领取";
      weekButtonEnable.value = false;
    }
    if (tempItem.isWeekReward == 1 &&
        tempItem.weekReward! > 0 &&
        currentVipLevel.value >= tempItem.level!) {
      weekButtonText.value = "可以领取";
      weekButtonEnable.value = true;
    }
    if (tempItem.isWeekReward == 2 && tempItem.weekReward! > 0) {
      weekButtonText.value = "已领取";
      weekButtonEnable.value = false;
    }
    //月奖励判断
    if (tempItem.isMonthReward == 0 ||
        tempItem.monthReward == 0 ||
        currentVipLevel.value < tempItem.level!) {
      monthButtonText.value = "暂不可领取";
      monthButtonEnable.value = false;
    }
    if (tempItem.isMonthReward == 1 &&
        tempItem.monthReward! > 0 &&
        currentVipLevel.value >= tempItem.level!) {
      monthButtonText.value = "可以领取";
      monthButtonEnable.value = true;
    }
    if (tempItem.isMonthReward == 2 && tempItem.monthReward! > 0) {
      monthButtonText.value = "已领取";
      monthButtonEnable.value = false;
    }
  }

  //切换banner的index
  void changeBannerIndex(int index) {
    currentBannerIndex.value = index;
    setCurrentSelectVipInfo(index);
  }

  RxInt currentBannerIndex = 0.obs; //当前选中banner的index

  String getVipBannerIcon(int vipLevel) {
    String iconPath = Assets.theme1.images.user.vip.iconVip1.path;
    switch (vipLevel) {
      case 0:
        iconPath = Assets.theme1.images.user.vip.iconVip1.path;
      case 1:
        iconPath = Assets.theme1.images.user.vip.iconVip2.path;
      case 2:
        iconPath = Assets.theme1.images.user.vip.iconVip3.path;
      case 3:
        iconPath = Assets.theme1.images.user.vip.iconVip4.path;
      case 4:
        iconPath = Assets.theme1.images.user.vip.iconVip5.path;
      case 5:
        iconPath = Assets.theme1.images.user.vip.iconVip6.path;
    }
    return iconPath;
  }

  Color getVipBannerBgFirstColor(int vipLevel) {
    Color tempColor = Color(0xFFF0EFF4);
    switch (vipLevel) {
      case 0:
        tempColor = Color(0xFFF0EFF4);
      case 1:
        tempColor = Color(0xFFFF8F2DF);
      case 2:
        tempColor = Color(0xFFC6E6FF);
      case 3:
        tempColor = Color(0xFFD9E2EC);
      case 4:
        tempColor = Color(0xFFDBDCF3);
      case 5:
        tempColor = Color(0xFF434043);
    }
    return tempColor;
  }

  Color getVipBannerBgSecondColor(int vipLevel) {
    Color tempColor = Color(0xFFC7C6D8);
    switch (vipLevel) {
      case 0:
        tempColor = Color(0xFFC7C6D8);
      case 1:
        tempColor = Color(0xFFF4C5AA);
      case 2:
        tempColor = Color(0xFF80C5F8);
      case 3:
        tempColor = Color(0xFF7088CD);
      case 4:
        tempColor = Color(0xFFCCA4DF);
      case 5:
        tempColor = Color(0xFF333033);
    }
    return tempColor;
  }

  Color getVipBannerTextColor(int vipLevel) {
    Color tempColor = Color(0xFF3B375F);
    switch (vipLevel) {
      case 0:
        tempColor = Color(0xFF3B375F);
      case 1:
        tempColor = Color(0xFF270C00);
      case 2:
        tempColor = Color(0xFF305676);
      case 3:
        tempColor = Color(0xFF214B61);
      case 4:
        tempColor = Color(0xFF2B1A64);
      case 5:
        tempColor = Color(0xFFFFDC8B);
    }
    return tempColor;
  }

  Color getVipBannerTextColor2(int vipLevel) {
    Color tempColor = Colors.white.withOpacity(0.6);
    switch (vipLevel) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4:
        tempColor = Colors.white.withOpacity(0.6);
      case 5:
        tempColor = Color(color3A373A);
    }
    return tempColor;
  }
}
