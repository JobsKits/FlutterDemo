import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/pages/alliance_plan/widget/custom_select_model.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/utils/date_util.dart';
import 'package:flutter_bet/utils/function.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/expansion/custom_expand_icon.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/time/time_format.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/custom_text.dart';
import 'custom_select_time_widget_mixin.dart';


///公用下拉框， 联盟计划-所有数据页面 用到
class CustomSelectTimeWidget extends StatefulWidget {
  // CustomTimeSelectWidget({super.key});
  CustomSelectTimeWidget({
    super.key,
    this.width = 200,
    this.height = 40,
    this.defaultTime,
    this.initSelected,
    this.onSelected,
    this.hintText,
    this.assetPath = "",
    this.rightIcon,
    this.panelRatio,
    this.borderShow = true,
    this.timeFormatter,
    this.minTime,
    this.maxTime,
    this.timeUtc = false,
  });

  final double? width; //默认220
  final double? height; //默认40
  // final List<CustomSelectModel>? modelList;
  // final CustomSelectModel? timeModel;
  final DateTime? defaultTime;
  final int? initSelected; //默认选中, 没默认的直接给null
  // final Function(int index, CustomSelectModel model)? onSelected; //选中回调
  final ParamTwiceCallback<int, CustomSelectModel>? onSelected; //选中回调
  final String? hintText; //提示文本
  final String assetPath; //图片路径
  final Widget? rightIcon; //右边图标
  final double? panelRatio; //面板比例，相对于组件，值在0-1
  final bool borderShow; //是否显示边框
  final TimeFormatterEnum? timeFormatter; // 时间返回格式, 默认 current 处理

  ///【0229需求变更】【app】联盟计划，时间查询，限制选择的区间3个月就行了(90天)
  DateTime? minTime; //null 表示可选任意时间点
  DateTime? maxTime; //null 表示可选任意时间点
  int? maxTimeLength; //最长时间

  bool timeUtc; //是否使用世界标准时间； 默认false , 本地时间；主要为了适配 默认的时间

  // DateTime? minTime ;
  // DateTime? maxTime ;

  @override
  State<CustomSelectTimeWidget> createState() => _CustomSelectTimeWidgetState();
}

class _CustomSelectTimeWidgetState extends State<CustomSelectTimeWidget>  with CustomSelectTimeWidgetMixin{
  //主要是给选择下拉组件 一个挂载锚地key, 通过它可以获取组件对象， 并计算获取size 大小，width 和 height
  final GlobalKey selectWidgetGlobalKey = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final bubbleWith = 200.0;

  //使用Rxn<String>(),这个主要目的是，为了兼容外面defaultStartTime 动态赋值，比如套接obx
  final currentLabelObs = Rxn<String>();

  // final currentEndLabelObs = Rxn<String>();
  // String? currentLabel;

  //框度，动态计算
  final double heightOfWidget = 5;

