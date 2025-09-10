import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/sport/common_model/sport_outrihgt_api_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/function.dart';
import '../../../widget/custom_divider_widget.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/sport/custom_sport_expand/custom_sport_expand.dart';
import 'sport_event_count_widget.dart';

/*=============================某个联赛 冠军投注列表===============================*/

/// 单个地区 或者联赛 冠军投注
/// 用于到[CustomSportOpeningListExpendWidget] 或者 [SportBettingPage] 的单个赛事
class OneLeagueOutrightExpendWidget extends StatelessWidget {
  final int id;
  final String ei; //赛事ID
  final String title;
  final String subTitle;
  final String time;
  final int count;
  final SportOutRightModel model;
  final List? dataList;
  final ParamSingleCallback<SportOutRightModel>? clickCallBack;

  OneLeagueOutrightExpendWidget({super.key, required this.model,this.dataList, this.clickCallBack})
      :
        //构造方法，数据初始化
        id = model.si ?? 0,
        ei = model.ei ?? "",
        title = model.cn ?? "",
        subTitle = model.oen ?? "",
        time = "",
        count = model.ml.isNotEmpty? model.ml[0].ms.length:0;///不是取 model.mc， 而是取model.ml .ms 列表数量

  @override
  Widget build(BuildContext context) {
    return _buildInsideExpendView(
      id: id,
      ei: ei,
      title: title,
      subTitle: subTitle,
      time: time,
      count: count,
    );
  }

  ///内部嵌套二级 扩展列表
  Widget _buildInsideExpendView({
    required int id,
    // required String ci;//
    // "ei": "54089692", //赛事ID
    required String ei,
    required String title,
    required String subTitle,
    required String time,
    required int count,
  }) {
    return CustomSportExpand(
      isExpanded: true,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: 10),
      childrenPadding: EdgeInsets.only(bottom: AppValues.sportPadding_8.h),
      title: CustomText(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: ThemeService()
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      ///数量
      countWidget: SportEventCountWidget(
        count:dataList!.isNotEmpty ? dataList!.length.toString():'1',
      ),
      titlePadding: EdgeInsets.symmetric(
        vertical: AppValues.sportPadding_12.w,
        horizontal: AppValues.sportPadding_10.w,
      ),
      decoration: BoxDecoration(
        // color: ThemeService().theme.colorScheme.surfaceVariant,
        // color: ThemeService().theme.colorScheme.surface,
        color: ThemeService().theme.colorScheme.tertiary,
        borderRadius: BorderRadius.circular(AppValues.sportRadius_4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25), // 阴影颜色，这里使用黑色
            offset: const Offset(3, 3), // 阴影偏移量，右下方向
            blurRadius: 10, // 阴影模糊程度
            spreadRadius: 0, // 阴影扩展程度
          ),
        ],
      ),
      trailing: FaIcon(
        FontAwesomeIcons.angleDown,
        size: 9.41.w,
      ),

      ///展开的内容
      children: dataList!.isNotEmpty ? dataList!.map((e) => _item(e)).toList() : [_singleItem()],
    );
  }

  Widget _item(SportOutRightModel model) {
    return Column(
      children: [
        const CustomDividerWidget(height: 2, color: Color(0xFF557086)),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () {
            log("点击了...冠军赛事...");
            clickCallBack != null ? clickCallBack!(model) : null;
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: AppValues.sportPadding_20.w),
            color: ThemeService().theme.colorScheme.tertiary,
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        // "${model.sn} id:${model.sid}" ,
                        model.oen??'',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap:true,
                        textAlign: TextAlign.start,
                        style: ThemeService().textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    // Spacer(),
                    const SizedBox(width: 12),
                    CustomText(
                      // "${model.sn} id:${model.sid}" ,
                      model.ml.isNotEmpty? '+${model.ml[0].ms.length}':'0',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: ThemeService().textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFFB1BAD3),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                CustomText(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: ThemeService().textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFB1BAD3),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _singleItem() {
    return Column(
      children: [
        const CustomDividerWidget(height: 2, color: Color(0xFF557086)),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () {
            log("点击了...冠军赛事...");
            clickCallBack != null ? clickCallBack!(model) : null;
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: AppValues.sportPadding_20.w),
            color: ThemeService().theme.colorScheme.tertiary,
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        // "${model.sn} id:${model.sid}" ,
                        subTitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap:true,
                        textAlign: TextAlign.start,
                        style: ThemeService().textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    // Spacer(),
                    const SizedBox(width: 12),
                    CustomText(
                      // "${model.sn} id:${model.sid}" ,
                      "+$count",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: ThemeService().textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFFB1BAD3),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                CustomText(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: ThemeService().textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFB1BAD3),
                        fontWeight: FontWeight.w500,
                      ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
