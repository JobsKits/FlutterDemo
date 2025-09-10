import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/pages/sport/common_model/sport_common_params.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/sport/custom_sport_expand/custom_sport_expand.dart';
import '../../../widget/sport/custom_sport_odd/custom_sport_odd_two.dart';
import '../../../widget/sport/custom_sport_odd_type.dart';
import 'sport_event_count_widget.dart';
import '../common_model/sport_handicap.dart';
import '../common_model/sport_handicap_select_model.dart';
import '../common_helper/sport_util.dart';
import '../sport_detail/model.dart';

///某一个联赛 扩展列表
class CustomSportOpeningOneExpendWidget extends StatelessWidget {
  CustomSportOpeningOneExpendWidget({
    super.key,
    required this.modelList, //体育类别赛事 下所有的比赛 model
    required this.sportBetClick,
    // required this.section,
    // this.handicapType = SportHandicapType.hsHandicap, //默认，获胜盘
    this.handicapType, //默认，获胜盘
    this.title = "",
    this.isExpend = true,
  });

  final List<SportMatchModel> modelList; //某个联赛下，所有的子赛事
  final SportBetClick sportBetClick;

  // final int section;
  final Handicap? handicapType; //盘口类型
  final bool isExpend;
  final String title;

  final _isExpend = false.obs;

  //是否展开
  @override
  Widget build(BuildContext context) {
    _isExpend.value = isExpend;
    return _buildExpendView(modelList);
    // return Container();
  }

  _buildExpendView(List<SportMatchModel>? modelList) {
    return Obx(() {
      return CustomSportExpand(
        isExpanded: _isExpend.value,
        padding: EdgeInsets.zero,
        title: Container(
          // height: 45,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
            left: AppValues.sportPadding_12.w,
            right: AppValues.sportPadding_12.w,
            top: AppValues.sportPadding_12.h,
            bottom: AppValues.sportPadding_12.h,
          ),
          child: CustomText(
            title,
            // "jlsjflajfljaj阿觉得上了飞机失联飞机是否是对粉丝的放松放松房贷首付jlsjflajfljaj阿觉联飞机是否是对粉",
            textAlign: TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: ThemeService().textTheme.labelLarge!.copyWith(
                  color: AppThemes.textColorSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        arrowPadding: EdgeInsets.only(
          // left: AppValues.sportPadding_12.w,
          right: AppValues.sportPadding_12.w,
          // bottom:AppValues.sportPadding_10.w,
          // top: AppValues.sportPadding_12.h,
          // bottom:AppValues.sportPadding_10.w,
        ),

        ///数量
        ///赛事列表页面赛事投注玩法数量取值，我们移动端也取这个MC哈，如果有提单反馈这个MC数量不准，把单子转后端确认即可
        // countWidget: SportEventCountWidget(count: modelList!.length.toString()),
        countWidget: SportEventCountWidget(count: modelList!.length.toString()),
        decoration: BoxDecoration(
          color: ThemeService().theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(AppValues.sportRadius_4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25), // 阴影颜色，这里使用黑色
              offset: const Offset(3, 3), // 阴影偏移量，右下方向
              blurRadius: 5, // 阴影模糊程度
              spreadRadius: 0, // 阴影扩展程度
            ),
          ],
        ),
        trailing: FaIcon(
          FontAwesomeIcons.angleDown,
          size: 9.41.w,
        ),
        children: [
          ...modelList.map((model) {
            return _buildOneItemView(model);
          }).toList()
        ],
        // ),
      );
    });
  }

  _buildOneItemView(SportMatchModel matchModel) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ///显示时间
        _buildExpendTime(matchModel.ed),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
          child: _getSportOddItem(matchModel.m, matchModel.es, matchModel.ml, handicapType,
              matchModel != modelList.first),
        )
      ],
    );
  }

  ///获取赔率，需要根据 盘口类型做 过滤
  ///marketType 市场类型 //market 1:早盘 2:今日 3:滚球
  _getSportOddItem(
      int? marketType, int? eventState, List<Ml>? ml, Handicap? handicapType, bool isSowDivider) {
    Widget? showWidget;
    if (ml != null && ml.isNotEmpty) {
      for (var k in ml.asMap().entries) {
        //需求：过滤处理. 需要改成用 bt 跟egi 都要相同来对应
        int? bt = handicapType?.bt;
        int? egi = handicapType?.egi;
        if (bt != null && egi != null && bt == k.value.bt && egi == k.value.egi) {
          showWidget = CustomSportOdd(
            // OddContestType.rolling, //coming 、rolling
            const [OddCountType.two],
            0,
            k.key,
            sportBetClick,
            S.current.sport_tabbar_rolling,
            marketType: SportMarketApiType.checkMarketType(marketType),
            eventStateType: SportEventStateApiType.checkEventStateType(eventState),
            sportMap: k.value,
            isSowDivider: isSowDivider,
            // margin2: 75,
            // newDesign: true,
          );
          break;
        }
      }
    }
    return showWidget ?? Container();
    // Container(alignment: Alignment.center, height: 40, child: Text("没有赛事"));
  }

  String? lastTimeLabel;

  _buildExpendTime(int? time) {
    var tempList = SportUtil.showSortTime(lastTimeLabel, time ?? 0);
    lastTimeLabel = tempList[1];
    return Visibility(
      visible: tempList[0],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Color(0xFF2F4553),
        child: Row(
          children: [
            CustomText(
              // getTimeFormat(time),
              tempList[1],
              style: ThemeService().textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
