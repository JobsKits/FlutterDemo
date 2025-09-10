// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/task/game_task_utils.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_button.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/task_bean.dart';

import 'task_page_left_icon.dart';
import 'task_page_center_container.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/game_task_tab_bean.dart';
import '../../controllers/controller_task_page.dart';

import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart' show parseNumber;

class TaskPage110 extends StatefulWidget {
  final TaskTabItemBean taskItemData;

  const TaskPage110({
    super.key,
    required this.taskItemData,
  });

  @override
  State<TaskPage110> createState() => _TaskPage110State();
}

class _TaskPage110State extends State<TaskPage110> {
  num percentage = 0;
  num valid_days = 0;
  ControllerTaskPage controller = Get.find();

  @override
  void initState() {
    super.initState();

    percentage = widget.taskItemData.percentage!;
    valid_days = widget.taskItemData.valid_days!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => _buildTabbarWidget(),
        ),
        _buildTabViewWidget(),
      ],
    );
  }

  // 构建导航栏
  Widget _buildTabbarWidget() {
    return Container(
      color: const Color(colorFFFFFF),
      width: double.infinity,
      child: TabBar(
        isScrollable: false,
        controller: controller.gameTaskTabController,
        tabAlignment: null,
        padding: EdgeInsets.zero, // 去除整体的边距
        tabs: controller.gameTaskTabData.map((element) {
          return Text(element.tabTitle);
        }).toList(),
        unselectedLabelColor: const Color(colorAFAFAF), // 未选中文字颜色
        labelColor: context.theme.primaryColor, // 选中文字颜色
        indicatorSize: TabBarIndicatorSize.label, // 指示器大小计算方式
        indicatorColor: Colors.transparent, // 指示器颜色
        automaticIndicatorColorAdjustment: true,
        dividerHeight: 0,
        labelPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        labelStyle: TextStyle(fontSize: 46.sp, overflow: TextOverflow.fade),
        unselectedLabelStyle: TextStyle(fontSize: 46.sp),
      ),
    );
  }

  TextSpan _buildTextSpan(String text, {bool? isRed = false}) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color:
            isRed == true ? const Color(colorE34310) : const Color(color3B3B3B),
        fontSize: 40.sp,
      ),
    );
  }

  // 构建页面
  Widget _buildTabViewWidget() {
    return Expanded(
      child: TabBarView(
        controller: controller.gameTaskTabController,
        physics: const NeverScrollableScrollPhysics(), // 禁止滑动
        children: controller.gameTaskTabData.map((element) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "",
                        children: [
                          _buildTextSpan("已领取"),
                          _buildTextSpan(controller.claimed.value, isRed: true),
                          _buildTextSpan("项，可领取"),
                          _buildTextSpan(controller.claimable.value,
                              isRed: true),
                          _buildTextSpan("项"),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: int.parse(controller.claimable.value) > 0,
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 240.w, minWidth: 200.w),
                        margin: EdgeInsets.only(right: 50.w),
                        child: CommonButton(
                          title: '一键领取',
                          type: CommonButtonTypeEnum.Primary,
                          onTap: () {
                            controller.handleReceive(item: null, isAll: true);
                          },
                          loading: controller.isReceiveLoading.value,
                          loadingAnimation: false,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: _buildContent(_getGameTaskData(element), ele: element),
              )
            ],
          );
        }).toList(),
      ),
    );
  }

  // 获取游戏任务数据
  List<GameTaskItemBean> _getGameTaskData(GameTaskTabBean ele) {
    if (ele.tabCal == 0) {
      return controller.gameTaskData;
    }

    return controller.gameTaskData.where((it) => it.cal == ele.tabCal).toList();
  }

  Widget _buildContent(
    List<GameTaskItemBean> dataList, {
    required GameTaskTabBean ele,
  }) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.requestRefresh(); // 调用刷新数据的方法
      },
      child: ListView.builder(
        key: PageStorageKey<String>(ele.tabTitle),
        padding: EdgeInsets.fromLTRB(30.w, 0.h, 30.w, 30.h),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          GameTaskItemBean itemData = dataList[index];
          return Container(
            margin: index != dataList.length - 1
                ? EdgeInsets.only(bottom: 30.h)
                : null,
            padding: EdgeInsets.fromLTRB(50.w, 20.h, 50.w, 20.h),
            constraints: BoxConstraints(minHeight: 200.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r), // 圆角
              border: Border.all(color: const Color(colorFBFFFE), width: 0.5.w),
              color: const Color(colorFFFFFF),
            ),
            child: _buildItem(itemData),
          );
        },
      ),
    );
  }

  // 构建奖励
  String _buildReward(GameTaskItemBean itemData) {
    return parseNumber(itemData.winnings_amount! / 1000);
  }

  Widget _buildItem(GameTaskItemBean itemData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              TaskPageLeftIcon(
                iconUrl: GameTaskUtils.buildIconUrl(itemData,
                    imgDomain: controller.imgDomain.value),
                isNetwork: true,
              ),
              TaskPageCenterContainer(
                topText: GameTaskUtils.buildTitle(itemData),
                reward: _buildReward(itemData),
                bottomText: GameTaskUtils.buildDesc(itemData),
                percentage: double.parse('${itemData.percentage}'),
                showQuestion: false,
              )
            ],
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 240.w),
          child: _buildButton(itemData),
        ),
      ],
    );
  }

  Widget _buildButton(GameTaskItemBean itemData) {
    if (itemData.is_draw == 1) {
      return const CommonButton(
        title: '已领取',
        type: CommonButtonTypeEnum.Primary,
        disabled: true,
      );
    }

    if (itemData.is_draw == 2) {
      return Obx(
        () => CommonButton(
          title: '领取',
          type: CommonButtonTypeEnum.Primary,
          onTap: () {
            controller.handleReceive(item: itemData, isAll: false);
          },
          loading: controller.isReceiveLoading.value,
          loadingAnimation: false,
        ),
      );
    }

    if (itemData.is_draw == 3) {
      return CommonButton(
        title: '去完成',
        type: CommonButtonTypeEnum.Primary,
        onTap: () {
          GameTaskUtils.linkJump(itemData);
        },
      );
    }

    return const SizedBox();
  }
}
