import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_turntable_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_info.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/wheel_grid.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/turntable_detail_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/turntable_score_detail.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import '../../../../../utils/CommonRipple.dart';

class ActivityTurntableDetail extends StatefulWidget {
  @override
  _ActivityTurntableDetailState createState() =>
      _ActivityTurntableDetailState();
}

class _ActivityTurntableDetailState extends State<ActivityTurntableDetail>
    with TickerProviderStateMixin {
  final ActivityTurntableController controller =
      Get.put(ActivityTurntableController());

  late Animation<double> _animation;
  late AnimationController _controller;

  RxList<WheelGrid> displayList = <WheelGrid>[].obs;
  bool isOK = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250), // 0.25秒一圈
    )..repeat();

    // 定义旋转动画
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
    _controller.stop();

    displayList.value = _getWheelGridsByType(controller.type.value)!;
  }

  // 开始旋转
  void _startRotation() {
    _controller.repeat();
  }

  void _stopRotation() {
    _controller.stop();
    isOK = false;
  }

  int? getPrizeIndexByAmount(int amout) {
    if (controller.type.value == TirntbaleEnum.silver) {
      return controller.wheelConfig.value.wheelGrids
          ?.indexWhere((prize) => prize.rewordAmount == amout);
    } else if (controller.type.value == TirntbaleEnum.gold) {
      return controller.wheelConfig2.value.wheelGrids
          ?.indexWhere((prize) => prize.rewordAmount == amout);
    } else if (controller.type.value == TirntbaleEnum.diamond) {
      return controller.wheelConfig3.value.wheelGrids
          ?.indexWhere((prize) => prize.rewordAmount == amout);
    }
    return controller.wheelConfig.value.wheelGrids
        ?.indexWhere((prize) => prize.rewordAmount == amout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景图像
          Image.asset(
            Assets.theme1.images.activity.activityTurntableBg.path,
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          // 页面内容
          SafeArea(
            child: Column(
              children: [
                // 顶部导航栏
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 左侧返回按钮
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      // 中间标题
                      const Expanded(
                        child: Text(
                          '活动详情',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // 右侧文本按钮
                      CommonRipple(
                        onTap: () {
                          controller.reqActivityTurntableRecords();
                        },
                        child: const Text(
                          '抽奖记录',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 可滑动内容
                Obx(() => Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 250.h), // 根据需要动态调整
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 40.w,
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      Assets.theme1.images.activity
                                          .activityTurntableG.path,
                                      fit: BoxFit.contain,
                                      width: 60.w,
                                      height: 60.h,
                                    ),
                                    SizedBox(width: 20.w),
                                    Obx(() => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '当前幸运值：${controller.info.value.availableSource ?? 0}',
                                              style: TextStyle(
                                                fontSize: 36.sp,
                                                color: const Color(0xFFFFFFFF),
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            if (controller.actionCfg.type ==
                                                1) ...[
                                              Text(
                                                '还需打码${controller.actionCfg.betSource ?? 0}可获得${1}幸运值',
                                                style: TextStyle(
                                                  fontSize: 36.sp,
                                                  color:
                                                      const Color(0xFFFFFFFF),
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              )
                                            ]
                                          ],
                                        )),
                                    const Spacer(),
                                    if (controller.model.value.actionCfg?.type == 3)
                                      CommonRipple(
                                        onTap: () {
                                          Get.dialog(TurntableScoreDetail(
                                            arguments: {},
                                          ));
                                          // Get.dialog(TurntableRecordsDialog(
                                          //   arguments: {},
                                          // ));
                                        },
                                        child: Text(
                                          '积分规则',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 39.sp,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    SizedBox(width: 10),
                                    CommonRipple(
                                      onTap: () {
                                        Get.dialog(TurntableDetailDialog(
                                            info: controller.info.value,
                                            actionCfg: controller.actionCfg));
                                      },
                                      child: Text(
                                        '详情',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 39.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                            // 顶部图片
                            Image.asset(
                              Assets.theme1.images.activity
                                  .activityLuckyTurntableTitle.path,
                              fit: BoxFit.contain,
                              width: 800.w,
                              height: 320.h,
                            ),

                            // 活动详情部分
                            Obx(() => Text(
                                  '参与幸运大转盘赢取${controller.maxAmount == 0 ? '' : (controller.maxAmount / 1000).truncateToFixed(2).replaceAll(RegExp(r'\.?0*$'), '')}元',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 60.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),

                            Stack(
                              children: [
                                Center(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: 0.85.sw,
                                    height: 0.85.sw,
                                    alignment: Alignment.center,
                                    child: Transform.rotate(
                                      angle: -0.03,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          AnimatedBuilder(
                                            animation: _animation,
                                            builder: (context, child) {
                                              return Transform.rotate(
                                                angle: _animation.value *
                                                    2 *
                                                    pi, // 将动画控制器的值转换为弧度
                                                child: Obx(() => Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Center(
                                                          child: Container(
                                                            width: 0.75.sw,
                                                            height: 0.75.sw,
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        50.h),
                                                            child: Image.asset(
                                                              controller.type
                                                                          .value ==
                                                                      TirntbaleEnum
                                                                          .silver
                                                                  ? Assets
                                                                      .theme1
                                                                      .images
                                                                      .activity
                                                                      .activitySliverCircle
                                                                      .path
                                                                  : controller.type
                                                                              .value ==
                                                                          TirntbaleEnum
                                                                              .gold
                                                                      ? Assets
                                                                          .theme1
                                                                          .images
                                                                          .activity
                                                                          .activityGoldCircle
                                                                          .path
                                                                      : Assets
                                                                          .theme1
                                                                          .images
                                                                          .activity
                                                                          .activityDiamondCircle
                                                                          .path,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        ),

                                                        // 使用 Obx 监听 rotationIdx 的变化
                                                        Obx(() {
                                                          return Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: List.generate(
                                                                getWheelGridsLength(),
                                                                (index) {
                                                              final prize =
                                                                  displayList[
                                                                      index];
                                                              double angle =
                                                                  (360 / getWheelGridsLength()) *
                                                                      index;
                                                              return Transform
                                                                  .rotate(
                                                                angle: angle *
                                                                    (pi / 180),
                                                                child: Align(
                                                                  alignment:
                                                                      const FractionalOffset(
                                                                          0.5,
                                                                          0.21),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Transform
                                                                          .translate(
                                                                        offset: const Offset(
                                                                            0,
                                                                            -20),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            // '${(prize.rewordAmount ?? 0) == 0 ? '' : ((prize.rewordAmount ?? 0) / 1000).truncateToFixed(2).replaceAll(RegExp(r'\.?0*$'), '')}\n元',
                                                                            //  '${(prize.rewordAmount ?? 0) == 0 ? '' : ((prize.rewordAmount ?? 0) / 1000).toStringAsFixed(2)}\n元',
                                                                            '${(prize.rewordAmount ?? 0) == 0 ? '' : ((prize.rewordAmount ?? 0) / 1000).toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '')}\n元',

                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 12,
                                                                              color: Colors.white,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                          );
                                                        }),
                                                      ],
                                                    )),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                CommonRipple(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    if (!LoginManager.instance.isLogin.value) {
                                      showLoginDialog();
                                      return;
                                    }
                                    if (controller.type.value ==
                                            TirntbaleEnum.silver &&
                                        (controller.info.value
                                                    .availableSource ??
                                                0) <
                                            (controller
                                                    .wheelConfig.value.source ??
                                                0)) {
                                      controller
                                          .displayTips('您的积分不足\n请获取积分后再参与');
                                      return;
                                    } else if (controller.type.value ==
                                            TirntbaleEnum.gold &&
                                        (controller.info.value
                                                    .availableSource ??
                                                0) <
                                            (controller.wheelConfig2.value
                                                    .source ??
                                                0)) {
                                      controller
                                          .displayTips('您的积分不足\n请获取积分后再参与');
                                      return;
                                    } else if (controller.type.value ==
                                            TirntbaleEnum.diamond &&
                                        (controller.info.value
                                                    .availableSource ??
                                                0) <
                                            (controller.wheelConfig3.value
                                                    .source ??
                                                0)) {
                                      controller
                                          .displayTips('您的积分不足\n请获取积分后再参与');
                                      return;
                                    }

                                    // 按钮点击事件
                                    if (isOK == false) {
                                      isOK = !isOK;
                                      _startRotation();
                                      Future.delayed(
                                          const Duration(milliseconds: 250),
                                          () {
                                        controller
                                            .reqActivityTurntable((amout) {
                                          _stopRotation();
                                          int rotationIdx =
                                              getPrizeIndexByAmount(amout) ?? 0;
                                          reorderDisplayList(rotationIdx);
                                          setState(() {
                                            _animation =
                                                Tween<double>(begin: 0, end: 0)
                                                    .animate(_controller);
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 250), () {
                                              _animation = Tween<double>(
                                                      begin: 0, end: 2 * pi)
                                                  .animate(_controller);
                                            });
                                          });
                                        });
                                      });
                                    }
                                  },
                                  child: Center(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 110.h),
                                      child: Image.asset(
                                        Assets.theme1.images.activity
                                            .activityStartBtn.path,
                                        fit: BoxFit.contain,
                                        width: 0.8.sw / 2,
                                        height: 0.84.sw / 2,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),

                            Obx(() => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    if (controller.wheelSwitch.contains(1)) ...{
                                      Container(
                                        width: Get.width / 3,
                                        height: 320.h,
                                        child: Stack(
                                          alignment: Alignment.center, // 将子组件居中
                                          children: [
                                            // 图片
                                            Image.asset(
                                              controller.type.value ==
                                                      TirntbaleEnum.silver
                                                  ? Assets
                                                      .theme1
                                                      .images
                                                      .activity
                                                      .turntableButton1Active
                                                      .path
                                                  : Assets
                                                      .theme1
                                                      .images
                                                      .activity
                                                      .turntableButton1
                                                      .path,
                                              fit: BoxFit.cover,
                                              height: 320.h,
                                            ),
                                            // 文字
                                            Positioned(
                                                top: 60.h,
                                                child: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                      // 基础样式，会被子Span继承
                                                      color: Colors.white,
                                                      fontFamily: 'MiSans',
                                                    ),
                                                    children: [
                                                      // 第一行：钻石转盘（大标题）
                                                      TextSpan(
                                                        text: "白银转盘",
                                                        style: TextStyle(
                                                          fontSize: 46.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      // 第二行：数值 + 幸运值
                                                      TextSpan(
                                                        text: "\n", // 先换行
                                                        children: [
                                                          // 数值部分
                                                          TextSpan(
                                                            text:
                                                                "${controller.wheelConfig.value.source}",
                                                            style: TextStyle(
                                                              fontSize: 34
                                                                  .sp, // 确保这个值足够大
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          // 文字部分
                                                          TextSpan(
                                                            text: "幸运值",
                                                            style: TextStyle(
                                                              fontSize: 28.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ).onTap(() {
                                        controller.type.value =
                                            TirntbaleEnum.silver;
                                        displayList.value =
                                            _getWheelGridsByType(
                                                controller.type.value)!;
                                      }),
                                    },
                                    if (controller.wheelSwitch.contains(2)) ...{
                                      Container(
                                        width: Get.width / 3,
                                        height: 320.h,
                                        child: Stack(
                                          alignment: Alignment.center, // 将子组件居中
                                          children: [
                                            // 图片
                                            Image.asset(
                                              controller.type.value ==
                                                      TirntbaleEnum.gold
                                                  ? Assets
                                                      .theme1
                                                      .images
                                                      .activity
                                                      .turntableButton2Active
                                                      .path
                                                  : Assets
                                                      .theme1
                                                      .images
                                                      .activity
                                                      .turntableButton2
                                                      .path,
                                              fit: BoxFit.cover,
                                              height: 320.h,
                                            ),
                                            // 文字
                                            Positioned(
                                                top: 60.h,
                                                child: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                      // 基础样式，会被子Span继承
                                                      color: Colors.white,
                                                      fontFamily: 'MiSans',
                                                    ),
                                                    children: [
                                                      // 第一行：钻石转盘（大标题）
                                                      TextSpan(
                                                        text: "黄金转盘",
                                                        style: TextStyle(
                                                          fontSize: 46.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      // 第二行：数值 + 幸运值
                                                      TextSpan(
                                                        text: "\n", // 先换行
                                                        children: [
                                                          // 数值部分
                                                          TextSpan(
                                                            text:
                                                                "${controller.wheelConfig2.value.source}",
                                                            style: TextStyle(
                                                              fontSize: 34
                                                                  .sp, // 确保这个值足够大
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          // 文字部分
                                                          TextSpan(
                                                            text: "幸运值",
                                                            style: TextStyle(
                                                              fontSize: 28.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ).onTap(() {
                                        controller.type.value =
                                            TirntbaleEnum.gold;
                                        displayList.value =
                                            _getWheelGridsByType(
                                                controller.type.value)!;
                                      }),
                                    },
                                    if (controller.wheelSwitch.contains(3)) ...{
                                      Container(
                                        width: Get.width / 3,
                                        height: 320.h,
                                        child: Stack(
                                          alignment: Alignment.center, // 将子组件居中
                                          children: [
                                            // 图片
                                            Image.asset(
                                              controller.type.value ==
                                                      TirntbaleEnum.diamond
                                                  ? Assets
                                                      .theme1
                                                      .images
                                                      .activity
                                                      .turntableButton3Active
                                                      .path
                                                  : Assets
                                                      .theme1
                                                      .images
                                                      .activity
                                                      .turntableButton3
                                                      .path,
                                              fit: BoxFit.cover,
                                              height: 320.h,
                                            ),
                                            // 文字
                                            Positioned(
                                                top: 60.h,
                                                child: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                      // 基础样式，会被子Span继承
                                                      color: Colors.white,
                                                      fontFamily: 'MiSans',
                                                    ),
                                                    children: [
                                                      // 第一行：钻石转盘（大标题）
                                                      TextSpan(
                                                        text: "钻石转盘",
                                                        style: TextStyle(
                                                          fontSize: 46.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      // 第二行：数值 + 幸运值
                                                      TextSpan(
                                                        text: "\n", // 先换行
                                                        children: [
                                                          // 数值部分
                                                          TextSpan(
                                                            text:
                                                                "${controller.wheelConfig3.value.source}",
                                                            style: TextStyle(
                                                              fontSize: 34
                                                                  .sp, // 确保这个值足够大
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          // 文字部分
                                                          TextSpan(
                                                            text: "幸运值",
                                                            style: TextStyle(
                                                              fontSize: 28.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ).onTap(() {
                                        controller.type.value =
                                            TirntbaleEnum.diamond;
                                        displayList.value =
                                            _getWheelGridsByType(
                                                controller.type.value)!;
                                      })
                                    },
                                  ],
                                )),

                            if (controller.actionCfg.type == 2 &&
                                (controller.info.value.taskConfigs?.length ??
                                        0) >
                                    0) ...[
                              Obx(() => Container(
                                    child: Stack(
                                      children: [
                                        // 主要内容
                                        Container(
                                          width: 0.98.sw,
                                          margin: EdgeInsets.only(
                                              top: 60.h,
                                              left: 30.w,
                                              right: 30.w),
                                          padding: EdgeInsets.all(50.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                          child: Column(
                                            children: [
                                              // 动态生成任务列表
                                              if (controller
                                                      .info.value.taskConfigs !=
                                                  null)
                                                ...controller
                                                    .info.value.taskConfigs!
                                                    .map((taskConfig) {
                                                  return Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 20
                                                            .h), // 每个 Container 之间的间距
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ConstrainedBox(
                                                                  constraints:
                                                                      BoxConstraints(
                                                                    maxWidth:
                                                                        0.6.sw,
                                                                  ),
                                                                  child: Text(
                                                                    getTaskDescription(
                                                                        taskConfig),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          32.sp,
                                                                      color: const Color(
                                                                          0xFF2D2D2D),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                                if (taskConfig
                                                                            .type ==
                                                                        'TOTAL_RECHARGE' ||
                                                                    taskConfig
                                                                            .type ==
                                                                        'BET_AMOUNT') ...[
                                                                  const SizedBox(
                                                                      height:
                                                                          8),
                                                                  buildProgressBar(
                                                                      taskConfig)
                                                                ]
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                            _buildLoginOutButton(
                                                                taskConfig), // 右侧按钮
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40.w,
                                                vertical: 10.h),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(40.r),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0xffFFE7E7),
                                                  offset: Offset(0, 12.h),
                                                  blurRadius: 21.h,
                                                ),
                                                BoxShadow(
                                                  color:
                                                      const Color(0xffFFE7E7),
                                                  offset: Offset(0, 7.h),
                                                  blurRadius: 0,
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              '每日任务',
                                              style: TextStyle(
                                                fontSize: 46.sp,
                                                color: const Color(0xFFea2728),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],

                            // 活动规则部分
                            Container(
                              margin: EdgeInsets.only(
                                  top: 38.h, left: 30.w, right: 30.w),
                              padding: EdgeInsets.all(50.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 12.w,
                                        height: 46.w,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(6.w),
                                            bottom: Radius.circular(6.w),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20.w),
                                      Text(
                                        '活动规则',
                                        style: TextStyle(
                                          fontSize: 51.sp,
                                          color: const Color(0xFF2D2D2D),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.w),
                                  HtmlWidget(
                                    controller.model.value.activityRule ?? '',
                                    textStyle: TextStyle(
                                      fontSize: 39.sp,
                                      color: const Color(0xFF4B4B4B),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getTaskDescription(TaskConfigs taskConfig) {
    if (taskConfig.type == "SIGN_RECHARGE") {
      return '单笔充值${(taskConfig.target! / 1000).truncateToFixed(0)}获得${taskConfig.source}积分';
    } else if (taskConfig.type == "TOTAL_RECHARGE") {
      return '累计充值${(taskConfig.target! / 1000).truncateToFixed(0)}获得${taskConfig.source}积分 (${(taskConfig.current! / 1000).truncateToFixed(0)}/${(taskConfig.target! / 1000).truncateToFixed(0)})';
    } else if (taskConfig.type == "BET_AMOUNT") {
      return '有效投注${(taskConfig.target! / 1000).truncateToFixed(0)}获得${taskConfig.source}积分 (${(taskConfig.current! / 1000).truncateToFixed(0)}/${(taskConfig.target! / 1000).truncateToFixed(0)})';
    } else {
      return '未知类型';
    }
  }

  // 提取一个函数来构建进度条
  Widget buildProgressBar(TaskConfigs taskConfig) {
    final clampedProgress = (taskConfig.current ?? 0) /
        (taskConfig.target ?? 1); // 避免 target 为 null
    final progress = clampedProgress.clamp(0.0, 1.0); // 限制进度在 0 到 1 之间

    return Container(
      height: 8, // 进度条高度
      width: 0.6.sw,
      decoration: BoxDecoration(
        color: Colors.grey[300], // 背景色为灰色
        borderRadius: BorderRadius.circular(4), // 圆角
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 8, // 进度条高度
          width: 0.6.sw * progress, // 基于父容器宽度计算进度条宽度
          decoration: BoxDecoration(
            color: Colors.red, // 进度条颜色为红色
            borderRadius: BorderRadius.circular(4), // 圆角
          ),
        ),
      ),
    );
  }

  void reorderDisplayList(int index) {
    if (displayList.isEmpty) {
      return; // 如果 displayList 为空，直接返回
    }

    // 确保 index 在有效范围内
    index = index % displayList.length;

    // 重新排序数据
    final List<WheelGrid> reorderedList = [
      ...displayList.sublist(index), // 从 index 开始的部分
      ...displayList.sublist(0, index), // index 之前的部分
    ];

    // 更新 displayList
    displayList.assignAll(reorderedList);

    print({'reorderDisplayList ====== ${displayList}'});
  }

  // 根据类型获取对应的 wheelGrids
  List<WheelGrid>? _getWheelGridsByType(TirntbaleEnum type) {
    switch (type) {
      case TirntbaleEnum.silver:
        return controller.wheelConfig.value.wheelGrids;
      case TirntbaleEnum.gold:
        return controller.wheelConfig2.value.wheelGrids;
      case TirntbaleEnum.diamond:
        return controller.wheelConfig3.value.wheelGrids;
      default:
        return null; // 默认情况
    }
  }

  // 提取一个函数来获取 prize
  dynamic getPrizeByType(int index) {
    switch (controller.type.value) {
      case TirntbaleEnum.silver:
        return controller.wheelConfig.value.wheelGrids?[index];
      case TirntbaleEnum.gold:
        return controller.wheelConfig2.value.wheelGrids?[index];
      case TirntbaleEnum.diamond:
        return controller.wheelConfig3.value.wheelGrids?[index];
      default:
        return null; // 默认情况
    }
  }

  int getWheelGridsLength() {
    if (controller.type.value == TirntbaleEnum.silver) {
      return controller.wheelConfig.value.wheelGrids?.length ?? 0;
    } else if (controller.type.value == TirntbaleEnum.gold) {
      return controller.wheelConfig2.value.wheelGrids?.length ?? 0;
    } else if (controller.type.value == TirntbaleEnum.diamond) {
      return controller.wheelConfig3.value.wheelGrids?.length ?? 0;
    } else {
      return 0; // 默认情况
    }
  }

  Widget _buildLoginOutButton(TaskConfigs taskConfig) {
    return CommonRipple(
      onTap: () {
        if (taskConfig.isDone ?? false) {
          return;
        }
        if (taskConfig.current! >= taskConfig.target!) {
          taskConfig.isDone = true;
          setState(() {});
          controller.reqActivityTaskIntegral(taskConfig);
        } else {
          Get.back();
          if (taskConfig.type == "SIGN_RECHARGE") {
            var isOpenVideo =
                TenantManager.instance.tenantBean?.isOpenVideo == 'true';
            controller.hcController.tabsController
                .jumpToPage(isOpenVideo ? 2 : 1);
          } else if (taskConfig.type == "TOTAL_RECHARGE") {
            var isOpenVideo =
                TenantManager.instance.tenantBean?.isOpenVideo == 'true';
            controller.hcController.tabsController
                .jumpToPage(isOpenVideo ? 2 : 1);
          } else if (taskConfig.type == "BET_AMOUNT") {
            controller.hcController.tabsController.jumpToPage(0);
          }
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: 180.w,
        decoration: BoxDecoration(
            color: taskConfig.isDone ?? false
                ? Colors.red.withAlpha(100)
                : (taskConfig.current! >= taskConfig.target!)
                    ? Colors.red
                    : const Color(0xffFBE8E7),
            borderRadius: BorderRadius.circular(80.r)),
        height: 35,
        child: Text(
          taskConfig.isDone ?? false
              ? "领取"
              : ((taskConfig.current ?? 0) >= (taskConfig.target ?? 0))
                  ? "领取"
                  : "去完成",
          style: TextStyle(
              fontSize: 28.sp,
              color: (taskConfig.current! >= taskConfig.target!)
                  ? Colors.white
                  : const Color(0xffea2728)),
        ),
      ),
    );
  }
}
