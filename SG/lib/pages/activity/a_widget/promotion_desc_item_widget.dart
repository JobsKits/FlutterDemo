import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';

///推广界面 推广条件 说明 item
class PromotionDescItemWidget extends StatelessWidget {
  const PromotionDescItemWidget({super.key, required this.title, required this.content, this.titleStyle});

  final String title;
  final String content;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //说明标题
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                    color: ThemeService().textTheme.labelMedium?.color,
                    borderRadius: BorderRadius.circular(12)),
              ),
              SizedBox(width: AppValues.padding_8),
              CustomText(
                title,
                maxLines: 2,
                style: titleStyle ??
                    ThemeService()
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          //说明内容
          Padding(
            padding: const EdgeInsets.only(left: AppValues.padding_14, top: AppValues.padding_2),
            child: CustomText(
              content,
              style: ThemeService()
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
