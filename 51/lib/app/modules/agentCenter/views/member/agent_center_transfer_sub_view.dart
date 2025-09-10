import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/member/agent_transfer_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/member/common_tips_dialog.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
// import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';
// import 'package:webview_flutter/webview_flutter.dart';

import '../../controllers/agent_center_transfer_sub_controller.dart';

import '../../../activity/widget/common_input_widget.dart';
import '../../../activity/widget/common_receive_button.dart';

// import 'package:flutter_tiyu_app/app/modules/webview/widget/common_dialog.dart';
// import '../../widget/sub_account_widget.dart';

// 转账下级
class AgentCenterTransferSubView
    extends GetView<AgentCenterTransferSubController> {
  const AgentCenterTransferSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        title: Text(
          "转账下级",
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
      // body: _buildBody(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 33.w, vertical: 40.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildBodyForm(context), Obx(() => _buildSubmitBtn(context))],
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: _buildLabelWidget(
                    context,
                    '最多可转出',
                    large: true,
                  )),
              Expanded(
                  flex: 3,
                  child: CommonInputWidget(
                    margin: EdgeInsets.only(left: 20.w),
                    placeholder: "请输入金额",
                    maxLength: 20,
                    textInputType: TextInputType.text,
                    color: context.customTheme?.inputBgColor,
                    defaultContent: LoginManager.instance.balanceStr.value,
                    readOnly: true,
                    readOnlyColor: context.customTheme?.inputBgColor,
                    inputWidgetType: InputWidgetTypeEnum.customeType,
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildLabelWidget(context, '转入会员ID'),
              ),
              Expanded(
                flex: 3,
                child: Obx(() => CommonInputWidget(
                  minValue: 0,
                  margin: EdgeInsets.only(left: 20.w, top: 30.h),
                  readOnly: false,
                  outsideFocus: controller.userIdFocusNode,
                  defaultContent: controller.defaultUserId.value,
                  textInputType: TextInputType.number,
                  inputWidgetType: InputWidgetTypeEnum.customeType,
                  onChanged: (value) => controller.setUserId(value),
                  placeholder: '请输入下级会员ID',
                  color: const Color(colorF6F6F6),
                )),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.h, left: 20.w),
            child: Row(
              children: [
                const Spacer(
                  flex: 1,
                ),
                Expanded(
                    flex: 3,
                    child: Text(
                      '会员姓名: ${controller.username.value}',
                      style: TextStyle(
                        fontSize: 30.sp,
                        color: context.customTheme?.title2Color,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ))
              ],
            ),
          ),
          Row(
            children: [
              Expanded(flex: 1, child: _buildLabelWidget(context, '代存金额')),
              Expanded(
                  flex: 3,
                  child: CommonInputWidget(
                    margin: EdgeInsets.only(left: 20.w, top: 30.h),
                    placeholder: "请输入转入金额",
                    maxLength: 16,
                    textInputType: TextInputType.number,
                    color: context.customTheme?.inputBgColor,
                    onChanged: (str) {
                      controller.setChangeValue(str, ChangeTypeEnum.amount);
                    },
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(flex: 1, child: _buildLabelWidget(context, '确认金额')),
              Expanded(
                  flex: 3,
                  child: CommonInputWidget(
                    margin: EdgeInsets.only(left: 20.w, top: 30.h),
                    placeholder: "请输入确认转账金额",
                    maxLength: 16,
                    isShowPwd: false,
                    textInputType: TextInputType.number,
                    color: const Color(colorF4F4F4),
                    onChanged: (str) {
                      controller.setChangeValue(str, ChangeTypeEnum.comfAmount);
                    },
                  )),
            ],
          ),
          // -----------
          // Row(
          //   children: [
          //     Expanded(
          //       flex: 1,
          //       child: _buildLabelWidget('要求打码量'),
          //     ),
          //     Expanded(
          //       flex: 3,
          //       child: CommonInputWidget(
          //         margin: EdgeInsets.only(left: 20.w, top: 30.h),
          //         placeholder: "请输入打码量",
          //         maxLength: 16,
          //         readOnly: true,
          //         readOnlyColor: const Color(colorF6F6F6),
          //         defaultContent: controller.codeVolume.value,
          //         textInputType: TextInputType.number,
          //         color: const Color(colorF4F4F4),
          //         onChanged: (str) {
          //           // controller.setChangeValue(str, ChangeTypeEnum.codeVolume);
          //         },
          //       ),
          //     )
          //   ],
          // ),
          // -----------
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildLabelWidget(context, '转账密码'),
              ),
              Expanded(
                flex: 3,
                child: CommonInputWidget(
                  margin: EdgeInsets.only(left: 20.w, top: 30.h),
                  placeholder: "请输入转账密码",
                  maxLength: 16,
                  isShowPwd: true,
                  textInputType: TextInputType.text,
                  color: context.customTheme?.inputBgColor,
                  onChanged: (str) {
                    controller.setChangeValue(str, ChangeTypeEnum.password);
                  },
                  inputWidgetType: InputWidgetTypeEnum.pwdInputType,
                ),
              )
            ],
          ),
          // -----------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(top: 60.h),
                  child: _buildLabelWidget(context, '备注'),
                ),
              ),
              Expanded(
                flex: 3,
                child: CommonInputWidget(
                  margin: EdgeInsets.only(left: 20.w, top: 30.h),
                  placeholder: "请输入备注(非必填)",
                  textInputType: TextInputType.multiline,
                  maxLines: 6,
                  color: context.customTheme?.inputBgColor,
                  onChanged: (str) {
                    controller.setChangeValue(str, ChangeTypeEnum.remark);
                  },
                  maxLength: 100,
                ),
              )
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
          // _errorTipsText(),
          // -----------
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
              colorFilter:
                  const ColorFilter.mode(Colors.black, BlendMode.srcIn),
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
        Expanded(
            child: Text(
          title,
          maxLines: 1,
          style: TextStyle(
            fontSize: 45.sp,
            color: context.customTheme?.title2Color,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ))
      ],
    );
  }

  Widget _buildSubmitBtn(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100.h, bottom: 60.h),
      child: CommonReceiveButton(
        title: '提交转账',
        loading: controller.isLoading.value,
        disabled: !controller.isCanOpt.value,
        // onTap: controller.handleRegister,
        onTap: () {
          controller.isReq.value = true;
          Future.delayed(const Duration(microseconds: 250), () {
            controller.isReq.value = false;
          });
          if (!controller.isCanOpt.value) return;
          if (controller.userId.value.isEmpty) return;
          if (controller.amount.value != controller.comfAmount.value) {
            Get.dialog(
              const CommonTipsDialog(
                tips: '请保证转入金额和确认金额保持一致',
              ),
              barrierDismissible: false,
            );
            return;
          }

          // if (controller.username.value.isEmpty) {
          //   controller.onUserIdFocusChange();
          //   return;
          // }

          Get.dialog(
            AgentTransferDialog(
              username: controller.username.value,
              userid: controller.userId.value,
              amount: controller.amount.value,
              remark: controller.remark.value,
              onPress: () => controller.handleTransfer(),
            ),
            barrierDismissible: false,
          );
        },
      ),
    );
  }
}
