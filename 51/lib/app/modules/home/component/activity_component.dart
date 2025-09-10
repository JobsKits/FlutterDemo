import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_coding_model/activity_coding_model.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/acticity_item.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_component_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_count_timer.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_redbag_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_redbag_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_wheel_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_wheel_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/reabag_rain_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/CommonRipple.dart';
import '../../user/widget/change_language_widget.dart';
import '../widget/home_activity_widget.dart';

class ActivitysComponent extends StatefulWidget {
  const ActivitysComponent({super.key});

  @override
  State<StatefulWidget> createState() => _ActivitysComponentState();
}

class _ActivitysComponentState extends State<ActivitysComponent> {
  final ActivitysComponentController controller =
      Get.put(ActivitysComponentController());
  final ActivitysWheelController awController =
      Get.put(ActivitysWheelController());
  final ActivitysRedbagController arController =
      Get.put(ActivitysRedbagController());
  final NewHomeController homeController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ActivitysRedbagController>();
    super.dispose();
  }

  RxBool isShow = true.obs;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        //百万福利入口
        // Obx(() => Visibility(
        //   visible: controller.models.isNotEmpty,
        //   child: ActivityItem(
        //     model: controller.models.first,
        //     positionX: Get.width - 220.w,
        //     positionY: Get.height - 600.h,
        //     logo: Assets.theme1.images.home.homeActivityEntrance.path,
        //     onClose: () {
        //       isShow.value = false;
        //     },
        //     onPressed: () {
        //       AppManager.instance.tapVibrate();
        //       controller.reqActivityDetails(
        //           controller.models.first.id.toString());
        //     },
        //   ))),
        Obx(() {
          // return Visibility(
          //     visible: controller.models.isNotEmpty,
          //     child: ActivityItem(
          //       model: controller.models.first,
          //       positionX: Get.width - 220.w,
          //       positionY: Get.height - 600.h,
          //       logo: Assets.theme1.images.home.homeActivityEntrance.path,
          //       onClose: () {
          //         isShow.value = false;
          //       },
          //       onPressed: () {
          //         AppManager.instance.tapVibrate();
          //         controller.reqActivityDetails(
          //             controller.models.first.id.toString());
          //       },
          //     ));
          return Visibility(
              visible: isShow.value,
              child: Positioned(
                  top: Get.height - 660.h,
                  left: Get.width - 220.w,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          CommonRipple(
                            onTap: () {
                              AppManager.instance.tapVibrate();
                              controller.reqFloatList((success) => {
                                    if (success)
                                      {
                                        Get.bottomSheet(HomeActivityWidget(
                                            floatModel:
                                                controller.floatModel.value))
                                      }
                                  });
                            },
                            // child: homeController.homeFloatIconPath.value.isNotEmpty ?  Image.network(
                            //   Assets
                            //       .theme1.images.home.homeActivityEntrance.path,
                            //   width: 200.w,
                            //   fit: BoxFit.cover,
                            // ): Image.asset(
                            //   Assets
                            //       .theme1.images.home.homeActivityEntrance.path,
                            //   width: 200.w,
                            //   fit: BoxFit.cover,
                            // ),
                            child: CachedNetworkImage(
                              imageUrl: homeController
                                      .homeFloatIconPath.value.isNotEmpty
                                  ? homeController.homeFloatIconPath.value
                                  : Assets.theme1.images.home
                                      .homeActivityEntrance.path,
                              placeholder: (
                                BuildContext context,
                                String url,
                              ) =>
                                  Image.asset(
                                Assets.theme1.images.home.homeActivityEntrance
                                    .path,
                                width: 200.w,
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (
                                BuildContext context,
                                String url,
                                Object error,
                              ) =>
                                  Image.asset(
                                Assets.theme1.images.home.homeActivityEntrance
                                    .path,
                                width: 200.w,
                                fit: BoxFit.cover,
                              ),
                              width: 200.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      ),
                      // ActivityCountTimer(
                      //   startTime: DateTime.now().millisecondsSinceEpoch,
                      //   endTime: endTime
                      // ),
                      Positioned(
                          top: -26.h,
                          right: 0,
                          child: CommonRipple(
                            onTap: () {
                              AppManager.instance.tapVibrate();
                              isShow.value = false;
                            },
                            child: CircleAvatar(
                              radius: 30.w,
                              backgroundColor:
                                  Color(0xffA6A6A6).withOpacity(0.6),
                              child: SvgPicture.asset(
                                Assets.theme1.images.home.iconDialogClose,
                                width: 26.w,
                                colorFilter: ColorFilter.mode(
                                  Color(0xffafafaf),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ))
                    ],
                  )));
        }),

        //幸运转盘
        // Obx(() => !controller.wheelData.value.isNotEmpty ?
        // Visibility(
        //   visible: true,
        //   child: ActivityItem(
        //     positionX: context.mediaQuerySize.width - 150.w,
        //     positionY: context.mediaQuerySize.height - 400.h,
        //     logo: Assets.theme1.images.home.homeWheel.path,
        //     onClose: () {
        //       awController.wheelStatus.value = false;
        //     },
        //     onPressed: () {
        //       Get.dialog(ActivityWheelDialog(
        //         onClose: (i) {
        //           Navigator.pop(context);
        //         },
        //       ));
        //     },
        //   ),
        // ),
        // : const SizedBox(),
        // ),
        // Obx( () =>
        //   controller.redRainStatus.value
        //     ? Visibility(
        //         visible: true,
        //         child: ActivityItem(
        //           positionX: context.mediaQuerySize.width - 180.w,
        //           positionY: context.mediaQuerySize.height - 400.h,
        //           logo: Assets.theme1.images.home.homeRedRain.path,
        //           onClose: () {
        //             controller.redRainStatus.value = false;
        //           },
        //           onPressed: () {
        //             controller.reqRadbagRainDetail();
        //           },
        //         ),
        //       )
        //     : const SizedBox(),
        // ),

        // Obx(() {
        //   return Visibility(
        //     visible: controller.models.isNotEmpty,
        //     child: controller.models.length == 1
        //         ? ActivityItem(
        //             model: controller.models.first,
        //             positionX: Get.width - 220.w,
        //             positionY: Get.height - 600.h,
        //             logo: Assets.theme1.images.home.homeRedRain.path,
        //             onClose: () {
        //               controller.removeActivityItem(0);
        //             },
        //             onPressed: () {
        //               AppManager.instance.tapVibrate();
        //               controller.reqActivityDetails(
        //                   controller.models.first.id.toString());
        //             },
        //           )
        //         : Positioned(
        //             left: context.mediaQuerySize.width - 300.w,
        //             top: context.mediaQuerySize.height / 2 + 100.h,
        //             child: CarouselSlider.builder(
        //               options: CarouselOptions(
        //                 height: 400.h,
        //                 viewportFraction: 1.0, // 确保每个项完全占据显示区域
        //                 enableInfiniteScroll: true,
        //                 enlargeCenterPage: false,
        //                 autoPlay: true, // 启用自动轮播
        //                 autoPlayInterval: Duration(seconds: 3), // 自动轮播时间间隔
        //                 autoPlayAnimationDuration:
        //                     Duration(milliseconds: 800), // 动画持续时间
        //                 autoPlayCurve: Curves.easeInOut, // 动画曲线
        //               ),
        //               itemCount: controller.models.length,
        //               itemBuilder: (context, index, realIndex) {
        //                 final item = controller.models.value[index];
        //                 return CommonRipple(
        //                   onTap: () {
        //                     AppManager.instance.tapVibrate();
        //                     // controller.reqRadbagRainDetail(item);
        //                     // controller.model.value = item;
        //                     // Get.toNamed(Routes.REDBAG_DETAIL);
        //                     controller.reqActivityDetails(item.id.toString());
        //                   },
        //                   child: ActivityItem(
        //                     model: item,
        //                     positionX: 0, // 在 CarouselSlider 内部无需指定绝对位置
        //                     positionY: 0, // 在 CarouselSlider 内部无需指定绝对位置
        //                     logo: Assets.theme1.images.home.homeRedRain.path,
        //                     onClose: () {
        //                       controller.removeActivityItem(index);
        //                     },
        //                     onPressed: () {
        //                       AppManager.instance.tapVibrate();
        //                       controller.reqActivityDetails(item.id.toString());
        //                     },
        //                   ),
        //                 );
        //               },
        //             ),
        //           ),
        //   );
        // }),

        // Obx(
        //   () => Visibility(
        //     visible: controller.models.value.isNotEmpty,
        //     child: Positioned(
        //       right: 20.w,
        //       bottom: 700.h,
        //       // left: context.mediaQuerySize.width - 300.w,
        //       // top: context.mediaQuerySize.height / 2 + 100.h,
        //       child: controller.models.value.length == 1
        //           ? ActivityItem(
        //               model: controller.models.first,
        //               positionX: 20.w,
        //               positionY: 700.h,
        //               logo: Assets.theme1.images.home.homeRedRain.path,
        //               onClose: () {
        //                 controller.removeActivityItem(0);
        //               },
        //               onPressed: () {
        //                 controller.reqActivityDetails(
        //                     controller.models.first.id.toString());
        //               },
        //             )
        //           : CarouselSlider.builder(
        //               options: CarouselOptions(
        //                 height: 400.h,
        //                 viewportFraction: 1.0, // 确保每个项完全占据显示区域
        //                 enableInfiniteScroll: true,
        //                 enlargeCenterPage: false,
        //                 autoPlay: true, // 启用自动轮播
        //                 autoPlayInterval: Duration(seconds: 3), // 自动轮播时间间隔
        //                 autoPlayAnimationDuration:
        //                     Duration(milliseconds: 800), // 动画持续时间
        //                 autoPlayCurve: Curves.easeInOut, // 动画曲线
        //               ),
        //               itemCount: controller.models.length,
        //               itemBuilder: (context, index, realIndex) {
        //                 final item = controller.models.value[index];
        //                 return CommonRipple(
        //                   onTap: () {
        //                     // controller.reqRadbagRainDetail(item);
        //                     // controller.model.value = item;
        //                     // Get.toNamed(Routes.REDBAG_DETAIL);
        //                     controller.reqActivityDetails(item.id.toString());
        //                   },
        //                   child: ActivityItem(
        //                     model: item,
        //                     positionX: 0, // 在 CarouselSlider 内部无需指定绝对位置
        //                     positionY: 0, // 在 CarouselSlider 内部无需指定绝对位置
        //                     logo: Assets.theme1.images.home.homeRedRain.path,
        //                     onClose: () {
        //                       controller.removeActivityItem(index);
        //                     },
        //                     onPressed: () {
        //                       controller.reqActivityDetails(item.id.toString());
        //                     },
        //                   ),
        //                 );
        //               },
        //             ),
        //     ),
        //   ),
        // ),

        Obx(
          () => arController.redbagModel.value != null
              ? Visibility(
                  visible: arController.wheelStatus.value,
                  child: ActivityRedbagDialog(
                    onClose: (i) {
                      arController.wheelStatus.value =
                          !arController.wheelStatus.value;
                    },
                  ),
                )
              : const SizedBox(),
        ),

        // Obx(() => Visibility(
        //       visible: controller.rainAnimation.value,
        //       child: RedBagRainStartModal(
        //         id: controller.rainId.value,
        //         onClose: () => {
        //           controller.rainAnimation.value =
        //               !controller.rainAnimation.value
        //         },
        //       ),
        //     ))
      ],
    );
  }
}
