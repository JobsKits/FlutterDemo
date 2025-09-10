import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_common_container.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_ok_button_widget.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_rich_title_widget.dart';
// import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../controllers/withdrawal_controller.dart';
import '../data/withdraw_type_bean.dart';
import './dashed_border_container_widget.dart';

/// 提现地址
// ignore: must_be_immutable
class WithdrawWalletAddressWidget extends StatefulWidget {
  final String? name; // 账户
  final int? payType; // 类型
  final String? icon; // 图标
  final WithdrawBindCardItemBean? defaultBindCard; // 默认账户
  final List<WithdrawBindCardItemBean>? withdrawBindCardList; // 提现绑定卡列表
  final VoidCallback? onTap;

  WithdrawWalletAddressWidget({
    super.key,
    this.name,
    this.payType,
    this.icon,
    this.onTap,
    this.defaultBindCard,
    List<WithdrawBindCardItemBean>? withdrawBindCardList,
  }) : withdrawBindCardList = withdrawBindCardList ?? []; // 默认值处理

  @override
  State<WithdrawWalletAddressWidget> createState() =>
      _WithdrawWalletAddressWidget();
}

class _WithdrawWalletAddressWidget extends State<WithdrawWalletAddressWidget> {
  final WithdrawalController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return RechargeCommonContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RechargeRichTitleWidget(fontSize: 45.sp, str: "收款钱包"),
        SizedBox(height: 40.h),
        Obx(() => _buildWalletWidget()),
      ],
    ));
  }

  String _getWalletTextName() {
    return '＋ 添加收款${widget.name}账号';
  }

  /// 构建钱包容器
  Widget _buildWalletWidget() {
    // 没有钱包
    if (widget.withdrawBindCardList!.isEmpty &&
        widget.defaultBindCard == null) {
      return DashedBorderContainerWidget(
        strokeWidth: 3.w,
        color: Colors.black,
        child: GestureDetector(
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
              style: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Image.asset(
          '${widget.icon}',
          width: 113.w,
          height: 113.w,
        ),
        SizedBox(
          width: 30.w,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.defaultBindCard!.payOrgName ?? '',
              style: TextStyle(
                fontSize: 45.sp,
                color: const Color(color313131),
              ),
            ),
            Text(
              maskCardNumber(widget.defaultBindCard!.payNo ?? ''),
              style: TextStyle(
                fontSize: 45.sp,
                color: const Color(color313131),
              ),
            ),
          ],
        )),
        GestureDetector(
          onTap: () {
            AppManager.instance.tapVibrate();
            _showSelectPop();
          },
          child: Container(
            width: 202.w,
            decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(73.r)),
            height: 85.h,
            alignment: Alignment.center,
            child: Text(
              "更换",
              style: TextStyle(color: Colors.white, fontSize: 45.sp),
            ),
          ),
        )
      ],
    );
  }

  //显示选择虚拟币的弹窗
  void _showSelectPop() {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.r), topRight: Radius.circular(50.r)),
        child: Container(
          height: 0.5.sh,
          color: const Color(colorF4F4F4),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(right: 40.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.r),
                      topRight: Radius.circular(50.r)),
                ),
                height: 130.h,
                child: Row(
                  children: [
                    Expanded(
                      child: Text("选择${widget.name}账户",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 52.sp,
                              color: const Color(color2D2D2D))),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        Get.back();
                      },
                      child: const Icon(Icons.close),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.withdrawBindCardList!.length,
                        itemBuilder: (context, index) {
                          WithdrawBindCardItemBean? cardItem =
                              widget.withdrawBindCardList![index];

                          return Container(
                            height: 205.h,
                            padding: EdgeInsets.symmetric(horizontal: 50.w),
                            margin: EdgeInsets.only(
                                top: 20.h, left: 30.w, right: 30.w),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.r)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      '${widget.icon}',
                                      width: 103.w,
                                      height: 103.w,
                                    ),
                                    SizedBox(
                                      width: 32.w,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${cardItem.payOrgName}",
                                          style: TextStyle(
                                            fontSize: 45.sp,
                                            color: const Color(color313131),
                                          ),
                                        ),
                                        Text(
                                          maskCardNumber(cardItem.payNo ?? ''),
                                          style: TextStyle(
                                            fontSize: 45.sp,
                                            color: const Color(color313131),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 82.w, // 设置宽度
                                  height: 82.h, // 设置高度
                                  child: Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50), // 圆形
                                    ),
                                    value: widget.defaultBindCard!.payNo ==
                                        cardItem.payNo,
                                    onChanged: (bool? value) {
                                      if (value == true) {
                                        controller.updateDefaultWithdrawAccount(
                                            cardItem);
                                        Get.back();
                                      }
                                    },
                                    activeColor:
                                        context.theme.primaryColor, // 选中颜色
                                    checkColor: Colors.white, // 选中时的勾选颜色
                                    side: const BorderSide(
                                        color: Colors.grey), // 未选中时的边框颜色
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      HorizontalMargin(
                        left: 30.w,
                        right: 30.w,
                        child: RechargeOkButtonWidget(
                          text: _getWalletTextName(),
                          clickButton: () {
                            AppManager.instance.tapVibrate();
                            Get.back();
                            Get.toNamed(
                              Routes.RECHARGE_ADD_ADDRESS,
                              arguments: {
                                "title": "添加${widget.name}账号",
                                "payType": widget.payType,
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 100.h,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      isDismissible: false,
    );
  }
}
