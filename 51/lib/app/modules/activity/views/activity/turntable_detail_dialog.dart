import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_info.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/action_cfg.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:get/get.dart';

class TurntableDetailDialog extends StatefulWidget {
  final VoidCallback? onClose;
  final ActivityTurntableDetailInfo? info;
  final ActionCfg? actionCfg;

  const TurntableDetailDialog(
      {super.key, this.onClose, this.info, this.actionCfg});

  @override
  _TurntableDetailDialogState createState() => _TurntableDetailDialogState();
}

class _TurntableDetailDialogState extends State<TurntableDetailDialog>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Container(
        width: 0.8.sw,
        height: widget.actionCfg!.validityTime != 4 ? 0.3.sh : 0.2.sh,
        decoration: BoxDecoration(
          color: context.customTheme?.dialogBgColor,
          borderRadius: BorderRadius.circular(12.5),
        ),
        child: Column(
          children: [_buildTitle(context), _buildContent(context)],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                '详情',
                style: TextStyle(
                  fontSize: 21,
                  color: context.customTheme?.titleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 30,
                height: 30,
                child: const Icon(
                  Icons.close_sharp,
                  color: Color(0xFFCECECE),
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      width: 0.7.sw,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align the text to the left
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      widget.actionCfg!.type == 1 ? '活动期间总打码：' : '活动期间内总获得幸运值：',
                  style: TextStyle(
                    fontSize: 42.sp,
                    color: context.customTheme?.titleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: widget.actionCfg!.type == 1
                      ? ((widget.info?.betAmount ?? 0) / 1000)
                          .truncateToFixed(0)
                      : '${widget.info?.totalSource}',
                  style: TextStyle(
                    fontSize: 42.sp,
                    color: const Color(0xFFD62E2E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '已使用幸运值：',
                  style: TextStyle(
                    fontSize: 42.sp,
                    color: context.customTheme?.titleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: '${widget.info?.usedSource ?? 0}',
                  style: TextStyle(
                    fontSize: 42.sp,
                    color: const Color(0xFFD62E2E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (widget.actionCfg!.validityTime != 4) ...[
            const SizedBox(height: 15),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '已过期幸运值：',
                    style: TextStyle(
                      fontSize: 42.sp,
                      color: context.customTheme?.titleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '${widget.info?.expiredSource ?? 0}',
                    style: TextStyle(
                      fontSize: 42.sp,
                      color: const Color(0xFFD62E2E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 15),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '可用幸运值：',
                  style: TextStyle(
                    fontSize: 42.sp,
                    color: context.customTheme?.titleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: '${widget.info?.availableSource ?? 0}',
                  style: TextStyle(
                    fontSize: 42.sp,
                    color: const Color(0xFFD62E2E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
