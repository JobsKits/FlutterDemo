import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/utils/function.dart';
import 'package:get/get.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import 'my_promotion_view_card_model.dart';

///联盟计划-tab-我的推广界面-数据详情card
@Deprecated("旧的ui设计风格")
class MyPromotionCardView extends StatelessWidget {
  const MyPromotionCardView({super.key, required this.models, this.onClickMore});

  final List<MyPromotionCardItemModel> models;
  final ParamSingleCallback<MyPromotionCardItemModel>? onClickMore;

  // final modelsObs = [].obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: ThemeService().colorScheme.tertiary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: models.map<Widget>((model) {
          if (model.isTitle) {
            return _TitleItemView(model: model,onClickMore:  onClickMore,);
          } else {
            return _ContentItemView(model: model);
          }
        }).toList(),
      ),
    );
  }
}

class _TitleItemView extends StatelessWidget {
  const _TitleItemView({super.key, required this.model, this.onClickMore});

  final MyPromotionCardItemModel model;
  // final VoidCallback? onClickMore;
  final ParamSingleCallback<MyPromotionCardItemModel>? onClickMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeService().colorScheme.tertiary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (onClickMore != null) {
            onClickMore!(model);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(model.label,
                style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            CustomText(S.current.random_text_153,
                style: ThemeService().textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}

class _ContentItemView extends StatelessWidget {
  const _ContentItemView({super.key, required this.model});

  final MyPromotionCardItemModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(model.label, style: ThemeService().textTheme.labelLarge),
              CustomText(model.content,
                  style:
                      ThemeService().textTheme.bodyMedium?.copyWith(color: model.colorType?.color)),
            ],
          ),
        ),
        Container(
          height: 2,
          color: ThemeService().colorScheme.tertiary,
          margin: EdgeInsets.symmetric(horizontal: 4),
        )
      ],
    );
  }
}
