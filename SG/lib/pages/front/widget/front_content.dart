import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/front/front_logic.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/function.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../generated/l10n.dart';

class FrontContent extends GetView<FrontLogic> {
  const FrontContent({super.key, this.callback});

  final ParamSingleCallback<String>? callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: AppValues.margin_20,
        ),
        _buildCasinoTitle(S.current.tab_bar_ent, 'assets/images/home/ic_card_casino.webp'),
        SizedBox(height: AppValues.margin_20,),
        _buildCasinoContent(),
        _buildCasinoTitle(S.current.tab_bar_sports, 'assets/images/bet_slip/ic_sprot_icon_one.webp'),
        SizedBox(height: AppValues.margin_20,),
        _buildSportContent(),
      ],
    );
  }

  Widget _buildCasinoTitle(String title, String icon) {
    return Container(
      margin: const EdgeInsets.only(left: AppValues.defaultMargin),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          CustomIcon(asset: icon),
          const SizedBox(
            width: AppValues.margin_6,
          ),
          CustomText(
            title,
            style: ThemeService().textTheme.titleMedium,
          )
        ],
      ),
    );
  }

  Widget _buildCasinoContent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: Column(
        children: [
          Image.asset('assets/images/bet_slip/ic_casino_img.webp'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppValues.halfMargin,
              ),
              CustomText(
                softWrap: true,
                S.current.casino_des_one,
                style: ThemeService().textTheme.titleSmall,
              ),
              const SizedBox(
                height: AppValues.halfMargin,
              ),
              CustomText(
                softWrap: true,
                S.current.casino_des_two,
                style: ThemeService().textTheme.bodyMedium?.copyWith(color: AppThemes.textColorSecondary),
              ),
              const SizedBox(
                height: AppValues.defaultMargin,
              ),
              CustomBigMainButton(
                title: S.current.go_to_casino,
                onTap: (buttonCtr) => callback!('casino'),
              ),
              const SizedBox(
                height: AppValues.margin_20,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSportContent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: Column(
        children: [
          Image.asset('assets/images/bet_slip/ic_sport_img.webp'),Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: AppValues.halfMargin,
                  ),
                  CustomText(
                    softWrap: true,
                    S.current.sport_des_one,
                    style: ThemeService().textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: AppValues.halfMargin,
                  ),
                  CustomText(
                    softWrap: true,
                    S.current.sport_des_two,
                    style: ThemeService().textTheme.bodyMedium?.copyWith(color: AppThemes.textColorSecondary),
                  ),
                  const SizedBox(
                    height: AppValues.margin_18,
                  ),
                  CustomBigMainButton(
                    title: S.current.go_to_sports_book,
                    onTap: (buttonCtr) => callback!('sport'),
                  )
                ],
              )
        ],
      ),
    );
  }
}
