import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_input_widget.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_receive_button.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../../utils/tenant_manager.dart';
import '../controllers/edit_password_controller.dart';

// 修改密码页面
class EditPasswordView extends GetView<EditPasswordController> {
  const EditPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        leading: BackButton(
          color: context.customTheme?.appbarText,
          onPressed: () {
            Get.back();
          },
        ),
        title: Obx(() => Text(controller.title.value,
            style: TextStyle(color: context.customTheme?.appbarText))),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 30.w),
            child: CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                if (TenantManager.instance.isCanOpenCustomerService) {
                  Get.toNamed(Routes.CUSTOMER_SERVICE);
                } else {
                  String? onlineAddr =
                      TenantManager.instance.tenantBean?.tenant?.onlineAddr;
                  if (onlineAddr != null) {
                    String? type = TenantManager.instance.tenantBean?.sysOptions
                        ?.customerServiceSkipType;
                    if (type == '1') {
                      launchUrl(Uri.parse(onlineAddr),
                          mode: LaunchMode.externalApplication);
                    } else {
                      Get.toNamed(Routes.WEB_VIEW_INAPP, arguments: {
                        "url": onlineAddr, //请求地址
                        "title": "在线客服",
                      });
                    }
                  }
                }
              },
              child: SvgPicture.asset(
                Assets.theme1.images.login.iconLoginCustom,
                width: 66.w,
                height: 66.h,
                colorFilter: ColorFilter.mode(
                    context.customTheme?.appbarText ?? Colors.white,
                    BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() => _buildBody(context)),
    );
  }

  Widget _buildLabelWidget(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 45.sp,
        color: context.customTheme?.title2Color,
        fontWeight: FontWeight.w500,
        height: 1,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    bool isLoginMode = controller.isLoginPwd.value;
    return IntrinsicHeight(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36.r),
          color: context.customTheme?.pageTwoBg,
        ),
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 60.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Visibility(
                visible: controller.hasPwd.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelWidget(context, '原密码'),
                    CommonInputWidget(
                      margin: EdgeInsets.only(top: 30.h, bottom: 60.h),
                      placeholder:
                          controller.isLoginPwd.value ? "请输入原登录密码" : "请输入原支付密码",
                      isShowPwd: true,
                      maxLength: 16, //原密码可能是登录密码，不需要做6位数限制
                      textInputType: TextInputType.visiblePassword,
                      defaultContent: controller.oldPwd.value,
                      color: context.customTheme?.inputBgColor,
                      onChanged: (str) => controller.setOldPwd(str),
                      inputWidgetType: InputWidgetTypeEnum.pwdInputType,
                    ),
                  ],
                ))),
            _buildLabelWidget(
                context,
                controller.hasPwd.value
                    ? '新密码'
                    : (isLoginMode ? "登录密码" : "支付密码")),
            CommonInputWidget(
              margin: EdgeInsets.only(top: 30.h, bottom: 60.h),
              placeholder: controller.isLoginPwd.value
                  ? (controller.hasPwd.value ? "请输入新密码" : "请输入登录密码")
                  : (controller.hasPwd.value ? "请输入新密码" : "请输入支付密码"),
              isShowPwd: true,
              maxLength: isLoginMode ? 16 : 6,
              textInputType: isLoginMode
                  ? TextInputType.visiblePassword
                  : TextInputType.number,
              defaultContent: controller.userPwd.value,
              color: context.customTheme?.inputBgColor,
              onChanged: (str) => controller.setUserPwd(str),
              inputWidgetType: InputWidgetTypeEnum.pwdInputType,
            ),
            _buildLabelWidget(context, '确认密码'),
            CommonInputWidget(
              margin: EdgeInsets.only(top: 30.h, bottom: 30.h),
              placeholder: controller.isLoginPwd.value ? "请输入确认密码" : "请输入确认密码",
              isShowPwd: true,
              maxLength: isLoginMode ? 16 : 6,
              textInputType: isLoginMode
                  ? TextInputType.visiblePassword
                  : TextInputType.number,
              defaultContent: controller.userConfirmPwd.value,
              color: context.customTheme?.inputBgColor,
              onChanged: (str) => controller.setConfirmPwd(str),
              inputWidgetType: InputWidgetTypeEnum.pwdInputType,
            ),
            _errorTipsText(),
            SizedBox(height: 30.h),
            CommonReceiveButton(
              title: '提交',
              loading: controller.isLoading.value,
              onTap: () async {
                DebounceThrottle.debounce(() => controller.handleSubmit())();
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  //登录校验失败的提示信息
  Widget _errorTipsText() {
    return Obx(() {
      final errorText = controller.verifyErrorTips.value;
      if (errorText.isEmpty) return const SizedBox();
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Icon(
                  Icons.error,
                  size: 50.w,
                  color: const Color(colorE01509),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                errorText,
                style: TextStyle(
                  fontSize: 42.sp,
                  color: const Color(colorE01509),
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
        ],
      );
    });
  }
}
