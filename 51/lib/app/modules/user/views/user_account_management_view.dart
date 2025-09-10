import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../../../../constants/withdraw_constants.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../routes/app_pages.dart';
import '../controllers/user_account_management_controller.dart';

class UserAccountManagementView
    extends GetView<UserAccountManagementController> {
  const UserAccountManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(colorF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "账户管理",
          style: TextStyle(fontSize: 57.sp, color: Colors.black),
        ),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Obx(() => controller.tabList.isNotEmpty
              ? TabBar(
                  tabAlignment: TabAlignment.start,
                  padding: EdgeInsets.zero,
                  isScrollable: true,
                  onTap: (index) {
                    if (controller.currentTabIndex.value != index) {
                      AppManager.instance.tapVibrate();
                    }
                    controller.changeTabIndex(index);
                  },
                  dividerHeight: 0,
                  indicatorColor: context.theme.primaryColor,
                  labelColor: context.theme.primaryColor,
                  tabs: List.generate(controller.tabList.length, (index) {
                    return Tab(
                      text: controller.tabList[index].label,
                    );
                  }),
                  controller: controller.tabController,
                )
              : SizedBox()),
        ),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => controller.contentList.isNotEmpty
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.contentList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _buildListItem(context, index);
                      })
                  : _buildEmptyView()),
              Obx(() => controller.tabList.isNotEmpty
                  ? _buildButton(context,
                      title:
                          "+ 添加${controller.tabList[controller.currentTabIndex.value].label}账户",
                      clickButton: () {
                      AppManager.instance.tapVibrate();
                      Get.toNamed(Routes.RECHARGE_ADD_ADDRESS, arguments: {
                        "title":
                            "添加${controller.tabList[controller.currentTabIndex.value].label}地址",
                        "type": addressTypeMap[controller
                            .tabList[controller.currentTabIndex.value].payType
                            .toString()]
                      })?.then((isRefresh) {
                        controller.reqAccountBankList();
                      });
                    })
                  : SizedBox()),
              SizedBox(
                height: 100.h,
              )
            ],
          ),
        ))
      ],
    );
  }

  _buildEmptyView() {
    return Container(
      height: 100,
      child: Text("暂无绑定钱包"),
      alignment: Alignment.center,
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.only(top: 50.h, bottom: 30.h),
      margin: EdgeInsets.only(top: 20.h, left: 33.w, right: 33.w),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 47.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  controller.getIconPath(),
                  width: 102.w,
                  height: 102.h,
                ),
                SizedBox(
                  width: 40.w,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${controller.contentList[index].payOrgName}",
                      style: TextStyle(fontSize: 48.sp),
                    ),
                    Visibility(
                        visible:
                            controller.contentList[index].payName?.isNotEmpty ??
                                false,
                        child: Text(
                          "${controller.contentList[index].payName}",
                          style: TextStyle(fontSize: 36.sp),
                        )),
                    Row(
                      children: [
                        Obx(() => Text(
                              controller.contentList[index].isShowNum.value
                                  ? "${controller.contentList[index].payNo}"
                                  : "${controller.contentList[index].tempPayNo}",
                              style: TextStyle(fontSize: 42.sp),
                            )),
                        SizedBox(
                          width: 30.w,
                        ),
                        CommonRipple(
                          onTap: () {
                            AppManager.instance.tapVibrate();
                            controller.showOrHideAccount(index);
                          },
                          child: Obx(() => SvgPicture.asset(
                                controller.contentList[index].isShowNum.value
                                    ? Assets
                                        .theme1.images.login.iconInputEyeOpen
                                    : Assets
                                        .theme1.images.login.iconInputEyeClose,
                                width: 40.w,
                                height: 40.h,
                              )),
                        )
                      ],
                    )
                  ],
                )),
                SvgPicture.asset(
                  Assets.theme1.images.user.iconDelete,
                  width: 44.w,
                  height: 44.h,
                )
              ],
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          Divider(
            height: 1.h,
            color: Color(colorEAEAEA),
          ),
          SizedBox(
            height: 27.h,
          ),
          Padding(
              padding: EdgeInsets.only(left: 47.w, right: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("设为默认提现账户"),
                  Obx(() => SizedBox(
                      height: 58.h,
                      width: 112.w,
                      child: Transform.scale(
                        scale: 0.6, // 缩放比例，根据需要调整
                        child: Switch(
                          value: controller.contentList[index].sortV == 1,
                          activeTrackColor: context.theme.primaryColor,
                          activeColor: Colors.white,
                          onChanged: (value) {
                            controller.setDefaultValue(index);
                          },
                        ),
                      ))),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String title, VoidCallback? clickButton}) {
    return CommonRipple(
      onTap: clickButton,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 66.w, top: 126.h, right: 66.w),
        height: 125.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: context.theme.primaryColor,
            borderRadius: BorderRadius.circular(79.r)),
        child: Text(
          "${title}",
          style: TextStyle(color: Colors.white, fontSize: 52.sp),
        ),
      ),
    );
  }
}
