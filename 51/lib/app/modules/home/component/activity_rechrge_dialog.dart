import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_bean.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';

class ActivityRechrgeDialog extends StatefulWidget {
  final ActivityListItemBean? model;
  final VoidCallback? onPress;
  final VoidCallback? requestBag;
  final VoidCallback? onClose;
  final ImageProvider? imageProvider;

  const ActivityRechrgeDialog({
    super.key,
    this.model,
    this.onPress,
    this.requestBag,
    this.onClose,
    this.imageProvider,
  });

  @override
  _ActivityRechrgeDialogState createState() => _ActivityRechrgeDialogState();
}

class _ActivityRechrgeDialogState extends State<ActivityRechrgeDialog>
    with SingleTickerProviderStateMixin {
  final NewHomeController homeController = Get.find();
  RxList allLossRewards = [].obs;

  RxBool isToday = false.obs;
  RxBool isNotDisplay = false.obs;

  RxString popupContent = ''.obs;

  @override
  void initState() {
    super.initState();
    final config = jsonDecode(widget.model?.actionCfg ?? '');
    popupContent.value = config['popupContent'] ?? '';
    if (config['rewardSetting'] is List) {
      allLossRewards.value = config['rewardSetting'];
      print('allLossRewards: ${allLossRewards}');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void isTodayDisplay(bool? isCheck) {
    isToday.value = isCheck ?? !isToday.value;
    if (LoginManager.instance.isLogin.value) {
      saveToday("${'local'}rechargeLoginToday", isToday.value);
    } else {
      saveToday("${'local'}rechargeToday", isToday.value);
    }
  }

  void iseveryNotDisplay(bool? isCheck) {
    isNotDisplay.value = isCheck ?? !isNotDisplay.value;
    if (LoginManager.instance.isLogin.value) {
      saveInfo("{'local'}rechargeLoginNaver", isNotDisplay.value);
    } else {
      saveInfo("${'local'}rechargeNaver", isNotDisplay.value);
    }
  }

  void saveToday(String saveName, bool value) async {
    if (value) {
      int timestampSeconds = DateTime.now().millisecondsSinceEpoch;
      await SpUtil.saveInt(saveName, timestampSeconds);
    } else {
      await SpUtil.saveInt(saveName, 0);
    }
  }

  void saveInfo(String saveName, bool value) async {
    await SpUtil.saveBool(saveName, value);
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
                Obx(() => Container(
                      width: 0.9.sw,
                      height: 0.625.sh,
                      decoration: BoxDecoration(
                        color: context.customTheme?.dialogBgColor,
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                      alignment: Alignment.center,
                      child: _buildLeaderboard(context),
                    )),
                SizedBox(height: 25),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: context.customTheme?.dialogXColor,
                    borderRadius: BorderRadius.circular(12.5),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.close_sharp,
                    color: Colors.red,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            widget.model?.activityName ?? '',
            style: TextStyle(
              fontSize: 42.sp,
              color: context.customTheme?.titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 40.h),
        if (popupContent.value.isEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '首次充值',
                style: TextStyle(
                  color: context.customTheme?.titleColor,
                  fontSize: 33.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '奖励金额',
                style: TextStyle(
                  color: context.customTheme?.titleColor,
                  fontSize: 33.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          SizedBox(
            height: 0.5.sh,
            child: ListView.builder(
              itemCount: allLossRewards.length,
              itemBuilder: (context, index) {
                final item = allLossRewards[index];
                Color c1 = context.customTheme?.inputBgColor ?? Colors.black;
                if (index % 2 == 1) {
                  c1 = context.customTheme?.dialogBgColor ?? Colors.black;
                }
                String rank =
                    (int.parse(item['rechargeAmount'].toString()) / 1000)
                        .truncateToFixed(0);
                String account = '0.0';

                final config = jsonDecode(widget.model?.actionCfg ?? '');
                if (config['bonusMethod'] == '1') {
                  account = (int.parse(item['rewardAmount'].toString()) / 1000)
                      .truncateToFixed(2);
                } else {
                  account =
                      '${(double.parse(item['rewardAmount'].toString()) * 100).truncateToFixed(1)}%';
                }

                return Container(
                  height: 80.h,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: c1,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '≥${rank}',
                        style: TextStyle(
                          color: context.customTheme?.titleColor,
                          fontSize: 33.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        account,
                        style: TextStyle(
                          color: context.customTheme?.titleColor,
                          fontSize: 33.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ] else ...[
          SizedBox(
            height: 0.475.sh,
            child: SingleChildScrollView(
              child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Image(
                    image: widget.imageProvider!,
                    fit: BoxFit.cover,
                  )
                  // child: Image(
                  //   image: widget.imageProvider,
                  //   fit: BoxFit.cover,
                  // ),
                  ),
            ),
          ),
        ],
        const Spacer(),
        _buildBottom(context)
      ],
    );
  }

  Widget _buildBottom(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          top: 30.h,
          left: 40.w,
          right: 40.w,
          bottom: 30.h,
        ),
        decoration: BoxDecoration(
          color: context.customTheme?.dialogBgColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 48.w, // 设置宽度
                      height: 48.h, // 设置高度
                      child: Transform.scale(
                        scale: 0.8,
                        child: Obx(() => Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5), // 圆形
                              ),
                              value: isToday.value,
                              onChanged: (bool? value) {
                                isTodayDisplay(value);
                              },
                              activeColor: context.theme.primaryColor, // 选中颜色
                              checkColor: Colors.white, // 选中时的勾选颜色
                              side: const BorderSide(
                                  color: Colors.grey), // 未选中时的边框颜色
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    CommonRipple(
                      onTap: () => {},
                      child: Text(
                        '今天不再提示',
                        style: TextStyle(
                            fontSize: 38.sp, color: const Color(color99999)),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    SizedBox(
                      width: 48.w, // 设置宽度
                      height: 48.h, // 设置高度
                      child: Transform.scale(
                          scale: 0.8,
                          child: Obx(() => Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5), // 圆形
                                ),
                                value: isNotDisplay.value,
                                onChanged: (bool? value) {
                                  iseveryNotDisplay(value);
                                },
                                activeColor: context.theme.primaryColor, // 选中颜色
                                checkColor: Colors.white, // 选中时的勾选颜色
                                side: const BorderSide(
                                    color: Colors.grey), // 未选中时的边框颜色
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ))
                          // Obx(() => Checkbox(
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(24), // 圆形
                          //   ),
                          //   value: false,
                          //   onChanged: (bool? value) {
                          //     // controller.isCheckRememberPwd(value);
                          //   },
                          //   activeColor:
                          //       const Color(theme01MainColor), // 选中颜色
                          //   checkColor: Colors.white, // 选中时的勾选颜色
                          //   side: const BorderSide(
                          //       color: Colors.grey), // 未选中时的边框颜色
                          //   materialTapTargetSize:
                          //       MaterialTapTargetSize.shrinkWrap,
                          // )),
                          ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    CommonRipple(
                      onTap: () => {},
                      child: Text(
                        '永不提示',
                        style: TextStyle(
                            fontSize: 38.sp, color: const Color(color99999)),
                      ),
                    )
                  ],
                ),
              ],
            ),
            _buildReceiveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiveButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.theme.primaryColor.withOpacity(0.75),
            context.theme.primaryColor,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: context.theme.primaryColor.withOpacity(0.75),
            offset: Offset(0, 12.h),
            blurRadius: 21.h,
          ),
        ],
        borderRadius: BorderRadius.circular(20.h),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: 120.w,
            vertical: 20.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.h),
          ),
        ),
        onPressed: () async {
          AppManager.instance.tapVibrate();
          Get.back();
          var isOpenVideo =
              TenantManager.instance.tenantBean?.isOpenVideo == 'true';
          homeController.tabsController.jumpToPage(isOpenVideo ? 2 : 1);
        },
        child: Text(
          '前往',
          style: TextStyle(
            fontSize: 54.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
