// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/task_bean.dart';

import '../../../../../utils/tenant_manager.dart';
import 'task_page_left_icon.dart';
import 'task_page_center_container.dart';
import '../../controllers/controller_task_page.dart';

import 'package:flutter_tiyu_app/app/modules/activity/widget/common_button.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart' show parseNumber;

class TaskPage112 extends StatefulWidget {
  final TaskTabItemBean taskItemData;

  const TaskPage112({
    super.key,
    required this.taskItemData,
  });

  @override
  State<TaskPage112> createState() => _TaskPage112State();
}

class _TaskPage112State extends State<TaskPage112> {
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
    num? completed = itemData.completed;
    num? fraction = itemData.fraction;

    return '${explains} ${parseNumber(completed)}/${parseNumber(fraction)}';
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

  Widget _buildItem(BuildContext context, StandaraListBean itemData) {
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
          constraints: BoxConstraints(maxWidth: 200.w),
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
        itemCount: controller.memberTaskData.length,
        itemBuilder: (context, index) {
          StandaraListBean itemData = controller.memberTaskData[index];
          return Container(
            margin: index != controller.memberTaskData.length - 1
                ? EdgeInsets.only(bottom: 30.h)
                : null,
            padding: EdgeInsets.fromLTRB(50.w, 20.h, 50.w, 20.h),
            constraints: BoxConstraints(minHeight: 200.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r), // 圆角
              border: Border.all(color: const Color(colorFBFFFE), width: 0.5.w),
              color: context.customTheme?.pageTwoBg,
            ),
            child: _buildItem(context, itemData),
          );
        },
      ),
    );
  }

  Widget _buildButton(StandaraListBean itemData) {
    if (itemData.isReceive == 1) {
      return CommonButton(
        title: itemData.type == 1 ? '前往' : '进行中',
        type: CommonButtonTypeEnum.Outline,
        onTap: itemData.type == 1
            ? () {
                controller.tabsController.jumpToPage(
                    TenantManager.instance.tenantBean!.isOpenVideo == 'true'
                        ? 2
                        : 1);
              }
            : null,
      );
    }

    if (itemData.autoReceive == 1 && [4, 5].contains(itemData.isReceive)) {
      return const CommonButton(
        title: '次日1点结算',
        type: CommonButtonTypeEnum.Outline,
      );
    }

    if (itemData.isReceive == 2) {
      return Obx(
        () => CommonButton(
          title: '领取',
          type: CommonButtonTypeEnum.Primary,
          onTap: () {
            controller.reqReceiveTaskMemberMission(itemData);
          },
          loading: controller.isReceiveLoading.value,
          loadingAnimation: false,
        ),
      );
    }

    if (itemData.isReceive == 3) {
      if (itemData.receiveMethod == 1) {
        return Obx(
          () => CommonButton(
            title: '领取',
            type: CommonButtonTypeEnum.Primary,
            onTap: () {
              controller.reqReceiveTaskMemberMission(itemData);
            },
            loading: controller.isReceiveLoading.value,
            loadingAnimation: false,
          ),
        );
      }

      return CommonButton(
        title:
            "${itemData.receiveTime != null ? DateTimeUtils.formatTimestamp(itemData.receiveTime!.toInt(), temp: 'yyyy/MM/dd') : ''}领取",
        type: CommonButtonTypeEnum.Outline,
        disabled: true,
      );
    }

    if (itemData.isReceive == 4) {
      return const CommonButton(
        title: '已领取',
        type: CommonButtonTypeEnum.Primary,
        disabled: true,
      );
    }

    if (itemData.isReceive == 5) {
      return const CommonButton(
        title: '已失效',
        type: CommonButtonTypeEnum.Primary,
        disabled: true,
      );
    }
    return const SizedBox();
  }
}
