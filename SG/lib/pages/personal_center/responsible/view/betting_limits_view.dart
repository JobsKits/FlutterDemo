import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_text.dart';
import '../model/betting_item_state.dart';
import '../responsible_logic.dart';
import 'betting_limits_item_view.dart';

///投注限Betting limits
class BettingLimitsView extends StatelessWidget {
  BettingLimitsView({super.key});

  final ResponsibleLogic controller = Get.find<ResponsibleLogic>();

  @override
  Widget build(BuildContext context) {
    return _buildListView();
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size.fromHeight(controller.windowListHeightMax)),
      child: LayoutBuilder(builder: (context, constraints) {
        log('约束信息：BettingLimitsView...$constraints');
        return Container(
          padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
          child: Obx(() {
            return ListView.builder(
              itemCount: controller.bettingItemStateList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                log('BettingLimitsItemView...index...' + index.toString());
                var state = controller.bettingItemStateList[index];
                return !state.isBottom ? BettingLimitsItemView(state: state) : _buildBottomTip();
              },
              // physics: NeverScrollableScrollPhysics(),
              // physics:ClampingScrollPhysics(),
              // physics: AlwaysScrollableScrollPhysics(),
              // controller: ScrollController(),
            );
          }),
        );
      }),
    );
  }

  _buildListView() {
    return LayoutBuilder(
      builder: (context, constraints)  {
        log('约束信息：投注限额...BettingLimitsView...$constraints');
        return Obx(() {
          return ListView.builder(
            itemCount: controller.bettingItemStateList.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              // log('BettingLimitsItemView...index...' + index.toString());
              var state = controller.bettingItemStateList[index];
              return !state.isBottom ? BettingLimitsItemView(state: state) : _buildBottomTip();
            },
          );
        });
      }
    );
  }

  _buildBottomTip() {
    return SizedBox(
      child: CustomText(
        S.current.random_text_375,
        style: ThemeService()
            .theme
            .textTheme
            .labelMedium
            ?.copyWith(fontWeight: FontWeight.w400, color: Color(0xFFED4163)),
      ),
    );
  }
}
