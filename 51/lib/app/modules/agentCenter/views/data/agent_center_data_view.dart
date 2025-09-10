import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/Finance.const.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import '../../controllers/agent_center_data_controller.dart';
import '../../widget/date_range_widget.dart';
import '../../widget/button_group_widget.dart';

// 推广数据
class AgentCenterDataView extends GetView<AgentCenterDataController> {
  const AgentCenterDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: null,
      body: Obx(() => _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.initData();
      },
      child: SingleChildScrollView(
        child: _buildHeadWidget(context),
      ),
    );
  }

  Widget _buildHeadWidget(BuildContext context) {
    var agentData = controller.agentData.value;
    return Container(
      constraints: BoxConstraints(minHeight: 1400.h),
      decoration: ThemeService.to.currentTheme.value?.model == 'blackGold'
          ? BoxDecoration(
              color: context.customTheme?.pageBg,
            )
          : BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    Assets.theme1.images.agentCenter.promoteShareHeadBg.path),
                fit: BoxFit.cover, // 使用 BoxFit.cover
                alignment: Alignment.topCenter, // 确保顶部对齐
              ),
            ),
      child: Column(
        children: [
          _buildDateSelectWidget(context),
          _buildSelfCommissionWidget(context),
          _buildTeamInfoWidget(context),
          SizedBox(height: 40.h),
          Container(
            height: 700.h,
            margin: EdgeInsets.symmetric(horizontal: 40.w),
            child: GridView.builder(
              itemCount: 4,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 36.h,
                mainAxisSpacing: 36.w,
                childAspectRatio: 2.2,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildItemWidget(
                    context,
                    text: '新增直属会员',
                    amount: parseNumber(agentData.xz_cust_count ?? 0),
                  );
                }

                if (index == 1) {
                  return _buildItemWidget(
                    context,
                    text: '首充人数',
                    amount: parseNumber(agentData.charge_first_amount_rs ?? 0),
                  );
                }

                if (index == 2) {
                  return _buildItemWidget(
                    context,
                    text: '充值人数',
                    amount: parseNumber(agentData.charge_rs ?? 0),
                  );
                }
                return _buildItemWidget(
                  context,
                  text: '充值金额',
                  amount:
                      '¥ ${((agentData.charge_sum_cust_amount ?? 0) / 1000).truncateToFixed(2)}',
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDateSelectWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 40.w, right: 40.w, top: 60.h, bottom: 60.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDateButton(context, DateTypeEnum.today),
          _buildDateButton(context, DateTypeEnum.yesterday),
          _buildDateButton(context, DateTypeEnum.weekly),
          _buildDateButton(context, DateTypeEnum.monthly),
          _buildDateButton(context, DateTypeEnum.custom),
        ],
      ),
    );
  }

  Widget _buildDateButton(BuildContext context, DateTypeEnum type) {
    String title = '';

    switch (type) {
      case DateTypeEnum.today:
        title = '今日';
        break;
      case DateTypeEnum.yesterday:
        title = '昨日';
        break;
      case DateTypeEnum.weekly:
        title = '近7日';
        break;
      case DateTypeEnum.monthly:
        title = '本月';
        break;
      case DateTypeEnum.custom:
        title = '自定义';
        break;
    }

    bool isSelect = type == controller.currentDateType.value;

    return InkWell(
      onTap: () {
        AppManager.instance.tapVibrate();
        if (!isSelect) {
          controller.setCurrentDateType(type);
        }

        // 如果是自定义日期弹窗
        if (type == DateTypeEnum.custom) {
          _handleCustomTime();
        }
      },
      child: Container(
        height: 80.h,
        constraints: BoxConstraints(minWidth: 180.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: isSelect
              ? context.theme.primaryColor
              : context.customTheme?.dialogBgColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 39.sp,
              color: const Color(colorFFFFFF),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelfCommissionWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 30.w,
        right: 30.w,
        top: 80.h,
        bottom: 80.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  '¥ ${((controller.agentData.value.estimate_amount ?? 0) / 1000).truncateToFixed(2)}',
                  style: TextStyle(
                    fontSize: 54.sp,
                    color: context.theme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  '预估佣金',
                  style: TextStyle(
                    fontSize: 39.sp,
                    color: context.customTheme?.titleColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1.w,
            height: 120.h,
            color: const Color(colorA1D5DC),
            margin: EdgeInsets.symmetric(horizontal: 30.w),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '¥ ${((controller.agentData.value.plan_amount ?? 0) / 1000).truncateToFixed(2)}',
                  style: TextStyle(
                    fontSize: 54.sp,
                    color: context.theme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  '有效业绩',
                  style: TextStyle(
                    fontSize: 39.sp,
                    color: context.customTheme?.titleColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextWidget(BuildContext context, String text, {bool? isTitle}) {
    if (isTitle == true) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 39.sp,
          color: context.customTheme?.title2Color,
        ),
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: 48.sp,
        color: context.customTheme?.titleColor,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // 团队信息
  Widget _buildTeamInfoWidget(BuildContext context) {
    var agentData = controller.agentData.value;
    return Container(
      height: 250.h,
      margin: EdgeInsets.symmetric(horizontal: 40.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        color: context.customTheme?.pageTwoBg,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(width: 100.w),
                    _buildTextWidget(context, '团队人数：', isTitle: true),
                    _buildTextWidget(
                        context, parseNumber(agentData.team_cust_count ?? 0)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(width: 100.w),
                    _buildTextWidget(context, '直属下级：', isTitle: true),
                    _buildTextWidget(
                        context, parseNumber(agentData.sub_cust_count ?? 0)),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 30.h),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(width: 100.w),
                    _buildTextWidget(context, '其他人数：', isTitle: true),
                    _buildTextWidget(
                        context,
                        parseNumber((agentData.team_cust_count ?? 0) -
                            (agentData.sub_cust_count ?? 0))),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(width: 100.w),
                    _buildTextWidget(context, '有效活跃：', isTitle: true),
                    _buildTextWidget(
                        context, parseNumber(agentData.eff_active_count ?? 0)),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // 构建team Item
  Widget _buildItemWidget(
    BuildContext context, {
    required String text,
    required String amount,
  }) {
    return Container(
      width: 518.w,
      height: 250.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        color: context.customTheme?.pageTwoBg,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTextWidget(context, amount, isTitle: false),
          SizedBox(height: 10.h),
          _buildTextWidget(context, text, isTitle: true),
        ],
      ),
    );
  }

  /// 打开自定义日期弹窗
  void _handleCustomTime() {
    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            // 可以在这里添加背景
            InkWell(
              onTap: () {
                AppManager.instance.tapVibrate();
                Get.back();
              },
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  // 根据动画值调整背景透明度
                  double opacity = animation.value; // 0.0 到 1.0

                  return Container(
                    color: [0, 1].contains(opacity)
                        ? Colors.black.withOpacity(0.3 * opacity)
                        : Colors.transparent, // 根据动画值调整透明度
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.topCenter, // 确保对话框位于顶部中央
              child: Container(
                width: double.infinity,
                height: 700.h, // 自定义高度
                color: context.customTheme?.dialogBgColor, // 背景颜色
                padding: EdgeInsets.only(
                  left: 60.w,
                  right: 60.w,
                  top: 150.h,
                  bottom: 100.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('请选择时间：',
                        style: TextStyle(
                            fontSize: 42.sp,
                            color: context.customTheme?.titleColor)),
                    SizedBox(height: 40.h),
                    Obx(
                      () => DateRangeWidget(
                        startTime: controller.startTime.value,
                        endTime: controller.endTime.value,
                        initialDateTime: controller.changeTime.value,
                        onTapStartTime: () async {
                          AppManager.instance.tapVibrate();
                          controller.setIsCheckedStartTime(true);
                          await controller
                              .onTimeChange(controller.startTime.value);
                        },
                        onTapEndTime: () async {
                          AppManager.instance.tapVibrate();
                          controller.setIsCheckedStartTime(false);
                          await controller
                              .onTimeChange(controller.endTime.value);
                        },
                        onConfrimTime: () {
                          controller.onConfrimTime();
                        },
                        onTimeChange: (date) {
                          controller.onTimeChange(date);
                        },
                      ),
                    ),
                    SizedBox(height: 100.h),
                    ButtonGroupWidget(
                      onConfrim: () {
                        controller.handleConfirmTime();
                      },
                      onReset: () {
                        AppManager.instance.tapVibrate();
                        controller.handleResetTime();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, -1.0); // 从顶部滑入
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
