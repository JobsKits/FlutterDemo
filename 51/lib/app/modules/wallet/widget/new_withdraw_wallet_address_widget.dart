import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity_detail_view.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_rich_title_widget.dart';
// import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';
import '../controllers/new_withdrawal_controller.dart';
import '../data/withdraw_type_new_bean2.dart';
import './dashed_border_container_widget.dart';

/// 提现地址
// ignore: must_be_immutable
class NewWithdrawWalletAddressWidget extends StatefulWidget {
  final VoidCallback? onTap;
  const NewWithdrawWalletAddressWidget({
    super.key,
    this.onTap,
  }); // 默认值处理

  @override
  State<NewWithdrawWalletAddressWidget> createState() =>
      _WithdrawWalletAddressWidget();
}

class _WithdrawWalletAddressWidget
    extends State<NewWithdrawWalletAddressWidget> {
  final NewWithdrawalController controller = Get.find();
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    ever(controller.currentSelectItemIndex, (index) {
      _scrollToSelectedItem(index);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RechargeRichTitleWidget(fontSize: 45.sp, str: "收款钱包"),
          SizedBox(height: 26.h),
          Obx(() => controller.bindList.isEmpty
              ? DashedBorderContainerWidget(
                  strokeWidth: 3.w,
                  color: context.customTheme!.rechargeSecondTypeBgColor!,
                  child: CommonRipple(
                    onTap: () {
                      if (widget.onTap != null) {
                        widget.onTap!();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 134.h,
                      child: Text(
                        _getWalletTextName(),
                        style: TextStyle(
                            fontSize: 45.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                context.customTheme?.rechargeSecondTypeBgColor),
                      ),
                    ),
                  ),
                )
              : _buildWalletWidget()),
        ],
      ),
    );
  }

  String _getWalletTextName() {
    return '＋ 添加${controller.tabList.isNotEmpty ? controller.tabList[controller.currentTabIndex.value].title : ""}账号';
  }

  void _scrollToSelectedItem(int index) {
    // 每个item的宽度
    double itemWidth = 800.w;
    // 每个item的右侧边距
    double itemSpacing = 26.w;
    // 计算滚动位置，使选中的item滑动到屏幕中心
    double offset = (itemWidth + itemSpacing) * index -
        MediaQuery.of(context).size.width / 2 +
        itemWidth / 2;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 滚动到选中的位置
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  /// 构建钱包容器
  Widget _buildWalletWidget() {
    print(
        "查询条件：${controller.bindList.isEmpty}   ${controller.currentSelectItem.value == null}");
    // 没有钱包
    // if (controller.bindList.isEmpty &&
    //     controller.currentSelectItem.value == null) {
    //   return ;
    // }

    return SizedBox(
      height: 327.h,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Obx(() => ListView.builder(
                itemCount: controller.bindList.length,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String imgUrl;
                  if (controller.tabList[controller.currentTabIndex.value]
                          .rechargeTypeId ==
                      3) {
                    imgUrl =
                        '${GameUtils.getWithdrawIcon(id: controller.bindList[index].cut!)}';
                  } else {
                    imgUrl = controller.getRechargeTypeIcon(
                        payOrgId: controller.bindList[index].payOrgId ?? 0);
                  }
                  WithdrawTypeNewBean2? bean;
                  var tempList = controller
                          .tabList[controller.currentTabIndex.value].data ??
                      [];
                  bean = tempList.firstWhereOrNull((item) =>
                      item.payOrgId == controller.bindList[index].payOrgId);
                  var tempIconUrl = bean?.icon_url ?? "";
                  if (tempIconUrl.isNotEmpty) {
                    imgUrl = tempIconUrl;
                  }
                  bool isNetWork = imgUrl.contains("http");
                  return CommonRipple(
                    onTap: () {
                      if (controller.currentSelectItemIndex.value != index) {
                        AppManager.instance.tapVibrate();
                      }
                      controller.changeSelectItemIndex(index);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 26.w),
                      width: 800.w,
                      padding: EdgeInsets.only(left: 60.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36.r),
                        color: context.customTheme?.pageTwoBg,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36.r),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                isNetWork
                                    ? Image.network(
                                        width: 113.w,
                                        height: 113.w,
                                        imgUrl,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            width: 113.w,
                                            height: 113.w,
                                            Assets.theme1.images.home.errorImg
                                                .path,
                                            fit: BoxFit.cover, // 根据需要调整 fit 属性
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        width: 113.w,
                                        height: 113.w,
                                        imgUrl,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            width: 113.w,
                                            height: 113.w,
                                            Assets.theme1.images.home.errorImg
                                                .path,
                                            fit: BoxFit.cover, // 根据需要调整 fit 属性
                                          );
                                        },
                                      ),
                                //
                                // Image.asset(
                                //   '${controller.getRechargeTypeIcon(payOrgId: controller.bindList[index].payOrgId!.toInt())}',
                                //   width: 113.w,
                                //   height: 113.w,
                                //   errorBuilder: (context, error, stackTrace) {
                                //     return Image.asset(
                                //       '${controller.getRechargeTypeIcon(payOrgId: controller.bindList[index].payOrgId!.toInt())}',
                                //       width: 113.w,
                                //       height: 113.w,
                                //     ); // 错误图像
                                //   },
                                // ),
                                SizedBox(
                                  width: 30.w,
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      controller
                                              .bindList[index]?.pay_org_name ??
                                          '',
                                      style: TextStyle(
                                        fontSize: 45.sp,
                                        color: context.customTheme?.titleColor,
                                      ),
                                    ),
                                    Text(
                                      maskCardNumber(
                                          controller.bindList[index]?.pay_no ??
                                              ''),
                                      style: TextStyle(
                                        fontSize: 45.sp,
                                        color: context.customTheme?.titleColor,
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                            Obx(() => Visibility(
                                visible:
                                    controller.currentSelectItemIndex.value ==
                                        index,
                                child: Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Image.asset(
                                    Assets
                                        .theme1.images.recharge.iconSelect.path,
                                    width: 100.w,
                                    height: 100.h,
                                    color: context.theme.primaryColor,
                                  ),
                                )))
                          ],
                        ),
                      ),
                    ),
                  );
                })),
            CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                var realIndex = controller.noPayInfo != null
                    ? controller.currentTabIndex.value - 1
                    : controller.currentTabIndex.value;
                Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT,
                    arguments: {"tabIndex": realIndex})?.then((_) {
                  controller.reqDefaultBankCard(
                      defaultIndex: controller.currentTabIndex.value);
                });
              },
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                    color: Color(colorE6E6E6),
                    borderRadius: BorderRadius.circular(36.r)),
                child: Icon(Icons.add),
                width: 138.w,
              ),
            )
          ],
        ),
      ),
    );
  }
}
