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

///娱乐城投注，竞赛列表
class BettingCasinoRaceListTimeView extends StatelessWidget {
  BettingCasinoRaceListTimeView({super.key, this.endLabel});

  String? endLabel;

  final defaultStyle = ThemeService().textTheme.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  @override
  Widget build(BuildContext context) {
    return _buildTitleView();
  }

  Widget _buildTitleView() {
    //倒计时行
    return Container(
      height: 54,
      // alignment: Alignment.centerLeft,
      // width: Get.width,
      // padding: EdgeInsets.symmetric(
      // horizontal: AppValues.defaultPadding,
      // vertical: AppValues.defaultPadding,
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(width: AppValues.padding_8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomIcon(
                  asset: 'assets/images/bet_slip/ic_competition_icon_one.webp',
                  size: 14,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: CustomText(
                    S.current.random_text_280,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: ThemeService().textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                )
              ],
            ),
          ),
          // Spacer(),
          SizedBox(width: AppValues.halfPadding),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomIcon(
                  asset: 'assets/images/bet_slip/ic_competition_icon_two.webp',
                  size: 14,
                ),
                SizedBox(width: 4),
                // CustomText(endLabel??S.current.random_text_281),
                // CustomText(
                //   S.current.random_text_579,
                //   style: ThemeService().textTheme.bodyMedium?.copyWith(
                //         color: Colors.white,
                //         fontSize: 14,
                //
                //         fontWeight: FontWeight.w600,
                //       ),
                // ),
                Expanded(
                    child: CustomText(
                  // endLabel ?? "",
                  "${S.current.random_text_579}${endLabel ?? ""}",
                  textAlign: TextAlign.center,
                  style: ThemeService().textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                )),
              ],
            ),
          ),
          SizedBox(width: AppValues.defaultPadding),
        ],
      ),
    );
    return Column(
      children: [
        //倒计时行
        Container(
          height: 54,
          // alignment: Alignment.centerLeft,
          // width: Get.width,
          // padding: EdgeInsets.symmetric(
          // horizontal: AppValues.defaultPadding,
          // vertical: AppValues.defaultPadding,
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: AppValues.defaultPadding),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIcon(
                      asset: 'assets/images/bet_slip/ic_competition_icon_one.webp',
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: CustomText(
                        S.current.random_text_280,
                        maxLines: 2,
                        style: ThemeService().textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    )
                  ],
                ),
              ),
              // Spacer(),
              SizedBox(width: AppValues.defaultPadding),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CustomIcon(
                      asset: 'assets/images/bet_slip/ic_competition_icon_two.webp',
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    // CustomText(endLabel??S.current.random_text_281),
                    // CustomText(
                    //   S.current.random_text_579,
                    //   style: ThemeService().textTheme.bodyMedium?.copyWith(
                    //         color: Colors.white,
                    //         fontSize: 14,
                    //
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    // ),
                    Expanded(
                        child: CustomText(
                      // endLabel ?? "",
                      "${S.current.random_text_579}${endLabel ?? ""}",
                      style: ThemeService().textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                    )),
                  ],
                ),
              ),
              SizedBox(width: AppValues.defaultPadding),
            ],
          ),
        ),
        const CustomDividerWidget(),
        //标题行
        Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: AppValues.halfPadding),
          // padding: const EdgeInsets.only(left: AppValues.defaultPadding),
          decoration: BoxDecoration(
            color: ThemeService().theme.colorScheme.background,
            // borderRadius: BorderRadius.circular(20),
          ),
          // margin: const EdgeInsets.only(left: 13, right: 13, bottom: 15),
          child: CustomRowExpandedWidget(
            expanded: LangService().isChinese ? const [15, 30, 50, 20] : const [15, 30, 50, 30],
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
                              style: ThemeService().textTheme.labelMedium?.copyWith(
                                    // color: const Color(0xFF13212D),
                                    color: Colors.black,

                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      onTriggered: () {},
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
        ),
      ],
    );
  }
}
