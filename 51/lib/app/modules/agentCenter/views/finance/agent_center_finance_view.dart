import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../../utils/CommonRipple.dart';

class AgentCenterFinanceView extends StatelessWidget {
  const AgentCenterFinanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: null,
      body: SingleChildScrollView(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 45.w),
      child: Column(
        children: [
          _buildItemWidget(
            context,
            text: '游戏记录',
            img: Assets.theme1.images.agentCenter.iconGameRecord.path,
            onTap: () {
              AppManager.instance.tapVibrate();
              Get.toNamed(Routes.AGENT_CENTER_GAME_RECORD);
            },
          ),
          _buildItemWidget(
            context,
            text: '佣金报表',
            img: Assets.theme1.images.agentCenter.iconReport.path,
            onTap: () {
              AppManager.instance.tapVibrate();
              Get.toNamed(Routes.AGENT_CENTER_COMMISSION_REPORT);
            },
          ),
          _buildItemWidget(
            context,
            text: '提成记录',
            img: Assets.theme1.images.agentCenter.iconRecord.path,
            onTap: () {
              AppManager.instance.tapVibrate();
              Get.toNamed(Routes.AGENT_CENTER_COMMISSION_RECORD);
            },
          ),
          _buildItemWidget(
            context,
            text: '会员报表',
            img: Assets.theme1.images.agentCenter.iconMenber.path,
            onTap: () {
              AppManager.instance.tapVibrate();
              Get.toNamed(Routes.AGENT_CENTER_MEMBER_REPORT);
            },
          ),
          _buildItemWidget(
            context,
            text: '充值记录',
            img: Assets.theme1.images.agentCenter.iconRechrge.path,
            onTap: () {
              AppManager.instance.tapVibrate();
              Get.toNamed(Routes.AGENT_CENTER_RECHARGE_RECORD);
            },
          ),
          _buildItemWidget(
            context,
            text: '提现记录',
            img: Assets.theme1.images.agentCenter.iconWithdraw.path,
            onTap: () {
              AppManager.instance.tapVibrate();
              Get.toNamed(Routes.AGENT_CENTER_WITHDRAW_RECORD);
            },
          ),
          _buildItemWidget(
            context,
            text: '我的业绩',
            img: Assets.theme1.images.agentCenter.iconPerfor.path,
            onTap: () {
              AppManager.instance.tapVibrate();
              Get.toNamed(Routes.AGENT_CENTER_PROFIT_RECORD);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemWidget(
    BuildContext context, {
    required String text,
    VoidCallback? onTap,
    String? img,
  }) {
    return CommonRipple(
      onTap: onTap,
      child: Container(
        height: 150.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: context.customTheme?.pageTwoBg,
        ),
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        margin: EdgeInsets.only(top: 40.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (ThemeService.to.currentTheme.value?.model == 'blackGold') ...[
              Image.asset(
                img ?? '',
                width: 68.w,
                height: 68.h,
                fit: BoxFit.cover,
              ),
            ],
            const SizedBox(width: 5, height: double.infinity),
            Text(
              text,
              style: TextStyle(
                fontSize: 45.sp,
                color: context.customTheme?.titleColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              Assets.theme1.images.common.iconArrowRight,
              width: 24.w,
              color: context.customTheme?.arrowColor,
            )
          ],
        ),
      ),
    );
  }
}
