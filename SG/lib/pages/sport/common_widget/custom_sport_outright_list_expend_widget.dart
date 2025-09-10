import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/function.dart';
import '../../../utils/time/time_format.dart';
import '../../../utils/time/time_utils.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_divider_widget.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/sport/custom_sport_expand/custom_sport_expand.dart';
import '../../../../widget/sport/custom_sport_expand/custom_sport_expand_controller.dart';
import '../../../constant/app_urls_values.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../common_model/sport_common_params.dart';
import 'sport_event_count_widget.dart';
import '../common_model/sport_game_model.dart';
import '../common_model/sport_outrihgt_api_model.dart';
import 'custom_sport_outrihgt_one_expend_widget.dart';

/*=============================一个地区 冠军投注列表===============================*/

/// 某个地区下 或者联赛 所有冠军投注列表
/// 里面会使用到 子扩展[OneLeagueOutrightExpendWidget]
class OneAreaOutrightExpendWidget extends StatefulWidget {
  const OneAreaOutrightExpendWidget({
    super.key,
    required this.si,
    required this.ci,
    required this.openType,
    required this.model,
    required this.loadDataCallBack,
    this.clickCallBack,
    this.isExpend = false,
  });

  final bool isExpend; //是否展开,默认不展开
  final int si; //球种Id
  final String ci; //联赛Id
  final SportOpenType openType; //页面类型
  final SportGameModel model;

  final ParamSingleCallback<SportOutrightParams>? loadDataCallBack; //请求网络数据
  final ParamSingleCallback<SportOutRightModel>? clickCallBack; // 点击回调

  // final  siObs = si.obs; //监听数据
  @override
  State<OneAreaOutrightExpendWidget> createState() => _OneAreaOutrightExpendWidgetState();
}

class _OneAreaOutrightExpendWidgetState extends State<OneAreaOutrightExpendWidget> {
  late CustomSportExpandController controller;
  final championListObs = <SportOutRightModel>[].obs; //请求后的数据
  final newList = [].obs;
  // final Rx<int> dataChangeObs = 0.obs; //监听数据model的 hashCode
  bool isAlreadyExpend = false; //是否已经打开
  bool isNeedRequest = false; //是否数据发生变化,是否需要请求网络数据
  final dataChangeObs = Rxn<int>(); //观察数据


  @override
  void initState() {
    super.initState();
    controller = CustomSportExpandController(isExpanded: widget.isExpend);
    //第一次进来，不会自动监听到，所以判断手动加载数据
    if (widget.isExpend) {
      getData();
      isAlreadyExpend = true;
    }
    //监听是否手动执行展开
    controller.addListener(() {
      //如果点击张开, 且没有数据的。 有数据不在加载网络
      if (championListObs.isEmpty || (controller.isExpanded && isNeedRequest)) {
        log("冠军投注...请求数据...");
        isNeedRequest = false;
        getData();
      }
      isAlreadyExpend = controller.isExpanded;
      log("冠军投注...开关监听...");
    });

    //监听数据的变换, 实例监听对象
    ever(dataChangeObs, (value) {
      isNeedRequest = true;
      //过滤调初始值
      if (isAlreadyExpend) {
        log("冠军投注...监听数据的变换...");
        getData();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ///点击获取数据
  getData() async {
    // logic.getOutrightListData(si: widget.si, pgid: widget.model.pgid, ci: widget.ci).then((data) {
    //   log("冠军投注...下拉...${JsonUtil.encodeObj(data)}");
    //   championListObs.value = data;
    // });
    var params = SportOutrightParams(
      si: widget.si,
      pgid: widget.model.pgid,
      ci: widget.ci,
    );
    if (widget.loadDataCallBack != null) {
      championListObs.value = await widget.loadDataCallBack!(params);
      championListObs.value = championListObs.where((element) => element.pgid == widget.model.pgid).toList();
      var obj={},newArr=[];
      for (var element in championListObs) {
        if (obj[element.ci] == null) {
          var arr = [];
          arr.add(element);
          newArr.add(arr);
          obj[element.ci] = element;
        } else {
          for (List temps in newArr) {
            if (temps.first.ci == element.ci) {
              temps.add(element);
            }
          }
        }
      }
      newList.value = newArr;
    }
  }

  //冠军
  @override
  Widget build(BuildContext context) {
    // siObs.value = widget.model.pgid.hashCode;
    dataChangeObs.value = widget.model.hashCode;
    // log("冠军投注...监听数据的变换...widget.model.hashCode=${widget.modelObs.value}...value...");
    return _buildOneAreaBettingView(widget.model, widget.isExpend);
  }

  //单个地区 下所有冠军投注列表
  _buildOneAreaBettingView(SportGameModel bigItemModel, bool isExpend) {
    return CustomSportExpand(
      isExpanded: isExpend,
      controller: controller,
      margin: EdgeInsets.only(bottom: AppValues.sportPadding_12.h),
      padding: EdgeInsets.zero,
      // childrenPadding: EdgeInsets.only(bottom: AppValues.sportPadding_8.h),
      titlePadding: EdgeInsets.symmetric(
        vertical: AppValues.sportPadding_12.w,
        horizontal: AppValues.sportPadding_10.w,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomNetWorkImage(
            imageUrl: "${AppUrlsValues.envConfig.asset_url}${bigItemModel.ppic}",
            width: SportCommonConfig.countryIconSize,
            height: SportCommonConfig.countryIconSize,
            errorWidget: const CustomAssetIcon(
              name: SportCommonConfig.countryIconAsset,
              size: SportCommonConfig.countryIconSize,
            ),
          ),
          const SizedBox(width: 6),
          CustomText(
            bigItemModel.pgn ?? '',
            style: ThemeService().textTheme.bodyMedium!.copyWith(
                  color: AppThemes.textColorSecondary,
                ),
          ),
        ],
      ),
      ///数量
      countWidget: SportEventCountWidget(
        count: bigItemModel.c.toString(),
        // count: gameModel.c.toString(),
      ),
      decoration: BoxDecoration(
        // color: ThemeService().theme.colorScheme.surfaceVariant,
        color: ThemeService().theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppValues.sportRadius_4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25), // 阴影颜色，这里使用黑色
            offset: const Offset(1, 2), // 阴影偏移量，右下方向
            blurRadius: 1, // 阴影模糊程度
            spreadRadius: 0, // 阴影扩展程度
          ),
        ],
      ),
      trailing: FaIcon(
        FontAwesomeIcons.angleDown,
        size: 9.41.w,
      ),
      children: [
        const CustomDividerWidget(height: 2, color: Color(0xFF2F4553)),
        SizedBox(height: 8.h),
        Container(
          color: ThemeService().theme.colorScheme.surface,
          margin: EdgeInsets.symmetric(horizontal: AppValues.sportPadding_16.w),
          // color: ThemeService().theme.colorScheme.tertiary,
          child: _getSubListView(),
        ),
      ],
    );
  }

  _getSubListView() {
    return Obx(() {
      return Column(
        children: [
          ...newList.map((list) {
            // _buildInsideExpendView
            return OneLeagueOutrightExpendWidget(
              model: list.first,
              dataList: list,
              clickCallBack: widget.clickCallBack,
            );
          }).toList()
        ],
      );
    });
  }

  ///时间格式化
  String getTimeFormat(int? time) {
    // print(time);
    // var dataTime =  DateTime.fromMicrosecondsSinceEpoch(time??0);
    var dataTime = DateTime.fromMillisecondsSinceEpoch(time != null ? time * 1000 : 0);
    return TimeUtils.dateTimeToTime(dataTime, YMDzh);
  }
}
