import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/login/controllers/login_dialog_controller.dart';
import 'package:flutter_tiyu_app/app/modules/login/views/login_content_widget.dart';
import 'package:flutter_tiyu_app/app/modules/login/views/register_content_widget.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';

///登录弹窗
class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key, required this.isShowLogin, this.callback});
  final bool isShowLogin; //是否显示登录，true:登录 false:注册
  final VoidCallback? callback;

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  late LoginDialogController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(LoginDialogController());
    controller.isSelectLogin.value = widget.isShowLogin;
  }

  @override
  void dispose() {
    Get.delete<LoginDialogController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 55.w),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildContent(context),
                SizedBox(
                  height: 40.h,
                ),
                CommonRipple(
                  //弹窗的关闭按钮
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back(); // 关闭弹窗
                    LoginManager.instance.isLoginDialogShowing = false;
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 45.w,
                    child: SvgPicture.asset(
                      Assets.theme1.images.home.iconDialogClose,
                      width: 39.w,
                      height: 39.h,
                      colorFilter:
                          const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(56.r),
        color: context.customTheme?.navbarBg,
      ),
      child: Column(
        children: [
          _buildTitle(context), //弹窗顶部标题：登录、注册
          _buildBody(context), //底部内容

          // LoginContentWidget()
        ],
      ),
    );
  }

  //构建title
  Widget _buildTitle(BuildContext context) {
    return SizedBox(
      height: 140.h,
      child: Obx(() => Row(
            children: [
              _buildTitleButton("登录", 0, controller.isSelectLogin.value, true),
              _buildTitleButton(
                  "注册", 1, !controller.isSelectLogin.value, false),
            ],
          )),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(
      () => controller.isSelectLogin.value
          ? LoginContentWidget(
              callback: widget.callback,
            )
          : RegisterContentWidget(
              callback: widget.callback,
            ),
    );
  }

  Widget _buildTitleButton(
      String text, int pageIndex, bool isSelected, bool isLogin) {
    return Expanded(
      child: CommonRipple(
        onTap: () {
          AppManager.instance.tapVibrate();
          controller.changePage(pageIndex);
        },
        child: Container(
          alignment: Alignment.center,
          height: double.infinity,
          decoration: isLogin
              ? (isSelected
                  ? null
                  : BoxDecoration(
                      color: context.customTheme?.pageTwoBg,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ))
              : (isSelected
                  ? null
                  : BoxDecoration(
                      color: context.customTheme?.pageTwoBg,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    )),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 56.sp,
              color: isSelected
                  ? context.theme.primaryColor
                  : const Color(color8A8A8A),
            ),
          ),
        ),
      ),
    );
  }
}
