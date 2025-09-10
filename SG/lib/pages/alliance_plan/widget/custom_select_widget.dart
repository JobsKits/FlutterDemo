import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/pages/alliance_plan/widget/custom_select_model.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/utils/function.dart';
import 'package:flutter_bet/widget/expansion/custom_expand_icon.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/dialog/dialog_utils.dart';
import 'custom_select_widget_mixin_amin.dart';

///公用下拉框， 联盟计划-所有数据页面 用到
class CustomSelectWidget extends StatefulWidget {
  // CustomTimeSelectWidget({super.key});
  const CustomSelectWidget({
    super.key,
    this.width = 200,
    this.height = 40,
    this.itemHeight,
    this.modelList,
    this.initSelected,
    this.onSelected,
    this.hintText,
    this.assetPath = "",
    this.rightIcon,
    this.panelRatio,
    this.panelRatioCallback,
    this.scaleAmin = true,
    this.backgroundColor,
    this.selectColor = AppThemes.secondaryColor, //字体颜色，默认
    this.unselectColor = AppThemes.widgetColorWhite, //字体颜色，默认
    this.selectColorFull,
    this.borderShow = true,
    this.dxWidth = 0.0,
    this.arrowBasisOffset = 0.0,
    this.positionedLeft,
    this.positionedRight,
    this.textAlign,
  });

  final double? width; //默认220
  final double? height; //默认40
  final double? itemHeight; //默认30

  final List<CustomSelectModel>? modelList;
  final int? initSelected; //默认选中, 没默认的直接给null
  // final Function(int index, CustomSelectModel model)? onSelected; //选中回调
  final ParamTwiceCallback<int, CustomSelectModel>? onSelected; //选中回调
  final String? hintText; //提示文本
  final String assetPath; //图片路径
  final Widget? rightIcon; //右边图标
  final double? panelRatio; //面板比例，相对于组件，值在0-1
  ///panelRatioCallback优先级高于panelRatio。 size组件的大小，  panelRatio 面板比例，相对于组件，值在0-1
  ///返回比例值
  final double Function(Size size, double panelRatio)? panelRatioCallback;
  final bool? scaleAmin; //是否开启动画
  final Color? backgroundColor; //背景颜色
  final Color? selectColor; //选中文本颜色
  final Color? unselectColor; //未选中文本颜色
  final Color? selectColorFull; //选中颜色,是否铺满
  // final bool selectColorFull; //选中颜色,是否铺满
  final bool borderShow; //是否显示边框
  final TextAlign? textAlign; ////文本显示对其方式 ,默认TextAlign.center

  ///偏移处理
  final double dxWidth;
  final double arrowBasisOffset;

  //范例：
  // dxWidth: LangService().isChinese ? 0.0 : -20,
  // arrowBasisOffset: LangService().isChinese ? 0.0 : 20.0,

  final double? positionedLeft; //防止右边溢出
  final double? positionedRight; //防止右边溢出

  @override
  State<CustomSelectWidget> createState() => _CustomSelectWidgetState();
}

class _CustomSelectWidgetState extends State<CustomSelectWidget> with CustomSelectWidgetMixinAmin {
  //主要是给选择下拉组件 一个挂载锚地key, 通过它可以获取组件对象， 并计算获取size 大小，width 和 height
  final GlobalKey selectWidgetGlobalKey = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  ScrollController? scrollController;
  final double _itemHeight = 30;
  final bubbleWith = 200.0;

