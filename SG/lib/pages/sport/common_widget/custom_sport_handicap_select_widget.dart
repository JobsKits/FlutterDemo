import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/generated/intl/messages_en.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/function.dart';
import '../../../utils/route_util.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../alliance_plan/widget/custom_select_model.dart';

///体育赛事-总分盘/让分盘/获胜盘  下拉widget
@Deprecated("直接使用[CustomSelectWidget]组件即可")
class CustomSportHandicapSelectWidget extends StatefulWidget {
  const CustomSportHandicapSelectWidget({
    super.key,
    this.width = 200,
    this.height = 40,
    this.modelList,
    this.initSelected,
    this.onSelected,
    this.hintText,
    this.assetPath = "",
    this.rightIcon,
  });

  final double? width; //默认220
  final double? height; //默认40
  final List<CustomSelectModel>? modelList;
  final int? initSelected; //默认选中, 没默认的直接给null
  // final Function(int index, CustomSelectModel model)? onSelected; //选中回调
  final ParamTwiceCallback<int, CustomSelectModel>? onSelected; //选中回调
  final String? hintText; //提示文本
  final String assetPath; //图片路径
  final Widget? rightIcon; //右边图标

  @override
  State<CustomSportHandicapSelectWidget> createState() => _CustomSelectWidgetState();
}

class _CustomSelectWidgetState extends State<CustomSportHandicapSelectWidget> {
  //主要是给选择下拉组件 一个挂载锚地key, 通过它可以获取组件对象， 并计算获取size 大小，width 和 height
  final GlobalKey selectWidgetGlobalKey = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final bubbleWith = 200.0;

  //框度，动态计算
  final double heightOfWidget = 5;
  int? currentSelected; //当前选中
  String? currentLabel;

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  @override
  void initState() {
    super.initState();

    ///初始化 默认着
    if (widget.modelList != null &&
        widget.initSelected != null &&
        widget.initSelected! < widget.modelList!.length) {
      currentLabel = widget.modelList![widget.initSelected!].label;
    }
  }

  @override
  Widget build(BuildContext context) {
    currentSelected = currentSelected ?? widget.initSelected;
    return GestureDetector(
      onTap: () {
        _startAnimation(_rotatingArrowKey);
        DialogUtils.showCustomBubbleDialog(
            Get.context!,
            _buildSelectListView(Get.context!),
            // bubbleWith,
            _getSelectWidth(0.8),
            widgetKey: selectWidgetGlobalKey,
            backgroundColor: ThemeService().colorScheme.tertiary,
            // globalKey: widget._rotatingArrowKey,
            globalKey: _rotatingArrowKey);
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
          // border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ///文本选择之后显示区域
            Expanded(
              child: CustomText(
                currentLabel ?? widget.hintText ?? "",
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
              ),
            ),
            const SizedBox(
              width: AppValues.margin_4,
            ),
            widget.rightIcon ??
                RotatingArrow(
                  key: _rotatingArrowKey,
                ),
            // widget.rightIcon ??
            //     // CustomAssetIcon(
            //     //   name: widget.assetPath.isNotEmpty
            //     //       ? widget.assetPath
            //     //       : "assets/images/top_drop_down arrow.png",
            //     //   size: 18,
            //     // ),
            //     Obx(() {
            //       return SizedBox(
            //         height: 18,
            //         width: 18,
            //         child: ExpandIcon(
            //           padding: EdgeInsets.zero,
            //           isExpanded: _expanded.value,
            //           size: 18,
            //           onPressed: (value) {},
            //         ),
            //       );
            //     }),
          ],
        ),
      ),
    );
  }

  ///创建 下拉列表
  Widget _buildSelectListView(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: _getSelectHeight(heightOfWidget)),
      padding: EdgeInsets.symmetric(vertical: AppValues.padding_4),
      child: SingleChildScrollView(
        child: Column(
          children: _createListWidget(),
        ),
      ),
    );
  }

  ///创建 获取 所有item
  List<Widget> _createListWidget() {
    var widgetList = <Widget>[];
    widget.modelList!.asMap().forEach((index, model) {
      print("Index $index: $model");
      var itemView = _createSelectItemView(index, model);
      widgetList.add(itemView);
    });

    return widgetList;
  }

  ///创建 下拉item 单个view
  Widget _createSelectItemView(int index, CustomSelectModel itemModel) {
    return InkWell(
      // padding: EdgeInsets.zero,
      onTap: () {
        // limitTimeTypeTemp.value = itemModel['type'];
        log('selected model:' + itemModel.toString());
        currentSelected = index;
        if (widget.onSelected != null) {
          widget.onSelected!(currentSelected!, itemModel);
        }
        RouteUtil.popView();
        setState(() {
          currentLabel = itemModel.label;
        });
      },
      child: Container(
        height: 30,
        // padding: const EdgeInsets.only(top: 6, bottom: 6),
        // color: index == currentSelected ? ThemeService().colorScheme.primary : null,
        alignment: Alignment.center,
        width: double.infinity,
        child: CustomText(
          itemModel.label,
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                color: index == currentSelected
                    ? ThemeService().colorScheme.primary
                    : AppThemes.ffd9d9d9,
              ),
        ),
      ),
    );
  }

  ///给选择器 定义最大高度
  double _getSelectHeight(double ratio) {
    double? totalHeight;
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox =
        selectWidgetGlobalKey.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    totalHeight = size.height;
    log("_getTimeHeight...Size...${size}");
    return totalHeight * ratio;
  }

  ///给选择器 定义我、宽度
  double _getSelectWidth(double ratio) {
    double? totalWidth;
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox =
        selectWidgetGlobalKey.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    totalWidth = size.width;
    return totalWidth * ratio;
  }
}
