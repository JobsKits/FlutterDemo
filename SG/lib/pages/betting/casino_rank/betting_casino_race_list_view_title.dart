import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_divider_widget.dart';
import 'package:flutter_bet/widget/row/custom_row_expanded_widget.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/lang_service.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/cell/custom_tooltip_widget.dart';
import '../../../widget/custom_bubble.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/custom_text.dart';
import '../common_helper/betting_width_config.dart';

///娱乐城投注，竞赛列表
class BettingCasinoRaceListTitleView extends StatelessWidget {
  BettingCasinoRaceListTitleView({super.key});

  final defaultStyle = ThemeService().textTheme.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  @override
  Widget build(BuildContext context) {
    return _buildTitleView();
  }

  ///标题行
  Widget _buildTitleView() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: AppValues.halfPadding),
      // padding: const EdgeInsets.only(left: AppValues.defaultPadding),
      decoration: BoxDecoration(
        color: ThemeService().theme.colorScheme.background,
        // borderRadius: BorderRadius.circular(20),
      ),
      // margin: const EdgeInsets.only(left: 13, right: 13, bottom: 15),
      child: CustomRowExpandedWidget(
        expanded: BettingWidthConfig.race().expends,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(child: CustomText(S.current.random_text_282, style: defaultStyle)),
          Center(child: CustomText(S.current.back_list_player_text, style: defaultStyle)),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //提示组件
                // const CustomAssetIcon(
                //     name: "assets/images/common/ic_common_sigh_gray.webp", size: 14),
                CustomTooltipWidget(
                  padding: EdgeInsets.zero,
                  verticalOffset: 10,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  richMessage: WidgetSpan(
                    child: UnconstrainedBox(
                      // key: _globalKeyTip,
                      child: BubbleView(
                        width: LangService().isChinese ? null : Get.width * 0.95,
                        direction: ArrowDirection.bottom,
                        arrowWidth: 8,
                        arrowHeight: 4,
                        borderRadius: const Radius.circular(4.0),
                        arrowBasisOffset: 0,
                        //偏移修改
                        arrowPeakOffset: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        offsetCallback: null,
                        child: CustomText(
                          S.current.random_text_889,
                          maxLines: 2,
                          style: ThemeService().textTheme.labelMedium?.copyWith(
                                // color: const Color(0xFF13212D),
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ),
                  child: const CustomAssetIcon(
                      name: "assets/images/common/ic_common_sigh_gray.webp", size: 14),
                ),
                const SizedBox(width: AppValues.margin_4),
                CustomText(S.current.statistics_title_total_text, style: defaultStyle),
              ],
            ),
          ),
          Center(child: CustomText(S.current.transactions_other_bonus, style: defaultStyle)),
        ],
      ),
    );
  }
}
