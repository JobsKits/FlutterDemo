import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/rotary/views/share_view.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/model/yulecheng/index.dart';
import 'package:flutter_bet/pages/find/YulechengCategoryPage/index.dart';
import 'package:flutter_bet/pages/find/YulechengCategoryPage/yulecheng_category_state.dart';
import 'package:flutter_bet/pages/find/yulechengtouzhurank/index.dart';
import 'package:flutter_bet/pages/home/widget/search_history_item.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/utils/string_uril.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/button/custom_small_mian_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_empty_widget.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../../../constant/app_themes.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/network_image/custom_network_image_placeholder.dart';
import '../../widget/casino_changguan_flip_list.dart';

class CasinoGameList extends StatefulWidget {
  final String name;
  final YulechengCategoryState state;
  final Function onsortTap;
  final Function onPlatTap;

  final YulechengcategorypageController controller;
  final GlobalKey _widgetKey = GlobalKey(); // 创建一个GlobalKey
  final GlobalKey _widgetKey1 = GlobalKey(); // 创建一个GlobalKey
  final GlobalKey globalKey = GlobalKey();
  final GlobalKey globalKey1 = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final GlobalKey<ScalingTextState> _scalingKey = GlobalKey<ScalingTextState>();

  final GlobalKey<RotatingArrowState> _rotatingArrowKey1 = GlobalKey<RotatingArrowState>();
  final GlobalKey<ScalingTextState> _scalingKey1 = GlobalKey<ScalingTextState>();
  CasinoGameList(
      {super.key,
      required this.name,
      required this.state,
      required this.onsortTap,
      required this.controller,
      required this.onPlatTap});

  @override
  State<CasinoGameList> createState() => _CasinoGameListState();
}

