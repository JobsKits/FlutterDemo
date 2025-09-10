import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/agent_center_controller.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

//代理中心主界面
class AgentCenterView extends GetView<AgentCenterController> {
  const AgentCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(colorF4F4F4),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        title: Text("邀好友领现金"),
        centerTitle: true,
        bottom: TabBar(
            controller: controller.tabController,
            dividerHeight: 0,
            indicatorColor: context.theme.primaryColor,
            onTap: (index) {
              if (controller.currentIndex.value != index) {
                AppManager.instance.tapVibrate();
              }
              controller.changeIndex(index);
            },
            indicatorWeight: 1.h,
            unselectedLabelStyle:
                TextStyle(color: Color(colorAFAFAF), fontSize: 48.sp),
            labelStyle:
                TextStyle(fontSize: 54.sp, color: context.theme.primaryColor),
            tabs: List.generate(controller.tabList.length, (index) {
              return Tab(
                text: controller.tabList[index],
              );
            })),
      ),
      body: Obx(() => _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    Widget widget;
    switch (controller.currentIndex.value) {
      case 1:
        widget = _buildTeamView();
        break;
      case 2:
        widget = _buildSubordinateView();
        break;
      case 3:
        widget = _buildCommissionView();
        break;
      default:
        widget = _buildInviteView(context);
        break;
    }
    return widget;
  }

  //邀请界面
  Widget _buildInviteView(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 34.w),
          margin: EdgeInsets.only(top: 35.h),
          height: 515.h,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60.h,
              ),
              Text("邀请好友加入，即可获得丰厚奖励"),
              SizedBox(
                height: 32.h,
              ),
              Obx(() => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 260.w,
                        height: 260.h,
                        margin: EdgeInsets.only(
                            left: 106.w, right: 88.w, top: 20.h),
                        child: controller.friendBean.value != null
                            ? QrImageView(
                                data: controller
                                    .friendBean.value!.linkAddr!, // 链接数据
                                version: QrVersions.auto, // 自动生成最佳版本
                                size: 200.0, // 设置二维码的大小
                                gapless: false, // 设置二维码是否无缝连接
                              )
                            : SizedBox(),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "我的链接",
                            style: TextStyle(fontSize: 36.sp),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                            height: 90.h,
                            width: 536.w,
                            padding: EdgeInsets.only(left: 20.w, right: 37.w),
                            decoration: BoxDecoration(
                                color: Color(colorF4F4F4),
                                borderRadius: BorderRadius.circular(8.r)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: controller.friendBean.value != null
                                      ? Text(
                                          "${controller.friendBean.value!.linkAddr}",
                                          style: TextStyle(fontSize: 30.sp),
                                        )
                                      : SizedBox(),
                                ),
                                SvgPicture.asset(
                                  Assets.theme1.images.user.agent.iconInvite,
                                  width: 51.w,
                                  height: 51.h,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text("快速分享", style: TextStyle(fontSize: 30.sp)),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                Assets.theme1.images.user.agent.iconWechat.path,
                                width: 55.w,
                                height: 55.h,
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Image.asset(
                                Assets
                                    .theme1.images.user.agent.iconWechat2.path,
                                width: 55.w,
                                height: 55.h,
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Image.asset(
                                Assets.theme1.images.user.agent.iconWb.path,
                                width: 55.w,
                                height: 55.h,
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Image.asset(
                                Assets.theme1.images.user.agent.iconQq.path,
                                width: 55.w,
                                height: 55.h,
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Image.asset(
                                Assets.theme1.images.user.agent.iconQq2.path,
                                width: 55.w,
                                height: 55.h,
                              ),
                            ],
                          )
                        ],
                      ))
                    ],
                  ))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
          height: 306.h,
          padding: EdgeInsets.only(left: 64.w),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
          child: Obx(() => Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "历史总佣金：${controller.agentCommissionBean.value != null ? (controller.agentCommissionBean.value!.rebateSum! / 1000) : 0}",
                        style: TextStyle(fontSize: 45.sp),
                      ),
                      SizedBox(
                        height: 54.h,
                      ),
                      Text(
                          "可领取佣金：${controller.agentCommissionBean.value != null ? (controller.agentCommissionBean.value!.receiveRebate! / 1000) : 0}",
                          style: TextStyle(fontSize: 45.sp))
                    ],
                  )),
                  Visibility(
                      visible: controller.agentCommissionBean.value?.code != 1,
                      child: Container(
                        width: 252.w,
                        margin: EdgeInsets.only(right: 84.w),
                        height: 85.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            borderRadius: BorderRadius.circular(73.r)),
                        child: Text(
                          "立即领取",
                          style:
                              TextStyle(color: Colors.white, fontSize: 45.sp),
                        ),
                      ))
                ],
              )),
        ),
        SizedBox(
          height: 80.h,
        ),
        Image.asset(Assets.theme1.images.user.agent.agentCenterBg.path)
      ],
    );
  }

  //团队界面
  Widget _buildTeamView() {
    return Obx(() => controller.friendBean.value != null
        ? Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 110.h, left: 30.w, right: 30.w),
                height: 351.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r)),
                child: Column(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${controller.agentCommissionBean.value != null ? controller.agentCommissionBean.value!.rebateSum : 0}",
                              style: TextStyle(fontSize: 45.sp),
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            Text("历史总佣金", style: TextStyle(fontSize: 52.sp)),
                          ],
                        )),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "${controller.agentCommissionBean.value != null ? controller.agentCommissionBean.value!.rebate : 0}",
                                style: TextStyle(fontSize: 45.sp)),
                            SizedBox(
                              height: 40.h,
                            ),
                            Text("昨日总佣金", style: TextStyle(fontSize: 52.sp)),
                          ],
                        ))
                      ],
                    )),
                    Text("我的账号：${controller.friendBean.value!.partnerName}"),
                    SizedBox(
                      height: 37.h,
                    )
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 44.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r)),
                  height: 569.h,
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${controller.friendBean.value!.direc}",
                            style: TextStyle(fontSize: 45.sp),
                          ),
                          SizedBox(
                            height: 37.h,
                          ),
                          Text(
                            "直属下级人数",
                            style: TextStyle(fontSize: 45.sp),
                          ),
                          SizedBox(
                            height: 51.h,
                          ),
                          Text(
                            "${controller.friendBean.value!.custCount!.custCount}",
                            style: TextStyle(fontSize: 45.sp),
                          ),
                          SizedBox(
                            height: 37.h,
                          ),
                          Text(
                            "今日下级人数",
                            style: TextStyle(fontSize: 45.sp),
                          ),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${controller.friendBean.value!.count}",
                            style: TextStyle(fontSize: 45.sp),
                          ),
                          SizedBox(
                            height: 37.h,
                          ),
                          Text(
                            "团队成员人数",
                            style: TextStyle(fontSize: 45.sp),
                          ),
                          SizedBox(
                            height: 51.h,
                          ),
                          Text(
                            "${controller.friendBean.value!.newChargeCustCount!.newChargeCustCount}",
                            style: TextStyle(fontSize: 45.sp),
                          ),
                          SizedBox(
                            height: 37.h,
                          ),
                          Text(
                            "团队新增充值人数",
                            style: TextStyle(fontSize: 45.sp),
                          ),
                        ],
                      ))
                    ],
                  )),
            ],
          )
        : SizedBox());
  }

  //佣金界面
  Widget _buildCommissionView() {
    return Column(
      children: [
        SizedBox(
          height: 110.h,
        ),
        Row(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "966582.26",
                  style: TextStyle(fontSize: 45.sp),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Text("历史总佣金", style: TextStyle(fontSize: 52.sp)),
              ],
            )),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("966582.26", style: TextStyle(fontSize: 45.sp)),
                SizedBox(
                  height: 40.h,
                ),
                Text("昨日总佣金", style: TextStyle(fontSize: 52.sp)),
              ],
            ))
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 100.h, left: 30.w, right: 30.w),
          height: 967.h,
          padding: EdgeInsets.only(top: 80.h, left: 45.w, right: 45.w),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "佣金明细",
                style: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30.h,
              ),
              ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 80.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "2023-02-05",
                            style: TextStyle(fontSize: 36.sp),
                          ),
                          Text("-98123.03", style: TextStyle(fontSize: 36.sp)),
                        ],
                      ),
                    );
                  })
            ],
          ),
        )
      ],
    );
  }

  //下级界面
  Widget _buildSubordinateView() {
    return Container(
      margin: EdgeInsets.only(top: 34.h, left: 30.w, right: 30.w),
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(top: 20.h),
              padding: EdgeInsets.only(left: 33.w, right: 66.w),
              height: 219.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(colorF4F4F4),
                        radius: 59.w,
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Text("ttujh")
                    ],
                  ),
                  Text("历史佣金：123412.23")
                ],
              ),
            );
          }),
    );
  }
}
