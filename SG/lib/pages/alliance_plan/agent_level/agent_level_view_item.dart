import 'package:flutter/widgets.dart';
import 'package:flutter_bet/constant/app_values.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_text.dart';
import 'agent_level_model.dart';

class AgentLevelItemView extends StatelessWidget {
  final AgentLevelModel model;
  final int index;

  const AgentLevelItemView({super.key, required this.model, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: index % 2 == 0
          ? ThemeService().colorScheme.surfaceVariant
          : ThemeService().theme.scaffoldBackgroundColor,
      alignment: Alignment.center,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomAssetIcon(
                name: '${model.getLevelImageAsset()}',
                size: 16,
              ),
              SizedBox(width: AppValues.margin_4),
              CustomText(
                '${model.getLevel()}',
                style: ThemeService().textTheme.bodySmall,
              ),
            ],
          ),
          CustomText(
            '${model.money}',
            style: ThemeService().textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