  //框度，动态计算
  final double heightOfWidget = 5;
  int? currentSelected; //手动点击当前选中的 index
  // String? currentLabel;
  final currentLabelObs = Rxn<String>();
  double _panelRatio = 0.8;

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  @override
  void initState() {
    super.initState();
    currentSelected = widget.initSelected;
    // log("下拉选择框...initState()...");
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      if (widget.panelRatioCallback != null) {
        _panelRatio =
            widget.panelRatioCallback!.call(_getSelectWidgetSize(), widget.panelRatio ?? 0.8);
      } else {
        _panelRatio = widget.panelRatio ?? 0.8;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // log("下拉选择框...didChangeDependencies()...");
  }

  @override
  void didUpdateWidget(covariant CustomSelectWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // log("下拉选择框...didUpdateWidget()...");
    //应对 组件套接 obx
    currentSelected = widget.initSelected;
  }

  ///初始化显示 正文
  initLabel() {
    if (widget.modelList != null &&
        currentSelected != null &&
        currentSelected! >= 0 &&
        currentSelected! < widget.modelList!.length) {
      currentLabelObs.value = widget.modelList![currentSelected!].label;
    }
  }

  // @override
  // void dispose() {
  //   scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // log("下拉选择框...build()...");
    initLabel();
    return GestureDetector(
      onTap: () {
        doScaleAmin(widget.scaleAmin);
        _startAnimation(_rotatingArrowKey);
        DialogUtils.showCustomBubbleDialog(
          Get.context!,
          _buildSelectListView(Get.context!),
          // bubbleWith,
          // _getSelectWidth(widget.panelRatio ?? 0.8),
          _getSelectWidth(_panelRatio),
          // Get.width,
          widgetKey: selectWidgetGlobalKey,
          backgroundColor: widget.backgroundColor ?? ThemeService().colorScheme.tertiary,
          // globalKey: widget._rotatingArrowKey,
          // arrowBasisOffset: 5.1,
          //  bubbleArrowWidth :13,
          //  bubbleArrowHeight : 5,
          globalKey: _rotatingArrowKey,
          dxWidth: widget.dxWidth,
          arrowBasisOffset: widget.arrowBasisOffset,
          positionedRight: widget.positionedRight,
          //范例：
          // dxWidth: LangService().isChinese ? 0.0 : -20,
          // arrowBasisOffset: LangService().isChinese ? 0.0 : 20.0,
          onDismissCallback: () {
            doScaleAmin(widget.scaleAmin);
            disposeScrollController();
          },
        );
      },

      ///选中 显示
      child: Obx(() {
        return Container(
          key: selectWidgetGlobalKey,
          width: widget.width,
          height: widget.height,
          // alignment: Alignment.center,

          alignment: Alignment.center,
          padding: const EdgeInsets.only(
              left: AppValues.halfPadding,
              right: AppValues.halfPadding,
              top: AppValues.smallPadding,
              bottom: AppValues.smallPadding),
          decoration: BoxDecoration(
            color: ThemeService().colorScheme.surface,
            border: widget.borderShow
                ? Border.all(color: ThemeService().colorScheme.tertiary, width: 2)
                : null,
            borderRadius: BorderRadius.circular(AppValues.smallRadius),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.bounceIn, // 使用弹性曲线
            transform: Matrix4.identity()..scale(scale),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///文本选择之后显示区域
                const SizedBox(width: AppValues.margin_4),
                Expanded(
                    child: CustomText(
                  currentLabelObs.value ?? (widget.hintText ?? ""),
                  maxLines: 1,
                  textAlign: widget.textAlign ?? TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: ThemeService().textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                )),
                const SizedBox(width: AppValues.margin_4),
                widget.rightIcon ?? RotatingArrow(key: _rotatingArrowKey),
              ],
            ),
          ),
        );
      }),
    );
  }

  ///创建 下拉列表
  Widget _buildSelectListView(BuildContext context) {
    var maxHeight = _getSelectHeight(heightOfWidget);
    newScrollController();
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      padding: const EdgeInsets.symmetric(vertical: AppValues.padding_4),
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        // physics: const BouncingScrollPhysics(),
        controller: scrollController,
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
      // log("Index $index: $model");
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
        log('selected model:' + itemModel.toString());
        currentSelected = index;
        if (widget.onSelected != null) {
          widget.onSelected!(currentSelected!, itemModel);
        }
        RouteUtil.popView();
        // setState(() {
        //   // currentLabel = itemModel.label;
        // });
        currentLabelObs.value = itemModel.label;
      },
      child: Container(
        height: widget.itemHeight ?? _itemHeight,
        // padding: const EdgeInsets.only(top: 6, bottom: 6),
        // color: index == currentSelected ? ThemeService().colorScheme.primary : null,
        // 是否选中拉满颜色
        color: index == currentSelected ? widget.selectColorFull : null,
        // todo:[0601] 左边剧中
        // alignment: Alignment.center,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 12),
        width: double.infinity,
        child: CustomText(
          itemModel.label,
          maxLines: 2,
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: index == currentSelected
                    // ? ThemeService().colorScheme.primary
                    //   : AppThemes.ffd9d9d9,
                    ? widget.selectColor
                    : widget.unselectColor,
              ),
        ),
      ),
    );
  }

  double scrollOffset = 0;

  ///滚动到选中位置
  void newScrollController() {
    scrollController = ScrollController(initialScrollOffset: scrollOffset);
    if (scrollController != null) {
      scrollController!.addListener(() {
        scrollOffset = scrollController!.offset;
        // log("scrollOffset...$scrollOffset");
      });
    }
  }

  void disposeScrollController() {
    if (scrollController != null) {
      scrollController!.dispose();
    }
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
    // log("_getSelectHeight...Size...${size}");
    return totalHeight * ratio;
  }

  ///给选择器 定义我、宽度
  double _getSelectWidth(double ratio) {
    double? totalWidth;
    //获取宽度
    final Size size = _getSelectWidgetSize();
    totalWidth = size.width;
    return totalWidth * ratio;
  }

  Size _getSelectWidgetSize() {
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox =
        selectWidgetGlobalKey.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    return size;
  }
}
