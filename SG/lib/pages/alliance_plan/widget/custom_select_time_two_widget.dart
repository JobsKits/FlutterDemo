import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/pages/alliance_plan/widget/custom_select_model.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/utils/date_util.dart';
import 'package:flutter_bet/utils/function.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/custom_text.dart';
import 'custom_select_time_widget_mixin.dart';

///时间选择器，开始时间 和 结束时间
class CustomSelectTimeTwoWidget extends StatefulWidget {
  // CustomTimeSelectWidget({super.key});
  const CustomSelectTimeTwoWidget({
    super.key,
    this.width = 200,
    this.height = 40,
    this.defaultStartTime,
    this.defaultEndTime,
    this.initSelected,
    this.onSelected,
    this.startHintText,
    this.endHintText,
    this.assetPath = "",
    this.rightIcon,
    this.panelRatio,
    this.borderShow = true,
  });

  final double? width; //默认220
  final double? height; //默认40
  // final List<CustomSelectModel>? modelList;
  // final CustomSelectModel? timeModel;
  final DateTime? defaultStartTime;
  final DateTime? defaultEndTime;
  final int? initSelected; //默认选中, 没默认的直接给null
  // final Function(int index, CustomSelectModel model)? onSelected; //选中回调
  final ParamTwiceCallback<CustomSelectModel?, CustomSelectModel?>? onSelected; //选中回调
  final String? startHintText; //提示文本
  final String? endHintText; //提示文本
  final String assetPath; //图片路径
  final Widget? rightIcon; //右边图标
  final double? panelRatio; //面板比例，相对于组件，值在0-1
  final bool borderShow; //是否显示边框

  @override
  State<CustomSelectTimeTwoWidget> createState() => _CustomSelectTimeTwoWidgetState();
}

