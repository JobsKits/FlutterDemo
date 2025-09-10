import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/modules/login/controllers/login_dialog_controller.dart';
import 'package:flutter_tiyu_app/app/modules/login/views/login_content_widget.dart';
import 'package:flutter_tiyu_app/app/modules/login/views/night_register_content_widget.dart';
import 'package:flutter_tiyu_app/app/modules/login/views/register_content_widget.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../controllers/night_login_dialog_controller.dart';
import 'night_login_content_widget.dart';

///登录弹窗
class NightLoginDialog extends StatefulWidget {
  const NightLoginDialog({super.key, required this.isShowLogin, this.callback});
  final bool isShowLogin; //是否显示登录，true:登录 false:注册
  final VoidCallback? callback;

  @override
  State<NightLoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<NightLoginDialog> {
  late NightLoginDialogController controller;
  NewHomeController homeController = Get.find();
  bool isSelectLogin = true;
  @override
  void initState() {
    super.initState();
    isSelectLogin = widget.isShowLogin;
    controller = Get.put(NightLoginDialogController());
    controller.isSelectLogin.value = widget.isShowLogin;
  }

  @override
  void dispose() {
    Get.delete<NightLoginDialogController>();
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
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
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

  Widget _buildTab(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 40.w),
      child: Row(
        children: [
          GestureDetector(
            child: Container(
                width: 160.w,
                alignment: Alignment.center,
                height: 72.h,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: isSelectLogin
                      ? context.theme.primaryColor
                      : Color(0xff33374A),
                ),
                child: Text("登录",
                    style: TextStyle(
                        fontSize: 42.sp,
                        color: isSelectLogin
                            ? context.customTheme?.rechargeMoneyColor
                            : Color(0xffD7DAEB)))),
            onTap: () {
              AppManager.instance.tapVibrate();
              changeSelectStatus(true);
            },
          ),
          SizedBox(
            width: 20.w,
          ),
          GestureDetector(
            child: Container(
                width: 160.w,
                alignment: Alignment.center,
                height: 72.h,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: isSelectLogin
                      ? Color(0xff33374A)
                      : context.theme.primaryColor,
                ),
                child: Text("注册",
                    style: TextStyle(
                        fontSize: 42.sp,
                        color: isSelectLogin
                            ? Color(0xffD7DAEB)
                            : context.customTheme?.rechargeMoneyColor))),
            onTap: () {
              AppManager.instance.tapVibrate();
              changeSelectStatus(false);
            },
          ),
        ],
      ),
    );
  }

  //构建title
  Widget _buildTitle(BuildContext context) {
    return Container(
      height: 140.h,
      padding: EdgeInsets.only(left: 10.w, right: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => homeController.iconPath.value.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: homeController.iconPath.value,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    width: 588.w,
                    height: 100.h,
                  )
                : const SizedBox.shrink(),
          ),
          GestureDetector(
            onTap: () {
              AppManager.instance.tapVibrate();
              Get.back();
              LoginManager.instance.isLoginDialogShowing = false;
            },
            child: Icon(
              Icons.close,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.only(top: 50.h),
      decoration: BoxDecoration(
        color: context.customTheme?.pageBg,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Column(
        children: [
          _buildTab(context),
          isSelectLogin
              ? NightLoginContentWidget(
                  callback: widget.callback,
                )
              : NightRegisterContentWidget(
                  callback: widget.callback,
                )
        ],
      ),
    );
  }

  Widget _buildTitleButton(
      String text, int pageIndex, bool isSelected, bool isLogin) {
    return Expanded(
      child: GestureDetector(
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

  void changeSelectStatus(bool isSelect) {
    if (isSelect == isSelectLogin) {
      return;
    }
    setState(() {
      isSelectLogin = isSelect;
    });
  }
}
