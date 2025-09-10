import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../../../utils/CommonRipple.dart';
import '../../controllers/controller_vip_page.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/vip_info_bean.dart';

import 'vip_current_info_widget.dart';
import 'vip_title_widget.dart';
import 'vip_level_widget.dart';

/// VIP页面
class VipView extends StatefulWidget {
  final bool isShowTitle;
  const VipView({super.key, this.isShowTitle = true});

  @override
  State<VipView> createState() => _VipViewState();
}

class _VipViewState extends State<VipView> {
  late ControllerVipPage controller = Get.put(ControllerVipPage());

  @override
  void dispose() {
    Get.delete<ControllerVipPage>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(colorF4F4F4),
      backgroundColor: const Color(colorFFFFFF),
      appBar: widget.isShowTitle
          ? AppBar(
              backgroundColor: const Color(colorFFFFFF),
              title: Text(
                'VIP',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 57.sp,
                ),
              ),
              centerTitle: true,
              leading: CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  Get.back();
                },
                child: SizedBox(
                  width: 54.w,
                  height: 54.h,
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.theme1.images.common.iconBack,
                      width: 34.w,
                      height: 54.h,
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.initData(needLoading: false);
        },
        child: SingleChildScrollView(
          child: Obx(
            () => _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyTopWidget() {
    return Container(
      width: double.infinity, // 容器的宽度
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.theme1.images.activity.vip.vipBg.path),
          fit: BoxFit.fitWidth, // 使用 BoxFit.cover
          alignment: const Alignment(0, -0.5), // 将图像对齐到顶部
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 60.h),
          VipCurrentInfoWidget(
            vipLevel: controller.vipInfoData.last,
            level: controller.currentVipLevel.value,
            rechargeDiff: controller.rechargeDiff.value,
            bettingDiff: controller.bettingDiff.value,
          ),
          SizedBox(height: 60.h),
          const VipTitleWidget(title: '等级奖励'),
          const VipLevelWidget(),
          SizedBox(height: 20.h),
          const VipTitleWidget(title: 'VIP等级对照表'),
          // SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildTableWidget() {
    return Container(
      constraints: BoxConstraints(minHeight: 225.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(colorFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.r),
          topRight: Radius.circular(50.r),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E8E8).withOpacity(0.5), // 颜色
            blurRadius: 6, // 阴影的模糊半径
            spreadRadius: 1, // 阴影的扩散半径
            offset: Offset(0, -2.h), // x, y 偏移
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTabBarWidget(),
          _buildTableHeader(),
        ],
      ),
    );
  }

  Widget _buildTabBarWidget() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.h),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
        alignment: Alignment.centerLeft,
        child: Obx(
          () {
            // final isScrollable = controller.tabData.length > 3;
            int curIndex = controller.tabCurrentIndex.value;
            if (controller.tabData.isNotEmpty) {
              return TabBar(
                // isScrollable: isScrollable,
                isScrollable: true,
                controller: controller.tabController,
                // tabAlignment: isScrollable ? TabAlignment.start : null,
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero, // 去除整体的边距
                onTap: (val) {
                  AppManager.instance.tapVibrate();
                  controller.jumpToPage(val);
                },
                tabs: controller.tabData.map((element) {
                  final itemData = controller.tabData[curIndex];
                  bool isSelected =
                      controller.tabData.indexOf(element) == curIndex;
                  return Container(
                    height: 72.h,
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: itemData.title == element.title
                          ? context.theme.primaryColor
                          : const Color(colorF4F4F4),
                    ),
                    child: Center(
                      child: Text(
                        element.title,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(colorFFFFFF) // 选中的颜色
                              : const Color(colorAFAFAF), // 未选中的颜色
                        ),
                      ),
                    ),
                  );
                }).toList(),
                dividerHeight: 0,
                indicatorWeight: 1,
                indicatorPadding: EdgeInsets.zero, // 去除指示器的边距
                unselectedLabelColor: const Color(colorAFAFAF),
                labelColor: const Color(colorFFFFFF),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.transparent,
                labelPadding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                labelStyle:
                    TextStyle(fontSize: 39.sp, overflow: TextOverflow.fade),
              );
            }

            return SizedBox(
              width: double.infinity,
              height: 72.h,
            );
          },
        ),
      ),
    );
  }

  /// 构建表头标题
  Widget _buildTableHeaderTitle(String text,
      {double? fontSize, bool? first = false}) {
    return Container(
      margin: EdgeInsets.only(left: first == true ? 20 : 0),
      child: Text(
        text,
        textAlign: first == true ? TextAlign.left : TextAlign.center,
        style: TextStyle(
          fontSize: fontSize ?? 36.sp,
          color: const Color(colorABB6B8),
          height: 1.05,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// 构建表头标题
  Widget _buildTableBodyTitle(String text,
      {double? fontSize,
      bool? isSelect = false,
      bool? display = false,
      String? value = ''}) {
    return isSelect == true && display == true
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                _buildPercentage(value: value),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize ?? 36.sp,
                    color: isSelect == true
                        ? const Color(color5DBBC9)
                        : const Color(color575A5B),
                    height: 1.05,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ])
        : Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize ?? 36.sp,
              color: isSelect == true
                  ? const Color(color5DBBC9)
                  : const Color(color575A5B),
              height: 1.05,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          );
  }

  /// 构建进度条
  Widget _buildPercentage({String? value = ''}) {
    return SizedBox(
      width: 300.w,
      height: 50.h,
      child: Stack(
        children: [
          Container(
            width: 300.w,
            height: 50.h,
            padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r), // 设置圆角
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.r), // 设置圆角
              child: LinearProgressIndicator(
                value: calculatePercentage(value ?? ''), // 进度值，0.5表示50%
                backgroundColor: const Color(colorCDCDCD), // 进度条的背景颜色
                valueColor: AlwaysStoppedAnimation<Color>(
                    context.theme.primaryColor), // 进度条的颜色
              ),
            ),
          ),
          Visibility(
            visible: true,
            child: Positioned.fill(
              child: Center(
                child: Text(
                  value ?? '', // 显示百分比
                  style: TextStyle(
                    fontSize: 30.sp, // 字体大小
                    color: const Color(colorFFFFFF), // 字体颜色
                    fontWeight: FontWeight.bold, // 加粗字体
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculatePercentage(String fraction) {
    if (!fraction.contains('/')) return 0.0;
    try {
      var parts = fraction.split('/');
      double numerator = double.parse(parts[0]);
      double denominator = double.parse(parts[1]);
      if (denominator == 0) return 0.0;
      double percentage = (numerator / denominator) * 100;
      return percentage / 100;
    } catch (e) {
      return 0.0;
    }
  }

  Widget _buildTableHeader() {
    bool up =
        controller.vipListData.any((vipItem) => vipItem.balanceLower! > 0);
    bool daySalary =
        controller.vipListData.any((vipItem) => vipItem.daySalary! > 0);
    bool weekSalary =
        controller.vipListData.any((vipItem) => vipItem.weekSalary! > 0);
    bool monthSalary =
        controller.vipListData.any((vipItem) => vipItem.monthSalary! > 0);
    bool valueLower =
        controller.vipListData.any((vipItem) => vipItem.valueLower! > 0);
    bool chargeLower = controller.vipListData
        .any((vipItem) => vipItem.relegationChargeLower! > 0);
    bool betLower = controller.vipListData
        .any((vipItem) => vipItem.relegationBetLower! > 0);
    List<Widget> tabList = [];

    if (controller.tabData[controller.tabCurrentIndex.value].title == '晋级奖金') {
      tabList = [
        Expanded(child: _buildTableHeaderTitle('等级')),
        if (up) ...[Expanded(child: _buildTableHeaderTitle('有效充值'))],
        if (valueLower) ...[Expanded(child: _buildTableHeaderTitle('有效投注'))],
        Expanded(child: _buildTableHeaderTitle('晋级奖金')),
      ];
    } else if (controller.tabData[controller.tabCurrentIndex.value].title ==
        '日俸禄') {
      tabList = [
        Expanded(child: _buildTableHeaderTitle('等级', first: true)),
        // Expanded(child: _buildTableHeaderTitle('有效充值')),
        if (daySalary &&
            controller.tabData[controller.tabCurrentIndex.value].title ==
                '日俸禄') ...[
          Expanded(child: _buildTableHeaderTitle('有效投注')),
        ],
        Expanded(child: _buildTableHeaderTitle('日俸禄奖金')),
      ];
    } else if (controller.tabData[controller.tabCurrentIndex.value].title ==
        '周俸禄') {
      tabList = [
        Expanded(child: _buildTableHeaderTitle('等级', first: true)),
        // Expanded(child: _buildTableHeaderTitle('有效充值')),
        if (weekSalary &&
            controller.tabData[controller.tabCurrentIndex.value].title ==
                '日俸禄') ...[
          Expanded(child: _buildTableHeaderTitle('有效投注')),
        ],
        Expanded(child: _buildTableHeaderTitle('周俸禄奖金')),
      ];
    } else if (controller.tabData[controller.tabCurrentIndex.value].title ==
        '月俸禄') {
      tabList = [
        Expanded(child: _buildTableHeaderTitle('等级', first: true)),
        // Expanded(child: _buildTableHeaderTitle('有效充值')),
        if (monthSalary &&
            controller.tabData[controller.tabCurrentIndex.value].title ==
                '日俸禄') ...[
          Expanded(child: _buildTableHeaderTitle('有效投注')),
        ],
        Expanded(child: _buildTableHeaderTitle('月俸禄奖金')),
      ];
    } else if (controller.tabData[controller.tabCurrentIndex.value].title ==
        '保级要求') {
      tabList = [
        Expanded(child: _buildTableHeaderTitle('等级', first: true)),
        if (chargeLower &&
            controller.tabData[controller.tabCurrentIndex.value].title ==
                '保级要求') ...[
          Expanded(child: _buildTableHeaderTitle('上月充值\n(未满足则降一级)')),
        ],
        if (betLower &&
            controller.tabData[controller.tabCurrentIndex.value].title ==
                '保级要求') ...[
          Expanded(child: _buildTableHeaderTitle('上月打码\n(未满足则降一级)')),
        ],
      ];
    } else if (controller.tabData[controller.tabCurrentIndex.value].title ==
        '生日红包') {
      tabList = [
        Expanded(child: _buildTableHeaderTitle('等级', first: true)),
        Expanded(child: _buildTableHeaderTitle('生日红包')),
      ];
    } else {
      tabList = [
        Expanded(child: _buildTableHeaderTitle('等级')),
        Expanded(child: _buildTableHeaderTitle('每日提现\n总额上限')),
        Expanded(child: _buildTableHeaderTitle('每日提现\n次数上限')),
        Expanded(child: _buildTableHeaderTitle('每日免手\n续费笔数')),
      ];
    }

    return Container(
      color: const Color(colorFFFFFF),
      padding: EdgeInsets.only(bottom: 40.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: tabList,
      ),
    );
  }

  Widget _buildTableBody() {
    if (controller.vipListData.isEmpty) {
      return const SizedBox();
    }
    int height = 120 * controller.vipListData.length + 100;

    bool up =
        controller.vipListData.any((vipItem) => vipItem.balanceLower! > 0);

    bool daySalary =
        controller.vipListData.any((vipItem) => vipItem.daySalary! > 0);
    bool weekSalary =
        controller.vipListData.any((vipItem) => vipItem.weekSalary! > 0);
    bool monthSalary =
        controller.vipListData.any((vipItem) => vipItem.monthSalary! > 0);
    bool valueLower =
        controller.vipListData.any((vipItem) => vipItem.valueLower! > 0);
    bool chargeLower = controller.vipListData
        .any((vipItem) => vipItem.relegationChargeLower! > 0);
    bool betLower = controller.vipListData
        .any((vipItem) => vipItem.relegationBetLower! > 0);

    return SizedBox(
      height: height.h,
      child: Column(
        children: List.generate(controller.vipListData.length, (index) {
          var itemData = controller.vipListData[index];
          return Container(
            height: 120.h,
            color: index % 2 == 0
                ? const Color(colorF6F9F9)
                : const Color(colorFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildVipLevelWidget(itemData.level!)),
                if (up &&
                    controller
                            .tabData[controller.tabCurrentIndex.value].title ==
                        '晋级奖金') ...[
                  Expanded(child: _buildSecondWidget(itemData)),
                ] else if (controller
                        .tabData[controller.tabCurrentIndex.value].title ==
                    'VIP特权') ...[
                  Expanded(child: _buildSecondWidget(itemData)),
                ],

                if (daySalary &&
                    controller
                            .tabData[controller.tabCurrentIndex.value].title ==
                        '日俸禄') ...[
                  Expanded(child: _buildThirdWidget(itemData)),
                ] else if (weekSalary &&
                    controller
                            .tabData[controller.tabCurrentIndex.value].title ==
                        '日俸禄') ...[
                  Expanded(child: _buildThirdWidget(itemData)),
                ] else if (monthSalary &&
                    controller
                            .tabData[controller.tabCurrentIndex.value].title ==
                        '月奉禄') ...[
                  Expanded(child: _buildThirdWidget(itemData)),
                ] else if (valueLower &&
                    controller
                            .tabData[controller.tabCurrentIndex.value].title ==
                        '晋级奖金') ...[
                  Expanded(child: _buildThirdWidget(itemData)),
                ] else if (controller
                        .tabData[controller.tabCurrentIndex.value].title ==
                    'VIP特权') ...[
                  Expanded(child: _buildThirdWidget(itemData)),
                ],
                // Expanded(child: _buildThirdWidget(itemData)),
                if (controller.tabData[controller.tabCurrentIndex.value].title =='保级要求') ...[
                  if (chargeLower && betLower) ... [
                    Expanded(child: _buildThirdWidget(itemData)),
                  ] else ... [
                    Expanded(child: _buildSecondWidget(itemData)),
                  ]
                ],

                if (controller
                        .tabData[controller.tabCurrentIndex.value].title ==
                    '生日红包') ...[
                  Expanded(child: _buildSecondWidget(itemData)),
                ] else ...[
                  Expanded(child: _buildFourdWidget(itemData)),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVipLevelWidget(int level) {
    String path = 'assets/theme1/images/activity/vip/vip${level}.png';
    bool isCurrent = level == controller.currentVipLevel.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 40.w),
        Image.asset(
          path,
          width: 78.w,
          height: 56.h,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            Assets.theme1.images.activity.vip.vip10.path,
            fit: BoxFit.cover, // 根据需要调整 fit 属性
            height: 56.h,
          ),
        ),
        SizedBox(width: 6.w),
        _buildTableBodyTitle('VIP${level}',
            isSelect: isCurrent, display: false),
        Visibility(
          visible: isCurrent,
          child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: SvgPicture.asset(
              Assets.theme1.images.activity.vip.iconCurrent,
              width: 35.w,
              height: 35.h,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSecondWidget(VipLevelItemBean itemData) {
    bool isCurrent = itemData.level == controller.currentVipLevel.value;

    String text = '';
    switch (controller.tabData[controller.tabCurrentIndex.value].title) {
      case '晋级奖金':
        text = parseNumber((itemData.balanceLower ?? 0) / 1000);
        break;
      case '日俸禄':
        text = '-';
        break;
      case '周俸禄':
        text = '-';
        break;
      case '月俸禄':
        text = '-';
        break;
      case 'VIP特权':
        text = parseNumber((itemData.withdrawUpperLimit ?? 0) / 1000);
        break;
      case '生日红包':
        text = parseNumber((itemData.birthdayRedPacket ?? 0) / 1000);
        break;
    }

    return _buildTableBodyTitle(
      // text == '0' ? '-' : text,
      text,
      isSelect: isCurrent,
    );
  }

  Widget _buildThirdWidget(VipLevelItemBean itemData) {
    bool isCurrent = itemData.level == controller.currentVipLevel.value;
    String text = '';
    switch (controller.tabData[controller.tabCurrentIndex.value].title) {
      case '晋级奖金':
        text = parseNumber((itemData.valueLower ?? 0) / 1000);
        break;
      case '日俸禄':
        text = parseNumber((itemData.daySalary ?? 0) / 1000);
        break;
      case '周俸禄':
        text = parseNumber((itemData.weekSalary ?? 0) / 1000);
        break;
      case '月奉禄':
        text = parseNumber((itemData.monthSalary ?? 0) / 1000);
        break;
      case '保级要求':
        text =
            ((itemData.relegationChargeLower ?? 0) / 1000).truncateToFixed(2);
        break;
      case 'VIP特权':
        text = parseNumber(itemData.dailyWithdrawalLimit ?? 0);
        break;
    }

    return _buildTableBodyTitle(
        // text == '0' ? '-' : text,
        controller.tabData[controller.tabCurrentIndex.value].title == '保级要求'
            ? text == '0.00'
                ? '-'
                : text
            : text,
        isSelect: isCurrent,
        display: controller.tabData[controller.tabCurrentIndex.value].title ==
                    '保级要求' &&
                text != '0.00'
            ? true
            : false,
        value:
            '${controller.totalRechrge.value.truncateToFixed(0)}/${parseNumber((itemData.relegationChargeLower ?? 0) / 1000)}');
  }

  Widget _buildFourdWidget(VipLevelItemBean itemData) {
    bool isCurrent = itemData.level == controller.currentVipLevel.value;

    String text = '';
    switch (controller.tabData[controller.tabCurrentIndex.value].title) {
      case '晋级奖金':
        text = parseNumber((itemData.levelReward ?? 0) / 1000);
        break;
      case '日俸禄':
        text = parseNumber((itemData.dayReward ?? 0) / 1000);
        break;
      case '周俸禄':
        text = parseNumber((itemData.weekReward ?? 0) / 1000);
        break;
      case '月俸禄':
        text = parseNumber((itemData.monthReward ?? 0) / 1000);
        break;
      case '保级要求':
        text = ((itemData.relegationBetLower ?? 0) / 1000).truncateToFixed(2);
        break;
      case 'VIP特权':
        text = parseNumber(itemData.withdrawFreeCnt ?? 0) == '0' ||
                parseNumber(itemData.withdrawFreeCnt ?? 0) == '9999'
            ? '-'
            : parseNumber(itemData.withdrawFreeCnt ?? 0);
        break;
    }

    return _buildTableBodyTitle(
        // text == '0' ? '-' : text,
        controller.tabData[controller.tabCurrentIndex.value].title == '保级要求'
            ? text == '0.00'
                ? '-'
                : text
            : text,
        isSelect: isCurrent,
        display: controller.tabData[controller.tabCurrentIndex.value].title ==
                    '保级要求' &&
                text != '0.00'
            ? true
            : false,
        value:
            '${controller.totalBet.value.truncateToFixed(0)}/${parseNumber((itemData.relegationBetLower ?? 0) / 1000)}');
  }

  Widget _buildRulerWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Color(colorF4F4F4),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VipTitleWidget(title: 'VIP活动规则'),
          SizedBox(height: 20.w),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r)),
            ),
            child: HtmlWidget(
              controller.ruler.value,
              textStyle: TextStyle(
                fontSize: 39.sp,
                color: const Color(0xFF4B4B4B),
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildBodyTopWidget(),
        _buildTableWidget(),
        _buildTableBody(),
        _buildRulerWidget(),
      ],
    );
  }
}
