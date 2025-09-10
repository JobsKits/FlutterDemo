import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../routes/app_pages.dart';
import '../../settings/views/settings_withdrawal_pwd_dialog.dart';
import '../../wallet/data/withdraw_type_new_bean2.dart';
import '../controllers/new_user_account_management_controller.dart';

class NewUserAccountManagementView extends StatefulWidget {
  const NewUserAccountManagementView({super.key});

  @override
  State<NewUserAccountManagementView> createState() =>
      _NewUserAccountManagementViewState();
}

class _NewUserAccountManagementViewState
    extends State<NewUserAccountManagementView> {
  late NewUserAccountManagementController controller =
      Get.put(NewUserAccountManagementController());
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<NewUserAccountManagementController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        title: Text(
          "账户管理",
          style: TextStyle(color: context.customTheme?.appbarText),
        ),
        centerTitle: true,
        leading: BackButton(
          color: context.customTheme?.appbarText,
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  //内容主体
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() => _buildWithdrawTypeTab()),
          SizedBox(
            height: 32.h,
          ),
          Column(
            children: [
              Obx(() => controller.contentList.isNotEmpty
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.contentList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _buildListItem(index);
                      })
                  : _buildEmptyView()),
              Obx(() => controller.tabList.isNotEmpty
                  ? _buildButton(
                      title:
                          "+ 添加${controller.tabList[controller.currentTabIndex.value].title}账号",
                      clickButton: () async{
                        AppManager.instance.tapVibrate();
                        if (LoginManager.instance.checkIsFrozen()) {
                          return;
                        }
                        if (controller.hasPwd) {
                          Get.toNamed(Routes.RECHARGE_ADD_ADDRESS, arguments: {
                            "title":
                                "添加${controller.tabList[controller.currentTabIndex.value].title}地址",
                            "payType": controller
                                .tabList[controller.currentTabIndex.value]
                                .rechargeTypeId,
                          })?.then((isRefresh) {
                            if (isRefresh) {
                              controller.reqDefaultBankCard(
                                  isRefresh: isRefresh ?? false);
                            }
                          });
                        } else {
                          // Get.toNamed(Routes.EDIT_PASSWORD,
                          //     arguments: {"isLoginPwd": false})?.then((_) {
                          //   controller.checkPwdStatus();
                          // });
                          await Get.dialog(SettingsWithdrawalPwdDialog());
                         controller. checkPwdStatus();
                        }
                      })
                  : const SizedBox()),
              SizedBox(
                height: 100.h,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawTypeTab() {
    if (controller.tabList.isEmpty) {
      return const SizedBox();
    }
    return Container(
      height: 94.h,
      padding: EdgeInsets.only(left: 40.w),
      color: context.customTheme?.pageTwoBg,
      child: TabBar(
        onTap: (index) {
          if (controller.currentTabIndex.value != index) {
            AppManager.instance.tapVibrate();
          }
          controller.changeTabIndex(index);
        },
        tabAlignment: controller.tabList.length < 5 ? null : TabAlignment.start,
        isScrollable: controller.tabList.length < 5 ? false : true,
        labelPadding: EdgeInsets.only(right: 50.w),
        labelStyle:
            TextStyle(color: context.theme.primaryColor, fontSize: 51.sp),
        indicatorColor: context.theme.primaryColor,
        unselectedLabelStyle:
            TextStyle(color: const Color(color4B4B4B), fontSize: 42.sp),
        dividerHeight: 1.h,
        controller: controller.tabController,
        tabs: List.generate(controller.tabList.length, (index) {
          return Tab(
            text: controller.tabList[index].title,
          );
        }),
      ),
    );
  }

  Widget _buildListItem(int index) {
    String imgUrl;
    if (controller.tabList[controller.currentTabIndex.value].rechargeTypeId ==
        3) {
      imgUrl =
          '${GameUtils.getWithdrawIcon(id: controller.contentList[index].cut!)}';
    } else {
      imgUrl = controller.getRechargeTypeIcon(
          payOrgId: controller.contentList[index].payOrgId ?? 0);
    }
    WithdrawTypeNewBean2? bean;
    var tempList =
        controller.tabList[controller.currentTabIndex.value].data ?? [];
    bean = tempList.firstWhereOrNull(
        (item) => item.payOrgId == controller.contentList[index].payOrgId);
    var tempIconUrl = bean?.icon_url ?? "";
    if (tempIconUrl.isNotEmpty) {
      imgUrl = tempIconUrl;
    }
    bool isNetWork = imgUrl.contains("http");
    return Container(
      padding: EdgeInsets.only(top: 50.h, bottom: 30.h),
      margin: EdgeInsets.only(top: 20.h, left: 33.w, right: 33.w),
      decoration: BoxDecoration(
          color: context.customTheme?.pageTwoBg,
          borderRadius: BorderRadius.circular(30.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 47.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isNetWork
                    ? Image.network(
                        width: 102.w,
                        height: 102.w,
                        imgUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            width: 102.w,
                            height: 102.w,
                            Assets.theme1.images.home.errorImg.path,
                            fit: BoxFit.cover, // 根据需要调整 fit 属性
                          );
                        },
                      )
                    : Image.asset(
                        controller.tabList[controller.currentTabIndex.value]
                                    .rechargeTypeId ==
                                3
                            ? GameUtils.getAccountManageIcon(id: 10086)
                            : GameUtils.getAccountManageIcon(
                                id: controller.contentList[index].payOrgId!),
                        width: 102.w,
                        height: 102.h,
                        errorBuilder: (context, error, stackTrace) {
                          var errorPath = "";
                          switch (controller
                              .tabList[controller.currentTabIndex.value]
                              .rechargeTypeId) {
                            case 1:
                              break;
                            case 2:
                              errorPath =
                                  GameUtils.getAccountManageIcon(id: 172);
                              break;
                            case 3:
                              errorPath =
                                  GameUtils.getAccountManageIcon(id: 10086);
                              break;
                            case 4:
                              errorPath = GameUtils.getAccountManageIcon(id: 7);
                              break;
                          }
                          return Image.asset(
                            width: 102.w,
                            height: 102.h,
                            errorPath,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                SizedBox(
                  width: 40.w,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${controller.contentList[index].pay_org_name}",
                      style: TextStyle(
                          fontSize: 48.sp,
                          color: context.customTheme?.titleColor),
                    ),
                    Visibility(
                        visible: controller
                                .contentList[index].pay_name?.isNotEmpty ??
                            false,
                        child: Text(
                          "${controller.contentList[index].pay_name}",
                          style: TextStyle(
                              fontSize: 36.sp,
                              color: context.customTheme?.titleColor),
                        )),
                    Row(
                      children: [
                        Obx(() => Text(
                              controller.contentList[index].isShowNum.value
                                  ? "${controller.contentList[index].pay_no}"
                                  : "${controller.contentList[index].tempPayNo}",
                              style: TextStyle(
                                  fontSize: 42.sp,
                                  color: context.customTheme?.titleColor),
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
                // SvgPicture.asset(
                //   Assets.theme1.images.user.iconDelete,
                //   width: 44.w,
                //   height: 44.h,
                // )
              ],
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          Divider(
            height: 1.h,
            color: context.customTheme?.lineColor,
          ),
          SizedBox(
            height: 27.h,
          ),
          Padding(
              padding: EdgeInsets.only(left: 47.w, right: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "设为默认提现账户",
                    style: TextStyle(color: context.customTheme?.titleColor),
                  ),
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
                            AppManager.instance.tapVibrate();
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

  Widget _buildButton({required String title, VoidCallback? clickButton}) {
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

  _buildEmptyView() {
    return Obx(() => Container(
          height: 100,
          alignment: Alignment.center,
          child: Text(
              controller.tabList.isNotEmpty
                  ? "暂无绑定${controller.tabList[controller.currentTabIndex.value].title}"
                  : "暂无绑定钱包",
              style: TextStyle(color: context.customTheme?.titleColor)),
        ));
  }
}
