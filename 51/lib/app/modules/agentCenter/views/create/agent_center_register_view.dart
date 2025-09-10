import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
// import 'package:webview_flutter/webview_flutter.dart';

import '../../controllers/agent_center_register_controller.dart';

import '../../../activity/widget/common_input_widget.dart';
import '../../../activity/widget/common_receive_button.dart';

import 'package:flutter_tiyu_app/app/modules/webview/widget/common_dialog.dart';
import '../../widget/dropdown_select.dart';

// 代理中心
class AgentCenterRegisterView extends GetView<AgentCenterRegisterController> {
  const AgentCenterRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        title: Text(
          controller.pageTitle.value,
          style: TextStyle(
              fontSize: 57.sp, color: context.customTheme?.appbarText),
        ),
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
      ),
      body: Obx(() => _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 33.w, vertical: 40.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildBodyForm(context), Obx(() => _buildSubmitBtn())],
        ),
      ),
    );
  }

  Widget _buildBodyForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r), // 圆角
        border: Border.all(
            color: context.customTheme?.lineColor ?? Colors.white,
            width: 0.5.w),
        color: context.customTheme?.pageTwoBg,
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabelWidget(
            context,
            '会员账号',
            iconPath: Assets.theme1.images.agentCenter.iconUsername,
            large: true,
          ),
          CommonInputWidget(
            margin: EdgeInsets.only(top: 30.h, bottom: 60.h),
            placeholder: "以字母开头，6-12位字符",
            maxLength: 12,
            textInputType: TextInputType.text,
            color: context.customTheme?.input2Color,
            onChanged: (str) {
              controller.setChangeValue(str, ChangeTypeEnum.custName);
            },
            inputWidgetType: InputWidgetTypeEnum.customeType,
          ),
          // -----------
          _buildLabelWidget(
            context,
            '登录密码',
            iconPath: Assets.theme1.images.agentCenter.iconPassword,
          ),
          CommonInputWidget(
            margin: EdgeInsets.only(top: 30.h, bottom: 60.h),
            placeholder: "必须在6-16个字符之间",
            isShowPwd: true,
            maxLength: 16,
            textInputType: TextInputType.visiblePassword,
            color: context.customTheme?.input2Color,
            onChanged: (str) {
              controller.setChangeValue(str, ChangeTypeEnum.password);
            },
            inputWidgetType: InputWidgetTypeEnum.pwdInputType,
          ),
          _buildLabelWidget(context, '会员类型'),
          DropdownSelect(
            currentValue: controller.partnerFlag.value,
            options: controller.selectOption,
            onChanged: (val) {
              controller.changePartnerFlag(val ?? '');
            },
          ),
          // -----------
          // _buildLabelWidget(
          //   '确认密码',
          //   iconPath: Assets.theme1.images.agentCenter.iconPassword,
          // ),
          // CommonInputWidget(
          //   margin: EdgeInsets.only(top: 30.h, bottom: 60.h),
          //   placeholder: "必须在6-16个字符之间",
          //   isShowPwd: true,
          //   maxLength: 16,
          //   textInputType: TextInputType.visiblePassword,
          //   color: const Color(colorF4F4F4),
          //   onChanged: (str) {
          //     controller.setChangeValue(str, ChangeTypeEnum.repassword);
          //   },
          //   inputWidgetType: InputWidgetTypeEnum.pwdInputType,
          // ),
          // -----------
          // _buildLabelWidget('同级配额总数', required: true),
          // CommonInputWidget(
          //   margin: EdgeInsets.only(top: 30.h, bottom: 60.h),
          //   placeholder: "必填",
          //   maxLength: 16,
          //   textInputType: TextInputType.number,
          //   color: const Color(colorF4F4F4),
          //   onChanged: (str) {
          //     controller.setChangeValue(str, ChangeTypeEnum.peerQuota);
          //   },
          //   inputWidgetType: InputWidgetTypeEnum.customeType,
          // ),
          // -----------
          // _buildLabelWidget('下级配额总数', required: true),
          // CommonInputWidget(
          //   margin: EdgeInsets.only(top: 30.h, bottom: 60.h),
          //   placeholder: "必填",
          //   maxLength: 16,
          //   textInputType: TextInputType.number,
          //   color: const Color(colorF4F4F4),
          //   onChanged: (str) {
          //     controller.setChangeValue(str, ChangeTypeEnum.lowerQuota);
          //   },
          //   inputWidgetType: InputWidgetTypeEnum.customeType,
          // ),

          _errorTipsText(),

          // -----------
          _buildLabelWidget(context, '权限设置', required: false),
          SizedBox(height: 10.h),
          ...List.generate(controller.checklist.length, (index) {
            var itemData = controller.checklist[index];

            if (!itemData['show']) {
              return const SizedBox();
            }

            return Container(
              height: 80.h,
              margin: EdgeInsets.symmetric(
                vertical: 10.h,
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: controller.checked[index],
                    onChanged: (bool? value) {
                      controller.setChecked(value, index);
                    },
                    activeColor: controller.checked[index]
                        ? const Color(colorFF1919)
                        : context.customTheme?.titleColor,
                  ),
                  Expanded(
                    child: Text(
                      itemData['name']!,
                      style: TextStyle(
                        fontSize: 42.sp,
                        color: controller.checked[index]
                            ? const Color(colorFF1919)
                            : context.customTheme?.titleColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          })
        ],
      ),
    );
  }

  // 校验失败的提示信息
  Widget _errorTipsText() {
    return Obx(() {
      final errorText = controller.verifyErrorTips.value;
      if (errorText.isEmpty) return const SizedBox();
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(errorText,
                style: TextStyle(fontSize: 38.sp, color: Colors.red)),
          ),
          SizedBox(height: 32.h),
        ],
      );
    });
  }

  Widget _buildLabelWidget(
    BuildContext context,
    String title, {
    String? iconPath,
    bool? large,
    bool? required,
  }) {
    bool isLarge = large == true;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 20.w),
        Visibility(
          visible: iconPath != null && iconPath.isNotEmpty,
          child: Padding(
            padding: EdgeInsets.only(right: 10.w, top: isLarge ? 10.h : 0),
            child: SvgPicture.asset(
              iconPath ?? '',
              width: isLarge ? 50.w : 38.w,
              height: isLarge ? 50.h : 38.h,
              colorFilter: ColorFilter.mode(
                  context.customTheme?.titleColor ?? Colors.black,
                  BlendMode.srcIn),
            ),
          ),
        ),
        Visibility(
          visible: required == true,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            height: 45.h,
            child: Center(
              child: Text(
                '*',
                style: TextStyle(
                  fontSize: 45.sp,
                  color: const Color(colorFF1919),
                ),
              ),
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 45.sp,
            color: context.customTheme?.titleColor,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        )
      ],
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
      margin: EdgeInsets.only(top: 100.h, bottom: 60.h),
      child: CommonReceiveButton(
        title: '确认',
        // loading: controller.isLoading.value,
        disabled: !controller.isCanRegister.value,
        // onTap: controller.handleRegister,
        onTap: () {
          Get.dialog(Obx(
            () => CommonDialog(
              title: controller.computedTitle(),
              isLoading: controller.isLoading.value,
              clickOk: () async {
                AppManager.instance.tapVibrate();
                await controller.handleRegister();
              },
            ),
          ));
        },
      ),
    );
  }
}
