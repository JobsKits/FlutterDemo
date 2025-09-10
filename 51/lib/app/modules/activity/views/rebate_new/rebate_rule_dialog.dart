import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RebateRuleDialog extends StatefulWidget {
  final String? rule;
  const RebateRuleDialog({super.key, this.rule});

  @override
  State<RebateRuleDialog> createState() => _RebateRuleDialogState();
}

class _RebateRuleDialogState extends State<RebateRuleDialog>
    with TickerProviderStateMixin {
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
    return _getContent(context);
  }

  Widget _getContent(BuildContext context) {
    return Center(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.customTheme?.dialogBgColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 50),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '返水规则',
                    style: TextStyle(
                      color: context.customTheme?.titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 50.sp,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 20,
                  color: context.customTheme?.titleColor,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 20),
            child: HtmlWidget(
              widget.rule ?? '',
              textStyle: TextStyle(
                fontSize: 39.sp,
                color: context.customTheme?.title3Color,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
