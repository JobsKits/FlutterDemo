import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../utils/CommonRipple.dart';
import '../controllers/change_avatar_controller.dart';

class ChangeAvatarView extends StatefulWidget {
  const ChangeAvatarView({super.key});

  @override
  State<ChangeAvatarView> createState() => _ChangeAvatarViewState();
}

class _ChangeAvatarViewState extends State<ChangeAvatarView> {
  ChangeAvatarController controller = Get.put(ChangeAvatarController());
  @override
  void dispose() {
    Get.delete<ChangeAvatarController>();
    super.dispose();
  }

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
        actions: [
          CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              //保存头像，返回前一个页面
              controller.setHeader();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
              child: Text(
                "保存",
                style: TextStyle(
                    fontSize: 39.sp, color: context.customTheme?.appbarText),
              ),
            ),
          )
        ],
        title: Text("修改头像",
            style: TextStyle(color: context.customTheme?.appbarText)),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 200.h, left: 33.w, right: 33.w),
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => CircleAvatar(
                backgroundColor: Colors.black26,
                radius: 132.w,
                backgroundImage:
                    NetworkImage(controller.currentHeaderUrl.value),
              )),
          SizedBox(
            height: 200.h,
          ),
          Expanded(
            child: _buildHeaderList(context),
          )
        ],
      ),
    );
  }

  Widget _buildHeaderList(BuildContext context) {
    return Obx(() => controller.headerList.isNotEmpty
        ? GridView.builder(
            itemCount: controller.headerList.length,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            itemBuilder: (context, index) {
              return CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  controller.changeHeaderUrl(index);
                },
                child: SizedBox(
                  height: 264.h,
                  child: CachedNetworkImage(
                      imageUrl:
                          "${controller.listImgDomain}/${controller.headerList[index]}"),
                ),
              );
            })
        : Center(
            child: SizedBox(
              width: 100.w,
              height: 100.h,
              child: LoadingIndicator(
                indicatorType: Indicator.ballSpinFadeLoader,
                colors: [context.theme.primaryColor],
              ),
            ),
          ));
  }
}
