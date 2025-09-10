import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_icon.dart';
import '../../../../widget/custom_text.dart';
import '../model/betting_item_state.dart';
import '../responsible_logic.dart';
import 'betting_limits_progress_indicator.dart';

///投注限Betting limits   item
class BettingLimitsItemShowView extends StatelessWidget {
  BettingLimitsItemShowView({super.key, this.onClickEdit, required this.state});

  final ResponsibleLogic controller = Get.find<ResponsibleLogic>();
  final GestureTapCallback? onClickEdit;

  final BettingItemState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///标题部分
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: ThemeService().colorScheme.tertiary,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppValues.smallRadius),
                  topRight: Radius.circular(AppValues.smallRadius))),
          child: Row(
            children: [
              CustomText(
                S.current.responsible_tab_betting_limits,
                style: ThemeService().textTheme.labelLarge,
              ),
              const Expanded(child: SizedBox()),
              CustomText(
                S.current.random_text_372,
                style: ThemeService().textTheme.labelLarge,
              ),
              SizedBox(width: AppValues.smallMargin),
              GestureDetector(
                child:
                    CustomIcon(size: 18, asset: 'assets/images/personal_center_icon/set_up.webp'),
                onTap: onClickEdit,
              ),
            ],
          ),
        ),

        ///正文部分
        Container(
          padding: EdgeInsets.all(AppValues.defaultPadding),
          decoration: BoxDecoration(
            color: ThemeService().colorScheme.surfaceVariant,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "R\$ ${state.limitMoney}",
                    style: ThemeService().textTheme.bodyMedium,
                  ),
                  SizedBox(width: AppValues.smallMargin),
                  CustomAssetIcon(size: 18, name: "assets/images/coin_icon/eth_ic.png"),
                  Expanded(child: SizedBox()),
                  Container(
                    height: 26,
                    padding: const EdgeInsets.only(
                        left: AppValues.defaultPadding,
                        right: AppValues.defaultPadding,
                        top: AppValues.smallPadding,
                        bottom: AppValues.smallPadding),
                    decoration: BoxDecoration(
                        color: ThemeService().colorScheme.surface,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(AppValues.smallRadius))),
                    child: Row(
                      children: [
                        CustomText("${controller.getLimitTimeTypeLabel(state.limitTimeType)}",
                            style: ThemeService()
                                .theme
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontWeight: FontWeight.w400)),
                        const SizedBox(
                          width: AppValues.margin_4,
                        ),
                        const CustomAssetIcon(
                          name: "assets/images/top_drop_down arrow.png",
                          size: 18,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: AppValues.defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "R\$ ${state.curryMoney}",
                    style: ThemeService().textTheme.labelMedium,
                  ),
                  Expanded(child: SizedBox()),
                  CustomText(
                    "R\$ ${state.limitMoney}",
                    style: ThemeService().textTheme.labelMedium,
                  ),
                ],
              ),
              SizedBox(height: AppValues.halfPadding),
              BettingLimitsProgressIndicator(value: state.getLimitProcess(), minHeight: 6),
              SizedBox(height: AppValues.halfPadding),
            ],
          ),
        ),
        SizedBox(
          height: AppValues.defaultMargin,
        )
      ],
    );
  }
}