  DateTime? _timeSelected; //选中的时间
  DateTime? _timeDefault; //选中的时间
  CustomSelectModel? _modelSelected; //对外提供的model数据

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  void _resetAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.resetAnimation();
  }

  @override
  void initState() {
    super.initState();

    // ///初始化 默认着
    // if (widget.defaultTime != null) {
    //   currentLabel = getDateTimeStr(widget.defaultTime);
    // }
    widget.minTime ??=
        DateTime.now().toLocal().subtract(Duration(days: widget.maxTimeLength ?? 90));
    widget.maxTime ??= DateTime.now().toLocal();
    //如果是utc 世界标准时间， 需要还原为 本地时间
    //初始化 默认把defaultTime 当作选中
    _timeDefault = _dealTimeDefault();
    _timeSelected = _timeDefault;
    // log("CustomSelectTimeWidget...initState...");
  }

  ///对默认时间进行处理
  DateTime? _dealTimeDefault() {
    return widget.timeUtc ? widget.defaultTime?.toLocal() : widget.defaultTime;
  }

  @override
  Widget build(BuildContext context) {
    //如果defaultTime 有变动的话，如何对timeSelected 进行处理
    //defaultTime 优先级 大于 _timeSelected
    var defaultTimeTemp = _dealTimeDefault();
    if (_timeDefault != defaultTimeTemp) {
      _timeDefault = defaultTimeTemp;
      _timeSelected = _timeDefault;
    }
    currentLabelObs.value = getDateTimeStr(_timeSelected);
    // log("defaultTime...${widget.defaultTime?.toLocal().toString()}");
    // log("timeSelected...${_timeSelected.toString()}");
    return CustomButton(
      padding: EdgeInsets.zero,
      onTap: () {
        _startAnimation(_rotatingArrowKey);
        showDatePicker();
      },

      ///选中 显示
      child: Container(
        key: selectWidgetGlobalKey,
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
            left: AppValues.halfPadding,
            right: AppValues.halfPadding,
            top: AppValues.smallPadding,
            bottom: AppValues.smallPadding),
        // decoration: BoxDecoration(
        //     color: ThemeService().colorScheme.surface,
        //     borderRadius: const BorderRadius.all(Radius.circular(AppValues.smallRadius))),
        decoration: BoxDecoration(
          color: ThemeService().colorScheme.surface,
          border: widget.borderShow
              ? Border.all(color: ThemeService().colorScheme.tertiary, width: 2)
              : null,
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ///文本选择之后显示区域
            Expanded(
              child: Obx(() {
                return CustomText(
                  currentLabelObs.value ?? widget.hintText ?? "",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  // "2023-10-18 - 2023-10-18",
                  style: ThemeService().textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        // color: currentLabel != null
                        //     ? ThemeService().colorScheme.onSurface
                        //     : ThemeService().colorScheme.onSurface.withOpacity(0.5),
                      ),
                );
              }),
            ),
            const SizedBox(
              width: AppValues.margin_4,
            ),
            widget.rightIcon ??
                RotatingArrow(
                  key: _rotatingArrowKey,
                ),
          ],
        ),
      ),
    );
  }

  void showDatePicker() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      // minTime: DateTime(2010, 1, 1),
      // maxTime: DateTime(2030, 12, 31),
      minTime: widget.minTime,
      maxTime: widget.maxTime,
      theme: const DatePickerTheme(
          headerColor: Colors.white,
          backgroundColor: Colors.white,
          itemStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
          doneStyle: TextStyle(color: Color(0xFF181818), fontSize: 16)),
      onChanged: (date) {
        log('change $date in time zone ${date.timeZoneOffset.inHours}');
      },
      onConfirm: (date) {
        log('confirm...$date');
        // "start_time": "2024-01-21 00:00:00",
        // "end_time": "2024-01-23 23:59:59",
        //  对选中时间date 进行回调处理
        DateTime dealDateTime = DateTime.parse(DateUtil.formatDate(date,
            format: widget.timeFormatter?.formatter ?? TimeFormatterEnum.current.formatter));
        String timeStr = getDateTimeStr(dealDateTime);
        log('confirm...deal $dealDateTime');
        // setState(() {
        //   currentLabel = timeStr;
        // });
        currentLabelObs.value = timeStr;
        log("confirm...currentLabelObs...${currentLabelObs.value}");
        if (widget.onSelected != null) {
          //保证只有一个
          if (_modelSelected == null) {
            _modelSelected = CustomSelectModel(timeStr, data: dealDateTime);
          } else {
            _modelSelected = _modelSelected!.copyWith(label: timeStr, data: dealDateTime);
          }
          _timeSelected = _modelSelected!.data;
          widget.onSelected!(0, _modelSelected!);
        }
      },
      onCancel: () {
        log('onCancel...');
      },
      currentTime: _timeSelected ?? (widget.defaultTime ?? DateTime.now()),
      // locale: LocaleType.vi,
      locale: getLocaleType(),
    ).then((dateTime) {
      log('close $dateTime');
      _resetAnimation(_rotatingArrowKey);
    });
  }



  ///获取时间DateTime  格式化
  String getDateTimeStr(DateTime? dateTime) {
    return DateUtil.formatDate(dateTime, format: 'yyyy-MM-dd');
    // return DateUtil.formatDate(dateTime,
    //     format: widget.timeFormatter?.formatter ?? CallBackTimeFormatter.current.formatter);
  }
}
