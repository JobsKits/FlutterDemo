import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/utils/function.dart';
import 'package:flutter_bet/utils/json_util.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../utils/time/time_format.dart';
import '../../../utils/time/time_utils.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/sport/custom_sport_expand/custom_sport_expand.dart';
import '../../../../widget/sport/custom_sport_expand/custom_sport_expand_controller.dart';
import '../../../../widget/sport/custom_sport_odd/custom_sport_odd_two.dart';
import '../../../../widget/sport/custom_sport_odd_type.dart';
import '../../../constant/app_urls_values.dart';
import '../common_model/sport_common_params.dart';
import '../common_model/sport_game_model.dart';
import '../common_model/sport_handicap.dart';
import '../common_model/sport_handicap_select_model.dart';
import '../sport_detail/model.dart';
import '../sport_detail/view.dart';

///滚球与即将开赛 -赛事标题 - 单个Expend扩展view
class CustomSportOpeningListExpendWidget extends StatefulWidget {
  const CustomSportOpeningListExpendWidget({
    super.key,
    required this.sportId,
    required this.gameModel,
    required this.sportBetClick,
    required this.section,
    this.isExpend = true,
    // this.handicapType = SportHandicapType.hsHandicap, //默认，获胜盘
    this.handicapType, //默认，获胜盘
    this.onItemExpend,
  });

  final int sportId;
  final SportGameModel gameModel; //体育类别赛事 下所有的比赛 model
  // final SportMatchModel openingModel; //体育类别赛事 下所有的比赛 model
  final SportBetClick sportBetClick; //点击回调
  final int section;
  final bool isExpend; //是否展开
  // final SportHandicapType handicapType; //盘口类型
  final Handicap? handicapType; //盘口类型
  final ParamSingleCallback<SportGameParams>? onItemExpend;

  @override
  State<CustomSportOpeningListExpendWidget> createState() =>
      _CustomSportOpeningListExpendWidgetState();
}

class _CustomSportOpeningListExpendWidgetState extends State<CustomSportOpeningListExpendWidget> {
  late CustomSportExpandController controller;
  final isFirstItemExpend = true.obs;

