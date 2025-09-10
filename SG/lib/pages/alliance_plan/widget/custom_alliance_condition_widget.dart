import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/utils/json_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/date_util.dart';
import '../../../utils/function.dart';
import '../../../utils/time/time_format.dart';
import '../wmodel/alliance_condition_model.dart';
import 'custom_alliance_search_widget.dart';
import '../../../widget/search/custom_cupertino_search_widget.dart';
import 'custom_select_model.dart';
import 'custom_select_time_two_widget.dart';
import 'custom_select_time_widget.dart';
import 'custom_select_widget.dart';
import 'dart:math' as math;

///联盟计划-页面的种的条件过滤view， 过滤条件包括时间、游戏类型、货币类型
///内容会持有一个 conditionModel
class CustomAllianceConditionWidget extends StatefulWidget {
  const CustomAllianceConditionWidget({
    super.key,
    required this.conditionConfig,
    // this.selectTimeList,
    this.startTimeDefault,
    this.endTimeDefault,
    this.selectTypeList,
    this.selectTypeDefault,
    this.selectCoinList,
    this.selectCoinDefault,
    // this.showCommission = false,
    this.commission,
    this.onAnyOneSelectedCallback,
    this.searchHintText,
  });

  final AllianceConditionConfig conditionConfig; //显示配置
  // final List<CustomSelectModel>? selectTimeList; //时间列表
  final DateTime? startTimeDefault; //默认开始时间
  final DateTime? endTimeDefault; //默认结束时间
  final List<CustomSelectModel>? selectTypeList; //游戏类型列表
  final int? selectCoinDefault; //coin类型 默认
  final int? selectTypeDefault; //游戏类型 默认
  final List<CustomSelectModel>? selectCoinList; //货币类型列表
  // final bool showCommission; //是否显示累积佣金
  final double? commission; //累积佣金

  final String? searchHintText; //搜索提示

  final ParamThreeCallback<dynamic, dynamic, AllianceConditionModel>? onAnyOneSelectedCallback;

  @override
  State<CustomAllianceConditionWidget> createState() => _CustomAllianceConditionWidgetState();
}

class _CustomAllianceConditionWidgetState extends State<CustomAllianceConditionWidget> {
  ///保存数据
  // CustomSelectModel? startTimeModel;
  // CustomSelectModel? endTimeModel;
  //
  // CustomSelectModel? selectTypeModel;
  //
  // CustomSelectModel? selectCoinModel;

  //给上层回调 的model
  final AllianceConditionModel conditionModel = AllianceConditionModel();

  //默认时间 or 动态显示时间
  final _startTimeDefault = Rxn<DateTime>(); //默认开始时间
  final _endTimeDefault = Rxn<DateTime>(); //默认结束时间
  ///结束时间的最大范围，从开始算起，
  ///【1】不能超过三个月， 且不能错过今天。
  ///【2】开始时间 不超过今天即可;
  ///【3】开始时间 距离结束时间超过90天，结束时间90天最后一天
  ///【3】开始时间 超过结束时间，则开始时间和结束时间一样，只查询该天数据,结束时间范围未一天
  static const int maxDays = 90;
  final _minEndTime =
      Rxn<DateTime>(DateTime.now().toLocal().subtract(const Duration(days: maxDays)));
  final _maxEndTime = Rxn<DateTime>(DateTime.now().toLocal());

