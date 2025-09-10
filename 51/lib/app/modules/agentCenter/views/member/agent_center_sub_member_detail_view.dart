import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/Finance.const.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/widget/empty_widget.dart';
import 'package:flutter_tiyu_app/app/widget/JobsViews.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/clipboard_util.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import '../../../../../utils/CommonRipple.dart';
import '../../controllers/agent_center_sub_member_detail_controller.dart';
import '../../widget/date_range_widget.dart';
import '../../widget/button_group_widget.dart';
import '../../widget/cascader/ym_cascader.dart';

// 会员详情
class AgentCenterSubMemberDetailView
    extends GetView<AgentCenterSubMemberDetailController> {
  const AgentCenterSubMemberDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(colorF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '下级详情',
          style: TextStyle(fontSize: 57.sp, color: Colors.black),
        ),
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
      ),
      body: Obx(() => _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.initData();
      },
      child: SingleChildScrollView(
        controller: controller.mainScrollController,
        child: _buildHeadWidget(context),
      ),
    );
  }

  Widget _buildHeadWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 45.w, vertical: 40.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: const Color(colorFFFFFF),
      ),
      padding: EdgeInsets.only(bottom: 50.w),
      child: Column(
        children: [
          _buildHeaderProfitBar(),
          Visibility(
            visible: controller.showGroup.value,
            child: _buildMemberBaseWidget(context),
          ),
          SizedBox(height: 30.h),
          _buildHeaderBar(context),
          Visibility(
            visible: controller.showQuery.value,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 40.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle('选择游戏：'),
                  _buildGameSelectWidget(),
                  _buildTitle('请选择时间：'),
                  _buildTimeSelectWidget(),
                  SizedBox(height: 60.h),
                  ButtonGroupWidget(
                    loading: controller.isRequest.value,
                    onConfrim: () {
                      controller.handleConfirmQuery();
                    },
                    onReset: () {
                      AppManager.instance.tapVibrate();
                      controller.handleResetData();
                    },
                  ),
                  SizedBox(height: 40.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // 允许水平滚动
                    child: Obx(() => _buildTableWidget()),
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.dataList.isEmpty,
                      child: const Center(
                        child: EmptyWidget(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 42.sp,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildGameSelectWidget() {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        _showGamePicker();
      },
      child: Container(
        height: 124.h,
        margin: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(
          color: const Color(colorF6F6F6),
          borderRadius: BorderRadius.circular(30.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.gameName.value.isEmpty
                  ? '选择游戏'
                  : controller.gameName.value,
              style: TextStyle(
                fontSize: 36.sp,
                color: const Color(color434043),
              ),
            ),
            SvgPicture.asset(
              Assets.theme1.images.agentCenter.iconArrowDown,
              width: 24.w,
            )
          ],
        ),
      ),
    );
  }

  void _showGamePicker() {
    showModalBottomSheet(
      context: Get.context!,
      builder: (BuildContext builder) {
        return Obx(() {
          if (!controller.isInit.value) {
            return const SizedBox();
          }

          return YmCascader(
            data: controller.gameListData,
            dataMap: controller.gameListMap,
            currentIndex:
                controller.isNeedReset.value ? [0, 0] : controller.gameIndex,
            isFixed: true,
            onOkClick: (list) async {
              Get.back();
              // 延迟100ms，等数据更新
              await Future.delayed(const Duration(milliseconds: 100));
              controller.confirmGame(list);
            },
            onCancelClick: () {
              Get.back();
            },
            onChanged: (position, index, value) {
              //
            },
          );
        });
      },
    );
  }

  Widget _buildTimeSelectWidget() {
    return DateRangeWidget(
      startTime: controller.startTime.value,
      endTime: controller.endTime.value,
      initialDateTime: controller.changeTime.value,
      onTapStartTime: () async {
        AppManager.instance.tapVibrate();
        controller.setIsCheckedStartTime(true);
        await controller.onTimeChange(controller.startTime.value);
      },
      onTapEndTime: () async {
        AppManager.instance.tapVibrate();
        controller.setIsCheckedStartTime(false);
        await controller.onTimeChange(controller.endTime.value);
      },
      onConfrimTime: () {
        controller.onConfrimTime();
      },
      onTimeChange: (date) {
        controller.onTimeChange(date);
      },
    );
  }

  Widget _buildHeaderProfitBar() {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        DebounceThrottle.debounce(controller.changeShowGroup)();
      },
      child: Container(
        height: 150.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8541), Color(0xFFFFC09D)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          image: DecorationImage(
            image: AssetImage(Assets.theme1.images.agentCenter.iconMask.path),
            fit: BoxFit.cover, // 使用 BoxFit.cover
            alignment: Alignment.topCenter, // 确保顶部对齐
          ),
        ),
        padding: EdgeInsets.only(left: 40.w, right: 40.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '下级基本信息',
                  style: TextStyle(
                    fontSize: 45.sp,
                    color: const Color(colorFFFFFF),
                  ),
                ),
              ],
            ),
            Container(
              width: 68.w,
              height: 68.h,
              decoration: BoxDecoration(
                color: const Color(colorFFFFFF),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 50.w,
                  color: const Color(0xFFFF8845),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberBaseWidget(BuildContext context) {
    return Column(
      children: [
        _buildMemberAccount(context),
        _buildMemberTimeGroup(),
        _buildMemberInfoGroup(),
      ],
    );
  }

  Widget _buildMemberAccount(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 70.w,
            backgroundColor: context.theme.primaryColor,
            backgroundImage: controller.userHead.value.isNotEmpty
                ? NetworkImage(
                    controller.userHead.value,
                  )
                : AssetImage(Assets.theme1.images.home.rankListHeader1.path),
          ),
          SizedBox(width: 20.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '下级账号ID',
                style: TextStyle(fontSize: 36.sp, color: Colors.black),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    controller.userAccount.value,
                    style: TextStyle(
                      fontSize: 48.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                  CommonRipple(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      ClipboardUtil.copy(controller.userAccount.value);
                    },
                    child: SvgPicture.asset(
                      Assets.theme1.images.agentCenter.iconCopy,
                      width: 42.w,
                      height: 42.h,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMemberTimeGroup() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '最后登录时间',
                style: TextStyle(
                  fontSize: 45.sp,
                  color: const Color(color666666),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                controller.userLoginTime.value,
                style: TextStyle(
                  fontSize: 45.sp,
                  color: const Color(color050505),
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          SizedBox(height: 40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '注册时间',
                style: TextStyle(
                  fontSize: 45.sp,
                  color: const Color(color666666),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                controller.userRegisteTime.value,
                style: TextStyle(
                  fontSize: 45.sp,
                  color: const Color(color050505),
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          SizedBox(height: 40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '钱包余额',
                style: TextStyle(
                  fontSize: 45.sp,
                  color: const Color(color666666),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                controller.userBalance.value,
                style: TextStyle(
                  fontSize: 45.sp,
                  color: const Color(colorFF3737),
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMemberInfoGroup() {
    return Container(
      height: 500.h,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
      child: GridView.count(
        crossAxisCount: 3, // 每行3个
        childAspectRatio: 1.65, // 控制每个子组件的宽高比
        children: [
          _buildMemberInfoItem(
            title: '存款金额',
            amount: parseNumber(controller.rechargeAmount.value),
          ),
          _buildMemberInfoItem(
            title: '提款金额',
            amount: parseNumber(controller.withdrawAmount.value),
          ),
          _buildMemberInfoItem(
            title: '今日输赢',
            amount: parseNumber(controller.todayWinAmount.value),
          ),
          _buildMemberInfoItem(
            title: '有效投注',
            amount: parseNumber(controller.bettingAmount.value),
          ),
          _buildMemberInfoItem(
            title: '总投注额',
            amount: parseNumber(controller.totalBettingAmount.value),
          ),
          _buildMemberInfoItem(
            title: '总输赢额',
            amount: parseNumber(controller.totalWinAmount.value),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberInfoItem({
    required String title,
    required String amount,
    bool? isAmount,
  }) {
    String value =
        isAmount == true ? parseNumber(double.tryParse(amount) ?? 0) : amount;
    return Container(
      width: 375.w,
      height: 180.h,
      margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color(0xFFFF8D4C).withOpacity(0.3),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isAmount == true
              ? RichText(
                  textAlign: TextAlign.end,
                  text: TextSpan(
                    text: '¥ ',
                    style: TextStyle(
                      fontSize: 40.sp,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: value,
                        style: TextStyle(fontSize: 72.sp, color: Colors.black),
                      ),
                    ],
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(fontSize: 54.sp, color: Colors.black),
                ),
          SizedBox(height: 20.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 33.sp,
              color: const Color(color6B6B6B),
              height: 1.2,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar(BuildContext context) {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        DebounceThrottle.debounce(controller.changeShowQuery)();
      },
      child: Container(
        height: 150.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF10C8E3), Color(0xFF95F1FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          image: DecorationImage(
            image: AssetImage(Assets.theme1.images.agentCenter.iconMask.path),
            fit: BoxFit.cover, // 使用 BoxFit.cover
            alignment: Alignment.topCenter, // 确保顶部对齐
          ),
        ),
        padding: EdgeInsets.only(left: 40.w, right: 40.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '游戏记录',
                  style: TextStyle(
                    fontSize: 45.sp,
                    color: const Color(colorFFFFFF),
                  ),
                ),
              ],
            ),
            Container(
              width: 68.w,
              height: 68.h,
              decoration: BoxDecoration(
                color: const Color(colorFFFFFF),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 50.w,
                  color: context.theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建表头标题 需要固定宽度
  Widget _buildTableHeaderTitle(String text,
      {double? width, BorderRadiusGeometry? borderRadius}) {
    return Container(
      width: width ?? 200.w,
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color(color00CCE7),
        borderRadius: borderRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 40.sp,
          color: const Color(colorFFFFFF),
          height: 1.1,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildTableBodyText(String text, {double? width}) {
    return Container(
      width: width ?? 200.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 36.sp,
          color: const Color(color6B6B6B),
          height: 1.1,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // 查看会员详情
  Widget _buildDetailText(dynamic item) {
    return CommonRipple(
      onTap: () {
        //
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        child: Text(
          '查看',
          style: TextStyle(
            fontSize: 45.sp,
            color: const Color(0xFF00CCE7),
            height: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildTableWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          // 固定表头
          Container(
            color: Colors.grey[300],
            child: Row(
              children: [
                _buildTableHeaderTitle(
                  '订单号',
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(20.r)),
                  width: 300.w,
                ),
                _buildTableHeaderTitle(
                  '厅方名称',
                  width: 200.w,
                ),
                _buildTableHeaderTitle(
                  '游戏名称',
                  width: 240.w,
                ),
                _buildTableHeaderTitle(
                  '投注金额',
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(20.r)),
                  width: 240.w,
                ),
              ],
            ),
          ),
          Visibility(
            visible: controller.dataList.isNotEmpty,
            child: // 可滚动的表体
                SizedBox(
              // height: controller.dataList.length > controller.pageSize
              //     ? 150.h * 10
              //     : 150.h * controller.dataList.length, // 根据数据行数设置高度
              height: calcTableHeight(
                dataLength: controller.dataList.length,
                pageSize: controller.pageSize,
              ),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),

                controller: controller.scrollController, // 绑定 ScrollController
                child: DataTable(
                  headingRowHeight: 0,
                  dataRowMinHeight: 100.h,
                  dataRowMaxHeight: 150.h,
                  horizontalMargin: 0,
                  columnSpacing: 0,
                  dividerThickness: 1.h,
                  columns: [
                    DataColumn(label: Container(height: 0)),
                    DataColumn(label: Container(height: 0)),
                    DataColumn(label: Container(height: 0)),
                    DataColumn(label: Container(height: 0)),
                  ],
                  rows: controller.dataList.map((item) {
                    return DataRow(cells: [
                      DataCell(_buildTableBodyText(
                        '${item['platform_order_id'] ?? ''}',
                        width: 300.w,
                      )),
                      DataCell(_buildTableBodyText(
                        '${item['play_cname'] ?? ''}',
                        width: 200.w,
                      )),
                      DataCell(_buildTableBodyText(
                        '${item['game_type_cname'] ?? ''}',
                        width: 240.w,
                      )),
                      DataCell(_buildTableBodyText(
                        parseNumber((item['bets'] is int
                                ? item['bets']
                                : (item['bets'] is String
                                    ? num.parse(item['bets'])
                                    : 0)) /
                            1000),
                        width: 240.w,
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
          Visibility(
            // 数据不为空 且 没有更多数据了
            visible: controller.dataList.isNotEmpty && !controller.hasMore,
            child: JobsNoMoreView(),
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

    return CommonRipple(
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
          color:
              isSelect ? context.theme.primaryColor : const Color(colorB1DAE0),
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
            CommonRipple(
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
                color: const Color(colorFFFFFF), // 背景颜色
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
                    Text('请选择时间：', style: TextStyle(fontSize: 42.sp)),
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
                        controller.handleConfirmQuery();
                        Get.back();
                      },
                      onReset: () {
                        AppManager.instance.tapVibrate();
                        controller.handleResetData();
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
