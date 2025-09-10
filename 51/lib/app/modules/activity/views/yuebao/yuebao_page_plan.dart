import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_button.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/yuebao_bean.dart';
import 'package:get/get.dart';
import '../../../../../utils/CommonRipple.dart';
import '../../controllers/controller_yuebao_page.dart';
import 'yuebao_buy_plan_dialog.dart';
import '../../widget/empty_widget.dart';

class YuebaoPagePlan extends StatefulWidget {
  final bool isFixed; // 是否为定期
  const YuebaoPagePlan({
    super.key,
    required this.isFixed,
  });

  @override
  State<YuebaoPagePlan> createState() => _YuebaoPagePlanState();
}

class _YuebaoPagePlanState extends State<YuebaoPagePlan> {
  final ControllerYuebaoPage controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildBody());
  }

  Widget _buildBody() {
    List<YueBaoInterestPlanItemBean> dataList =
        widget.isFixed == true ? controller.fixedPlan : controller.livePlan;

    if (dataList.isEmpty) {
      // return const SizedBox();
      return const EmptyWidget();
    }

    return Column(
      children: [
        ...List.generate(
          dataList.length,
          (index) {
            YueBaoInterestPlanItemBean dataItem = dataList[index];
            // 定期方案
            if (widget.isFixed) {
              return _buildFiexedPlanItem(
                planName: dataItem.plan_name ?? '',
                rate: double.tryParse('${(dataItem.daily_rate ?? 0) / 100}') ??
                    0.00,
                day: int.parse('${dataItem.product_cycle ?? 0}'),
                disabled: dataItem.state != 0,
                dataItem: dataItem,
              );
            }

            // 活期方案
            return _buildMovedPlanItem(
              planName: dataItem.plan_name ?? '',
              rate: double.tryParse('${(dataItem.daily_rate ?? 0) / 100}') ??
                  0.00,
              disabled: dataItem.state != 0,
              dataItem: dataItem,
            );
          },
        ),
        SizedBox(height: 30.h),
      ],
    );
  }

  // 构建定期方案
  Widget _buildFiexedPlanItem({
    required String planName, // 方案名称
    required double rate, // 方案利率
    required int day, // 周期时间
    required bool disabled, // 是否能购买
    required YueBaoInterestPlanItemBean dataItem,
  }) {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        controller.jumpToDetail(detail: dataItem, mode: JumpToPageMode.fixed);
      },
      child: Container(
        constraints: BoxConstraints(minHeight: 230.h),
        margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 30.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: const Color(colorFFFFFF),
        ),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 58.w, vertical: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planName,
                      style: TextStyle(
                          color: const Color(color3A373A), fontSize: 45.sp),
                    ),
                    SizedBox(height: 10.h),
                    RichText(
                      text: TextSpan(
                        text: '利率：',
                        style: TextStyle(
                          fontSize: 39.sp,
                          color: const Color(color868686),
                        ),
                        children: [
                          TextSpan(
                            text: ' ${rate.truncateToFixed(2)}%',
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
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '产品周期：',
                    style: TextStyle(
                      fontSize: 39.sp,
                      color: const Color(color868686),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    '${parseNumber(day)}天',
                    style: TextStyle(
                      fontSize: 39.sp,
                      color: const Color(color5077CF),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 230.w,
              child: CommonButton(
                title: disabled ? '已购买' : '购买',
                disabled: disabled,
                disabledBgColor: const Color(colorA0BEC3),
                disabledColor: const Color(colorFFFFFF),
                onTap: () {
                  controller.setDetailData(
                      detail: dataItem, mode: JumpToPageMode.fixed);
                  Get.dialog(
                    const YuebaoBuyPlanDialog(
                      isFixed: true,
                    ),
                    barrierDismissible: false,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // 构建活期方案
  Widget _buildMovedPlanItem({
    required String planName, // 方案名称
    required double rate, // 方案利率
    required bool disabled, // 是否能购买
    required YueBaoInterestPlanItemBean dataItem,
  }) {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        controller.jumpToDetail(detail: dataItem, mode: JumpToPageMode.live);
      },
      child: Container(
        constraints: BoxConstraints(minHeight: 230.h),
        margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 30.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: const Color(colorFFFFFF),
        ),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 58.w, vertical: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planName,
                      style: TextStyle(
                          color: const Color(color3A373A), fontSize: 45.sp),
                      maxLines: 4,
                    ),
                    SizedBox(height: 10.h),
                    RichText(
                      text: TextSpan(
                        text: '利率：',
                        style: TextStyle(
                          fontSize: 39.sp,
                          color: const Color(color868686),
                        ),
                        children: [
                          TextSpan(
                            text: ' ${rate.truncateToFixed(2)}%',
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
              ),
            ),
            SizedBox(
              width: 230.w,
              child: CommonButton(
                title: disabled ? '已转入' : '转入',
                disabled: disabled,
                disabledBgColor: const Color(colorA0BEC3),
                disabledColor: const Color(colorFFFFFF),
                onTap: () {
                  controller.setDetailData(
                      detail: dataItem, mode: JumpToPageMode.live);
                  Get.dialog(
                    const YuebaoBuyPlanDialog(
                      isFixed: false,
                    ),
                    barrierDismissible: false,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
