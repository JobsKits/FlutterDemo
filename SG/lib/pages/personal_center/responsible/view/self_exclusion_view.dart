import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/button/custom_small_mian_button.dart';
import '../../../../widget/custom_text.dart';
import '../responsible_logic.dart';

///自我排除
class SelfExclusionView extends StatelessWidget {
  SelfExclusionView({super.key});

  final ResponsibleLogic controller = Get.find<ResponsibleLogic>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraint) {
        log('约束信息：PageView 里面...item...自我排除...$boxConstraint');
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  bottom: AppValues.largePadding,
                  left: AppValues.defaultPadding,
                  right: AppValues.defaultPadding),
              child: CustomText(
                S.current.random_text_377,
                style:
                    ThemeService().theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppValues.halfMargin),
              height: 1,
              color: ThemeService().colorScheme.tertiary,
            ),
            Padding(
              padding: const EdgeInsets.all(AppValues.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    S.current.random_text_386,
                    style: ThemeService()
                        .theme
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => controller.onClickSelfExclusionMore(),
                    child: CustomText(
                      S.current.responsible_title_self_exclusion,
                      style: ThemeService().theme.textTheme.bodyMedium,
                    ),
                  ),
                  CustomText(
                    S.current.random_text_387,
                    style: ThemeService()
                        .theme
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            CustomSmallMainButton(
              title: S.current.responsible_btn_request_self_exclusion,
              width: 148,
              backgroundColor: ThemeService().colorScheme.tertiaryContainer,
              fontWeight: FontWeight.w500,
              onTap: () => controller.onClickSelfExclusion(),
            ),
            SizedBox(height: AppValues.defaultMargin),
          ],
        );
      }
    );
  }
}