class _CustomSelectTimeTwoWidgetState extends State<CustomSelectTimeTwoWidget>
    with CustomSelectTimeWidgetMixin {
  //主要是给选择下拉组件 一个挂载锚地key, 通过它可以获取组件对象， 并计算获取size 大小，width 和 height
  final GlobalKey selectWidgetGlobalKey = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final bubbleWith = 200.0;

  //框度，动态计算
  final double heightOfWidget = 5;

  //使用Rxn<String>(),这个主要目的是，为了兼容外面defaultStartTime 动态赋值，比如套接obx
  final currentStartLabelObs = Rxn<String>();
  final currentEndLabelObs = Rxn<String>();
  DateTime? startSelectedTime; //选中的时间
  DateTime? endSelectedTime; //选中的时间
  CustomSelectModel? startSelectedModel; //对外提供的model数据
  CustomSelectModel? endSelectedModel; //对外提供的model数据
  bool isChinese = true;

  ///【0229】【app】联盟计划，时间查询，限制选择的区间3个月就行了(90天)
  final DateTime minTime = DateTime.now().subtract(const Duration(days: 90));
  final DateTime maxTime = DateTime.now().add(const Duration(days: 1));

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
    // if (widget.defaultStartTime != null) {
    //   currentStartLabel = getDateTimeStr(widget.defaultStartTime);
    //   currentEndLabel = getDateTimeStr(widget.defaultEndTime);
    // }
    isChinese = GlobalStateController.of().isChinese();
    // startSelectedTime = widget.defaultStartTime;
    // endSelectedTime = widget.defaultEndTime;
  }

  @override
  Widget build(BuildContext context) {
    startSelectedTime = widget.defaultStartTime;
    endSelectedTime = widget.defaultEndTime;
    currentStartLabelObs.value = getDateTimeStr(startSelectedTime);
    currentEndLabelObs.value = getDateTimeStr(endSelectedTime);
    return Container(
      key: selectWidgetGlobalKey,
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
        left: AppValues.halfPadding,
        right: AppValues.halfPadding,
        // top: AppValues.smallPadding,
        // bottom: AppValues.smallPadding,
      ),
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
        mainAxisSize: MainAxisSize.max,
        children: [
          ///文本选择之后显示区域
          Expanded(
            child: InkWell(
              onTap: () {
                _startAnimation(_rotatingArrowKey);
                showStartDatePicker();
              },
              child: Center(
                child: Obx(() {
                  return CustomText(
                    currentStartLabelObs.value ?? widget.startHintText ?? "",
                    // getDateTimeStr(startSelectedTime) ?? (widget.startHintText ?? ""),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    // "2023-10-18 - 2023-10-18",
                    style:
                        ThemeService().textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                  );
                }),
              ),
            ),
          ),
          CustomText(
            "-",
            maxLines: 1,
            textAlign: TextAlign.center,
            // "2023-10-18 - 2023-10-18",
            style: ThemeService().textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                _startAnimation(_rotatingArrowKey);
                showEndDatePicker();
              },
              child: Center(
                child: Obx(() {
                  return CustomText(
                    currentEndLabelObs.value ?? widget.endHintText ?? "",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    // "2023-10-18 - 2023-10-18",
                    style: ThemeService().textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: AppValues.margin_2),
          widget.rightIcon ??
              RotatingArrow(
                key: _rotatingArrowKey,
              ),
        ],
      ),
    );
  }

  ///显示开始时间
  void showStartDatePicker() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2010, 1, 1),
      maxTime: DateTime(2030, 12, 31),
      theme: const DatePickerTheme(
          headerColor: Colors.white,
          backgroundColor: Colors.white,
          itemStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
          doneStyle: TextStyle(color: Color(0xFF181818), fontSize: 16)),
      onChanged: (date) {
        log('change $date in time zone ${date.timeZoneOffset.inHours}');
      },
      onConfirm: (date) {
        log('confirm $date');
        String timeStr = getDateTimeStr(date) ?? "";
        // setState(() {
        //   currentStartLabel = timeStr;
        // });
        currentStartLabelObs.value = timeStr;
        if (widget.onSelected != null) {
          //保证只有一个
          if (startSelectedModel == null) {
            startSelectedModel = CustomSelectModel(timeStr, data: date);
          } else {
            startSelectedModel = startSelectedModel!.copyWith(label: timeStr, data: date);
          }
          startSelectedTime = startSelectedModel!.data;
          widget.onSelected!(startSelectedModel, endSelectedModel);
        }
      },
      onCancel: () {
        log('onCancel...');
      },
      currentTime: startSelectedTime ?? (widget.defaultStartTime ?? DateTime.now()),
      locale: getLocaleType(),
    ).then((dateTime) {
      log('close $dateTime');
      _resetAnimation(_rotatingArrowKey);
    });
  }

  ///结束时间
  void showEndDatePicker() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      // minTime: DateTime(2010, 1, 1),
      // maxTime: DateTime(2030, 12, 31),
      minTime: minTime,
      maxTime: maxTime,
      theme: const DatePickerTheme(
          headerColor: Colors.white,
          backgroundColor: Colors.white,
          itemStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
          doneStyle: TextStyle(color: Color(0xFF181818), fontSize: 16)),
      onChanged: (date) {
        log('change $date in time zone ${date.timeZoneOffset.inHours}');
      },
      onConfirm: (date) {
        log('confirm $date');
        String timeStr = getDateTimeStr(date) ?? "";
        // setState(() {
        //   currentEndLabelObs = timeStr;
        // });
        currentEndLabelObs.value = timeStr;
        if (widget.onSelected != null) {
          //保证只有一个
          if (endSelectedModel == null) {
            endSelectedModel = CustomSelectModel(timeStr, data: date);
          } else {
            endSelectedModel = endSelectedModel!.copyWith(label: timeStr, data: date);
          }
          endSelectedTime = endSelectedModel!.data;
          widget.onSelected!(startSelectedModel, endSelectedModel);
        }
      },
      onCancel: () {
        log('onCancel...');
      },
      currentTime: endSelectedTime ?? (widget.defaultEndTime ?? DateTime.now()),
      locale: getLocaleType(),
    ).then((dateTime) {
      log('close $dateTime');
      _resetAnimation(_rotatingArrowKey);
    });
  }

  ///获取时间DateTime  格式化
  //todo: 适配国际化，中文使用yyyy-MM-dd ，非中文使用dd-MM-yyyy
  String? getDateTimeStr(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }
    bool isChinese = LangService().lang == LangType.zhCN;
    return DateUtil.formatDate(dateTime, format: isChinese ? 'yyyy-MM-dd' : 'dd-MM-yyyy');
  }
}
