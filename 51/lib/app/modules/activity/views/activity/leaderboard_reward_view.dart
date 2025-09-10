import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/leaderboard_reward_controller.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// 排行榜-活动详情
class LeaderboardRewardView extends GetView<LeaderboardRewardController> {
  const LeaderboardRewardView({super.key});

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
            padding: EdgeInsets.only(right: 30.w, top: 40.h),
            child: InkWell(
              onTap: () {
                AppManager.instance.tapVibrate();
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
              child: Text("在线客服",
                  style: TextStyle(color: context.customTheme?.pageBg)),
            ),
          ),
        ],
      ),
      body: Obx(() => _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: 200.h), // Add padding for the fixed button
                  child: Column(
                    children: [
                      if (controller.isShowAvatar.value == '1') ...[
                        Container(
                          padding: EdgeInsets.only(
                              top: 10.h, left: 30.w, right: 30.w),
                          child: InteractiveViewer(
                            child: Image.network(
                              controller.showAvatar.value,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      ],
                      if (controller.detailModel.value.t?.isShowDetailTime ==
                          '1') ...[_buildTime()],

                      Container(
                        margin:
                            EdgeInsets.only(top: 15.h, left: 30.w, right: 30.w),
                        // padding: EdgeInsets.all(50.w),
                        child: Obx(() => _buildLeaderboard(context)),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
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
                                    color: const Color(0xFF00CAE6),
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
                              controller.rule.value,
                              textStyle: TextStyle(
                                fontSize: 39.sp,
                                color: const Color(0xFF4B4B4B),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: 20.h), // Add some extra space at the bottom
                    ],
                  ),
                );
              },
            ),
          ),

          // Fixed button at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200.h,
            child: _buildClaimButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildTime() {
    return Container(
      margin: EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
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
                  color: const Color(0xFF00CAE6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.w),
                    topRight: Radius.circular(6.w),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Text(
                '活动时间',
                style: TextStyle(
                  fontSize: 51.sp,
                  color: const Color(0xFF2D2D2D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.w),
          Text(
            '${controller.detailModel.value.t?.startTime} ~ ${controller.detailModel.value.t?.endTime}',
            style: TextStyle(
              fontSize: 39.sp,
              color: const Color(0xFF4B4B4B),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClaimButton() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      color: const Color(theme01MainColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 改为居中
        children: [
          // 左侧内容
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Text("上期排名:  ",
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                Text(
                  controller.myOrderNoLastTime.value,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                )
              ]),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('奖励金额:  ',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                Text(
                    '¥${NumberFormat("#,##0.00").format(controller.myAwardAmountLastTime.value / 1000)}',
                    style: const TextStyle(color: Colors.white, fontSize: 12))
              ])
            ],
          ),
          // 右侧按钮
          Column(
            children: [
              Container(
                height: 100.h,
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    AppManager.instance.tapVibrate();
                    if (controller.myAwardAmountLastTime.value > 0) {
                      Get.toNamed(Routes.BOUNS_CENTER);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.85),
                    minimumSize: Size(120, 100.h),
                  ),
                  child: Text(
                    '去领取',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 36.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLeaderboard(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 40.w),
          decoration: BoxDecoration(
            color: context.customTheme?.inputBgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.w),
              topRight: Radius.circular(20.w)
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '您目前的排名：${controller.myOrderNo.value}',
                    style: TextStyle(
                      fontSize: 42.sp,
                      color: context.customTheme?.titleColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '  可获得奖金：${controller.myAwardAmount.value}',
                    style: TextStyle(
                      fontSize: 42.sp,
                      color: context.customTheme?.titleColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 42.sp,
                    color: const Color(0xFF1F1F1F),
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: controller.myOrderNo.value == '暂未上榜'
                          ? "距离上榜差: "
                          : "距离上一名还差：",
                    ),
                    TextSpan(
                      text: NumberFormat("#,##0.00").format(controller.myRankAmount.value / 1000),
                      style: const TextStyle(
                        color: Color(0xffFFBA3A), // Gold color
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.symmetric(vertical: 15.h),
          decoration: BoxDecoration(
            color: const Color(0xffF6F6F7), // 背景颜色
            border: Border.all(
              color: const Color(0xffC7CBD3), // 边框颜色
              width: 1.0, // 边框宽度
            ),
            borderRadius: BorderRadius.circular(5.0), // 圆角边框
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 40.w),
              Expanded(
                flex: 2,
                child: Text(
                  '排名',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF00CFE9),
                    fontSize: 38.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  controller.rankway.value == 1 || controller.rankway.value == 2
                      ? '玩家/充值金额'
                      : '玩家/打码金额',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF00CFE9),
                    fontSize: 38.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '奖金金额',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF00CFE9),
                    fontSize: 38.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 60.w),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.w),
          child: SizedBox(
            height: 800.h,
            child: ListView.builder(
              itemCount: _calculateTotalItemCount(controller.rankingData),
              itemBuilder: (context, index) {
                final groups = _processData(controller.rankingData)
                  ..sort((a, b) {
                    final aStart = _extractStartValue(a.awardName);
                    final bStart = _extractStartValue(b.awardName);
                    return aStart.compareTo(bStart);
                  });

                // Find which group and item we're building
                int currentIndex = 0;
                GroupData? currentGroup;
                int? groupItemIndex;
                int displayedItemIndex = 0; // Track displayed items count

                for (final group in groups) {
                  const itemCount = 1;

                  if (index >= currentIndex && index < currentIndex + itemCount) {
                    currentGroup = group;
                    groupItemIndex = index - currentIndex;
                    break;
                  }
                  currentIndex += itemCount;
                  displayedItemIndex += itemCount;
                }

                if (currentGroup == null || groupItemIndex == null) {
                  return const SizedBox.shrink();
                }

                // Get the actual item index to display
                final itemIndex = currentGroup.showLimit
                    ? 0 // Always show first item if showLimit is true
                    : groupItemIndex;

                if (itemIndex >= currentGroup.items.length) {
                  return const SizedBox.shrink();
                }

                final item = currentGroup.items[itemIndex];

                // Determine what to display
                final showAwardName = _shouldShow(
                    currentGroup.awardNameSame, currentGroup, groupItemIndex);
                final showAwardAmount = _shouldShow(
                    currentGroup.awardAmountSame, currentGroup, groupItemIndex);

                final formattedAmount = showAwardAmount
                    ? _formatAwardAmount(item.awardAmount, currentGroup)
                    : '';

                var rankName = currentGroup.awardName;
                if (currentGroup.awardName.contains('-')) {
                  final parts = currentGroup.awardName.split('-');
                  final startValue = int.tryParse(parts[0]) ?? 0;
                  final endValue = int.tryParse(parts[1]) ?? 0;
                  if (startValue == endValue) {
                    rankName = '${startValue}';
                  }
                }

                return _buildListItem(
                  index: displayedItemIndex + groupItemIndex, // Pass the displayed index
                  awardName: showAwardName ? rankName : '',
                  awardAmount: formattedAmount,
                  account: item.acctId == LoginManager.instance.loginInfo?.acctId
                    ? "我自己 / ${NumberFormat("#,##0.00").format((item.chargeAmount ?? 0) / 1000)}"
                    : "${item.account} / ${NumberFormat("#,##0.00").format((item.chargeAmount ?? 0) / 1000)}",
                  context: context,
                  currentGroup: currentGroup,
                );
              },
            ),
          ),
        )
      ],
    ));
  }

  int _extractStartValue(String awardName) {
    if (awardName.contains('-')) {
      final parts = awardName.split('-');
      return int.tryParse(parts[0]) ?? 0;
    } else {
      return int.tryParse(awardName) ?? 0;
    }
  }

  // 辅助方法：处理 awardAmount 的格式化逻辑
  String _formatAwardAmount(String? awardAmount, currentGroup) {
    if (awardAmount == null || awardAmount.isEmpty) return '';

    // 检查是否是区间格式（如 "5000-8000"）
    if (awardAmount.contains('-')) {
      final parts = awardAmount.split('-');
      if (parts.length == 2) {
        final startValue = double.tryParse(parts[0]) ?? 0;
        final endValue = double.tryParse(parts[1]) ?? 0;

        final formattedStart =
            NumberFormat("#,##0.00").format(startValue / 1000);
        final formattedEnd = NumberFormat("#,##0.00").format(endValue / 1000);

        // 如果 currentGroup 要求显示 "/人"，则拼接
        if (currentGroup.awardAmountSame && currentGroup.showLimit) {
          return '$formattedStart-$formattedEnd/人';
        } else {
          return '$formattedStart-$formattedEnd';
        }
      }
    }

    // 默认情况（单个数值）
    final awardAmountValue = double.tryParse(awardAmount) ?? 0;
    if (currentGroup.awardAmountSame && currentGroup.showLimit) {
      return '${NumberFormat("#,##0.00").format(awardAmountValue / 1000)}/人';
    } else {
      return NumberFormat("#,##0.00").format(awardAmountValue / 1000);
    }
  }

  List<GroupData> _processData(List<dynamic> rankingData) {
    final groupedData = <String, List<dynamic>>{};

    // Group data by awardName
    for (var item in rankingData) {
      final awardName = item.awardName ?? '';
      groupedData.putIfAbsent(awardName, () => []);
      groupedData[awardName]!.add(item);
    }

    // Convert to GroupData objects with same-value checks
    return groupedData.entries.map((entry) {
      final firstItem = entry.value.firstOrNull;
      final firstAwardAmount = firstItem?.awardAmount;
      final allSameAwardAmount = firstAwardAmount != null
          ? entry.value.every((item) => item.awardAmount == firstAwardAmount)
          : false;

      return GroupData(
        awardName: entry.key,
        items: entry.value,
        awardNameSame: true, // Since we grouped by awardName
        awardAmountSame: allSameAwardAmount,
      );
    }).toList()
      ..sort((a, b) {
        try {
          final aParts =
              a.awardName.split('-').map((e) => int.tryParse(e) ?? 0).toList();
          final bParts =
              b.awardName.split('-').map((e) => int.tryParse(e) ?? 0).toList();
          if (aParts.length == 2 && bParts.length == 2) {
            return aParts[0].compareTo(bParts[0]);
          }
          return a.awardName.compareTo(b.awardName);
        } catch (e) {
          return a.awardName.compareTo(b.awardName);
        }
      });
  }

  bool _shouldShow(bool allSame, GroupData group, int groupItemIndex) {
    if (!allSame) return true;
    return groupItemIndex == 0;
  }

  Widget _buildMoreButton(BuildContext context, GroupData group) {
    return GestureDetector(
      onTap: () => {
        Get.dialog(
          Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
              child: Stack(
                children: [
                  Column(
                    children: [
                      const Spacer(),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: MediaQuery.of(context).size.height / 2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                          child: _contentBuild(context, group),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: context.theme.cardColor.withOpacity(.9),
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.close_sharp,
                            color: Colors.grey,
                            size: 15,
                          ),
                        ).onTap(() {
                          AppManager.instance.tapVibrate();
                          Get.back();
                        }),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              )),
          barrierDismissible: false,
        )
      },
      child: SizedBox(
        height: 50.h,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min, // 让Row宽度适应内容
            children: [
              Text(
                '更多',
                style: TextStyle(
                  color: const Color(0xff10C8E3),
                  fontSize: 32.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(width: 8.w), // 文字和图标之间的间距
              Image.asset(
                Assets.theme1.images.activity.activityRankMore.path,
                width: 25.w,
                height: 26.h,
                color: const Color(theme01MainColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem({
    required int index,
    required String awardName,
    required String awardAmount,
    required String account,
    required BuildContext context,
    required GroupData currentGroup
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      constraints: BoxConstraints(
        minHeight: 100.h,
      ),
      color: index % 2 == 0 ? const Color(0xFFFCFCFC) : const Color(0xFFF6F6F7),
      child: Row(
        children: [
          SizedBox(width: 40.w),
          if (index == 0) ... [
            Expanded(
              flex: 2,
              child: Image.asset(
                Assets.theme1.images.activity.activityRank1.path,
                width: 72.w,
                height: 44.h,
              ),
            ),
          ] else if (index == 1) ... [
            Expanded(
              flex: 2,
              child: Image.asset(
                Assets.theme1.images.activity.activityRank2.path,
                width: 72.w,
                height: 44.h,
              ),
            ),
          ] else if (index == 2) ... [
            Expanded(
              flex: 2,
              child: Image.asset(
                Assets.theme1.images.activity.activityRank3.path,
                width: 72.w,
                height: 44.h,
              ),
            ),
          ] else ... [
            Expanded(
              flex: 2,
              child: Text(
                awardName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 34.sp),
              ),
            ),
          ],
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  account.contains('虚位以待') ? '--' : account,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 34.sp),
                ),
                if (awardName != '' && awardName.contains('-') && !account.contains('虚位以待')) ... [
                  _buildMoreButton(context, currentGroup)
                ]
              ],
            )
          ),
          Expanded(
            flex: 2,
            child: Text(
              awardName.contains('-') && !awardAmount.contains('人') ? '${awardAmount}/人' : awardAmount,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 34.sp, color: const Color(0xffFFBA3A)),
            ),
          ),
          SizedBox(width: 60.w),
        ],
      ),
    );
  }

  int _calculateTotalItemCount(List<dynamic>? rankingData) {
    if (rankingData == null || rankingData.isEmpty) return 0;
    return _processData(rankingData).fold(0, (sum, group) {
      return sum + group.items.length;
    });
  }

  Widget _contentBuild(BuildContext context, GroupData group) {
    List<String> titleList = ["名次", "会员账号", "打码金额", "奖励金额"];
    if (controller.rankway.value == 1 || controller.rankway.value == 2) {
      titleList[2] = '充值金额';
    }
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              child: Column(
                children: [
                  // Header
                  Center(child: Text("详情", style: TextStyle(fontSize: 46.sp))),
                  SizedBox(height: 20.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
                    decoration: BoxDecoration(
                      color: const Color(colorF6F6F7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.w),
                        topRight: Radius.circular(15.w),
                      ),
                    ),
                    child: _rankItemHeaderRow(titleList),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2 -
                        280.h, // Set the fixed height of the ListView (e.g., 300h for responsive height)
                    child: ListView.builder(
                      shrinkWrap:
                          true, // Ensures that the ListView height is based on the content
                      itemCount: group.items.length, // Safely handle null data
                      itemBuilder: (context, idx) {
                        final row = group.items[idx];
                        final parts = row.awardName.toString().split('-');
                        GroupData? currentGroup = GroupData(
                            awardName: '',
                            items: [],
                            awardAmountSame: false,
                            awardNameSame: false);
                        final formattedAmount =
                            _formatAwardAmount(row.awardAmount, currentGroup);
                        final listRow = [
                          '第${(int.parse(parts[0]) + idx).toString()}名',
                          LoginManager.instance.isLogin.value == true &&
                          row.acctId == LoginManager.instance.loginInfo?.acctId &&
                          row.acctId != null
                            ? "我自己"
                            : row.account.toString() ?? '--',
                          NumberFormat("#,##0.00").format(row.chargeAmount / 1000) == "0.00"
                            ? '--'
                            : NumberFormat("#,##0.00").format(row.chargeAmount / 1000),
                          formattedAmount,
                        ];
                        return _rankItemRow(idx, listRow, '');
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget _rankItemHeaderRow(List<String> values) {
    TextStyle style = TextStyle(
        color: const Color(color6B6B6B),
        fontSize: 28.sp,
        fontWeight: FontWeight.bold);

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

    TextStyle lastColStyle = TextStyle(
      color: const Color(0xffFFBA3A),
      fontSize: 28.sp,
    );
    // Map each value to a column widget, with specific styling for the last column
    List<Widget> columns = values.asMap().entries.map((entry) {
      return Expanded(
        flex: 1,
        child: _rankItemCol(entry.value, 80.w, values.last == entry.value ? lastColStyle : defaultStyle, false),
      );
    }).toList();
    return Container(
      color: index % 2 == 0 ? Colors.white : const Color(colorF6F6F7),
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
        child: Text(val,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: style));
  }

  // Widget _buildClaimButton() {
  //   bool canClaim = controller.myRankAmount.value > 0;
  //   if (canClaim) {
  //     return Container(
  //       margin: EdgeInsets.only(
  //         left: 60.w,
  //         right: 60.w,
  //         bottom: 60.w,
  //       ),
  //       width: double.infinity,
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(60.r),
  //         gradient: const LinearGradient(
  //           colors: [Color(0xFF10C8E3), Color(0xFF00F5FF)],
  //           begin: Alignment.centerLeft,
  //           end: Alignment.centerRight,
  //         ),
  //         boxShadow: [
  //           BoxShadow(
  //             color: const Color(0x8000DEFF),
  //             offset: Offset(0, 6.w),
  //             blurRadius: 10.w,
  //           ),
  //         ],
  //       ),
  //       height: 120.h,
  //       child: ElevatedButton(
  //         onPressed: () {
  //           AppManager.instance.tapVibrate();
  //           // Get.dialog(
  //           //   const TipsDialog(tips: '领取成功', desc: '今日获得100积分'),
  //           //   barrierDismissible: false,
  //           // );
  //           if (!controller.loading.value) {
  //             controller.reqRankReward();
  //           }
  //         },
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.transparent,
  //           shadowColor: Colors.transparent,
  //         ),
  //         child: Container(
  //           alignment: Alignment.center,
  //           width: double.infinity,
  //           height: double.infinity,
  //           child: controller.loading.value
  //               ? SizedBox(
  //                   width: 48.w,
  //                   height: 48.h,
  //                   child: CircularProgressIndicator(
  //                     strokeWidth: 4.w,
  //                     valueColor: const AlwaysStoppedAnimation<Color>(
  //                         Color(colorFFFFFF)), // 圆圈颜色
  //                   ),
  //                 )
  //               : Text(
  //                   '领取',
  //                   style: TextStyle(
  //                     fontSize: 48.sp,
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //         ),
  //       ),
  //     );
  //   } else {
  //     return Container(
  //       margin: EdgeInsets.only(
  //         left: 60.w,
  //         right: 60.w,
  //         bottom: 60.w,
  //       ),
  //       width: double.infinity,
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //         color: const Color(0xFFBABABA),
  //         borderRadius: BorderRadius.circular(60.r),
  //       ),
  //       height: 120.h,
  //       child: Text(
  //         '领取',
  //         style: TextStyle(
  //           fontSize: 48.sp,
  //           color: Colors.white,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //     );
  //   }
  // }
}

class GroupData {
  final String awardName;
  final List<dynamic> items;
  final bool awardNameSame;
  final bool awardAmountSame;
  final bool showLimit;

  GroupData({
    required this.awardName,
    required this.items,
    required this.awardNameSame,
    required this.awardAmountSame,
  }) : showLimit = items.length > 10;
}
