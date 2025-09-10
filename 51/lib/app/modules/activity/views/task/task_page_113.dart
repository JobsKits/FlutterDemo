// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/task_bean.dart';

import 'task_page_left_icon.dart';
import 'task_page_center_container.dart';
import '../../controllers/controller_task_page.dart';

import 'package:flutter_tiyu_app/app/modules/activity/widget/common_button.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart' show parseNumber;

class TaskPage113 extends StatefulWidget {
  final TaskTabItemBean taskItemData;

  const TaskPage113({
    super.key,
    required this.taskItemData,
  });

  @override
  State<TaskPage113> createState() => _TaskPage113State();
}

class _TaskPage113State extends State<TaskPage113> {
  num percentage = 0;
  num valid_days = 0;
  ControllerTaskPage controller = Get.find();

  @override
  void initState() {
    super.initState();

    percentage = widget.taskItemData.percentage!;
    valid_days = widget.taskItemData.valid_days!;
  }

  // 构建标题
  String _buildTitle(StandaraListBean itemData) {
    String? standara_name = itemData.standara_name;
    // num? fraction = itemData.fraction;

    return standara_name ?? '';
  }

  // 构建描述
  String _buildDesc(StandaraListBean itemData) {
    String? explains = itemData.explains;
    num? isReceive = itemData.isReceive;
    num? receiveTime = itemData.receiveTime;

    String prefix =
        '${(explains ?? '').isEmpty ? '${DateTimeUtils.formatTimestamp(receiveTime!.toInt())}前领取' : explains}';

    String suffix = '${isReceive == 2 ? 1 : 0}/1';
    return '${prefix} ${suffix}';
  }

  // 构建奖励
  String _buildReward(StandaraListBean itemData) {
    num? reward = itemData.reward;

    if (reward == null) {
      return '';
    }

    return parseNumber(reward / 1000);
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
                showQuestion: true,
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
    return RefreshIndicator(
      onRefresh: () async {
        await controller.requestRefresh(); // 调用刷新数据的方法
      },
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 30.h),
        itemCount: controller.activeBonusData.length,
        itemBuilder: (context, index) {
          StandaraListBean itemData = controller.activeBonusData[index];
          return Container(
            margin: index != controller.activeBonusData.length - 1
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
    if (itemData.isReceive == 2) {
      return Obx(
        () => CommonButton(
          title: '领取',
          type: CommonButtonTypeEnum.Primary,
          onTap: () {
            controller.reqReceiveTaskActivityBonus(itemData);
          },
          loading: controller.isReceiveLoading.value,
          loadingAnimation: false,
        ),
      );
    }

    return const CommonButton(
      title: '已领取',
      type: CommonButtonTypeEnum.Primary,
      disabled: true,
    );
  }
}
