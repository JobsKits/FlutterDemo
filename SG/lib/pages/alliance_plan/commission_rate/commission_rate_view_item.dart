import 'package:flutter/widgets.dart';
import 'package:flutter_bet/utils/num_util.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/custom_text.dart';
import '../widget_cell/alliance_item_cell_widget.dart';
import 'commission_rate_model.dart';

///联盟计划-拥挤比例tab-详细页面item
class CommissionRateItemView extends StatelessWidget {
  final CommissionRateModel model;
  final int index;
  final BorderRadiusGeometry? borderRadius;

  const CommissionRateItemView({super.key, required this.index, required this.model, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width + 200,
      padding: const EdgeInsets.symmetric(vertical: AppValues.defaultMargin),
      decoration: BoxDecoration(
        borderRadius: borderRadius??BorderRadius.circular(4),
        color: index % 2 == 0
            ? ThemeService().colorScheme.surfaceVariant
            : ThemeService().theme.scaffoldBackgroundColor,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            // 使用有效投注作为 升序条件， 这个排序位索引排序
            // child: Center(child: AllianceItemCellWidget("${model.level.toString()}")),
            child: Center(child: AllianceItemCellWidget("${index + 1}")),
          ),
          Expanded(
            flex: 3,
            child: Center(child: AllianceItemCellWidget("${model.validBet}+")),
          ),
          Expanded(
            flex: 2,
            child: Center(child: AllianceItemCellWidget("${model.rebateAmount}")),
          ),
        ],
      ),
    );
  }
}
