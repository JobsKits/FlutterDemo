import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_detail_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/relief_fund_controller.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/CommonRipple.dart';

class ReliefFundView extends GetView<ReliefFundController> {
  const ReliefFundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        leading: BackButton(
          color: context.customTheme?.appbarText,
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: context.customTheme?.navbarBg,
        title: Obx(
          () => Text(
            controller.activityName.value,
            style: TextStyle(
              fontSize: 57.sp,
              color: context.customTheme?.appbarText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 30.w),
            child: CommonRipple(
              onTap: () {
                if (TenantManager.instance.isCanOpenCustomerService) {
                  Get.toNamed(Routes.CUSTOMER_SERVICE);
                } else {
                  String? onlineAddr =
                      TenantManager.instance.tenantBean?.tenant?.onlineAddr;
                  if (onlineAddr != null) {
                    String? type = TenantManager.instance.tenantBean?.sysOptions
                        ?.customerServiceSkipType;
                    if (type == '1') {
                      launchUrl(Uri.parse(onlineAddr),
                          mode: LaunchMode.externalApplication);
                    } else {
                      Get.toNamed(Routes.WEB_VIEW_INAPP, arguments: {
                        "url": onlineAddr, //请求地址
                        "title": "在线客服",
                      });
                    }
                  }
                }
              },
              child: const Text("在线客服"),
            ),
          ),
        ],
      ),
      body: Obx(() => _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: context.customTheme?.pageBg,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (controller.isShowAvatar.value == '1') ...[
                    Container(
                      padding: EdgeInsets.only(top: 10.h, left: 30.w, right: 30.w),
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 5.0,
                        child: Image.network(
                          controller.showAvatar.value,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  ],
                  if (controller.isShowDetailTime.value == '1') ...[
                    _buildPeriod(context),
                  ],
                  _buildDetails(context),
                  _buildRules(context),
                ],
              ),
            ),
          ),
        ),
        _buildBottom(context),
      ],
    );
  }

  Widget _buildPeriod(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
      padding: EdgeInsets.all(50.w),
      decoration: BoxDecoration(
        color: context.customTheme?.pageTwoBg,
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
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(6.w),
                    bottom: Radius.circular(6.w),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Text(
                '活动时间',
                style: TextStyle(
                  fontSize: 51.sp,
                  color: context.customTheme?.titleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.w),
          if (controller.startTime.value.isNotEmpty &&
              controller.endTime.value.isNotEmpty)
            Text(
              '活动时间：${DateTimeUtils.formatDateTime(
                controller.startTime.value,
                temp: 'yyyy/MM/dd HH:mm',
              )} 至 ${DateTimeUtils.formatDateTime(
                controller.endTime.value,
                temp: 'yyyy/MM/dd HH:mm',
              )}',
              style: TextStyle(
                fontSize: 39.sp,
                color: context.customTheme?.title2Color,
                fontWeight: FontWeight.w300,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
      padding: EdgeInsets.all(50.w),
      decoration: BoxDecoration(
        color: context.customTheme?.pageTwoBg,
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
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(6.w),
                    bottom: Radius.circular(6.w),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Text(
                '活动详情',
                style: TextStyle(
                  fontSize: 51.sp,
                  color: context.customTheme?.titleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.w),
          HtmlWidget(
            controller.content.value,
            textStyle: TextStyle(
              fontSize: 39.sp,
              color: context.customTheme?.title2Color,
              fontWeight: FontWeight.w300,
            ),
          ),
          if (controller.allLossRewards.isNotEmpty ||
              controller.type == ActivityTypsEnum.recharge)
            _buildTable(context),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    List<String> titleList;
    if (controller.rewardType.value == '1') {
      titleList = ['亏损金额', '奖励金额（元）'];
    } else {
      titleList = ['亏损金额', '奖金比例（%）'];
    }
    List<String> titleList2 = ['充值金额', '赠送金额'];
    double height = (controller.allLossRewards.length + 1) * 35;
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.w),
        border: Border.all(color: Colors.grey, width: 1), // 可选的边框
      ),
      child: Column(
        children: [
          // 表头
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: context.theme.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.w),
                topRight: Radius.circular(15.w),
              ),
            ),
            child: _rankItemHeaderRow(
                controller.type == ActivityTypsEnum.recharge
                    ? titleList2
                    : titleList),
          ),
          // 列表
          Expanded(
            child: ListView.builder(
              shrinkWrap: true, // 高度自适应
              physics: const NeverScrollableScrollPhysics(), // 禁用单独滚动
              itemCount: controller.allLossRewards.length,
              itemBuilder: (context, idx) {
                final row = controller.allLossRewards[idx];
                List<String> listRow = ['', ''];

                try {
                  if (controller.type == ActivityTypsEnum.recharge) {
                    // 安全转换 rechargeAmount
                    final rechargeAmount = _safeParseDouble(row['rechargeAmount']) / 1000.0;
                    final rewardAmount = _safeParseDouble(row['rewardAmount']);

                    listRow = [
                      '≥${rechargeAmount.truncateToFixed(0)}',
                      controller.rewardType.value == '2'
                          ? formatRewardPercentage(rewardAmount)
                          : (rewardAmount / 1000.0).truncateToFixed(2),
                    ];
                  } else {
                    final loss = _safeParseDouble(row['loss'] ?? 0);
                    final reward = _safeParseDouble(row['reward'] ?? 0);

                    if (loss > 0 && reward > 0) {
                      if (controller.rewardType.value == '1') {
                        listRow = [
                          '≥${_formatDouble((loss / 1000.0))}',
                          ((reward / 1000).truncateToFixed(2))
                        ];
                      } else if (controller.rewardType.value == '2') {
                        listRow = [
                          '≥${_formatDouble((loss / 1000.0))}',
                          '${_formatDouble(reward)}%',
                        ];
                      }
                    }
                  }
                } catch (e) {
                  listRow = ['-', '-'];
                }

                return _rankItemRow(idx, listRow, '');
              },
            ),
          ),
        ],
      ),
    );
  }

  String formatRewardPercentage(double rewardAmount) {
    final formatted = rewardAmount * 100 % 1 == 0
        ? NumberFormat("#,##0").format(rewardAmount * 100)
        : NumberFormat("#,##0.0").format(rewardAmount * 100);
    return '$formatted%';
  }

  // 辅助方法
  double _safeParseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) {
      try {
        return double.parse(value);
      } catch (_) {
        return 0.0;
      }
    }
    return 0.0;
  }

  String _formatDouble(double value) {
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
  }

  Widget _rankItemHeaderRow(List<String> values) {
    TextStyle style = TextStyle(
        color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold);

    // Create a list of widget columns based on the values
    List<Widget> columns = values.asMap().entries.map((entry) {
      String value = entry.value;

      // For the first and last item, use fixed width
      return Expanded(
        flex: 1,
        child: _rankItemCol(value, 100.w, style, true),
      );
    }).toList();

    return Row(
      children: columns,
    );
  }

  Widget _rankItemRow(int index, List<String> values, String? rollingType) {
    TextStyle defaultStyle = TextStyle(
      color: const Color.fromRGBO(102, 102, 102, 1),
      fontSize: 28.sp,
    );
    // Map each value to a column widget, with specific styling for the last column
    List<Widget> columns = values.asMap().entries.map((entry) {
      return Expanded(
        flex: 1,
        child: _rankItemCol(entry.value, 80.w, defaultStyle, false),
      );
    }).toList();
    // print({'object =======$index'});
    return Container(
      color: Colors.white,
      child: Row(
        children: columns,
      ),
    );
  }

  Widget _rankItemCol(
      String val, double width, TextStyle style, bool isheader) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        height: 35,
        alignment: Alignment.center,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(
              color: isheader ? Colors.transparent : Colors.grey,
              width: isheader ? 0 : 0.5), // 添加边框
        ),
        child: Text(val, style: style));
  }

  Widget _buildRules(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
      padding: EdgeInsets.all(50.w),
      decoration: BoxDecoration(
        color: context.customTheme?.pageTwoBg,
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
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(6.w),
                    bottom: Radius.circular(6.w),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Text(
                '活动规则与条款',
                style: TextStyle(
                  fontSize: 51.sp,
                  color: context.customTheme?.titleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.w),
          HtmlWidget(
            controller.rule.value,
            textStyle: TextStyle(
              fontSize: 39.sp,
              color: context.customTheme?.title2Color,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return SafeArea(
      child: Container(
        color: context.customTheme?.pageTwoBg,
        padding: EdgeInsets.only(
          top: 30.h,
          left: 40.w,
          right: 40.w,
          bottom: 30.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: controller.type == ActivityTypsEnum.recharge
                            ? '充值金额：'
                            : "亏损金额:  ",
                        style: TextStyle(
                          fontSize: 36.sp,
                          color: context.customTheme?.title2Color,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextSpan(
                        text: '¥${controller.standardAmount.value / 1000}',
                        style: TextStyle(
                          fontSize: 42.sp,
                          color: context.customTheme?.titleColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: controller.type == ActivityTypsEnum.recharge
                            ? '        奖金：'
                            : "救援金:  ",
                        style: TextStyle(
                          fontSize: 36.sp,
                          color: context.customTheme?.title2Color,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextSpan(
                        text: '¥${controller.receiveAmount.value / 1000}',
                        style: TextStyle(
                          fontSize: 42.sp,
                          color: context.customTheme?.titleColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildReceiveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiveButton(BuildContext context) {
    if (controller.state.value == 1) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.theme.primaryColor,
              context.theme.primaryColor,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: context.theme.primaryColor.withOpacity(0.5),
              offset: Offset(0, 12.h),
              blurRadius: 21.h,
            ),
            BoxShadow(
              color: context.theme.primaryColor,
              offset: Offset(0, 7.h),
              blurRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(20.h),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: 120.w,
              vertical: 20.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.h),
            ),
          ),
          onPressed: () async {
            controller.getReliefRewards();
          },
          child: Text(
            '领取',
            style: TextStyle(
              fontSize: 54.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFBABABA),
          borderRadius: BorderRadius.circular(20.h),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: 120.w,
              vertical: 20.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.h),
            ),
          ),
          onPressed: null,
          child: Text(
            '领取',
            style: TextStyle(
              fontSize: 54.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }
}
