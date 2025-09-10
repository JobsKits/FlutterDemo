import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_list_item_widget.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/utils/common_color.dart';
import '../../../../utils/CommonRipple.dart';
import '../controllers/recharge_controller.dart';

///充值界面的快捷输入金额的组件
// ignore: must_be_immutable

class RechargeQuickInputMoneyWidget extends StatefulWidget {
  final String? rechargeAmount;
  final ValueChanged<String>? onChanged;

  const RechargeQuickInputMoneyWidget({
    super.key,
    this.rechargeAmount = '',
    this.onChanged,
  });

  @override
  State<RechargeQuickInputMoneyWidget> createState() =>
      _RechargeQuickInputMoneyWidget();
}

class _RechargeQuickInputMoneyWidget
    extends State<RechargeQuickInputMoneyWidget> {
  late RechargeController controller = Get.find();

  @override
  void didUpdateWidget(RechargeQuickInputMoneyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.rechargeAmount != widget.rechargeAmount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.quickMoneyList.contains(widget.rechargeAmount)) {
          var index = controller.quickMoneyList.indexOf(widget.rechargeAmount);

          if (controller.currentSelectMoneyIndex.value != index) {
            controller.changeMoneyIndex(index);
          }
        }
      });
    }
  }

  bool _isSelectValue(int index) {
    bool isSelect = false;
    if (controller.currentSelectMoneyIndex.value == index) {
      isSelect = true;
    }

    if (controller.quickMoneyList.isNotEmpty) {
      isSelect = controller.quickMoneyList[index] == widget.rechargeAmount;
    }

    return isSelect;
  }

  @override
  Widget build(BuildContext context) {
    if (controller.quickMoneyList.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: EdgeInsets.only(top: 0.h, bottom: 40.h),
      child: Obx(
        () => GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: controller.quickMoneyList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16.h,
              mainAxisSpacing: 16.w,
              childAspectRatio: 2.36),
          itemBuilder: (context, index) {
            return CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                controller.changeMoneyIndex(index);
                if (widget.onChanged != null) {
                  widget.onChanged!(controller.quickMoneyList[index]);
                }
              },
              child: Obx(
                () => Container(
                  height: 96.h,
                  alignment: Alignment.center,
                  decoration: _isSelectValue(index)
                      ? BoxDecoration(
                          color: context.theme.primaryColor,
                          borderRadius: BorderRadius.circular(27.r),
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(27.r),
                          border: Border.all(color: const Color(colorCFCFCF))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.quickMoneyList[index],
                        style: TextStyle(
                            color: _isSelectValue(index)
                                ? Colors.white
                                : context
                                    .customTheme?.rechargeSecondTypeBgColor,
                            fontSize: 41.sp),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