  @override
  void initState() {
    super.initState();
    _startTimeDefault.value = widget.startTimeDefault;
    _endTimeDefault.value = widget.endTimeDefault;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildConditionViewUp(),
        const SizedBox(height: AppValues.halfMargin),
        // SizedBox(height: AppValues.defaultMargin),
        _buildConditionViewDown(),
        // const SizedBox(height: AppValues.halfMargin),
      ],
    );
  }

  ///任意 一个选中执行回调
  _doOnSelected(AllianceConditionModel conditionModel) {
    if (widget.onAnyOneSelectedCallback != null) {
      widget.onAnyOneSelectedCallback!(null, null, conditionModel);
    }
  }

  ///头部条件：时间、游戏类型
  _buildConditionViewUp() {
    return Row(
      // mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Expanded(
        //     flex: 1,
        //     child: Offstage(
        //       offstage: !widget.conditionConfig.startTime,
        //       child: CustomSelectTimeTwoWidget(
        //         borderShow: false,
        //         width: 120,
        //         startHintText: S.current.sport_event_list_begin_time,
        //         endHintText: S.current.random_text_550,
        //         defaultStartTime: widget.startTimeDefault,
        //         defaultEndTime: widget.endTimeDefault,
        //         onSelected: (dataOne, dataTwo) {
        //           log('时间选择器回调数据...${dataTwo.toString()}');
        //           conditionModel.startTimeModel = dataOne;
        //           conditionModel.endTimeModel = dataTwo;
        //           _doOnSelected(conditionModel);
        //         },
        //       ),
        //     )),

        //【0229需求变更】【app】联盟计划，时间筛选，分开始时间和结束时间两个框
        // 开始时间
        Expanded(
            flex: 1,
            child: Offstage(
              offstage: !widget.conditionConfig.startTime,
              child: CustomSelectTimeWidget(
                timeUtc: true,
                borderShow: false,
                width: 120,
                hintText: S.current.sport_event_list_begin_time,
                defaultTime: widget.startTimeDefault,
                minTime: DateTime.now().toLocal().subtract(const Duration(days: 2000)),
                maxTime: DateTime.now().toLocal(),
                // defaultTime: _startTimeDefault.value,
                timeFormatter: TimeFormatterEnum.start,
                onSelected: (dataOne, dataTwo) {
                  log('start时间选择器回调数据...${dataTwo.toString()}');
                  conditionModel.startTimeModel = dataTwo;
                  _endTimeDefault.value = conditionModel.startTimeModel?.data;
                  var endDateTime = dealMaxEndTime(
                      dataTwo.data, conditionModel.endTimeModel?.data ?? widget.endTimeDefault);
                  if (conditionModel.endTimeModel == null) {
                    conditionModel.endTimeModel =
                        CustomSelectModel(endDateTime.toString(), data: endDateTime);
                  } else {
                    conditionModel.endTimeModel?.label = endDateTime.toString();
                    conditionModel.endTimeModel?.data = endDateTime;
                  }
                  //转换成 utc,查询
                  conditionModel.startTimeModel = copyWithUtc(conditionModel.startTimeModel!);
                  _doOnSelected(conditionModel);
                  log("_endTimeDefault...${_endTimeDefault.value}");
                },
              ),
            )),
        SizedBox(width: AppValues.largeMargin),
        // 结束时间
        Expanded(
          flex: 1,
          child: Offstage(
            offstage: !widget.conditionConfig.endTime,
            child: Obx(() {
              return CustomSelectTimeWidget(
                timeUtc: true,
                borderShow: false,
                width: 120,
                hintText: S.current.random_text_550,
                // defaultTime: widget.endTimeDefault,
                // defaultTime: conditionModel.startTimeModel?.data,
                defaultTime: _endTimeDefault.value ?? widget.endTimeDefault,
                minTime: _minEndTime.value,
                maxTime: _maxEndTime.value,
                timeFormatter: TimeFormatterEnum.end,
                onSelected: (dataOne, dataTwo) {
                  log('end时间选择器回调数据...${dataTwo.toString()}');
                  // "start_time": "2024-01-21 00:00:00",
                  // "end_time": "2024-01-23 23:59:59",
                  //针对 结束时间做特殊处理
                  // String? dealEndTime =DateUtil.formatDate(dataTwo, format: 'yyyy-MM-dd 23:59:59');
                  // DateTime.parse(DateUtil.formatDate(dataTwo, format: 'yyyy-MM-dd 23:59:59'));
                  // conditionModel.endTimeModel = dataTwo;
                  //转换成 utc,查询
                  conditionModel.endTimeModel = copyWithUtc(dataTwo);
                  _doOnSelected(conditionModel);
                },
              );
            }),
          ),
        ),

        // SizedBox(width: AppValues.halfMargin),
      ],
    );
  }

  ///转换成 utc, 因为后端 存储 是utc+0, 在执行搜索时，需要转换成utc+0，显示不用
  CustomSelectModel copyWithUtc(CustomSelectModel model) {
    var dateTimeUtc =
        DateUtil.getDateTimeByMs((model.data as DateTime).millisecondsSinceEpoch, isUtc: true);
    var timeModelUtc = CustomSelectModel(model.label, type: model.type, data: dateTimeUtc);
    // log("model...${model.toString()}");
    // log("timeModelUtc...${timeModelUtc.toString()}");
    return timeModelUtc;
  }

  ///货币类型、累积佣金
  _buildConditionViewDown() {
    return Container(
      // padding: EdgeInsets.only(left: 12, top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: widget.conditionConfig.coinType ? 1 : 0,
            child: Offstage(
              offstage: !widget.conditionConfig.coinType,
              child: CustomSelectWidget(
                borderShow: false,
                // width: 130,
                width: Get.width,
                panelRatio: 0.95,
                scaleAmin: false,
                modelList: widget.selectCoinList,
                // initSelected: null,
                initSelected: widget.selectCoinDefault,
                hintText: "",
                backgroundColor: Colors.white,
                selectColor: Colors.white,
                unselectColor: ThemeService().colorScheme.tertiary,
                selectColorFull: AppThemes.secondaryColor,
                onSelected: (index, model) {
                  conditionModel.selectCoinModel = model;
                  _doOnSelected(conditionModel);
                },
                // rightIcon: CustomExpandIcon(onPressed: (bool value) {  } ),
              ),
            ),
          ),
          // Spacer(),
          // Offstage(
          //   offstage: !widget.conditionConfig.showCommission,
          //   child: Row(
          //     children: [
          //       CustomText(S.current.random_text_189,
          //           style:
          //               ThemeService().textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
          //       CustomText("${widget.commission ?? 0.00}",
          //           style: ThemeService()
          //               .textTheme
          //               .bodyMedium!
          //               .copyWith(color: AppThemes.scoreTextColor)),
          //       SizedBox(width: AppValues.margin_4)
          //     ],
          //   ),
          // ),

          Offstage(
              offstage: !widget.conditionConfig.coinType,
              child: const SizedBox(width: AppValues.largeMargin)),
          Expanded(
            child: Stack(
              children: [
                Offstage(
                  offstage: !widget.conditionConfig.search,
                  child: CustomAllianceSearchWidget(
                    borderShow: false,
                    // width: 90,
                    width: Get.width,
                    hintText: widget.searchHintText ?? S.current.random_text_551,
                    hintStyle: ThemeService().textTheme.labelMedium?.copyWith(
                        fontSize: 14, fontWeight: FontWeight.w500, fontFamily: "PingFang SC"),
                    callback: (input) {
                      log('搜索回调...$input');
                      conditionModel.searchModel =
                          CustomSelectModel(S.current.random_text_552, data: input.trim());
                      _doOnSelected(conditionModel);
                    },
                  ),
                  // child: CustomCupertinoSearchWidget(
                  //   onStringCallback: (String value) {
                  //     log('搜索回调...$value');
                  //     conditionModel.searchModel = CustomSelectModel('关键字', data: value.trim());
                  //     _doOnSelected(conditionModel);
                  //   },
                  // ),
                ),
                //体育类型
                Offstage(
                  offstage: !widget.conditionConfig.sportType,
                  child: CustomSelectWidget(
                    borderShow: false,
                    width: Get.width,
                    //变态的适配， 类型中数据是后台数据给的翻译结果， 可长， 可短， 结合多语言，够变态的。
                    //中文，英文中的item , 长度比较理想，其他语言变态的长。
                    //比如："原创游戏，捕鱼"，"Trò chơi nguyên bản, Bắn cá"
                    // panelRatio: !(LangService().isVi && isLargeLine()) ? 0.95 : 1.4,
                    panelRatio: 0.95,
                    panelRatioCallback: (size, panelRatio) {
                      double? itemMaxWidth = getItemMaxWidth(widget.selectTypeList);
                      //如果最大长度大于配置， 就自动拉宽
                      if (itemMaxWidth != null && itemMaxWidth > size.width * panelRatio) {
                        // log("panelRatioCallback...size...$size");
                        // log("panelRatioCallback...width...${size.width * panelRatio}");
                        // log("panelRatioCallback...itemMaxWidth...$itemMaxWidth");
                        return itemMaxWidth / size.width;
                      }
                      return panelRatio;
                    },
                    // dxWidth: 12,
                    positionedRight: 12,
                    arrowBasisOffset: !(LangService().isVi && isLargeLine()) ? 0.0 : 20,
                    // arrowBasisOffset: !isLargeLine() ? 0.0 : 50,
                    scaleAmin: false,
                    modelList: widget.selectTypeList,
                    initSelected: widget.selectTypeDefault,
                    hintText: "",
                    backgroundColor: Colors.white,
                    selectColor: Colors.white,
                    unselectColor: ThemeService().colorScheme.tertiary,
                    selectColorFull: AppThemes.secondaryColor,
                    onSelected: (index, model) {
                      conditionModel.selectTypeModel = model;
                      _doOnSelected(conditionModel);
                    },
                    // rightIcon: CustomExpandIcon(onPressed: (bool value) {  } ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///为了多语言适配， 一行显示。比如："原创游戏，捕鱼"，"Trò chơi nguyên bản, Bắn cá"
  bool isLargeLine() {
    return widget.selectTypeList?.any((element) => element.label.contains(",")) ?? false;
  }

  void initLanguageAdapter() {
    var tempList = widget.selectTypeList;
    tempList?.sort((a, b) => a.label.length.compareTo(b.label.length));
    var model = tempList?.last;
  }

  ///计算item最大长度
  double? getItemMaxWidth(List<CustomSelectModel>? list,
      {double textSize = 14, double padding = 8}) {
    if (list == null || list.isEmpty) {
      return null;
    }
    var tempList = <CustomSelectModel>[];
    tempList.assignAll(list);
    tempList.sort((a, b) => a.label.length.compareTo(b.label.length));
    var width = tempList.last.label.length * (textSize.sp);
    var itemWidthFinal = width + padding;
    return LangService().isChinese ? itemWidthFinal : itemWidthFinal / 2;
  }

  ///计算字体像素
  void countTextPs(int textSize) {
    var scaleText = ScreenUtil().scaleText;
    var screenWidth = ScreenUtil().screenWidth;
    var getWidth = Get.width;
    var textCount = (Get.width - 10) / textSize.sp * scaleText;
    // log("scaleText...$scaleText");
    // log("screenWidth...$screenWidth,,,getWidth...$getWidth,,,textCount...$textCount");
  }

  /// 结束时间组件， 最小 和 最大 范围控制
  /// 返回需要更新查询的 endTime
  DateTime dealMaxEndTime(DateTime startTime, DateTime? endTime) {
    var dataTimeNow = DateTime.parse(
        DateUtil.formatDate(DateTime.now(), format: TimeFormatterEnum.end.formatter));
    var currentEndTime = endTime ?? dataTimeNow;

    // 开始时间与结束时间的距离
    var inDays = startTime.difference(currentEndTime).inDays;
    // 开始时间距离现在时间的距离，为了结束时间控制在90天之内
    int inDaysNow = startTime.difference(dataTimeNow).inDays;
    var showEndTime;
    log("currentEndTime...$currentEndTime");
    log("inDays...$inDays,,,inDaysNow....$inDaysNow");
    if (inDays <= -maxDays) {
      //比如<=-90
      _minEndTime.value = startTime;
      _maxEndTime.value = startTime.add(const Duration(days: maxDays));
      _endTimeDefault.value = _maxEndTime.value;
      showEndTime = _maxEndTime.value;
    } else if (inDays >= 0) {
      //两种情况： =1，=0  等于或者超过结束时间
      // "start_time": "2024-01-21 00:00:00",
      // "end_time": "2024-01-21 23:59:59",
      //这种情况inDays == 0
      _minEndTime.value = startTime;
      //结束时间自动延后
      _maxEndTime.value =
          inDaysNow.abs() >= maxDays ? startTime.add(const Duration(days: maxDays)) : dataTimeNow;
      _endTimeDefault.value = startTime;
      showEndTime = startTime;
    } else {
      //在合理的90天之内
      // _maxEndTime.value = DateTime.now();
      // _minEndTime.value = startTime;
      //结束时间自动延后
      _minEndTime.value = startTime;
      _maxEndTime.value =
          inDaysNow.abs() >= maxDays ? startTime.add(const Duration(days: maxDays)) : dataTimeNow;
      ;
      _endTimeDefault.value = currentEndTime;
      showEndTime = currentEndTime;
    }
    return DateTime.parse(
        DateUtil.formatDate(showEndTime, format: TimeFormatterEnum.end.formatter));
  }
}

///多语言适配 config
class _SelectConfig {
  bool isLargeLine;
  double panelRatio;
  double arrowBasisOffset;

  _SelectConfig({
    required this.isLargeLine,
    required this.panelRatio,
    required this.arrowBasisOffset,
  });
}