class _CasinoGameListState extends State<CasinoGameList> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      slivers: <Widget>[
        <Widget>[
          Image.asset("assets/images/yulecheng/group-banner-default.webp", fit: BoxFit.cover)
              .tight(width: double.infinity),
          Text(
            widget.name,
            style: ThemeService()
                .theme
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
          ).alignLeft().marginOnly(left: AppValues.defaultPadding),
          Image.asset(
            "assets/images/yulecheng/ic_category_${widget.controller.imagenName}.webp",
            width: 149,
            height: 80,
          ).paddingRight(AppValues.defaultPadding).alignRight(),
        ].toStack().tight(height: 80).sliverToBoxAdapter(),
        // _buildSearchView(context).sliverToBoxAdapter(),
        if (widget.controller.state.showSorttype == true &&
            widget.controller.state.showInfoType == 0)
          buildSelectButton(context).sliverToBoxAdapter(),

        buildSearchOrBody(),
        if (widget.state.showLoadMore == true &&
            widget.controller.state.showInfoType.value == 0 &&
            widget.controller.state.isLoading == false)
          bottomloadMore().sliverToBoxAdapter(),

        if (widget.state.showQieHuanPage == true) changePage().sliverToBoxAdapter(),
        if (widget.controller.fromChangguanPage != 3 &&
            widget.controller.fromChangguanPage != 1 &&
            widget.controller.state.isLoading == false)
          buildBottomChangguan().sliverToBoxAdapter(),
        if (widget.controller.state.isLoading == false)
          RankingListWidget("category", context).sliverToBoxAdapter(),

        SizedBox(
          height: AppValues.barBottomHeight,
        ).sliverToBoxAdapter(),
      ],
    );
  }

  Widget _buildSearchView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeService().theme.colorScheme.tertiary, // 边框颜色
          width: 2.0, // 边框宽度
          style: BorderStyle.solid, // 边框样式，可以是 solid, dashed, dotted 等
        ),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Container(
            margin: const EdgeInsets.only(left: AppValues.extraSmallMargin),
            child: const CustomAssetIcon(
              name: 'assets/images/search_icon.png',
              size: 22,
            ),
          ),
          Container(
            height: 36,
            child: TextField(
              focusNode: widget.controller.focusNode,
              textAlign: TextAlign.left,
              autofocus: false,
              maxLines: 1,
              style: ThemeService().theme.textTheme.bodyMedium,
              onChanged: (string) {
                widget.controller.state.searchContent.value = string;
                if (string.length > 2) {
                  widget.controller.search();
                } else {
                  widget.controller.state.showSearchType.value = 0;
                }
              },
              controller: widget.controller.state.textController,
              decoration: InputDecoration(
                  fillColor: AppThemes.widgetColorWhite,
                  hintText: S.current.search_game,
                  hintStyle: const TextStyle(color: AppThemes.secondaryIconColor, fontSize: 14),
                  border: _getEditBorder(),
                  focusedBorder: _getEditBorder(),
                  disabledBorder: _getEditBorder(),
                  enabledBorder: _getEditBorder(),
                  contentPadding: const EdgeInsets.only(left: 30, right: 30, top: 6, bottom: 6)),
            ),
          ),
          Positioned(
            right: 2,
            child: Visibility(
              visible: widget.controller.state.showInfoType == 1 ? true : false,
              child: InkWell(
                onTap: widget.controller.onClean,
                child: const Icon(
                  Icons.cancel_rounded,
                  color: AppThemes.widgetColorWhite,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ).paddingHorizontal(AppValues.defaultPadding),
    ).paddingHorizontal(AppValues.defaultPadding);
  }

  ///获取输入框的Border属性，可公用
  ///[isEdit]是否获取焦点
  OutlineInputBorder _getEditBorder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
  }

  Widget buildSearchOrBody() {
    if (widget.controller.state.showInfoType == 1 && widget.controller.state.showSearchType != 2) {
      return _buildEmptySearch(
              widget.controller.state.showSearchType.value, widget.controller.state.history)
          .sliverToBoxAdapter();
    } else {
      return buildBody();
    }
  }

  ///0：提示至少3个字符+搜索记录 1:搜索无结果+搜索记录
  Widget _buildEmptySearch(int type, List<String> history) {
    return GestureDetector(
      onTap: () {
        widget.controller.closeSearchView();
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              alignment: Alignment.center,
              child: CustomText(
                type == 0
                    ? S.current.game_category_search_standards
                    : S.current.game_Category_no_results,
                style: ThemeService().textTheme.labelLarge,
              ),
            ),

            ///搜索记录
            _buildSearchHistory(history),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHistory(List<String> history) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                S.current.game_category_recent_search,
                style: ThemeService().textTheme.labelLarge,
              ),
              const Expanded(child: SizedBox()),
              InkWell(
                  onTap: () {
                    widget.controller.cleanHistory();
                  },
                  child: CustomText(
                    S.current.game_category_clear_seach_results + '${history.length})',
                    style: ThemeService().textTheme.labelLarge,
                  ))
            ],
          ),
          const SizedBox(
            height: AppValues.margin_12,
          ),
          Wrap(
            children: [
              for (String item in history)
                SearchHistoryItem(
                  name: item,

                  ///点击自动搜索关键词
                  onTap: () {
                    widget.controller.searchByClick(item);
                  },
                  deleteWord: (word) {
                    widget.controller.removeWord(word);
                  },
                )
            ],
          ),
        ],
      ),
    );
  }

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  void _startScaleAnimation(GlobalKey<ScalingTextState> key) {
    key.currentState?.startAnimation();
  }

  Widget buildSelectButton(context) {
    return (widget.controller.fromChangguanPage == 2 && widget.controller.navModel.ty == 1 ||
                widget.controller.fromChangguanPage == 21 && widget.controller.itemModel.ty == 1) ||
            widget.controller.fromChangguanPage == 5 && widget.controller.lobbbModel.ty == 1 ||
            widget.controller.fromChangguanPage == 6
        ? <Widget>[
            GestureDetector(
              key: widget.globalKey,
              onTap: () {
                // widget.controller.goToChangguanList();
                _startAnimation(widget._rotatingArrowKey);
                _startScaleAnimation(widget._scalingKey);
                DialogUtils.showCustomBubbleDialog(context, _viewBubbleChild0(),
                    widget.controller.state.changguanSumArray.length > 0 ? 220 : 110,
                    widgetKey: widget._widgetKey1,
                    globalKey: widget._rotatingArrowKey,
                    globalKeyScaling: widget._scalingKey,
                    // backgroundColor: ThemeService().colorScheme.tertiary,
                    dxWidth: widget.controller.state.changguanSumArray.length > 0
                        ? (170 -
                                StringUtil.textWidth(
                                    " " + S.current.game_supplier,
                                    ThemeService()
                                        .theme
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w600))) /
                            2
                        : (60 -
                                StringUtil.textWidth(
                                    " " + S.current.game_supplier,
                                    ThemeService()
                                        .theme
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w600))) /
                            2,
                    height: widget.controller.state.changguanSumArray.length *
                            AppValues.defaultTextHeight +
                        AppValues.defaultButtonHeight);
              },
              child: CustomIconButton(
                borderRadius: 4,
                backgroundColor: ThemeService().theme.colorScheme.surface,
                animationWidget: ScalingText(
                    key: widget._scalingKey,
                    text: " " + S.current.game_supplier,
                    textStyle: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600)),
                direction: Direction.right,
                // iconWidget: <Widget>[
                // Container(
                //   decoration: BoxDecoration(
                //       color: AppThemes.secondaryColor, borderRadius: BorderRadius.circular(10)),
                //   child: CustomText(
                //     widget.controller.state.changguanSumArray.length.toString(),
                //     textAlign: TextAlign.center,
                //   ),
                // ).tight(width: 25),
                // SizedBox(
                //   width: 25,
                // ),
                // RotatingArrow(
                //   key: widget._rotatingArrowKey,
                // ).paddingLeft(5),
                // ].toRow().paddingLeft(5),
                iconWidget: RotatingArrow(
                  key: widget._rotatingArrowKey,
                ),
                widgetHeight: 44.19,
                widgetWidth: StringUtil.textWidth(
                        " " + S.current.game_supplier,
                        ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600)) +
                    50,
                iconWidth: 30,
                iconHeight: 20,
                key: widget._widgetKey1,
              ),
            ),
            GestureDetector(
              key: widget.globalKey1,
              onTap: () {
                _startAnimation(widget._rotatingArrowKey1);
                _startScaleAnimation(widget._scalingKey1);
                DialogUtils.showCustomBubbleDialog(
                  // backgroundColor:
                  // ThemeService().theme.scaffoldBackgroundColor,
                  context,
                  _viewBubbleChild(),
                  LangUtil().isZhCn() ? 98 : 130,
                  dxWidth: LangUtil().isZhCn()
                      ? StringUtil.textWidth(
                                  "  " +
                                      widget.controller.state
                                              .sortType[widget.controller.state.currentSortType]
                                          ["name"],
                                  ThemeService()
                                      .theme
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w600)) /
                              2 -
                          24
                      : StringUtil.textWidth(
                                  "  " +
                                      widget.controller.state
                                              .sortType[widget.controller.state.currentSortType]
                                          ["name"],
                                  ThemeService()
                                      .theme
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w600)) /
                              2 -
                          40,
                  widgetKey: widget._widgetKey,
                  globalKey: widget._rotatingArrowKey1,
                  globalKeyScaling: widget._scalingKey1,
                  // backgroundColor: ThemeService().colorScheme.tertiary,
                  height: 157,
                );
              },
              child: CustomIconButton(
                borderRadius: 4,
                backgroundColor: ThemeService().theme.colorScheme.surface,
                animationWidget: ScalingText(
                    key: widget._scalingKey1,
                    text: "  " +
                        widget.controller.state.sortType[widget.controller.state.currentSortType]
                            ["name"],
                    textStyle: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600)),
                direction: Direction.right,
                iconWidget: RotatingArrow(
                  key: widget._rotatingArrowKey1,
                ),
                iconWidth: 30,
                iconHeight: 20,
                widgetHeight: 44.19,
                widgetWidth: StringUtil.textWidth(
                        "  " +
                            widget.controller.state
                                .sortType[widget.controller.state.currentSortType]["name"],
                        ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600)) +
                    50,
                key: widget._widgetKey,
              ).tight(height: 44.19),
            )
          ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .tight(height: 44.19)
            .paddingAll(AppValues.defaultPadding)
        : <Widget>[
            GestureDetector(
              onTap: () {
                widget.controller.goToChangguanList();
              },
              child: CustomIconButton(
                backgroundColor: ThemeService().theme.colorScheme.surface,
                name:
                    "${S.current.game_category_check_all}${LangUtil().isHiIN() ? 'देखे' : S.current.game_supplier}",
                direction: Direction.right,
                borderRadius: 20,
                widgetHeight: 40,
                widgetWidth: LangUtil().isZhCn() ? 150 : 210,
                iconWidth: 1,
                iconHeight: 1,
                key: widget._widgetKey1,
              ),
            ),
            GestureDetector(
              onTap: () {
                DialogUtils.showCustomBubbleDialog(
                    // backgroundColor:
                    // ThemeService().theme.scaffoldBackgroundColor,
                    context,
                    _viewBubbleChild(),
                    LangUtil().isZhCn() ? 98 : 130,
                    dxWidth: LangUtil().isZhCn() ? 0 : -20,
                    widgetKey: widget._widgetKey,
                    // backgroundColor: ThemeService().colorScheme.tertiary,
                    height: 160);
              },
              child: CustomIconButton(
                borderRadius: 4,
                backgroundColor: ThemeService().theme.colorScheme.surface,
                name: widget.controller.state.sortType[widget.controller.state.currentSortType]
                    ["name"],
                direction: Direction.right,
                iconWidget: Image.asset(
                  "assets/images/yulecheng/icon_down.webp",
                ).tight(width: 15, height: 12),
                widgetHeight: 40,
                widgetWidth: 100,
                iconWidth: 15,
                iconHeight: 12,
                key: widget._widgetKey,
              ).tight(height: 40),
            )
          ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .tight(height: 50)
            .paddingAll(AppValues.defaultPadding);
  }