  @override
  void initState() {
    super.initState();
    controller = CustomSportExpandController(isExpanded: widget.isExpend);
    isFirstItemExpend.value = widget.isExpend;
    controller.addListener(() {
      //如果点击张开, 且没有数据的。 有数据不在加载网络
      if (controller.isExpanded) {
        isFirstItemExpend.value = true;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  //二级张开时，请求网络数据, 需要返回数据
  @override
  Widget build(BuildContext context) {
    return _buildExpendView(widget.gameModel);
  }

  _buildExpendView(SportGameModel model) {
    return Container(
      padding: EdgeInsets.only(
        // left: AppValues.sportPadding_12.w,
        // right: AppValues.sportPadding_12.w,
        // top: AppValues.sportPadding_10.w,
        bottom: AppValues.sportPadding_10.w,
      ),
      child: CustomSportExpand(
        isExpanded: widget.isExpend,
        controller: controller,
        // expandDuration: const Duration(milliseconds: 100),
        // trailingDuration: const Duration(milliseconds: 100),
        padding: EdgeInsets.only(
          left: AppValues.sportPadding_12.w,
          right: AppValues.sportPadding_12.w,
          top: AppValues.sportPadding_12.h,
          bottom: 0,
        ),
        title: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // CustomAssetIcon(name: "assets/images/sport/ic_sport_area_world.webp", size: 14),
              CustomNetWorkImage(
                imageUrl: "${AppUrlsValues.envConfig.asset_url}${widget.gameModel.ppic}",
                width: SportCommonConfig.countryIconSize,
                height: SportCommonConfig.countryIconSize,
                errorWidget: const CustomAssetIcon(
                  name: SportCommonConfig.countryIconAsset,
                  size: SportCommonConfig.countryIconSize,
                ),
              ),
              SizedBox(width: 6),
              Container(
                // width: 230,
                child: CustomText(
                  widget.gameModel.pgn ?? '',
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ThemeService().theme.textTheme.bodyMedium!.copyWith(
                        color: AppThemes.textColorSecondary,
                      ),
                ),
              ),
            ],
          ),
        ),

        ///数量
        countWidget: Container(
            padding: EdgeInsets.only(
              left: AppValues.sportHeight_7.w,
              right: AppValues.sportHeight_7.w,
              top: AppValues.sportHeight_2.h,
              bottom: AppValues.sportHeight_2.h,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                // Adjust the radius value as needed
                color: ThemeService().colorScheme.tertiary //Background color
                ),
            child: CustomText(
              widget.gameModel.c.toString(),
              style: const TextStyle(
                  color: AppThemes.textColorSecondary, fontSize: AppValues.fontBodySmallSize),
            )),
        // Text(((e.value["cl"] as List).first as Map)["cn"]

        decoration: BoxDecoration(
          // color: ThemeService().theme.colorScheme.surfaceVariant,
          color: ThemeService().theme.colorScheme.surface,
          // color: ThemeService().theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(AppValues.sportRadius_4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25), // 阴影颜色，这里使用黑色
              offset: Offset(3, 3), // 阴影偏移量，右下方向
              blurRadius: 10, // 阴影模糊程度
              spreadRadius: 0, // 阴影扩展程度
            ),
          ],
        ),
        trailing: FaIcon(
          FontAwesomeIcons.angleDown,
          size: 9.41.w,
        ),
        titlePadding: EdgeInsets.only(bottom: 14.5.h),
        // children: [
        //   _buildExpendTime(model.ed),
        //   ..._buildExpendDetail(model),
        //   _buildExpendMore(),
        // ],
        children: _buildExpendDetail(model.cl!),
        // children: [Container()],
      ),
    );
  }

  _buildExpendDetail(List<SportGameItemModel> modelList) {
    return modelList.asMap().entries.map((k) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///多个联赛 赛事 列表 比分
          Obx(() {
            return SportOddExpendListView(
              model: k.value,
              section: widget.section,
              // isExpend: widget.isExpend && k.key == 0,
              isExpend: isFirstItemExpend.value && k.key == 0,
              sportBetClick: widget.sportBetClick,
              handicapType: widget.handicapType,
              // 请求参数封装
              params: SportGameParams(
                si: widget.sportId,
                m: SportMarketApiType.comingAndRolling.type,
                pgid: widget.gameModel.pgid ?? "", //地区id
                ci: <String>[k.value.ci ?? ""], //联赛ID
              ),
              loadDataCallBack: widget.onItemExpend,
            );
          }),
          SizedBox(height: 10),
          // ///分割线
          // Container(
          //   height: 2,
          //   color: Color(0xFF2F4553),
          // ),
        ],
      );
    }).toList();
  }

  _buildExpendMore() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Color(0xFF2F4553),
      child: Row(
        children: [
          CustomText(
            S.current.sport_add_more,
            style: ThemeService()
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Spacer(),
        ],
      ),
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Color(0xFF2F4553),
      child: CustomText(
        S.current.sport_add_more,
        style: ThemeService().textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
/*=============================SportOddExpendListView===================================*/

///二级列表 打开 三级
class SportOddExpendListView extends StatefulWidget {
  const SportOddExpendListView({
    super.key,
    required this.model, //体育类别赛事 下所有的比赛 model
    required this.sportBetClick,
    required this.section,
    required this.params,
    required this.handicapType,
    required this.loadDataCallBack,
    this.isExpend = false, //默认打开
  });

  final SportGameItemModel model;
  final SportBetClick sportBetClick;
  final int section;
  final SportGameParams params; //请求参数
  // final SportHandicapType handicapType; //盘口类型
  final Handicap? handicapType; //盘口类型
  final bool isExpend; //是否展开
  final ParamSingleCallback<SportGameParams>? loadDataCallBack; //请求网络数据

  @override
  State<SportOddExpendListView> createState() => _SportOddExpendListViewState();
}

class _SportOddExpendListViewState extends State<SportOddExpendListView> {
  final openingModel = SportMatchModel().obs;

  // final SportOpeningLogic logic = Get.find<SportOpeningLogic>();
  final modelList = <SportMatchModel>[].obs;
  late CustomSportExpandController controller;

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
    }

    //监听是否手动执行展开
    controller.addListener(() {
      ///如果需要打开
      if (modelList.isEmpty || (controller.isExpanded && isNeedRequest)) {
        isNeedRequest = false;
        getData();
      }
    });

    //监听数据的变换, 实例监听对象
    ever(dataChangeObs, (value) {
      isNeedRequest = true;
      //过滤调初始值
      if (isAlreadyExpend) {
        log("冠军投注...监听数据的变换...widget.model.hashCode=${widget.model.hashCode}...value...$value");
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
    if (widget.loadDataCallBack != null) {
      modelList.value = await widget.loadDataCallBack!(widget.params);
    }
    // SportGameParams params = widget.params;
    // logic.getListData(params).then((value) {
    //   // openingSportList.refresh();
    //   modelList.value = value;
    // });
  }

  @override
  Widget build(BuildContext context) {
    dataChangeObs.value = widget.model.hashCode;
    return _buildItemExpendView(widget.model);
  }

  ///二级列表 打开 三级
  _buildItemExpendView(SportGameItemModel model) {
    return Container(
      padding: EdgeInsets.only(
          // left: AppValues.sportPadding_6.w,
          // right: AppValues.sportPadding_6.w,
          //   top: AppValues.sportPadding_10.w,
          // bottom: AppValues.sportPadding_10.w,
          ),
      child: CustomSportExpand(
        isExpanded: widget.isExpend,
        // expandDuration: const Duration(milliseconds: 350),
        expandDuration: const Duration(milliseconds: 400),
        trailingDuration: const Duration(milliseconds: 400),
        margin: EdgeInsets.zero,
        padding: EdgeInsets.only(
          // left: AppValues.sportPadding_12.w,
          // right: AppValues.sportPadding_12.w,
          top: AppValues.sportPadding_12.h,
          // bottom: AppValues.sportPadding_12.h,
        ),
        title: Container(
          // height: 40,
          width: 250,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
            left: AppValues.sportPadding_12.w,
            right: AppValues.sportPadding_12.w,
            // top: AppValues.sportPadding_12.h,
            // bottom: AppValues.sportPadding_12.h,
          ),
          child: CustomText(model.cn ?? '',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ThemeService().theme.textTheme.bodyMedium!.copyWith(
                    color: AppThemes.textColorSecondary,
                  )),
        ),
        arrowPadding: EdgeInsets.only(right: 12),

        ///数量
        countWidget: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            left: AppValues.sportHeight_7.w,
            right: AppValues.sportHeight_7.w,
            top: AppValues.sportHeight_2.h,
            bottom: AppValues.sportHeight_2.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0), // Adjust the radius value as needed
            color: ThemeService().colorScheme.tertiary, //Background color
          ),
          child: Text(
            model.c.toString(),
            style: const TextStyle(
                color: AppThemes.textColorSecondary, fontSize: AppValues.fontBodySmallSize),
          ),
        ),

        decoration: BoxDecoration(
          color: ThemeService().theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(AppValues.sportRadius_4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25), // 阴影颜色，这里使用黑色
              offset: Offset(3, 3), // 阴影偏移量，右下方向
              blurRadius: 5, // 阴影模糊程度
              spreadRadius: 0, // 阴影扩展程度
            ),
          ],
        ),
        trailing: FaIcon(
          FontAwesomeIcons.angleDown,
          size: 9.41.w,
        ),
        // childrenPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.only(bottom: 14.5.h),
        children: [
          Obx(() {
            return modelList.isNotEmpty
                ? Column(children: _buildItemSportOddList(modelList))
                : Container();
          }),
        ],
        // ),
        controller: controller,
      ),
    );
  }

  _buildItemSportOddList(List<SportMatchModel> modelList) {
    return modelList
        .map((matchModel) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child:
                  _getSportOddItem(matchModel.m, matchModel.es, matchModel.ml, widget.handicapType),
            ))
        .toList();
  }

  ///获取赔率，需要根据 盘口类型做 过滤
  ///marketType 市场类型 //market 1:早盘 2:今日 3:滚球
  _getSportOddItem(int? marketType, int? eventState, List<Ml>? ml, Handicap? handicapType) {
    Widget? showWidget;
    if (ml != null && ml.isNotEmpty) {
      for (var k in ml.asMap().entries) {
        //需求：过滤处理. 需要改成用 bt 跟egi 都要相同来对应
        int? bt = handicapType?.bt;
        int? egi = handicapType?.egi;
        if (bt != null && egi != null && bt == k.value.bt && egi == k.value.egi) {
          log("滚球盘与即将开赛盘口...赔率...${JsonUtil.encodeObj(k.value)}");
          showWidget = CustomSportOdd(
            // OddContestType.rolling, //coming 、rolling
            const [OddCountType.two],
            widget.section,
            k.key,
            widget.sportBetClick,
            // null,
            S.current.sport_tabbar_rolling,
            // S.current.sport_tabbar_coming,
            marketType: SportMarketApiType.checkMarketType(marketType),
            eventStateType: SportEventStateApiType.checkEventStateType(eventState),
            sportMap: k.value,
            margin2: 75,
            // newDesign: true,
          );
          break;
        }
      }
    }
    return showWidget ?? Container();
    // Container(alignment: Alignment.center, height: 40, child: Text("没有赛事"));
  }

  _buildExpendTime(int? time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Color(0xFF2F4553),
      child: Row(
        children: [
          CustomText(
            getTimeFormat(time),
            style: ThemeService().textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Spacer(),
        ],
      ),
    );
  }

  ///时间格式化
  getTimeFormat(int? time) {
    // print(time);
    // var dataTime =  DateTime.fromMicrosecondsSinceEpoch(time??0);
    var dataTime = DateTime.fromMillisecondsSinceEpoch(time != null ? time * 1000 : 0);
    return TimeUtils.dateTimeToTime(dataTime, YMDzh);
  }
}
