import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/controllers/lottery_home_controller.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';
import '../../../../utils/CommonRipple.dart';

class LotteryHomePage extends GetView<LotteryController> {
  const LotteryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LotteryController());
    return Scaffold(
        backgroundColor: Colors.transparent, // 设置背景透明
        body: Obx(() => Stack(
              children: [
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                ),
                Positioned(
                    top: Get.height - (Get.height / 1.6),
                    child: container(context)),
                Positioned(
                    bottom: 86,
                    left: 120,
                    child: Container(
                      width: 170,
                      height: 40,
                      padding: const EdgeInsets.all(4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xA1A1A169),
                            offset: Offset(0, 0),
                            blurRadius: 27,
                            spreadRadius: 0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              // width: 160,
                              // height: 40,
                              padding: const EdgeInsets.only(
                                  left: 6, right: 6, top: 6, bottom: 6),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xA1f6f6f6),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Image.asset(
                                Assets.theme1.images.lottery.del.path,
                                width: 60.w,
                                height: 60.h,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text("共1注10元", style: TextStyle(fontSize: 16))
                          ]),
                    )),
                // controller.chipStatus.value
                Visibility(
                    visible: controller.chipStatus.value,
                    child: Positioned(
                      bottom: 78,
                      left: 10,
                      child: Stack(children: [
                        Container(
                          width: 1.sw - 20,
                          height: 60,
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 4, left: 10, right: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xA1A1A169),
                                offset: Offset(0, 0),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 120,
                                  height: 40,
                                  padding: const EdgeInsets.only(
                                      left: 6, right: 6, top: 6, bottom: 6),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xA1f6f6f6),
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                      color: const Color(
                                          0xffdddddd), // 设置边框颜色，你可以根据需求调整
                                      width: 1, // 设置边框宽度为1
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  Assets.theme1.images.lottery.chips5.path,
                                  width: 110.w,
                                  height: 110.h,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Image.asset(
                                  Assets.theme1.images.lottery.chips10.path,
                                  width: 110.w,
                                  height: 110.h,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Image.asset(
                                  Assets.theme1.images.lottery.chips50.path,
                                  width: 110.w,
                                  height: 110.h,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Image.asset(
                                  Assets.theme1.images.lottery.chips100.path,
                                  width: 110.w,
                                  height: 110.h,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Image.asset(
                                  Assets.theme1.images.lottery.chips200.path,
                                  width: 110.w,
                                  height: 110.h,
                                ),
                              ]),
                        ),
                        const Positioned(
                          top: 4,
                          left: 46,
                          child: Text(
                            '投注金额',
                            style: TextStyle(
                              color: Color(0xff898989),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ]),
                    )),
                Visibility(
                  visible: controller.showBetStatus.value,
                  child: Positioned(
                      top: Get.height - (Get.height / 1.6),
                      child: _betContainer(context)),
                )
              ],
            )));
  }

  Widget container(BuildContext context) {
    return Stack(children: [
      Container(
          width: Get.width,
          height: Get.height / 1.6,
          decoration: const BoxDecoration(
            color: Color(0xFF10C8E3),
            // color: Color(0xFFf0f0f0),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), // Adjust the radius as needed
              topRight: Radius.circular(20.0), // Adjust the radius as needed
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centers the content horizontally
                      children: [
                        Center(
                          child: Text(
                            "一分快三",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                            width: 5), // Add some space between text and icon
                        Icon(Icons.lightbulb_circle_rounded,
                            color: Colors.white), // Exclamation mark icon
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      AppManager.instance.tapVibrate();
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ), // Close button
                  ),
                ],
              ),
              Container(
                  // width: Get.width,
                  // height: Get.height / 2,
                  padding: EdgeInsets.only(
                      left: 50.w, right: 50.w, bottom: 30.w, top: 30.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFFDFF),
                    borderRadius: BorderRadius.only(
                      topLeft:
                          Radius.circular(20.0), // Adjust the radius as needed
                      topRight:
                          Radius.circular(20.0), // Adjust the radius as needed
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        Row(
                          children: [
                            Image.asset(
                              Assets.theme1.images.lottery.lotteryDice1.path,
                              width: 80.w,
                              height: 80.h,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Image.asset(
                              Assets.theme1.images.lottery.lotteryDice1.path,
                              width: 80.w,
                              height: 80.h,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Image.asset(
                              Assets.theme1.images.lottery.lotteryDice1.path,
                              width: 80.w,
                              height: 80.h,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "09",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "小",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "单",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Text(
                          "第240723001期开奖结果",
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF747C7D)),
                        ),
                      ]),
                      const Column(children: [
                        Text(
                          "00:36",
                          style: TextStyle(
                            fontSize: 24, // 字体大小
                            fontWeight: FontWeight.bold, // 字体粗细
                            color: Colors.red, // 字体颜色
                            fontFamily: 'FX-LED', // 字体家族
                          ),
                        ),
                        Text(
                          "第240723002期倒计时",
                          style: TextStyle(
                              fontSize: 14, color: Color(0xFF747C7D)),
                        ),
                      ])
                    ],
                  )),
              _buildTabBar(),
            ],
          )),
      // 底部下注部分
      Positioned(
          bottom: 0, // 距离页面底部
          left: 0,
          right: 0,
          child: Container(
            width: context.mediaQuerySize.width,
            height: 80 + context.mediaQueryPadding.bottom,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x66717171),
                  offset: Offset(0, -4),
                  blurRadius: 35,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: context.mediaQueryPadding.bottom,
                      top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 10, vertical: 4),
                          //   decoration: BoxDecoration(
                          //       color: controller.chasingNumber.isEmpty
                          //           ? context
                          //               .customTheme?.chasingNumberDisableBg
                          //           : context.customTheme?.robotSelectBg,
                          //       borderRadius: 5.radius),
                          //   child: Text("追号",
                          //       style: context.textTheme.bodyMedium
                          //           ?.copyWith(
                          //               color: context.customTheme
                          //                   ?.reverseFontColor)),
                          // ).onTap(() => controller.handleSubmit(true)),
                          // Container(
                          //   margin: const EdgeInsets.only(top: 5),
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 10, vertical: 4),
                          //   decoration: BoxDecoration(
                          //       color: Colors.red,
                          //       borderRadius: 5.radius),
                          //   child: Text("机选",
                          //       style: context.textTheme.bodyMedium
                          //           ?.copyWith(
                          //               color: context.customTheme
                          //                   ?.reverseFontColor)),
                          // ).onTap(controller.handleRobotSelect),
                        ],
                      ),
                      // 下注，筹码，输入框
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 6),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "账户余额",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFF1F1F1F),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: const Color(0xFF10C8E3),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8,
                                                          right: 8,
                                                          bottom: 2),
                                                  child: const Text(
                                                    "充值",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF10C8E3),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                )
                                              ]),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  "￥",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF1F1F1F),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const Text(
                                                  "0.00",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Color(0xFF1F1F1F),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Image.asset(
                                                  Assets.theme1.images.lottery
                                                      .shuaxing.path,
                                                  width: 40.w,
                                                  height: 40.h,
                                                ),
                                              ]),
                                        ]),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image.asset(
                                                  Assets.theme1.images.lottery
                                                      .chips10.path,
                                                  width: 130.w,
                                                  height: 130.h,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Image.asset(
                                                  Assets.theme1.images.lottery
                                                      .gengduo.path,
                                                  width: 64.w,
                                                  height: 64.h,
                                                ),
                                              ]),
                                        ]).onTap(() {
                                      AppManager.instance.tapVibrate();
                                      controller.handleOpenChip();
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          Container(
                              alignment: Alignment.center,
                              width: 110,
                              height: 48,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF10C8E3),
                                      Color(0xFF1FEBFD),
                                    ],
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xB200DEFF),
                                      offset: Offset(0, 4),
                                      blurRadius: 6,
                                      spreadRadius: 0,
                                    ),
                                    BoxShadow(
                                      color: Color(0xFF00DEFF),
                                      offset: Offset(0, 2),
                                      blurRadius: 0,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(100)),
                              child: Text("投注",
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18))
                                  .onTap(() {
                                AppManager.instance.tapVibrate();
                                controller.handleOpenBet();
                              })),
                        ],
                      ).paddingOnly(left: 10)
                    ],
                  ),
                ),

                // Positioned(
                //     bottom: 0,
                //     child: Obx(
                //       () => controller.select.value.name != "ofclk3mmc"
                //           ? controller.closeingTimeNumber.value <= 0 ||
                //                   controller.getNextIsu.value.isSeal == "1"
                //               ? Container(
                //                   width: context.mediaQuerySize.width,
                //                   height: 100 +
                //                       context.mediaQueryPadding.bottom,
                //                   padding: EdgeInsets.only(top: 10),
                //                   color: context.customTheme?.error
                //                       ?.withOpacity(.8),
                //                   // color: Colors.red,
                //                   alignment: Alignment.center,
                //                   child: Text('已封盘',
                //                       style: context.textTheme.titleMedium
                //                           ?.copyWith(
                //                               color: context.customTheme
                //                                   ?.reverseFontColor,
                //                               fontWeight: FontWeight.w700)),
                //                 )
                //               : const SizedBox()
                //           : const SizedBox(),
                //     ))
              ],
            ),
          )),
    ]);
  }

  Widget _buildTabBar() {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: Get.width,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFf0f0f0),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0), // Adjust the radius as needed
                topRight: Radius.circular(10.0), // Adjust the radius as needed
              ),
            ),
            // decoration: const BoxDecoration(
            //     color: Color(0x1FF0F0F0),
            //     border: Border(right: BorderSide(width: .5, color: Colors.lightGreen))
            // ),
            child: Scrollbar(
              controller: controller.scrollController,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  scrollDirection: Axis.horizontal,
                  controller: controller.scrollController,
                  itemCount: controller.categories1.length,
                  itemBuilder: (context, index) {
                    final name = controller.categories1[index];
                    return Container(
                        width: Get.width / controller.categories1.length,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0x1FF0F0F0),
                            border: Border.all(
                              width: 1,
                              color: (controller.menuActive.value == index
                                  ? const Color(0x1FF0F0F0)
                                  : Colors.transparent),
                            )),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(name).onTap(() {
                          AppManager.instance.tapVibrate();
                          controller.handleLeftMednuActive(index, name);
                        }));
                  }),
            ),
          ),
          Expanded(
            child: Container(
                color: Colors.grey[300],
                child: controller
                    .lhcSpecialWidget(controller.menuActiveDetail.value)),
          )
        ],
      ),
    );
  }

  Widget _betContainer(BuildContext context) {
    return Stack(children: [
      Container(
          width: Get.width,
          height: Get.height / 1.6,
          decoration: const BoxDecoration(
            color: Color(0xFFF7F7F7),
            // color: Color(0xFFf0f0f0),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), // Adjust the radius as needed
              topRight: Radius.circular(20.0), // Adjust the radius as needed
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "投注单",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      AppManager.instance.tapVibrate();
                      controller.handleOpenBet();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFFEEEEEE),
                    ), // Close button
                  ),
                ],
              ),
            ],
          )),

      // 底部下注部分
      Positioned(
          bottom: 0, // 距离页面底部
          left: 0,
          right: 0,
          child: Container(
            width: context.mediaQuerySize.width,
            height: 80 + context.mediaQueryPadding.bottom,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x66717171),
                  offset: Offset(0, -4),
                  blurRadius: 35,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: context.mediaQueryPadding.bottom,
                      top: 10),
                  child: const SizedBox(),
                ),
              ],
            ),
          )),
    ]);
  }
}
