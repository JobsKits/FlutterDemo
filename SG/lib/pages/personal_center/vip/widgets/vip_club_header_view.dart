import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/personal_center/vip/logic.dart';
import 'package:flutter_bet/pages/personal_center/vip_club/vip_club_view_swiper.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_small_mian_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class VipClubHeaderView extends StatelessWidget {
  final VipHomeLogic logic;

  VipClubHeaderView({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildVipTop(),
          _buildVipHandbook(),
          _buildVipExperience(),
          _buildVipAward(),
          // SizedBox(height: AppValues.margin_30),
        ],
      ),
    );
  }

  ///vip体验
  _buildVipTop() {
    return Container(
      color: ThemeService().colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const CustomAssetIcon(
            name: "assets/images/personal_center_icon/ic_vip_club_diamond.webp",
            size: 80,
            boxFit: BoxFit.fitHeight,
          ),
          const SizedBox(height: AppValues.margin_24),
          CustomText(
            S.current.random_text_433,
            style: ThemeService()
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 28),
          ),
          const SizedBox(height: AppValues.margin_24),
          CustomText(
            S.current.random_text_434,
            style: ThemeService()
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(height: AppValues.margin_24),
          Row(children: [
            SizedBox(
                width: 100,
                height: 44,
                child: CustomSmallMainButton(
                  title: S.current.start_game_text,
                  backgroundColor: ThemeService().colorScheme.primaryContainer,
                  textColor: Colors.black,
                  fontWeight: FontWeight.w600,
                  onTap: () => logic.onClickBeginGame(),
                )),
            const SizedBox(width: AppValues.defaultPadding),
            Container(
              width: GlobalStateController.of().isChinese() ? 140 : 200,
              // padding: EdgeInsets.symmetric(horizontal: 20),
              height: 44,
              child: CustomSmallMainButton(
                title: S.current.random_text_436,
                backgroundColor: ThemeService().colorScheme.tertiary,
                onTap: () => logic.onClickVipLevelTable(2),
                // padding: EdgeInsets.symmetric(horizontal: 0),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  ///入门手册 及其步骤
  _buildVipHandbook() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin, vertical: 24),
          child: Column(
            children: [
              CustomText(
                S.current.random_text_437,
                style: ThemeService()
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(height: AppValues.margin_6),
              CustomText(
                S.current.random_text_438,
                style: ThemeService()
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
              )
            ],
          ),
        ),

        ///步骤说明
        Image.asset(
          "assets/images/personal_center_icon/ic_vip_club_step_bg01.webp",
          fit: BoxFit.contain,
        ),
        _buildVipStepDetail(S.current.random_text_439, S.current.random_text_700),

        Image.asset(
          "assets/images/personal_center_icon/ic_vip_club_step_bg02.webp",
          fit: BoxFit.contain,
        ),
        _buildVipStepDetail(S.current.random_text_441, S.current.random_text_440),

        Image.asset(
          "assets/images/personal_center_icon/ic_vip_club_step_bg03.webp",
          fit: BoxFit.contain,
        ),
        _buildVipStepDetail(S.current.random_text_442, S.current.random_text_701),
      ],
    );
  }

  _buildVipStepDetail(String title, String detail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            '$title',
            style: ThemeService()
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          SizedBox(height: AppValues.margin_6),
          CustomText(
            '$detail',
            style: ThemeService()
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
          )
        ],
      ),
    );
  }

  ///体验
  _buildVipExperience() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin, vertical: 24),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            S.current.random_text_444,
            style: ThemeService()
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          SizedBox(height: AppValues.margin_6),
          CustomText(
            S.current.random_text_702,
            style: ThemeService()
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppValues.margin_30),
          Container(
            height: 380,
            // width: 200,
            child: Swiper(
              // itemWidth: 100,
              // itemHeight: 150,
              containerWidth: 90,
              containerHeight: 140,
              layout: SwiperLayout.DEFAULT,
              index: 0,
              loop: false,
              itemBuilder: (context, index) {
                return VipClubSwiperItemView(model: logic.swiperModelList[index]);
              },
              // autoplay: true,
              itemCount: logic.swiperModelList.length,
              scrollDirection: Axis.horizontal,
              // pagination: const SwiperPagination(alignment: Alignment.centerRight),
              control: const SwiperControl(
                color: Color(0xFFB1BAD3),
                size: 20,
                padding: EdgeInsets.all(0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///vip奖励等级
  _buildVipAward() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      child: Column(
        children: [
          CustomText(
            S.current.random_text_445,
            style: ThemeService()
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          SizedBox(height: AppValues.margin_6),
          CustomText(
            S.current.random_text_446,
            style: ThemeService()
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
