import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_turntable_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/activity_turntable_detail_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/wheel_config.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/wheel_grid.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/turntable_detail_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_turntable_dialog_controller.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/CommonRipple.dart';

class ActivityTurntableDialog extends StatefulWidget {
  final ActivityTurntableDetailModel? model;
  final VoidCallback? onPress;
  final VoidCallback? requestBag;
  final VoidCallback? onClose;

  const ActivityTurntableDialog({
    super.key,
    this.model,
    this.onPress,
    this.requestBag,
    this.onClose,
  });

  @override
  _ActivityTurntableDialogState createState() =>
      _ActivityTurntableDialogState();
}

class _ActivityTurntableDialogState extends State<ActivityTurntableDialog>
    with SingleTickerProviderStateMixin {
  final ActivityTurntableDialogController controller =
      Get.put(ActivityTurntableDialogController());

  RxBool isToday = false.obs;
  RxBool isNotDisplay = false.obs;

  late Animation<double> _animation;
  late AnimationController _controller;

  RxList<WheelGrid> displayList = <WheelGrid>[].obs;

  @override
  void initState() {
    super.initState();

    if (widget.model != null) {
      controller.model.value = widget.model!;
      controller.reqActivityTurntableDetail();
      controller.reqActivityTurntableRecords();
    }

    final data = widget.model?.actionCfg;
    controller.actionCfg = data;
    final List configs = data?.wheelConfigs as List;
    if (configs.isNotEmpty) {
      controller.wheelConfig.value = WheelConfig.fromJson(configs.first);
    }
    if (configs.length >= 2) {
      controller.wheelConfig2.value = WheelConfig.fromJson(configs[1]);
    }
    if (configs.length >= 3) {
      controller.wheelConfig3.value = WheelConfig.fromJson(configs[2]);
    }

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
  }

  void isTodayDisplay(bool? isCheck) {
    isToday.value = isCheck ?? !isToday.value;
    if (LoginManager.instance.isLogin.value) {
      saveToday("{'local'}turntableLoginToday", isToday.value);
    } else {
      saveToday("{'local'}turntableToday", isToday.value);
    }
  }

  void iseveryNotDisplay(bool? isCheck) {
    isNotDisplay.value = isCheck ?? !isNotDisplay.value;
    if (LoginManager.instance.isLogin.value) {
      saveInfo("{'local'}turntableLoginNaver", isNotDisplay.value);
    } else {
      saveInfo("{'local'}turntableNaver", isNotDisplay.value);
    }
  }

  void saveToday(String saveName, bool value) async {
    if (value) {
      int timestampSeconds = DateTime.now().millisecondsSinceEpoch;
      await SpUtil.saveInt(saveName, timestampSeconds);
    } else {
      await SpUtil.saveInt(saveName, 0);
    }
  }

  //保存用户信息，内存、本地各一份
  void saveInfo(String saveName, bool value) async {
    await SpUtil.saveBool(saveName, value);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.transparent.withOpacity(0),
            ),
          ),
          Align(
            // 使用 Align 包裹 Positioned
            alignment: Alignment.center, // 居中
            child: Column(
              mainAxisSize: MainAxisSize.min, // 使 Column 仅占用所需空间
              children: [
                Container(
                  width: 0.9.sw, // Dialog width as a percentage of screen width
                  height: 0.625.sh, // Dialog height as a percentage of screen height
                  decoration: BoxDecoration(
                    color: context.customTheme?.dialogBgColor,
                    borderRadius: BorderRadius.circular(12.5),
                  ),
                  child: Column(
                    children: [
                      _buildTitle(context), // Title fixed at the top
                      Expanded(
                        child: SingleChildScrollView(
                          // Only the body scrolls
                          child: _buildBody(context),
                        ),
                      ),
                      _buildBottom(context), // Bottom fixed at the bottom
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: context.theme.cardColor.withOpacity(.9),
                    borderRadius: BorderRadius.circular(12.5),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.close_sharp,
                    color: Colors.red,
                    size: 15,
                  ),
                ).onTap(() {
                  Get.back();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.model?.activityName ?? '',
                style: TextStyle(
                  color: context.customTheme?.titleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFunctions(context),
        _buildValue(context),
        _buildTurntable(context),
        _buildTab(context),
        _buildContent(context),
      ],
    );
  }

  Widget _buildFunctions(BuildContext context) {
    return Container(
      // height: 40,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        color: context.customTheme?.dialogBgColor,
      ),
      child: Center(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.functionsList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15, // Horizontal space between items
              mainAxisSpacing: 15, // Vertical space between items
              childAspectRatio: 2.5),
          itemBuilder: (context, index) {
            return Obx(() => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: controller.type.value == TirntbaleEnum.silver &&
                                index == 0 ||
                            controller.type.value == TirntbaleEnum.gold &&
                                index == 1 ||
                            controller.type.value == TirntbaleEnum.diamond &&
                                index == 2
                            ? context.theme.primaryColor
                            : context.customTheme?.inputBgColor,
                  ),
                  child: CommonRipple(
                    onTap: () {
                      if (index == 0) {
                        controller.type.value = TirntbaleEnum.silver;
                        controller.wheelType =
                            controller.wheelConfig.value.wheelType ?? 1;
                      } else if (index == 1) {
                        controller.type.value = TirntbaleEnum.gold;
                        controller.wheelType =
                            controller.wheelConfig2.value.wheelType ?? 1;
                      } else if (index == 2) {
                        controller.type.value = TirntbaleEnum.diamond;
                        controller.wheelType =
                            controller.wheelConfig3.value.wheelType ?? 1;
                      }
                      displayList.value =
                          _getWheelGridsByType(controller.type.value)!;
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.functionsList[index]['title'],
                          style: TextStyle(
                              color: controller.type.value ==
                                              TirntbaleEnum.silver &&
                                          index == 0 ||
                                      controller.type.value ==
                                              TirntbaleEnum.gold &&
                                          index == 1 ||
                                      controller.type.value ==
                                              TirntbaleEnum.diamond &&
                                          index == 2
                                        ? context.customTheme?.msTextColor
                                        : context.customTheme?.mnTextColor,
                              fontSize: 38.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          index == 0
                              ? '${controller.wheelConfig.value.source}幸运值'
                              : index == 1
                                  ? '${controller.wheelConfig2.value.source}幸运值'
                                  : index == 2
                                      ? '${controller.wheelConfig3.value.source}幸运值'
                                      : '-',
                          style: TextStyle(
                              color: controller.type.value ==
                                              TirntbaleEnum.silver &&
                                          index == 0 ||
                                      controller.type.value ==
                                              TirntbaleEnum.gold &&
                                          index == 1 ||
                                      controller.type.value ==
                                              TirntbaleEnum.diamond &&
                                          index == 2
                                        ? context.customTheme?.msTextColor
                                        : context.customTheme?.mnTextColor,
                              fontSize: 28.sp),
                        ),
                      ],
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }

  String getSource() {
    switch (controller.type.value) {
      case TirntbaleEnum.silver:
        return '${controller.wheelConfig.value.source}';
      case TirntbaleEnum.gold:
        return '${controller.wheelConfig2.value.source}';
      case TirntbaleEnum.diamond:
        return '${controller.wheelConfig3.value.source}';
      default:
        return '';
    }
  }

  Widget _buildValue(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
        child: Row(
          children: [
            Image.asset(
              Assets.theme1.images.activity.activityTurntableG.path,
              fit: BoxFit.contain,
              width: 60.w,
              height: 60.h,
            ),
            SizedBox(width: 20.w),
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        text: '当前幸运值：',
                        style: TextStyle(
                          fontSize: 36.sp,
                          color: const Color(0xFF6DA2AD),
                        ),
                        children: [
                          TextSpan(
                            text:
                                '${controller.info.value.availableSource ?? 0}',
                            style: TextStyle(
                              color: const Color(0xFFFF5A5A),
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            const Spacer(),
            CommonRipple(
              onTap: () {
                Get.dialog(TurntableDetailDialog(
                    info: controller.info.value,
                    actionCfg: controller.actionCfg));
              },
              child: Text(
                '详情',
                style: TextStyle(
                  color: const Color(theme01MainColor),
                  fontSize: 39.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildTurntable(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 0.85.sw,
            height: 0.85.sw,
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation.value,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Obx(() => Container(
                                    width: 0.75.sw,
                                    height: 0.75.sw,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 50.h),
                                    child: Image.asset(
                                      controller.type.value ==
                                              TirntbaleEnum.silver
                                          ? Assets.theme1.images.activity
                                              .activitySliverCircle.path
                                          : controller.type.value ==
                                                  TirntbaleEnum.gold
                                              ? Assets.theme1.images.activity
                                                  .activityGoldCircle.path
                                              : Assets.theme1.images.activity
                                                  .activityDiamondCircle.path,
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                            ),
                            Obx(() {
                              return Stack(
                                alignment: Alignment.center,
                                children: List.generate(getWheelGridsLength(),
                                    (index) {
                                  final prize = displayList[index];
                                  double angle =
                                      (360 / getWheelGridsLength()) * index;
                                  return Transform.rotate(
                                    angle: angle * (pi / 180),
                                    child: Align(
                                      alignment:
                                          const FractionalOffset(0.5, 0.21),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Transform.translate(
                                            offset: const Offset(0, -20),
                                            child: Center(
                                              child: Text(
                                                '${(prize.rewordAmount ?? 0) == 0 ? '' : ((prize.rewordAmount ?? 0) / 1000).truncateToFixed(2).replaceAll(RegExp(r'\.?0*$'), '')}\n元',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
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
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        CommonRipple(
          onTap: () {
            if (!LoginManager.instance.isLogin.value) {
              Get.back();
              showLoginDialog();
              return;
            }
            if (controller.type.value == TirntbaleEnum.silver &&
                (controller.info.value.availableSource ?? 0) <
                    (controller.wheelConfig.value.source ?? 0)) {
              controller.displayTips('您的积分不足\n请获取积分后再参与');
              return;
            } else if (controller.type.value == TirntbaleEnum.gold &&
                (controller.info.value.availableSource ?? 0) <
                    (controller.wheelConfig2.value.source ?? 0)) {
              controller.displayTips('您的积分不足\n请获取积分后再参与');
              return;
            } else if (controller.type.value == TirntbaleEnum.diamond &&
                (controller.info.value.availableSource ?? 0) <
                    (controller.wheelConfig3.value.source ?? 0)) {
              controller.displayTips('您的积分不足\n请获取积分后再参与');
              return;
            }

            // 按钮点击事件
            _startRotation();
            Future.delayed(const Duration(milliseconds: 250), () {
              controller.reqActivityTurntable((amout) {
                _stopRotation();
                int rotationIdx = getPrizeIndexByAmount(amout) ?? 0;
                reorderDisplayList(rotationIdx);
                setState(() {
                  _animation =
                      Tween<double>(begin: 0, end: 0).animate(_controller);
                  Future.delayed(const Duration(milliseconds: 250), () {
                    _animation = Tween<double>(begin: 0, end: 2 * pi)
                        .animate(_controller);
                  });
                });
              });
            });
          },
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 110.h),
              child: Image.asset(
                Assets.theme1.images.activity.activityStartBtn.path,
                fit: BoxFit.contain,
                width: 0.8.sw / 2,
                height: 0.84.sw / 2,
              ),
            ),
          ),
        )
      ],
    );
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

  Widget _buildTab(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 40.w,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildButton(0, "规则"),
                SizedBox(width: 30.w),
                _buildButton(1, "记录"),
              ],
            ),
          ],
        ));
  }

  Widget _buildContent(BuildContext context) {
    return Obx(() => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Container(
          margin:
              EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w, bottom: 38.h),
          padding: EdgeInsets.all(50.w),
          decoration: BoxDecoration(
              color: context.customTheme?.inputBgColor,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: context.customTheme?.inputBgColor ?? Colors.white,
                  offset: Offset(0, 6.w),
                  blurRadius: 10.w,
                ),
              ]),
          child: controller.index.value == 0
              ? HtmlWidget(
                  widget.model?.activityRule ?? '',
                  textStyle: TextStyle(
                    fontSize: 39.sp,
                    color: const Color(0xFF4B4B4B),
                    fontWeight: FontWeight.w300,
                  ),
                )
              : _buildRecordsList(),
        )));
  }

  Widget _buildRecordsList() {
    return controller.models.isEmpty
        ? emptyWidget()
        : Container(
            height: 400,
            child: ListView.builder(
              itemCount: controller.models.length,
              itemBuilder: (context, index) {
                var item = controller.models[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: const Color(colorF4F4F4),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '${typeWithName(item.wheelType!.toInt())}转盘',
                            style: TextStyle(
                              fontSize: 48.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateTimeUtils.formatTimestamp(
                                item.creatTime!.toInt(),
                                temp: 'yyyy-MM-dd hh:ss:mm'),
                            style: TextStyle(
                              fontSize: 36.sp,
                              color: const Color(colorA0A0A0),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Image.asset(
                        Assets.theme1.images.activity.activityReviceCny.path,
                        width: 60.w,
                        height: 60.h,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        ((item.rewordAmount ?? 0) == 0
                            ? ''
                            : ((item.rewordAmount ?? 0) / 1000)
                                .truncateToFixed(2)
                                .replaceAll(RegExp(r'\.?0*$'), '')),
                        style: TextStyle(
                          color: context.theme.primaryColor,
                          fontSize: 42.sp,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
  }

  String typeWithName(int type) {
    String name = '';
    switch (type) {
      case 1:
        name = '白银';
        break;
      case 2:
        name = '黄金';
        break;
      case 3:
        name = '钻石';
        break;
      default:
    }
    return name;
  }

  String formatNumber(double? value) {
    if (value == null) return '0.00'; // 处理空值
    final formatter = NumberFormat('#,###.00', 'en_US'); // 使用千分位格式
    return formatter.format(value);
  }

  Widget _buildButton(int index, String text) {
    bool isSelected = controller.index.value == index; // 判断按钮是否选中
    return CommonRipple(
      onTap: () {
        setState(() {
          // 选中按钮时更新状态，取消其他按钮的选中
          controller.index.value = isSelected ? -1 : index;
        });
      },
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: isSelected
                  ? context.theme.primaryColor
                  : context.customTheme?.title2Color, // 选中时红色，未选中时黑色
            ),
          ),
          // 在文字下方显示横条
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 60,
              height: 3,
              color: context.theme.primaryColor,
            ),
        ],
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customTheme?.dialogBgColor,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 48.w,
                height: 48.h,
                child: Transform.scale(
                  scale: 0.8,
                  child: Obx(() => Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        value: isToday.value,
                        onChanged: (bool? value) {
                          isTodayDisplay(value);
                        },
                        activeColor: context.theme.primaryColor,
                        checkColor: Colors.white,
                        side: const BorderSide(color: Colors.grey),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )),
                ),
              ),
              SizedBox(width: 20.w),
              CommonRipple(
                onTap: () {},
                child: Text(
                  '今天不再提示',
                  style: TextStyle(
                      fontSize: 38.sp, color: context.customTheme?.title2Color),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              SizedBox(
                width: 48.w,
                height: 48.h,
                child: Transform.scale(
                  scale: 0.8,
                  child: Obx(() => Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        value: isNotDisplay.value,
                        onChanged: (bool? value) {
                          iseveryNotDisplay(value);
                        },
                        activeColor: context.theme.primaryColor,
                        checkColor: Colors.white,
                        side: const BorderSide(color: Colors.grey),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )),
                ),
              ),
              SizedBox(width: 20.w),
              CommonRipple(
                onTap: () {},
                child: Text(
                  '永不提示',
                  style: TextStyle(
                      fontSize: 38.sp, color: context.customTheme?.title2Color),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget emptyWidget() {
    return Container(
      width: 0.9.sw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50.h,
          ),
          Image.asset(
            Assets.theme1.images.user.noFundingDataBg.path,
            width: 480.w,
            height: 339.h,
          ),
          SizedBox(
            height: 76.h,
          ),
          Text(
            "暂无数据",
            style: TextStyle(fontSize: 36.sp, color: const Color(colorAAAFBB)),
          ),
          SizedBox(
            height: 50.h,
          ),
        ],
      ),
    );
  }
}
