import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/task_newcomers_model/datum.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/task_newcomers_model/task_newcomers_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_button.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_count_timer.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';

class ActivityNewcoersSigninDialog extends StatefulWidget {
  final TaskNewcomersModel? newcoersModel;

  const ActivityNewcoersSigninDialog({super.key, this.newcoersModel});

  @override
  _ActivityNewcoersSigninDialogState createState() =>
      _ActivityNewcoersSigninDialogState();
}

class _ActivityNewcoersSigninDialogState
    extends State<ActivityNewcoersSigninDialog>
    with SingleTickerProviderStateMixin {
  NewHomeController homeController = Get.find();
  RxBool isReceiveLoading = false.obs; // 领取奖励loading
  RxInt balance = 0.obs;

  @override
  void initState() {
    super.initState();
    balance.value = widget.newcoersModel?.t!.received ?? 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> reqNewcomersTaskReceive(Datum model) async {
    EasyLoading.show();
    isReceiveLoading.value = true;

    try {
      final res = await ActivityApi.reqActivityReceive(model.receiveLogId);
      if (res.type == NetworkService.networkTypeSuccess &&
          res.data['response_code'] == '9999') {
        EasyLoading.showSuccess("领取成功");
        setState(() {
          balance.value =
              balance.value + int.parse(model.rewardAmount.toString());
          model.status = 3;
        });
      }
    } finally {
      EasyLoading.dismiss();
      isReceiveLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.transparent.withOpacity(0),
            ),
          ),
          Align(
            // 使用 Align 包裹 Positioned
            alignment: Alignment.center, // 居中
            child: Column(
              mainAxisSize: MainAxisSize.min, // 使 Column 仅占用所需空间
              children: [
                Container(
                  width: 0.9.sw,
                  height: 0.575.sh,
                  padding: EdgeInsets.symmetric(vertical: 15.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, // 从上到下渐变
                      end: Alignment.bottomCenter,
                      colors: ThemeService.to.currentTheme.value?.model == 'blue' ||
                        ThemeService.to.currentTheme.value?.model == 'gold3'
                        ? [
                            context.theme.primaryColor, // 顶部黑色（透明度 0.2）
                            Colors.white, // 底部白色
                          ]
                        : [
                            Color(0xff444756), // 顶部黑色（透明度 0.2）
                            context.customTheme?.dialogBgColor ?? Colors.transparent, // 底部白色
                          ],
                      stops: const [0.0, 0.2], // 调整渐变范围（0.0~0.3 是黑色到白色，之后纯白）
                    ),
                  ),
                  alignment: Alignment.center,
                  child: _buildLeaderboard(context),
                ),
                SizedBox(height: 25),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: context.theme.cardColor.withOpacity(.9),
                    borderRadius: BorderRadius.circular(12.5),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.close_sharp,
                    color: Color(0xffCECECE),
                    size: 15,
                  ),
                ).onTap(() {
                  Get.back();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30.h),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '新人大礼包',
                    style: TextStyle(
                      fontSize: 73.sp,
                      fontWeight: FontWeight.bold,
                      color: ThemeService.to.currentTheme.value?.model == 'blackGold' ? context.theme.primaryColor : Colors.black
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style:
                          DefaultTextStyle.of(context).style, // 继承默认文本样式（如字体）
                      children: <TextSpan>[
                        TextSpan(
                          text: '888元 ', // 左边灰色文字
                          style: TextStyle(
                              fontSize: 73.sp,
                              fontWeight: FontWeight.bold,
                              color: ThemeService.to.currentTheme.value?.model == 'blackGold' ? context.theme.primaryColor : Colors.red),
                        ),
                        TextSpan(
                          text: '免费送', // 右边黑色文字
                          style: TextStyle(
                              fontSize: 67.sp,
                              fontWeight: FontWeight.bold,
                              color: context.theme.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          Spacer(),
          Image.asset(
            ThemeService.to.currentTheme.value?.model == 'blackGold'
              ? Assets.theme1.images.home.homeNewcomersRightBlackgold.path
              : Assets.theme1.images.home.homeNewcomersRight.path,
            width: 380.w,
            fit: BoxFit.contain,
          ),
        ],
      ),
      Obx(
        () => Container(
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
          margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: context.theme.primaryColor,
            borderRadius: BorderRadius.circular(12.5),
          ),
          child: Row(
            children: [
              Image.asset(
                Assets.theme1.images.home.homeNewcomersMoney.path,
                width: 50.w,
                fit: BoxFit.contain,
              ),
              Text(
                ' 已获得总奖金:', // 右边黑色文字
                style: TextStyle(
                    fontSize: 39.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
              Spacer(),
              Text(
                '${(double.parse((balance.value).toString()) / 1000).truncateToFixed(2)}元 ', // 左边灰色文字
                style: TextStyle(
                    fontSize: 39.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.5),
        ),
        child: Text(
          '完成以下任务即可获取相应金额的奖金,总奖金高达888元! 奖金将自动发放至您的钱包！', // 左边灰色文字
          style: TextStyle(fontSize: 39.sp, color: ThemeService.to.currentTheme.value?.model == 'blackGold' ? context.customTheme?.title2Color : Color(0xff638993)),
        ),
      ),
      Expanded(
        child: Container(
          margin: EdgeInsets.only(bottom: 30.h), // 底部外边距
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...widget.newcoersModel!.data!.map(
                  (data) => _buildNewcomersItem(context, data),
                ),
              ],
            ),
          ),
        )
      ),
    ]);
  }

  Widget _buildNewcomersItem(BuildContext context, Datum model) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeService.to.currentTheme.value?.model == 'blackGold' ? context.customTheme?.inputBgColor :Color(0xffECF9FC),
        borderRadius: BorderRadius.circular(12),
      ),
      padding:
          EdgeInsets.only(left: 30.w, right: 15.w, top: 15.w, bottom: 15.w),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: context.customTheme?.pageTwoBg,
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: BoxConstraints(minWidth: 120.w),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${((model.rewardAmount ?? 0) / 1000).toStringAsFixed(2)}元',
                  style: TextStyle(
                    color: ThemeService.to.currentTheme.value?.model == 'blackGold' ? context.theme.primaryColor : Colors.red,
                    fontSize: 36.sp,
                  ),
                ),
                Text(
                  '奖励',
                  style: TextStyle(
                    color: context.customTheme?.title2Color,
                    fontSize: 27.sp,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 15.h),

          // Task name
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.taskName ?? '',
                    style: TextStyle(
                      color: context.customTheme?.titleColor,
                      fontSize: 45.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (model.status == 4) ...{
                    Container(
                        width: 200.w,
                        child: ActivityCountTimer(
                          startTime: DateTime.now().millisecondsSinceEpoch,
                          endTime: getTomorrowTimestamp(),
                          timeFormat: false,
                          fontSize: 39.sp,
                          fontColor: Color(0xffAFAFAF),
                        ))
                  }
                ],
              ),
            ),
          ),

          Container(
            constraints: BoxConstraints(maxWidth: 180.w),
            child: _buildActionButton(model),
          ),
        ],
      ),
    );
  }

  int getTomorrowTimestamp() {
    DateTime now = DateTime.now();
    DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
    int tomorrowMidnightTimestamp = tomorrow.millisecondsSinceEpoch;
    return tomorrowMidnightTimestamp;
  }

  Widget _buildActionButton(Datum model) {
    final isCompleted = model.status == 3;
    final canReceive = model.status == 2;
    final canPerform = model.status == 1;

    if (isCompleted) {
      return CommonButton(
          title: "已完成",
          color: Colors.white,
          bgColor: const Color(0xffE3E4E4),
          type: CommonButtonTypeEnum.Primary);
    }

    return CommonButton(
      title: canReceive ? "领取" : backWithName(model.status ?? 0),
      bgColor: model.status == 3
          ? const Color(0xffE3E4E4)
          : model.status == 4
              ? const Color(0xffC7CBD3)
              : const Color(theme01MainColor),
      type: model.status == 3 || model.status == 4
          ? CommonButtonTypeEnum.Primary
          : CommonButtonTypeEnum.LinearGradient,
      onTap: () {
        if (canPerform) {
          _handleTaskAction(model);
        } else if (canReceive) {
          reqNewcomersTaskReceive(model);
        }
      },
      loading: isReceiveLoading.value,
      loadingAnimation: false,
    );
  }

  void _handleTaskAction(Datum model) {
    Get.back();
    switch (model.taskCode) {
      case '1':
        showRegisterDialog();
        break;
      case '2':
        Future.delayed(Duration(milliseconds: 100), () {
          Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT,
              arguments: {"tabIndex": 1});
        });
        // Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT, arguments: {"tabIndex": 1});
        break;
      case '3':
        Future.delayed(Duration(milliseconds: 100), () {
          Get.toNamed(Routes.USER_INFO, arguments: {"isShowSendCode": true, "isShowBirthday": true});
        });
        break;
      case '4':
        Future.delayed(Duration(milliseconds: 100), () {
          Get.toNamed(Routes.EDIT_PASSWORD, arguments: {"isLoginPwd": false});
        });
        break;
      case '5':
        // homeController.pushToActivity('利息宝');
        var isOpenVideo =
            TenantManager.instance.tenantBean?.isOpenVideo == 'true';
        homeController.tabsController.jumpToPage(isOpenVideo ? 3 : 2);
        final signInIndex =
            homeController.activityController.activityData.indexWhere(
          (activity) => activity.title == '利息宝',
        );
        Future.delayed(Duration(milliseconds: 100), () {
          homeController.activityController.jumpToPage(signInIndex);
        });
        break;
      case '6':
        Get.toNamed(Routes.CHANGE_AVATAR);
        break;
      case '7':
        Future.delayed(Duration(milliseconds: 100), () {
          Get.toNamed(Routes.USER_INFO, arguments: {
            "isShowSendCode": true,
            "isShowBindPhoneDialog": true
          });
        });
        break;
      case '8':
        var isOpenVideo =
            TenantManager.instance.tenantBean?.isOpenVideo == 'true';
        homeController.tabsController.jumpToPage(isOpenVideo ? 2 : 1);
        break;
      case '9':
        if (model.status == 0 || model.status == 1) {
          var isOpenVideo =
              TenantManager.instance.tenantBean?.isOpenVideo == 'true';
          homeController.tabsController.jumpToPage(isOpenVideo ? 2 : 1);
        } else {
          showLoginDialog();
        }
        break;
      case '10':
        Future.delayed(Duration(milliseconds: 100), () {
          Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT);
        });
        break;
      case '11':
        Future.delayed(Duration(milliseconds: 100), () {
          Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT);
        });
        break;
      case '12':
        Future.delayed(Duration(milliseconds: 100), () {
          Get.toNamed(Routes.NEW_RECHARGE_WITHDRAWAL,
              arguments: {"isBand": true});
        });
        break;
      case '13':
        if (model.status == 0 || model.status == 1) {
          var isOpenVideo = TenantManager.instance.tenantBean?.isOpenVideo == 'true';
          homeController.tabsController.jumpToPage(isOpenVideo ? 2 : 1);
        } else {
          showLoginDialog();
        }
        break;
      default:
        break;
    }
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
}
