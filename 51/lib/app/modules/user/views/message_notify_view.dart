import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';
import '../controllers/message_notify_controller.dart';

//消息通知页面
class MessageNotifyView extends GetView<MessageNotifyController> {
  const MessageNotifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(colorF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text("消息通知"),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 32.h),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(103.r)),
            child: TabBar(
                labelStyle: TextStyle(fontSize: 48.sp, color: Colors.white),
                unselectedLabelStyle:
                    TextStyle(fontSize: 48.sp, color: Color(color7E7E7E)),
                dividerHeight: 0,
                controller: controller.tabController,
                indicator: BoxDecoration(
                  color: Colors.blue, // 指示器颜色
                  borderRadius: BorderRadius.circular(103.r), // 圆角), // 边框
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: List.generate(controller.tabList.length, (index) {
                  return Tab(
                    text: controller.tabList[index],
                  );
                })),
          ),
          Expanded(child: _buildListContent()),
        ],
      ),
    );
  }

  Widget _buildListContent() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        Widget itemView;
        if (index % 2 == 0) {
          itemView = _buildImgItem();
        } else {
          itemView = _buildTextItem();
        }
        return itemView;
      },
      itemCount: 5,
    );
  }

  Widget _buildTextItem() {
    return CommonRipple(
        onTap: () {
          AppManager.instance.tapVibrate();
          Get.toNamed(Routes.MESSAGE_DETAIL, arguments: {"isImgType": false});
        },
        child: Container(
          margin: EdgeInsets.only(top: 35.h),
          padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 48.w),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "消息主标题文案",
                style: TextStyle(fontSize: 54.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 23.h,
              ),
              Text(
                  "全网最高信誉，从演示站开始！作为国际专业的网上博 彩游戏运营商，我们承诺，为每一位客户提供最安全、 最公平的博彩娱乐，以及全方位的服务……",
                  style: TextStyle(fontSize: 39.sp)),
              SizedBox(
                height: 27.h,
              ),
              Text("2023-08-18", style: TextStyle(fontSize: 34.sp)),
            ],
          ),
        ));
  }

  Widget _buildImgItem() {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        Get.toNamed(Routes.MESSAGE_DETAIL, arguments: {"isImgType": true});
      },
      child: Container(
          margin: EdgeInsets.only(top: 35.h),
          padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 48.w),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "消息主标题文案",
                style: TextStyle(fontSize: 54.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 31.h,
              ),
              Container(
                color: Colors.black26,
                height: 476.h,
              ),
              SizedBox(
                height: 27.h,
              ),
              Text("2023-08-18", style: TextStyle(fontSize: 34.sp)),
            ],
          )),
    );
  }
}
