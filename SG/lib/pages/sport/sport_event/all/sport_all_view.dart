import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_urls_values.dart';
import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_divider_widget.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/sport/custom_sport_expand/custom_sport_expand.dart';
import '../../../../widget/status/custom_load_state_view.dart';
import '../../../../widget/status/load_state_config.dart';
import '../../common_model/sport_common_params.dart';
import '../../common_widget/sport_event_count_widget.dart';
import '../../common_model/sport_game_model.dart';
import '../../sport_event_ranking/sport_event_ranking_view.dart';
import '../bottom_rank/view.dart';
import 'sport_all_logic.dart';

///体育赛事-tab-全部足球[篮球、网球等等]
class SportAllPage extends StatelessWidget {
  SportAllPage({Key? key, required this.pageTag, required this.params})
      : logic = Get.put<SportAllLogic>(SportAllLogic(params), tag: pageTag),
  // state = Get.find<SportAllLogic>(tag: pageTag).state,
        super(key: key);

  final String pageTag;
  final SportAllLogic logic;

  // final state;
  final SportOpenPageParams params;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() {
            return CustomLoadStateLayout(
              configType: LoadStateConfigType.sport,
              configState: logic.allSportPageStateObs.value,
              showEmptyRetry: false,
              showErrorRetry: false,
              configSuccess: ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: _buildAllGameView(),
              ),
            );
          }),
          _buildRankingTabView(),
        ],
      ),
    );
  }

  ///体育赛事 内嵌的排行榜tabView，包括：所有投注、风云榜、竞赛排行榜
  _buildRankingTabView() {
    return BottomRankPage();
    return SportEventRankingPage();
  }

  _buildAllGameView() {
    //列表数据
    List<SportGameModel> modelList = logic.apiDataModel.value.list;
    return modelList.map((gameModel) {
      return CustomSportExpand(
        isExpanded: gameModel == modelList.first,
        titlePadding: EdgeInsets.symmetric(
          vertical: AppValues.sportPadding_12.w,
          horizontal: AppValues.sportPadding_10.w,
        ),
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(bottom: AppValues.margin_12),
        childrenPadding: EdgeInsets.only(bottom: AppValues.sportPadding_8.h),
        // margin: EdgeInsets.only(
        //   left: AppValues.sportPadding_12.w,
        //   right: AppValues.sportPadding_12.w,
        // ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomNetWorkImage(
              imageUrl: "${AppUrlsValues.envConfig.asset_url}${gameModel.ppic}",
              width: SportCommonConfig.countryIconSize,
              height: SportCommonConfig.countryIconSize,
              errorWidget: const CustomAssetIcon(
                name: SportCommonConfig.countryIconAsset,
                size: SportCommonConfig.countryIconSize,
              ),
            ),
            SizedBox(width: 6),
            CustomText(gameModel.pgn ?? '',
                style: ThemeService()
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: AppThemes.textColorSecondary)),
          ],
        ),

        ///数量
        countWidget: SportEventCountWidget(
          count: gameModel.cl != null ? gameModel.cl!.length.toString() : "",
          // count: gameModel.c.toString(),
          // count: gameModel.c.toString(),
        ),
        decoration: BoxDecoration(
          // color: ThemeService().theme.colorScheme.surfaceVariant,
          color: ThemeService().theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppValues.sportRadius_4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25), // 阴影颜色，这里使用黑色
              offset: Offset(1, 2), // 阴影偏移量，右下方向
              blurRadius: 1, // 阴影模糊程度
              spreadRadius: 0, // 阴影扩展程度
            ),
          ],
        ),
        trailing: FaIcon(
          FontAwesomeIcons.angleDown,
          size: 9.41.w,
        ),
        // titlePadding: EdgeInsets.only(bottom: 12.h),
        // childrenPadding: EdgeInsets.only(bottom: 19.h),
        // controller: expandableWidgetController2,

        children: [
          // CustomSportOdd(OddContestType.rolling, const [OddCountType.two], widget.section,0,
          //     widget.sportBetClick),
          // CustomSportOdd(OddContestType.rolling, const [OddCountType.three], widget.section,1,
          //     widget.sportBetClick),
          CustomDividerWidget(),
          SizedBox(height: 8.h),
          Column(
            children: [
              ...gameModel.cl!
                  .map((itemModel) => _buildItemGameView(gameModel.pgid ?? "", itemModel))
                  .toList(),
            ],
          ),
        ],
      );
    }).toList();
  }

  ///全部体育赛事 二级列表,
  _buildItemGameView(String pgid, SportGameItemModel model) {
    return InkWell(
      onTap: () => logic.onClickToPage(pgid, model),
      child: Container(
        height: AppValues.sportHeight_42,
        margin: EdgeInsets.symmetric(
          horizontal: AppValues.sportPadding_16.w,
          vertical: AppValues.sportPadding_4.w,
        ),
        color: ThemeService().theme.colorScheme.tertiary,
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: AppValues.sportPadding_16.w),
            // Container(
            //   width: AppValues.sportHeight_24,
            //   height: AppValues.sportHeight_24,
            //   color: AppThemes.secondaryIconColor,
            // ),
            // SizedBox(width: AppValues.sportPadding_8.w),
            Expanded(
              child: CustomText(
                '${model.cn}（${model.ci}）',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: ThemeService()
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
