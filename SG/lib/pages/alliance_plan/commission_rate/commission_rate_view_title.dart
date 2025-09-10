import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/widget/cell/custom_tooltip_cell_widget.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import '../widget_cell/alliance_item_cell_widget.dart';

///联盟计划-拥挤比例tab-详细页面item
class CommissionRateTitleView extends StatelessWidget {
  const CommissionRateTitleView({super.key, this.titleColor});
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      // padding: const EdgeInsets.symmetric(vertical: AppValues.defaultMargin),
      color: titleColor??ThemeService().theme.scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: AllianceItemCellWidget(S.current.random_text_88, isTitle: true),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AllianceItemCellWidget(S.current.random_text_51, isTitle: true),
                  SizedBox(width: 1),
                  CustomAssetIcon(name: "assets/images/coin_icon/ic_coin_usdt.webp",size: 15,)
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            // child: Center(child: AllianceItemCellWidget(S.current.random_text_89)),
            child: Center(
              child: AllianceItemCellWidget(S.current.random_text_63, isTitle: true),
            ),
          ),
        ],
      ),
    );
  }
}
