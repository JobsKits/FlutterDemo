import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_task_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/daily_tasks_model/daily_tasks_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/daily_tasks_model/task_date_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/task/task_page_center_container.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/task/task_page_left_icon.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_button.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../utils/CommonRipple.dart';

class TaskPage204 extends StatefulWidget {
  final DailyTasksModel taskItemData;

  const TaskPage204({
    super.key,
    required this.taskItemData,
  });

  @override
  State<TaskPage204> createState() => _TaskPage204State();
}

class _TaskPage204State extends State<TaskPage204> {
  ControllerTaskPage controller = Get.find();

  // 当前选中的索引
  int _selectedIndex = 0;

  // 按钮列表
  final List<String> _options = ['每日', '每周', '每月'];

  @override
  void initState() {
    super.initState();
  }

  // 构建标题
  String _buildTitle(TaskDateModel itemData) {
    return itemData.taskName ?? '';
  }

  String formatRewardAmount(dynamic rewardAmount) {
    double amount = (rewardAmount is num)
        ? rewardAmount.toDouble()
        : double.tryParse(rewardAmount?.toString() ?? '0') ?? 0;

    return (amount / 1000).truncateToFixed(2);
  }

  String _buildDesc(TaskDateModel itemData) {
    return '奖励 ${formatRewardAmount(itemData.rewardAmount)}元';
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

  Widget _buildItem(TaskDateModel itemData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              TaskPageLeftIcon(iconUrl: itemData.taskIcon),
              TaskPageCenterContainer(
                topText: _buildTitle(itemData),
                reward: _buildTitle(itemData),
                bottomText: _buildDesc(itemData),
                showPercentage: false,
                bottomColor: Colors.red,
                percentage: 0.0,
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

  @override
  Widget build(BuildContext context) {
    // 获取标准列表数据
    List<TaskDateModel> standaraListData = [];
    if (_selectedIndex == 0) {
      standaraListData = widget.taskItemData.day ?? [];
    } else if (_selectedIndex == 1) {
      standaraListData = widget.taskItemData.week ?? [];
    } else if (_selectedIndex == 2) {
      standaraListData = widget.taskItemData.month ?? [];
    }

    return Column(
      children: [
        _buildHeader(context), // 构建顶部奖金和按钮区域
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.requestRefresh, // 刷新数据
            child: _buildTaskList(standaraListData), // 构建任务列表
          ),
        ),
      ],
    );
  }

  // 构建顶部 Header
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "",
              children: [
                _buildTextSpan("获得奖金:"),
                _buildTextSpan(
                    '${formatRewardAmount(widget.taskItemData.getAmount)}元',
                    isRed: true),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_options.length, (index) {
              final isSelected = _selectedIndex == index;
              return CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 7.5, horizontal: 10.0),
                  margin: const EdgeInsets.symmetric(horizontal: 0.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: index == 0
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5))
                        : index == 2
                            ? const BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5))
                            : BorderRadius.circular(0.0),
                  ),
                  child: Text(
                    _options[index],
                    style: TextStyle(
                      color: isSelected
                          ? context.theme.primaryColor
                          : Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  // 构建任务列表
  Widget _buildTaskList(List<TaskDateModel> standaraListData) {
    if (standaraListData.isEmpty) {
      return Center(
        child: Text(
          '暂无任务数据',
          style: TextStyle(fontSize: 32.sp, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 30.h),
      itemCount: standaraListData.length,
      itemBuilder: (context, index) {
        TaskDateModel itemData = standaraListData[index];
        return _buildTaskItem(itemData, index, standaraListData.length);
      },
    );
  }

  // 构建单个任务项
  Widget _buildTaskItem(TaskDateModel itemData, int index, int totalLength) {
    return Container(
      margin: index != totalLength - 1 ? EdgeInsets.only(bottom: 30.h) : null,
      padding: EdgeInsets.fromLTRB(50.w, 20.h, 50.w, 20.h),
      constraints: BoxConstraints(minHeight: 200.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r), // 圆角
        border: Border.all(color: const Color(colorFBFFFE), width: 0.5.w),
        color: const Color(colorFFFFFF),
      ),
      child: _buildItem(itemData),
    );
  }

  Widget _buildButton(TaskDateModel itemData) {
    if (itemData.status == '0') {
      return CommonButton(
        title: '去完成',
        type: CommonButtonTypeEnum.Outline,
        onTap: () {
          if (itemData.taskType == '1') {
            controller.tabsController.jumpToPage(0);
          } else {
            var isOpenVideo = TenantManager.instance.tenantBean!.isOpenVideo;
            if (isOpenVideo == 'true') {
              controller.tabsController.jumpToPage(1);
            }
          }
        },
      );
    }

    if (itemData.status == '1') {
      return CommonButton(
        title: '领取',
        type: CommonButtonTypeEnum.Outline,
        onTap: () {
          controller.reqReceiveDailyTaskData(
            itemData.receiveLogId ?? 0,
          );
        },
        loading: controller.isReceiveLoading.value,
        loadingAnimation: false,
      );
    }

    if (itemData.status == '2') {
      return const CommonButton(
        title: '已领取',
        type: CommonButtonTypeEnum.Outline,
      );
    }
    return const SizedBox();
  }
}
