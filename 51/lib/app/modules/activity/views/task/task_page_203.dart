// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/task_bean.dart';

import 'task_page_left_icon.dart';
import 'task_page_center_container.dart';
import '../../controllers/controller_task_page.dart';

import 'package:flutter_tiyu_app/app/modules/activity/widget/common_button.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart' show parseNumber;

class TaskPage203 extends StatefulWidget {
  final TaskTabItemBean taskItemData;

  const TaskPage203({
    super.key,
    required this.taskItemData,
  });

  @override
  State<TaskPage203> createState() => _TaskPage203State();
}

class _TaskPage203State extends State<TaskPage203> {
  num percentage = 0;
  ControllerTaskPage controller = Get.find();

  @override
  void initState() {
    super.initState();

    percentage = widget.taskItemData.percentage!;
  }

  // 构建标题
  String _buildTitle(StandaraListBean itemData) {
    String? standara_name = itemData.standara_name;
    num? fraction = itemData.fraction;

    if (standara_name != null && standara_name.isNotEmpty) {
      return standara_name;
    }

    return '亏损满${double.tryParse('${fraction ?? 0}')!.truncateToFixed(2)}金币可领取';
  }

  // 构建描述
  String _buildDesc(StandaraListBean itemData) {
    String? explains = itemData.explains;
    num? completed = itemData.completed;
    num? fraction = itemData.fraction;

    return explains == null || explains == ''
        ? '每日任务 ${parseNumber(completed)}/${parseNumber(fraction)}'
        : explains;
  }

  // 构建奖励
  String _buildReward(StandaraListBean itemData) {
    num? reward = itemData.reward;

    if (reward == null) {
      return '';
    }

    if (percentage == 1) {
      return '${parseNumber(reward)}%';
    }

    return parseNumber(reward);
  }

  Widget _buildItem(StandaraListBean itemData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              TaskPageLeftIcon(iconUrl: itemData.icon_url),
              TaskPageCenterContainer(
                topText: _buildTitle(itemData),
                reward: _buildReward(itemData),
                bottomText: _buildDesc(itemData),
                percentage: double.tryParse('${itemData.percentage ?? 0}'),
                itemStandara: itemData,
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
    List<StandaraListBean> standaraListData = widget.taskItemData.standaraList!;
    return RefreshIndicator(
      onRefresh: () async {
        await controller.requestRefresh(); // 调用刷新数据的方法
      },
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 30.h),
        itemCount: standaraListData.length,
        itemBuilder: (context, index) {
          StandaraListBean itemData = standaraListData[index];
          return Container(
            margin: index != standaraListData.length - 1
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

  Widget _buildButton(StandaraListBean itemData) {
    if (itemData.isReceive == 0) {
      return const CommonButton(
        title: '今日24点结算',
        type: CommonButtonTypeEnum.Outline,
        disabled: true,
      );
    }

    if (itemData.isReceive == 1) {
      return const CommonButton(
        title: '已领取',
        type: CommonButtonTypeEnum.Primary,
        disabled: true,
      );
    }

    if (itemData.isReceive == 2) {
      return Obx(
        () => CommonButton(
          title: '领取',
          type: CommonButtonTypeEnum.Primary,
          onTap: () {
            controller.reqReceiveTaskReward(
              itemData.index! + 1,
              widget.taskItemData.type!,
              itemData.reward!,
              widget.taskItemData.percentage!,
              itemData.fraction!,
            );
          },
          loading: controller.isReceiveLoading.value,
          loadingAnimation: false,
        ),
      );
    }

    if (itemData.isReceive == 3) {
      return const CommonButton(
        title: '即将开始',
        type: CommonButtonTypeEnum.Outline,
        disabled: true,
      );
    }

    return const SizedBox();
  }
}