// 弹窗出来的平台选择
  _viewBubbleChild0() {
    return GetBuilder(
        init: YulechengcategorypageController(),
        id: "show_list",
        builder: (context) {
          return Column(
            children: List.generate(widget.controller.state.changguanSumArray.length + 1, (index) {
              return index < widget.controller.state.changguanSumArray.length
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () {
                            // Get.back();
                            widget.controller.selectedCheckBox(index);
                          },
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              // CustomIcon(asset: betSlipTypeList[index].icon!),
                              widget.controller.state.changguanSumArray[index].selected
                                  ? Container(
                                      width: 20,
                                      height: 20,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF2F4552),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4)),
                                        shadows: [
                                          const BoxShadow(
                                            color: Color(0x59000000),
                                            blurRadius: 3,
                                            offset: Offset(0, 1),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/svg/yulecheng_checked.svg",
                                        width: 14.5,
                                        height: 11.5,
                                      ).center(),
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side:
                                              const BorderSide(width: 2, color: Color(0xFF2F4552)),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        shadows: [
                                          const BoxShadow(
                                            color: Color(0x59000000),
                                            blurRadius: 3,
                                            offset: Offset(0, 1),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                    ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                widget.controller.state.changguanSumArray[index].platformName,
                                style: widget.controller.state.changguanSumArray[index].selected
                                    ? ThemeService().theme.textTheme.bodyMedium?.copyWith(
                                        color: const Color(0xff2f4552),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)
                                    : ThemeService().theme.textTheme.bodyMedium?.copyWith(
                                        color: const Color(0xff2f4552),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: widget.controller.getSelectedNumber()
                                        ? AppThemes.secondaryColor
                                        : widget.controller.state.changguanSumArray[index].selected
                                            ? AppThemes.secondaryColor
                                            : const Color(0xff0a1724),
                                    borderRadius: BorderRadius.circular(10)),
                                child: CustomText(
                                  widget.controller.state.changguanSumArray[index].total > 999
                                      ? "999+"
                                      : widget.controller.state.changguanSumArray[index].total
                                          .toString(),
                                  textAlign: TextAlign.center,
                                  style: ThemeService().textTheme.bodyMedium!.copyWith(
                                        color: widget.controller.getSelectedNumber()
                                            ? const Color(0xff041720)
                                            : widget.controller.state.changguanSumArray[index]
                                                    .selected
                                                ? const Color(0xff041720)
                                                : const Color(0xffb1bad3),
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              )
                                  .tight(
                                    width: 35,
                                    // height: 20,
                                  )
                                  .paddingLeft(AppValues.halfPadding),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                      ],
                    ).tight(height: AppValues.defaultTextHeight).paddingZero
                  : Column(
                      children: [
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(color: Color(0xffd5dceb)),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            widget.controller.quanBuQingChu();
                          },
                          child: SizedBox(
                            height: 20,
                            child: Text(
                              S.current.bet_all_clean,
                              textAlign: TextAlign.center,
                              style: ThemeService().theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xff2f4552),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ).paddingTop(AppValues.halfPadding),
                      ],
                    );
            }),
          );
        });
  }

