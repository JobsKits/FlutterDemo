import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_button.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';

import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/app/modules/activity/data/yuebao_bean.dart';
import '../../../../../utils/CommonRipple.dart';
import '../../controllers/controller_yuebao_page.dart';

import '../../widget/empty_widget.dart';

class YuebaoPageHasBuy extends StatefulWidget {
  const YuebaoPageHasBuy({super.key});

  @override
  State<YuebaoPageHasBuy> createState() => _YuebaoPageHasBuyState();
}

class _YuebaoPageHasBuyState extends State<YuebaoPageHasBuy> {
  final ControllerYuebaoPage controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildBody());
  }

  Widget _buildBody() {
    if (controller.buyPlanData.isEmpty) {
      // return const SizedBox();
      return const EmptyWidget();
    }
    return Column(
      children: [
        ...List.generate(
          controller.buyPlanData.length,
          (index) {
            YueBaoHasBuyPlanItemBean itemData = controller.buyPlanData[index];
            return _buildRecordItem2(itemData);
          },
        ),
        SizedBox(height: 30.h),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 106.w,
      height: 106.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(53.r),
        color: const Color(colorF6F6F6),
      ),
      child: Center(
        child: SvgPicture.asset(
          Assets.theme1.images.activity.yuebao.iconWallet,
          width: 65.w,
          height: 65.h,
        ),
      ),
    );
  }

  Widget _buildRecordItemTop(YueBaoHasBuyPlanItemBean itemData) {
    num rate = double.tryParse('${(itemData.daily_rate ?? 0) / 100}') ?? 0.00;
    int? day = itemData.product_cycle != null
        ? int.parse('${itemData.product_cycle ?? 0}')
        : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildIcon(),
        SizedBox(width: 20.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              itemData.plan_name ?? '-',
              style: TextStyle(
                fontSize: 45.sp,
                color: const Color(color3A373A),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: '利率：',
                    style: TextStyle(
                      fontSize: 39.sp,
                      color: const Color(color868686),
                    ),
                    children: [
                      TextSpan(
                        text: '${rate.truncateToFixed(2)}%',
                        style: const TextStyle(
                          color: Color(colorD73F4C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30.w),
                Visibility(
                  visible: day != null || day != 0,
                  child: RichText(
                    text: TextSpan(
                      text: '周期：',
                      style: TextStyle(
                        fontSize: 39.sp,
                        color: const Color(color868686),
                      ),
                      children: [
                        TextSpan(
                          text: '${parseNumber(day)}天',
                          style: TextStyle(
                            color: context.theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              '${DateTimeUtils.formatTimestamp(int.parse('${itemData.create_time ?? 0}'))} 买入',
              style: TextStyle(
                fontSize: 36.sp,
                color: const Color(color868686),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildRecordItemBottom(YueBaoHasBuyPlanItemBean itemData) {
    num amount = (itemData.balance ?? 0) / 1000; // 金额
    num income = (itemData.income ?? 0) / 1000; // 收入
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: '转入金额：',
                style: TextStyle(
                  fontSize: 39.sp,
                  color: const Color(color868686),
                ),
                children: [
                  TextSpan(
                    text: parseNumber(amount),
                    style: const TextStyle(
                      color: Color(colorD73F4C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            RichText(
              text: TextSpan(
                text: '总收益：',
                style: TextStyle(
                  fontSize: 39.sp,
                  color: const Color(color868686),
                ),
                children: [
                  TextSpan(
                    text: parseNumber(income),
                    style: const TextStyle(
                      color: Color(colorD73F4C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          width: 230.w,
          child: CommonButton(
            title: '赎回',
            onTap: () {
              _buildCloseDialog(itemData);
            },
          ),
        )
      ],
    );
  }

  void _buildCloseDialog(YueBaoHasBuyPlanItemBean itemData) {
    num amount = (itemData.balance ?? 0) / 1000; // 金额
    num income = (itemData.income ?? 0) / 1000; // 收入
    num fee = (itemData.handling_fee ?? 0) / 1000; // 手续费

    num money = amount + income;
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: 980.w,
          height: 645.h,
          padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 60.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.r),
            color: const Color(colorFFFFFF),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 100.h,
                    child: Center(
                      child: Text(
                        '赎回',
                        style: TextStyle(
                          fontSize: 50.sp,
                          color: const Color(color3B3B3B),
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.h,
                    right: 0.w,
                    child: CommonRipple(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        size: 66.r,
                        color: const Color(colorCECECE),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      '预计赎回：${parseNumber(money)}',
                      style: TextStyle(
                        fontSize: 45.sp,
                        color: const Color(color3B3B3B),
                      ),
                    ),
                    SizedBox(height: 60.h),
                    Text(
                      '手续费：${parseNumber(fee)}',
                      style: TextStyle(
                        fontSize: 45.sp,
                        color: const Color(color3B3B3B),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 50.w),
                    child: SizedBox(
                      width: 340.w,
                      height: 105.h,
                      child: CommonButton(
                        title: '取消',
                        onTap: () {
                          Get.back();
                        },
                        type: CommonButtonTypeEnum.Outline,
                      ),
                    ),
                  ),
                  Obx(() => Padding(
                        padding: EdgeInsets.only(right: 50.w),
                        child: SizedBox(
                          width: 340.w,
                          height: 105.h,
                          child: CommonButton(
                            title: '确认',
                            onTap: () {
                              controller.reqSellPlan(itemData.acct_product_id!);
                              print('====> ${itemData.toString()}');
                            },
                            loading: controller.isDetailBtnLoading.value,
                          ),
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildRecordItem(YueBaoHasBuyPlanItemBean itemData) {
    return Container(
      constraints: BoxConstraints(minHeight: 230.h),
      margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 30.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: const Color(colorFFFFFF),
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 58.w, vertical: 30.h),
      child: Column(
        children: [
          _buildRecordItemTop(itemData),
          SizedBox(height: 16.h),
          Divider(height: 1.h, color: const Color(colorE8E8E8)),
          SizedBox(height: 16.h),
          _buildRecordItemBottom(itemData),
        ],
      ),
    );
  }

  Widget _buildRecordItem2(YueBaoHasBuyPlanItemBean itemData) {
    // print('plan_name: ${itemData.plan_name}');
    num amount = (itemData.balance ?? 0) / 1000;
    // print('计息金币：${parseNumber(amount)}元');
    num rate = double.tryParse('${(itemData.daily_rate ?? 0) / 100}') ?? 0.00;
    num interest = (itemData.interest ?? 0) / 1000;
    // print('上次收益：${parseNumber(interest)}');
    num income = (itemData.income ?? 0) / 1000;
    // print('总收益：${parseNumber(income)}');
    // print(
    //     'create_time: ${DateTimeUtils.formatTimestamp(int.parse('${itemData.create_time ?? 0}'))}');

    return Container(
      constraints: BoxConstraints(minHeight: 230.h),
      margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 30.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: const Color(colorFFFFFF),
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 58.w, vertical: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: itemData.plan_name,
                  style: TextStyle(
                    fontSize: 45.sp,
                    color: const Color(color3A373A),
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    WidgetSpan(
                      child: SizedBox(width: 40.w),
                    ),
                    TextSpan(
                      text: '计息金币：',
                      style: TextStyle(
                        fontSize: 39.sp,
                        color: const Color(color868686),
                      ),
                    ),
                    TextSpan(
                      text: '${parseNumber(amount)}元',
                      style: TextStyle(
                        fontSize: 39.sp,
                        color: const Color(color868686),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              RichText(
                text: TextSpan(
                  text: '日利率：',
                  style: TextStyle(
                    fontSize: 39.sp,
                    color: const Color(color868686),
                  ),
                  children: [
                    TextSpan(
                      text: '${rate.truncateToFixed(2)}%',
                      style: const TextStyle(
                        color: Color(colorD73F4C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              RichText(
                text: TextSpan(
                  text: '上次收益：',
                  style: TextStyle(
                    fontSize: 39.sp,
                    color: const Color(color868686),
                  ),
                  children: [
                    TextSpan(
                      text: parseNumber(interest),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              RichText(
                text: TextSpan(
                  text: '总收益：',
                  style: TextStyle(
                    fontSize: 39.sp,
                    color: const Color(color868686),
                  ),
                  children: [
                    TextSpan(
                      text: parseNumber(income),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                '${DateTimeUtils.formatTimestamp(int.parse('${itemData.create_time ?? 0}'))}',
                style: TextStyle(
                  fontSize: 39.sp,
                  color: const Color(color868686),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 230.w,
            child: CommonButton(
              title: '赎回',
              onTap: () {
                _buildCloseDialog(itemData);
              },
            ),
          )
        ],
      ),
    );
  }
}
