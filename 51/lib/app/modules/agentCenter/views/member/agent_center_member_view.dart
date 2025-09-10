import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/Finance.const.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/widget/empty_widget.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/app/widget/JobsViews.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import '../../../activity/widget/common_input_widget.dart';
import '../../controllers/agent_center_member_controller.dart';
import '../../widget/date_range_widget.dart';
import '../../widget/button_group_widget.dart';
import '../../widget/cascader/ym_cascader.dart';

// 会员
class AgentCenterMemberView extends GetView<AgentCenterMemberController> {
  const AgentCenterMemberView({super.key});

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
      ),
      padding: EdgeInsets.only(bottom: 50.w),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              AppManager.instance.tapVibrate();
              Get.toNamed(Routes.AGENT_CENTER_TRANSFER_SUB);
            },
            child: Container(
              padding: EdgeInsets.only(left: 50.h, right: 50.h),
              margin: EdgeInsets.only(bottom: 50.h),
              height: 145.h,
              decoration: BoxDecoration(
                  color: context.customTheme?.pageTwoBg,
                  borderRadius: BorderRadius.circular(40.r)),
              child: Row(
                children: [
                  Image.asset(
                    ThemeService.to.currentTheme.value?.model == 'blackGold'
                        ? Assets.theme1.images.agentCenter
                            .iconAgentMoneyBlackGold.path
                        : Assets.theme1.images.agentCenter.iconAgentMoney.path,
                    width: 66.w,
                    height: 66.h,
                    color: context.theme.primaryColor,
                  ),
                  SizedBox(
                    width: 32.w,
                  ),
                  Expanded(
                      child: Text(
                    "转账给下级",
                    style: TextStyle(
                        fontSize: 45.sp,
                        color: context.customTheme?.titleColor),
                  )),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 80.w,
                    color: context.customTheme?.arrowColor,
                  )
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: context.customTheme?.pageTwoBg,
                borderRadius: BorderRadius.circular(30.r)),
            child: Column(
              children: [
                _buildHeaderProfitBar(context),
                Visibility(
                  visible: controller.showGroup.value,
                  child: _buildProfixGroup(context),
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
                        // _buildTitle('选择游戏：'),
                        // _buildGameSelectWidget(),
                        _buildTitle(context, '会员ID：'),
                        CommonInputWidget(
                          minValue: 0,
                          readOnly: false,
                          defaultContent: controller.defaultUsername.value,
                          textInputType: TextInputType.number,
                          inputWidgetType: InputWidgetTypeEnum.customeType,
                          onChanged: (value) => controller.setUsername(value),
                          placeholder: '请输入会员ID',
                          color: context.customTheme?.inputBgColor,
                        ),
                        // Stack(
                        //   children: [
                        //     CommonInputWidget(
                        //       margin: EdgeInsets.only(top: 30.h, bottom: 60.h),
                        //       placeholder: "请选择会员账号",
                        //       maxLength: 16,
                        //       readOnly: true,
                        //       defaultContent: controller.username.value,
                        //       textInputType: TextInputType.text,
                        //       color: const Color(colorF4F4F4),
                        //       rightWidget: Icon(
                        //         Icons.arrow_drop_down_rounded,
                        //         size: 80.w,
                        //         color: const Color(0xFFB5B5B5),
                        //       ),
                        //       readOnlyColor:
                        //           const Color(colorDDDDDD).withOpacity(0.4),
                        //       inputWidgetType: InputWidgetTypeEnum.customeType,
                        //     ),
                        //     Positioned(
                        //       left: 0,
                        //       top: 0,
                        //       child: InkWell(
                        //         onTap: () {
                        //           if (controller.subList.isEmpty) {
                        //             EasyLoading.showError('暂无下级账号');
                        //           } else {
                        //             Get.bottomSheet(
                        //               SubAccountWidget(
                        //                 selectId: controller.selectAcctId.value,
                        //                 subList: controller.subList,
                        //                 callback: controller.setSelectAcctId,
                        //               ),
                        //               isScrollControlled: true,
                        //             );
                        //           }
                        //         },
                        //         child: Container(
                        //           width: double.infinity,
                        //           height: 124.h,
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        // ),
                        _buildTitle(context, '请选择时间：'),
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
          )
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 42.sp,
          color: context.customTheme?.titleColor,
        ),
      ),
    );
  }

  Widget _buildGameSelectWidget() {
    return InkWell(
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

  Widget _buildHeaderProfitBar(BuildContext context) {
    return InkWell(
      onTap: () {
        AppManager.instance.tapVibrate();
        DebounceThrottle.debounce(controller.changeShowGroup)();
      },
      child: Container(
        height: 150.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          gradient: LinearGradient(
            colors: ThemeService.to.currentTheme.value?.model == 'blackGold'
                ? [
                    context.customTheme?.pageTwoBg ?? Colors.transparent,
                    context.customTheme?.pageTwoBg ?? Colors.transparent
                  ]
                : [Color(0xFFFF8541), Color(0xFFFFC09D)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          // image: DecorationImage(
          //   image: AssetImage(Assets.theme1.images.agentCenter.iconMask.path),
          //   fit: BoxFit.cover, // 使用 BoxFit.cover
          //   alignment: Alignment.topCenter, // 确保顶部对齐
          // ),
        ),
        padding: EdgeInsets.only(left: 40.w, right: 40.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  ThemeService.to.currentTheme.value?.model == 'blackGold'
                      ? Assets
                          .theme1.images.agentCenter.iconProfitBlackGold.path
                      : Assets.theme1.images.agentCenter.iconProfit.path,
                  width: 58.w,
                  height: 58.h,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10.w),
                Text(
                  '业绩报表',
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
                color: context.customTheme?.inputBgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 50.w,
                  color: const Color(colorFFFFFF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfixGroup(BuildContext context) {
    return Container(
      height: 920.h,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
      child: GridView.count(
        crossAxisCount: 3, // 每行3个
        childAspectRatio: 1.3, // 控制每个子组件的宽高比
        children: [
          _buildProfitItem(
            context,
            title: '下级成员统计',
            amount: '${controller.memberInfo.value.cust_count ?? 0}',
          ),
          _buildProfitItem(
            context,
            title: '本月新增',
            amount: '${controller.memberInfo.value.mon_register_count ?? 0}',
          ),
          _buildProfitItem(
            context,
            title: '本月活跃成员',
            amount: '${controller.memberInfo.value.mon_active_count ?? 0}',
          ),
          _buildProfitItem(
            context,
            title: '本月有效活跃',
            amount:
                '${controller.memberInfo.value.mon_invalid_active_count ?? 0}',
          ),
          _buildProfitItem(
            context,
            title: '今日新增',
            amount: '${controller.memberInfo.value.today_register_count ?? 0}',
          ),
          _buildProfitItem(
            context,
            title: '今日活跃',
            amount: '${controller.memberInfo.value.day_active_count ?? 0}',
          ),
          _buildProfitItem(
            context,
            title: '本月存款(元)',
            amount: parseNumber(
                (controller.memberInfo.value.mon_charge_amount ?? 0) / 1000),
            isAmount: true,
          ),
          _buildProfitItem(
            context,
            title: '今日存款(元)',
            amount: parseNumber(
                (controller.memberInfo.value.day_charge_amount ?? 0) / 1000),
            isAmount: true,
          ),
          _buildProfitItem(
            context,
            title: '总输赢金额',
            amount: parseNumber(
                (controller.memberInfo.value.profie_amount ?? 0) / 1000),
            isAmount: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProfitItem(
    BuildContext context, {
    required String title,
    required String amount,
    bool? isAmount,
  }) {
    String value =
        isAmount == true ? parseNumber(double.tryParse(amount) ?? 0) : amount;
    return Container(
      width: 300.w,
      height: 250.h,
      margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color(0xFFFF8D4C).withOpacity(0.3),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isAmount == true
              ? RichText(
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  text: TextSpan(
                    text: '¥',
                    style: TextStyle(
                      fontSize: 36.sp,
                      color: context.theme.primaryColor,
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(
                        text: value,
                        style: TextStyle(
                          fontSize: 56.sp,
                          color: context.theme.primaryColor,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    fontSize: 56.sp,
                    color: context.theme.primaryColor,
                    height: 1.2,
                  ),
                  maxLines: 2,
                ),
          SizedBox(height: 20.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 33.sp,
              color: context.customTheme?.title2Color,
              height: 1.2,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar(BuildContext context) {
    return InkWell(
      onTap: () {
        AppManager.instance.tapVibrate();
        DebounceThrottle.debounce(controller.changeShowQuery)();
      },
      child: Container(
        height: 150.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          gradient: LinearGradient(
            colors: ThemeService.to.currentTheme.value?.model == 'blackGold'
                ? [
                    context.customTheme?.pageTwoBg ?? Colors.transparent,
                    context.customTheme?.pageTwoBg ?? Colors.transparent
                  ]
                : [Color(0xFF10C8E3), Color(0xFF95F1FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          // image: DecorationImage(
          //   image: AssetImage(Assets.theme1.images.agentCenter.iconMask.path),
          //   fit: BoxFit.cover, // 使用 BoxFit.cover
          //   alignment: Alignment.topCenter, // 确保顶部对齐
          // ),
        ),
        padding: EdgeInsets.only(left: 40.w, right: 40.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  ThemeService.to.currentTheme.value?.model == 'blackGold'
                      ? Assets
                          .theme1.images.agentCenter.iconSubMemberBlackGold.path
                      : Assets.theme1.images.agentCenter.iconSubMember.path,
                  width: 68.w,
                  height: 68.h,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10.w),
                Text(
                  '下级成员列表',
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
                color: context.customTheme?.inputBgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 50.w,
                  color: Color(colorFFFFFF),
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
    return InkWell(
      onTap: () {
        AppManager.instance.tapVibrate();
        //  跳转会员详情
        Get.toNamed(
          Routes.AGENT_CENTER_SUB_DETAIL,
          arguments: {'userId': item['cust_id']},
        );
      },
      child: SizedBox(
        width: 200.w,
        child: Center(
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
        ),
      ),
    );
  }

  Widget _buildTableWidget() {
    if (controller.dataList.isEmpty) {
      return const SizedBox();
    }

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
                  '会员ID',
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(20.r)),
                  width: 240.w,
                ),
                _buildTableHeaderTitle(
                  '存款(元)',
                ),
                _buildTableHeaderTitle(
                  '提款(元)',
                ),
                _buildTableHeaderTitle(
                  '充提差',
                ),
                _buildTableHeaderTitle(
                  '投注额(元)',
                  width: 240.w,
                ),
                _buildTableHeaderTitle(
                  '最后登录日期',
                  width: 300.w,
                ),
                _buildTableHeaderTitle(
                  '注册时间',
                ),
                // _buildTableHeaderTitle('实际充值金额', width: 300.w),
                _buildTableHeaderTitle(
                  '操作',
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(20.r)),
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
                    DataColumn(label: Container(height: 0)),
                    DataColumn(label: Container(height: 0)),
                    DataColumn(label: Container(height: 0)),
                    DataColumn(label: Container(height: 0)),
                  ],
                  rows: controller.dataList.map((item) {
                    return DataRow(cells: [
                      DataCell(_buildTableBodyText(
                        '${item['cust_id'] ?? ''}',
                        width: 240.w,
                      )),
                      DataCell(_buildTableBodyText(
                        parseNumber((item['charge_amount'] ?? 0) / 1000),
                      )),
                      DataCell(_buildTableBodyText(
                        parseNumber((item['withdraw_amount'] ?? 0) / 1000),
                      )),
                      DataCell(_buildTableBodyText(
                        parseNumber((item['charge_withdraw_diff'] ?? 0) / 1000),
                      )),
                      DataCell(_buildTableBodyText(
                        parseNumber((item['plan_amount'] ?? 0) / 1000),
                        width: 240.w,
                      )),
                      DataCell(_buildTableBodyText(
                        DateTimeUtils.formatTimestamp(
                            int.parse('${item['login_time'] ?? 0}')),
                        width: 300.w,
                      )),
                      DataCell(_buildTableBodyText(
                        DateTimeUtils.formatTimestamp(
                            int.parse('${item['create_time'] ?? 0}')),
                      )),
                      DataCell(_buildDetailText(item)),
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
