import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/task_newcomers_model/datum.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/task_newcomers_model/task_newcomers_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/task/task_page_204.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_button.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/empty_widget.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_count_timer.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/CommonRipple.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import "package:flutter_tiyu_app/constants/activity_constants.dart";

import 'package:flutter_tiyu_app/utils/common_color.dart';

import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_task_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/task_bean.dart';

import './task_page_101.dart';
import './task_page_102.dart';
import './task_page_103.dart';
import './task_page_203.dart';
import './task_page_106.dart';
import './task_page_110.dart';
import './task_page_111.dart';
import './task_page_112.dart';
import './task_page_113.dart';

/// 任务页面
class TaskPageView extends GetView<ControllerTaskPage> {
  const TaskPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 整个Column左对齐
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          controller.defaultLeftTab.isEmpty 
          ? RefreshIndicator(
              onRefresh: () async {
                await controller.requestRefresh(); // 调用刷新数据的方法
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 300.h),
                child: const Center(
                  child: EmptyWidget(),
                ),
              ),
            )
          : Expanded(
            child: Container(
              color: context.customTheme?.pageBg,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // 行内容顶部对齐
                children: [
                  // 左侧菜单栏
                  _buildLeftBarWidget(context),
                  
                  // 右侧内容区域
                  if (controller.defaultLeftTab[controller.leftCurrentIndex.value].contains('新人福利'))
                    _buildNewcomersContent(context)
                  else
                    _buildActivityTabContent(context),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNewcomersContent(BuildContext context) {
    return Expanded(
      flex: 1,
      child: RefreshIndicator(
        onRefresh: () async {
          await controller.requestActivityData();
          await controller.requestNewcomersWelfareData();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10.h),
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 0.9.sh,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (controller.newcommersList.isEmpty)
                  const Center(child: EmptyWidget())
                else ...[
                  ...controller.newcommersList.map(
                    (data) => _buildNewcomersItem(context, data),
                  ),
                  _buildNewcomersRuler(
                    context, 
                    controller.newcommersModel.value.t?.activityRule ?? ''
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityTabContent(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          // _buildTabBar(context),
          _buildTabView(context),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(130.h),
      child: Container(
        // color: const Color(colorFFFFFF),
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Obx(() {
          if (controller.tabList.isEmpty) {
            return SizedBox(width: double.infinity, height: 130.h);
          }

          final isScrollable = controller.tabList.length > 3;
          final curIndex = controller.tabCurrentIndex.value;
          
          return TabBar(
            isScrollable: isScrollable,
            controller: controller.tabActivityListController,
            tabAlignment: isScrollable ? TabAlignment.start : null,
            padding: EdgeInsets.zero,
            onTap: (val) {
              AppManager.instance.tapVibrate();
              controller.jumpToPage(val, needAnimate: false);
            },
            tabs: controller.tabList.map((element) {
              final isSelected = controller.tabList.indexOf(element) == curIndex;
              return Container(
                height: 86.h,
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(43.r),
                  color: isSelected
                    ? const Color(theme01MainColor)
                    : const Color(colorF4F4F4),
                ),
                child: Center(
                  child: Text(
                    element.title!,
                    style: TextStyle(
                      color: isSelected
                        ? const Color(colorFFFFFF)
                        : const Color(colorAFAFAF),
                    ),
                  ),
                ),
              );
            }).toList(),
            dividerHeight: 0,
            indicatorWeight: 1,
            indicatorPadding: EdgeInsets.zero,
            unselectedLabelColor: const Color(colorAFAFAF),
            labelColor: const Color(colorFFFFFF),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.transparent,
            labelPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            labelStyle: TextStyle(fontSize: 46.sp, overflow: TextOverflow.fade),
          );
        }),
      ),
    );
  }

  Widget _buildTabView(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Obx(() {
        if (controller.tabList.isEmpty) return const SizedBox();
        
        return PageView(
          controller: controller.pageController,
          onPageChanged: (index) {
            controller.jumpToPage(index);
          },
          children: controller.tabList.map((ele) {
            return _buildTabViewItem(context); // Pass the tab item data
          }).toList(),
        );
      }),
    );
  }

  Widget _buildLeftBarWidget(BuildContext context) {
    return Container(
      width: 200.w,
      height: 0.9.sh,
      margin: EdgeInsets.only(top: 10.h, left: 10.w),
      child: SingleChildScrollView(
        padding: EdgeInsets.zero, // 清除默认 padding
        physics: const BouncingScrollPhysics(), // 可选：更流畅的滚动效果
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
          children: [
            SizedBox(height: 10.h), // 顶部留白（可选）
            ...controller.defaultLeftTab.map((tab) {
              int idx = controller.defaultLeftTab.indexOf(tab);
              int curIndex = controller.leftCurrentIndex.value;
              bool isSelected = idx == curIndex;
              
              return CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  controller.leftCurrentIndex.value = idx;
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 26.h),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  constraints: BoxConstraints(minWidth: 200.w, minHeight: 162.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: isSelected
                      ? context.theme.primaryColor.withOpacity(0.15)
                      : context.customTheme?.pageTwoBg,
                    border: isSelected
                      ? Border.all(
                        color: context.theme.primaryColor,
                        width: 0.5
                      ) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (controller.defaultLeftTab[idx] == '新人福利') ... [
                        Image.asset(
                          Assets.theme1.images.activity.activityTaskNewcomersS.path,
                          width: 64.w,
                          height: 64.h,
                          color: isSelected 
                            ? context.theme.primaryColor // 选中的颜色
                            : context.customTheme?.title2Color, // 未选中的颜色
                        ),
                      ] else if (controller.defaultLeftTab[idx] == '会员任务') ... [
                        Image.asset(
                          Assets.theme1.images.activity.activityTaskDailyN.path,
                          width: 64.w,
                          height: 64.h,
                          color: isSelected 
                            ? context.theme.primaryColor // 选中的颜色
                            : context.customTheme?.title2Color, // 未选中的颜色
                        ),
                      ],
                      // if (controller.defaultLeftTab[controller.leftCurrentIndex.value].contains('新人福利')) ... [
                      //   Image.asset(
                      //     Assets.theme1.images.activity.activityTaskNewcomersS.path,
                      //     width: 113.w,
                      //     height: 99.h,
                      //   ),
                      // ] else if (controller.defaultLeftTab[controller.leftCurrentIndex.value].contains('会员任务') ) ... [
                      //   Image.asset(
                      //     Assets.theme1.images.activity.activityTaskDailyN.path,
                      //     width: 113.w,
                      //     height: 99.h,
                      //   ),
                      // ],
                      Text(
                        tab, // 直接使用 tab，无需通过索引获取
                        style: TextStyle(
                          fontSize: 36.sp,
                          color: isSelected
                              ? context.theme.primaryColor // 选中的颜色
                              : context.customTheme?.title2Color, // 未选中的颜色
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),

                      if (controller.defaultLeftTab.isNotEmpty && 
                        controller.taskDurationDisplay.value > 0 && 
                        (controller.newcommersModel.value.t?.expiredDate ?? 0) != 0 && 
                        controller.defaultLeftTab[idx] == '新人福利' &&
                        LoginManager.instance.isLogin.value) ... {
                        Container(
                          width: 350.w,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: ActivityCountTimer(
                            startTime: DateTime.now().millisecondsSinceEpoch,
                            endTime: controller.newcommersModel.value.t?.expiredDate ?? 0,
                            timeFormat: true,
                            lastStr: '',
                            fontSize: 39.sp,
                            fontColor: isSelected
                              ? const Color(colorFFFFFF)
                              : const Color(colorC7CBD3),
                          ),
                        )
                      }
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNewcomersItem(BuildContext context, Datum model) {
    return Container(
      decoration: BoxDecoration(
        color: context.customTheme?.pageTwoBg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.only(left: 30.w, right: 15.w, top: 30.w, bottom: 30.w),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 0.55.sw,
                child: Text(
                  model.taskName ?? '',
                  style: TextStyle(
                    color: context.customTheme?.titleColor,
                    fontSize: 45.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Image.asset(
                    Assets.theme1.images.activity.activtyTaskMonney.path,
                    width: 30.w,
                    height: 30.h,
                  ),
                  Text(
                    ((model.rewardAmount ?? 0) / 1000).toStringAsFixed(2),
                    style: TextStyle(
                      color: context.theme.primaryColor,
                      fontSize: 36.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (model.activityScore != null && model.activityScore != '' && model.activityScore != '0') ... [
                    const SizedBox(width: 10),
                    Image.asset(
                      Assets.theme1.images.activity.activtyTaskEnergy.path,
                      width: 30.w,
                      height: 30.h,
                    ),
                    Text(
                      model.activityScore ?? '',
                      style: TextStyle(
                        color: context.theme.primaryColor,
                        fontSize: 36.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]
                ],
              )
            ],
          ),
        ),

        Container(
          constraints: BoxConstraints(maxWidth: 180.w),
          child: Column(
            children: [
              CommonButton(
                title: backWithName(model.status ?? 0),
                bgColor: model.status == 3 ? const Color(0xffE3E4E4) : model.status == 4 ? const Color(0xffC7CBD3) : context.theme.primaryColor,
                type: model.status == 3 || model.status == 4 ? CommonButtonTypeEnum.Primary : CommonButtonTypeEnum.LinearGradient,
                onTap: () {
                  if (model.status == 0 || model.status == null) {
                    showRegisterDialog();
                  } else if (model.status == 1) {
                    switch (model.taskCode) {
                      case '1':
                        showRegisterDialog();
                        break;
                      case '2':
                        Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT, arguments: {"tabIndex": 1})?.then((_) async {
                          await controller.requestNewcomersWelfareData();
                        });
                        break;
                      case '3':
                        Get.toNamed(Routes.USER_INFO, arguments: {"isShowSendCode": true, "isShowBirthday": true})?.then((_) async {
                          await controller.requestNewcomersWelfareData();
                        });
                        break;
                      case '4':
                        Get.toNamed(Routes.EDIT_PASSWORD, arguments: {"isLoginPwd": false})?.then((_) async {
                          await controller.requestNewcomersWelfareData();
                        });
                        break;
                      case '5':
                        final signInIndex = controller.actController.activityData.indexWhere(
                          (activity) => activity.title == "利息宝",
                        );
                        Future.delayed(const Duration(milliseconds: 100), () {
                          controller.actController.jumpToPage(signInIndex);
                        });
                        break;
                      case '6':
                        Get.toNamed(Routes.CHANGE_AVATAR)?.then((_) async {
                          await controller.requestNewcomersWelfareData();
                        });
                        break;
                      case '7':
                        Get.toNamed(Routes.USER_INFO,
                          arguments: {"isShowSendCode": true, "isShowBindPhoneDialog": true})?.then((_) async {
                          await controller.requestNewcomersWelfareData();
                        });
                        break;
                      case '8':
                        var isOpenVideo = TenantManager.instance.tenantBean?.isOpenVideo == 'true';
                        controller.tabsController.jumpToPage(isOpenVideo ? 2 : 1);
                        break;
                      case '9':
                        if (LoginManager.instance.isLogin.value) {
                          var isOpenVideo = TenantManager.instance.tenantBean?.isOpenVideo == 'true';
                          controller.tabsController.jumpToPage(isOpenVideo ? 2 : 1);
                        } else {
                          showLoginDialog();
                        }
                        break;
                      case '10':
                        Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT)?.then((_) async {
                          await controller.requestNewcomersWelfareData();
                        });
                        break;
                      case '11':
                        Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT)?.then((_) async {
                          await controller.requestNewcomersWelfareData();
                        });
                        break;
                      case '12':
                        Get.toNamed(Routes.NEW_RECHARGE_WITHDRAWAL)?.then((_) async {
                          await controller.requestNewcomersWelfareData();
                        });
                        break;
                      case '13':
                        if (LoginManager.instance.isLogin.value) {
                          var isOpenVideo = TenantManager.instance.tenantBean?.isOpenVideo == 'true';
                          controller.tabsController.jumpToPage(isOpenVideo ? 2 : 1);
                        } else {
                          showLoginDialog();
                        }
                        break;
                      default:
                    }
                  } else if (model.status == 2) {
                    controller.reqNewcomersTaskReceive(model);
                  }
                },
                loading: controller.isReceiveLoading.value,
                loadingAnimation: false,
              ),
              if (model.status == 4) ... {
                ActivityCountTimer(
                  startTime: DateTime.now().millisecondsSinceEpoch,
                  endTime: getTomorrowTimestamp(),
                  timeFormat: false,
                  fontSize: 39.sp,
                  fontColor: Color(0xffAFAFAF),
                )
              }
            ],
          )
        ),
      ],
    ));
  }

  int getTomorrowTimestamp() {
    DateTime now = DateTime.now();
    DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
    int tomorrowMidnightTimestamp = tomorrow.millisecondsSinceEpoch;
    return tomorrowMidnightTimestamp;
  }

  String backWithName(int status) {
    var name = '';
    switch (status) {
      case 0 || 1:
        name = '去完成';
        break;
      case 2 || 4:
        name = '领取';
        break;
      case 3:
        name = '已完成';
        break;
      default:
        name = '未知';
        break;
    }
    return name;
  }

  Widget _buildNewcomersRuler(BuildContext context, String ruler) {
    return Container(
      decoration: BoxDecoration(
        color: context.customTheme?.pageTwoBg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.only(left: 30.w, right: 15.w, top: 15.w, bottom: 15.w),
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
      child: HtmlWidget(ruler, textStyle: TextStyle(color: context.customTheme?.titleColor))
    );
  }
  
  // 构建任务子项
  Widget _buildTabViewItem(BuildContext context) {
    return Obx(() {
      final taskItemData = controller.tabList[controller.tabCurrentIndex.value];
      bool isEmpty = controller.getIsEmpty(taskItemData);

      if (controller.isLoading.isTrue && isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      // 空的时候
      if (isEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            await controller.requestRefresh(); // 调用刷新数据的方法
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 300.h),
            child: Center(
              child: EmptyWidget(
                isShowLogin:
                    taskItemData.type! == ActivityConstants.ACTIVITY_TYPE_113 &&
                        !LoginManager.instance.isLogin.value,
              ),
            ),
          ),
        );
      }

      switch (taskItemData.type!.toInt()) {
        /// 充值大礼包
        case ActivityConstants.ACTIVITY_TYPE_101:
          return TaskPage101(
            taskItemData: taskItemData,
          );

        /// 天天得意金
        case ActivityConstants.ACTIVITY_TYPE_102:
          return TaskPage102(
            taskItemData: taskItemData,
          );

        /// 亏损救援金
        case ActivityConstants.ACTIVITY_TYPE_103:
          return TaskPage103(
            taskItemData: taskItemData,
          );

        /// 新增的 救援金活动
        case ActivityConstants.ACTIVITY_TYPE_203:
          return TaskPage203(
            taskItemData: taskItemData,
          );

        /// 分享领工资
        case ActivityConstants.ACTIVITY_TYPE_106:
          return TaskPage106(
            taskItemData: taskItemData,
          );

        /// 游戏任务
        case ActivityConstants.ACTIVITY_TYPE_110:
          return TaskPage110(
            taskItemData: taskItemData,
          );

        /// 虚拟币充值
        case ActivityConstants.ACTIVITY_TYPE_111:
          return TaskPage111(
            taskItemData: taskItemData,
          );

        /// 会员任务
        case ActivityConstants.ACTIVITY_TYPE_112:
          return TaskPage112(
            taskItemData: taskItemData,
          );

        /// 活动奖金
        case ActivityConstants.ACTIVITY_TYPE_113:
          return TaskPage113(
            taskItemData: taskItemData,
          );

        /// 日常任务
        case ActivityConstants.ACTIVITY_TYPE_204:
          return TaskPage204(
            taskItemData: controller.dailyTasks.value,
          );

        default:
          return const SizedBox();
      }
    });
  }
}
