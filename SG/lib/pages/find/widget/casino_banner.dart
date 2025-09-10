import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/pages/find/logic.dart';
import 'package:flutter_bet/pages/sport/sportbannermodel.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/utils/url_launch_util.dart';
import 'package:flutter_bet/widget/carousel/side_img_carousel.dart';
import 'package:flutter_bet/widget/custom_toast.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/scroll_tab_bar/custom_tab_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CasinoBanner extends StatefulWidget {
  final List<SportBannerModel> data;
  final FindLogic controller;
  CasinoBanner({super.key, required this.data, required this.controller});

  @override
  State<CasinoBanner> createState() => _CustomSportBannerState();
}

class _CustomSportBannerState extends State<CasinoBanner> {
  @override
  Widget build(BuildContext context) {
    // return CustomSideImageCarousel(
    //     imgUrls: [
    //       for(int i = 0; i < widget.data.length; i++)
    //       getImageUrl(widget.data[i])
    //     ],
    //     callback: (int index) {
    //       UrlLaunchUtil.launchURL(widget.data[index].jumpUrl ?? '').then((message) {
    //         if (message.isNotEmpty) {
    //           CustomToast.show(message, context);
    //         }
    //       });
    //     }).paddingOnly(top: AppValues.defaultPadding, bottom: AppValues.largePadding)
    //     .paddingHorizontal(AppValues.defaultMargin);

    return Padding(
      padding: const EdgeInsets.only(top: AppValues.defaultRadius, bottom: AppValues.defaultRadius),
      child: SizedBox(
        height: 200.sp,
        child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    UrlLaunchUtil.launchURL(widget.data[index].jumpUrl ?? '').then((message) {
                      if (message.isNotEmpty) {
                        CustomToast.show(message, context);
                      }
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0), // 设置圆角半径
                    child: CustomNetWorkImage(
                      imageUrl: getImageUrl(widget.data[index]),
                      // placeholder: Image.asset("assets/images/sport/sport_banner1.webp"),
                      fit: BoxFit.fill,
                      width: AppValues.sportWidth_320.w, // Set width
                      height: AppValues.sportHeight_188.h,
                    ),
                  ),
                );
              },
              itemCount: widget.data.length,
              viewportFraction: 0.92,
              scale: 0.97,
              loop: false,
            )
      ),
    );
  }

  // getImageUrl(SportBannerModel model) {
  //   final GlobalStateController g = Get.find<GlobalStateController>();

  //   if (g.langType.value == 1) {
  //     // print(BranchService.instance.current.asset_url + '/' + (model.imageUrl?.zhCn ?? ''));
  //     return BranchService.instance.current.asset_url + '/' + (model.imageUrl?.contentZhCn ?? '');
  //   } else if (g.langType.value == 2) {
  //     return BranchService.instance.current.asset_url + '/' + (model.imageUrl?.enUs ?? '');
  //   } else if (g.langType.value == 3) {
  //     return BranchService.instance.current.asset_url + '/' + (model.imageUrl?.enUs ?? '');
  //   } else if (g.langType.value == 4) {
  //     return BranchService.instance.current.asset_url + '/' + (model.imageUrl?.enUs ?? '');
  //   } else {
  //     return BranchService.instance.current.asset_url + '/' + (model.imageUrl?.zhCn ?? '');
  //   }
  // }

  getImageUrl(SportBannerModel model) {
    final GlobalStateController globalController = Get.find<GlobalStateController>();
    if (model.bannerStyle == 3) {
      if (globalController.langType.value == 1) {
        return '${BranchService.instance.current.asset_url}/${model.bannerUrl?.contentZhCn ?? ''}';
      } else if (globalController.langType.value == 2) {
        return '${BranchService.instance.current.asset_url}/${model.bannerUrl?.enUs ?? ''}';
      } else if (globalController.langType.value == 3) {
        return '${BranchService.instance.current.asset_url}/${model.bannerUrl?.ptBr ?? ''}';
      } else if (globalController.langType.value == 4) {
        return '${BranchService.instance.current.asset_url}/${model.bannerUrl?.viVn ?? ''}';
      } else {
        return '${BranchService.instance.current.asset_url}/${model.bannerUrl?.zhCn ?? ''}';
      }
    } else {
      return '${BranchService.instance.current.asset_url}/${model.bannerInfo!.background ?? ''}';
    }
  }
}
