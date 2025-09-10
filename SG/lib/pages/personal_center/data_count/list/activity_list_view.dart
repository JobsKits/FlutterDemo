import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/bottom/custom_bottom_page_widget.dart';
import '../../../../widget/custom_text.dart';
import '../data_count_logic.dart';

///送奖活动 列表
class ActivityListView extends StatelessWidget {
  final DataCountLogic controller;

  const ActivityListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        _buildList(),
        CustomBottomPageWidget(currentPage: 1),
      ],
    );
  }

  _buildTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      height: 44,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: CustomText(S.current.tab_bar_order,
                  textAlign: TextAlign.left, textColorStyle: CustomTextColorStyle.normal)),
          Expanded(
              flex: 2,
              child: CustomText(S.current.random_text_358,
                  textAlign: TextAlign.center, textColorStyle: CustomTextColorStyle.normal)),
          Expanded(
              flex: 2,
              child: CustomText(S.current.random_text_359,
                  textAlign: TextAlign.right, textColorStyle: CustomTextColorStyle.normal)),
        ],
      ),
    );
  }

  _buildList() {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size.fromHeight(controller.windowListHeightMax)),
      child: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _ActivityItemView(index: index);
        },
      ),
    );
  }
}

class _ActivityItemView extends StatelessWidget {
  final index;

  const _ActivityItemView({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final isOdd = index % 2 == 1;
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      decoration: BoxDecoration(
        color: isOdd ? Colors.transparent : ThemeService().colorScheme.surfaceVariant,
        // borderRadius: BorderRadius.circular(AppValues.smallRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: CustomText(
              "11",
              textAlign: TextAlign.left,
              textColorStyle: CustomTextColorStyle.normal,
              style: ThemeService().textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: CustomText(
              "22",
              textColorStyle: CustomTextColorStyle.normal,
              textAlign: TextAlign.center,
              style: ThemeService().textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: CustomText(
              "22",
              textColorStyle: CustomTextColorStyle.normal,
              textAlign: TextAlign.end,
              style: ThemeService().textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
