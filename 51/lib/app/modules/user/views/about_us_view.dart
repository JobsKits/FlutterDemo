import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/CommonRipple.dart';
import '../controllers/about_us_controller.dart';

//关于我们页面
class AboutUsView extends GetView<AboutUsController> {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        title: Text("关于我们"),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(colorE9E9E9)))),
      padding: EdgeInsets.only(top: 117.h, left: 60.w, right: 60.w),
      alignment: Alignment.center,
      child: Column(
        children: [
          Image.network(
            controller.homeController.iconPath.value,
            width: 488.w,
            height: 118.h,
          ),
          SizedBox(height: 50.h),
          Obx(() => HtmlWidget(
                '${controller.desc}',
                textStyle: const TextStyle(color: Colors.black),
              )),
          _buildCustomService(),
          // _buildWhatApp(),
          // _buildTelegram()
        ],
      ),
    );
  }

  //官方客服
  Widget _buildCustomService() {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        if (TenantManager.instance.isCanOpenCustomerService) {
          Get.toNamed(Routes.CUSTOMER_SERVICE);
        } else {
          String? onlineAddr =
              TenantManager.instance.tenantBean?.tenant?.onlineAddr;
          if (onlineAddr != null) {
            String? type = TenantManager
                .instance.tenantBean?.sysOptions?.customerServiceSkipType;
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
      child: Container(
        margin: EdgeInsets.only(top: 80.h),
        height: 178.h,
        padding: EdgeInsets.symmetric(horizontal: 50.w),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // 阴影颜色
            spreadRadius: 2, // 阴影扩散范围
            blurRadius: 5, // 模糊半径
            offset: Offset(3, 3), // 阴影偏移量（x, y）
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
        child: Row(
          children: [
            Image.asset(
              Assets.theme1.images.user.iconCustomService.path,
              width: 112.w,
              height: 112.h,
            ),
            SizedBox(
              width: 40.w,
            ),
            Expanded(
              child: Text("官方在线客服", style: TextStyle(fontSize: 48.sp)),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(colorCECECE),
              size: 50.w,
            )
          ],
        ),
      ),
    );
  }

  //官方客服
  Widget _buildWhatApp(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      height: 178.h,
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1), // 阴影颜色
          spreadRadius: 2, // 阴影扩散范围
          blurRadius: 5, // 模糊半径
          offset: Offset(3, 3), // 阴影偏移量（x, y）
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
      child: Row(
        children: [
          Image.asset(
            Assets.theme1.images.user.iconWhatsapp.path,
            width: 112.w,
            height: 112.h,
          ),
          // Image.asset(
          //   Assets.theme1.images.user.iconTelegram.path,
          //   width: 112.w,
          //   height: 112.h,
          // )
          SizedBox(
            width: 40.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("官方Whatsapp",
                    style:
                        TextStyle(fontSize: 45.sp, color: Color(color4A4A4A))),
                Text("${TenantManager.instance.tenantBean?.tenant?.whatsApp}",
                    style: TextStyle(fontSize: 48.sp)),
              ],
            ),
          ),
          Container(
            width: 156.w,
            height: 68.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(56.r)),
            child: Text(
              "复制",
              style: TextStyle(fontSize: 36.sp, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  //官方飞机号
  Widget _buildTelegram(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      height: 178.h,
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1), // 阴影颜色
          spreadRadius: 2, // 阴影扩散范围
          blurRadius: 5, // 模糊半径
          offset: Offset(3, 3), // 阴影偏移量（x, y）
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
      child: Row(
        children: [
          Image.asset(
            Assets.theme1.images.user.iconTelegram.path,
            width: 112.w,
            height: 112.h,
          ),
          SizedBox(
            width: 40.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("官方Telegram",
                    style:
                        TextStyle(fontSize: 45.sp, color: Color(color4A4A4A))),
                Text("${TenantManager.instance.tenantBean?.tenant?.telegram}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 48.sp)),
              ],
            ),
          ),
          Container(
            width: 156.w,
            height: 68.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(56.r)),
            child: Text(
              "复制",
              style: TextStyle(fontSize: 36.sp, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