// 弹窗出来的币种选择
  _viewBubbleChild() {
    return Column(
      children: List.generate(widget.controller.state.sortType.length, (index) {
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Get.back();
                widget.controller.selectedSortType(index);
              },
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  // CustomIcon(asset: betSlipTypeList[index].icon!),
                  const SizedBox(
                    width: 6,
                  ),
                  if (index == 2)
                    SvgPicture.asset(
                      "assets/svg/yulecheng_ic_hot_sort.svg",
                      color: widget.controller.state.currentSortType == 2
                          ? AppThemes.secondaryColor
                          : Color(0xff2f4552),
                    ),
                  if (index == 2)
                    const SizedBox(
                      width: 3,
                    ),
                  if (index == 3)
                    SvgPicture.asset(
                      "assets/svg/yulecheng_ic_important_sort.svg",
                      color: widget.controller.state.currentSortType == 3
                          ? AppThemes.secondaryColor
                          : Color(0xff2f4552),
                    ),
                  if (index == 3)
                    const SizedBox(
                      width: 3,
                    ),
                  Text(
                    widget.controller.state.sortType[index]["name"],
                    style: ThemeService().theme.textTheme.bodySmall?.copyWith(
                        color: index == widget.controller.state.currentSortType
                            ? AppThemes.secondaryColor
                            : Color(0xff2f4552),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        );
      }),
    );
  }

  Widget buildBody() {
    if (widget.state.isLoading == true) {
      return SizedBox(
          height: 150,
          child: CustomNetWorkImagePlaceholder(
            color: AppThemes.surfaceVariant.withOpacity(0),
            placeholderType: NetWorkImagePlaceholderType.loading,
            // borderRadius: borderRadius,
            // border: border,
          )).sliverToBoxAdapter();
    }
    if (widget.controller.fromChangguanPage == 1) {
      if (widget.controller.title == S.current.random_text_260) {
        return widget.state.dataArray.isEmpty && widget.state.isLoading == false
            ? const CustomEmptyWidget().paddingBottom(AppValues.defaultPadding).sliverToBoxAdapter()
            : gameList2();
      } else {
        return widget.state.dataArray.isEmpty ? emptyTips().sliverToBoxAdapter() : gameList2();
      }
    } else if (widget.controller.fromChangguanPage == 3) {
      return widget.controller.changguanDataArray.isEmpty
          ? const CustomEmptyWidget().paddingBottom(AppValues.defaultPadding).sliverToBoxAdapter()
          : changguanList();
    } else {
      return (widget.controller.fromChangguanPage == 2 && widget.controller.navModel.ty == 1 ||
                  widget.controller.fromChangguanPage == 21 &&
                      widget.controller.itemModel.ty == 1) ||
              widget.controller.fromChangguanPage == 5 && widget.controller.lobbbModel.ty == 1
          ? gameList1()
          : gameList2();
    }
  }

  Widget emptyTips() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: ThemeService().theme.textTheme.bodyMedium,
          children: [
            TextSpan(text: S.current.yulecheng_zanwushoucang),
            const WidgetSpan(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Icon(
                  Icons.star_border,
                  color: Colors.red,
                ),
              ),
            ),
            TextSpan(
              text: S.current.yulecheng_savegame_tofavorite,
            ),
          ],
        ),
      )
          .center()
          .paddingTop(AppValues.defaultPadding)
          .paddingHorizontal(AppValues.defaultPadding * 2),
    );
    // return Text(
    //   "暂无任何收藏,请使用收藏把游戏添加到收藏夹中",
    //   style: ThemeService().theme.textTheme.bodyMedium,
    // ).paddingTop(AppValues.defaultPadding * 3);
  }

  Widget gameList1() {
    return SliverPadding(
      padding: const EdgeInsets.all(AppValues.defaultPadding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns in the grid
          mainAxisSpacing: 5.0, // Spacing between rows
          crossAxisSpacing: 5.0, // Spacing between columns
          childAspectRatio: widget.controller.isZhenRen
              ? 112 / 151
              : 112 / 180, // Width to height ratio of grid items
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            //  /images/SG/%lang%/limbo.webp
            // gameType == "8" ? 特殊情况dev_替换
            String imgUrl = widget.state.ty1DataArray[index].img;
            if (widget.state.ty1DataArray[index].gameType == "8") {
              imgUrl = BranchService.instance.current.asset_url +
                  widget.state.ty1DataArray[index].img.replaceAll("%lang%/",
                      "${LangUtil().getLangType()}/${AppValues.defaultBranch.ws_prefix}_");
            } else {
              imgUrl = BranchService.instance.current.asset_url +
                  widget.state.ty1DataArray[index].img
                      .replaceAll("%lang%", LangUtil().getLangType());
            }

            return GestureDetector(
                onTap: () {
                  if (widget.state.ty1DataArray[index].maintained == "2") {
                    return;
                  }
                  widget.controller.goToTy1Detail(widget.state.ty1DataArray[index]);
                },
                child: <Widget>[
                  Stack(
                    children: <Widget>[
                      CustomNetWorkImage(
                          imageUrl: imgUrl,
                          placeholder: CustomNetWorkImage(
                            imageUrl: BranchService.instance.current.asset_url +
                                widget.state.ty1DataArray[index].img
                                    .replaceAll(".webp", ".s.webp")
                                    .replaceAll("%lang%", LangUtil().getLangType()),
                            errorWidget: const SizedBox(),
                          )),
                      if (widget.state.ty1DataArray[index].maintained == "2")
                        // 半透明蒙版
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppValues.smallPadding),
                            ),
                          ),
                          // 使用Color.fromRGBO来设置半透明颜色
                        ),
                      if (widget.state.ty1DataArray[index].maintained == "2")
                        // 上层内容
                        <Widget>[
                          // SvgPicture.asset("assets/svg/icon _yulecheng_maintanance.svg").center(),
                          Image.network(BranchService.instance.current.asset_url +
                                  "/images/common/%lang%/maintained.webp"
                                      .replaceAll("%lang%", LangUtil().getLangType()))
                              .center(),
                          // Text(
                          //   S.current.game_category_repair,
                          //   style: ThemeService().theme.textTheme.bodyMedium,
                          // )
                          //     .alignBottom()
                          //     .center()
                          //     .paddingHorizontal(AppValues.halfPadding)
                          //     .paddingTop(AppValues.defaultPadding),
                        ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
                    ],
                  ).expanded(),
                  if (widget.controller.isZhenRen == false)
                    <Widget>[
                      // Container(
                      //   decoration: const BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(4)),
                      //     color: AppThemes.chatRoomOnlineGreenColor,
                      //   ),
                      // ).tight(width: 8, height: 8).paddingLeft(3),
                      Image.asset(
                        "assets/svg/green_pot.webp",
                        width: 20,
                        height: 20,
                      ),
                      CustomText(
                          "${widget.state.ty1DataArray[index].playerAmount ?? ""}${S.current.random_text_578}",
                          style: TextStyle(fontSize: AppValues.fontBodySmallSize))
                    ].toRow().tight(height: 30).alignBottom()
                ].toColumn());
          },
          childCount: widget.state.ty1DataArray.length, // Total number of grid items
        ),
      ),
    );
  }

  Widget gameList2() {
    return SliverPadding(
      padding: const EdgeInsets.all(AppValues.defaultPadding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns in the grid
          mainAxisSpacing: 5.0, // Spacing between rows
          crossAxisSpacing: 5.0, // Spacing between columns
          childAspectRatio: widget.controller.isZhenRen
              ? 112 / 150
              : 112 / 180, // Width to height ratio of grid items
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  if (widget.state.dataArray[index].zkOnline == "2") {
                    return;
                  }
                  widget.controller.goToDetail(widget.state.dataArray[index]);
                },
                child: <Widget>[
                  Stack(
                    children: <Widget>[
                      CustomNetWorkImage(
                          imageUrl: BranchService.instance.current.asset_url +
                              widget.state.dataArray[index].gameImgUrl,
                          placeholder: CustomNetWorkImage(
                            imageUrl: BranchService.instance.current.asset_url +
                                widget.state.dataArray[index].img
                                    .replaceAll(".webp", ".s.webp")
                                    .replaceAll("%lang%", LangUtil().getLangType()),
                            errorWidget: const SizedBox(),
                          )),
                      if (widget.state.dataArray[index].zkOnline == "2")
                        // 半透明蒙版
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppValues.smallPadding),
                            ),
                          ),
                          // 使用Color.fromRGBO来设置半透明颜色
                        ).paddingHorizontal(AppValues.smallPadding),
                      if (widget.state.dataArray[index].zkOnline == "2")
                        // 上层内容
                        <Widget>[
                          // SvgPicture.asset("assets/svg/icon _yulecheng_maintanance.svg").center(),
                          Image.network(BranchService.instance.current.asset_url +
                                  "/images/common/%lang%/maintained.webp"
                                      .replaceAll("%lang%", LangUtil().getLangType()))
                              .center(),
                          // Text(
                          //   S.current.game_category_repair,
                          //   style: ThemeService().theme.textTheme.bodyMedium,
                          // )
                          //     .alignBottom()
                          //     .center()
                          //     .paddingHorizontal(AppValues.halfPadding)
                          //     .paddingTop(AppValues.defaultPadding),
                        ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
                    ],
                  ).expanded(),
                  if (widget.controller.isZhenRen == false)
                    <Widget>[
                      // Container(
                      //   decoration: const BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(4)),
                      //     color: AppThemes.chatRoomOnlineGreenColor,
                      //   ),
                      // ).tight(width: 8, height: 8).paddingLeft(3),
                      Image.asset(
                        "assets/svg/green_pot.webp",
                        width: 20,
                        height: 20,
                      ),
                      CustomText(
                          "${widget.state.dataArray[index].playerAmount ?? ""}${S.current.random_text_578}",
                          style: TextStyle(fontSize: AppValues.fontBodySmallSize))
                    ].toRow().tight(height: 30).alignBottom()
                ].toColumn());
          },
          childCount: widget.state.dataArray.length, // Total number of grid items
        ),
      ),
    );
  }

  Widget changguanList() {
    return SliverPadding(
      padding: const EdgeInsets.all(AppValues.defaultPadding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns in the grid
          mainAxisSpacing: 10.0, // Spacing between rows
          crossAxisSpacing: 10.0, // Spacing between columns
          childAspectRatio: (Get.width - 8 * 4) / 3.0 / 44.0, // Width to height ratio of grid items
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                widget.controller.changeToPlatGameList(widget.controller.changguanDataArray[index]);
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ThemeService().colorScheme.surface,
                          offset: const Offset(0.0, 4.0),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppValues.halfPadding),
                      child: CustomNetWorkImage(
                        imageUrl: BranchService.instance.current.asset_url +
                            widget.controller.changguanDataArray[index].icon
                                .replaceAll("%lang%", LangUtil().getLangType()),
                      ),
                    ).paddingHorizontal(AppValues.smallPadding),
                  ),
                  if (widget.controller.changguanDataArray[index].maintained == "2")
                    // 半透明蒙版
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppValues.smallPadding),
                        ),
                      ),
                      // 使用Color.fromRGBO来设置半透明颜色
                    ).paddingHorizontal(AppValues.smallPadding),
                  if (widget.controller.changguanDataArray[index].maintained == "2")
                    // 上层内容
                    <Widget>[
                      SvgPicture.asset(
                        "assets/svg/icon _yulecheng_maintanance.svg",
                        width: 16,
                        height: 16,
                      ).paddingBottom(AppValues.halfPadding).center(),
                      // Text(
                      //   S.current.game_category_repair,
                      //   style: ThemeService().theme.textTheme.bodyMedium,
                      // )
                      //     .alignBottom()
                      //     .center()
                      //     .paddingHorizontal(AppValues.halfPadding)
                      //     .paddingTop(AppValues.defaultPadding),
                    ].toStack()
                ],
              ),
            );
          },
          childCount: widget.controller.changguanDataArray.length, // Total number of grid items
        ),
      ),
    );
  }

  Widget changePage() {
    return <Widget>[
      CustomIconButton(
        name: S.current.yulecheng_prepage,
        style: ThemeService().textTheme.bodyMedium!.copyWith(
            color: widget.controller.state.showLoadMore == true
                ? AppThemes.ylclightGreyColor
                : AppThemes.textColorSecondary),
        onTap: () {},
        // iconWidget: SvgPicture.asset(
        //   'assets/svg/ic_left_arrow.svg',
        // ),
        // direction: Direction.left,
        // iconHeight: AppValues.iconSize_14,
        // iconWidth: AppValues.iconSize_14,
      ),
      CustomIconButton(
        name: S.current.yulecheng_nextpage,
        style: ThemeService().textTheme.bodyMedium!.copyWith(
            color: widget.controller.state.showLoadMore == true
                ? AppThemes.ylclightGreyColor
                : AppThemes.textColorSecondary),
        onTap: () {},
        // iconWidget: SvgPicture.asset(
        //   'assets/svg/ic_right_arrow.svg',
        // ),
        // direction: Direction.right,
        // iconHeight: AppValues.iconSize_14,
        // iconWidth: AppValues.iconSize_14,
      ),
    ].toRow(mainAxisAlignment: MainAxisAlignment.center);
  }

  /// 底部加载更多
  Widget bottomloadMore() {
    double rate = 0.0;
    if (widget.state.totalGame > 0) {
      rate =
          (widget.state.ty1DataArray.length.toDouble() + widget.state.dataArray.length.toDouble())
                  .toDouble() /
              widget.state.totalGame.toDouble();
    }

    return <Widget>[
      <Widget>[
        Container(
          width: 180,
          height: 2,
          color: ThemeService().theme.colorScheme.tertiary,
        ),
        Container(
          width: 180.0 * rate,
          height: 2,
          color: rate == 1
              ? ThemeService().colorScheme.primaryContainer
              : ThemeService().theme.colorScheme.secondaryContainer,
        ),
      ].toStack(),
      Text(
        widget.controller.getTotalGameText(widget.state.totalGame,
            widget.state.ty1DataArray.length + widget.state.dataArray.length),
        // "正显示${widget.state.totalGame} 款游戏中的 ${widget.state.ty1DataArray.length + widget.state.dataArray.length} 个",
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(AppValues.defaultPadding),
      if (widget.state.totalGame > widget.state.ty1DataArray.length + widget.state.dataArray.length)
        CustomSmallMainButton(
          onTap: widget.controller.loadMoreData,
          title: S.current.sport_add_more,
          backgroundColor: ThemeService().theme.colorScheme.tertiary,
        ).paddingTop(AppValues.defaultPadding).tight(height: 50, width: 180),
    ].toColumn();
  }

  Widget buildLoading() {
    return SizedBox(
        height: 100,
        child: CustomNetWorkImagePlaceholder(
          color: AppThemes.surfaceVariant.withOpacity(0),
          placeholderType: NetWorkImagePlaceholderType.loading,
          // borderRadius: borderRadius,
          // border: border,
        )).sliverToBoxAdapter();
  }

  Widget buildBottomChangguan() {
    return widget.controller.changguanDataArray.isNotEmpty
        ? CasinoChangguanFlipList(
            onTap: widget.controller.changeToPlatGameList,
            items: widget.controller.changguanDataArray,
            title: S.current.game_supplier,
            icon: 'assets/images/home/ic_game_provider.webp',
          )
        : const SizedBox();
  }
}
